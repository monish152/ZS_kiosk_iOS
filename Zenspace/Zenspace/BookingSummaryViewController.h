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
#import "EventsListViewController.h"
#import "PCCPViewController.h"
#import "StripePaymentViewController.h"
#import <Stripe/Stripe.h>
#import "SupportScreen1ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookingSummaryViewController : UIViewController<GlobalKeyViewControllerDelegate,STPPaymentCardTextFieldDelegate,STPAddCardViewControllerDelegate>{
    IBOutlet UILabel *title1;
    IBOutlet UILabel *title2;
    IBOutlet UIButton *submit;
    
    IBOutlet UILabel *podNameLbl;
    IBOutlet UILabel *poddateLbl;
    IBOutlet UILabel *podtimeLbl;
    IBOutlet UIImageView *podImage;
    IBOutlet UILabel *salesPriceLbl;
    IBOutlet UILabel *salesTaxLbl;
    IBOutlet UILabel *discountLbl;
    IBOutlet UILabel *amountDueLbl;
    
    IBOutlet UILabel *salesPriceValue;
    IBOutlet UILabel *salesTaxValue;
    IBOutlet UILabel *discountValue;
    IBOutlet UILabel *amountDueValue;
    
    IBOutlet UIImageView *dateIcon;
    IBOutlet UIImageView *timeIcon;
    
    IBOutlet UITextField *email;
    IBOutlet UITextField *phone;
    IBOutlet UITextField *name;
    
    IBOutlet UIImageView *flag;
    IBOutlet UILabel *countryCode;
    
    NSString *countrycodeStr;
    
    NSString *amountDue;
}
@property(nonatomic,retain)NSString *podName;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,assign)NSInteger duration;
@property(nonatomic,assign)NSInteger capacity;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *imageurl;
@property(nonatomic,retain)NSString *sfid;

-(IBAction)backBtnPress:(id)sender;
-(IBAction)submitBtnPress:(id)sender;
-(IBAction)changeCountry:(id)sender;
@end

NS_ASSUME_NONNULL_END
