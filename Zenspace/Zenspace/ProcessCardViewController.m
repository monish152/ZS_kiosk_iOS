//
//  ViewController.m
//  Zenspace
//
//  Created by Monish on 15/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "ProcessCardViewController.h"
#import "NSObject+TLVParser.h"
#import <MediaPlayer/MediaPlayer.h>

#define SHOW_DEBUG_COUNT 0
typedef void (^cmdCompBlock)(NSString*);
@interface ProcessCardViewController ()
{
    int swipeCount;
    NSString* commandResult;
    cmdCompBlock cmdCompletion;
    
}
typedef void(^commandCompletion)(NSString*);
@property (nonatomic, strong) commandCompletion queueCompletion;


@end

@implementation ProcessCardViewController

- (void)viewDidLoad {
    
    cardView.layer.cornerRadius = 20;
    swipeCardLbl.font = [UIFont fontWithName:@"CircularStd-Medium"
                                        size:28];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self connectMethod];
    
}
- (void)connectMethod
{
    self.lib = [MTSCRA new];
    
    [self.lib setDeviceType:MAGTEKKDYNAMO];
    [self.lib setDeviceProtocolString:@"com.magtek.idynamo"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    self.lib.delegate = self;
    if(!self.lib.isDeviceOpened )
    {
        [self setText: @"Connecting..."];
        [self.lib openDevice];
    }
    
    else
    {
        [self setText:@"Close Device"];
        [self.lib closeDevice];
    }
    
    
#if SHOW_DEBUG_COUNT
    swipeCount = 0;
#endif
}
- (void) turnMSROn
{
    Byte rs[3];
    NSData* rsData = [HexUtil getBytesFromHexString: [self sendCommandSync:@"5800"]];
    [rsData getBytes:rs length:rsData.length];
    if(rs[2] == 0x00)
    {
        [self sendCommandSync:@"580101"];
    }
    else if( rs[2] == 0x01)
    {
        [self sendCommandSync:@"580100"];
        
    }
    
}
- (void)setSleepmode
{
    [self sendCommandSync:@"590100"];
}
- (void)startEMV
{
    
    if(self.lib.isDeviceOpened && self.lib.isDeviceConnected)
    {
        NSString *txtAmount =  _transactionAmount;
        if(txtAmount.length == 0)
            txtAmount = @"0";
        if(txtAmount.length > 0)
        {
            // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData* dataAmount = [HexUtil dataFromHexString:txtAmount];
            
            
            memcpy(tempAmount, [dataAmount bytes],6);
            
            for (int i = 5; i >= 0; i--) {
                amount[i] = tempAmount[5 - i];
            }
            memcpy(tempAmount, amount,6);
            Byte timeLimit = 0x3C;
            Byte cardType = 0x01;
            
            
            Byte option = 0x00;
            
            Byte transactionType = 0x00;
            
            cashBack[0] = 0x00;
            cashBack[1] = 0x00;
            cashBack[2] = 0x00;
            cashBack[3] = 0x00;
            cashBack[4] = 0x00;
            cashBack[5] = 0x00;
            
            
            currencyCode[0] =  0x08;
            currencyCode[1] = 0x40;
            Byte reportingOption =   0x02;
            
            
            [self getARQCFormat:^(NSString *format) {
                
                if([[format substringToIndex:1] isEqualToString:@"02"])
                {
                    self->arqcFormat = 0x00;
                }
                else
                {
                    if([HexUtil getBytesFromHexString:format].length > 2)
                    {
                        NSData * data = [[HexUtil getBytesFromHexString:format]subdataWithRange:NSMakeRange(2, 1)];
                        [data getBytes:&self->arqcFormat length:1];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.lib startTransaction:timeLimit cardType:cardType option:option amount:self->amount transactionType:transactionType cashBack:self->cashBack currencyCode:self->currencyCode reportingOption:reportingOption];
                    
                });
            }];
        }
        
        
    }
}
-(void)appWillResignActive:(NSNotification*)note
{
    [self.lib closeDevice];
}
-(void)appDidBecomeActive:(NSNotification*)note
{
    [self.lib openDevice];
}


