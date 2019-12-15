//
//  ArticleDetailsViewController.h
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "NewsResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetailsViewController : XLFormViewController
@property(nonatomic,strong)NewsArticle* article;
@end

NS_ASSUME_NONNULL_END
