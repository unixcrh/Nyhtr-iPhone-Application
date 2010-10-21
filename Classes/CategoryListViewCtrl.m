//
//  CategoryListViewCtrl.m
//  Nyhtr
//
#import "DataStorage.h"
#import "CommonLiterals.h"
#import "ItemListViewCtrl.h"
#import "CategoryListViewCtrl.h"

@implementation CategoryListViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Nyhtr";		 
	_listOfCategories.backgroundColor = [UIColor clearColor];	
	
		// parse the sources.xml i.e., icons xml, so	
	NyhtrAppDelegate *appDelegate = (NyhtrAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.isSetIcons = YES;
	_connection = [[ServerConnection alloc]init];
	[_connection connectionRequest:KIconsXmlLink];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connDidFinished:) 
												 name:@"getDataForTable" object:nil];
	
	_showToWait = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_showToWait.frame = CGRectMake(self.view.center.x, self.view.center.y, 40, 40);
	[_showToWait setCenter:self.view.center];
	_showToWait.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
}

- (void) viewWillAppear:(BOOL)animated
{
		// show-off title of the screen
	self.title = nil;
	
		// header
	[super viewWillAppear:animated];
	UIImage *image = [UIImage imageNamed: @"header.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage: image];	
	imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	CGRect frame = self.navigationController.navigationBar.frame;
	imageView.frame = CGRectMake(frame.size.width/4, frame.size.height/4, frame.size.width/2, frame.size.height/2);
		
		// beige color (HEX: #ccbda2)
		// cc - 204, bd - 189, a2 - 162
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:204.0f green:189.0f blue:162.0f alpha:1.0f]]; 
	[self.navigationController.navigationBar addSubview:imageView];
	imageView.tag = KImageTag;	
	[imageView release];
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
	[_listOfCategories release];
}

- (void)dealloc 
{
	if(_connection)
		[_connection release];
	
	[_showToWait release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table view delegates

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = (indexPath.row % 2 == 0?[UIColor colorWithRed:0.92 green:0.97 blue:0.98 alpha:1]:[UIColor whiteColor]);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
	
	switch (indexPath.row) 
	{
		case 0:
			cell.textLabel.text = Knews;
			break;
			
		case 1:
			cell.textLabel.text = Kbusiness;
			break;
			
		case 2:
			cell.textLabel.text = Ksport;	
			break;
			
		case 3:
			cell.textLabel.text = Ktechnology;
			break;
			
		case 4:
			cell.textLabel.text = Kentertainment;			 
			break;
			
		case 5:
			cell.textLabel.text = Kculture;			 
			break;
			
	}		
	
	cell.backgroundColor = [UIColor clearColor];	
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;	
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	_secondPage = [[ItemListViewCtrl alloc]initWithNibName:@"ItemListView" bundle:nil];
	
		// store it to display in Web-View screen
	DataStorage* sharedObject = [DataStorage sharedObject];		
	
		// show indicator
	[self.view addSubview:_showToWait];
	
		// we are parsing the xml for list of items, so
	NyhtrAppDelegate *appDelegate = (NyhtrAppDelegate *)[[UIApplication sharedApplication] delegate];		
	appDelegate.isSetItems = YES;
	
		//parse for list of items according to the category
	switch (indexPath.row) 
	{
		case 0:
			[_showToWait startAnimating];
			_connection = [[ServerConnection alloc]init];
			[_connection connectionRequest:KURLNews]; 
			[_secondPage setUrl:KNewsRedirectedURL];
			sharedObject.categoryName = Knews;					
			break;
			
		case 1:
			[_showToWait startAnimating];
			_connection = [[ServerConnection alloc]init];
			[_connection connectionRequest:KURLBusiness]; 
			[_secondPage setUrl:KBusinessRedirectedURL];
			sharedObject.categoryName = Kbusiness;
			break;
			
		case 2:
			[_showToWait startAnimating];
			_connection = [[ServerConnection alloc]init];
			[_connection connectionRequest:KURLSport]; 
			[_secondPage setUrl:KSportRedirectedURL];
			sharedObject.categoryName = Ksport;
			break;
			
		case 3:
			[_showToWait startAnimating];
			_connection = [[ServerConnection alloc]init];
			[_connection connectionRequest:KURLTechnology]; 
			[_secondPage setUrl:KTechnologyRedirectedURL];
			sharedObject.categoryName = Ktechnology;
			break;
			
		case 4:
			[_showToWait startAnimating];
			_connection = [[ServerConnection alloc]init];
			[_connection connectionRequest:KURLEntertainment]; 
			[_secondPage setUrl:KEntertainmentRedirectedURL];
			sharedObject.categoryName = Kentertainment;
			break;
			
		case 5:
			[_showToWait startAnimating];
			_connection = [[ServerConnection alloc]init];
			[_connection connectionRequest:KURLCulture]; 
			[_secondPage setUrl:KCultureRedirectedURL];
			sharedObject.categoryName = Kculture;
			break;			
	}	
}

- (void) connDidFinished:(NSNotification*)notif
{
	[_showToWait stopAnimating];
	
	if (nil != _secondPage)
	{
		self.title = @"Nyhtr";
		[self.navigationController pushViewController:_secondPage animated:YES];	
		[_secondPage release];	
	}
}

@end
