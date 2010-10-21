//
//  DataStorage.m
//  Nyhtr
//
#import "DataStorage.h"

@implementation DataStorage

@synthesize categoryName = _categoryName;

static DataStorage* dataStorage = nil;

+ (DataStorage*) sharedObject
{
	if (nil == dataStorage)
		dataStorage = [[DataStorage alloc] init];
	return dataStorage;
}

-(void) dealloc
{
	if (nil != dataStorage)
		[dataStorage release];
	[super dealloc];
}

@end
