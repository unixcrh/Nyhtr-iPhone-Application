//
//  UIUtils.m
//
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

#import "GSNSDataExtensions.h"
#import "UIUtils.h"

@implementation UIUtils

+ (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

+ (void) messageAlertWithOkCancel:(NSString*)msg title:(NSString*)title delegate:(id)delegate
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
												   delegate: delegate cancelButtonTitle: @"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

+ (void) errorAlert:(NSString*)msg;
{
	[UIUtils messageAlert:msg title:@"Error" delegate:nil];
}

+ (void) localizedErrorAlert:(NSString*)strId
{
	[UIUtils messageAlert:strId title:@"Message" delegate:nil];
}

+ (void) conditionFailedMsg:(NSString*)condition filename:(NSString*)fname line:(int)line
{
	NSString* str = [NSString stringWithFormat:@"Condition Failed (%@)\n\n%@\nLine No: %d", condition, fname, line];
	[UIUtils messageAlert:str title:@"DebugError (Please report)" delegate:nil];
}




# pragma mark -

+ (BOOL) isString:(NSString*)str inArray:(NSArray*)array
{
	for (id s in array)
	{
		if (_IsSameString(str, s))
			return YES;
	}
	return NO;
}

+ (NSString*) base64StringFromString:(NSString*)string
{
	_Assert_ReturnExp(string, nil);
		
	NSData* strData = [string dataUsingEncoding:NSUTF8StringEncoding];
	return [strData base64EncodingWithLineLength:0];
}

+ (NSString*) stringFromBase64String:(NSString*)string
{
	_Assert_ReturnExp(string, nil);
	NSString* str = [[NSString alloc] initWithData:[NSData dataWithBase64EncodedString:string] encoding:NSUTF8StringEncoding];
	return [str autorelease];
}

+ (UIImage*) cropImage:(UIImage*)inImage ofSize:(CGSize) inSize
{
	if (inImage)
	{
		CGRect thumbRect = CGRectMake(0, 0, inSize.width, inSize.height);
		UIGraphicsBeginImageContext(inSize);
		[inImage drawInRect:thumbRect];
		UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
///		[thumbImage retain];
		UIGraphicsEndImageContext();
		return thumbImage;
	}
	else 
		return nil;
}

#pragma mark -

+ (NSString*) stringFromImage:(UIImage*)image
{
	_Assert_ReturnExp(image, nil);
	
	NSData* imageData = UIImagePNGRepresentation(image);
	
	NSString* str = [imageData base64EncodingWithLineLength:80];
	return str;
	
}

+ (UIImage*) imageFromString:(NSString*)imageString
{
	_Assert_ReturnExp(imageString, nil);
	NSData* imageData = [NSData dataWithBase64EncodedString:imageString];
	return [UIImage imageWithData: imageData];
}

#pragma mark -


+ (BOOL) isConnectedToNetwork
{
#ifdef _SCNetwrokFrameworkAvailable
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	// synchronous model

	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		NSLog(@"Error. Could not recover network reachability flags\n");
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	//return (isReachable && !needsConnection) ? YES : NO;
	//BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	return (isReachable && !needsConnection);
#else
	return NO;
#endif
}


+ (void) addNotificationToQueue:(NSString*)name object:(id)inObject userInfo:(NSDictionary*)dictionary postingStyle:(NSPostingStyle)style
{
	NSNotification* notification = [NSNotification notificationWithName:(NSString *)name object:(id)inObject userInfo:dictionary];

	[[NSNotificationQueue defaultQueue] dequeueNotificationsMatching:notification coalesceMask:NSNotificationCoalescingOnName];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:style];
}

+ (BOOL) checkForSpecialCharacter:(NSString*) string
{
	NSString* str = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYZ1234567890.-_";
	NSCharacterSet* alfaNumericSet = [NSCharacterSet characterSetWithCharactersInString:str];
	for (int i = 0; i < string.length; ++i)
	{
		if (![alfaNumericSet characterIsMember:[string characterAtIndex:i]])
			return YES;
	}
	return NO;
}


+ (void) moveViewFor:(UIViewController*) viewC xOffset:(CGFloat)x yOffset: (CGFloat)y
{
#ifdef _ShowStatusBar
	_Assert(viewC && viewC.view);
	CGRect r = viewC.view.frame;
	r.origin.y -= 20;
	viewC.view.frame = r;
#endif
	
}

#pragma mark -

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (paths.count <= 0)
		return nil;

	NSString* dirPath = [paths objectAtIndex:0];
	if (subpath)
		dirPath = [dirPath stringByAppendingFormat:@"/%@", subpath];

	return dirPath;
}

#pragma mark  url encoder

+ (NSString*) urlEncodeValue:(NSString*) string
{
	_Assert(string);
	
	NSString* result = (NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																		   (CFStringRef)string,
																		   NULL,
																		   CFSTR("-/:;()$&@\"'!?,.[]{}#%^*+=><~|\\_£¥€•"),
																		   kCFStringEncodingUTF8);
	return [result autorelease];
}

+ (NSString*) urlDecodeValue:(NSString*) string
{
	_Assert(string);
	
	NSString* tmpResult = (NSString*) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																							  (CFStringRef)string,
																							  CFSTR("-/:;()$&@\"'!?,.[]{}#%^*+=><~|\\_£¥€•"),
																							  // CFSTR(""),
																							  kCFStringEncodingUTF8);
	//  kCFStringEncodingUnicode);
	//  kCFStringEncodingUTF16);
	NSString* result = [tmpResult stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[tmpResult release];
	return result;
}

@end