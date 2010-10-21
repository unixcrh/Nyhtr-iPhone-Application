//
//  ServerConnection.h
//  MedeFile
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject
{
	NSURLConnection*	_connection;
	NSMutableData*		_data;
	NSArray*			_array;
	//NSInteger			_error;
}


@property (nonatomic, retain) NSMutableData* data;
//@property (nonatomic) NSInteger error;

-(void) connectionRequest:(NSString* ) request;
+ (BOOL) saveResponseData:(NSData*)data asFile:(NSString*) filename;
@end
