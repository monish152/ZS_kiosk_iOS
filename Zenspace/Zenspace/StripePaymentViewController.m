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
    
//    self.paymentCardTextField = [[STPPaymentCardTextField alloc] init];
//    self.paymentCardTextField.delegate = self;
//
//    // Add payment card text field to view
//    [self.view addSubview:self.paymentCardTextField];
    
    // Setup customer context
    STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
    addCardViewController.delegate = self;
    
    // Present add card view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark STPPaymentCardTextFieldDelegate

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
    
    //    NSDictionary *params = @{@"startdate":_date,
    //                             @"duration":[NSNumber numberWithInteger:_duration],
    //                             @"capacity":[NSNumber numberWithInteger:_capacity],
    //                             @"stripe_source":@"",
    //                             @"email":_email,
    //                             @"amount_due":[NSNumber numberWithInteger:[_price integerValue]],
    //                             @"save_card":[NSNumber numberWithInteger:0],
    //                             @"magtek_transaction_id" :@"",
    //                             @"phonenumber" :number,
    //                             @"name" :name.text
    //                             };
    
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
//- (void)addCardViewController:(STPAddCardViewController *)addCardViewController didCreatePaymentMethod:(STPPaymentMethod *)paymentMethod completion:(STPErrorBlock)completion {
////    [self submitPaymentMethodToBackend:paymentMethod completion:^(NSError *error) {
////        if (error) {
////            // Show error in add card view controller
////            completion(error);
////        }
////        else {
////            // Notify add card view controller that token creation was handled successfully
////            completion(nil);
////
////            // Dismiss add card view controller
////            [self dismissViewControllerAnimated:YES completion:nil];
////        }
////    }];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
