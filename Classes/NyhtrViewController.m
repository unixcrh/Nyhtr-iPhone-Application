//
//  NyhtrViewController.m
//  Nyhtr
//
#import "NyhtrViewController.h"

@implementation NyhtrViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	CGRect rect = _baseNavC.view.frame;
	rect.origin.y = 0;
	_baseNavC.view.frame = rect;
	
	[self.view addSubview:_baseNavC.view];
	[_baseNavC viewWillAppear:NO];
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
}

- (void)dealloc 
{
	[_baseNavC release];
    [super dealloc];
}

@end
