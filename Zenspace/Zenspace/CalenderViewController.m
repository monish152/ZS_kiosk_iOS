//
//  ButtonsViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 4/15/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "CalenderViewController.h"
#import "FSCalendar.h"

@interface CalenderViewController()<FSCalendarDataSource,FSCalendarDelegate>

@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) NSCalendar *gregorian;

- (void)previousClicked:(id)sender;
- (void)nextClicked:(id)sender;

@end

@implementation CalenderViewController
@synthesize eventId,eventStartDate,eventEndDate,groupId;


-(void)viewDidLoad{
    self.title = @"Search Pod";
    titleLbl.font = [UIFont fontWithName:@"CircularStd-Medium"
                                    size:24];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar= [[FSCalendar alloc] initWithFrame:CGRectMake(122, 222, 780, 418)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesDefaultCase;
    calendar.layer.cornerRadius = 15;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(122, 222+7, 95, 34);
    previousButton.backgroundColor = [UIColor clearColor];
    [previousButton setImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    previousButton.tintColor = [UIColor darkGrayColor];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(calendar.frame)+20, 222+7, 85, 34);
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    nextButton.tintColor = [UIColor darkGrayColor];
    self.nextButton = nextButton;
    
    nextBtn.layer.cornerRadius = 10;
    selectedDate = calendar.today;
    
}
    
    
  
-(void)viewWillAppear:(BOOL)animated{
    //    self.navigationController.navigationBarHidden = YES;
    
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}


- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
   
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:eventStartDate];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSDate *dateFromString = [formatter dateFromString:dateStr];
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [today compare:dateFromString]; // comparing two dates
    NSString *event = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"eventorlocation"];
    
    if(result==NSOrderedDescending || [event isEqualToString:@"location"])
    {
        
       return today;
        
    }
    else{
        return dateFromString;
    }
    
    
    
   
    
//    return [NSDate date];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //2019-12-31T20:00:00
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
     [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [formatter dateFromString:eventEndDate];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSDate *dateFromString = [formatter dateFromString:dateStr];
    
    NSDate *maxDate = dateFromString;
    
    NSString *event = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"eventorlocation"];
    if ([event isEqualToString:@"event"]) {
        return maxDate;
    }
    else{
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 6;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        
        return nextDate;
    }
    
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    SearchPodViewController *vc = [[SearchPodViewController alloc] initWithNibName:@"SearchPodViewController" bundle:nil];
    vc.eventId = eventId;
    vc.groupId =  groupId;
    vc.selectedDate = date;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(NSString *)formatDateWithString:(NSDate *)date{
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
     [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
- (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(IBAction)backBtnPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)searchPod:(id)sender{
    SearchPodViewController *vc = [[SearchPodViewController alloc] initWithNibName:@"SearchPodViewController" bundle:nil];
    vc.eventId = eventId;
    vc.groupId =  groupId;
    vc.selectedDate = selectedDate;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)settingButtonPressed:(id)sender{
    GlobalKeyViewController *vc = [[GlobalKeyViewController alloc] initWithNibName:@"GlobalKeyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
}
- (void)GlobalKeyViewControllerDelegateMethod :(NSString *)emailId{
    GlobalKeyViewController *vc = [[GlobalKeyViewController alloc] initWithNibName:@"GlobalKeyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.emailId = emailId;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
    
}
- (void)PopViewToMainView :(NSString *)emailId{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[GroupsListViewController class]]){
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
    
}
@end
