#import "CKSparkline.h"

@implementation CKSparkline

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initializeDefaults];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeDefaults];
    }
    
    return self;
}

#pragma mark - View Configuration

@synthesize selected;
@synthesize lineColor;
@synthesize lineWidth;
@synthesize highlightedLineColor;
@synthesize drawPoints;
@synthesize drawArea;

- (void)initializeDefaults
{
    self.selected = NO;
    self.backgroundColor = [UIColor clearColor];
    self.lineColor = [UIColor colorWithWhite:0.65 alpha:1.0];
    self.highlightedLineColor = [UIColor whiteColor];
    self.lineWidth = 1.0;
    self.drawPoints = NO;
    self.drawArea = NO;
}

- (void)setSelected:(BOOL)isSelected
{
    selected = isSelected;    
    [self setNeedsDisplay];
}

#pragma mark - Data Management

@synthesize data;
@synthesize computedData;

- (void)setData:(NSArray *)newData
{
    CK_ARC_RELEASE(data);
    data = CK_ARC_RETAIN(newData);
    
    [self recalculateComputedData];
    [self setNeedsDisplay];
}

- (void)recalculateComputedData
{
    CGFloat max = 0.0;
    CGFloat min = FLT_MAX;
    NSMutableArray *mutableComputedData = [[NSMutableArray alloc] initWithCapacity:[self.data count]];
    
    for (NSNumber *dataValue in self.data) {
        min = MIN([dataValue floatValue], min);
        max = MAX([dataValue floatValue], max);
    }
    
    for (NSNumber *dataValue in self.data) {
        CGFloat floatValue = ([dataValue floatValue] - min) / (max - min + 1.0);
        NSNumber *value = [[NSNumber alloc] initWithFloat:floatValue];
        
        [mutableComputedData addObject:value];
        
        CK_ARC_RELEASE(value);
    }
    
    CK_ARC_RELEASE(computedData);    
    computedData = mutableComputedData;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if ([self.computedData count] < 1) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef displayColor = [(self.selected ? self.highlightedLineColor : self.lineColor) CGColor];
    CGContextSetStrokeColorWithColor(context, displayColor);    
    CGContextSetLineWidth(context, self.lineWidth);
    
    [self updateBoundary];
    
    if (self.drawArea) {
        UIColor *displayColorInstance = [UIColor colorWithCGColor:displayColor];
        UIColor *areaColor = [displayColorInstance colorWithAlphaComponent:0.4];
        
        CGContextSetFillColorWithColor(context, [areaColor CGColor]);
        [self drawAreaInRect:rect withContext:context];
    }
    
    [self drawLineInRect:rect withContext:context];
    
    if (self.drawPoints) {
        CGContextSetFillColorWithColor(context, displayColor);
        [self drawPointsInRect:rect withContext:context];
    }
}

- (void)drawLineInRect:(CGRect)rect withContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextBeginPath(context);                
    CGContextMoveToPoint(context, boundary.min.x, boundary.max.y - (boundary.max.y - boundary.min.y) * [[computedData objectAtIndex:0] floatValue]);
    
    for (int i = 1; i < [self.computedData count]; i++) {
        CGPoint point = calculatePosition(self.computedData, i, &boundary);
        CGContextAddLineToPoint(context, point.x, point.y);        
    }
    
    CGContextStrokePath(context);    
    CGContextRestoreGState(context);
}

- (void)drawAreaInRect:(CGRect)rect withContext:(CGContextRef)context
{
    CGPoint point;
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);                
    CGContextMoveToPoint(context, boundary.min.x, boundary.max.y - (boundary.max.y - boundary.min.y) * [[computedData objectAtIndex:0] floatValue]);
    
    for (int i = 1; i < [self.computedData count]; i++) {
        point = calculatePosition(self.computedData, i, &boundary);
        CGContextAddLineToPoint(context, point.x, point.y);        
    }
    
    CGContextAddLineToPoint(context, point.x, CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, boundary.min.x, CGRectGetMaxY(rect));
    
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}

- (void)drawPointsInRect:(CGRect)rect withContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    CGFloat pointSize = calculatePointSize(self.lineWidth);
    
    CGContextFillEllipseInRect(context, CGRectMake(boundary.min.x - pointSize / 2.0, (boundary.max.y - (boundary.max.y - boundary.min.y) * [[computedData objectAtIndex:0] floatValue]) - pointSize / 2.0, pointSize, pointSize));
    
    for (int i = 1; i < [self.computedData count]; i++) {
        if (i == [self.computedData count] - 1) {
            CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
        }
        
        CGPoint point = calculatePosition(self.computedData, i, &boundary);
        CGContextFillEllipseInRect(context, CGRectMake(point.x - pointSize / 2.0, point.y - pointSize / 2.0, pointSize, pointSize));
    }
    
    CGContextRestoreGState(context);
}

- (void)updateBoundary
{
    CGRect lineRect;
    CGFloat lineSize = self.lineWidth;
    CGFloat pointSize = calculatePointSize(lineSize);
    
    if (self.drawPoints) {
        lineRect = CGRectInset(self.bounds, lineSize / 2.0 + pointSize, lineSize / 2.0 + pointSize);
    } else {
        lineRect = CGRectInset(self.bounds, lineSize, lineSize);
    }
    
    CKBoundary lineBoundary = {
        { CGRectGetMinX(lineRect), CGRectGetMinY(lineRect) },
        { CGRectGetMaxX(lineRect), CGRectGetMaxY(lineRect) }
    };
    
    boundary = lineBoundary;
}

#pragma mark Helper Functions

static inline CGFloat calculatePointSize(CGFloat lineWidth)
{
    return lineWidth + log(20.0 * lineWidth);
}

static inline CGPoint calculatePosition(NSArray *data, int index, CKBoundary *boundary)
{
    return CGPointMake(boundary->min.x + (boundary->max.x - boundary->min.x) * ((CGFloat)index / ([data count] - 1)), boundary->max.y - (boundary->max.y - boundary->min.y) * [[data objectAtIndex:index] floatValue]);
}

#pragma mark -

- (void)dealloc
{    
#if ! __has_feature(objc_arc)
    [super dealloc];
    
    [data release];
    [computedData release];    
    [lineColor release];
    [highlightedLineColor release];
#endif
}

@end
