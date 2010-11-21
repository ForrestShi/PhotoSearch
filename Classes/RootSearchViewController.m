//
//  ChoosePhotoViewController.m
//  TTFacebook
//
//  Created by shi stone on 10-11-11.
//  Copyright 2010 cyanapple. All rights reserved.
//

#import "RootSearchViewController.h"
#import "PhotoThumbsViewController.h"
#import "TTFacebookSearchFeedModel.h"

#import "SearchFeedViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RootSearchViewController

@synthesize customPickerView ,customPickerDataSource;

- (void)dealloc
{
	[customPickerView release];
	[customPickerDataSource release];
    [queryField release];
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
        self.title = @"Photo example";
       
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil	{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibNameOrNil]) {
		//
	}
	return self;

}

#pragma mark 
#pragma mark UIPickerView - Custom Picker
// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
								   screenRect.size.height - 84.0 - size.height,
								   size.width,
								   size.height);
	return pickerRect;
}


- (void)createCustomPicker
{
	customPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	customPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	// setup the data source and delegate for this picker
	customPickerDataSource = [[CustomPickerDataSource alloc] init];
	customPickerDataSource.indexDelegate = self;
	customPickerView.dataSource = customPickerDataSource;
	customPickerView.delegate = customPickerDataSource;
	
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
	CGSize pickerSize = [customPickerView sizeThatFits:CGSizeZero];
	customPickerView.frame = [self pickerFrameWithSize:pickerSize];
	customPickerView.showsSelectionIndicator = YES;
	
	// add this picker to our view controller, initially hidden
	//customPickerView.hidden = YES;
	[self.view addSubview:customPickerView];
}

#pragma mark 
#pragma mark CurrentPickerIndex methods

-(void)retrieveCurrentIndex:(NSInteger*)index{
	currentMode = *index;
}

- (void)doSearch
{
    NSLog(@"Searching for %@", queryField.text);
    
    [queryField resignFirstResponder];
  
	
	switch (currentMode) {
		case SearchPhotoFromFlickr:
		{
			PhotoThumbsViewController *thumbs = [[PhotoThumbsViewController alloc] initWithQuery:queryField.text];
			
			[self.navigationController pushViewController:thumbs animated:YES];
			[thumbs release];
			break;
		}
		case SearchFeedFromFacebook:
		{
			SearchFeedViewController* feedViewController = [[SearchFeedViewController alloc] initWithQuery:queryField.text withFeedType:TWITTER];
			[self.navigationController pushViewController:feedViewController animated:YES	];
			feedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[feedViewController release];
			break;
		}
		default:
			break;
	}

}

- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithWhite:1.0f alpha:1.f];
    
	long offsetY = 0;
    // Search query field.
	CGRect frame = TTApplicationFrame();
    queryField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/10,frame.size.height/20,frame.size.width*8/10,40)];
    queryField.placeholder = @"Image Search Key Words";
    queryField.autocorrectionType = NO;
    queryField.autocapitalizationType = NO;
    queryField.clearsOnBeginEditing = YES;
    queryField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:queryField];
	
	offsetY += 50;
    // Search button.
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(frame.size.width*0.7,frame.size.height/20 + offsetY,frame.size.width*0.2,40)];
    [searchButton addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
	
	[self createCustomPicker];
}

@end

