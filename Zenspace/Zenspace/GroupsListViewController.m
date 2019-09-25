//
//  ButtonsViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 4/15/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "GroupsListViewController.h"


@interface GroupsListViewController()



@end

@implementation GroupsListViewController
@synthesize eventId,eventStartDate,eventEndDate;
-(void)viewDidLoad{
    self.title = @"Group List";
    self.navigationController.navigationBarHidden = YES;
    searchEvent.titleLabel.font = [UIFont fontWithName:@"CircularStd-Medium"
                                             size:16];
    searchEvent.layer.cornerRadius = 10;
    [self getApi];
}
-(void)getApi{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/groups/%@",KBASEPATH,eventId]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
        self->dictionary = [responseObject objectForKey:@"result"];
        [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
       [self plotUI];
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        id responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        NSString *string = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"detail"]];
        
        NSLog(@"Error: %@", error);
    }];
}
-(void)plotUI{
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
            yPos=yPos+346;
        }
        
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(xPos, yPos, 300, 326);
        view.layer.cornerRadius = 10;
        view.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:view];
        
        UIImageView *bg = [[UIImageView alloc]init];
        bg.frame = CGRectMake(0, 0, 300, 171);
         bg.image = [UIImage imageNamed:@"mask"];
        [view addSubview:bg];
        
        
        UIImageView *img = [[UIImageView alloc]init];
        img.frame = CGRectMake(0, 0, 300, 171);
        img.layer.cornerRadius = 10;
        img.clipsToBounds = YES;
        [view addSubview:img];
        
        
        NSString *imgName = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"card_image__c"]];
        
        [img sd_setImageWithURL:[NSURL URLWithString:imgName]
               placeholderImage:[UIImage imageNamed:@""]];
        
        UILabel *eventName = [[UILabel alloc]init];
        eventName.frame = CGRectMake(29, 201, 270, 20);
        eventName.font = [UIFont fontWithName:@"CircularStd-Bold"
                                         size:16];
        eventName.textColor = [UIColor blackColor];
        eventName.text = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"name"]];
        [view addSubview:eventName];
        
        UIImageView *icon = [[UIImageView alloc]init];
        icon.frame = CGRectMake(22, 240, 24, 27);
        icon.image = [UIImage imageNamed:@"icons-location-f-ill"];
        icon.image = [icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [icon setTintColor:[UIColor lightGrayColor]];
        [view addSubview:icon];
        
        
        UILabel *address = [[UILabel alloc]init];
        address.frame = CGRectMake(49, 241, 230, 21);
        address.font = [UIFont fontWithName:@"CircularStd-Book"
                                       size:16];
        address.textColor = [UIColor lightGrayColor];
        address.text = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"indoor_location__c"]];
        [view addSubview:address];
        
        
        icon = [[UIImageView alloc]init];
        icon.frame = CGRectMake(22, 275, 24, 27);
        icon.image = [UIImage imageNamed:@"icons-search"];
        icon.image = [icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [icon setTintColor:[UIColor lightGrayColor]];
        [view addSubview:icon];
        
        UILabel *capacity = [[UILabel alloc]init];
        capacity.frame = CGRectMake(49, 280, 100, 21);
        capacity.font = [UIFont fontWithName:@"CircularStd-Book"
                                        size:16];
        capacity.textColor = [UIColor lightGrayColor];
        NSString *capacityStr = [[arrResults objectAtIndex:i] valueForKey:@"maximum_pod_capacity__c"];
        if (capacityStr == nil || capacityStr == (id)[NSNull null]) {
            capacityStr= @"N/A";
        }else{
            capacityStr =  [NSString stringWithFormat:@"%@ People", capacityStr];
        }
        capacity.text = capacityStr;
        [view addSubview:capacity];
        
        UILabel *time = [[UILabel alloc]init];
        time.frame = CGRectMake(175, 280, 100, 17);
        time.font = [UIFont fontWithName:@"CircularStd-Bold"
                                    size:16];
        time.textColor = [UIColor colorWithRed:22.0/255.0 green:91.0/255.0 blue:254.0/255.0 alpha:1.0];
        time.textAlignment = NSTextAlignmentRight;
        
        NSString *minimumPrice = [[arrResults objectAtIndex:i] valueForKey:@"minimum_pod_pricing__c"];
        if (minimumPrice == nil || minimumPrice == (id)[NSNull null]) {
            minimumPrice= @"N/A";
        }else{
            minimumPrice =  [NSString stringWithFormat:@"$%@/Hr", capacityStr];
        }
        time.text = minimumPrice;
       
        [view addSubview:time];
        
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.backgroundColor = [UIColor clearColor];
        bt.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        bt.tag = i;
        [bt addTarget:self action:@selector(eventClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:bt];
        
        
        xPos=xPos+320;
        lineCount = lineCount+1;
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, yPos+239);
    
}
-(IBAction)eventClick:(UIButton*)sender{
    NSInteger i = [sender tag];
    id arrResponse = dictionary;
    NSArray *arrResults;
    if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
    {
        arrResults =  arrResponse;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"name"]] forKey:@"groupName"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"indoor_location__c"]] forKey:@"location"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"card_image__c"]] forKey:@"image"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CalenderViewController *vc = [[CalenderViewController alloc] initWithNibName:@"CalenderViewController" bundle:nil];
    vc.eventId = eventId;
    vc.groupId =  [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"sfid"]];
    NSString *valueToSave = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:i] valueForKey:@"sfid"]];
    
    NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
    [def setObject:valueToSave forKey:@"ppn"];
    [def setObject:@"group" forKey:@"apiCall"];
    [def synchronize];
    
    vc.eventStartDate = eventStartDate;
    vc.eventEndDate =eventEndDate;
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)searchEntireEvent:(id)sender
{
    CalenderViewController *vc = [[CalenderViewController alloc] initWithNibName:@"CalenderViewController" bundle:nil];
    vc.eventId = eventId;
    vc.groupId =  eventId;
    NSString *valueToSave = eventId;
    
    NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
    [def setObject:valueToSave forKey:@"ppn"];
    [def setObject:@"event" forKey:@"apiCall"];
    [def synchronize];
    vc.eventStartDate = eventStartDate;
    vc.eventEndDate =eventEndDate;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(IBAction)backBtnPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
