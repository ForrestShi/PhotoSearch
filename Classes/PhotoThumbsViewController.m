#import "PhotoThumbsViewController.h"
#import "MockPhotoSource.h"

@implementation PhotoThumbsViewController


-(id)initWithQuery:(NSString*)query{
	if (self = [super init]) {
		self.photoSource = [[MockPhotoSource alloc] initWithQuery: query];
	}
	return self;
}

@end
