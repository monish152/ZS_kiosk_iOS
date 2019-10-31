//
//  ButtonsViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 4/15/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "EventsListViewController.h"


@interface EventsListViewController()



@end

@implementation EventsListViewController

-(void)viewDidLoad{
    
    eventsBtn.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular"
                                                size:20];
    locationBtn.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular"
                                                  size:20];
    
    
    titleLbl.font = [UIFont fontWithName:@"Roboto-Medium"
                                    size:24];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"event" forKey:@"eventorlocation"];
    [def synchronize];
    eventsBtn.alpha = 1.0;
    locationBtn.alpha = 0.7;
    
    eventLine.hidden = NO;
    locationLine.hidden = YES;
    [self getEvents:YES];
    self.navigationController.navigationBarHidden = YES;
    
    isFirstTime = YES;
}
-(IBAction)eventBtnPress:(id)sender{
    titleLbl.text = @"Upcoming Events";
    
    NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"event" forKey:@"eventorlocation"];
    [def synchronize];
    eventsBtn.alpha = 1.0;
    locationBtn.alpha = 0.7;
    
    eventLine.hidden = NO;
    locationLine.hidden = YES;
    [self getEvents:YES];
}
-(IBAction)locationBtnPress:(id)sender{
    titleLbl.text = @"Locations";
    
    NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"location" forKey:@"eventorlocation"];
    [def synchronize];
    eventsBtn.alpha = 0.7;
    locationBtn.alpha = 1.0;
    
    eventLine.hidden = YES;
    locationLine.hidden = NO;
    [self getEvents:NO];
}
-(void)getEvents:(BOOL)isEvent{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/events/",KBASEPATH]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        self->dictionary = [responseObject objectForKey:@"result"];
        id arrResponse = self->dictionary;
        if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
        {
            NSMutableArray *arrResults =  [arrResponse mutableCopy];
            NSMutableArray *discardedItems = [NSMutableArray array];
            for (int i=0; i<[arrResults count]; i++) {
                NSString *endDateStr =  [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"end_datetime__c"]];
                NSDate *today = [NSDate date];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSDate *date = [formatter dateFromString:endDateStr];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
                NSString *dateStr = [formatter stringFromDate:date];
                NSDate *dateFromString = [formatter dateFromString:dateStr];
                
                NSComparisonResult result;
                //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
                
                result = [today compare:dateFromString]; // comparing two dates
                
                if(result==NSOrderedDescending)
                {
                    
                    [discardedItems addObject:[arrResults objectAtIndex:i]];
                    
                }
            }
            [arrResults removeObjectsInArray:discardedItems];
            
            discardedItems = [NSMutableArray array];
            for (int i=0; i<[arrResults count]; i++) {
                NSString *isLocation = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"is_location__c"]];
                if (isEvent) {
                    if ([isLocation isEqualToString:@"1"]) {
                        [discardedItems addObject:[arrResults objectAtIndex:i]];
                    }
                }
                else{
                    if ([isLocation isEqualToString:@"0"]) {
                        [discardedItems addObject:[arrResults objectAtIndex:i]];
                    }
                }
            }
            [arrResults removeObjectsInArray:discardedItems];
            NSArray *viewsToRemove = [scrollView subviews];
               for (UIView *v in viewsToRemove) {
                   [v removeFromSuperview];
               }
            if (isEvent) {
                if (arrResults.count >0) {
                    self->dictionary =  [arrResults mutableCopy];
                    [self plotUI];
                    noEvent.hidden = YES;
                }
                else{
                    if (isFirstTime) {
                        isFirstTime = NO;
                        [self locationBtnPress:nil];
                    }
                    else{
                        noEvent.hidden = NO;
                    }
                    
                }
            }else{
                self->dictionary =  [arrResults mutableCopy];
                [self plotUI];
                isFirstTime = NO;
            }
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :@"" :errorDescription];
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        NSString *string = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"detail"]];
        
        NSLog(@"Error: %@", responseObject);
    }];
}
-(void)plotUI{
    NSArray *viewsToRemove = [scrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    NSUInteger keyCount = [dictionary count];
    id arrResponse = dictionary;
    NSArray *arrResults;
    if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
    {
        arrResults =  arrResponse;
    }
    
    int xPos = 0;
    int yPos = 0;
    int lineCount = 0;
    for (int i =0;i<keyCount;i++)
    {
        if (lineCount==3)
        {
            lineCount=0;
            xPos=0;
            yPos=yPos+320;
        }
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(xPos, yPos, 300, 300);
        //        view.layer.cornerRadius = 10;
        view.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:view];
        
        
        UIImageView *img = [[UIImageView alloc]init];
        img.frame = CGRectMake(0, 0, 300, 200);
        //        img.layer.cornerRadius = 10;
        img.clipsToBounds = YES;
        [view addSubview:img];
        
        
        NSString *imgName = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"card_image__c"]];
        [img sd_setImageWithURL:[NSURL URLWithString:imgName]
               placeholderImage:[UIImage imageNamed:@""]];
        
        UILabel *eventName = [[UILabel alloc]init];
        eventName.frame = CGRectMake(29, 221, 280, 25);
        eventName.font = [UIFont fontWithName:@"Roboto-Medium"
                                         size:20];
        eventName.textColor = [UIColor blackColor];
        eventName.text = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"name"]];
        [view addSubview:eventName];
        
        
        UIImageView *icon = [[UIImageView alloc]init];
        icon.frame = CGRectMake(25, 262, 20, 20);
        icon.image = [UIImage imageNamed:@"TIME ICON.png"];
        //        icon.image = [icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //        [icon setTintColor:[UIColor lightGrayColor]];
        [view addSubview:icon];
        
        
        UILabel *address = [[UILabel alloc]init];
        address.frame = CGRectMake(60, 261, 240, 22);
        address.font = [UIFont fontWithName:@"Roboto-Regular"
                                       size:14];
        address.textColor = [UIColor lightGrayColor];
        address.text = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"date_of_event__c"]];
        [view addSubview:address];
        
        //        UIImageView *calimg = [[UIImageView alloc]init];
        //        calimg.frame = CGRectMake(157, 15, 24, 24);
        //        calimg.image = [UIImage imageNamed:@"icons-calendar-filled"];
        //        calimg.image = [calimg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //        [calimg setTintColor:[UIColor whiteColor]];
        //        [img addSubview:calimg];
        //
        //        UILabel *time = [[UILabel alloc]init];
        //        time.frame = CGRectMake(187, 18, 105, 18);
        //        time.font = [UIFont fontWithName:@"Roboto-Medium"
        //                                    size:16];
        //        time.textColor = [UIColor whiteColor];
        //        time.text = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"date_of_event__c"]];
        //        [img addSubview:time];
        //
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.backgroundColor = [UIColor clearColor];
        bt.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        bt.tag = i;
        [bt addTarget:self action:@selector(eventClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:bt];
        
        
        xPos=xPos+320;
        lineCount = lineCount+1;
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, yPos+320);
    
}
-(IBAction)eventClick:(UIButton*)sender{
    NSInteger i = [sender tag];
    id arrResponse = dictionary;
    NSArray *arrResults;
    if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
    {
        arrResults =  arrResponse;
    }
    GroupsListViewController *vc = [[GroupsListViewController alloc] initWithNibName:@"GroupsListViewController" bundle:nil];
    vc.eventId = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"sfid"]];
    vc.eventStartDate = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"start_datetime__c"]];
    vc.eventEndDate = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"end_datetime__c"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"name"]] forKey:@"groupName"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"indoor_location__c"]] forKey:@"location"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"card_image__c"]] forKey:@"image"];
    
    NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
    NSString *valueToSave = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"sfid"]];
    [def setObject:valueToSave forKey:@"ppn"];
    [def setObject:@"event" forKey:@"apiCall"];
    [def synchronize];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)backBtnPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