-(void)apiConnect:(NSString *)tlvData{
    
    NSString *amountStr = _transactionAmount;
//    NSString *amountStr = @"25";
    NSString *custCode = @"QC16736815";
    NSString *userName = @"MAG190709002";
    NSString *password = @"Md!kgW#V@zBu5A";
    NSString *soapMessage;
    NSString *processorName = @"Rapid Connect v3 - Pilot";
    NSString *transactionIdStr = @"1231232";
    
//    encryptionType = @"80";
    
    
    //production
    //    NSString *custCode = @"QF20436257";
    //    NSString *userName = @"MAG190911002";
    //    NSString *password = @"ryQbhRu!e@6#Z3";
    //    NSString *processorName = @"Rapid Connect v3 - Production";
    
   
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://mppg.magensa.net/v3/MPPGv3Service.svc"]];
    [request setValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"mppg.magensa.net" forHTTPHeaderField:@"Host"];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"Apache-HttpClient/4.1.1" forHTTPHeaderField:@"User-Agent"];
    
    
    ///EMV Sale Request
    
    
    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mpp=\"http://www.magensa.net/MPPGv3/\" xmlns:mpp1=\"http://schemas.datacontract.org/2004/07/MPPGv3WS.Core\" xmlns:sys=\"http://schemas.datacontract.org/2004/07/System.Collections.Generic\">\n"
    "<soapenv:Header/>\n"
    "<soapenv:Body>\n"
    "<mpp:ProcessEMVSRED>\n"
    "<mpp:ProcessEMVSREDRequests>\n"
    "<mpp1:ProcessEMVSREDRequest>\n"
    "<mpp1:AdditionalRequestData>\n"
    "<sys:KeyValuePairOfstringstring>\n"
    "<sys:key/>\n"
    "<sys:value/>\n"
    "</sys:KeyValuePairOfstringstring>\n"
    "<sys:KeyValuePairOfstringstring>\n"
    "<sys:key/>\n"
    "<sys:value/>\n"
    "</sys:KeyValuePairOfstringstring>\n"
    "</mpp1:AdditionalRequestData>\n"
    "<mpp1:Authentication>\n"
    "<mpp1:CustomerCode>%@</mpp1:CustomerCode>\n"
    "<mpp1:Password>%@</mpp1:Password>\n"
    "<mpp1:Username>%@</mpp1:Username>\n"
    "</mpp1:Authentication>\n"
    "<mpp1:CustomerTransactionID>%@</mpp1:CustomerTransactionID>\n"
    "<mpp1:EMVSREDInput>\n"
    "<mpp1:EMVSREDData>%@</mpp1:EMVSREDData>\n"
    "<mpp1:EncryptionType>%@</mpp1:EncryptionType>\n"
    "<mpp1:KSN>%@</mpp1:KSN>\n"
    "<mpp1:NumberOfPaddedBytes>%@</mpp1:NumberOfPaddedBytes>\n"
    "<mpp1:PaymentMode>EMV</mpp1:PaymentMode>\n"
    "</mpp1:EMVSREDInput>\n"
    "<mpp1:TransactionInput>\n"
    "<mpp1:Amount>%@</mpp1:Amount>\n"
    "<mpp1:ProcessorName>%@</mpp1:ProcessorName>\n"
    "<mpp1:TransactionInputDetails>\n"
    "<sys:KeyValuePairOfstringstring>\n"
    "<sys:key>PartAuthrztnApprvlCapablt</sys:key>\n"
    "<sys:value>0</sys:value>\n"
    "</sys:KeyValuePairOfstringstring>\n"
    "</mpp1:TransactionInputDetails>\n"
    "<mpp1:TransactionType>SALE</mpp1:TransactionType>\n"
    "</mpp1:TransactionInput>\n"
    "</mpp1:ProcessEMVSREDRequest>\n"
    "</mpp:ProcessEMVSREDRequests>\n"
    "</mpp:ProcessEMVSRED>\n"
    "</soapenv:Body>\n"
                   "</soapenv:Envelope>\n",custCode,password,userName,transactionIdStr,tlvData,encryptionType,ksnStr,paddedBytes,amountStr,processorName];
    
    
    
