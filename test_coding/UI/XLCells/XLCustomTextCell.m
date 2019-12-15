//
//  XLCustomTextCell.m
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "XLCustomTextCell.h"
NSString* const kXLCustomTextCellType = @"XLCustomTextCell";
NSString* const kXLCustomTextColor = @"textLabel.textColor";
NSString* const kXLCustomTextBackgroundColor = @"backgroundColor";
NSString* const kXLCustomTextFontSize = @"fontSize";

@interface XLCustomTextCell()
@property (strong, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation XLCustomTextCell
@synthesize textLabel = _textLabel;
-(float)fontSize{
	return self.textLabel.font.pointSize;
}
-(void)setFontSize:(float)fontSize{
	self.textLabel.font = [self.textLabel.font fontWithSize:fontSize];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBackgroundColor:(UIColor *)backgroundColor{
	[super setBackgroundColor:backgroundColor];
	[self.contentView setBackgroundColor:backgroundColor];
}

-(void)update{
	[super update];
	self.textLabel.text = self.rowDescriptor.value;
}

@end
