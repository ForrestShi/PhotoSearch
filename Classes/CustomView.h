/*
     File: CustomView.h
 Abstract: The custom view holding the image and title for the custom picker.
  Version: 2.8
 
 
 */

#import <UIKit/UIKit.h>

@interface CustomView : UIView
{
	NSString *title;
	UIImage *image;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImage *image;

+ (CGFloat)viewWidth;
+ (CGFloat)viewHeight;

@end
