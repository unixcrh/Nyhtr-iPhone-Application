//
//  WebViewCtrl.m
//  Nyhtr
//

#import "WebViewCtrl.h"
#import "XMLNodeString.h"
#import <QuartzCore/CALayer.h>
#import <UIKit/UIView.h>

@implementation WebViewCtrl

@synthesize showRssWebView = _showRssWebView;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
		// show indicator	
	_wait.frame = CGRectMake(self.view.center.x, self.view.center.y, 40, 40);
	[_wait setCenter:self.view.center];
	_wait.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[_wait startAnimating];
	
		// set title
	self.title = [[_data elementForName:@"title"]stringValue];
	
		// get the link
	NSString* link = [[_data elementForName:@"link"]stringValue];
	NSURL *url = [NSURL URLWithString:link];
	
		// URL Request Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
		// Round corners using CALayer property
	//[[_showRssWebView layer] setCornerRadius:1];
	//[_showRssWebView setClipsToBounds:YES];
	
		// Create colored border using CALayer property
	//[[_showRssWebView layer] setBorderColor:
	//[[UIColor colorWithRed:0 green:1.0 blue:0 alpha:1] CGColor]];
	//[[_showRssWebView layer] setBorderWidth:2.75];
	
		// enable zoom in/out property of web view
		// initially it is zoomed out.
	_showRssWebView.scalesPageToFit = YES;
	
		// Load the request in the UIWebView.		
	[_showRssWebView loadRequest:requestObj];	
	
		// delegate is self, so that webViewDidFinishLoad will be called	
	_showRssWebView.delegate = self;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload
{
}

- (void)dealloc 
{
		// release all the data
	[_data release];
	[_wait release];
	[_showRssWebView release];
	[super dealloc];
}

#pragma mark -
#pragma mark others

- (void) setNSXMLElement:(NSXMLElement*) data
{
	_data =  [data retain];
}

#pragma mark -
#pragma mark delegate methhods

- (void) webViewDidFinishLoad:(UIWebView *)webView
{	
		// stop animating and turn-off showing
	[_wait stopAnimating];
	_wait.hidden = YES;	
}

@end
