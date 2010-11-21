/*
     File: CustomPickerDataSource.h
 Abstract: The data source for the Custom Picker that displays text and images.
  Version: 2.8
 
 
 */

@protocol CurrentPickerIndex <NSObject>

-(void)retrieveCurrentIndex:(NSInteger*)index;

@end


@interface CustomPickerDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate >
{
	NSArray	*customPickerArray;
	id<CurrentPickerIndex> indexDelegate;
}

@property (nonatomic, retain) NSArray *customPickerArray;
@property (nonatomic, assign) id<CurrentPickerIndex> indexDelegate;


@end
