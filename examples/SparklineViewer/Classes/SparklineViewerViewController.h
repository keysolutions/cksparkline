//
//  SparklineViewerViewController.h
//  SparklineViewer
//
//  Created by Adam Keys on 10-09-02.
//  Copyright Connex Keysolutions Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKSparkline.h"

@interface SparklineViewerViewController : UIViewController {
	CKSparkline *sparkline;
}

@property (nonatomic, retain) IBOutlet CKSparkline *sparkline;

@end

