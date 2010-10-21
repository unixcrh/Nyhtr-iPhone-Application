//
//  UICachedImageMgr.h
//  
//

#import "HttpConnection.h"

@interface UIImageProxy : NSObject
{
	UIImage*	_image;
	NSObject*	_userInfo;
}

@property(nonatomic, readonly)	BOOL		hasImage;
@property(nonatomic, retain)	UIImage*	image;
@property(nonatomic, readonly)	CGSize		size;

@property(nonatomic, readonly) NSObject*	userInfo;


+ (UIImageProxy*) imageProxyWithUserInfo:(NSObject*) userInfo;

- (id) initWithContentsOfFile:(NSString*)path withUserInfo:(NSObject*)userInfo;
- (id) initWithImage:(UIImage*)image withUserInfo:(NSObject*)userInfo;

- (void) drawInRect:(CGRect) rect;
- (CGRect) drawProportionallyInRect:(CGRect) rect;
- (void) drawAtPoint:(CGPoint) point;

   
@end


#define	kNotificationImageLoaded		@"CachedImageLoaded"
#define	kMaxImageConnection				2

@interface UICachedImageMgr : NSObject <HttpConnectionDelegate>
{
	NSString*				_baseDirectory;
	NSString*				_baseURL;

	NSUInteger				_cacheSize;
	NSMutableDictionary*	_cachedImages;

	HttpConnection*			_connections[kMaxImageConnection];
	
}

@property(nonatomic, assign) NSUInteger		cacheSize;

- (id) initWithBaseDirectory:(NSString*)directory baseURL:(NSString*)baseURL;
- (void) clearDiskCache;
- (NSString*) cacheDirecotryPath;

- (UIImageProxy*) imageWithName:(NSString*)name userInfo:(NSObject*)userInfo;
- (BOOL) purgeCacheForImageName:(NSString*)name;
- (BOOL) purgeCachedImages:(BOOL)alsoFromDisk;
- (NSString*) imageNameFromURLString:(NSString*)url;

+ (id) defaultMgr;
+ (void) clearDiskCache;
+ (UIImageProxy*) imageWithName:(NSString*)name userInfo:(NSObject*)userInfo;

@end

