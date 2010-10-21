//
//  ServerConnection.m
//  MedeFile
//
#import "UIPrefix.h"
#import "XMLNodeString.h"
#import "NyhtrAppDelegate.h"
#import "ServerConnection.h"

@implementation ServerConnection

@synthesize data = _data;

-(void) connectionRequest:(NSString* )request
{
	if(_data)
	{
		[_data release];
		_data = nil;
	}
	NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
	_connection =  [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]; 
}

- (void) connection:(NSURLConnection* ) connection didFailWithError:(NSError* ) error
{
}

- (void) connection:(NSURLConnection* ) connection didReceiveResponse:(NSURLResponse* ) response
{
}

- (void) connection:(NSURLConnection* ) connection didReceiveData:(NSData* ) data
{
	if (!_data)
		_data = [[NSMutableData alloc] init];
	[_data appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection* )connection
{	
	NSXMLDocument* xDoc = [[NSXMLDocument alloc] initWithData:_data options:0 error:nil];
	NSXMLElement* rootElement = [xDoc rootElement];
	
	if (rootElement)
	{		
		NyhtrAppDelegate *appDelegate = (NyhtrAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		if (YES == appDelegate.isSetItems)
		{
			NSXMLElement* element = [rootElement elementForName:@"channel"];
			_array = [[NSArray alloc]initWithArray:[element elementsForName:@"item"]];
			[appDelegate setItems:_array];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"getDataForTable" object:nil userInfo:nil];
		}
		else if (YES == appDelegate.isSetIcons)
		{			
			_array = [[NSArray alloc]initWithArray:[rootElement elementsForName:@"source"]];
			[appDelegate setIcons:_array];
		}
		else
		{
			// nothing to do
		}					
				
		[_array autorelease];		
	}	
}

#pragma mark -

+ (BOOL) saveResponseData:(NSData*)data asFile:(NSString*) filename;
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* docDirectry = [paths objectAtIndex:0];
	docDirectry = [docDirectry stringByAppendingPathComponent:filename];
	[data writeToFile:docDirectry atomically:YES];
	return TRUE;
}

@end
