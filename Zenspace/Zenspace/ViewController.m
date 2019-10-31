//
//  ViewController.m
//  Zenspace
//
//  Created by Monish on 15/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
   
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
//    EventsListViewController *vc = [[EventsListViewController alloc] initWithNibName:@"EventsListViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:NO];

//        BookingSummaryViewController *vc = [[BookingSummaryViewController alloc] initWithNibName:@"BookingSummaryViewController" bundle:nil];
//        vc.price = @"10";
//        [self.navigationController pushViewController:vc animated:NO];
    
//    StripePaymentViewController *vc = [[StripePaymentViewController alloc] initWithNibName:@"StripePaymentViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:NO];
    
    
    [super viewDidLoad];
    [self.navigationController isNavigationBarHidden];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)payBtn:(id)sender{
     kDynamoController *kVc = [[kDynamoController alloc] initWithNibName:@"kDynamoController" bundle:nil];
    kVc.transactionAmount = @"1";
    [self.navigationController pushViewController:kVc animated:YES];
}
- (IBAction)testOtherApp:(id)sender{
    
    EventsListViewController *vc = [[EventsListViewController alloc] initWithNibName:@"EventsListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    
//    PodsListViewController *vc = [[PodsListViewController alloc] initWithNibName:@"PodsListViewController" bundle:nil];
//    vc.groupId = @"a0Z56000001KXT3EAO";
//    vc.capacity = 3;
//    vc.duration = 30;
//    [self.navigationController pushViewController:vc animated:YES];

//


}
- (void)stripeView :(NSString *)emailId{
  
}
- (IBAction)testSupport:(id)sender{
    
    SupportScreen1ViewController *vc = [[SupportScreen1ViewController alloc] initWithNibName:@"SupportScreen1ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
