//
//  eDynamoController.m
//  MTSCRADemo
//
//  Created by Tam Nguyen on 7/22/15.
//  Copyright (c) 2015 MagTek. All rights reserved.
//

#import "eDynamoController.h"
#import "eDynamoSignature.h"

#define ARQC_DYNAPRO_FORMAT 0x01
#define ARQC_EDYNAMO_FORMAT 0x00
@interface eDynamoController ()
{
    UIActionSheet *userSelection;
    NSTimer* tmrTimeout;
    optionController* opt;
    Byte tempAmount[6];
    unsigned char amount[6];
    Byte currencyCode[2];
    Byte cashBack[6];
    Byte arqcFormat;
  
}
typedef void(^commandCompletion)(NSString*);
@property (nonatomic, strong) commandCompletion queueCompletion;
@end

@implementation eDynamoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int xOffset = 0;
    if([self isX])
    {
        xOffset = 70;
    }
    
    // Do any additional setup after loading the view.
    self.title = @"Bluetooth LE EMV";
   
    
    int btnWidth = self.view.frame.size.width / 4;
    
    self.cardView.layer.cornerRadius = 20;
    self.swipeCardLbl.font = [UIFont fontWithName:@"CircularStd-Medium"
                                        size:28];
    
    _btnStartEMV = [[UIButton alloc]initWithFrame:CGRectMake(5, self.view.frame.size.height - 98 - 65 - 60, btnWidth - 7, 40)];
    [_btnStartEMV setTitle:@"Start" forState:UIControlStateNormal];
    [_btnStartEMV setBackgroundColor:UIColorFromRGB(0x3465AA)];
    [_btnStartEMV addTarget:self action:@selector(startEMV) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnStartEMV];
    

    
    self.lib = [MTSCRA new];
    //self.lib.delegate = self;
    
    [self.lib setDeviceType:MAGTEKEDYNAMO];
    
    
    [self.btnConnect removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    int yOffset = 0;
    if([self isX])
    {
        yOffset = 60;
    }
    self.btnConnect.frame = CGRectMake(0, self.view.frame.size.height - 98 - 65 - xOffset - yOffset, self.view.frame.size.width, 50);
    [self.btnConnect addTarget:self action:@selector(isTDyanmo) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.txtData.text = [NSString stringWithFormat:@"App Version: %@.%@ , SDK Version: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], self.lib.getSDKVersion];
    
    
    self.lib.delegate = self;
//    [self.navigationController popViewControllerAnimated:YES];
    opt = [[optionController alloc]initWithData];
    
    
}

-(void)isTDyanmo
{
    
    if(self.lib.isDeviceOpened)
    {
        [self.lib closeDevice];
        return;
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Bluetooth LE EMV Type"
                                  message:@"Which device are you connecting to"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* eDynamo = [UIAlertAction
                            actionWithTitle:@"eDynamo"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.lib setDeviceType:MAGTEKEDYNAMO];
                                    [self scanForBLE];
                                });
                                
                            }];
    UIAlertAction* tDynamo = [UIAlertAction
                                actionWithTitle:@"tDynamo"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.lib setDeviceType:MAGTEKTDYNAMO];
                                        [self scanForBLE];
                                    });
                                }];
    UIAlertAction* btnCancel = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  
                              }];
    [alert addAction:eDynamo];
    [alert addAction:tDynamo];
    [alert addAction:btnCancel];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)presentOption
{
    if(!opt)
        opt = [[optionController alloc]initWithStyle:UITableViewStyleGrouped];
    opt.delegate = self;
    [self.navigationController pushViewController:opt animated:YES];
    
}
-(void)didSelectSetDateTime
{
    [self setDateTime];
    [self.navigationController popViewControllerAnimated:YES];
}

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
    NSString* serialNumber = @"42324645304542303932393135414100"; //CHANGE TO REAL DEVICE SERIAL NUMBER
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
    // [self ledON:0 completion:^(NSString * status) {
    [self.lib cancelTransaction];
    // }];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    //[self.lib closeDevice];
    
}

