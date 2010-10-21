//
//  ItemListViewCtrl.h
//  Nyhtr
//
#import <UIKit/UIKit.h>
#import "CustomizedTableCells.h"
#import "GDataDefines.h"

@interface ItemListViewCtrl : UIViewController
{
				NSArray*		_arrayOfElements;
				NSString*		_urlAddress;	
	IBOutlet	UITableView*	_listOfItems;
}

- (void) setUrl:(NSString*) url;
- (NSXMLElement*)getIconElementForThisDomain:(NSString*)domain;
- (void) setIconInACell:(CustomizedTableCells*)cell withDomain:(NSString*)domain;
- (NSString*) getDomain:(NSXMLElement*)node;
@end
