//
//  eDynamoController.h
//  MTSCRADemo
//
//  Created by Tam Nguyen on 7/22/15.
//  Copyright (c) 2015 MagTek. All rights reserved.
//

#import "MTDataViewerViewController.h"
#import "BLEScannerList.h"
#import "optionController.h"
@interface eDynamoController : MTDataViewerViewController<MTSCRAEventDelegate, BLEScanListEvent, optionControllerEvent,NSXMLParserDelegate>
{
    NSString *currentElement;
    BOOL isCardSwipe;

}
- (void)startEMV;

@property (nonatomic, strong) UIButton* btnStartEMV;
@property (nonatomic, strong) UIButton* btnCancel;
@property (nonatomic, strong) UIButton* btnReset;
@property (nonatomic, strong) UIButton* btnOptions;
@end
