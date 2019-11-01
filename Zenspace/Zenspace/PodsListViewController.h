//
//  GroupsViewController.h
//  Zenspace
//
//  Created by Monish on 15/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PodListTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "GlobalKeyViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EventsListViewController.h"
#import "ProcessCardViewController.h"
#import "BookingSummaryViewController.h"
#import "SupportScreen1ViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface PodsListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GlobalKeyViewControllerDelegate>
{
    IBOutlet UILabel *titleLbl;
    IBOutlet UITableView *m_tableView;
    NSMutableArray *filteredContentList;
    NSMutableDictionary *dictionary;
    
    IBOutlet UILabel *NameLbl;
    
    IBOutlet UIImageView *dateIcon;
    IBOutlet UIImageView *timeIcon;
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *timeLbl;
    IBOutlet UIImageView *imageViewGroup;
    
    IBOutlet UIButton *editButton;
}
@property(nonatomic,assign)NSInteger capacity;
@property(nonatomic,assign)NSInteger duration;
@property(nonatomic,retain)NSString *selectedDate;
@property(nonatomic,retain)NSString *eventId;
@property(nonatomic,retain)NSString *selectedSlot;
@property(nonatomic,retain)NSString *groupId;

-(IBAction)backBtnPress:(id)sender;
-(IBAction)editBtnPress:(id)sender;
@end

NS_ASSUME_NONNULL_END
