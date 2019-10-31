//
//  AppDelegate.m
//  Zenspace
//
//  Created by Monish on 15/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
     [Stripe setDefaultPublishableKey:@"pk_live_CEKEZh124pleOeee47rAXnGB"];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    
    [FIRApp configure];self.ref = [[FIRDatabase database] reference];
    
    NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"" forKey:@"stripe"];
    [def synchronize];
    
    return YES;
}
-(void)fireBaseUpdateData :(NSString *)className :(NSString *)apiURL :(NSString *)parameters :(NSString *)error  {
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSString *key = [[_ref child:@"Logs"] childByAutoId].key;
    NSDictionary *post = @{@"date" : dateString,
                           @"appVersion": appVersion,
                           @"appBuild": appBuild,
                           @"class": className,
                           @"apiURL": apiURL,
                           @"parameters": parameters,
                           @"error": error,
                           @"deviceVersion": [[UIDevice currentDevice] systemVersion]};
    NSDictionary *childUpdates = @{[@"/Logs/" stringByAppendingString:key]: post};
    [_ref updateChildValues:childUpdates];
}
-(void)applicationDidTimeout:(NSNotification *) notif
{
//    NSLog (@"time exceeded!!");
    UINavigationController *nvc = (UINavigationController *)self.window.rootViewController;
    UIViewController* topMostController = nvc.visibleViewController;;
    if([[NSString stringWithFormat:@"%s", class_getName([topMostController class])] isEqualToString:@"ViewController"]) {
    }
    if([[NSString stringWithFormat:@"%s", class_getName([topMostController class])] isEqualToString:@"EventsListViewController"]) {
    }
    if([[NSString stringWithFormat:@"%s", class_getName([topMostController class])] isEqualToString:@"GroupsListViewController"]) {
    }
    else  if([[NSString stringWithFormat:@"%s", class_getName([topMostController class])] isEqualToString:@"GlobalKeyViewController"]) {
        
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        NSArray *viewControllers = [(UINavigationController *)self.window.rootViewController viewControllers];
        for( int i=0;i<[viewControllers count];i++){
            id obj=[viewControllers objectAtIndex:i];
            if([obj isKindOfClass:[SelectionViewController class]]){
                [obj viewDidLoad];
                [(UINavigationController *)self.window.rootViewController popToViewController:obj animated:NO];
                
                ScreensaverViewController *vc = [[ScreensaverViewController alloc] initWithNibName:@"ScreensaverViewController" bundle:nil];
                [self.window.rootViewController presentViewController:vc animated:NO completion:NULL];
                
                [(TIMERUIApplication *)[UIApplication sharedApplication] resetIdleTimer];
                
                return;
            }
        }
        
    }
    
    else{
        NSArray *viewControllers = [(UINavigationController *)self.window.rootViewController viewControllers];
        for( int i=0;i<[viewControllers count];i++){
            id obj=[viewControllers objectAtIndex:i];
            if([obj isKindOfClass:[SelectionViewController class]]){
                [obj viewDidLoad];
                [(UINavigationController *)self.window.rootViewController popToViewController:obj animated:NO];
                
                ScreensaverViewController *vc = [[ScreensaverViewController alloc] initWithNibName:@"ScreensaverViewController" bundle:nil];
                [self.window.rootViewController presentViewController:vc animated:NO completion:NULL];
                
                [(TIMERUIApplication *)[UIApplication sharedApplication] resetIdleTimer];
                
                return;
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
