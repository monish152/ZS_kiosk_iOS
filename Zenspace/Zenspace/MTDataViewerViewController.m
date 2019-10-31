//
//  MTDataViewerViewController.m
//  MTSCRADemo
//
//  Created by Tam Nguyen on 7/21/15.
//  Copyright (c) 2015 MagTek. All rights reserved.
//

#import "MTDataViewerViewController.h"
#import "NSObject+TLVParser.h"
#import <MediaPlayer/MediaPlayer.h>

#define SHOW_DEBUG_COUNT 0
typedef void (^cmdCompBlock)(NSString*);
@interface MTDataViewerViewController ()
{
    int swipeCount;
    NSString* commandResult;
    cmdCompBlock cmdCompletion;
    
}
@end

@implementation MTDataViewerViewController
-(void)awakeFromNib{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUpUI];
    
    // Do any additional setup after loading the view.
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

- (BOOL)isX
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        if (@available(iOS 8, *)) {
            NSLog(@"%i",(int)[[UIScreen mainScreen] nativeBounds].size.height);
            switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                    
                case 1136:
                    printf("iPhone 5 or 5S or 5C");
                    break;
                case 1334:
                    printf("iPhone 6/6S/7/8");
                    break;
                case 2208:
                    printf("iPhone 6+/6S+/7+/8+");
                    break;
                case 2436:
                case 2688:
                case 1792:
                    return YES;
                    break;
                default:
                    printf("unknown");
            }
        }
        else
            return NO;
    }
    else
    {
        
        NSLog(@"%i",(int)[[UIScreen mainScreen] nativeBounds].size.height);
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                
                
            case 2388:
            case 2732:
                //iPad Pro 11
                return YES;
            default:
                return NO;
                
                
        }
        
    }
    return NO;
    
}

- (void) setUpUI
{
    devicePaired = YES;
    int xOffset = 0;
    if([self isX])
    {
        xOffset = 70;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear Data"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self action:@selector(clearData)];
    
    
    
}
- (void) turnMSROn
{
    Byte rs[3];
    NSData* rsData = [HexUtil getBytesFromHexString: [self sendCommandSync:@"5800"]];
    [rsData getBytes:rs length:rsData.length];
    if(rs[2] == 0x00)
    {
        [self sendCommandSync:@"580101"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MSR Off"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self action:@selector(turnMSROn)];
    }
    else if( rs[2] == 0x01)
    {
        [self sendCommandSync:@"580100"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MSR On"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self action:@selector(turnMSROn)];
    }
    
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
        self.txtData.text = [NSString stringWithFormat:@"%@\r%@", self.txtData.text, text];
        [self scrollTextViewToBottom:self.txtData];
    });
}

- (void)getSerialNumber
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.txtData.text = [NSString stringWithFormat:@"%@\rDevice Serial Number: %@\r", self.txtData.text, [self.lib getDeviceSerial]];// @"Connected...";
        [self setText: [NSString stringWithFormat:@"Device Serial Number: %@\r",[self.lib getDeviceSerial]]];
        
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)sendCommand
{
    if (_txtCommand.text.length > 0) {
        [self.lib sendcommandWithLength:_txtCommand.text];
    }
}

- (void)connect
{
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
    
    if(self.lib.getDeviceType == MAGTEKAUDIOREADER)
    {
        // ...
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        musicPlayer.volume = 1.0f;
    }
#if SHOW_DEBUG_COUNT
    swipeCount = 0;
#endif
}

- (void) cardSwipeDidStart:(id)instance
{
    [self setText:@"Card Swipe Started"];// @"Connected...";
    
}
- (void) cardSwipeDidGetTransError
{
    [self setText:@"Transfer error..."];
}


