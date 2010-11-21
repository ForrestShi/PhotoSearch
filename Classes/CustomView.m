/*
     File: CustomView.m
 Abstract: The custom view holding the image and title for the custom picker.
  Version: 2.8
 
 
 */

#import "CustomView.h"

#define MAIN_FONT_SIZE 18
#define MIN_MAIN_FONT_SIZE 16

@implementation CustomView

@synthesize title, image;

const CGFloat kViewWidth = 200;
const CGFloat kViewHeight = 44;

+ (CGFloat)viewWidth
{
    return kViewWidth;
}

+ (CGFloat)viewHeight 
{
    return kViewHeight;
}

- (id)initWithFrame:(CGRect)frame
{
	// use predetermined frame size
	if (self = [super initWithFrame:CGRectMake(0.0, 0.0, kViewWidth, kViewHeight)])
	{
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];	// make the background transparent
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	// draw the image and title using their draw methods
	CGFloat yCoord = (self.bounds.size.height - self.image.size.height) / 2;
	CGPoint point = CGPointMake(10.0, yCoord);
	[self.image drawAtPoint:point];
	
	yCoord = (self.bounds.size.height - MAIN_FONT_SIZE) / 2;
	point = CGPointMake(10.0 + self.image.size.width + 10.0, yCoord);
	[self.title drawAtPoint:point
					forWidth:self.bounds.size.width
					withFont:[UIFont systemFontOfSize:MAIN_FONT_SIZE]
					minFontSize:MIN_MAIN_FONT_SIZE
					actualFontSize:NULL
					lineBreakMode:UILineBreakModeTailTruncation
					baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
}

// Enable accessibility for this view.
- (BOOL)isAccessibilityElement
{
	return YES;
}

// Return a string that describes this view.
- (NSString *)accessibilityLabel
{
	return self.title;
}

- (void)dealloc
{
	[title release];
	[image release];
	
	[super dealloc];
}

@end
