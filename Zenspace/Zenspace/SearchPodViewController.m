//
//  ButtonsViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 4/15/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "SearchPodViewController.h"
#import "FSCalendar.h"

@interface SearchPodViewController()<FSCalendarDataSource,FSCalendarDelegate>

@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) NSCalendar *gregorian;

- (void)previousClicked:(id)sender;
- (void)nextClicked:(id)sender;

@end

@implementation SearchPodViewController
@synthesize eventId,eventStartDate,eventEndDate,groupId,selectedDate,selectedSlot;


-(void)viewDidLoad{
    titleCapacity.font = [UIFont fontWithName:@"CircularStd-Medium"
                                    size:22];
    titleSlot.font = [UIFont fontWithName:@"CircularStd-Medium"
                                    size:22];
    titleDuration.font = [UIFont fontWithName:@"CircularStd-Medium"
                                    size:22];
    durationLbl.font = [UIFont fontWithName:@"CircularStd-Book"
                                       size:16];
    searchPodBtn.titleLabel.font = [UIFont fontWithName:@"CircularStd-Medium"
                                                size:16];
    
    self.title = @"Search Pod";
    selectedSlot = @"";
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   
    
    durationLbl.layer.cornerRadius = 10;
    searchPodBtn.layer.cornerRadius = 10;
    durationLbl.clipsToBounds = YES;
    
    plusBtn.layer.cornerRadius = plusBtn.frame.size.width/2;
    minusBtn.layer.cornerRadius = minusBtn.frame.size.width/2;
    
    selectedCapacity = 1;
    [self getCapacityApi];
    [self getDurationApi:selectedDate];
    
    minusBtn.enabled = NO;
    minusBtn.alpha = 0.3;
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
        [occupancyArr addObject:@"Yourself"];
        [occupancyArr addObject:@"2 People"];
        [occupancyArr addObject:@"3 People"];
        [occupancyArr addObject:@"4 People"];

        for (int i= 0; i<[self->capacityDictionary count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            CGRect frame = CGRectMake(122+(i*110), 230, 94, 40);
            button.frame = frame;
            [button setTitle:[occupancyArr objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            button.tag = 2000+1+i;
            button.titleLabel.font = [UIFont fontWithName:@"CircularStd-Book"
                                                     size:16];
            [button addTarget:self action:@selector(selectCapacity:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 10;
            button.clipsToBounds = YES;
            [button setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:70.0/255.0 green:117.0/255.0 blue:251.0/255.0 alpha:1.0]]
                              forState:UIControlStateSelected];
            [button setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:70.0/255.0 green:117.0/255.0 blue:251.0/255.0 alpha:1.0]]
                              forState:UIControlStateHighlighted];
            [self.view addSubview:button];
        }
        UIButton *selectedBtn = (UIButton *)[self.view viewWithTag:2001];
        selectedBtn.selected = YES;


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
    //Monish Pending
    for (int i= 0; i<[self->capacityDictionary count]; i++)
    {
        UIButton *btn=[self.view viewWithTag:2000+1+i];
        btn.selected = NO;
    }
    
    NSInteger index = sender.tag-2000;
    [sender setSelected:YES];
    id arrResponse = capacityDictionary;
    if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
    {
        NSArray *arrResults =  arrResponse;
        arrResults = [[arrResults reverseObjectEnumerator] allObjects];
        selectedCapacity = [[arrResults objectAtIndex:index-1] integerValue];
    }
    
    [self getSlotsApi:selectedDate];
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
            self->durationArray = [[NSMutableArray alloc]init];
            self->durationArray =  arrResponse;
            self->durationLbl.text = [NSString stringWithFormat:@"%@ Min",[self->durationArray objectAtIndex:0]];
            self->durationIndex = 0;
            self->selectedDuration = [[self->durationArray objectAtIndex:0] integerValue];
            [self getSlotsApi:date];
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
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
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

-(IBAction)searchPod:(id)sender{
    if ([selectedSlot isEqualToString:@""]) {
        NSString *string = [NSString stringWithFormat:@"Please select any slot first."];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    PodsListViewController *vc = [[PodsListViewController alloc] initWithNibName:@"PodsListViewController" bundle:nil];
    vc.capacity = selectedCapacity;
    vc.duration = selectedDuration;
    vc.selectedDate = selectedSlot;
    vc.eventId = eventId;
    vc.selectedSlot = selectedSlot;
    vc.groupId = groupId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)plusButtonPressed:(id)sender{
    if (durationIndex<durationArray.count-1) {
        minusBtn.enabled = YES;
        minusBtn.alpha = 1.0;
        durationIndex ++;
        durationLbl.text = [NSString stringWithFormat:@"%@ Min",[self->durationArray objectAtIndex:durationIndex]];
        self->selectedDuration = [[self->durationArray objectAtIndex:durationIndex] integerValue];
        [self getSlotsApi:selectedDate];
    }
    if (durationIndex==durationArray.count-1) {
        plusBtn.enabled = NO;
        plusBtn.alpha = 0.3;
    }
    
}
-(IBAction)minusButtonPressed:(id)sender{
    if (durationIndex >0 ) {
        durationIndex --;
        durationLbl.text = [NSString stringWithFormat:@"%@ Min",[self->durationArray objectAtIndex:durationIndex]];
        self->selectedDuration = [[self->durationArray objectAtIndex:durationIndex] integerValue];
        [self getSlotsApi:selectedDate];
        
        plusBtn.enabled = YES;
        plusBtn.alpha = 1.0;
    }
    if (durationIndex==0) {
        
        minusBtn.enabled = NO;
        minusBtn.alpha = 0.3;
    }
    
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
-(void)setupSlotUI{
    [self.theScrollView removeFromSuperview];
    self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(122, 398, 882, 210)];
    self.theScrollView.delegate = self;
    self.theScrollView.pagingEnabled = YES;
    self.theScrollView.showsHorizontalScrollIndicator = NO;
    self.theScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.theScrollView];
    
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
        [btnClick setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        btnClick.tag = 3000+1+i;
        [btnClick addTarget:self action:@selector(selectSlot:) forControlEvents:UIControlEventTouchUpInside];
        btnClick.layer.cornerRadius = 10;
        btnClick.titleLabel.font = [UIFont fontWithName:@"CircularStd-Book"
                                                   size:16];
        btnClick.clipsToBounds = YES;
        [btnClick setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:70.0/255.0 green:117.0/255.0 blue:251.0/255.0 alpha:1.0]]
                          forState:UIControlStateSelected];
        [btnClick setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:70.0/255.0 green:117.0/255.0 blue:251.0/255.0 alpha:1.0]]
                          forState:UIControlStateHighlighted];
                       
        [self.theScrollView addSubview:btnClick];
        
    }
    if (slotsArray.count>28) {
        self.theScrollView.contentSize = CGSizeMake(self.theScrollView.frame.size.width, self.theScrollView.frame.size.height * (slotsArray.count/21));
    }
    else{
        self.theScrollView.contentSize = CGSizeMake(self.theScrollView.frame.size.width, self.theScrollView.frame.size.height);
    }
    
    
}
-(IBAction)selectSlot:(UIButton *)sender{
    for (int i= 0; i<30; i++)
    {
        UIButton *btn=[self.view viewWithTag:3000+1+i];
        btn.selected = NO;
    }
    
    NSInteger index = sender.tag-3000-1;
    [sender setSelected:YES];
    selectedSlot = [slotsArray objectAtIndex:index];
    
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
-(IBAction)helpButtonpressed:(id)sender{
    SupportScreen1ViewController *vc = [[SupportScreen1ViewController alloc] initWithNibName:@"SupportScreen1ViewController" bundle:nil];
       [self.navigationController pushViewController:vc animated:YES];
}
@end