-(void)viewDidAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.lib isDeviceOpened])
        {
            if([self.lib isDeviceConnected])
            {
                
               
            }
            else
            {
                NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
                   [def setObject:@"Yes" forKey:@"stripe"];
                   [def synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
               [def setObject:@"Yes" forKey:@"stripe"];
               [def synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    });
    
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

- (NSString*) buildCommandForAudioTLV:(NSString*)commandIn
{
    
    NSString* commandSize = [NSString stringWithFormat:@"%02x",  (unsigned int)commandIn.length / 2];
    NSString* newCommand = [NSString stringWithFormat:@"8402%@%@", commandSize, commandIn];
    
    NSString* fullLength = [NSString stringWithFormat:@"%02x",  (unsigned int)newCommand.length / 2];
    NSString* tlvCommand = [NSString stringWithFormat:@"C102%@%@", fullLength, newCommand];
    
    return tlvCommand;
    
}

-(void) onDeviceConnectionDidChange:(MTSCRADeviceType)deviceType connected:(BOOL)connected instance:(id)instance
{
    
//    
//    if([(MTSCRA*)instance isDeviceOpened] && [self.lib isDeviceConnected])
//    {
//        if(connected)
//        {
//            int delay = 1.0;
//            if (deviceType == MAGTEKAUDIOREADER)
//                delay = 2.0f;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
//                if([self.lib isDeviceConnected] && [self.lib isDeviceOpened])
//                {
//                    
//                    
//                    dispatch_async(queue, ^{
//                        
//                        
//                        if(deviceType == MAGTEKDYNAMAX || deviceType == MAGTEKEDYNAMO  || deviceType == MAGTEKTDYNAMO)
//                        {
//                            [self setText:[NSString stringWithFormat:@"Connected to %@",[(MTSCRA*)instance getConnectedPeripheral].name]];
//                            
//                            
//                            if(!self->devicePaired)
//                                return;
//                            
//                            if(deviceType == MAGTEKDYNAMAX || deviceType == MAGTEKEDYNAMO || deviceType == MAGTEKTDYNAMO)
//                            {
//                                [self setText:@"Setting data output to Bluetooth LE..."];
//                                NSString* bleOutput = [self sendCommandSync:@"480101"];
//                                [self setText:[NSString stringWithFormat:@"[Output Result]\r%@",bleOutput]];
//                                
//                            }
//                            else if(deviceType == MAGTEKDYNAMAX)
//                            {
////                                [self.lib sendcommandWithLength:@"000101"];
//                            }
//                            
//                        }
//                        
//                        else
//                        {
//                            [self setText:@"Device Connected..."];// @"Connected...";
//                        }
//                        
//                        [self setText:@"Getting FW ID..."];
//                        NSString* fw ;
//                        if([self.lib getDeviceType] == MAGTEKAUDIOREADER)
//                        {
//                            fw = [self sendCommandSync:[self buildCommandForAudioTLV: @"000100"]];
//                            [NSThread sleepForTimeInterval:1];
//                        }
//                        else
//                        {
////                            fw = [self sendCommandSync:@"000100"];
//                        }
////                        [self setText:[NSString stringWithFormat:@"[Firmware ID]\r%@",fw]];
//                        
//                        [self setText:@"Getting SN..."];
//                        NSString* sn;
//                        if([self.lib getDeviceType] == MAGTEKAUDIOREADER)
//                        {
//                            sn = [self sendCommandSync:[self buildCommandForAudioTLV: @"000103"]];
//                            //[NSThread sleepForTimeInterval:1];
//                        }
//                        else
//                        {
////                            sn = [self sendCommandSync:@"000103"];
//                        }
//                        [self setText:[NSString stringWithFormat:@"[Device SN]\r%@",sn]];
//                        
//                        [self setText:@"Getting Security Level..."];
//                        NSString* sl;
//                        if([self.lib getDeviceType] == MAGTEKAUDIOREADER)
//                        {
//                            sl = [self sendCommandSync:[self buildCommandForAudioTLV: @"1500"]];
//                            //[NSThread sleepForTimeInterval:1];
//                        }
//                        else
//                        {
//                            sl = [self sendCommandSync:@"1500"];
//                        }
//                        
//                        [self setText:[NSString stringWithFormat:@"[Security Level]\r%@",sl]];
//                        
//                        
//                        [NSThread sleepForTimeInterval:0.5];
//                        [self sendCommandSync:@"580101"];
//                        [self sendCommandSync:@"59020F20"];
//                         [self setDateTime];
//                       
//                    });
//                    
//                    if(deviceType == MAGTEKTDYNAMO)
//                    {
//                        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MSR On"
//                                                                                                 style:UIBarButtonItemStylePlain
//                                                                                                target:self action:@selector(turnMSROn)];
//                    }
//                };
//                
//            });
//        }
//        else
//        {
//            devicePaired = YES;
//            [self setText:@"Disconnected"];
//           
//        }
//        
//    }
//    else
//    {
//        devicePaired = YES;
//        [self setText:@"Disconnected"];
//        [_btnConnect setTitle: @"Connect" forState:UIControlStateNormal];
//        
//       
//        if(deviceType == MAGTEKTDYNAMO)
//        {
//            self.navigationItem.leftBarButtonItem = nil;
//        }
//        
//    }
//#if SHOW_DEBUG_COUNT
//    self.txtData.text = [self.txtData.text stringByAppendingString: [NSString stringWithFormat:@"\n\nSwipe.Count:%i", swipeCount]];
//#endif
    
    
}
-(void)clearData
{
    [self.lib clearBuffers];
    [self.txtData setText:@""];
}




-(void)onDataReceived:(MTCardData *)cardDataObj instance:(id)instance
{
    NSLog(@"onDataReceived : %@",[NSString stringWithFormat:      @"Track.Status: %@\n\n"
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
                                              [(MTSCRA*)instance getResponseData]]);
    
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
    
    
    ksnStr = cardDataObj.deviceKSN;
    deviceSNStr = cardDataObj.deviceSerialNumber;
    magnePrintStr = cardDataObj.encryptedMagneprint;
    magnePrintStatus = cardDataObj.magneprintStatus;
    track1Str = cardDataObj.encryptedTrack1;
    track2Str = cardDataObj.encryptedTrack2;
    
    [self getSwipeCard];
    
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


-(void)onDeviceResponse:(NSData *)data
{
    
    if(cmdCompletion)
    {
        
        NSString* dataStr = [HexUtil toHex:data offset:0 len:data.length];
        cmdCompletion( dataStr);
        cmdCompletion = nil;
        return;
        
    }
    
    
    NSString* dataString = [self getHexString:data];
    NSLog(@"%@", dataString);
    
    commandResult = dataString;
    [self setText:[NSString stringWithFormat:@"\n[Device Response]\n%@", dataString]];
    
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
