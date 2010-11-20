#import "MockPhotoSource.h"

#import <extThree20JSON/extThree20JSON.h>
#import "GTMNSString+URLArguments.h"

static NSString* kFacebookSearchFeedFormat = @"http://graph.facebook.com/search?q=%@&type=post";
const static NSUInteger kFlickrBatchSize = 16; 


@implementation MockPhotoSource

@synthesize title = _title;
@synthesize totalPhotos = _totalPhotos;
@synthesize page = _page;
@synthesize query = _query;

///////////////

- (NSString *)gtm_httpArgumentsString:(NSDictionary*) dictionary {
	NSMutableArray* arguments = [NSMutableArray arrayWithCapacity:[dictionary count]];
	NSEnumerator* keyEnumerator = [dictionary keyEnumerator];
	NSString* key;
	while ((key = [keyEnumerator nextObject])) {
		[arguments addObject:[NSString stringWithFormat:@"%@=%@",
							  [key gtm_stringByEscapingForURLArgument],
							  [[[dictionary objectForKey:key] description] gtm_stringByEscapingForURLArgument]]];
	}
	
	return [arguments componentsJoinedByString:@"&"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)myLoad:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
//- (void)myLoad {
	if (!self.isLoading) {
		//test flicker
		
		
		if (more) {
			NSLog(@"load more  _page : %d",_page);
			_page++;
		}

		NSLog(@"page : %d",self.page);
		
		NSString *batchSize = [NSString stringWithFormat:@"%lu", (unsigned long)kFlickrBatchSize];
		
		// Construct the request.
		NSString *host = @"http://api.flickr.com";
		NSString *path = @"/services/rest/";
		NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
									@"flickr.photos.search", @"method",
									self.query, @"text",
									@"url_m,url_t", @"extras",
									@"43f122b1a7fef3db2328bd75b38da08d", @"api_key", // I am providing my own API key as a convenience because I'm trusting you not to use it for evil.
									@"json", @"format",
									[NSString stringWithFormat:@"%lu", (unsigned long)self.page], @"page",
									batchSize, @"per_page",
									@"1", @"nojsoncallback",
									nil];
		
		NSString *url = [host stringByAppendingFormat:@"%@?%@", path, [self gtm_httpArgumentsString:parameters]];
		
		
		//   NSString* url = [NSString stringWithFormat:kFacebookSearchFeedFormat, _searchQuery];
		
		TTURLRequest* request = [TTURLRequest
								 requestWithURL: url
								 delegate: self];
		
		request.cachePolicy = TTURLRequestCachePolicyEtag;
		request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
		
		TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
		request.response = response;
		TT_RELEASE_SAFELY(response);
		
		[request send];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
	
	NSDictionary* feed = response.rootObject;

	// Drill down into the JSON object to get the parts
    // that we're actually interested in.
    NSDictionary *root = [feed objectForKey:@"photos"];
    int totalObjectsAvailableOnServer = [[root objectForKey:@"total"] integerValue];
	self.totalPhotos = totalObjectsAvailableOnServer;
	
    // Now wrap the results from the server into a domain-specific object.
    NSArray *entries = [root objectForKey:@"photo"];
	
	
	//TT_RELEASE_SAFELY(_photos);
	NSMutableArray* photos = [[NSMutableArray alloc] initWithCapacity:[entries count]];
	int i =0;
	for (NSDictionary* entry in entries) {

		MockPhoto* photo = [[MockPhoto alloc] initWithURL:[entry objectForKey:@"url_m"] 
												 smallURL:[entry objectForKey:@"url_t"]
													 size:CGSizeMake([[entry objectForKey:@"width_m"] floatValue],
																	[[entry objectForKey:@"height_m"] floatValue])
												  caption:[entry objectForKey:@"title"]];
		
		photo.photoSource = self;
		photo.index = (self.page -1)* kFlickrBatchSize + i++;
	
		[photos addObject:photo];
		TT_RELEASE_SAFELY(photo);
	}
	//_photos = photos;
	[_photos addObjectsFromArray:photos];
	TT_RELEASE_SAFELY(photos);
	
	NSLog(@"photos size : %d ",_photos.count);
	
	[super requestDidFinishLoad:request];
}


