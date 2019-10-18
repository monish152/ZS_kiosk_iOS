//
//  SupportScreen1ViewController.m
//  ZenspaceOutdoor
//
//  Created by Monish on 10/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "SupportSubmitViewController.h"

@interface SupportSubmitViewController ()

@end

@implementation SupportSubmitViewController

- (void)viewDidLoad {
    selectedOption = @"";
    title1.font = [UIFont fontWithName:@"Roboto-Medium"
                                  size:24];
    title2.font = [UIFont fontWithName:@"Roboto-Regular"
                                  size:18];
    title3.font = [UIFont fontWithName:@"Roboto-Regular"
                                  size:18];
    

    emailTxtFld.font = [UIFont fontWithName:@"Roboto-Regular"
                                  size:16];
    phoneTxtFld.font = [UIFont fontWithName:@"Roboto-Regular"
                                       size:16];
    nameTxtFld.font = [UIFont fontWithName:@"Roboto-Regular"
                                       size:16];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title1.text];
    
    float letterSpacing = 3.0f; // change spacing here
    [attributedString addAttribute:NSKernAttributeName value:@(letterSpacing) range:NSMakeRange(0, [title1.text length])];
    [title1 setAttributedText:attributedString];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 16)];
    imgView.image = [UIImage imageNamed:@"email_icon"];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [paddingView addSubview:imgView];
    [emailTxtFld setLeftViewMode:UITextFieldViewModeAlways];
    [emailTxtFld setLeftView:paddingView];
    
    
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 8, 18, 18)];
    imgView.image = [UIImage imageNamed:@"name_textfield"];
    
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [paddingView addSubview:imgView];
    [nameTxtFld setLeftViewMode:UITextFieldViewModeAlways];
    [nameTxtFld setLeftView:paddingView];
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 4, 14, 22)];
    imgView.image = [UIImage imageNamed:@"phone_textField"];
    
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [paddingView addSubview:imgView];
    [phoneTxtFld setLeftViewMode:UITextFieldViewModeAlways];
    [phoneTxtFld setLeftView:paddingView];
    
    submitBtn.layer.cornerRadius = 40;
    
    

   
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
-(IBAction)phoneButtonPressed:(id)sender{
    selectedOption = @"phonenumber";
    [phoneBtn setImage:[UIImage imageNamed:@"phone_Selected"] forState:UIControlStateNormal];
    [emailBtn setImage:[UIImage imageNamed:@"email_unSelected"] forState:UIControlStateNormal];
}
-(IBAction)emailButtonPressed:(id)sender{
    selectedOption = @"email";
    [phoneBtn setImage:[UIImage imageNamed:@"mobile_unSelected"] forState:UIControlStateNormal];
    [emailBtn setImage:[UIImage imageNamed:@"emailSelecgted"] forState:UIControlStateNormal];
}
-(IBAction)submitButtonPressed:(id)sender{
    if (![emailTxtFld.text isEqualToString:@""]) {
        if (![self validateEmailWithString:emailTxtFld.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Please provide valid email address." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
    if (![phoneTxtFld.text isEqualToString:@""]) {
        if (phoneTxtFld.text.length <9) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Please provide valid phone number." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
            
        }
        
    }
    
    if ([emailTxtFld.text isEqualToString:@""] && [phoneTxtFld.text isEqualToString:@""]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Zenspace"
                                     message:@"Please provide email id or password."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                       
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    if ([selectedOption isEqualToString:@""] ) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Zenspace"
                                     message:@"Please select preferred method to contact you."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    [self submitSupport];
}
-(void)submitSupport{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/user/createticket/",KBASEPATH]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults]
                                                               stringForKey:@"token"]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    
    NSDictionary *params = @{
                             @"appName":@"Kiosk App",
                             @"issueType":@"general",
                             @"name":nameTxtFld.text,
                             @"phoneNumber":phoneTxtFld.text,
                             @"email":emailTxtFld.text,
                             @"issuedetail1":_issueType,
                             @"preferredContact":selectedOption,
                             @"issuedetail2":@""
                             };
    
    [manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *dict = [responseObject objectForKey:@"result"];
        if ([dict isEqualToString:@"Ticket Generated"]) {
            SupportSuccessViewController *vc = [[SupportSuccessViewController alloc] initWithNibName:@"SupportSuccessViewController" bundle:nil];
              
               [self.navigationController pushViewController:vc animated:YES];
        }
       
        
        
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
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
