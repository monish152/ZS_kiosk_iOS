//
//  LogicalPodViewController.m
//  ZenspaceOutdoor
//
//  Created by Monish on 18/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "ScreensaverViewController.h"

@interface ScreensaverViewController ()

@end

@implementation ScreensaverViewController
@synthesize physicalPodName;
- (void)viewDidLoad {
    submitBtn.layer.cornerRadius = 10;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getList];
    
    [NSTimer scheduledTimerWithTimeInterval:1*60*60
                                     target:self
                                   selector:@selector(getList)
                                   userInfo:nil
                                    repeats:NO];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hitRefresh"
                                                            object:nil];
    }];
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
            NSString*imgName = [[arrResults objectAtIndex:0] valueForKey:@"screen_saver__c"];
            if (!imgName || [imgName isKindOfClass:[NSNull class]])
            {
                
            }
            else{
                [self->imgView sd_setImageWithURL:[NSURL URLWithString:imgName]
                                 placeholderImage:[UIImage imageNamed:@""]];
            }
            
        }
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
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


@end
