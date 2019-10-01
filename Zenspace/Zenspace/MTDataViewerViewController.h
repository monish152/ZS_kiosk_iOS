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
    
    
    NSString *transactionid;
    BOOL paymentApproved;
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

@property (nonatomic, strong)IBOutlet UIView *cardView;
@property (nonatomic, strong)IBOutlet UILabel *swipeCardLbl;
-(IBAction)api:(id)sender;
- (NSString *)getHexString:(NSData *)data;
-(void) onDeviceConnectionDidChange:(MTSCRADeviceType)deviceType connected:(BOOL)connected instance:(id)instance;
- (void)onDeviceResponse:(NSData *)data;
- (void)onDeviceError:(NSError *)error;
- (void) setText:(NSString*)text;
- (void)deviceNotPaired;
- (void)setDateTime;
@end
