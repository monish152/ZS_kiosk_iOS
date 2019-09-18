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
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "CalenderViewController.h"
#import "GlobalKeyViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupsListViewController : UIViewController<GlobalKeyViewControllerDelegate>
{
    
    NSMutableArray *filteredContentList;
    NSMutableDictionary *dictionary;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *searchEvent;
}
-(IBAction)backBtnPress:(id)sender;
-(IBAction)searchEntireEvent:(id)sender;

@property(nonatomic,retain)NSString *eventId;
@property(nonatomic,retain)NSString *eventStartDate;
@property(nonatomic,retain)NSString *eventEndDate;

@end

NS_ASSUME_NONNULL_END
