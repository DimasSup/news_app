//
//  NewsNYTimesProvider.m
//  test_coding
//
//  Created by Dimas on 14.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "NewsNYTimesProvider.h"


@interface NYTNavigationInterface :NSObject<NewsNavigationInterface>
@property(nonatomic,assign)int offset;
@property(nonatomic,assign)int currentPage;
@end
@implementation NYTNavigationInterface

@end

@implementation NewsNYTimesProvider{
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
		_apiKey = key ?: @"FfigF83qXnVSU1a4xxF7zSVjrGRPMFZD";
		_limit = limit?:20;
	}
	return self;
}
-(NSURLComponents*)getRequestComponents:(int)offset limit:(int)limit{
	NSURLComponents* components = [NSURLComponents componentsWithString:@"https://api.nytimes.com/svc/news/v3/content/all/all.json"];
	[components setQueryItems:@[
		[NSURLQueryItem queryItemWithName:@"api-key" value:_apiKey],
		[NSURLQueryItem queryItemWithName:@"offset" value:@(offset).description],
		[NSURLQueryItem queryItemWithName:@"limit" value:@(limit).description],
	]];
	return components;
}
-(id<NewsNavigationInterface>)zeroNavigationInterface{
	NYTNavigationInterface* nextNavigation = [NYTNavigationInterface new];
	nextNavigation.offset = 0;
	nextNavigation.currentPage = 1;
	return nextNavigation;
}

-(NSURL *)requestString:(id<NewsNavigationInterface>)navigation{
	assert([navigation isKindOfClass:[NYTNavigationInterface class]]);
	NYTNavigationInterface* interface = navigation;
	return [self getRequestComponents:interface.offset limit:_limit].URL;
}

-(NewsResponse *)parseResponse:(NSDictionary *)response forNavigation:(id<NewsNavigationInterface>)navigation{
	if(response == nil){
		return nil;
	}
	assert([navigation isKindOfClass:[NYTNavigationInterface class]]);
	if(![self checkStatus:response]){
		return nil;
	}
	NYTNavigationInterface* interface = navigation;
	
	NewsResponse* responseObject = [NewsResponse new];
	NSArray<NSDictionary*>* articles = response[@"results"];
	int resultsLeft = [response[@"num_results"] intValue];
	
	if(resultsLeft>0){
		NYTNavigationInterface* nextNavigation = [NYTNavigationInterface new];
		nextNavigation.offset = interface.offset + (int)articles.count;
		nextNavigation.currentPage = interface.currentPage + 1;
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
			@"articleId" : json[@"slug_name"] ?: @"",
			@"section" : json[@"section"] ?: @"",
			@"title" : json[@"title"] ?: @"",
			@"subTitle" : json[@"abstract"] ?: @"",
			@"postDate" : json[@"published_date"] ?: @"",
			@"thumbnailLink" : json[@"thumbnail_standard"] ?: @"",
			@"contentLink" : json[@"url"] ?: @"",
		};
		NewsArticle* article = [NewsArticle new];
		[article setValuesForKeysWithDictionary:dict];
		[articles addObject:article];
	}
	return articles;
}

-(BOOL)checkStatus:(NSDictionary*)response{
	NSString* status = response[@"status"];
	if([status.lowercaseString isEqualToString:@"ok"]){
		return YES;
	}
	
	return NO;
}


@end