-(void)didSelectBLEReader:(CBPeripheral *)per
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:@"Connecting..."];
        //cbper = per;
        self.lib.delegate = self;
        [self.navigationController popViewControllerAnimated:YES];
        [self.lib setAddress:per.identifier.UUIDString];
        [self.lib openDevice];
    });
    
}
-(void)bleReaderStateUpdated:(MTSCRABLEState)state
{
    
    
    
   // NSLog(@"BLE State: %d", state);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(state == UNSUPPORTED)
        {
            [[[UIAlertView alloc]initWithTitle:@"Bluetooth LE Error" message:@"Bluetooth LE is unsupported on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
            
        }
    });
}
- (void)scanForBLE
{
    
  
    
    BLEScannerList* list = [[BLEScannerList alloc] initWithStyle:UITableViewStylePlain lib:self.lib];
    list.delegate = self;
    [self.navigationController pushViewController:list animated:YES];
}


- (void)deviceNotPaired
{
    [super deviceNotPaired];
    [self setText:@"Error: Device not Paired.\r"];
    
}
-(void) onDeviceConnectionDidChange:(MTSCRADeviceType)deviceType connected:(BOOL)connected instance:(id)instance
{
    
        [super onDeviceConnectionDidChange:deviceType connected:connected instance:instance];
    
    
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
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    // dispatch_async(dispatch_get_main_queue(), ^{
    if (buttonIndex == 1 || buttonIndex == 2) {
        NSString *txtAmount = self.transactionAmount;
        if(txtAmount.length == 0)
            txtAmount = @"0";
        if(txtAmount.length > 0)
        {
            // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if(alertView.tag == 0)
            {
                NSData* dataAmount = [HexUtil dataFromHexString:txtAmount];
                
                
                memcpy(tempAmount, [dataAmount bytes],6);
                
                for (int i = 5; i >= 0; i--) {
                    amount[i] = tempAmount[5 - i];
                }
                memcpy(tempAmount, amount,6);
                
            }
            else
            {
                memcpy(amount, tempAmount,6);
                
            }
            Byte timeLimit = 0x3C;
            Byte cardType = [opt getCardType];
            
            
            Byte option = 0x00;
            
            if([opt isQuickChip])
            {
                option |= 0x80;
            }
            
            Byte transactionType = [opt getPurchaseOption];
            
            cashBack[0] = 0x00;
            cashBack[1] = 0x00;
            cashBack[2] = 0x00;
            cashBack[3] = 0x00;
            cashBack[4] = 0x00;
            cashBack[5] = 0x00;
            
            
            currencyCode[0] =  0x08;
            currencyCode[1] = 0x40;
            Byte reportingOption =   0x02;
            
            
            if([opt getPurchaseOption] & 0x02)
            {
                if(alertView.tag != 1)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Cashback Amount"
                                                                        message:@"Enter amout for Cashback"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"OK", nil];
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                        [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
                        alert.tag = 1;
                        [alert show];
                        
                    });
                    return;
                }
                else
                {
                    NSData* dataAmount = [HexUtil dataFromHexString:txtAmount];
                    
                    
                    memcpy(tempAmount, [dataAmount bytes],6);
                    
                    for (int i = 5; i >= 0; i--) {
                        cashBack[i] = tempAmount[5 - i];
                    }
                    
                    
                }
                
                
            }
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
                    //[self ledON:1 completion:^(NSString* status) {
                    [self.lib startTransaction:timeLimit cardType:cardType option:option amount:self->amount transactionType:transactionType cashBack:self->cashBack currencyCode:self->currencyCode reportingOption:reportingOption];
                    
                    //}];
                });
            }];
            //});
        }
        
        
        
    }
    //});
}
 */

//setLED:(BOOL)
-(int)ledON:(int)on completion:(commandCompletion)completion
{
    int rs = [self.lib sendcommandWithLength:[NSString stringWithFormat: @"4D010%i", on]];
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
     [super onDeviceResponse:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (self.queueCompletion) {
            self.queueCompletion([super getHexString:data]);
            self.queueCompletion = nil;
        }
    });
}
- (void)startEMV
{
    
    if(self.lib.isDeviceOpened && self.lib.isDeviceConnected)
    {

        // dispatch_async(dispatch_get_main_queue(), ^{
        
            NSString *txtAmount = self.transactionAmount;
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
                Byte cardType = 0x03;
                
                
                Byte option = 0x00;
                
                if([opt isQuickChip])
                {
                    option |= 0x80;
                }
                
                Byte transactionType = [opt getPurchaseOption];
                
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
                        //[self ledON:1 completion:^(NSString* status) {
                        [self.lib startTransaction:timeLimit cardType:cardType option:option amount:self->amount transactionType:transactionType cashBack:self->cashBack currencyCode:self->currencyCode reportingOption:reportingOption];
                        
                        //}];
                    });
                }];
                //});
            }
    }
}