//    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//                   "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mpp=\"http://www.magensa.net/MPPGv3/\" xmlns:mpp1=\"http://schemas.datacontract.org/2004/07/MPPGv3WS.Core\" xmlns:sys=\"http://schemas.datacontract.org/2004/07/System.Collections.Generic\">\n"
//                   "<soapenv:Header/>\n"
//                   "<soapenv:Body>\n"
//                   "<mpp:ProcessEMVSRED>\n"
//                   "<!--Optional:-->\n"
//                   "<mpp:ProcessEMVSREDRequests>\n"
//                   "<mpp1:ProcessEMVSREDRequest>\n"
//                   "<!--Optional:-->\n"
//                   "<mpp1:AdditionalRequestData>\n"
//                   "<sys:KeyValuePairOfstringstring>\n"
//                   "<sys:key></sys:key>\n"
//                   "<sys:value></sys:value>\n"
//                   "</sys:KeyValuePairOfstringstring>\n"
//                   "</mpp1:AdditionalRequestData>\n"
//                   "<mpp1:Authentication>\n"
//                   "<mpp1:CustomerCode>%@</mpp1:CustomerCode>\n"
//                   "<mpp1:Password>%@</mpp1:Password>\n"
//                   "<mpp1:Username>%@</mpp1:Username>\n"
//                   "</mpp1:Authentication>\n"
//                   "<!--Optional:-->\n"
//                   "<mpp1:CustomerTransactionID>000</mpp1:CustomerTransactionID>\n"
//                   "<mpp1:EMVSREDInput>\n"
//                   "<mpp1:EMVSREDData>%@</mpp1:EMVSREDData>\n"
//                   "<mpp1:EncryptionType>%@</mpp1:EncryptionType>\n"
//                   "<mpp1:KSN>%@</mpp1:KSN>\n"
//                   "<mpp1:NumberOfPaddedBytes>%@</mpp1:NumberOfPaddedBytes>\n"
//                   "<mpp1:PaymentMode>EMV</mpp1:PaymentMode>\n"
//                   "</mpp1:EMVSREDInput>\n"
//                   "<mpp1:TransactionInput>\n"
//                   "<mpp1:ProcessorName>Token</mpp1:ProcessorName>\n"
//                   "<mpp1:TransactionInputDetails>\n"
//                   "<sys:KeyValuePairOfstringstring>\n"
//                   "<sys:key></sys:key>\n"
//                   "<sys:value></sys:value>\n"
//                   "</sys:KeyValuePairOfstringstring>\n"
//                   "</mpp1:TransactionInputDetails>\n"
//                   "<mpp1:TransactionType>TOKEN</mpp1:TransactionType>\n"
//                   "</mpp1:TransactionInput>\n"
//                   "</mpp1:ProcessEMVSREDRequest>\n"
//                   "<mpp1:ProcessEMVSREDRequest>\n"
//                   "<mpp1:AdditionalRequestData>\n"
//                   "<sys:KeyValuePairOfstringstring>\n"
//                   "<sys:key>NonremovableTags</sys:key>\n"
//                   "<sys:value Encoding=\"cdata\"><![CDATA[<NonremovableTags><Tag>CCTrack2</Tag></NonremovableTags>]]></sys:value>\n"
//                   "</sys:KeyValuePairOfstringstring>\n"
//                   "</mpp1:AdditionalRequestData>\n"
//                   "<mpp1:Authentication>\n"
//                   "<mpp1:CustomerCode>%@</mpp1:CustomerCode>\n"
//                   "<mpp1:Password>%@</mpp1:Password>\n"
//                   "<mpp1:Username>%@</mpp1:Username>\n"
//                   "</mpp1:Authentication>\n"
//                   "<mpp1:CustomerTransactionID>000</mpp1:CustomerTransactionID>\n"
//                   "<mpp1:EMVSREDInput>\n"
//                   "<mpp1:EMVSREDData>%@</mpp1:EMVSREDData>\n"
//                   "<mpp1:EncryptionType>%@</mpp1:EncryptionType>\n"
//                   "<mpp1:KSN>%@</mpp1:KSN>\n"
//                   "<mpp1:NumberOfPaddedBytes>%@</mpp1:NumberOfPaddedBytes>\n"
//                   "<mpp1:PaymentMode>EMV</mpp1:PaymentMode>\n"
//                   "</mpp1:EMVSREDInput>\n"
//                   "<mpp1:TransactionInput>\n"
//                   "<mpp1:Amount>%@</mpp1:Amount>\n"
//                   "<mpp1:ProcessorName>%@</mpp1:ProcessorName>\n"
//                   "<mpp1:TransactionInputDetails>\n"
//                   "<sys:KeyValuePairOfstringstring>\n"
//                   "<sys:key></sys:key>\n"
//                   "<sys:value></sys:value>\n"
//                   "</sys:KeyValuePairOfstringstring>\n"
//                   "</mpp1:TransactionInputDetails>\n"
//                   "<mpp1:TransactionType>SALE</mpp1:TransactionType>\n"
//                   "</mpp1:TransactionInput>\n"
//                   "</mpp1:ProcessEMVSREDRequest>\n"
//                   "</mpp:ProcessEMVSREDRequests>\n"
//                   "</mpp:ProcessEMVSRED>\n"
//                   "</soapenv:Body>\n"
//                   "</soapenv:Envelope>\n",custCode,password,userName,string,encryptionType,ksnStr,paddedBytes,processorName,custCode,password,userName,string,encryptionType,ksnStr,paddedBytes,amountStr,processorName];
    
    [request setValue:@"http://www.magensa.net/MPPGv3/IMPPGv3Service/ProcessEMVSRED" forHTTPHeaderField:@"SOAPAction"];
    
    
    NSLog(@"Soap Request : %@",soapMessage);
    
    
    ///Card Swipe
    /*
     soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
     "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mpp=\"http://www.magensa.net/MPPGv3/\" xmlns:mpp1=\"http://schemas.datacontract.org/2004/07/MPPGv3WS.Core\" xmlns:sys=\"http://schemas.datacontract.org/2004/07/System.Collections.Generic\">\n"
     "<soapenv:Header/>\n"
     "<soapenv:Body>\n"
     "<mpp:ProcessCardSwipe>\n"
     "<mpp:ProcessCardSwipeRequests>\n"
     "<!--Zero or more repetitions:-->\n"
     "<mpp1:ProcessCardSwipeRequest>\n"
     "<mpp1:AdditionalRequestData>\n"
     "<sys:KeyValuePairOfstringstring>\n"
     "<sys:key></sys:key>\n"
     "<sys:value></sys:value>\n"
     "</sys:KeyValuePairOfstringstring>\n"
     "</mpp1:AdditionalRequestData>\n"
     "<mpp1:Authentication>\n"
     "<mpp1:CustomerCode>%@</mpp1:CustomerCode>\n"
     "<mpp1:Password>%@</mpp1:Password>\n"
     "<mpp1:Username>%@</mpp1:Username>\n"
     "</mpp1:Authentication>\n"
     "<mpp1:CardSwipeInput>\n"
     "<mpp1:EncryptedCardSwipe>\n"
     "<mpp1:DeviceSN>B39B81F031417AA</mpp1:DeviceSN>\n"
     "<mpp1:KSN>9011880B39B81F000001</mpp1:KSN>\n"
     "<mpp1:MagnePrint>B23E26494E64EBC00E39AA1E33BF7B4ADEBB8F6463D76325B92003BCDAEA98979A442040B2E1AC8D8CC79C4BE11B7AD89B1E95D01F4EB2C4E2D30621CA926EEC202773B618FBF07F1CC5DFCD16DCA8041A22054EC27EA2057C572662AB32BBDE9ABD92694E0C5D9BCE9B3351AF57D14D79CDF8E45F640B8D</mpp1:MagnePrint>\n"
     "<mpp1:MagnePrintStatus>304061</mpp1:MagnePrintStatus>\n"
     "<mpp1:Track1>B23E26494E64EBC00E39AA1E33BF7B4ADEBB8F6463D76325B92003BCDAEA98979A442040B2E1AC8D8CC79C4BE11B7AD89B1E95D01F4EB2C4E2D30621CA926EEC202773B618FBF07F1CC5DFCD16DCA804</mpp1:Track1>\n"
     "<mpp1:Track2>1A22054EC27EA2057C572662AB32BBDE9ABD92694E0C5D9BCE9B3351AF57D14D79CDF8E45F640B8D</mpp1:Track2>\n"
     "<mpp1:Track3></mpp1:Track3>\n"
     "</mpp1:EncryptedCardSwipe>\n"
     "</mpp1:CardSwipeInput>\n"
     "<mpp1:CustomerTransactionID>GlobalPay</mpp1:CustomerTransactionID>\n"
     "<mpp1:TransactionInput>\n"
     "<mpp1:Amount>%@</mpp1:Amount>\n"
     "<mpp1:ProcessorName>Rapid Connect v3 - Pilot</mpp1:ProcessorName>\n"
     "<mpp1:TransactionInputDetails>\n"
     "<!--Zero or more repetitions:-->\n"
     "<sys:KeyValuePairOfstringstring>\n"
     "<sys:key></sys:key>\n"
     "<sys:value></sys:value>\n"
     "</sys:KeyValuePairOfstringstring>\n"
     "</mpp1:TransactionInputDetails>\n"
     "<mpp1:TransactionType>SALE</mpp1:TransactionType>\n"
     "</mpp1:TransactionInput>\n"
     "</mpp1:ProcessCardSwipeRequest>\n"
     "</mpp:ProcessCardSwipeRequests>\n"
     "</mpp:ProcessCardSwipe>\n"
     "</soapenv:Body>\n"
     "</soapenv:Envelope>\n",custCode,password,userName,amountStr];
     
     
     [request setValue:@"http://www.magensa.net/MPPGv3/IMPPGv3Service/ProcessCardSwipe" forHTTPHeaderField:@"SOAPAction"];
     
     */
    
    
    
    
    
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFHTTPSessionManager *sManager = [[AFHTTPSessionManager alloc] init];
    sManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [sManager dataTaskWithRequest:(NSURLRequest *)request
                                                 completionHandler:^( NSURLResponse *response, id responseObject, NSError *error){
                                                     NSString *resString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                     NSLog(@"MPPGResult: %@", resString);
                                                     NSData *myData = [resString dataUsingEncoding:NSUTF8StringEncoding];
                                                     
                                                     NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
                                                     
                                                     // Don't forget to set the delegate!
                                                     xmlParser.delegate = self;
                                                     
                                                     // Run the parser
                                                     BOOL parsingResult = [xmlParser parse];
                                                     //NSLog(@"Resp: %@", [response ]);
                                                     NSLog(@"Err: %@", error);
                                                 }];
    [dataTask resume];
}

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    currentElement = elementName;
    
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([currentElement isEqualToString:@"a:FaultReason"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:string
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([currentElement isEqualToString:@"a:AuthorizedAmount"]) {
        txtData.text = [txtData.text stringByAppendingString:[NSString stringWithFormat:@"\n\nAmount : %@",string]];
       
    }
    if ([currentElement isEqualToString:@"a:TransactionID"]) {
        txtData.text = [txtData.text stringByAppendingString:[NSString stringWithFormat:@"\n\nTrasaction Id : %@",string]];
         [self bookingApi:string];
        
        
   
        
    }
    if ([currentElement isEqualToString:@"a:TransactionUTCTimestamp"]) {
        txtData.text = [txtData.text stringByAppendingString:[NSString stringWithFormat:@"\n\nTime : %@",string]];
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    
}



-(void) onDeviceConnectionDidChange:(MTSCRADeviceType)deviceType connected:(BOOL)connected instance:(id)instance
{
    if(deviceType == MAGTEKKDYNAMO)
    {
        if(connected)
        {
                        CGFloat delay = 0.1;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                            [self.lib sendcommandWithLength:@"480102"];
            
                        }
                            );
            
            
            
        }
        else
        {
            
        }
        
    }
    
    if([(MTSCRA*)instance isDeviceOpened] && [self.lib isDeviceConnected])
    {
        if(connected)
        {
            int delay = 1.0;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                if([self.lib isDeviceConnected] && [self.lib isDeviceOpened])
                {
                    
                    dispatch_async(queue, ^{
                        
                        
                        [self setText:@"Device Connected..."];
                        
                        //                        [self setText:@"Getting FW ID..."];
                        //                        NSString* fw ;
                        //                        fw = [self sendCommandSync:@"000100"];
                        //                        [self setText:[NSString stringWithFormat:@"[Firmware ID]\r%@",fw]];
                        //
                        //                        [self setText:@"Getting SN..."];
                        //                        NSString* sn;
                        //                        sn = [self sendCommandSync:@"000103"];
                        //                        [self setText:[NSString stringWithFormat:@"[Device SN]\r%@",sn]];
                        //
                        //                        [self setText:@"Getting Security Level..."];
                        //                        NSString* sl;
                        //                        sl = [self sendCommandSync:@"1500"];
                        //
                        //                        NSString *timeSleep;
                        //                         sl = [self sendCommandSync:@"1500"];
                        
                        //                        [self setText:[NSString stringWithFormat:@"[Security Level]\r%@",sl]];
                        
                        //                        NSString* ksn;
                        //                        ksn = [self.lib getKSN];
                        //                         [self setText:[NSString stringWithFormat:@"[KSN]\r%@",ksn]];
                        
                        //                        NSString *serialNumber = [self.lib getDeviceSerial];
                        //                        [self setText:[NSString stringWithFormat:@"[Serial]\r%@",serialNumber]];
                        
                        [self sendCommandSync:@"580101"];
                        [self sendCommandSync:@"59020F20"];
                        

                        
                        if(deviceType == MAGTEKTDYNAMO || deviceType == MAGTEKKDYNAMO)
                        {
                            
                            [self setText:@"Setting Date Time..."];
                            int delay = 1.0;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                                [self setDateTime];
                                
                            }
                                           );
                           
                        }
                        
                        
                        [self startEMV];
                        
                    });
                    
                };
                
            });
        }
        else
        {
            devicePaired = YES;
            [self setText:@"Disconnected"];
            
        }
    }
    else
    {
        devicePaired = YES;
        [self setText:@"Disconnected"];
        
        if(deviceType == MAGTEKTDYNAMO)
        {
            self.navigationItem.leftBarButtonItem = nil;
        }
        
    }
