#import <UIKit/UIKit.h>


@interface CKSparkline : UIView {
	BOOL selected;
	UIColor *lineColor;
	UIColor *highlightedLineColor;
	NSArray *data;
	NSArray *computedData;
	int lineWidth;
}


@property (readonly) BOOL selected;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *highlightedLineColor;
@property (nonatomic) int lineWidth;
@property (readonly) NSArray *data;
@property (readonly) NSArray *computedData;


- (void)setSelected:(BOOL)isSelected;
- (void)setData:(NSArray *)newData;

@end
