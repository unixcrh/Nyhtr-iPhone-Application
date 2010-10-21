//
//  UIUtils.h
//

#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

+ (void) messageAlert: (NSString*)msg title: (NSString*)title delegate: (id)delegate;
+ (void) messageAlertWithOkCancel:(NSString*)msg title:(NSString*)title delegate:(id)delegate;
+ (void) errorAlert:(NSString*)msg;
+ (void) localizedErrorAlert:(NSString*)strId;

+ (void) conditionFailedMsg:(NSString*)condition filename:(NSString*)fname line:(int)line;


// pure UI utils function
+ (BOOL) isString:(NSString*)str inArray:(NSArray*)array;

+ (NSString*) stringFromImage:(UIImage*)image;
+ (UIImage*) imageFromString:(NSString*)imageString;

+ (NSString*) base64StringFromString:(NSString*)string;
+ (NSString*) stringFromBase64String:(NSString*)string;

+ (UIImage*) cropImage:(UIImage*)inImage ofSize:(CGSize) inSize;
+ (BOOL) isConnectedToNetwork;

+ (void) addNotificationToQueue:(NSString*)name object:(id)self userInfo:(NSDictionary*)dictionary postingStyle:(NSPostingStyle)style;

+ (void) moveViewFor:(UIViewController*) viewC xOffset:(CGFloat)x yOffset: (CGFloat)y;
+ (BOOL) checkForSpecialCharacter:(NSString*) string;

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath;

+ (NSString*) urlEncodeValue:(NSString*) string;
+ (NSString*) urlDecodeValue:(NSString*) string;

@end


