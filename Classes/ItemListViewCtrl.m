//
//  ItemListViewCtrl.m
//  Nyhtr
//
#import "XMLNodeString.h"
#import "NyhtrAppDelegate.h"
#import "CommonLiterals.h"
#import "WebViewCtrl.h"
#import "ItemListViewCtrl.h"
#import "DataStorage.h"
#import "UICachedImageMgr.h"

@implementation ItemListViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
	
		// remove header of the first screen
	[[self.navigationController.navigationBar viewWithTag:KImageTag] removeFromSuperview];
	
		// title
	DataStorage* sharedObject = [DataStorage sharedObject];
	self.title = sharedObject.categoryName;	
	
	_listOfItems.backgroundColor = [UIColor clearColor];	
	
		// image cashed manager
	[[UICachedImageMgr defaultMgr] initWithBaseDirectory:nil baseURL:KIconBaseUrl];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload
{
	[_listOfItems release];
}

- (void)dealloc 
{
	[super dealloc];
}

#pragma mark -
#pragma mark OTHERS

- (void) setUrl:(NSString*)url
{
	_urlAddress =  url;
}

#pragma mark -
#pragma mark Table view delegates

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
		// number of items in a table
	NyhtrAppDelegate *appDelegate = (NyhtrAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [appDelegate.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
		// cell height
	return 40.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
		// background color is changed for every alternative row
	cell.backgroundColor = (indexPath.row % 2 == 0?[UIColor colorWithRed:0.92 green:0.97 blue:0.98 alpha:1]:[UIColor whiteColor]);		
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	static NSString* identifier = @"CellTypeLabel";
	
		// create custom cell
	CustomizedTableCells* cell = nil;	
	if (cell == nil)
        cell = [[[CustomizedTableCells alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	
		// cell accessory type
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	
	NyhtrAppDelegate *appDelegate = (NyhtrAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSXMLElement* node = [appDelegate.items objectAtIndex:indexPath.row];
	NSLog(@"\n Output :: %@ :: ", [node XMLString]);
	
		// set the lable name for a cell
	if(node != NULL)
	{		
		int width = cell.contentView.bounds.size.width-50;
		if([[[node elementForName:@"pubDate"] stringValue]length] > 0)
			[cell setCellWithTitleAndSize:[[node elementForName:@"title"] stringValue] rect:CGRectMake(45, 0, width, 35) size: 17];
		else
			[cell setCellWithTitleAndSize:@"N/A" rect:CGRectMake(45, 0, width, 35) size: 17];		
	}	
	
		// draw icon in the cell
	[self setIconInACell:cell withDomain:[self getDomain:node]];
	
	return cell;	
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
		// tapped on item
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
		// get the corresponding item element
	NyhtrAppDelegate *appDelegate = (NyhtrAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSXMLElement* node = [appDelegate.items objectAtIndex:indexPath.row];
	
		// create WebView (3rd screen)
	WebViewCtrl* thirdPage = [[WebViewCtrl alloc]initWithNibName:@"WebView" bundle:nil];
	[thirdPage setNSXMLElement:node];
	
		// push the WebView screen
	[self.navigationController pushViewController:thirdPage animated:YES];	  
	
	[thirdPage release];	
}

#pragma mark -
#pragma mark displaying image in cell

- (NSString*) getDomain:(NSXMLElement*)node
{
	NSString* link = [[node elementForName:@"link"] stringValue];
	return [[link componentsSeparatedByString:@"domain="] objectAtIndex:1];	
}

- (NSXMLElement*)getIconElementForThisDomain:(NSString*)domain
{
	NyhtrAppDelegate*	appDelegate = (NyhtrAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSXMLElement*		iconElement	= nil;
	int					count		= [appDelegate.icons count];	
	
		// get the icon element for corresponding domain
	for (int i = 0; i < count; ++i)
	{
		iconElement = [appDelegate.icons objectAtIndex:i];
		NSString* elementDomain = [[iconElement elementForName:@"domain"]stringValue];
		if ([elementDomain isEqualToString:domain])
			return iconElement; //[iconElement autorelease] or just iconElement
	}
	return nil;
}

- (void)setIconInACell:(CustomizedTableCells*)cell withDomain:(NSString*)domain
{
	NSXMLElement* iconElement = [self getIconElementForThisDomain:domain];	
			
		// get the icon link
	NSString* iconImageUrl = nil;
	if (nil != iconElement)
		iconImageUrl = [[iconElement elementForName:@"retina-icon"]stringValue];
	else
		iconImageUrl = @"http://nyhtr.se/icon/nyheter24.png";	
	
		// cached images	
	NSString* imageName = [[UICachedImageMgr defaultMgr] imageNameFromURLString:iconImageUrl];
	UIImageProxy* imageProxy = [UICachedImageMgr imageWithName:imageName userInfo:self];
	[cell setCellImageViewForImage:CGRectMake(5, 4, 32, 32) UIImage:imageProxy.image];
}

@end
