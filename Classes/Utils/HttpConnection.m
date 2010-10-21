//
//  HttpConnection.m
//  Collab
//

#import "UIUtils.h"
#import "HttpConnection.h"

@implementation HttpConnection

@synthesize responseData = _responseData, userInfo = _userInfo;
@synthesize urlString = _urlString;

- (BOOL) isFree
{
	return (_urlConnection == nil);
}

- (id) initWithDelegate:(id) delegate userInfo:(NSObject*)userInfo;
{
	if (self = [super init])
	{
		_delegate = [delegate retain];
		_userInfo = [userInfo retain];
	}
	return self;
}

- (void) dealloc
{
	[self cancelRequest];
	
	_ReleaseObject(_urlString);
	
	_ReleaseObject(_delegate);
	_ReleaseObject(_userInfo);
	
	[super dealloc];
}

#pragma mark -

- (EStatusCode) sendRequestWithUrlString:(NSString*) urlString
{
	//	NSLog(serverURL);
	if (_urlConnection != nil)
		return EStatusRequestPending;

	_SetRetained(_urlString, urlString);

	NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[urlRequest setHTTPMethod:@"GET"];
	[urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
	
	_Assert(_urlConnection == nil);
	_urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	
	if (!_urlConnection)
		return EStatusURLConnectionError;
	
	return EStatusRequestSent;
}

+ (NSData*) sendSyncRequestWithUrlString:(NSString*) urlString;
{
	NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[urlRequest setHTTPMethod:@"GET"];
	[urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
	
	NSError* error = nil;
	return [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
}

+ (void) releaseConnection:(HttpConnection*) connection
{
	if (connection)
	{
		[connection cancelRequest];
		[connection release];
	}
}

-(void) cancelRequest
{
	[_urlConnection cancel];
	_ReleaseObject(_urlConnection);
	_ReleaseObject(_responseData);
}

- (void) logResponse
{
	//	NSLog(@"Response Received: %@", 
	//		  [[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] autorelease]);
}

- (NSString*) requestType
{
	if ([_urlString rangeOfString:@"login.php"].length > 0)
		return @"login";

	if ([_urlString rangeOfString:@"logout.php"].length > 0)
		return @"logout";

	if ([_urlString rangeOfString:@"currentUsers.php"].length > 0)
		return @"user-list";

	if ([_urlString rangeOfString:@"@quickNote.php"].length > 0)
		return @"quick-note";

	if ([_urlString rangeOfString:@"refresh.php"].length > 0)
		return @"document refresh";
	
	if ([_urlString rangeOfString:@"editNote.php"].length > 0)
	{
		if ([_urlString rangeOfString:@"action=new"].length > 0)
			return @"save";
		
		if ([_urlString rangeOfString:@"action=edit"].length > 0)		
			return @"save";
		
		if ([_urlString rangeOfString:@"action=delete"].length > 0)		
			return @"delete";
		
		return @"note refresh";
	}
	
	return @"image retrieval";
}

#pragma mark-

- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	_Assert(_urlConnection == connection);
	
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	NSUInteger responseStatusCode = [httpResponse statusCode];
	
	if ([_delegate respondsToSelector:@selector(requestRespondedWithStatus:connection:)])
		[_delegate requestRespondedWithStatus:responseStatusCode connection:self];
	
	if (responseStatusCode != 200)
	{	
		NSString* msg  = [NSHTTPURLResponse localizedStringForStatusCode:responseStatusCode];
		[UIUtils messageAlert:msg title:nil delegate:nil];

//		NSLog(@"The description is %@", [NSHTTPURLResponse localizedStringForStatusCode:responseStatusCode]);
		return;
	}
	
	_ReleaseObject(_responseData);
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	_Assert(_urlConnection == connection);

	if (_responseData == nil)
	{
		_responseData = [[NSMutableData dataWithData:data] retain];
	}
	else
	{
		[_responseData appendData:data];
	}
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	_Assert(_urlConnection == connection);
	
	_ReleaseObject(_urlConnection);
	
	[_delegate requestFailedWithError:error connection:self];
	
	
	
	NSString* requestType = [self requestType];
	if([requestType isEqualToString:@"image retrieval"])
		return;
	
	NSString* msg  = nil;
	if ([error code] == 22)
	{
		msg	 = @"No Network! Please check your network settings.";
	}
	else if ([error code] == -1001)
	{
		msg = [NSString stringWithFormat:@"Trying to send %@ request has timed out. Please try latter. Check your internet connection.", requestType];
	}
	else
	{
		msg  = [error localizedDescription];
	}
	
	[UIUtils messageAlert:msg title:nil delegate:nil];
	
	
}

- (void) connectionDidFinishLoading:(NSURLConnection*) connection 
{
	_Assert(_urlConnection == connection);
	//NSLog([_responseData description]);
	[_delegate requestCompletedWithData:_responseData  connection:self];
	NSMutableString* str = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
	NSLog(str);
	_ReleaseObject(_urlConnection);
}

@end
