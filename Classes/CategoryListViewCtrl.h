//
//  CategoryListViewCtrl.h
//  Nyhtr
//


#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "NyhtrAppDelegate.h"

@interface CategoryListViewCtrl : UIViewController
{	
	ServerConnection*			_connection;
	IBOutlet	UITableView*				_listOfCategories;
	UIActivityIndicatorView*	_showToWait;	
	ItemListViewCtrl*			_secondPage ;
}

@end
