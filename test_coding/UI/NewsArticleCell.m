//
//  NewsArticleCell.m
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "NewsArticleCell.h"
@import SDWebImage;
@implementation NewsArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.thumbnailImageView.layer.cornerRadius = 10;
	self.thumbnailImageView.clipsToBounds = YES;
	self.thumbnailImageView.backgroundColor = UIColor.darkGrayColor;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setArticle:(NewsArticle *)article{
	_article = article;
	[self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:article.thumbnailLink ?: @""] placeholderImage:[UIImage imageNamed:@"article_placeholder"]];
	self.articleTitle.text = article.title;
	self.articleSubtitle.text = article.subTitle;
	[self setNeedsLayout];
	[self setNeedsUpdateConstraints];
	[self updateConstraintsIfNeeded];
	[self layoutIfNeeded];
	
}

@end
