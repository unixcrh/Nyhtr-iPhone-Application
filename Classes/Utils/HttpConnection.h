//
//  HttpConnection.h
//
#import "UIPrefix.h"
#define	_ReleaseHttpConnection(obj)					{ [HttpConnection releaseConnection:obj]; obj = nil; }

@class HttpConnection;

@protocol HttpConnectionDelegate <NSObject>

@optional
- (void) requestRespondedWithStatus:(NSUInteger)statusCode connection:(HttpConnection*)connection;

@required
- (void) requestFailedWithError:(NSError*) errorCode connection:(HttpConnection*)connection;
- (void) requestCompletedWithData:(NSData*)data connection:(HttpConnection*)connection;

@end

@interface HttpConnection : NSObject 
{
	NSString*			_urlString;
	NSURLConnection*	_urlConnection;
	NSMutableData*		_responseData;

	id<HttpConnectionDelegate>	_delegate;
	NSObject*					_userInfo;
}

@property(nonatomic, readonly) NSString*	urlString;
@property(nonatomic, readonly) NSData*		responseData;
@property(nonatomic, readonly) NSObject*	userInfo;

@property(nonatomic, readonly) BOOL			isFree;


- (id) initWithDelegate:(id) delegate userInfo:(NSObject*)userInfo;

- (EStatusCode) sendRequestWithUrlString:(NSString*) urlString;
+ (NSData*) sendSyncRequestWithUrlString:(NSString*) urlString;

- (void) cancelRequest;
- (void) logResponse;

- (NSString*) requestType;

+ (void) releaseConnection:(HttpConnection*) connection;

@end
