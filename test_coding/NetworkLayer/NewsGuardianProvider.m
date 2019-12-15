//
//  NewsGuardianProvider.m
//  test_coding
//
//  Created by Dimas on 14.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "NewsGuardianProvider.h"
@interface GuardianNavigationInterface :NSObject<NewsNavigationInterface>
@property(nonatomic,assign)int nextPage;
@property(nonatomic,assign)int currentPage;
@end
@implementation GuardianNavigationInterface

@end
@implementation NewsGuardianProvider{
	NSString* _apiKey;
	int _limit;

}
- (instancetype)init
{
	self = [self initWithKey:nil limit:0];
	if (self) {
		
	}
	return self;
}

-(instancetype)initWithKey:(NSString*)key limit:(int)limit{
	self = [super init];
	if(self){
		_apiKey = key ?: @"3326535f-22f5-4880-8de3-081905173ed8";
		_limit = limit?:20;
	}
	return self;
}
-(NSURLComponents*)getRequestComponents:(int)offset limit:(int)limit{
	NSURLComponents* components = [NSURLComponents componentsWithString:@"https://content.guardianapis.com/search"];
	[components setQueryItems:@[
		[NSURLQueryItem queryItemWithName:@"api-key" value:_apiKey],
		[NSURLQueryItem queryItemWithName:@"page" value:@(offset).description],
		[NSURLQueryItem queryItemWithName:@"page-size" value:@(limit).description],
	]];
	return components;
}
-(id<NewsNavigationInterface>)zeroNavigationInterface{
	GuardianNavigationInterface* nextNavigation = [GuardianNavigationInterface new];
	nextNavigation.currentPage = 1;
	nextNavigation.nextPage = 2;
	return nextNavigation;
}

-(NSURL *)requestString:(id<NewsNavigationInterface>)navigation{
	assert([navigation isKindOfClass:[GuardianNavigationInterface class]]);
	GuardianNavigationInterface* interface = navigation;
	return [self getRequestComponents:interface.nextPage limit:_limit].URL;
	
}

-(NewsResponse *)parseResponse:(NSDictionary *)response forNavigation:(id<NewsNavigationInterface>)navigation{
	if(response == nil){
		return nil;
	}
	assert([navigation isKindOfClass:[GuardianNavigationInterface class]]);
	if(![self checkStatus:response]){
		return nil;
	}
	GuardianNavigationInterface* interface = navigation;
	
	NewsResponse* responseObject = [NewsResponse new];
	NSArray<NSDictionary*>* articles = response[@"response"][@"results"];
	int allPages = [response[@"response"][@"pages"] intValue];
	
	if(allPages>interface.nextPage){
		GuardianNavigationInterface* nextNavigation = [GuardianNavigationInterface new];
		nextNavigation.nextPage = interface.nextPage + 1;
		nextNavigation.currentPage = interface.nextPage;
		responseObject.navigationOptions = nextNavigation;
	}
	
	
	responseObject.articles = [self parseArticles:articles];
	
	return responseObject;
}

-(NSArray<NewsArticle*>*)parseArticles:(NSArray<NSDictionary*>*)articlesJSON{
	//Using object mapping? ¯\_(ツ)_/¯
	NSMutableArray<NewsArticle*>* articles = [[NSMutableArray alloc] initWithCapacity:articlesJSON.count];
	
	for (NSDictionary* json in articlesJSON) {
		NSDictionary<NSString*,id>* dict = @{
			@"articleId" : json[@"id"] ?: @"",
			@"section" : json[@"sectionName"] ?: @"",
			@"title" : json[@"pillarName"] ?: @"",
			@"subTitle" : json[@"webTitle"] ?: @"",
			@"postDate" : json[@"webPublicationDate"] ?: @"",
			@"contentLink" : json[@"webUrl"] ?: @"",
		};
		NewsArticle* article = [NewsArticle new];
		[article setValuesForKeysWithDictionary:dict];
		[articles addObject:article];
	}
	return articles;
}

-(BOOL)checkStatus:(NSDictionary*)response{
	NSString* status = response[@"response"][@"status"];
	if([status.lowercaseString isEqualToString:@"ok"]){
		return YES;
	}
	
	return NO;
}


@end
