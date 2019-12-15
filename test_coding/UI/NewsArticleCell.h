//
//  NewsArticleCell.h
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewsArticleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UILabel *articleSubtitle;
@property(nonatomic,strong)NewsArticle* article;
@end

NS_ASSUME_NONNULL_END
