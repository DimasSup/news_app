//
//  NewsTableViewController.m
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsArticleCell.h"
#import "ArticleDetailsViewController.h"
NSString* const kLoadingCell = @"loading";
NSString* const kArticleCell = @"article";

@interface NewsTableViewController ()<NewsServiceDelegate>
@property(nonatomic,strong)IBInspectable NSString* providerKey;
@property(nonatomic,assign)BOOL loadingEnabled;
@property(nonatomic,assign)BOOL loadingInProgress;
@property(nonatomic,strong)NSArray<NewsArticle*>* news;
@end

@interface NewsTableViewController(Details)
-(void)openDetails:(NewsArticle*)article;
@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.loadingEnabled = YES;
	self.tableView.tableFooterView = [UIView new];
	[self.tableView registerNib:[UINib nibWithNibName:@"NewsArticleCell" bundle:nil] forCellReuseIdentifier:kArticleCell];
	[self.tableView registerNib:[UINib nibWithNibName:@"LoadingCell" bundle:nil] forCellReuseIdentifier:kLoadingCell];
	[self.newsDelegate.getNewsService.delegates addDelegatesObject:self];
}
-(void)requestNews{
	if(!self.loadingInProgress){
		self.loadingInProgress = YES;
		[self.newsDelegate.getNewsService requestNextPageInProvider:self.providerKey];
	}
}
#pragma mark - News Service delegate
-(void)onNewsProvider:(NewsProviderType)provider response:(NewsResponse *)response error:(NSError *)error{
	if([provider isEqualToString:self.providerKey]){
		if(response){
			[self updateWithResponse:response];
		}
		else{
			[self disableLoading];
		}
	}
}
-(void)updateWithResponse:(NewsResponse*)response{
	assert(response);
	
	NSMutableArray<NewsArticle*>* copyNews = [[NSMutableArray alloc] initWithArray:self.news];
	NSMutableArray<NSIndexPath*>* insertIndexes = [[NSMutableArray alloc] initWithCapacity:response.articles.count];
	NSMutableArray<NSIndexPath*>* removeIndexes = [NSMutableArray new];
	NSInteger startIndex = copyNews.count;
	[copyNews addObjectsFromArray:response.articles];
	for (NSInteger index = 0; index<response.articles.count; index++) {
		[insertIndexes addObject:[NSIndexPath indexPathForRow:index+startIndex inSection:0]];
	}
	BOOL newLoadingState = response.navigationOptions!=nil;
	if(self.loadingEnabled!=newLoadingState){
		if(newLoadingState){
			[insertIndexes addObject:[NSIndexPath indexPathForRow:copyNews.count inSection:0]];
		}
		else{
			[removeIndexes addObject:[NSIndexPath indexPathForRow:startIndex inSection:0]];
		}
	}
	
	__weak typeof(self) weakself = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		NewsTableViewController* instance = weakself;
		if(instance){
			[instance.tableView beginUpdates];
			
			instance.news = copyNews;
			instance.loadingEnabled = response.navigationOptions!=nil;
			instance.loadingInProgress = NO;
			
			[instance.tableView insertRowsAtIndexPaths:insertIndexes withRowAnimation:UITableViewRowAnimationBottom];
			[instance.tableView deleteRowsAtIndexPaths:removeIndexes withRowAnimation:UITableViewRowAnimationFade];
			
			[instance.tableView endUpdates];
		}
	});
}
-(void)disableLoading{
	__weak typeof(self) weakself = self;
	
	if(self.loadingEnabled){
		
		dispatch_async(dispatch_get_main_queue(), ^{
			NewsTableViewController* instance = weakself;
			if(instance){
				instance.loadingEnabled = NO;
				instance.loadingInProgress = NO;
				[instance.tableView reloadData];
			}
		});
	}
	else{
		self.loadingInProgress = NO;
	}
	
}
	
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count + (self.loadingEnabled?1:0);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(self.loadingEnabled && indexPath.row == self.news.count){
		return [tableView dequeueReusableCellWithIdentifier:kLoadingCell forIndexPath:indexPath];
	}
	//FIXME: should set-up in willDisplayCell but autolayout  bugging
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kArticleCell forIndexPath:indexPath];
	assert([cell isKindOfClass:[NewsArticleCell class]]);
	NewsArticleCell* newsCell = (NewsArticleCell*)cell;
	newsCell.article = self.news[indexPath.row];
	return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	if(self.loadingEnabled && !self.loadingInProgress && (indexPath.row == self.news.count)){
		[self requestNews];
	}
	if(self.loadingEnabled && indexPath.row == self.news.count){
		return;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row < self.news.count){
		[self openDetails:self.news[indexPath.row]];
	}
}

@end


@implementation NewsTableViewController (Details)
-(void)openDetails:(NewsArticle *)article{
	UIViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleDetailsForm"];
	assert([viewController isKindOfClass:[ArticleDetailsViewController class]]);
	ArticleDetailsViewController* detailsController = (ArticleDetailsViewController*)viewController;
	detailsController.article = article;
	[self.navigationController pushViewController:detailsController animated:YES];
}

@end