-(IBAction)getSwipeCard{
    [self apiCardSwipeConnect];
}
- (void)onDeviceError:(NSError *)error
{
    [super onDeviceError:error];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




-(void)OnTransactionStatus:(NSData *)data
{
    NSString* dataString = [self getHexString:data];
    
    //self.txtData.text = [self.txtData.text stringByAppendingString:[NSString stringWithFormat:@"\n[Transaction Status]\n%@", dataString]];
    [self setText:[NSString stringWithFormat:@"\n[Transaction Status]\n%@", dataString]];
    
    
}

-(void)OnDisplayMessageRequest:(NSData *)data
{
    NSString* dataString =  [ HexUtil stringFromHexString:[self getHexString:data]];
    self.cardPaymentStatus = dataString;
    NSLog(@"OnDisplayMessageRequest self.cardPaymentStatus :%@",dataString);
    if ([dataString isEqualToString:@"PRESENT CARD"]) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.cardView.hidden = NO;
        
    }
    if ([dataString isEqualToString:@"INSERT AGAIN"]) {
        self.cardView.hidden = NO;
        self.swipeCardLbl.text = @"Insert Again";
        
    }
    if ([dataString isEqualToString:@"PLEASE WAIT"]) {
        self.cardView.hidden = NO;
        self.swipeCardLbl.text = @"Please Wait";
        
    }
    if ([dataString isEqualToString:@"TRANSACTION TERMINATED"]) {
        self.cardView.hidden = NO;
        self.swipeCardLbl.text = @"Please Try Again";
        
    }
    if ([dataString isEqualToString:@"PROCESSING ERROR"]) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Sorry..Processing Error. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self.lib closeDevice];
            [self.navigationController popViewControllerAnimated:YES];
            // Ok action example
        }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
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
        // self.txtData.text =  [self.txtData.text stringByAppendingString:[NSString stringWithFormat:@"\n[Display Message Request]\n%@", dataString]];
        [self setText:[NSString stringWithFormat:@"\n[Display Message Request]\n%@", dataString]];
    });
    
}

-(NSString*)getUserFriendlyLanguage:(NSString*)codeIn
{
    NSDictionary* lanCode = @{@"EN": @"English",
                              @"DE": @"Deutsch",
                              @"FR": @"Français",
                              @"ES": @"Español",
                              @"ZH": @"中文",
                              @"IT": @"Italiano"};
    
    return [lanCode objectForKey:[codeIn uppercaseString]];
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
        [self setText:[NSString stringWithFormat:@"\n[EMV Command Result]\n%@", dataString]];
    });
}
-(void)OnUserSelectionRequest:(NSData *)data
{
    
    NSString* dataString = [self getHexString:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:[NSString stringWithFormat:@"\n[User Selection Request]\n%@", dataString]];
        
        NSData* data = [HexUtil getBytesFromHexString:dataString];
        Byte *dataType = (unsigned char*)[[data subdataWithRange:NSMakeRange(0, 1)] bytes];
        
        
        Byte timeOut;
        [[data subdataWithRange:NSMakeRange(1, 1)] getBytes:&timeOut length:sizeof(timeOut)];
        
        NSArray* menuItems =   [[self getHexString:[data subdataWithRange:NSMakeRange(2, data.length - 2)]] componentsSeparatedByString:@"00"];
        self->userSelection = [[UIActionSheet alloc] init];
        [self->userSelection setTitle: [ HexUtil stringFromHexString: menuItems[0]]];
        self->userSelection.delegate = self;
        for(int i = 1; i < menuItems.count - 1; i ++)
        {
            if(dataType[0] & 0x01)
            {
                [self->userSelection addButtonWithTitle: [self getUserFriendlyLanguage:[ HexUtil stringFromHexString: menuItems[i]]]];
            }
            else
            {
                [self->userSelection addButtonWithTitle: [ HexUtil stringFromHexString: menuItems[i]]];
            }
        }
        [self->userSelection setDestructiveButtonIndex:[self->userSelection addButtonWithTitle:@"Cancel"]];
        [self->userSelection showInView:self.view];
        if((int)timeOut > 0)
        {
            int time = (int)timeOut;
            self->tmrTimeout = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(selectionTimedOut) userInfo:nil repeats:NO];
        }
        
    });
    
}


