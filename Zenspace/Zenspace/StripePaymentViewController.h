//
//  StripePaymentViewController.h
//  Zenspace
//
//  Created by Monish on 20/09/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/Stripe.h>
#import "MBProgressHUD.h"
#import "BookingConfirmationViewController.h"
#import "BKCardNumberField.h"
#import "BKCardExpiryField.h"
#import "CardIO.h"
NS_ASSUME_NONNULL_BEGIN

@interface StripePaymentViewController : UIViewController<UITextFieldDelegate,CardIOPaymentViewControllerDelegate>{
    IBOutlet UIButton *submit;
    IBOutlet UIButton *scanCard;
    
    
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
}

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
@property (nonatomic,retain)NSString *transactionAmount;

@property (weak, nonatomic) IBOutlet BKCardExpiryField *cardExpiryField;
@property (weak, nonatomic) IBOutlet BKCardNumberField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *cvcField;
@property (weak, nonatomic) IBOutlet UITextField *cardHolderName;


@end

NS_ASSUME_NONNULL_END
