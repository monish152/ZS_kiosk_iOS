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
NS_ASSUME_NONNULL_BEGIN

@interface StripePaymentViewController : UIViewController<STPPaymentCardTextFieldDelegate,STPAddCardViewControllerDelegate>{
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
@end

NS_ASSUME_NONNULL_END
