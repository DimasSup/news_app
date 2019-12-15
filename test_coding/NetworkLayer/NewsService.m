//
//  NewsService.m
//  test_coding
//
//  Created by Dimas on 11.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "NewsService.h"
#import "NewsNYTimesProvider.h"
#import "NewsGuardianProvider.h"
@import AFNetworking;



@interface NewsService ()
@property(nonatomic,strong)NSMutableDictionary<NewsProviderType,id<NewsProviderProtocol>>* newsProviders;
@property(nonatomic,strong)AFURLSessionManager *manager;

@property(nonatomic,strong)NSMutableDictionary<NewsProviderType,id<NewsNavigationInterface>>* newsProvidersNavigation;
@end

@implementation NewsService
+(NSArray<NewsProviderType> *)allProviders{
	return @[NSStringFromClass(NewsGuardianProvider.class),NSStringFromClass(NewsNYTimesProvider.class)];
}
- (instancetype)initWithProviders:(NSArray<NewsProviderType> *)providers{
	self = [super init];
	if(self){
		_delegates = [HPDelegatesContainer new];
		self.newsProviders = [NSMutableDictionary new];
		self.newsProvidersNavigation = [NSMutableDictionary new];
		for (NewsProviderType providerType in providers) {
			Class class = NSClassFromString(providerType);
			assert(class != nil);
			id<NewsProviderProtocol> provider = [[class alloc] init];
			self.newsProviders[providerType] = provider;
		}
		[self setup];
	}
	return self;
}

-(void)setup{
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	configuration.HTTPMaximumConnectionsPerHost = 1;
	self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
}

-(void)notifyDelegateResponse:(NewsProviderType)provider response:(NewsResponse*)response error:(NSError*)error{
	[self.delegates enumarateAllDelegatesWithCallback:^BOOL(id<NewsServiceDelegate> _Nonnull delegate) {
		if([delegate respondsToSelector:@selector(onNewsProvider:response:error:)]){
			[delegate onNewsProvider:provider response:response error:error];
		}
		return NO;
	}];
}

@end

@implementation NewsService(Requests)
-(void)requestNextPageInProvider:(NewsProviderType)providerType{
	assert(providerType!=nil);
	
	id<NewsProviderProtocol> provider = self.newsProviders[providerType];
	id<NewsNavigationInterface> navigation = self.newsProvidersNavigation[providerType] ?:provider.zeroNavigationInterface;
	NSURLRequest* request = [NSURLRequest requestWithURL:[provider requestString:navigation]];
	__weak typeof(self) weakSelf = self;
	[[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		NewsService* instance = weakSelf;
		if(!instance || error){
			[self notifyDelegateResponse:providerType response:nil error:error];
			return;
		}
		NewsResponse* parsedResponse = [instance parseResponse:providerType navigation:navigation responseData:responseObject];
		[self notifyDelegateResponse:providerType response:parsedResponse error:nil];
	}] resume];
}

-(NewsResponse * __nullable)parseResponse:(NewsProviderType)providerType navigation:(id<NewsNavigationInterface>)navigation responseData:(id)responseData{
	id<NewsProviderProtocol> provider = self.newsProviders[providerType];
	NewsResponse* response = [provider parseResponse:responseData forNavigation:navigation];
	self.newsProvidersNavigation[providerType] = response.navigationOptions;
	return response;
}
-(void)resetNavigationInProvider:(NewsProviderType)provider{
	assert(provider!=nil);
	@synchronized (self.newsProvidersNavigation) {
		self.newsProvidersNavigation[provider] = nil;
	}
}
@end


