//
//  SupportScreen1ViewController.h
//  ZenspaceOutdoor
//
//  Created by Monish on 10/10/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SupportSubmitViewController : UIViewController
{
    NSArray *arr;
    

    
    IBOutlet UILabel *title1;
    IBOutlet UILabel *title2;
    
    IBOutlet UITextField *nameTxtFld;
    IBOutlet UITextField *emailTxtFld;
    IBOutlet UITextField *phoneTxtFld;
    
    IBOutlet UILabel *title3;
    
    IBOutlet UIButton *submitBtn;
    
    IBOutlet UIButton *phoneBtn;
    IBOutlet UIButton *emailBtn;
    
    NSString *selectedOption;
    
}
@property(nonatomic,retain)NSString *issueType;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)submitButtonPressed:(id)sender;
-(IBAction)phoneButtonPressed:(id)sender;
-(IBAction)emailButtonPressed:(id)sender;
@end

NS_ASSUME_NONNULL_END
