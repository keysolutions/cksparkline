#import <UIKit/UIKit.h>

// Define ARC_RETAIN/ARC_RELEASE macros for conditional support of the ARC 
// memory management features. When ARC is enabled, the value is assigned
// to itself to silence compiler warnings.

#if ! __has_feature(objc_arc)

#define CK_ARC_RETAIN(o) [(o) retain]
#define CK_ARC_RELEASE(o) [(o) release]

#else

#define CK_ARC_RETAIN(o) (o = o)
#define CK_ARC_RELEASE(o) (o = o)

#endif


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
