//
//  LogicalPodViewController.h
//  ZenspaceOutdoor
//
//  Created by Monish on 18/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//
#import <UIKit/UIKit.h>

@class GlobalKeyViewController;
@protocol GlobalKeyViewControllerDelegate //define delegate protocol
- (void)GlobalKeyViewControllerDelegateMethod :(NSString *_Nonnull)emailId;
- (void)PopViewToMainView :(NSString *_Nonnull)emailId;
@end //end protocol




#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN



@interface GlobalKeyViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UILabel *enterKey;
    IBOutlet UITextField *firstTxtField;
    IBOutlet UITextField *secondTxtField;
    IBOutlet UITextField *thirdTxtField;
    IBOutlet UITextField *fourthTxtField;
    
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    IBOutlet UIImageView *img3;
    IBOutlet UIImageView *img4;
    
    IBOutlet UIButton *submitBtn;
    
    NSMutableData *receiveData;
    NSMutableData *responseData;
    int statusCode;
    
    IBOutlet UILabel *keyType;
}

@property(nonatomic, retain)NSString *physicalPodName;
@property(nonatomic, retain)NSString *emailId;
@property (nonatomic, weak) id <GlobalKeyViewControllerDelegate> delegate;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)unlockButtonPressed:(id)sender;


@end

NS_ASSUME_NONNULL_END
