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
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
