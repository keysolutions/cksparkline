#import <UIKit/UIKit.h>
#import "CKSparkline.h"

@interface SparklineViewerViewController : UIViewController {
    CKSparkline *sparkline;
}

@property (nonatomic, retain) IBOutlet CKSparkline *sparkline;

@end

