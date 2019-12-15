//
//  NewsTableViewController.h
//  test_coding
//
//  Created by Dimas on 15.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsService.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NewsTableViewControllerDelegate <NSObject>
@required
-(NewsService*__nonnull)getNewsService;
@end

@interface NewsTableViewController : UITableViewController
@property(nonatomic,weak)IBOutlet id<NewsTableViewControllerDelegate> newsDelegate;
@end

NS_ASSUME_NONNULL_END
