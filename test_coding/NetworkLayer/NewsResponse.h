//
//  NewsResponse.h
//  test_coding
//
//  Created by Dimas on 14.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsNavigationInterface.h"

NS_ASSUME_NONNULL_BEGIN


@interface NewsArticle : NSObject
+(NSString*)dateFormat;
@property(nonatomic,strong)NSString* articleId;
@property(nonatomic,strong)NSString* section;
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* subTitle;

@property(nonatomic,strong)NSString* postDate;
-(NSDate*)parsedDate;

@property(nonatomic,strong)NSString* thumbnailLink;

@property(nonatomic,strong)NSString* contentLink;
@end

@interface NewsResponse : NSObject
@property(nonatomic,strong)id<NewsNavigationInterface> navigationOptions;
@property(nonatomic,strong)NSArray<NewsArticle*>* articles;
@end

NS_ASSUME_NONNULL_END
