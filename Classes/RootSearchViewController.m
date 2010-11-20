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

- (id)init
{
    if ((self = [super init])) {
        self.title = @"Photo example";
       
    }
    return self;
}

- (void)doSearch
{
    NSLog(@"Searching for %@", queryField.text);
    
    [queryField resignFirstResponder];
  
	// search photos from flickr 
    PhotoThumbsViewController *thumbs = [[PhotoThumbsViewController alloc] initWithQuery:queryField.text];
   
    [self.navigationController pushViewController:thumbs animated:YES];
    [thumbs release];

	//search feed from facebook
//	SearchFeedViewController* feedViewController = [[SearchFeedViewController alloc] initWithQuery:queryField.text withFeedType:TWITTER];
//	[self.navigationController pushViewController:feedViewController animated:YES	];
//	feedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//	[feedViewController release];
}

- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
    self.view.backgroundColor = [UIColor blackColor];//[UIColor colorWithWhite:1.0f alpha:1.f];
    
    // Search query field.
	CGRect frame = TTApplicationFrame();
    queryField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/10,frame.size.height/20,frame.size.width*8/10,40)];
    queryField.placeholder = @"Image Search Key Words";
    queryField.autocorrectionType = NO;
    queryField.autocapitalizationType = NO;
    queryField.clearsOnBeginEditing = YES;
    queryField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:queryField];
	
    // Search button.
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(190.f, 140.f, 100.f, 44.f)];
    [searchButton addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
}

- (void)dealloc
{
    [queryField release];
    [super dealloc];
}




@end