-(void)selectionTimedOut
{
    [userSelection dismissWithClickedButtonIndex:userSelection.destructiveButtonIndex animated:YES];
    [self.lib setUserSelectionResult:0x02 selection:(Byte)userSelection.destructiveButtonIndex];
    [[[UIAlertView alloc]initWithTitle:@"Transaction Timed Out" message:@"User took too long to enter a selection, transaction has been canceled" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil]show];
}

-(void)OnARQCReceived:(NSData *)data
{
    
    NSString* dataString = [self getHexString:data];
    
    NSData *emvBytes = [HexUtil getBytesFromHexString:dataString];
    NSMutableDictionary* tlv = [emvBytes parseTLVData];
    NSString* dataDump = [tlv dumpTags];
    NSLog(@"%@",dataDump);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:[NSString stringWithFormat:@"\n[ARQC Received]\n%@", dataString]];
        if(tlv != nil)
        {
            
            if([self->opt isQuickChip])
            {
                [self setText:[NSString stringWithFormat:@"\n[Quick Chip]\r\nNot sending response\n"]];
                return;
            }
            NSString* deviceSN = [HexUtil stringFromHexString: [(MTTLV*)[tlv objectForKey:@"DFDF25"] value]];
            [self setText:[NSString stringWithFormat:@"\nSN Bytes = %@", [(MTTLV*)[tlv objectForKey:@"DFDF25"] value]]];
            [self setText:[NSString stringWithFormat:@"\nSN String = %@", deviceSN]];
            NSData* response;
            
            if(self->arqcFormat == ARQC_EDYNAMO_FORMAT)
            {
                
                response = [self buildAcquirerResponse:[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF25"] value]] encryptionType:nil ksn:nil approved:[self->opt shouldSendApprove]];
            }
            else
            {
                response = [self buildAcquirerResponse:[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF25"] value]] encryptionType:[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF55"] value]] ksn:[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF54"] value]] approved:[self->opt shouldSendApprove]];
            }
            
            [self setText:[NSString stringWithFormat:@"\n[Send Response]\n%@", response]];
            
            [self.lib setAcquirerResponse:(unsigned char *)[response bytes] length:(int)response.length];
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
    NSLog(@"OnTransactionResult dataString:%@",dataString);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:[NSString stringWithFormat:@"\n[Transaction Result]\n%@", dataString]];
        
        
        NSString* dataString = [self getHexString:[data subdataWithRange:NSMakeRange(1, data.length - 1)]];
        
        NSData *emvBytes = [HexUtil getBytesFromHexString:dataString];
        NSMutableDictionary* tlv = [emvBytes parseTLVData];
        NSString* dataDump = [tlv dumpTags];
//         NSLog(@"%@", dataDump);
        if(self->arqcFormat == ARQC_EDYNAMO_FORMAT)
        {
            Byte* responseTag = (unsigned char*)[[HexUtil getBytesFromHexString:[(MTTLV*)[tlv objectForKey:@"DFDF1A"] value]]bytes] ;
            
            
            [self setText:[NSString stringWithFormat:@"\n[Parsed Transaction Result]\n%@", dataDump]];
            
            Byte *sigReq = (unsigned char*)[[data subdataWithRange:NSMakeRange(0, 1)] bytes] ;
            if(sigReq[0] == 0x01 && (responseTag[0] == 0x00))
            {
                [[[UIAlertView alloc] initWithTitle:@"Signature"
                                            message:@"Signature required, please sign."
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil]show];
                eDynamoSignature* sig = [eDynamoSignature new];
                
                [self.navigationController pushViewController:sig animated:YES];
            }
           
        }
        
        self->ksnStr = [(MTTLV*)[tlv objectForKey:@"DFDF56"] value];
        self->encryptionType = [(MTTLV*)[tlv objectForKey:@"DFDF57"] value];
        self->paddedBytes = [(MTTLV*)[tlv objectForKey:@"DFDF58"] value];
        
        NSLog(@"self.cardPaymentStatus :%@",self.cardPaymentStatus);
        if ([self.cardPaymentStatus isEqualToString:@"APPROVED"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
            
            [self apiEVMConnect:dataString];
            
        }
    });
    [self ledON:0 completion:nil];
}