#if SHOW_DEBUG_COUNT
    txtData.text = @"";
    txtData.text = [txtData.text stringByAppendingString: [NSString stringWithFormat:@" Swipe.Count:%i", swipeCount]];
#endif
    
    
}



- (NSString*)sendCommandSync:(NSString*)command
{
    __block NSString* deviceRs = @"";
    int counter = 0;
    
    [self sendCommandWithCallBack:command completion:^(NSString *data) {
        deviceRs = data;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.2];
    while (deviceRs.length == 0 && [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:loopUntil] && counter <= 20)
    {
        
        counter++;
        loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.2];
        
    }
    return deviceRs;
}

- (void)sendCommandWithCallBack:(NSString*)command completion:(void (^)(NSString*))completion
{
    
    if(completion)
    {
        cmdCompletion = completion;
    }
    [self.lib sendcommandWithLength:command];
}

- (void) setText:(NSString*)text
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        txtData.text = [NSString stringWithFormat:@"%@ %@", txtData.text, text];
        //        [self scrollTextViewToBottom:txtData];
    });
}

- (void)getSerialNumber
{
    txtData.text = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        txtData.text = [NSString stringWithFormat:@"%@ Device Serial Number: %@ ", txtData.text, [self.lib getDeviceSerial]];// @"Connected...";
        [self setText: [NSString stringWithFormat:@"Device Serial Number: %@ ",[self.lib getDeviceSerial]]];
        
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}





