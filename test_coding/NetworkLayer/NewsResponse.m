//
//  NewsResponse.m
//  test_coding
//
//  Created by Dimas on 14.12.2019.
//  Copyright © 2019 T.D.V.DG. All rights reserved.
//

#import "NewsResponse.h"

@implementation NewsArticle{
	NSDate* _parsedDate;
}
+(NSString *)dateFormat{
	return @"yyyy-MM-dd'T'HH:mm:ssXXX";
}
+(NSDate*)parseDateString:(NSString*)dateString{
	if(!dateString.length){
		return nil;
	}
	static NSDateFormatter* formatter = nil;
	if(!formatter){
		formatter = [NSDateFormatter new];
		[formatter setDateFormat:[self dateFormat]];
	}
	return [formatter dateFromString:dateString];
}
-(NSDate *)parsedDate{
	if(!_parsedDate){
		_parsedDate = [NewsArticle parseDateString:self.postDate];
	}
	return _parsedDate;
}


@end

@implementation NewsResponse

@end
