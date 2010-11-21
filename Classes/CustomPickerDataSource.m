/*
     File: CustomPickerDataSource.m
 Abstract: The data source for the Custom Picker that displays text and images.
  Version: 2.8
 
 
 */

#import "CustomPickerDataSource.h"
#import "CustomView.h"

@implementation CustomPickerDataSource

@synthesize customPickerArray;
@synthesize indexDelegate;

- (id)init
{
	// use predetermined frame size
	self = [super init];
	if (self)
	{
		// create the data source for this custom picker
		NSMutableArray *viewArray = [[NSMutableArray alloc] init];

		CustomView *earlyMorningView = [[CustomView alloc] initWithFrame:CGRectZero];
		earlyMorningView.title = @"Search Photos from Flickr";
		earlyMorningView.image = [UIImage imageNamed:@"flickr48.png"];
		[viewArray addObject:earlyMorningView];
		[earlyMorningView release];

		CustomView *lateMorningView = [[CustomView alloc] initWithFrame:CGRectZero];
		lateMorningView.title = @"Search Feeds from Facebook";
		lateMorningView.image = [UIImage imageNamed:@"facebook_logo48.png"];
		[viewArray addObject:lateMorningView];
		[lateMorningView release];

		CustomView *afternoonView = [[CustomView alloc] initWithFrame:CGRectZero];
		afternoonView.title = @"Search Feeds from Twitter";
		afternoonView.image = [UIImage imageNamed:@"twitter48.png"];
		[viewArray addObject:afternoonView];
		[afternoonView release];

		self.customPickerArray = viewArray;
		[viewArray release];
	}
	return self;
}

- (void)dealloc
{
	[indexDelegate release];
	[customPickerArray release];
	[super dealloc];
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return [CustomView viewWidth];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return [CustomView viewHeight];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [customPickerArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


#pragma mark -
#pragma mark UIPickerViewDelegate
  
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	// pass current selection index to delegate 
	if ([indexDelegate respondsToSelector:@selector(retrieveCurrentIndex:)]) {
		[indexDelegate retrieveCurrentIndex:&row];
	}
}

// tell the picker which view to use for a given component and row, we have an array of views to show
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component reusingView:(UIView *)view
{
	
	return [customPickerArray objectAtIndex:row];
}

@end
