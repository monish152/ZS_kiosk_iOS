//
//  SupportScreen1ViewController.m
//  ZenspaceOutdoor
//
//  Created by Monish on 10/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "SupportScreen1ViewController.h"

@interface SupportScreen1ViewController ()

@end

@implementation SupportScreen1ViewController

- (void)viewDidLoad {
    
   
    
    
   
    
    
    title1.font = [UIFont fontWithName:@"Roboto-Medium"
                                    size:24];
    title2.font = [UIFont fontWithName:@"Roboto-Regular"
                                    size:18];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title1.text];
    
    float letterSpacing = 3.0f; // change spacing here
    [attributedString addAttribute:NSKernAttributeName value:@(letterSpacing) range:NSMakeRange(0, [title1.text length])];
    [title1 setAttributedText:attributedString];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)generalButtonPressed:(id)sender{
    SupportScreen2ViewController *vc = [[SupportScreen2ViewController alloc] initWithNibName:@"SupportScreen2ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
    
-(IBAction)emergencyButtonPressed:(id)sender{
    EmergencyViewController *vc = [[EmergencyViewController alloc] initWithNibName:@"EmergencyViewController" bundle:nil];
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
