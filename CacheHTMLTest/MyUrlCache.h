//
//  MyUrlCache.h
//  CacheHTMLTest
//
//  Created by zhangmeng on 15/2/3.
//  Copyright (c) 2015年 zhangmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUrlCache : NSURLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request;

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request;

- (void)initilize;

- (void)doRemoveAllCachedResponse;

@end
