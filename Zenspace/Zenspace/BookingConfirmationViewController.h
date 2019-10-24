//
//  BookingSummaryViewController.h
//  Zenspace
//
//  Created by Monish on 13/08/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "GlobalKeyViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProcessCardViewController.h"
#import "CalenderViewController.h"
#import "SupportScreen1ViewController.h"
#import "SelectionViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BookingConfirmationViewController : UIViewController<GlobalKeyViewControllerDelegate>{
    IBOutlet UILabel *title1;
    IBOutlet UILabel *title2;
    IBOutlet UIButton *submit;
    
    IBOutlet UILabel *podNameLbl;
    IBOutlet UILabel *poddateLbl;
    IBOutlet UILabel *podtimeLbl;
    IBOutlet UIImageView *podImage;
   
    IBOutlet UILabel *amountDueLbl;
    IBOutlet UILabel *amountDueValue;
    
    IBOutlet UIImageView *dateIcon;
    IBOutlet UIImageView *timeIcon;
    
    IBOutlet UITextField *email;
    IBOutlet UITextField *phone;
    IBOutlet UITextField *name;
    
    IBOutlet UILabel *unlockCode;
    IBOutlet UILabel *wifiCode;
    
    IBOutlet UILabel *unlockLbl;
    

    
}
@property(nonatomic,retain)NSString *podName;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,retain)NSString *duration;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *imageurl;
@property(nonatomic,retain)NSString *transactionId;
@property(nonatomic,retain)NSString *userKey;
@property(nonatomic,assign)NSInteger capacity;
-(IBAction)backBtnPress:(id)sender;
-(IBAction)submitBtnPress:(id)sender;
@end

NS_ASSUME_NONNULL_END
