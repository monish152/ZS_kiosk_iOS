//
//  ButtonsViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 4/15/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "PodsListViewController.h"


@interface PodsListViewController()<FSCalendarDataSource,FSCalendarDelegate>



@end

@implementation PodsListViewController
@synthesize capacity,duration,selectedDate,eventId,selectedSlot,groupId;
-(void)viewDidLoad{
    [self.navigationController setNavigationBarHidden:YES];
    
    editButton.titleLabel.font = [UIFont fontWithName:@"CircularStd-Medium"
                                                 size:16];
    editButton.layer.cornerRadius = 10;
    
    
    titleLbl.font = [UIFont fontWithName:@"CircularStd-Medium"
                                    size:24];
    
    NSString *imgName = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"image"];
    [imageViewGroup sd_setImageWithURL:[NSURL URLWithString:imgName]
                      placeholderImage:[UIImage imageNamed:@""]];
    imageViewGroup.layer.cornerRadius = 10;
    imageViewGroup.clipsToBounds = YES;
    
    
    NameLbl.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]
                                                      stringForKey:@"groupName"]];
    NameLbl.font = [UIFont fontWithName:@"CircularStd-Bold"
                                   size:19];
    
    
    dateIcon.image = [dateIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [dateIcon setTintColor:[UIColor lightGrayColor]];
    
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [format dateFromString:selectedSlot];
    [format setDateFormat:@"MMM dd, yyyy"];
    NSString* finalDateString = [format stringFromDate:date];
    
    dateLbl.text = [NSString stringWithFormat:@"%@",finalDateString];
    dateLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                   size:14];
    
    
    
    
    timeIcon.image = [timeIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [timeIcon setTintColor:[UIColor lightGrayColor]];
    
    
    [format setDateFormat:@"HH:mm"];
    finalDateString = [format stringFromDate:date];
    timeLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                   size:14];
    timeLbl.text = [NSString stringWithFormat:@"%@ for %@ min",finalDateString,[NSString stringWithFormat:@"%ld",(long)duration] ];
    [self getPodsApi];
}
-(void)getPodsApi{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/available/%@/",KBASEPATH,groupId]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults]
                                                               stringForKey:@"token"]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *apiCall = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"apiCall"];
    NSString *on_basis;
    if([apiCall isEqualToString:@"event"]){
        on_basis = @"event";
    }else{
        on_basis = @"group";
    }
    
    NSDictionary *params = @{@"on_basis":on_basis,
                             @"capacity":[NSNumber numberWithInteger:capacity],
                             @"startdate":selectedDate,
                             @"duration":[NSNumber numberWithInteger:duration],
                             @"all_day_event":@"FALSE"
                             };
    
    [manager GET:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [responseObject objectForKey:@"result"];
        id arrResponse = dict;
        if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
        {
            self->dictionary = [responseObject objectForKey:@"result"];
            [self->m_tableView reloadData];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        id responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        NSString *string = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"detail"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"Error: %@", error);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger keyCount = [dictionary count];
    return keyCount;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"PodListTableCell";
    PodListTableCell *cell = (PodListTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PodListTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id arrResponse = dictionary;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    if (indexPath.row ==0) {
    //
    //        NSString *imgName = [[NSUserDefaults standardUserDefaults]
    //                                                    stringForKey:@"image"];
    //        [cell.img sd_setImageWithURL:[NSURL URLWithString:imgName]
    //                    placeholderImage:[UIImage imageNamed:@""]];
    //        cell.img.layer.cornerRadius = 10;
    //        cell.img.clipsToBounds = YES;
    //
    //        cell.locationIcon.image = [cell.locationIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //        [cell.locationIcon setTintColor:[UIColor lightGrayColor]];
    //
    //        cell.capacityIcon.hidden = YES;
    //
    //
    //
    //        cell.title.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]
    //                                                             stringForKey:@"groupName"]];
    //        cell.title.font = [UIFont fontWithName:@"CircularStd-Bold"
    //                                          size:16];
    //
    //        cell.address.text =  [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]
    //                                                                stringForKey:@"location"]];
    //        cell.address.font = [UIFont fontWithName:@"CircularStd-Book"
    //                                            size:14];
    //
    //
    //
    ////
    ////        NSString *price = [NSString stringWithFormat:@"%@",[[arrResults objectAtIndex:indexPath.row-1] valueForKey:@"unitprice"]];
    ////        if ([price isEqualToString:@"0"]) {
    ////            cell.price.text = [NSString stringWithFormat:@"Free"];
    ////        }
    ////        else{
    ////            cell.price.text = [NSString stringWithFormat:@"$%@/hr ",price];
    ////        }
    //
    //
    //
    //        cell.dateIcon.hidden = NO;
    //        cell.dateIcon.image = [cell.dateIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //        [cell.dateIcon setTintColor:[UIColor lightGrayColor]];
    //
    //
    //
    //        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //        [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    //         [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //        NSDate *date = [format dateFromString:selectedSlot];
    //        [format setDateFormat:@"MMM dd, yyyy"];
    //        NSString* finalDateString = [format stringFromDate:date];
    //
    //        cell.occupancy.text = [NSString stringWithFormat:@"%@",finalDateString];
    //        cell.occupancy.font = [UIFont fontWithName:@"CircularStd-Book"
    //                                              size:14];
    //
    //
    //
    //        cell.timeIcon.hidden = NO;
    //        cell.timeIcon.image = [cell.timeIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //        [cell.timeIcon setTintColor:[UIColor lightGrayColor]];
    //
    //        cell.timeLbl.hidden = NO;
    //
    //        [format setDateFormat:@"HH:mm"];
    //        finalDateString = [format stringFromDate:date];
    //        cell.timeLbl.font = [UIFont fontWithName:@"CircularStd-Book"
    //                                          size:14];
    //        cell.timeLbl.text = [NSString stringWithFormat:@"%@ for %@ min",finalDateString,[NSString stringWithFormat:@"%ld",(long)duration] ];
    //
    //
    //
    //        cell.price.hidden = YES;
    //
    //
    //        cell.bookBtn.hidden = YES;
    //        cell.bookBtn.layer.cornerRadius = 10;
    //        cell.bookBtn.clipsToBounds = YES;
    //        cell.bookBtn.titleLabel.font = [UIFont fontWithName:@"CircularStd-Medium"
    //                                                       size:16];
    //
    //    }
    
    if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
    {
        NSArray *arrResults =  arrResponse;
        
        NSString *imgName = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:indexPath.row] valueForKey:@"card_image__c"]];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:imgName]
                    placeholderImage:[UIImage imageNamed:@""]];
        cell.img.layer.cornerRadius = 10;
        cell.img.clipsToBounds = YES;
        
        cell.locationIcon.image = [cell.locationIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.locationIcon setTintColor:[UIColor lightGrayColor]];
        
        cell.capacityIcon.image = [cell.capacityIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.capacityIcon setTintColor:[UIColor lightGrayColor]];
        
        
        cell.title.text = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:indexPath.row] valueForKey:@"name"]];
        cell.title.font = [UIFont fontWithName:@"CircularStd-Bold"
                                          size:16];
        
        cell.address.text =  [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:indexPath.row] valueForKey:@"indoor_location__c"]];
        cell.address.font = [UIFont fontWithName:@"CircularStd-Book"
                                            size:14];
        
        
        cell.occupancy.text = [NSString stringWithFormat:@"%@ People", [[arrResults objectAtIndex:indexPath.row] valueForKey:@"capacity__c"]];
        cell.occupancy.font = [UIFont fontWithName:@"CircularStd-Book"
                                              size:14];
        
        NSString *price = [NSString stringWithFormat:@"%@",[[arrResults objectAtIndex:indexPath.row] valueForKey:@"unitprice"]];
        if ([price isEqualToString:@"0"]) {
            cell.price.text = [NSString stringWithFormat:@"Free"];
        }
        else{
            cell.price.text = [NSString stringWithFormat:@"$%@/hr ",price];
        }
        
        cell.price.font = [UIFont fontWithName:@"CircularStd-Bold"
                                          size:18];
        
        
        cell.bookBtn.tag = indexPath.row;
        cell.bookBtn.layer.cornerRadius = 10;
        cell.bookBtn.clipsToBounds = YES;
        cell.bookBtn.titleLabel.font = [UIFont fontWithName:@"CircularStd-Medium"
                                                       size:16];
        [cell.bookBtn addTarget:self action:@selector(bookBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return cell;
}
-(void)bookBtnClicked:(UIButton*)sender
{
    BookingSummaryViewController *vc = [[BookingSummaryViewController alloc] initWithNibName:@"BookingSummaryViewController" bundle:nil];
    id arrResponse = dictionary;
    NSArray *arrResults =  arrResponse;
    vc.podName = [[arrResults objectAtIndex:sender.tag] valueForKey:@"name"];
    vc.date = selectedDate;
    vc.duration = duration;
    NSString *imgName = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:sender.tag] valueForKey:@"card_image__c"]];
    vc.imageurl = imgName;
    
    
    NSString *priceStr = [NSString stringWithFormat:@"%@",[[arrResults objectAtIndex:sender.tag] valueForKey:@"unitprice"]];
    if (![priceStr isEqualToString:@"0"]) {
        CGFloat perHourPrice = [priceStr floatValue];
        CGFloat actualPrice =  perHourPrice * duration / 60;
        priceStr = [NSString stringWithFormat:@"%.02f",actualPrice];
        
    }
    vc.price = priceStr;
    vc.sfid = [[arrResults objectAtIndex:sender.tag] valueForKey:@"sfid"];
    vc.capacity = capacity;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    PodListTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
}
-(IBAction)backBtnPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)editBtnPress:(id)sender{
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