-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (tmrTimeout) {
        [tmrTimeout invalidate];
        tmrTimeout = nil;
    }
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self.lib setUserSelectionResult:0x01 selection:0x00];
        return;
    }
    
    [self.lib setUserSelectionResult:0x00 selection:(Byte)buttonIndex];
    
}


-(void)apiEVMConnect:(NSString *)tlvData{
    NSString *soapMessage;
    
    
    //Static Values
    NSString *amountStr = self.transactionAmount;
    NSString *transactionIdStr = @"1231232";
    encryptionType = @"80";
    paddedBytes = @"0";
    
    
    
    
    //production
//            NSString *custCode = @"QF20436257";
//            NSString *userName = @"MAG190911002";
//            NSString *password = @"ryQbhRu!e@6#Z3";
//            NSString *processorName = @"Rapid Connect v3 - Production";
//
    
    //Pilot
    NSString *custCode = @"RU78375046";
    NSString *userName = @"MAG180419001";
    NSString *password = @"e!g@8iX9kN#O4k";
    NSString *processorName = @"Rapid Connect v3 - Pilot";
    
    
    
    
    
    
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
                       "<!--Optional:-->\n"
                       "<mpp:ProcessEMVSREDRequests>\n"
                       "<mpp1:ProcessEMVSREDRequest>\n"
                       "<!--Optional:-->\n"
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
                       "<!--Optional:-->\n"
                       "<mpp1:CustomerTransactionID>%@</mpp1:CustomerTransactionID>\n"
                       "<mpp1:EMVSREDInput>\n"
                       "<mpp1:EMVSREDData>%@</mpp1:EMVSREDData>\n"
                       "<mpp1:EncryptionType>%@</mpp1:EncryptionType>\n"
                       "<mpp1:KSN>%@</mpp1:KSN>\n"
                       "<mpp1:NumberOfPaddedBytes>%@</mpp1:NumberOfPaddedBytes>\n"
                       "<mpp1:PaymentMode>EMV</mpp1:PaymentMode>\n"
                       "</mpp1:EMVSREDInput>\n"
                       "<mpp1:TransactionInput>\n"
                       "<mpp1:ProcessorName>Token</mpp1:ProcessorName>\n"
                       "<mpp1:TransactionInputDetails>\n"
                       "<sys:KeyValuePairOfstringstring>\n"
                       "<sys:key></sys:key>\n"
                       "<sys:value></sys:value>\n"
                       "</sys:KeyValuePairOfstringstring>\n"
                       "</mpp1:TransactionInputDetails>\n"
                       "<mpp1:TransactionType>TOKEN</mpp1:TransactionType>\n"
                       "</mpp1:TransactionInput>\n"
                       "</mpp1:ProcessEMVSREDRequest>\n"
                       "<mpp1:ProcessEMVSREDRequest>\n"
                       "<mpp1:AdditionalRequestData>\n"
                       "<sys:KeyValuePairOfstringstring>\n"
                       "<sys:key>NonremovableTags</sys:key>\n"
                       "<sys:value Encoding=\"cdata\"><![CDATA[<NonremovableTags><Tag>CCTrack2</Tag></NonremovableTags>]]></sys:value>\n"
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
                       "<sys:key></sys:key>\n"
                       "<sys:value></sys:value>\n"
                       "</sys:KeyValuePairOfstringstring>\n"
                       "</mpp1:TransactionInputDetails>\n"
                       "<mpp1:TransactionType>SALE</mpp1:TransactionType>\n"
                       "</mpp1:TransactionInput>\n"
                       "</mpp1:ProcessEMVSREDRequest>\n"
                       "</mpp:ProcessEMVSREDRequests>\n"
                       "</mpp:ProcessEMVSRED>\n"
                       "</soapenv:Body>\n"
                       "</soapenv:Envelope>\n",custCode,password,userName,transactionIdStr,tlvData,encryptionType,ksnStr,paddedBytes,custCode,password,userName,transactionIdStr,tlvData,encryptionType,ksnStr,paddedBytes,amountStr,processorName];
        
        [request setValue:@"http://www.magensa.net/MPPGv3/IMPPGv3Service/ProcessEMVSRED" forHTTPHeaderField:@"SOAPAction"];
   
        
    
    
    
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
-(void)apiCardSwipeConnect{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *soapMessage;
    
    NSString *amountStr = self.transactionAmount;
    NSString *transactionIdStr = @"1231232";
  
    
    //production
//    NSString *custCode = @"QF20436257";
//    NSString *userName = @"MAG190911002";
//    NSString *password = @"ryQbhRu!e@6#Z3";
//    NSString *processorName = @"Rapid Connect v3 - Production";
    
    
    //Pilot
    NSString *custCode = @"RU78375046";
    NSString *userName = @"MAG180419001";
    NSString *password = @"e!g@8iX9kN#O4k";
    NSString *processorName = @"Rapid Connect v3 - Pilot";
//
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://mppg.magensa.net/v3/MPPGv3Service.svc"]];
    [request setValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"mppg.magensa.net" forHTTPHeaderField:@"Host"];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"Apache-HttpClient/4.1.1" forHTTPHeaderField:@"User-Agent"];
    
    
    
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
                   "<mpp1:DeviceSN>%@</mpp1:DeviceSN>\n"
                   "<mpp1:KSN>%@</mpp1:KSN>\n"
                   "<mpp1:MagnePrint>%@</mpp1:MagnePrint>\n"
                   "<mpp1:MagnePrintStatus>%@</mpp1:MagnePrintStatus>\n"
                   "<mpp1:Track1>%@</mpp1:Track1>\n"
                   "<mpp1:Track2>%@</mpp1:Track2>\n"
                   "<mpp1:Track3></mpp1:Track3>\n"
                   "</mpp1:EncryptedCardSwipe>\n"
                   "</mpp1:CardSwipeInput>\n"
                   "<mpp1:CustomerTransactionID>%@</mpp1:CustomerTransactionID>\n"
                   "<mpp1:TransactionInput>\n"
                   "<mpp1:Amount>%@</mpp1:Amount>\n"
                   "<mpp1:ProcessorName>%@</mpp1:ProcessorName>\n"
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
                   "</soapenv:Envelope>\n",custCode,password,userName,deviceSNStr,ksnStr,magnePrintStr,magnePrintStatus,track1Str,track2Str,transactionIdStr,amountStr,processorName];
    
    [request setValue:@"http://www.magensa.net/MPPGv3/IMPPGv3Service/ProcessCardSwipe" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    NSLog(@"Soap Request : %@",soapMessage);
    
    
    
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
        self.txtData.text = [self.txtData.text stringByAppendingString:[NSString stringWithFormat:@"\n\nAmount : %@",string]];
        
    }
    if ([currentElement isEqualToString:@"a:TransactionID"]) {
        self.transactionid = string;
    }
    if ([currentElement isEqualToString:@"a:TransactionMessage"]) {
        NSLog(@"payment Status : %@",string);
        if ([string isEqualToString:@"APPROVAL"]) {
            NSLog(@"self.transactionid : %@",self.transactionid);
            self.swipeCardLbl.text = @"Thanks. Payment Approved";
             [self bookingApi:self.transactionid];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.lib closeDevice];
}

-(void)bookingApi:(NSString *)transactionID{
    return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/reservation/%@/",KBASEPATH,self.sfid]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults]
                                                               stringForKey:@"token"]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"startdate":self.date,
                             @"duration":[NSNumber numberWithInteger:self.duration],
                             @"capacity":[NSNumber numberWithInteger:self.capacity],
                             @"stripe_source":@"",
                             @"email":self.email,
                             @"amount_due":self.price,
                             @"save_card":[NSNumber numberWithInteger:0],
                             @"magtek_transaction_id" :transactionID,
                             @"phonenumber" :self.phoneNumber,
                             @"name" :self.name
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
        vc.podName =self.podName;
        vc.date = self.date;
        vc.duration = [NSString stringWithFormat:@"%ld",(long)self.duration];
        vc.imageurl = self.imageurl;
        vc.price = self.price;
        vc.capacity = self.capacity;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *parameters = [NSString stringWithFormat:@"%@", params];
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :parameters :errorDescription];
        
        
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
