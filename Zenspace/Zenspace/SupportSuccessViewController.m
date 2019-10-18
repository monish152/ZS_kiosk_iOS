//
//  SupportScreen1ViewController.m
//  ZenspaceOutdoor
//
//  Created by Monish on 10/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "SupportSuccessViewController.h"

@interface SupportSuccessViewController ()

@end

@implementation SupportSuccessViewController

- (void)viewDidLoad {
    
    title1.font = [UIFont fontWithName:@"Roboto-Regular"
                                  size:40];
    title2.font = [UIFont fontWithName:@"Roboto-Regular"
                                  size:24];
    title3.font = [UIFont fontWithName:@"Roboto-Regular"
                                  size:16];
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
