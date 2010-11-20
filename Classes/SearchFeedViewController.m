//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "SearchFeedViewController.h"

#import "TTFacebookSearchFeedDataSource.h"
#import "TTTwitterSearchFeedDataSource.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SearchFeedViewController

@synthesize query = _query;
@synthesize type = _type;

-(id)initWithQuery:(NSString*)query withFeedType:(FeedSearchType)feedType{
	if (self = [super init]) {
		self.query = query;
		self.type = feedType;
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Facebook feed";
    self.variableHeightRows = YES;
	 
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
	switch (_type) {
		case FACEBOOK:
			self.dataSource = [[[TTFacebookSearchFeedDataSource alloc]
								initWithSearchQuery:self.query] autorelease];
			break;
		case TWITTER:
			self.dataSource = [[[TTTwitterSearchFeedDataSource alloc]
								initWithSearchQuery:self.query] autorelease];
			break;
		default:
			break;
	}
  
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


@end

