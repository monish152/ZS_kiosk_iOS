//
//  kDynamoControllerViewController.m
//  MTSCRADemo
//
//  Created by Tam Nguyen on 8/29/16.
//  Copyright © 2016 MagTek. All rights reserved.
//

#import "kDynamoController.h"
#import "HexUtil.h"
@interface kDynamoController ()
{
    UIView* firstLED;
    UIView* secondLED;
    UIView* thirdLED;
    UIView* fourthLED;
    NSTimer* idleTimer;
}
@end

@implementation kDynamoController

- (void)viewDidLoad {
    [super viewDidLoad];
    int xOffset = 0;
    if([self isX])
    {
        xOffset = 70;
    }
    self.title = @"Lightning EMV";
    
    
    self.lib = [MTSCRA new];
    self.lib.delegate = self;
    

//    self.txtData.frame = CGRectMake(5, 60, 500, 500);
//    self.txtData.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.txtData];
    
    [self.lib setDeviceType:MAGTEKKDYNAMO];
    [self.lib setDeviceProtocolString:@"com.magtek.idynamo"];
    
    self.txtData.text = [NSString stringWithFormat:@"App Version: %@.%@ , SDK Version: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], self.lib.getSDKVersion];
    
    //[self.lib openDevice];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNotified:) name:@"kDynamoData" object:nil];
    [self.btnConnect removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnConnect addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    
    [self addLED];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self connect];
    
}
-(void)appWillResignActive:(NSNotification*)note
{
    [self.lib closeDevice];
}
-(void)appDidBecomeActive:(NSNotification*)note
{
    //[self.lib openDevice];
}
-(IBAction)api:(id)sender{
    
}

- (void) addLED
{
    int xOffset = 0;
    if([self isX])
    {
        xOffset = 70;
    }
    
    firstLED = [[UIView alloc]initWithFrame:CGRectMake(self.btnStartEMV.frame.origin.x, self.btnStartEMV.frame.origin.y - 60 - xOffset, self.btnStartEMV.frame.size.width, self.btnStartEMV.frame.size.height)];
    firstLED.backgroundColor = [UIColor grayColor];
    [self.view addSubview:firstLED];
    
  
}
- (void)onDeviceConnectionDidChange:(MTSCRADeviceType)deviceType connected:(BOOL)connected instance:(id)instance
{
    [super onDeviceConnectionDidChange:deviceType connected:connected instance:instance];
    // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if(deviceType == MAGTEKKDYNAMO)
    {
        if(connected)
        {
            [self setLEDState:1];
            [self.lib sendcommandWithLength:@"480102"];
            
            [self startEMV];
        }
        else
        {
            [self setLEDState:0];
        }
        
    }
     //});
}


- (void)idleTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(firstLED.backgroundColor == [UIColor grayColor])
        {
            
            firstLED.backgroundColor = [UIColor greenColor];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                firstLED.backgroundColor = [UIColor grayColor];
            });
        }
    });
}
- (void)hideLED:(BOOL)hidden
{
    [firstLED setHidden:hidden];
    [secondLED setHidden:hidden];
    [thirdLED setHidden:hidden];
    [fourthLED setHidden: hidden];
}
- (void)setLEDState:(int)state
{
    switch (state) {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                firstLED.backgroundColor = [UIColor grayColor];
                secondLED.backgroundColor = [UIColor grayColor];
                thirdLED.backgroundColor = [UIColor grayColor];
                fourthLED.backgroundColor = [UIColor grayColor];
                [idleTimer invalidate];
                idleTimer = nil;
            });
            break;
        }
        case 1:
        {
            //idle
            firstLED.backgroundColor = [UIColor greenColor];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                firstLED.backgroundColor = [UIColor grayColor];
            });
            idleTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(idleTimer) userInfo:nil repeats:YES];
            

            break;
        }
        case 2:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                firstLED.backgroundColor = [UIColor greenColor];
            });
            break;
        }
        case 3:
        {
            
            float offsetTime = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(offsetTime += .25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                firstLED.backgroundColor = [UIColor greenColor];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(offsetTime += .25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                secondLED.backgroundColor = [UIColor greenColor];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(offsetTime += .25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                thirdLED.backgroundColor = [UIColor greenColor];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(offsetTime += .25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                fourthLED.backgroundColor = [UIColor greenColor];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setLEDState:0];
            });
            
            break;
        }
        default:
            break;
    }
}
-(void)startEMV
{
    [super startEMV];
    [self hideLED:NO];
}

- (void)OnTransactionResult:(NSData *)data
{
    [super OnTransactionResult:data];
    [self setLEDState:0];
    [self setLEDState:1];
}
- (void)OnTransactionStatus:(NSData *)data
{
    [super OnTransactionStatus:data];
    Byte dataBytes[data.length];
    [data getBytes:&dataBytes length:data.length];
    if(dataBytes[0] == 0x04 && dataBytes[2] == 0x01)
    {
        [self setLEDState:0];
        [self setLEDState:2];
    }
    else if (dataBytes[0] == 0x09 && dataBytes[2]== 0x1C)
    {
        [self setLEDState:0];
        [self setLEDState:3];
    }
}

//- (void) gotNotified:(NSNotification *) notification
//{
//    NSDictionary* dataDict = [notification userInfo];
//    NSData*data = [dataDict valueForKey:@"data"];
//
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.txtData.text = [self.txtData.text stringByAppendingString: [NSString stringWithFormat:@"\r\nDebug - Data Length%lu Data %@",(unsigned long)data.length,  data]];
//    });
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onDataReceived:(MTCardData *)cardDataObj instance:(id)instance
{
    [super onDataReceived:cardDataObj instance:instance];
}
-(IBAction)backBtnPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
