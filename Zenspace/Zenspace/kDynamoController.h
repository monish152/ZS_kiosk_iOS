//
//  kDynamoControllerViewController.h
//  MTSCRADemo
//
//  Created by Tam Nguyen on 8/29/16.
//  Copyright © 2016 MagTek. All rights reserved.
//

#import "MTDataViewerViewController.h"
#import "eDynamoController.h"
@interface kDynamoController : eDynamoController<MTSCRAEventDelegate>
{
    
}

-(IBAction)api:(id)sender;
@end
