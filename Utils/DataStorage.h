//
//  DataStorage.h
//  Nyhtr
//

#import <Foundation/Foundation.h>


@interface DataStorage : NSObject 
{	
	NSString* _categoryName;
}

@property (nonatomic, retain) NSString* categoryName;

+ (DataStorage*) sharedObject;
- (void) dealloc;

@end
