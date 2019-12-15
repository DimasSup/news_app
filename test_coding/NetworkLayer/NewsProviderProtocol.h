//
//  NewsProviderProtocol.h
//  test_coding
//
//  Created by Dimas on 14.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsResponse.h"



@protocol NewsProviderProtocol <NSObject>
-(NSURL* __nullable)requestString:(id<NewsNavigationInterface> __nonnull)navigation;
-(NewsResponse* __nullable)parseResponse:(NSDictionary* __nullable)response forNavigation:(id<NewsNavigationInterface> __nonnull)navigation;
-(id<NewsNavigationInterface> __nonnull)zeroNavigationInterface;

@end
