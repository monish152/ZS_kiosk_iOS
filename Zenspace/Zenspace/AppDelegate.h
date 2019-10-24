//
//  AppDelegate.h
//  Zenspace
//
//  Created by Monish on 15/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "TIMERUIApplication.h"
#import "GlobalKeyViewController.h"
#import "CalenderViewController.h"
#import "ScreensaverViewController.h"
#import <Stripe/Stripe.h>
#import "SelectionViewController.h"
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define KBASEPATH @"https://zenspace-production.herokuapp.com/"
//#define KBASEPATH @"https://zensapce-staging.herokuapp.com/"

@import Firebase;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FIRDatabaseReference *ref;
-(void)fireBaseUpdateData :(NSString *)className :(NSString *)apiURL :(NSString *)parameters :(NSString *)error;
@end