- (void) cardSwipeDidStart:(id)instance
{
    [self setText:@"Card Swipe Started"];// @"Connected...";
    
}
- (void) cardSwipeDidGetTransError
{
    [self setText:@"Transfer error..."];
}



- (void)setDateTime
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:date] - 2008;
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:date];
    NSInteger minute = [calendar component:NSCalendarUnitMinute fromDate:date];
    NSInteger second = [calendar component:NSCalendarUnitSecond fromDate:date];
    
    NSString* cmd = @"030C";
    NSString* size = @"0018";
    NSString* deviceSn = @"00000000000000000000000000000000";
    NSString* strMonth = [NSString stringWithFormat:@"%02lX", (long)month];
    NSString* strDay = [NSString stringWithFormat:@"%02lX", (long)day];
    NSString* strHour = [NSString stringWithFormat:@"%02lX", (long)hour];
    NSString* strMinute = [NSString stringWithFormat:@"%02lX", (long)minute];
    NSString* strSecond = [NSString stringWithFormat:@"%02lX", (long)second];
    // NSString* placeHol = [NSString stringWithFormat:@"%02lX", (long)second];
    NSString* strYear = [NSString stringWithFormat:@"%02lX", (long)year];
    NSString* commandToSend = [NSString stringWithFormat:@"%@%@00%@%@%@%@%@%@00%@", cmd, size, deviceSn, strMonth, strDay, strHour, strMinute, strSecond, strYear];
    [self.lib sendExtendedCommand:commandToSend];
}

- (void)deviceNotPaired
{
    devicePaired = NO;
}
- (void)onDeviceError:(NSError *)error

{
    [self setText:error.localizedDescription];
    
}


-(void)onDataReceived:(MTCardData *)cardDataObj instance:(id)instance
{
    
    
    [self setText:  [NSString stringWithFormat:      @"Track.Status: %@\n\n"
                     "Track1.Status: %@\n\n"
                     "Track2.Status: %@\n\n"
                     "Track3.Status: %@\n\n"
                     "Encryption.Status: %@\n\n"
                     "Battery.Level: %ld\n\n"
                     "Swipe.Count: %ld\n\n"
                     "Track.Masked: %@\n\n"
                     "Track1.Masked: %@\n\n"
                     "Track2.Masked: %@\n\n"
                     "Track3.Masked: %@\n\n"
                     "Track1.Encrypted: %@\n\n"
                     "Track2.Encrypted: %@\n\n"
                     "Track3.Encrypted: %@\n\n"
                     "Card.PAN: %@\n\n"
                     "MagnePrint.Encrypted: %@\n\n"
                     "MagnePrint.Length: %i\n\n"
                     "MagnePrint.Status: %@\n\n"
                     "SessionID: %@\n\n"
                     "Card.IIN: %@\n\n"
                     "Card.Name: %@\n\n"
                     "Card.Last4: %@\n\n"
                     "Card.ExpDate: %@\n\n"
                     "Card.ExpDateMonth: %@\n\n"
                     "Card.ExpDateYear: %@\n\n"
                     "Card.SvcCode: %@\n\n"
                     "Card.PANLength: %ld\n\n"
                     "KSN: %@\n\n"
                     "Device.SerialNumber: %@\n\n"
                     "MagTek SN: %@\n\n"
                     "Firmware Part Number: %@\n\n"
                     "Device Model Name: %@\n\n"
                     "TLV Payload: %@\n\n"
                     "DeviceCapMSR: %@\n\n"
                     "Operation.Status: %@\n\n"
                     "Card.Status: %@\n\n"
                     "Raw Data: \n\n%@",
                     cardDataObj.trackDecodeStatus,
                     cardDataObj.track1DecodeStatus,
                     cardDataObj.track2DecodeStatus,
                     cardDataObj.track3DecodeStatus,
                     cardDataObj.encryptionStatus,
                     cardDataObj.batteryLevel,
                     cardDataObj.swipeCount,
                     cardDataObj.maskedTracks,
                     cardDataObj.maskedTrack1,
                     cardDataObj.maskedTrack2,
                     cardDataObj.maskedTrack3,
                     cardDataObj.encryptedTrack1,
                     cardDataObj.encryptedTrack2,
                     cardDataObj.encryptedTrack3,
                     cardDataObj.cardPAN,
                     cardDataObj.encryptedMagneprint,
                     cardDataObj.magnePrintLength,
                     cardDataObj.magneprintStatus,
                     cardDataObj.encrypedSessionID,
                     cardDataObj.cardIIN,
                     cardDataObj.cardName,
                     cardDataObj.cardLast4,
                     cardDataObj.cardExpDate,
                     cardDataObj.cardExpDateMonth,
                     cardDataObj.cardExpDateYear,
                     cardDataObj.cardServiceCode,
                     cardDataObj.cardPANLength,
                     cardDataObj.deviceKSN,
                     cardDataObj.deviceSerialNumber,
                     cardDataObj.deviceSerialNumberMagTek,
                     cardDataObj.firmware,
                     cardDataObj.deviceName,
                     [(MTSCRA*)instance getTLVPayload],
                     cardDataObj.deviceCaps,
                     [(MTSCRA*)instance getOperationStatus],
                     cardDataObj.cardStatus,
                     [(MTSCRA*)instance getResponseData]]];
    
    
    
    
}
- (void)scrollTextViewToBottom:(UITextView *)textView {
    NSRange range = NSMakeRange(textView.text.length, 0);
    [textView scrollRangeToVisible:range];
    
    [textView setScrollEnabled:NO];
    [textView setScrollEnabled:YES];
}


