//
//  GroupsViewController.h
//  Zenspace
//
//  Created by Monish on 15/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "PodListTableCell.h"
#import "SearchPodViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "GroupsListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface EventsListViewController : UIViewController
{
    IBOutlet UILabel *titleLbl;
    NSMutableArray *filteredContentList;
    NSMutableDictionary *dictionary;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIButton *eventsBtn;
    IBOutlet UIButton *locationBtn;
}

-(IBAction)backBtnPress:(id)sender;
-(IBAction)eventBtnPress:(id)sender;
-(IBAction)locationBtnPress:(id)sender;
@end

NS_ASSUME_NONNULL_END
