//
//  SupportScreen1ViewController.h
//  ZenspaceOutdoor
//
//  Created by Monish on 10/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmergencyViewController : UIViewController{
    IBOutlet UILabel *title1;
     IBOutlet UILabel *title2;
     IBOutlet UILabel *title3;

     IBOutlet UILabel *emergencyCall;
     IBOutlet UILabel *zenCall;
}


-(IBAction)backButtonPressed:(id)sender;
@end

NS_ASSUME_NONNULL_END
