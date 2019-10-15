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
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title1.text];
    
//    float letterSpacing = 2.0f; // change spacing here
//    [attributedString addAttribute:NSKernAttributeName value:@(letterSpacing) range:NSMakeRange(0, [title1.text length])];
//    [title1 setAttributedText:attributedString];
    
   
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
