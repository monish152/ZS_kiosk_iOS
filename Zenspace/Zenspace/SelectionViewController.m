//
//  SelectionViewController.m
//  Zenspace
//
//  Created by Monish on 23/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "SelectionViewController.h"

@interface SelectionViewController ()

@end

@implementation SelectionViewController
@synthesize eventId,eventStartDate,eventEndDate,groupId;
- (void)viewDidLoad {
    changeDate.font = [UIFont fontWithName:@"Roboto-Medium"
                                      size:24];
    capacityTitle.font = [UIFont fontWithName:@"Roboto-Medium"
                                         size:24];
    durationTitle.font = [UIFont fontWithName:@"Roboto-Medium"
    size:24];
    titleSlot.font = [UIFont fontWithName:@"Roboto-Medium"
    size:24];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self dateBtnPress:nil];
    
}
-(IBAction)dateBtnPress:(id)sender{
    
    dateBtn.alpha = 1.0;
    capacityBtn.alpha = 0.5;
    durationBtn.alpha = 0.5;
    startDateBtn.alpha = 0.5;
    
    dateView.hidden = NO;
    capacityView.hidden = YES;
    durationView.hidden = YES;
    startTimeView.hidden = YES;
    
    
    NSDate *minDate;
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:eventStartDate];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSDate *dateFromString = [formatter dateFromString:dateStr];
    
    NSComparisonResult result;
    result = [today compare:dateFromString]; // comparing two dates
    NSString *event = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"eventorlocation"];
    if(result==NSOrderedDescending || [event isEqualToString:@"location"])
    {
        
        minDate = today;
        
    }
    else{
        minDate = dateFromString;
    }
    
    datesArray = [[NSMutableArray alloc]init];
    [datesArray addObject:minDate];
    
    
    
    
    NSDate *maxDate;
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    date = [formatter dateFromString:eventEndDate];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    dateStr = [formatter stringFromDate:date];
    dateFromString = [formatter dateFromString:dateStr];
    
    maxDate = dateFromString;
    
    if ([event isEqualToString:@"event"]) {
        
    }
    else{
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 6;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        
        maxDate = nextDate;
    }
    
    
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDateComponents *conversionInfo = [theCalendar components:unitFlags fromDate:minDate   toDate:maxDate  options:0];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    int days = [conversionInfo day];
    
    for (int i=0; i<days; i++) {
        minDate = [theCalendar dateByAddingComponents:dayComponent toDate:minDate options:0];
        [datesArray addObject:minDate];
    }
    NSLog(@"datesArray : %@",datesArray);
    
    int count = datesArray.count;
    if (datesArray.count > 7) {
        count = 7;
    }
    
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect frame = CGRectMake(50+(i*135), 230, 115, 121);
        button.frame = frame;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = 2000+i;
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        if ([[dateFormat stringFromDate:selectedDate] isEqualToString:[dateFormat stringFromDate:[datesArray objectAtIndex:i]]]) {
            [button setBackgroundColor:[UIColor colorWithRed:0.19 green:0.37 blue:.83 alpha:1.0]];
        }
        
        [button addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 2;
        button.clipsToBounds = YES;
        [button setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:0.19 green:0.37 blue:.83 alpha:1.0]]
                          forState:UIControlStateSelected];
        [button setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:0.19 green:0.37 blue:.83 alpha:1.0]]
                          forState:UIControlStateHighlighted];
        
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.2;
        [dateView addSubview:button];
        
        
        date = [datesArray objectAtIndex:i];
        [formatter setDateFormat:@"MMMM"];
        dateStr = [formatter stringFromDate:date];
        
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.frame = CGRectMake(0, 0, 115, 30);
        lbl.textColor = [UIColor darkGrayColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = dateStr;
        if ([[dateFormat stringFromDate:selectedDate] isEqualToString:[dateFormat stringFromDate:[datesArray objectAtIndex:i]]]) {
            lbl.textColor = [UIColor whiteColor];
        }
        lbl.font = [UIFont fontWithName:@"Roboto-Medium"
                                   size:15];
        [button addSubview:lbl];
        
        
        
        NSDate *date = [datesArray objectAtIndex:i];
        [formatter setDateFormat:@"dd"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        
        lbl = [[UILabel alloc]init];
        lbl.frame = CGRectMake(0, 30, 115, 55);
        lbl.textColor = [UIColor darkGrayColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = dateStr;
        lbl.font = [UIFont fontWithName:@"Roboto-Light"
                                   size:51];
        if ([[dateFormat stringFromDate:selectedDate] isEqualToString:[dateFormat stringFromDate:[datesArray objectAtIndex:i]]]) {
            lbl.textColor = [UIColor whiteColor];
        }
        [button addSubview:lbl];
        
        
        NSDateFormatter* day = [[NSDateFormatter alloc] init];
        [day setDateFormat: @"EEEE"];
        
        
        lbl = [[UILabel alloc]init];
        lbl.frame = CGRectMake(0, 85, 115, 30);
        lbl.textColor = [UIColor darkGrayColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [day stringFromDate:date];
        if ([[dateFormat stringFromDate:selectedDate] isEqualToString:[dateFormat stringFromDate:[datesArray objectAtIndex:i]]]) {
            lbl.textColor = [UIColor whiteColor];
        }
        lbl.font = [UIFont fontWithName:@"Roboto-Medium"
                                   size:15];
        [button addSubview:lbl];
        
    }
    
}
-(IBAction)capacityBtnPress:(id)sender{
    if (selectedDate == nil) {
        return;
    }
    dateBtn.alpha = 0.5;
    capacityBtn.alpha = 1.0;
    durationBtn.alpha = 0.5;
    startDateBtn.alpha = 0.5;
    
    dateView.hidden = YES;
    capacityView.hidden = NO;
    durationView.hidden = YES;
    startTimeView.hidden = YES;
    
    [self getCapacityApi];
}
-(IBAction)durationBtnPress:(id)sender{
    if (selectedDate == nil) {
        return;
    }
    if (selectedCapacity == nil) {
        return;
    }
    dateBtn.alpha = 0.5;
    capacityBtn.alpha = 0.5;
    durationBtn.alpha = 1.0;
    startDateBtn.alpha = 0.5;
    
    dateView.hidden = YES;
    capacityView.hidden = YES;
    durationView.hidden = NO;
    startTimeView.hidden = YES;
    
     [self getDurationApi:selectedDate];
}
-(IBAction)startDateBtnPress:(id)sender{
    if (selectedDate == nil) {
        return;
    }
    if (selectedCapacity == nil) {
        return;
    }
    dateBtn.alpha = 0.5;
    capacityBtn.alpha = 0.5;
    durationBtn.alpha = 0.5;
    startDateBtn.alpha = 1.0;
    
    dateView.hidden = YES;
    capacityView.hidden = YES;
    durationView.hidden = YES;
    startTimeView.hidden = NO;
    
    [self getSlotsApi:selectedDate];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(IBAction)selectedDate:(id)sender{
    UIButton *button = (UIButton *)sender;
    selectedDate = [datesArray objectAtIndex:[button tag]-2000];
    [self capacityBtnPress:nil];
}







-(void)getCapacityApi{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/capacity/%@/",KBASEPATH,groupId]];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults]
                                                               stringForKey:@"token"]];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *on_basis;
    NSString *apiCall = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"apiCall"];
    if([apiCall isEqualToString:@"event"]){
        on_basis = @"event";
    }else{
        on_basis = @"group";
    }
    
    NSDictionary *params = @{@"on_basis":on_basis};
    
    [manager GET:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self->capacityDictionary = [[responseObject objectForKey:@"result"] objectForKey:@"capacity"];
        
        NSMutableArray *occupancyArr = [[NSMutableArray alloc]init];
        [occupancyArr addObject:@"1"];
        [occupancyArr addObject:@"2"];
        [occupancyArr addObject:@"3"];
        [occupancyArr addObject:@"4"];
        
        
        NSMutableArray *occupancyArr2 = [[NSMutableArray alloc]init];
        [occupancyArr2 addObject:@"Yourself"];
        [occupancyArr2 addObject:@"People"];
        [occupancyArr2 addObject:@"People"];
        [occupancyArr2 addObject:@"People"];
        
        for (int i= 0; i<[self->capacityDictionary count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            CGRect frame = CGRectMake(260+(i*135), 230, 115, 121);
            button.frame = frame;
            [button setBackgroundColor:[UIColor whiteColor]];
            button.tag = 3000+i;
            
            
            [button addTarget:self action:@selector(selectCapacity:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            [button setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:0.19 green:0.37 blue:.83 alpha:1.0]]
                              forState:UIControlStateSelected];
            [button setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:0.19 green:0.37 blue:.83 alpha:1.0]]
                              forState:UIControlStateHighlighted];
            
             if ([[NSString stringWithFormat:@"%ld",(long)self->selectedCapacity] isEqualToString:[occupancyArr objectAtIndex:i]]) {
                       [button setBackgroundColor:[UIColor colorWithRed:0.19 green:0.37 blue:.83 alpha:1.0]];
                   }
                   
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 0.2;
            [capacityView addSubview:button];
            
            
            
            
            
            UILabel *lbl = [[UILabel alloc]init];
            lbl.frame = CGRectMake(0, 15, 115, 65);
            lbl.textColor = [UIColor darkGrayColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = [occupancyArr objectAtIndex:i];
            lbl.font = [UIFont fontWithName:@"Roboto-Light"
                                       size:59];
            if ([[NSString stringWithFormat:@"%ld",(long)self->selectedCapacity] isEqualToString:[occupancyArr objectAtIndex:i]]) {
                lbl.textColor = [UIColor whiteColor];
            }
            [button addSubview:lbl];
            
            
            NSDateFormatter* day = [[NSDateFormatter alloc] init];
            [day setDateFormat: @"EEE"];
            
            
            lbl = [[UILabel alloc]init];
            lbl.frame = CGRectMake(0, 85, 115, 18);
            lbl.textColor = [UIColor darkGrayColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = [occupancyArr2 objectAtIndex:i];
            if ([[NSString stringWithFormat:@"%ld",(long)self->selectedCapacity] isEqualToString:[occupancyArr objectAtIndex:i]]) {
                lbl.textColor = [UIColor whiteColor];
            }
            lbl.font = [UIFont fontWithName:@"Roboto-Medium"
                                       size:15];
            [button addSubview:lbl];
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *parameters = [NSString stringWithFormat:@"%@", params];
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :parameters :errorDescription];
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"Error: %@", error);
        id responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        NSString *string = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"detail"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
-(IBAction)selectCapacity:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
 
    id arrResponse = capacityDictionary;
    if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
    {
        NSArray *arrResults =  arrResponse;
        arrResults = [[arrResults reverseObjectEnumerator] allObjects];
        selectedCapacity = [[arrResults objectAtIndex:[button tag]-3000] integerValue];
    }
    [self durationBtnPress:nil];
}

-(void)getDurationApi :(NSDate *)date{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/duration/%@/",KBASEPATH,groupId]];
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
    
    NSDictionary *params = @{@"on_basis":on_basis,@"date":[self formatDateWithString:date]};
    
    [manager GET:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [[responseObject objectForKey:@"result"] objectForKey:@"duration"];
        id arrResponse = dict;
        if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
        {
            minusBtn.enabled = NO;
            minusBtn.alpha = 0.3;
            self->durationArray = [[NSMutableArray alloc]init];
            self->durationArray =  arrResponse;
            self->durationLbl.text = [NSString stringWithFormat:@"%@",[self->durationArray objectAtIndex:0]];
            self->durationIndex = 0;
            self->selectedDuration = [[self->durationArray objectAtIndex:0] integerValue];
            self->durationLbl.font = [UIFont fontWithName:@"Roboto-Light"
            size:59];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *parameters = [NSString stringWithFormat:@"%@", params];
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :parameters :errorDescription];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        id responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        NSString *string = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"detail"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
-(IBAction)plusButtonPressed:(id)sender{
    if (durationIndex<durationArray.count-1) {
        minusBtn.enabled = YES;
        minusBtn.alpha = 1.0;
        durationIndex ++;
        durationLbl.text = [NSString stringWithFormat:@"%@",[self->durationArray objectAtIndex:durationIndex]];
        self->selectedDuration = [[self->durationArray objectAtIndex:durationIndex] integerValue];
    
    }
    if (durationIndex==durationArray.count-1) {
        plusBtn.enabled = NO;
        plusBtn.alpha = 0.3;
    }
    
}
-(IBAction)minusButtonPressed:(id)sender{
    if (durationIndex >0 ) {
        durationIndex --;
        durationLbl.text = [NSString stringWithFormat:@"%@",[self->durationArray objectAtIndex:durationIndex]];
        self->selectedDuration = [[self->durationArray objectAtIndex:durationIndex] integerValue];
        
        plusBtn.enabled = YES;
        plusBtn.alpha = 1.0;
    }
    if (durationIndex==0) {
        
        minusBtn.enabled = NO;
        minusBtn.alpha = 0.3;
    }
    
}
-(IBAction)nextBtnClicked:(id)sender{
    [self startDateBtnPress:nil];
}
-(void)getSlotsApi :(NSDate *)date{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/pod/slots/%@/",KBASEPATH,groupId]];
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
    NSDictionary *params = @{@"event_id":eventId,
                             @"group_id":groupId,
                             @"date":[self formatDateWithString:date],
                             @"capacity":[NSNumber numberWithInteger:selectedCapacity],
                             @"on_basis":on_basis,
                             @"duration":[NSNumber numberWithInteger:selectedDuration]
                             };
    
    [manager GET:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         NSDictionary *dict = [[responseObject objectForKey:@"result"] objectForKey:@"availability"];
        id arrResponse = dict;
        if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
        {
            self->slotsArray = [[NSMutableArray alloc]init];
            self->slotsArray =  arrResponse;
        }
        if (self->slotsArray.count == 0) {
            
            NSString *string = [NSString stringWithFormat:@"No Slots Available at selected date."];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:string preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            [self setupSlotUI];
        }
     
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
        NSString *className = NSStringFromClass([self class]);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *parameters = [NSString stringWithFormat:@"%@", params];
        [appDelegate fireBaseUpdateData:className :URL.absoluteString :parameters :errorDescription];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        NSString *string = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"detail"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self startDateBtnPress:nil];
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}
-(void)setupSlotUI{
    [self.theScrollView removeFromSuperview];
    self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(63, 100, 898, 500)];
    self.theScrollView.delegate = self;
    self.theScrollView.pagingEnabled = YES;
    self.theScrollView.showsHorizontalScrollIndicator = NO;
    self.theScrollView.showsVerticalScrollIndicator = NO;
    [startTimeView addSubview:self.theScrollView];
    
    for(int i=0 ; i<slotsArray.count;i++)
    {
        UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnClick setFrame:CGRectMake(((WIDTH + PADDING) * (i%NUMBEROFBUTTONSINAROW)), (HEIGHT + PADDING)*(i/NUMBEROFBUTTONSINAROW), WIDTH, HEIGHT)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date = [formatter dateFromString:[slotsArray objectAtIndex:i]];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        
        [btnClick setTitle:dateStr forState:UIControlStateNormal];
        [btnClick setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btnClick setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnClick setBackgroundColor:[UIColor whiteColor]];
        btnClick.layer.borderColor = [UIColor lightGrayColor].CGColor;
                   btnClick.layer.borderWidth = 0.2;
                 
        btnClick.tag = 3000+1+i;
        [btnClick addTarget:self action:@selector(selectSlot:) forControlEvents:UIControlEventTouchUpInside];
        btnClick.layer.cornerRadius = 30;
        btnClick.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium"
                                                   size:16];
        btnClick.clipsToBounds = YES;
        [btnClick setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:70.0/255.0 green:117.0/255.0 blue:251.0/255.0 alpha:1.0]]
                          forState:UIControlStateSelected];
        [btnClick setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:70.0/255.0 green:117.0/255.0 blue:251.0/255.0 alpha:1.0]]
                          forState:UIControlStateHighlighted];
                       
        [self.theScrollView addSubview:btnClick];
        
    }
    if (slotsArray.count>28) {
        self.theScrollView.contentSize = CGSizeMake(self.theScrollView.frame.size.width, self.theScrollView.frame.size.height * (slotsArray.count/26));
    }
    else{
        self.theScrollView.contentSize = CGSizeMake(self.theScrollView.frame.size.width, self.theScrollView.frame.size.height);
    }
    
    
}
-(IBAction)selectSlot:(UIButton *)sender{
//    for (int i= 0; i<30; i++)
//    {
//        UIButton *btn=[self.view viewWithTag:3000+1+i];
//        btn.selected = NO;
//    }
//
    NSInteger index = sender.tag-3000-1;
    [sender setSelected:YES];
    _selectedSlot = [slotsArray objectAtIndex:index];
    
    PodsListViewController *vc = [[PodsListViewController alloc] initWithNibName:@"PodsListViewController" bundle:nil];
       vc.capacity = selectedCapacity;
       vc.duration = selectedDuration;
    vc.selectedDate = _selectedSlot;
       vc.eventId = eventId;
    vc.selectedSlot = _selectedSlot;
       vc.groupId = groupId;
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
-(IBAction)helpButtonpressed:(id)sender{
    SupportScreen1ViewController *vc = [[SupportScreen1ViewController alloc] initWithNibName:@"SupportScreen1ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
