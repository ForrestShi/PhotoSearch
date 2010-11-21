//
//  ChoosePhotoViewController.h
//  TTFacebook
//
//  Created by shi stone on 10-11-11.
//  Copyright 2010 cyanapple. All rights reserved.
//
#import "CustomPickerDataSource.h"

typedef enum{
	SearchPhotoFromFlickr,
	SearchFeedFromFacebook,
	SearchFeedFromTwitter,
	SearchModeDefault = SearchPhotoFromFlickr
}SearchMode;

@interface RootSearchViewController : TTViewController < CurrentPickerIndex> {
	UITextField *queryField;
	
	UIPickerView		*customPickerView;
	CustomPickerDataSource *customPickerDataSource;
	SearchMode currentMode;

}
@property (nonatomic, retain) UIPickerView *customPickerView;
@property (nonatomic, retain) CustomPickerDataSource *customPickerDataSource;

@end
