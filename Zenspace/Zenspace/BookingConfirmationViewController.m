//
//  BookingSummaryViewController.m
//  Zenspace
//
//  Created by Monish on 13/08/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "BookingConfirmationViewController.h"

@interface BookingConfirmationViewController ()

@end

@implementation BookingConfirmationViewController
@synthesize transactionId;
- (void)viewDidLoad {
    self.navigationController.navigationBarHidden = YES;
     title1.font = [UIFont fontWithName:@"Roboto-Medium"
                                     size:24];
       
      
       submit.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium"
                                                size:16];
       submit.layer.cornerRadius = 40;
   
    title2.font = [UIFont fontWithName:@"Roboto-Medium"
                                       size:16];
   
    
    [podImage sd_setImageWithURL:[NSURL URLWithString:_imageurl]
                placeholderImage:[UIImage imageNamed:@""]];
   
    
     podNameLbl.font = [UIFont fontWithName:@"Roboto-Medium"
                                         size:20];
       podNameLbl.text = _podName;
       
       poddateLbl.font = [UIFont fontWithName:@"Roboto-Regular"
                                         size:14];
       
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
     [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [format dateFromString:_date];
    [format setDateFormat:@"MMM dd, yyyy"];
    NSString* finalDateString = [format stringFromDate:date];
    
    
    poddateLbl.text = finalDateString;
    timeIcon.image = [timeIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [timeIcon setTintColor:[UIColor lightGrayColor]];
    
    
    [format setDateFormat:@"HH:mm"];
    finalDateString = [format stringFromDate:date];
     podtimeLbl.font = [UIFont fontWithName:@"Roboto-Regular"
                                         size:14];
    podtimeLbl.text = [NSString stringWithFormat:@"%@ for %@ min",finalDateString,_duration ];
    
    
    dateIcon.image = [dateIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [dateIcon setTintColor:[UIColor lightGrayColor]];
    
    amountDueLbl.font = [UIFont fontWithName:@"Roboto-Medium"
                                        size:16];
    
    

    
    amountDueValue.font = [UIFont fontWithName:@"Roboto-Medium"
                                          size:18];
    amountDueValue.text = [NSString stringWithFormat:@"$%@",_price];
    
    
    unlockCode.font = [UIFont fontWithName:@"Roboto-Medium"
                                      size:20];
    unlockCode.text = [NSString stringWithFormat:@"%@",_userKey];
    
    
    wifiCode.font = [UIFont fontWithName:@"Roboto-Medium"
                                    size:20];
   
    
    
    unlockLbl.font = [UIFont fontWithName:@"Roboto-Medium"
                                     size:16];
    
    NSTimer *timer;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0*10
                                             target: self
                                           selector: @selector(backToCalenderScreen)
                                           userInfo: nil
                                            repeats: NO];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    NSArray *viewControllers = self.navigationController.viewControllers;
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[SelectionViewController class]]){
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
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
        if([obj isKindOfClass:[GroupsListViewController class]]){
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
    
}
-(void)backToCalenderScreen{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[SelectionViewController class]]){
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
}
-(IBAction)submitBtnPress:(id)sender{
    if (![email.text isEqualToString:@""]) {
        if (![self validateEmailWithString:email.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Please provide valid email address" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    
    if (![phone.text isEqualToString:@""]) {
        if (phone.text.length <11) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Please provide valid phone number" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
            
        }
        
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[SelectionViewController class]]){
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
    
    
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(IBAction)helpButtonpressed:(id)sender{
    SupportScreen1ViewController *vc = [[SupportScreen1ViewController alloc] initWithNibName:@"SupportScreen1ViewController" bundle:nil];
       [self.navigationController pushViewController:vc animated:YES];
}
@end