- (NSString *)getHexString:(NSData *)data
{
    
    
    NSMutableString *mutableStringTemp = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < data.length; i++)
    {
        unsigned char tempByte;
        
        [data getBytes:&tempByte
                 range:NSMakeRange(i, 1)];
        
        [mutableStringTemp appendFormat:@"%02X", tempByte];
    }
    
    return mutableStringTemp;
}


-(void)onDeviceResponses:(NSData *)data
{
    
    if(cmdCompletion)
    {
        
        NSString* dataStr = [HexUtil toHex:data offset:0 len:data.length];
        cmdCompletion( dataStr);
        cmdCompletion = nil;
        return;
        
    }
    
    
    NSString* dataString = [self getHexString:data];
    NSLog(@"onDeviceResponses %@", dataString);
    
    commandResult = dataString;
    [self setText:[NSString stringWithFormat:@"\n[Device Response] %@", dataString]];
    
    
    
}


//Edynamo
-(void)getTerminalConfiguration:(NSData*)commandIn
{
    NSString* command = @"0306";
    NSString* length = @"0003";
    NSString* slotNumber = @"01";
    NSString* operation = @"0F";
    NSString* databaseSelector = @"00";
    
    
    [self.lib sendExtendedCommand:[NSString stringWithFormat:@"%@%@%@%@%@", command, length, slotNumber, operation, databaseSelector]];
}
-(void)commitConfiguration
{
    NSString* command = @"030E"; // Commit Configuration Command
    
    NSString* databaseSelector = @"00"; // Contact L2 EMV
    NSString* length = @"0001";
    
    [self.lib sendExtendedCommand:[NSString stringWithFormat:@"%@%@%@", command, length, databaseSelector]];
}

- (void)setTerminalConfiguration:(NSData*)commandIn
{
    NSString* command = @"0305";
    NSString* serialNumber = [self.lib getDeviceSerial];//@"42324645304542303932393135414100"; //CHANGE TO REAL DEVICE SERIAL NUMBER
    NSString* macType = @"00";
    NSString* slotNumber = @"01";
    NSString* operation =  @"01";
    NSString* databaseSelector =  @"00";
    NSString* objectsToWrite = @"FA00";
    NSString* MAC = @"00000000";//PASS IN VALID MAC
    NSString* length = @"001A"; //two byte length
    [self.lib sendExtendedCommand:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", command, length, macType, slotNumber, operation, databaseSelector, serialNumber, objectsToWrite, MAC]];
    
}

- (void)didSelectConfigCommand:(NSData *)command
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if(memcmp([ [command subdataWithRange:NSMakeRange(1, 1)] bytes],"\x05",1) == 0)
    {
        [self setTerminalConfiguration:command];
    }
    else  if(memcmp([ [command subdataWithRange:NSMakeRange(1, 1)] bytes],"\x06",1) == 0)
    {
        [self getTerminalConfiguration:command];
    }
    else  if(memcmp([ [command subdataWithRange:NSMakeRange(1, 1)] bytes],"\x0e",1) == 0)
    {
        [self commitConfiguration];
    }
    
}

-(void)resetDevice
{
    [self.lib sendcommandWithLength:@"020100"];
}

- (void) cancelEMV
{
    [self.lib cancelTransaction];
    
}

- (int)getARQCFormat: (commandCompletion)completion
{
    
    int rs = [self.lib sendcommandWithLength:@"000168"];
    if(rs == 0)
    {
        self.queueCompletion = completion;
    }
    //0 - sent successful
    //15 - device is busy
    return rs;
    
    
}


-(void)onDeviceResponse:(NSData *)data
{
    [self onDeviceResponses:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.queueCompletion) {
            self.queueCompletion([self getHexString:data]);
            self.queueCompletion = nil;
        }
    });
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)OnTransactionStatus:(NSData *)data
{
    //    NSString* dataString = [self getHexString:data];
    //0400010000 present card
    //    txtData.text = [txtData.text stringByAppendingString:[NSString stringWithFormat:@" [Transaction Status] %@", dataString]];
    //    [self setText:[NSString stringWithFormat:@" [Transaction Status] %@", dataString]];
    
    
}

