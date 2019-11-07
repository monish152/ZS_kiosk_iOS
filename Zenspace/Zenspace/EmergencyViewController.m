//
//  SupportScreen1ViewController.m
//  ZenspaceOutdoor
//
//  Created by Monish on 10/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "EmergencyViewController.h"

@interface EmergencyViewController ()

@end

@implementation EmergencyViewController

- (void)viewDidLoad {
    
   title1.font = [UIFont fontWithName:@"Roboto-Medium"
                                 size:24];
   title2.font = [UIFont fontWithName:@"Roboto-Regular"
                                 size:24];
    title3.font = [UIFont fontWithName:@"Roboto-Regular"
    size:24];
    
    zenCall.font = [UIFont fontWithName:@"Roboto-Bold"
                                 size:36];
    emergencyCall.font = [UIFont fontWithName:@"Roboto-Bold"
    size:36];
    [self getList];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)getList{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return;
    }
    
    NSString *ppnName = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"ppn"];
    NSString *apiCall = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"apiCall"];
    NSString* webStringURL ;
    
    if([apiCall isEqualToString:@"event"]){
        webStringURL = [[NSString stringWithFormat:@"%@api/pod/event/%@/",KBASEPATH,ppnName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        webStringURL = [[NSString stringWithFormat:@"%@api/pod/group/%@/",KBASEPATH,ppnName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
        
    NSURL* URL = [NSURL URLWithString:webStringURL];
    
  
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:25];
    
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults]
                                                               stringForKey:@"token"]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [responseObject objectForKey:@"result"];
        id arrResponse = dict;
        if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
        {
            NSArray *arrResults =  arrResponse;
            NSString*number = [[arrResults objectAtIndex:0] valueForKey:@"zenspace_contact_number__c"];
            if (!number || [number isKindOfClass:[NSNull class]])
            {
                
            }
            else{
                zenCall.text = number;
            }
            
        }
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :@"" :errorDescription];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (data && data != nil) {
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *string = [NSString stringWithFormat:@"System Error."];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:string preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        
        
    }];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
