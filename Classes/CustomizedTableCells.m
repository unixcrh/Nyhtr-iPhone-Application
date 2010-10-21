//
//  CustomizedTableCells.m
//  Nyhtr
//

#import "CustomizedTableCells.h"

@implementation CustomizedTableCells

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

-(void) setCellWithTitle:(NSString* )title rect:(CGRect)rect
{
	UILabel* label = [[UILabel alloc] initWithFrame:rect] ;
	label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
	[label setBackgroundColor:[UIColor clearColor]];
	label.text = title;
	label.numberOfLines = 1;
	[self.contentView addSubview:label];
}

-(void) setCellWithTitleAndColor:(NSString* )title rect:(CGRect)rect color:(UIColor* )foreColor
{
	UILabel* label = [[UILabel alloc] initWithFrame:rect];
	label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:foreColor];
	label.text = title;
	label.numberOfLines = 1;
	[self.contentView addSubview:label];
}

-(void) setCellWithTitleAndFontBold:(NSString* )title rect:(CGRect)rect 
{
	UILabel* label = [[UILabel alloc] initWithFrame:rect] ;
	label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
	[label setBackgroundColor:[UIColor clearColor]];
	label.text = title;
	label.numberOfLines = 1;
	
	[label setFont:[UIFont boldSystemFontOfSize:15]];
	[self.contentView addSubview:label];
}

-(void) setCellWithTitleAndSize:(NSString* )title rect:(CGRect)rect size:(NSInteger) fontSize;
{
	UILabel* label = [[UILabel alloc] initWithFrame:rect] ;
	label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
	[label setBackgroundColor:[UIColor clearColor]];
	label.text = title;
	label.numberOfLines = 1;
	[label setFont:[UIFont systemFontOfSize:fontSize]];
	[self.contentView addSubview:label];
}

-(void) setCellWithTitle:(NSString* )title rect:(CGRect)rect noLines:(NSInteger) noOfLines
{
	UILabel* label = [[UILabel alloc] initWithFrame:rect] ;
	label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
	[label setBackgroundColor:[UIColor clearColor]];
	label.text = title;
	label.numberOfLines = noOfLines;
	[self.contentView addSubview:label];
}

-(void)	setCellWithButton:(NSString* )imageName rect:(CGRect)rect
{
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = rect;
	[btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	[self.contentView addSubview:btn];
}

-(UIImageView*) setCellImageView:(CGRect) rect Image:(NSString* )imageName
{
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
	// client doesn't want auto resizing
	//imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth;
	UIImage* image = [UIImage imageNamed:imageName];
	[imageView setImage:image];
	[self.contentView addSubview:imageView];
	return imageView;
}

-(UIImageView*) setCellImageViewForImage:(CGRect) rect Image:(NSString* )path
{
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
	// client doesn't want auto resizing
	//imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth;
	UIImage* image = [UIImage imageWithContentsOfFile:path];
	[imageView setImage:image];
	[self.contentView addSubview:imageView];
	return imageView;
}

-(UIImageView*) setCellImageViewForImage:(CGRect) rect UIImage:(UIImage* )image
{
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];	
	// client doesn't want auto resizing
	//imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth;
	[imageView setImage:image];
	[self.contentView addSubview:imageView];
	return imageView;
}

-(void) temp:(id) sender
{
}

- (void)dealloc {
    [super dealloc];
}


@end