-(void)OnDisplayMessageRequest:(NSData *)data
{
    NSString* dataString =  [ HexUtil stringFromHexString:[self getHexString:data]];
    txtData.text = @"";
    cardPaymentStatus = dataString;
    //PRESENT CARD
    //PLEASE WAIT
    //DECLINED
    //APPROVED
    if ([dataString isEqualToString:@"PRESENT CARD"]) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        cardView.hidden = NO;
        
    }
    if ([dataString isEqualToString:@"DECLINED"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Sorry..Payment Declined. Please try after some time." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self.lib closeDevice];
            [self.navigationController popViewControllerAnimated:YES];
            // Ok action example
        }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self->txtData.text =  [NSString stringWithFormat:@"Result %@", dataString];
    });
    
}


-(void)onDeviceExtendedResponse:(NSString *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:[NSString stringWithFormat:@"\n[Device Extended Response]\n%@", data]];
    });
}


-(void)OnEMVCommandResult:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString* dataString = [self getHexString:data];
        [self setText:[NSString stringWithFormat:@"\n[EMV Command Result] %@", dataString]];
    });
}
-(void)OnUserSelectionRequest:(NSData *)data
{
    
    NSString* dataString = [self getHexString:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:[NSString stringWithFormat:@"\n[User Selection Request] %@", dataString]];
        
        NSData* data = [HexUtil getBytesFromHexString:dataString];
        Byte *dataType = (unsigned char*)[[data subdataWithRange:NSMakeRange(0, 1)] bytes];
        
        
        Byte timeOut;
        [[data subdataWithRange:NSMakeRange(1, 1)] getBytes:&timeOut length:sizeof(timeOut)];
        
        
        if((int)timeOut > 0)
        {
            int time = (int)timeOut;
            self->tmrTimeout = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(selectionTimedOut) userInfo:nil repeats:NO];
        }
        
    });
    
}


-(void)selectionTimedOut
{
    
    [[[UIAlertView alloc]initWithTitle:@"Transaction Timed Out" message:@"User took too long to enter a selection, transaction has been canceled" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil]show];
}

-(void)OnARQCReceived:(NSData *)data
{
    NSString* dataString = [self getHexString:data];
    
    NSData *emvBytes = [HexUtil getBytesFromHexString:dataString];
    NSMutableDictionary* tlv = [emvBytes parseTLVData];
    // NSLog([tlv dumpTags]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:[NSString stringWithFormat:@"\n[ARQC Received]\n%@", dataString]];
        
        if(tlv != nil)
        {
            
            
            NSString* deviceSN = [HexUtil stringFromHexString: [(MTTLV*)[tlv objectForKey:@"DFDF25"] value]];
            self->ksnStr = [(MTTLV*)[tlv objectForKey:@"DFDF56"] value];
            self->encryptionType = [(MTTLV*)[tlv objectForKey:@"DFDF55"] value];
            self->paddedBytes = [(MTTLV*)[tlv objectForKey:@"DFDF58"] value];
            
            [self setText:[NSString stringWithFormat:@"\nSN Bytes = %@", [(MTTLV*)[tlv objectForKey:@"DFDF25"] value]]];
            [self setText:[NSString stringWithFormat:@"\nSN String = %@", deviceSN]];
            NSData* response;
            if(self->arqcFormat == ARQC_EDYNAMO_FORMAT)
            {
                
                response = [self buildAcquirerResponse:[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF25"] value]] encryptionType:nil ksn:nil approved:YES];
            }
            else
            {
                response = [self buildAcquirerResponse:[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF25"] value]] encryptionType:[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF55"] value]] ksn:[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF54"] value]] approved:YES];
            }
            txtData.text = @"";
            txtData.text = [txtData.text stringByAppendingString: [NSString stringWithFormat:@" [Send Respond] %@", [self getHexString:response]]];
            [self setText:[NSString stringWithFormat:@"\n[Send Response]\n%@", response]];
            
            [self.lib setAcquirerResponse:(unsigned char *)[response bytes] length:(int)response.length];
            
            if ([self->cardPaymentStatus isEqualToString:@"APPROVED"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                });
                [self.lib closeDevice];
                [self apiConnect:dataString];
                
                
            }
        }
        
        
    });
    
}

