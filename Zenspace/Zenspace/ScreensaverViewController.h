//
//  LogicalPodViewController.h
//  ZenspaceOutdoor
//
//  Created by Monish on 18/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "Reachability.h"
NS_ASSUME_NONNULL_BEGIN

@interface ScreensaverViewController : UIViewController
{
    IBOutlet UIButton *submitBtn;
    IBOutlet UIImageView *imgView;
}

@property(nonatomic, retain)NSString *physicalPodName;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)unlockButtonPressed:(id)sender;
@end

NS_ASSUME_NONNULL_END
