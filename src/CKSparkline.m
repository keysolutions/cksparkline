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

- (void)initializeDefaults
{
    self.selected = NO;
    self.backgroundColor = [UIColor clearColor];
    self.lineColor = [UIColor colorWithWhite:0.65 alpha:1.0];
    self.highlightedLineColor = [UIColor whiteColor];
    self.lineWidth = 1.0;
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
    if ([self.computedData count] < 1)
        return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect lineRect = CGRectInset(rect, self.lineWidth / 2, self.lineWidth / 2);
    CGFloat minX = CGRectGetMinX(lineRect);
    CGFloat maxX = CGRectGetMaxX(lineRect);
    CGFloat minY = CGRectGetMinY(lineRect);
    CGFloat maxY = CGRectGetMaxY(lineRect);
    
    CGColorRef strokeColor = [(self.selected ? self.highlightedLineColor : self.lineColor) CGColor];
    CGContextSetStrokeColorWithColor(context, strokeColor);
    CGContextSetLineWidth(context, self.lineWidth);

    CGContextBeginPath(context);                
    CGContextMoveToPoint(context, minX, maxY - (maxY - minY) * [[computedData objectAtIndex:0] floatValue]);
    
    for (int i = 1; i < [self.computedData count]; i++) {
        CGContextAddLineToPoint(context, minX + (maxX - minX) * ((CGFloat)i / ([self.computedData count] - 1)), maxY - (maxY - minY) * [[self.computedData objectAtIndex:i] floatValue]);
    }
    
    CGContextStrokePath(context);
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
