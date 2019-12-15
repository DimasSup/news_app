//
//  ViewController.m
//  test_coding
//
//  Created by Dimas on 11.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "ViewController.h"
#import "NewsTableViewController.h"

@interface ViewController ()<NewsTableViewControllerDelegate>
@property(nonatomic,strong)NewsService* newsService;
@end

@implementation ViewController
-(void)viewDidLoad{
	[super viewDidLoad];
	self.newsService = [[NewsService alloc] initWithProviders:NewsService.allProviders];
	for(UIViewController* vc in self.childViewControllers){
		if([vc isKindOfClass:[NewsTableViewController class]]){
			((NewsTableViewController*)vc).newsDelegate = self;
		}
	}
}
#pragma mark - News Table Delegate
-(NewsService *)getNewsService{
	return self.newsService;
}
#pragma mark - Tab bar callbacks
-(void)setSelectedViewController:(__kindof UIViewController *)selectedViewController{
	[super setSelectedViewController:selectedViewController];
	self.navigationItem.title = selectedViewController.title;
}
@end
