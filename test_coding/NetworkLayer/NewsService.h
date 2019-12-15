//
//  NewsService.h
//  test_coding
//
//  Created by Dimas on 11.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsResponse.h"
@import HPManagedObjects;

typedef NSString* NewsProviderType;
@class NewsService;
@protocol NewsServiceDelegate <NSObject>
-(void)onNewsProvider:(NewsProviderType __nonnull)provider
			 response:(NewsResponse* __nullable)response
				error:(NSError* __nullable)error;
@end

@interface NewsService : NSObject
+(NSArray<NewsProviderType>* __nonnull)allProviders;
-(instancetype __nonnull)initWithProviders:(NSArray<NewsProviderType>* __nonnull)providers;
@property(nonatomic,strong,readonly,nonnull)HPDelegatesContainer<id<NewsServiceDelegate>>* delegates;
@end
@interface NewsService(Requests)
//Use FBPromise as result?
-(void)requestNextPageInProvider:(NewsProviderType __nonnull)provider;
-(void)resetNavigationInProvider:(NewsProviderType __nonnull)provider;
@end
