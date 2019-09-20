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


//#define KBASEPATH @"https://zenspace-production.herokuapp.com/"
#define KBASEPATH @"https://zensapce-staging.herokuapp.com/"

@import Firebase;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

