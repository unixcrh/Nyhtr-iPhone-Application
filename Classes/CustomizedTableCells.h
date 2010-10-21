//
//  CustomizedTableCells.h
//  Nyhtr
//

#import <UIKit/UIKit.h>


@interface CustomizedTableCells : UITableViewCell
{

}

-(void) setCellWithTitle:(NSString* )title rect:(CGRect)rect;
-(void) setCellWithTitle:(NSString* )title rect:(CGRect)rect noLines:(NSInteger) noOfLines;
-(void) setCellWithTitleAndFontBold:(NSString* )title rect:(CGRect)rect;
-(void) setCellWithTitleAndSize:(NSString* )title rect:(CGRect)rect size:(NSInteger) fontSize;
-(void) setCellWithTitleAndColor:(NSString* )title rect:(CGRect)rect color:(UIColor* )foreColor;


-(UIImageView*) setCellImageView:(CGRect) rect Image:(NSString* )imageName;
-(UIImageView*) setCellImageViewForImage:(CGRect) rect Image:(NSString* )path;
-(UIImageView*) setCellImageViewForImage:(CGRect) rect UIImage:(UIImage* )image;
@end
