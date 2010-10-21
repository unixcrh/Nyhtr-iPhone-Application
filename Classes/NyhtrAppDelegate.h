//
//  NyhtrAppDelegate.h
//  Nyhtr
//


#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "NyhtrViewController.h"
#import "CommonLiterals.h"

@interface NyhtrAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow*				window;
    NyhtrViewController*	viewController;
	
	NSArray*				_icons;
	NSArray*				_items;    
	BOOL					_isSetItems;
	BOOL					_isSetIcons;
	ServerConnection*		_connection;
}

@property (nonatomic, retain) IBOutlet UIWindow*				window;
@property (nonatomic, retain) IBOutlet NyhtrViewController*	viewController;
@property (nonatomic, retain) NSArray*				items;
@property (nonatomic, retain) NSArray*				icons;
@property (nonatomic) BOOL							isSetItems;
@property (nonatomic) BOOL							isSetIcons;

- (void) setItems:(NSArray*)itemsList;
- (void) setIcons:(NSArray*)iconsData;


@end

