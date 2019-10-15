//
//  LogicalPodViewController.m
//  ZenspaceOutdoor
//
//  Created by Monish on 18/07/19.
//  Copyright © 2019 Monish. All rights reserved.
//

#import "GlobalKeyViewController.h"
#import "AppDelegate.h"
@interface GlobalKeyViewController ()

@end

@implementation GlobalKeyViewController
@synthesize physicalPodName,emailId;
@synthesize delegate;
- (void)viewDidLoad {
    submitBtn.layer.cornerRadius = 10;
    
    keyType.font = [UIFont fontWithName:@"CircularStd-Bold"
                                    size:32];
    firstTxtField.font = [UIFont fontWithName:@"CircularStd-Medium"
                                         size:22];
    secondTxtField.font = [UIFont fontWithName:@"CircularStd-Medium"
                                          size:22];
    thirdTxtField.font = [UIFont fontWithName:@"CircularStd-Medium"
                                         size:22];
    fourthTxtField.font = [UIFont fontWithName:@"CircularStd-Medium"
                                          size:22];
    
    img1.layer.cornerRadius = 10;
    img2.layer.cornerRadius = 10;
    img3.layer.cornerRadius = 10;
    img4.layer.cornerRadius = 10;
    
  
    
     if(emailId) {
        keyType.text = @"Enter Global Pin";
         firstTxtField.keyboardType = UIKeyboardTypeNumberPad;
         secondTxtField.keyboardType = UIKeyboardTypeNumberPad;
         thirdTxtField.keyboardType = UIKeyboardTypeNumberPad;
         fourthTxtField.keyboardType = UIKeyboardTypeNumberPad;
    }
    [firstTxtField becomeFirstResponder];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    
    
    UIToolbar *extraRow = [[UIToolbar alloc] init];
    //    extraRow.barStyle = UIBarStyleBlack;
    extraRow.translucent = NO;
    extraRow.barTintColor = [UIColor colorWithRed:207.0/255.0 green:210.0/255.0 blue:216.0/255.0 alpha:1.0];
    [extraRow sizeToFit];
    NSArray *buttons = [NSArray arrayWithObjects: flexBarButton,
                        [self keyboardButton:@"1"],
                        flexBarButton,
                        [self keyboardButton:@"2"],
                        flexBarButton,
                        [self keyboardButton:@"3"],
                        flexBarButton,
                        [self keyboardButton:@"4"],
                        flexBarButton,
                        [self keyboardButton:@"5"],
                        flexBarButton,
                        [self keyboardButton:@"6"],
                        flexBarButton,
                        [self keyboardButton:@"7"],
                        flexBarButton,
                        [self keyboardButton:@"8"],
                        flexBarButton,
                        [self keyboardButton:@"9"],
                        flexBarButton,
                        [self keyboardButton:@"0"],
                        flexBarButton,
                        nil];
    [extraRow setItems:buttons animated:YES];
    
    
    
    
    
    firstTxtField.inputAccessoryView = extraRow;
    secondTxtField.inputAccessoryView = extraRow;
    thirdTxtField.inputAccessoryView = extraRow;
    fourthTxtField.inputAccessoryView = extraRow;
    
    firstTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    UITextInputAssistantItem* shortcut = [firstTxtField inputAssistantItem];
    shortcut.leadingBarButtonGroups = @[];
    shortcut.trailingBarButtonGroups = @[];
    
    secondTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    shortcut = [secondTxtField inputAssistantItem];
    shortcut.leadingBarButtonGroups = @[];
    shortcut.trailingBarButtonGroups = @[];
    
    
    thirdTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    shortcut = [thirdTxtField inputAssistantItem];
    shortcut.leadingBarButtonGroups = @[];
    shortcut.trailingBarButtonGroups = @[];
    
    fourthTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    shortcut = [fourthTxtField inputAssistantItem];
    shortcut.leadingBarButtonGroups = @[];
    shortcut.trailingBarButtonGroups = @[];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(UIBarButtonItem*)keyboardButton :(NSString *)text{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    button.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(barButtonCustomPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4.0;
    
    UIBarButtonItem *my0Button = [[UIBarButtonItem alloc] initWithCustomView:button];
    CGRect resizedFrame = my0Button.customView.frame;
    resizedFrame.origin.y = 10;
    resizedFrame.size.width = 45;
    resizedFrame.size.height = 45;
    my0Button.customView.frame = resizedFrame;
    
    
    return my0Button;
    
}
-(IBAction)barButtonCustomPressed:(UIButton*)btn {
    //    NSLog(@"button tapped %@", btn.titleLabel.text);
    if ([firstTxtField isFirstResponder]) {
        firstTxtField.text = btn.titleLabel.text;
        [secondTxtField becomeFirstResponder];
    }
    else if ([secondTxtField isFirstResponder]){
        secondTxtField.text = btn.titleLabel.text;
        [thirdTxtField becomeFirstResponder];
    }
    else if ([thirdTxtField isFirstResponder]){
        thirdTxtField.text = btn.titleLabel.text;
        [fourthTxtField becomeFirstResponder];
    }
    else if ([fourthTxtField isFirstResponder]){
        fourthTxtField.text = btn.titleLabel.text;
        [fourthTxtField resignFirstResponder];
        [self unlockButtonPressed:nil];
    }
}
-(IBAction)addNumberToString:(id)sender{
    [firstTxtField becomeFirstResponder];
}
-(IBAction)backButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)unlockButtonPressed:(id)sender{
    NSString *key = [NSString stringWithFormat:@"%@%@%@%@",firstTxtField.text,secondTxtField.text,thirdTxtField.text,fourthTxtField.text];
    if (key.length<4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:@"Please enter key." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // Ok action example
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self callApi:key];
    
}
-(void)callApi :(NSString *)key{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(!emailId || [emailId isKindOfClass:[NSNull class]])    {
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/iot/pod/key-verify/",KBASEPATH]];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:25.0];
        
        [request setHTTPMethod:@"POST"];
        postString = [NSString stringWithFormat:@"key=%@",key];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (theConnection) {
            
            receiveData = [NSMutableData data];
            
        }
    }
    else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/iot/pod/pin-verify/",KBASEPATH]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                        
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        
                                                           timeoutInterval:25.0];
        
        [request setHTTPMethod:@"POST"];
        postString = [NSString stringWithFormat:@"pin=%@&personemail=%@",key,emailId];
        request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (theConnection) {
            
            receiveData = [NSMutableData data];
            
        }
    }
    
    
}
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass: [NSHTTPURLResponse class]])
        statusCode = [(NSHTTPURLResponse*) response statusCode];
    responseData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [self cleanData];
    NSLog(@"Connection failed: %@", [error description]);
    
    NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
    NSString *className = NSStringFromClass([self class]);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate fireBaseUpdateData:className :url.absoluteString :postString :errorDescription];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   [self cleanData];
    NSError *error;
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(!emailId || [emailId isKindOfClass:[NSNull class]]) {
        if (statusCode == 200) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            dict = [dict objectForKey:@"result"];
            id arrResponse = dict;
            if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
            {
                NSArray *arrResults =  arrResponse;
                NSString*emailId = [[arrResults objectAtIndex:0] valueForKey:@"personemail"];
                [self dismissViewControllerAnimated:NO completion:^{
                    [self.delegate GlobalKeyViewControllerDelegateMethod :emailId];
                }];
            }
        }
        else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
           
            NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
            NSString *className = NSStringFromClass([self class]);
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate fireBaseUpdateData:className :url.absoluteString :postString :[dict objectForKey:@"detail"]];
           
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:[dict objectForKey:@"detail"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                // Ok action example
                [self->firstTxtField becomeFirstResponder];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else{
        if (statusCode == 200) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            dict = [dict objectForKey:@"result"];
            id arrResponse = dict;
            if ([arrResponse isKindOfClass:[NSArray class]] && arrResponse != nil && arrResponse != (id)[NSNull null])
            {
                NSArray *arrResults =  arrResponse;
                
                [self dismissViewControllerAnimated:NO completion:^{
                    [self.delegate PopViewToMainView:@""];
                }];
            }
        }
        else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            
            NSString *errorDescription = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
            NSString *className = NSStringFromClass([self class]);
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate fireBaseUpdateData:className :url.absoluteString :postString :[dict objectForKey:@"detail"]];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zenspace" message:[dict objectForKey:@"detail"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [self->firstTxtField becomeFirstResponder];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
    
    
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
////    if (textField.tag == 203 && ![firstTxtField.text isEqualToString:@""]&& ![secondTxtField.text isEqualToString:@""] && ![thirdTxtField.text isEqualToString:@""] &&![fourthTxtField.text isEqualToString:@""]) {
////        [self unlockButtonPressed:nil];
////    }
//}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 203 && ![firstTxtField.text isEqualToString:@""]&& ![secondTxtField.text isEqualToString:@""] && ![thirdTxtField.text isEqualToString:@""] &&![fourthTxtField.text isEqualToString:@""]) {
        [self unlockButtonPressed:nil];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UITextField *preTextField = ((UITextField *)[self.view viewWithTag:textField.tag-1]);
    if ([preTextField.text isEqualToString:@""]) {
        return NO;
    }
    
    if (![textField.text isEqualToString:@""]) {
        UITextField *nextTextField = ((UITextField *)[self.view viewWithTag:textField.tag+1]);
        if (nextTextField == nil || [nextTextField.text isEqualToString:@""]) {
            
        }
        else{
            return NO;
        }
        
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ((textField.text.length >= 0) && (string.length > 0))
    {
        // Try to find next responder
        
        UITextField *preTextField = ((UITextField *)[self.view viewWithTag:textField.tag-1]);
        if ([preTextField.text isEqualToString:@""]) {
            return NO;
        }
        
        textField.text = string;
        NSInteger nextTag = textField.tag + 1;
        
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (! nextResponder)
            nextResponder = [textField.superview viewWithTag:1];
        
        if (nextResponder)
            // Found next responder, so set it.
            [nextResponder becomeFirstResponder];
        
        if (textField.tag == 203){
            [textField resignFirstResponder];
        }
        
        return NO;
    }
    else if (string.length == 0)
    {
        // Try to find next responder
        
        
        textField.text = string;
        UITextField *preTextField = ((UITextField *)[self.view viewWithTag:textField.tag-1]);
        [preTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)keyboardInputShouldDelete:(UITextField *)textField {
    UITextField *preTextField = ((UITextField *)[self.view viewWithTag:textField.tag-1]);
    preTextField.text = @"";
    [preTextField becomeFirstResponder];
    return YES;
    
}
-(void)cleanData{
    firstTxtField.text = @"";
    secondTxtField.text = @"";
    thirdTxtField.text = @"";
    fourthTxtField.text = @"";
}
@end
