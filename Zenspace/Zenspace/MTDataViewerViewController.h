//
//  MTDataViewerViewController.h
//  MTSCRADemo
//
//  Created by Tam Nguyen on 7/21/15.
//  Copyright (c) 2015 MagTek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MTSCRA.h"
#import "HexUtil.h"
#import "NSObject+TLVParser.h"
@interface MTDataViewerViewController : UIViewController < UITextFieldDelegate, UIActionSheetDelegate,UISearchBarDelegate>
{
      BOOL devicePaired;
    
    
    NSString *ksnStr;
    NSString *encryptionType;
    NSString *paddedBytes;

    NSString *deviceSNStr;
    NSString *magnePrintStr;
    NSString *magnePrintStatus;
    NSString *track1Str;
    NSString *track2Str;
    
}
- (void)connect;
- (BOOL)isX;
@property (nonatomic, strong) UIButton* btnConnect ;
@property (nonatomic, strong) UIButton* btnSendCommand ;
@property (atomic, strong) IBOutlet UITextView* txtData;
@property (nonatomic, strong) UITextField* txtCommand;
@property (nonatomic, strong) MTSCRA* lib;
@property (nonatomic, strong) UIButton* btnGetSN ;
@property (nonatomic, strong) NSString *cardPaymentStatus;
@property (nonatomic, strong) NSString *transactionAmount;

@property (nonatomic, strong) NSString *transactionid;

@property (nonatomic, strong)IBOutlet UIView *cardView;
@property (nonatomic, strong)IBOutlet UILabel *swipeCardLbl;

@property(nonatomic,retain)NSString *podName;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,assign)NSInteger duration;
@property(nonatomic,assign)NSInteger capacity;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *imageurl;
@property(nonatomic,retain)NSString *sfid;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *phoneNumber;





-(IBAction)getSwipeCard;
- (NSString *)getHexString:(NSData *)data;
-(void) onDeviceConnectionDidChange:(MTSCRADeviceType)deviceType connected:(BOOL)connected instance:(id)instance;
- (void)onDeviceResponse:(NSData *)data;
- (void)onDeviceError:(NSError *)error;
- (void) setText:(NSString*)text;
- (void)deviceNotPaired;
- (void)setDateTime;
@end
