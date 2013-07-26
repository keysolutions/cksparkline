#import <UIKit/UIKit.h>
#import <math.h>

// Define ARC_RETAIN/ARC_RELEASE macros for conditional support of the ARC 
// memory management features. When ARC is enabled, the value is assigned
// to itself to silence compiler warnings.

#if ! __has_feature(objc_arc)

#define CK_ARC_RETAIN(o) [(o) retain]
#define CK_ARC_RELEASE(o) [(o) release]

#else

#define CK_ARC_RETAIN(o) o
#define CK_ARC_RELEASE(o) (void)0

#endif

typedef struct 
{
    CGPoint min;
    CGPoint max;
} CKBoundary;

static inline CGFloat calculatePointSize(CGFloat lineWidth);
static inline CGPoint calculatePosition(NSArray *data, int index, CKBoundary *boundary);

@interface CKSparkline : UIView {
    BOOL selected;

    UIColor *lineColor;
    CGFloat lineWidth;
    UIColor *highlightedLineColor;
    BOOL drawPoints;
    
    NSArray *data;
    NSArray *computedData;
    
    CKBoundary boundary;
}

@property (readonly) BOOL selected;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *highlightedLineColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) BOOL drawPoints;
@property (nonatomic) BOOL drawArea;
@property (nonatomic, retain) NSArray *data;
@property (readonly) NSArray *computedData;

- (void)initializeDefaults;
- (void)setSelected:(BOOL)isSelected;

- (void)recalculateComputedData;

- (void)drawLineInRect:(CGRect)rect withContext:(CGContextRef)context;
- (void)drawAreaInRect:(CGRect)rect withContext:(CGContextRef)context;
- (void)drawPointsInRect:(CGRect)rect withContext:(CGContextRef)context;
- (void)updateBoundary;

@end