- (NSData*) buildAcquirerResponse:(NSData*)deviceSN encryptionType:(NSData*)encryptionType ksn:(NSData*)ksn approved:(int)approved
{
    
    NSMutableData* response = [[NSMutableData alloc]init];
    
    
    NSInteger lenSN = 0;
    if (deviceSN != nil)
    {
        lenSN = deviceSN.length;
    }
    
    
    Byte snTagByte[] = {(Byte)0xDF, (Byte)0xDF, 0x25, (Byte)lenSN};
    NSData* snTag = [NSData dataWithBytes:snTagByte length:4];
    
    Byte encryptionTypeTagByte[] = {(Byte)0xDF, (Byte)0xDF, 0x55, (Byte)encryptionType.length};
    NSData* encryptionTypeTag = [NSData dataWithBytes:encryptionTypeTagByte length:4];
    
    Byte ksnTagByte[] = {(Byte)0xDF, (Byte)0xDF, 0x54, (Byte)ksn.length};
    NSData* ksnTag = [NSData dataWithBytes:ksnTagByte length:4];
    
    Byte containerByte[] = { (Byte) 0xFA, 0x06, 0x70, 0x04};
    NSData* container = [NSData dataWithBytes:containerByte length:4];
    
    
    
    
    Byte approvedARCByte[] =  { (Byte) 0x8A, 0x02, 0x30, 0x30 };
    NSData* approvedARC = [NSData dataWithBytes:approvedARCByte length:4];
    
    Byte declinedARCByte[] = { (Byte) 0x8A, 0x02, 0x30, 0x35 };
    NSData* declinedARC = [NSData dataWithBytes:declinedARCByte length:4];
    
    /*
     Byte quickChipARCByte[] =  { (Byte) 0x8A, 0x02, 0x5A, 0x33 };
     NSData* quickChipARC = [NSData dataWithBytes:quickChipARCByte length:4];
     */
    
    Byte macPadding[] = { 0x00, 0x00,0x00,0x00,0x00,0x00,0x01,0x23, 0x45, 0x67 };
    
    unsigned long len = 2 + snTag.length + lenSN + container.length + approvedARC.length;
    
    if(arqcFormat == ARQC_DYNAPRO_FORMAT)
    {
        len += encryptionTypeTag.length + encryptionType.length + ksnTag.length + ksn.length ;
    }
    Byte len1 = (Byte)((len >>8) & 0xff);
    Byte len2 = (Byte)(len & 0xff);
    
    Byte tempByte = 0xf9;
    [response appendBytes:&len1 length:1];
    [response appendBytes:&len2 length:1];
    [response appendBytes:&tempByte length:1];
    tempByte = (Byte) (len - 2);
    if(arqcFormat == ARQC_DYNAPRO_FORMAT)
    {
        tempByte = encryptionTypeTag.length + encryptionType.length + ksnTag.length + ksn.length +  snTag.length + lenSN + container.length + approvedARC.length;
    }
    [response appendBytes:&tempByte length:1];
    
    
    if(arqcFormat == ARQC_DYNAPRO_FORMAT)
    {
        [response appendData:ksnTag];
        [response appendData:ksn];
        
        [response appendData:encryptionTypeTag];
        [response appendData:encryptionType];
    }
    
    [response appendData:snTag];
    [response appendData:deviceSN];
    [response appendData:container];
    
    
    if(approved == 1)
    {
        [response appendData:approvedARC];
    }
    else if( approved== 0)
    {
        [response appendData:declinedARC];
    }
    /*
     else
     {
     [response appendData:quickChipARC];
     }*/
    
    
    
    if(arqcFormat == ARQC_DYNAPRO_FORMAT)
    {
        
        [response appendData:[NSData dataWithBytes:&macPadding length:10]];
    }
    
    
    
    return  response;
    
}
-(void)OnTransactionResult:(NSData *)data
{
    NSString* dataString = [self getHexString:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:[NSString stringWithFormat:@"\n[Transaction Result]\n%@", dataString]];
        
        
        
        NSString* dataString = [self getHexString:[data subdataWithRange:NSMakeRange(1, data.length - 1)]];
        
        NSData *emvBytes = [HexUtil getBytesFromHexString:dataString];
        NSMutableDictionary* tlv = [emvBytes parseTLVData];
        NSString* dataDump = [tlv dumpTags];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setText:[NSString stringWithFormat:@"\n[ARQC Received]\n%@", dataString]];
            
            if(tlv != nil)
            {
                
                
                NSString* deviceSN = [HexUtil stringFromHexString: [(MTTLV*)[tlv objectForKey:@"DFDF25"] value]];
                self->ksnStr = [(MTTLV*)[tlv objectForKey:@"DFDF56"] value];
                self->encryptionType = [(MTTLV*)[tlv objectForKey:@"DFDF55"] value];
                self->paddedBytes = [(MTTLV*)[tlv objectForKey:@"DFDF58"] value];
                
                NSString *datastr = [(MTTLV*)[tlv objectForKey:@"DFDF59"] value];
                
                if ([self->cardPaymentStatus isEqualToString:@"APPROVED"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    });
                    [self.lib closeDevice];
                    [self apiConnect:datastr];
                }
            }
            
            
        });
        
        
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.lib closeDevice];
}

-(IBAction)settingButtonPressed:(id)sender{
    GlobalKeyViewController *vc = [[GlobalKeyViewController alloc] initWithNibName:@"GlobalKeyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
}
- (void)GlobalKeyViewControllerDelegateMethod :(NSString *)emailId{
    GlobalKeyViewController *vc = [[GlobalKeyViewController alloc] initWithNibName:@"GlobalKeyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.emailId = emailId;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
    
}
- (void)PopViewToMainView :(NSString *)emailId{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[GroupsListViewController class]]){
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
    
}
-(IBAction)backBtnPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)bookingApi:(NSString *)transactionID{
//    return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/reservation/%@/",KBASEPATH,_sfid]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults]
                                                               stringForKey:@"token"]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"startdate":_date,
                             @"duration":[NSNumber numberWithInteger:_duration],
                             @"capacity":[NSNumber numberWithInteger:_capacity],
                             @"stripe_source":@"",
                             @"email":_email,
                             @"amount_due":_price,
                             @"save_card":[NSNumber numberWithInteger:0],
                             @"magtek_transaction_id" :transactionID,
                             @"phonenumber" :_phoneNumber,
                             @"name" :_name
                             };
    
//    NSDictionary *params = @{@"startdate":_date,
//                             @"duration":[NSNumber numberWithInteger:_duration],
//                             @"capacity":[NSNumber numberWithInteger:_capacity],
//                             @"stripe_source":@"",
//                             @"email":_email,
//                             @"amount_due":[NSNumber numberWithInteger:[_price integerValue]],
//                             @"save_card":[NSNumber numberWithInteger:0],
//                             @"magtek_transaction_id" :@"",
//                             @"phonenumber" :number,
//                             @"name" :name.text
//                             };
    
    [manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [responseObject objectForKey:@"result"];
        BookingConfirmationViewController *vc = [[BookingConfirmationViewController alloc] initWithNibName:@"BookingConfirmationViewController" bundle:nil];
        vc.userKey = [dict valueForKey:@"userkey"];
        vc.podName = self->_podName;
        vc.date = self->_date;
        vc.duration = [NSString stringWithFormat:@"%ld",(long)self->_duration];
        vc.imageurl = self->_imageurl;
        vc.price = self->_price;
        vc.capacity = self->_capacity;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        id responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        NSString *string = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"detail"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"Error: %@", error);
    }];
    
}
@end
