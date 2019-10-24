//
//  SupportScreen1ViewController.h
//  ZenspaceOutdoor
//
//  Created by Monish on 10/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderViewController.h"
#import "SelectionViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SupportSuccessViewController : UIViewController
{
    NSArray *arr;
    IBOutlet UILabel *title1;
    IBOutlet UILabel *title2;
    IBOutlet UILabel *title3;

}

-(IBAction)backButtonPressed:(id)sender;
@end

NS_ASSUME_NONNULL_END
