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
#import "SearchPodViewController.h"
#import "GlobalKeyViewController.h"
#import "EventsListViewController.h"
#import "SupportScreen1ViewController.h"
NS_ASSUME_NONNULL_BEGIN

#define WIDTH 216
#define HEIGHT 60
#define PADDING 10
#define NUMBEROFBUTTONSINAROW 4


@interface CalenderViewController : UIViewController<UIScrollViewDelegate,GlobalKeyViewControllerDelegate>
{
     IBOutlet UILabel *titleLbl;
    
    FSCalendar *calendar;
    NSDate *selectedDate;
    
    IBOutlet UIButton *nextBtn;
   
}
-(IBAction)backBtnPress:(id)sender;

@property(nonatomic,retain)NSString *eventId;
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,retain)NSString *eventStartDate;
@property(nonatomic,retain)NSString *eventEndDate;
@property (strong, nonatomic) UIScrollView *theScrollView;

+ (UIImage *)imageWithColor:(UIColor *)color;
-(IBAction)nextBtnClicked:(id)sender;


-(IBAction)backBtnPress:(id)sender;
@end

NS_ASSUME_NONNULL_END
