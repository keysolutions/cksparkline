#import <UIKit/UIKit.h>
#import "arc.h"

@interface CKSparkline : UIView {
    BOOL selected;

    UIColor *lineColor;
    CGFloat lineWidth;
    UIColor *highlightedLineColor;
    
    NSArray *data;
    NSArray *computedData;
}

@property (readonly) BOOL selected;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *highlightedLineColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, retain) NSArray *data;
@property (readonly) NSArray *computedData;

- (void)initializeDefaults;
- (void)setSelected:(BOOL)isSelected;
- (void)recalculateComputedData;

@end
