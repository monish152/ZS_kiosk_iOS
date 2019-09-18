//
//  GroupsViewController.h
//  Zenspace
//
//  Created by Monish on 15/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "PodsListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "GlobalKeyViewController.h"
#import "GroupsListViewController.h"
NS_ASSUME_NONNULL_BEGIN

#define WIDTH 94
#define HEIGHT 40
#define PADDING 16
#define NUMBEROFBUTTONSINAROW 7


@interface SearchPodViewController : UIViewController<UIScrollViewDelegate,GlobalKeyViewControllerDelegate>
{
    IBOutlet UILabel *titleCapacity;
    IBOutlet UILabel *titleDuration;
    IBOutlet UILabel *titleSlot;
    
    IBOutlet UILabel *durationLbl;
    int durationIndex;
    NSMutableArray *durationArray;
    NSInteger selectedDuration;;
    NSInteger selectedCapacity;
    NSDictionary *capacityDictionary;
    NSMutableArray *slotsArray;
    
    IBOutlet UIButton *plusBtn;
    IBOutlet UIButton *minusBtn;
    
    IBOutlet UIButton *searchPodBtn;
}
-(IBAction)backBtnPress:(id)sender;

@property(nonatomic,retain)NSString *eventId;
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,retain)NSString *eventStartDate;
@property(nonatomic,retain)NSString *eventEndDate;
@property(nonatomic,retain)NSString *selectedSlot;
@property (strong, nonatomic) UIScrollView *theScrollView;
@property(nonatomic,retain)NSDate *selectedDate;

+ (UIImage *)imageWithColor:(UIColor *)color;
-(IBAction)searchPod:(id)sender;
-(IBAction)plusButtonPressed:(id)sender;
-(IBAction)minusButtonPressed:(id)sender;


@end

NS_ASSUME_NONNULL_END
