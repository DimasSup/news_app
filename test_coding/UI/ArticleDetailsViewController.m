//
//  ArticleDetailsViewController.m
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "ArticleDetailsViewController.h"
#import "XLCustomTextCell.h"
#import "XLCustomImageCell.h"

@interface ArticleDetailsViewController ()

@end

@implementation ArticleDetailsViewController
-(void)setupForm{
	NSString* title = self.article.title;
	if(title.length > 17){
		title = [[title substringToIndex:15] stringByAppendingString:@"..."];
	}
	XLFormDescriptor* form = [XLFormDescriptor formDescriptorWithTitle:title];
	XLFormSectionDescriptor* section = [XLFormSectionDescriptor formSection];
	[form addFormSection:section];
	XLFormRowDescriptor* titleRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"title" rowType:kXLCustomTextCellType];
	titleRow.cellConfig[kXLCustomTextBackgroundColor] = [UIColor colorWithRed:0.22 green:0.26 blue:0.43 alpha:1.0];
	titleRow.cellConfig[kXLCustomTextColor] = [UIColor whiteColor];
	titleRow.cellConfig[kXLCustomTextFontSize] = @(18);
	
	
	titleRow.value = self.article.title;
	[section addFormRow:titleRow];
	
	if(self.article.thumbnailLink){
		XLFormRowDescriptor* imgDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:@"thumb" rowType:kXLCustomImageCellType];
		imgDescriptor.value = [NSURL URLWithString:self.article.thumbnailLink];
		imgDescriptor.height = 80;
		[section addFormRow:imgDescriptor];
	}
	
	
	XLFormRowDescriptor* detailsRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"details" rowType:kXLCustomTextCellType];
	detailsRow.cellConfig[kXLCustomTextBackgroundColor] = [UIColor colorWithRed:0.22 green:0.26 blue:0.43 alpha:1.0];
	detailsRow.cellConfig[kXLCustomTextColor] = [UIColor colorWithWhite:0.7 alpha:1];
	detailsRow.cellConfig[kXLCustomTextFontSize] = @(14);
	detailsRow.value = self.article.subTitle;
	[section addFormRow:detailsRow];
	
	XLFormRowDescriptor* link = [XLFormRowDescriptor formRowDescriptorWithTag:@"link" rowType:XLFormRowDescriptorTypeButton];
	NSURL* url = self.article.contentLink?[NSURL URLWithString:self.article.contentLink]:nil;
	if(url){
		XLFormAction* action = [[XLFormAction alloc] init] ;
		[action setFormBlock:^(XLFormRowDescriptor * _Nonnull sender) {
			[UIApplication.sharedApplication openURL:sender.value options:@{} completionHandler:nil];
		}];
		link.action = action;
		link.title = @"SEE FULL VERSION";
		link.value = url;
		link.cellConfig[@"textLabel.textColor"] = [UIColor colorWithRed:0.00 green:1.00 blue:0.82 alpha:1.0];
	}
	else{
		link.title = @"NO FULL VERSION";
	}
	link.height = 44;
	link.cellConfig[kXLCustomTextBackgroundColor] = [UIColor colorWithRed:0.22 green:0.26 blue:0.43 alpha:1.0];
	
	
	[section addFormRow:link];
	
	
	self.form = form;

}
+(void)initialize{
	[super initialize];
	[[XLFormViewController cellClassesForRowDescriptorTypes] setObject:@"XLCustomTextCell" forKey:kXLCustomTextCellType];
	[[XLFormViewController cellClassesForRowDescriptorTypes] setObject:@"XLCustomImageCell" forKey:kXLCustomImageCellType];

}
- (void)viewDidLoad {
	
	
	
	[self setupForm];
	
	
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