-(id)initWithQuery:(NSString*)query{
	if (self = [super init]) {
		self.page = 1;
		self.query = query;
	}
	return [self initWithType:MockPhotoSourceNormal title:nil photos:nil photos2:nil];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithType:(MockPhotoSourceType)type title:(NSString*)title photos:(NSArray*)photos
      photos2:(NSArray*)photos2 {
  if (self = [super init]) {
    _type = type;
    _title = [title copy];
    _photos = photos2 ? [photos mutableCopy] : [[NSMutableArray alloc] init];
    _tempPhotos = photos2 ? [photos2 retain] : [photos retain];
    _fakeLoadTimer = nil;

    for (int i = 0; i < _photos.count; ++i) {
      id<TTPhoto> photo = [_photos objectAtIndex:i];
      if ((NSNull*)photo != [NSNull null]) {
        photo.photoSource = self;
        photo.index = i;
      }
    }

    if (!(_type & MockPhotoSourceDelayed || photos2)) {
		[self performSelector:@selector(myLoad:more:) withObject:nil withObject:nil];
    }
  }
  return self;
}



- (void)dealloc {
  [_fakeLoadTimer invalidate];
  TT_RELEASE_SAFELY(_photos);
  TT_RELEASE_SAFELY(_tempPhotos);
  TT_RELEASE_SAFELY(_title);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModel

- (BOOL)isLoading {
	NSLog(@"%s",__FUNCTION__);
  return !!_fakeLoadTimer;
}

- (BOOL)isLoaded {
	NSLog(@"%s",__FUNCTION__);
	NSLog(@"isLoaded ? %d ", !!_photos);
  return !!_photos;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	NSLog(@"%s",__FUNCTION__);
  if (cachePolicy & TTURLRequestCachePolicyNetwork) {
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];

	  [self myLoad:cachePolicy more:more];
	  
  }
}

- (void)cancel {
	NSLog(@"%s",__FUNCTION__);
  [_fakeLoadTimer invalidate];
  _fakeLoadTimer = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTPhotoSource

- (NSInteger)numberOfPhotos {
	NSLog(@"%s",__FUNCTION__);
  //if (_tempPhotos) {
//    return _photos.count + (_type & MockPhotoSourceVariableCount ? 0 : _tempPhotos.count);
//  } else {
//    return _photos.count;
//  }
	NSLog(@"%d",self.totalPhotos);
	return self.totalPhotos;
}

- (NSInteger)maxPhotoIndex {
	NSLog(@"%s",__FUNCTION__);
  return _photos.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
	NSLog(@"%s",__FUNCTION__);
	NSLog(@"photoIndex %d",photoIndex);
  if (photoIndex < _photos.count) {
    id photo = [_photos objectAtIndex:photoIndex];
    if (photo == [NSNull null]) {
      return nil;
    } else {
      return photo;
    }
  } else {
    return nil;
  }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MockPhoto

@synthesize photoSource = _photoSource, size = _size, index = _index, caption = _caption;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size {
  return [self initWithURL:URL smallURL:smallURL size:size caption:nil];
}

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size
    caption:(NSString*)caption {
  if (self = [super init]) {
    _photoSource = nil;
    _URL = [URL copy];
    _smallURL = [smallURL copy];
    _thumbURL = [smallURL copy];
    _size = size;
    _caption = [caption copy];
    _index = NSIntegerMax;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_URL);
  TT_RELEASE_SAFELY(_smallURL);
  TT_RELEASE_SAFELY(_thumbURL);
  TT_RELEASE_SAFELY(_caption);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTPhoto

- (NSString*)URLForVersion:(TTPhotoVersion)version {
  if (version == TTPhotoVersionLarge) {
    return _URL;
  } else if (version == TTPhotoVersionMedium) {
    return _URL;
  } else if (version == TTPhotoVersionSmall) {
    return _smallURL;
  } else if (version == TTPhotoVersionThumbnail) {
    return _thumbURL;
  } else {
    return nil;
  }
}

@end
