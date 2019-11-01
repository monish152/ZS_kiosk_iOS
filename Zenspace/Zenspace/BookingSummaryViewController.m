//
//  BookingSummaryViewController.m
//  Zenspace
//
//  Created by Monish on 13/08/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "BookingSummaryViewController.h"
#import "kDynamoController.h"
@interface BookingSummaryViewController ()

@end

@implementation BookingSummaryViewController

- (void)viewDidLoad {
    self.navigationController.navigationBarHidden = YES;
    title1.font = [UIFont fontWithName:@"Roboto-Medium"
                                  size:24];
    
   
    submit.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium"
                                             size:16];
    submit.layer.cornerRadius = 25;
    
    [podImage sd_setImageWithURL:[NSURL URLWithString:_imageurl]
                placeholderImage:[UIImage imageNamed:@""]];
   
    
    podNameLbl.font = [UIFont fontWithName:@"Roboto-Medium"
                                      size:20];
    podNameLbl.text = _podName;
    
    poddateLbl.font = [UIFont fontWithName:@"Roboto-Regular"
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
    
    
    [format setDateFormat:@"HH:mm a"];
    finalDateString = [format stringFromDate:date];
    podtimeLbl.font = [UIFont fontWithName:@"Roboto-Regular"
                                      size:14];
    podtimeLbl.text = [NSString stringWithFormat:@"%@ for %ld min",finalDateString,(long)_duration ];
    
    
    dateIcon.image = [dateIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [dateIcon setTintColor:[UIColor lightGrayColor]];
    
    salesTaxLbl.font = [UIFont fontWithName:@"Roboto-Regular"
                                       size:14];
    salesPriceLbl.font = [UIFont fontWithName:@"Roboto-Regular"
                                         size:14];
    discountLbl.font = [UIFont fontWithName:@"Roboto-Regular"
                                       size:14];
    amountDueLbl.font = [UIFont fontWithName:@"Roboto-Regular"
                                        size:14];
    
    
    salesPriceValue.font = [UIFont fontWithName:@"Roboto-Medium"
                                           size:14];
    salesPriceValue.text = [NSString stringWithFormat:@"$%@",_price];
    
    salesTaxValue.font = [UIFont fontWithName:@"Roboto-Medium"
                                         size:14];
    discountValue.font = [UIFont fontWithName:@"Roboto-Medium"
                                         size:14];
    
    amountDueValue.font = [UIFont fontWithName:@"Roboto-Medium"
                                          size:14];
    amountDueValue.text = [NSString stringWithFormat:@"$%@",_price];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 16)];
       imgView.image = [UIImage imageNamed:@"email_icon"];
       
       UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
       [paddingView addSubview:imgView];
       [email setLeftViewMode:UITextFieldViewModeAlways];
       [email setLeftView:paddingView];
       
       
       
       imgView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 8, 18, 18)];
       imgView.image = [UIImage imageNamed:@"name_textfield"];
       
       paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
       [paddingView addSubview:imgView];
       [name setLeftViewMode:UITextFieldViewModeAlways];
       [name setLeftView:paddingView];
       
       imgView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 4, 14, 22)];
       imgView.image = [UIImage imageNamed:@"phone_textField"];
       
       paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
       [paddingView addSubview:imgView];
       [phone setLeftViewMode:UITextFieldViewModeAlways];
       [phone setLeftView:paddingView];
    
    
    [self updateViewsWithCountryDic:[PCCPViewController infoFromSimCardAndiOSSettings]];
    
    [self getPrice];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    NSString *apiCall = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"stripe"];
    if([apiCall isEqualToString:@"Yes"]){
        [self stripe:@""];
        NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
        [def setObject:@"NO" forKey:@"stripe"];
        [def synchronize];
    }
}
-(void)getPrice{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/reservation/amount/",KBASEPATH]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults]
                                                               stringForKey:@"token"]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    
    NSDictionary *params = @{
                             @"duration":[NSNumber numberWithInteger:_duration],
                             @"sfid":_sfid
                             };
    
    [manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [responseObject objectForKey:@"result"];
        self->amountDue  = [dict valueForKey:@"amount_due"];
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *parameters = [NSString stringWithFormat:@"%@", params];
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :parameters :errorDescription];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(IBAction)backBtnPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)settingButtonPressed:(id)sender{
    GlobalKeyViewController *vc = [[GlobalKeyViewController alloc] initWithNibName:@"GlobalKeyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
}
- (void)GlobalKeyViewControllerDelegateMethod :(NSString *)emailId{
    GlobalKeyViewController *vc = [[GlobalKeyViewController alloc] initWithNibName:@"GlobalKeyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.emailId = emailId;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
    
}
- (void)PopViewToMainView :(NSString *)emailId{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[EventsListViewController class]]){
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
    
}
-(IBAction)submitBtnPress:(id)sender{
    if (![email.text isEqualToString:@""]) {
        if (![self validateEmailWithString:email.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Please provide valid email address." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
    if (![phone.text isEqualToString:@""]) {
        if (phone.text.length <9) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Please provide valid phone number." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
            
        }
        
    }
    
    if ([email.text isEqualToString:@""] && [phone.text isEqualToString:@""]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Zenspace"
                                     message:@"You didn't provide email id or phone number. In this case you need to remember Access code. Are You Sure Want to Continue!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        [self apiCall];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        //Add your buttons to alert controller
        
        
        [alert addAction:noButton];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else{
        [self apiCall];
    }
    
    
}
-(void)apiCall{
    _price = [NSString stringWithFormat:@"%@",_price];
//    _price = @"0.5";
    if ([_price isEqualToString:@"0"]) {
        [self bookingApi];
    }
    else{
        NSString *number = @"";
        if (![phone.text isEqualToString:@""]) {
            number = [NSString stringWithFormat:@"+%@%@",countrycodeStr,phone.text];
        }
    
     
//        StripePaymentViewController *vc = [[StripePaymentViewController alloc] initWithNibName:@"StripePaymentViewController" bundle:nil];
//        NSString *amount = [NSString stringWithFormat:@"%@", _price];
//        vc.transactionAmount =amount ;
//        vc.sfid = _sfid;
//        vc.podName = self->_podName;
//        vc.date = self->_date;
//        vc.duration = _duration;
//        vc.imageurl = self->_imageurl;
//        vc.price = amountDue;
//        vc.capacity = self->_capacity;
//        vc.email = email.text;
//        vc.phoneNumber = number;
//        vc.name = name.text;
//        [self.navigationController pushViewController:vc animated:YES];
        
        
       
        kDynamoController *vc = [[kDynamoController alloc] initWithNibName:@"kDynamoController" bundle:nil];
        CGFloat value = [_price floatValue] *100;
        NSString *amount = [NSString stringWithFormat:@"%f",value];
        NSInteger i = [amount integerValue];
        amount = [NSString stringWithFormat:@"%ld", (long)i];
        // you got your string
        
        vc.transactionAmount =amount ;
        vc.sfid = _sfid;
        vc.podName = self->_podName;
        vc.date = self->_date;
        vc.duration = _duration;
        vc.imageurl = self->_imageurl;
        vc.price = amountDue;
        vc.capacity = self->_capacity;
        vc.email = email.text;
        vc.phoneNumber = number;
        vc.name = name.text;
        [self.navigationController pushViewController:vc animated:YES];
       
   
        /*
        ProcessCardViewController *vc = [[ProcessCardViewController alloc] initWithNibName:@"ProcessCardViewController" bundle:nil];
        CGFloat value = [_price floatValue] *100;
        NSString *amount = [NSString stringWithFormat:@"%f",value];
        NSInteger i = [amount integerValue];
        amount = [NSString stringWithFormat:@"%ld", (long)i];
        // you got your string
        vc.transactionAmount =amount ;
        vc.sfid = _sfid;
        vc.podName = self->_podName;
        vc.date = self->_date;
        vc.duration = _duration;
        vc.imageurl = self->_imageurl;
        vc.price = amountDue;
        vc.capacity = self->_capacity;
        vc.email = email.text;
        vc.phoneNumber = number;
        vc.name = name.text;
        
        [self.navigationController pushViewController:vc animated:YES];
         */
    }
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(void)bookingApi{
    
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
    
    NSString *number = @"";
    if (![phone.text isEqualToString:@""]) {
        number = [NSString stringWithFormat:@"+%@%@",countrycodeStr,phone.text];
    }
    
    NSDictionary *params = @{@"startdate":_date,
                             @"duration":[NSNumber numberWithInteger:_duration],
                             @"capacity":[NSNumber numberWithInteger:_capacity],
                             @"stripe_source":@"",
                             @"email":email.text,
                             @"amount_due":[NSNumber numberWithInteger:0],
                             @"save_card":[NSNumber numberWithInteger:0],
                             @"magtek_transaction_id" :@"",
                             @"phonenumber" :number,
                             @"booked_through" :@"App",
                             @"name" :name.text
                             };
    
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
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *parameters = [NSString stringWithFormat:@"%@", params];
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :parameters :errorDescription];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
- (IBAction)changeCountry:(id)sender {
    PCCPViewController * vc = [[PCCPViewController alloc] initWithCompletion:^(id countryDic) {
        [self updateViewsWithCountryDic:countryDic];
    }];
    [vc setIsUsingChinese:NO];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naviVC animated:YES completion:NULL];
}

- (void)updateViewsWithCountryDic:(NSDictionary*)countryDic{
    //    [_label setText:[NSString stringWithFormat:@"country_code: %@\ncountry_en: %@\ncountry_cn: %@\nphone_code: %@",countryDic[@"country_code"],countryDic[@"country_en"],countryDic[@"country_cn"],countryDic[@"phone_code"]]];
    [flag setImage:[PCCPViewController imageForCountryCode:countryDic[@"country_code"]]];
    countryCode.text = countryDic[@"country_code"];
    countrycodeStr = countryDic[@"phone_code"];
}
#pragma mark STPAddCardViewControllerDelegate

- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    // Dismiss add card view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addCardViewController:(STPAddCardViewController *)addCardViewController didCreateToken:(STPToken *)token completion:(STPErrorBlock)completion{
    [self bookingApi:token.tokenId];
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
    NSString *number = @"";
    if (![phone.text isEqualToString:@""]) {
        number = [NSString stringWithFormat:@"+%@%@",countrycodeStr,phone.text];
    }
    NSDictionary *params = @{@"startdate":_date,
                             @"duration":[NSNumber numberWithInteger:_duration],
                             @"capacity":[NSNumber numberWithInteger:_capacity],
                             @"stripe_token":transactionID,
                             @"email":email.text,
                             @"amount_due":_price,
                             @"save_card":[NSNumber numberWithInteger:0],
                             @"magtek_transaction_id" :@"",
                             @"phonenumber" :number,
                             @"booked_through" :@"App",
                             @"name" :name.text
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
-(IBAction)helpButtonpressed:(id)sender{
    SupportScreen1ViewController *vc = [[SupportScreen1ViewController alloc] initWithNibName:@"SupportScreen1ViewController" bundle:nil];
       [self.navigationController pushViewController:vc animated:YES];
}
- (void)stripe :(NSString *)emailId{
  NSString *number = @"";
          if (![phone.text isEqualToString:@""]) {
              number = [NSString stringWithFormat:@"+%@%@",countrycodeStr,phone.text];
          }
      
       
          StripePaymentViewController *vc = [[StripePaymentViewController alloc] initWithNibName:@"StripePaymentViewController" bundle:nil];
          NSString *amount = [NSString stringWithFormat:@"%@", _price];
          vc.transactionAmount =amount ;
          vc.sfid = _sfid;
          vc.podName = self->_podName;
          vc.date = self->_date;
          vc.duration = _duration;
          vc.imageurl = self->_imageurl;
          vc.price = amountDue;
          vc.capacity = self->_capacity;
          vc.email = email.text;
          vc.phoneNumber = number;
          vc.name = name.text;
          [self.navigationController pushViewController:vc animated:YES];
}
@end
