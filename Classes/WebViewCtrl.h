//
//  WebViewCtrl.h
//  Nyhtr
//

#import "GDataDefines.h"
#import <UIKit/UIKit.h>

@interface WebViewCtrl : UIViewController <UIWebViewDelegate>
{
	NSXMLElement*							_data;	
	IBOutlet UIActivityIndicatorView*		_wait;
	IBOutlet UIWebView*						_showRssWebView;	
}

@property (nonatomic, retain)UIWebView*   showRssWebView;

- (void) setNSXMLElement:(NSXMLElement*) data;
- (void) webViewDidFinishLoad:(UIWebView *)webView;

@end
