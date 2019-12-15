//
//  NewsNavigationProtocol.h
//  test_coding
//
//  Created by Dimas on 14.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NewsNavigationInterface<NSObject>
@property(nonatomic,assign,readonly)int currentPage;
@end

NS_ASSUME_NONNULL_END
