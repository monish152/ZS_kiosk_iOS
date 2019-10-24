//
//  SelectionViewController.h
//  Zenspace
//
//  Created by Monish on 23/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "PodsListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "SearchPodViewController.h"
#import "GlobalKeyViewController.h"
#import "GroupsListViewController.h"
#import "SupportScreen1ViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectionViewController : UIViewController<UIScrollViewDelegate,GlobalKeyViewControllerDelegate>
{
    IBOutlet UILabel *titleLbl;
       
       FSCalendar *calendar;
       NSDate *selectedDate;
       
       IBOutlet UIButton *nextBtn;
    
    IBOutlet UIButton *dateBtn;
    IBOutlet UIButton *capacityBtn;
    IBOutlet UIButton *durationBtn;
    IBOutlet UIButton *startDateBtn;
    
    IBOutlet UIView *dateView;
    IBOutlet UIView *capacityView;
    IBOutlet UIView *durationView;
    IBOutlet UIView *startTimeView;
    
    NSMutableArray *datesArray;
    IBOutlet UILabel *changeDate;
    
    
    IBOutlet UILabel *capacityTitle;
    NSInteger selectedCapacity;
    NSDictionary *capacityDictionary;
    
    IBOutlet UILabel *durationTitle;
    IBOutlet UILabel *durationLbl;
       int durationIndex;
       NSMutableArray *durationArray;
       NSInteger selectedDuration;;
    IBOutlet UIButton *plusBtn;
    IBOutlet UIButton *minusBtn;
    
    
    IBOutlet UILabel *titleSlot;
    NSMutableArray *slotsArray;
    
}


@property(nonatomic,retain)NSString *eventId;
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,retain)NSString *eventStartDate;
@property(nonatomic,retain)NSString *eventEndDate;
@property (strong, nonatomic) UIScrollView *theScrollView;
@property(nonatomic,retain)NSString *selectedSlot;
-(IBAction)nextBtnClicked:(id)sender;
-(IBAction)backBtnPress:(id)sender;
+ (UIImage *)imageWithColor:(UIColor *)color;
-(IBAction)searchPod:(id)sender;
-(IBAction)plusButtonPressed:(id)sender;
-(IBAction)minusButtonPressed:(id)sender;

-(IBAction)dateBtnPress:(id)sender;
-(IBAction)capacityBtnPress:(id)sender;
-(IBAction)durationBtnPress:(id)sender;
-(IBAction)startDateBtnPress:(id)sender;

@end

NS_ASSUME_NONNULL_END
