//
//  SparklineViewerAppDelegate.h
//  SparklineViewer
//
//  Created by Adam Keys on 10-09-02.
//  Copyright Connex Keysolutions Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SparklineViewerViewController;

@interface SparklineViewerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SparklineViewerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SparklineViewerViewController *viewController;

@end

