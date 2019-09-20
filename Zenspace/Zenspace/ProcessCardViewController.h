//
//  ProcessCardViewController.h
//  Zenspace
//
//  Created by Monish on 02/08/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSCRA.h"
#import "HexUtil.h"
#import "NSObject+TLVParser.h"
#import "AFNetworking.h"
#import "GlobalKeyViewController.h"
#import "GroupsListViewController.h"
#import "MBProgressHUD.h"
#import "BookingConfirmationViewController.h"
#define ARQC_DYNAPRO_FORMAT 0x01
#define ARQC_EDYNAMO_FORMAT 0x00
NS_ASSUME_NONNULL_BEGIN



@interface ProcessCardViewController : UIViewController<NSXMLParserDelegate,MTSCRAEventDelegate,GlobalKeyViewControllerDelegate>{
    IBOutlet UIView *cardView;
    IBOutlet UILabel *swipeCardLbl;
    
    NSString  *currentElement;

    BOOL devicePaired;
    NSTimer* tmrTimeout;
    Byte tempAmount[6];
    unsigned char amount[6];
    Byte currencyCode[2];
    Byte cashBack[6];
    Byte arqcFormat;
    IBOutlet UITextView *txtData;
    
    NSString *cardPaymentStatus;
    NSString *ksnStr;
    NSString *encryptionType;
    NSString *paddedBytes;
    
    
    NSString *transactionid;
    BOOL paymentApproved;
    
    NSString *megPrint;
    NSString *track1;
    NSString *track2;
    
}
@property (nonatomic, strong) MTSCRA* lib;
@property (nonatomic,retain)NSString *transactionAmount;
- (IBAction)startEMV:(id)sender;

-(IBAction)startApi:(id)sender;
- (NSString *)getHexString:(NSData *)data;
-(void) onDeviceConnectionDidChange:(MTSCRADeviceType)deviceType connected:(BOOL)connected instance:(id)instance;
- (void)onDeviceResponse:(NSData *)data;
- (void)onDeviceError:(NSError *)error;
- (void) setText:(NSString*)text;
- (void)deviceNotPaired;
- (void)setDateTime;

-(IBAction)backBtnPress:(id)sender;
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

@end


NS_ASSUME_NONNULL_END
