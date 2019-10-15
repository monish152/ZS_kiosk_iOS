//
//  SupportScreen1ViewController.m
//  ZenspaceOutdoor
//
//  Created by Monish on 10/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "SupportScreen2ViewController.h"

@interface SupportScreen2ViewController ()

@end

@implementation SupportScreen2ViewController

- (void)viewDidLoad {
    
    arr = @[@"Issue Related to Payment",
            @"Issue Related to Unlock Code",
            @"Issue Related to Reservation​",
            @"Didn’t receive the unlock code",
            @"Other​ ..."];
    
    title1.font = [UIFont fontWithName:@"Roboto-Medium"
                                  size:24];
    title2.font = [UIFont fontWithName:@"Roboto-Regular"
                                  size:18];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title1.text];
    
    float letterSpacing = 3.0f; // change spacing here
    [attributedString addAttribute:NSKernAttributeName value:@(letterSpacing) range:NSMakeRange(0, [title1.text length])];
    [title1 setAttributedText:attributedString];

}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)selectOption:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - 101;
    SupportSubmitViewController *vc = [[SupportSubmitViewController alloc] initWithNibName:@"SupportSubmitViewController" bundle:nil];
    vc.issueType = [arr objectAtIndex:index];
    [self.navigationController pushViewController:vc animated:YES];
    
   
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
