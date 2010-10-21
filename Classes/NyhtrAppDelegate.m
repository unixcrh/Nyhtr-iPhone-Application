//
//  NyhtrAppDelegate.m
//  Nyhtr
//

#import "NyhtrAppDelegate.h"
#import "DataStorage.h"

@implementation NyhtrAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize items = _items;
@synthesize icons = _icons;
@synthesize isSetItems = _isSetItems;
@synthesize isSetIcons = _isSetIcons;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{        
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
		// initially all BOOLs are YES
	_isSetItems = NO;
	_isSetIcons = NO;		
}


- (void)dealloc 
{
	if(_items)
		[_items release];
	
	DataStorage* sharedObject = [DataStorage sharedObject];
	[sharedObject release];
	sharedObject = nil;
	
    [viewController release];
    [window release];
    [super dealloc];
}

- (void) setItems:(NSArray*) itemsData
{
		// release all previous data
	if(_items)
		[_items release];	
	_items = nil;
	
		// fill with new items data
	_items = [[NSArray alloc]initWithArray:itemsData];
	
		// items data had set, so
	_isSetItems = NO;
}

- (void) setIcons:(NSArray*) iconsData
{
		// release all previous data
	if(_icons)
		[_icons release];	
	_icons = nil;
	
		// fill with new icon data
	_icons = [[NSArray alloc]initWithArray:iconsData];
	
		// icons data had set, so
	_isSetIcons = NO;
}

@end
