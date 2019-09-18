#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//the length of time before your application "times out". This number actually represents seconds, so we'll have to multiple it by 60 in the .m file
#define kApplicationTimeoutInMinutes 3

//the notification your AppDelegate needs to watch for in order to know that it has indeed "timed out"
#define kApplicationDidTimeoutNotification @"AppTimeOut"

@interface TIMERUIApplication : UIApplication
{
    NSTimer     *myidleTimer;
}

-(void)resetIdleTimer;

@end
