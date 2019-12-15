//
//  XLCustomTextCell.h
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

@import UIKit;
@import XLForm;
NS_ASSUME_NONNULL_BEGIN
extern NSString* const kXLCustomTextCellType;
extern NSString* const kXLCustomTextColor;
extern NSString* const kXLCustomTextBackgroundColor;
extern NSString* const kXLCustomTextFontSize;


@interface XLCustomTextCell : XLFormBaseCell
@property(nonatomic,assign)float fontSize;
@end

NS_ASSUME_NONNULL_END
