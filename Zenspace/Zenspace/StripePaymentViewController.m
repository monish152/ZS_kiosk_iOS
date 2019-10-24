//
//  StripePaymentViewController.m
//  Zenspace
//
//  Created by Monish on 20/09/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "StripePaymentViewController.h"

@interface StripePaymentViewController ()
{
    
}

@end

@implementation StripePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardNumberField.showsCardLogo = YES;
    self.cardNumberField.font = [UIFont fontWithName:@"CircularStd-Book"
                                        size:16];
    self.cardExpiryField.font = [UIFont fontWithName:@"CircularStd-Book"
                                        size:16];
    _cvcField.font = [UIFont fontWithName:@"CircularStd-Book"
                                        size:16];
    _cardHolderName.font = [UIFont fontWithName:@"CircularStd-Book"
                                     size:16];
    
    [self.cardNumberField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.cardExpiryField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
   
    
    [self.cardNumberField becomeFirstResponder];
    
    
    
    [podImage sd_setImageWithURL:[NSURL URLWithString:_imageurl]
                placeholderImage:[UIImage imageNamed:@""]];
    podImage.layer.cornerRadius = 10;
    podImage.clipsToBounds = YES;
    
    podNameLbl.font = [UIFont fontWithName:@"CircularStd-Bold"
                                      size:16];
    podNameLbl.text = _podName;
    
    poddateLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                      size:14];
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [format dateFromString:_date];
    [format setDateFormat:@"MMM dd, yyyy"];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString* finalDateString = [format stringFromDate:date];
    
    
    poddateLbl.text = finalDateString;
    timeIcon.image = [timeIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [timeIcon setTintColor:[UIColor lightGrayColor]];
    
    
    [format setDateFormat:@"HH:mm"];
    finalDateString = [format stringFromDate:date];
    podtimeLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                      size:14];
    podtimeLbl.text = [NSString stringWithFormat:@"%@ for %ld min",finalDateString,(long)_duration ];
    
    
    dateIcon.image = [dateIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [dateIcon setTintColor:[UIColor lightGrayColor]];
    
    salesTaxLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                       size:16];
    salesPriceLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                         size:16];
    discountLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                       size:16];
    amountDueLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                        size:16];
    
    
    salesPriceValue.font = [UIFont fontWithName:@"CircularStd-Bold"
                                           size:18];
    salesPriceValue.text = [NSString stringWithFormat:@"$%@",_price];
    
    salesTaxValue.font = [UIFont fontWithName:@"CircularStd-Bold"
                                         size:18];
    discountValue.font = [UIFont fontWithName:@"CircularStd-Bold"
                                         size:18];
    
    amountDueValue.font = [UIFont fontWithName:@"CircularStd-Bold"
                                          size:18];
    amountDueValue.text = [NSString stringWithFormat:@"$%@",_price];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CardIOUtilities preloadCardIO];
}
- (void)textFieldEditingChanged:(id)sender
{
    if (sender == self.cardNumberField) {
        
        NSString *cardCompany = self.cardNumberField.cardCompanyName;
        if (nil == cardCompany) {
            cardCompany = @"unknown";
        }
        
        
    } 
}


-(IBAction)backBtnPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)submitBtnPress:(id)sender{
    NSDateComponents *dateComp = self.cardExpiryField.dateComponents;
    STPCardParams *cardParams = [[STPCardParams alloc] init];
    cardParams.number = self.cardNumberField.cardNumber;
    cardParams.expMonth = dateComp.month;
    cardParams.expYear = dateComp.year;
    cardParams.cvc = _cvcField.text;
    cardParams.name = _cardHolderName.text;
    
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error) {
        if (token == nil || error != nil) {
            // Present error to user...
            NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
            NSLog(@"%@",errorDescription);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self dismissViewControllerAnimated:NO completion:nil];
           
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Error: %@", error);
            return;
        }
       
        NSLog(@"token.tokenId :: %@",token.tokenId);
         [self bookingApi:token.tokenId];
        
    }];
}
-(void)bookingApi:(NSString *)transactionID{
    //    return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/reservation/%@/",KBASEPATH,_sfid]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults]
                                                               stringForKey:@"token"]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    
    NSDictionary *params = @{@"startdate":_date,
                             @"duration":[NSNumber numberWithInteger:_duration],
                             @"capacity":[NSNumber numberWithInteger:_capacity],
                             @"stripe_token":transactionID,
                             @"email":_email,
                             @"amount_due":_price,
                             @"save_card":[NSNumber numberWithInteger:0],
                             @"magtek_transaction_id" :@"",
                             @"phonenumber" :_phoneNumber,
                             @"name" :_name
                             };
    
    NSLog(@"Stripe api parameter : %@",params);
    
    [manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [responseObject objectForKey:@"result"];
        BookingConfirmationViewController *vc = [[BookingConfirmationViewController alloc] initWithNibName:@"BookingConfirmationViewController" bundle:nil];
        vc.userKey = [dict valueForKey:@"userkey"];
        vc.podName = self->_podName;
        vc.date = self->_date;
        vc.duration = [NSString stringWithFormat:@"%ld",(long)self->_duration];
        vc.imageurl = self->_imageurl;
        vc.price = self->_price;
        vc.capacity = self->_capacity;
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *parameters = [NSString stringWithFormat:@"%@", params];
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :parameters :errorDescription];
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _cvcField) {
        if (textField.text.length >= 3 && range.length == 0)
        {
            [_cardHolderName becomeFirstResponder];
            return NO; // return NO to not change text
        }
    }
    
   
    if (self.cardNumberField.cardNumber.length >10 && _cvcField.text.length == 3 && self.cardExpiryField.text.length ==7 && _cardHolderName.text.length >= 3) {
        submit.enabled = YES;
        submit.alpha = 1.0;
    }
    else{
        submit.enabled = NO;
        submit.alpha = 0.5;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (IBAction)scanCard:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    // Use the card info...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
