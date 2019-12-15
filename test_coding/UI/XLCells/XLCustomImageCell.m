//
//  XLCustomImageCell.m
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "XLCustomImageCell.h"

NSString* const kXLCustomImageCellType = @"XLCustomImageCell";

@import SDWebImage;
@interface XLCustomImageCell()
@property(nonatomic,strong)IBOutlet UIImageView* imageView;
@end
@implementation XLCustomImageCell
@synthesize imageView = _imageView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)update{
	[super update];
	
	if([self.rowDescriptor.value isKindOfClass:[NSURL class]]){
		UIImage* placeHolder = [UIImage imageNamed:@"article_placeholder"];
		[self.imageView sd_setImageWithURL:self.rowDescriptor.value placeholderImage:placeHolder];
	}
	else if([self.rowDescriptor.value isKindOfClass:[UIImage class]]){
		[self.imageView setImage:self.rowDescriptor.value];
	}
	else{
		[self.imageView sd_cancelCurrentImageLoad];
		[self.imageView setImage:[UIImage imageNamed:@"article_placeholder"]];
	}
}

@end
