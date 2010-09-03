#import <UIKit/UIKit.h>

@class SparklineViewerViewController;

@interface SparklineViewerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SparklineViewerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SparklineViewerViewController *viewController;

@end

