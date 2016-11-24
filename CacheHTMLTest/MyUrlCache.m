//
//  MyUrlCache.m
//  CacheHTMLTest
//
//  Created by zhangmeng on 15/2/3.
//  Copyright (c) 2015年 zhangmeng. All rights reserved.
//

#import "MyUrlCache.h"

#import "ZMUtils.h"
#define WILL_BE_CACHED_EXTS ".jpg.png.gif.bmp.ico.html"
#define DEBUGP   //#define WILL_BE_CACHED_EXTS ".html"


@implementation MyUrlCache
{
    NSString *spath;
    NSFileManager *fileManager;
    NSString *dirName;
    NSInteger dirType;
}

- (void)initilize {
    
    fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains((dirType==0?NSDocumentDirectory:(dirType==1?NSLibraryDirectory:NSCachesDirectory)), NSUserDomainMask, YES);
    spath = [paths firstObject];
    
    [fileManager changeCurrentDirectoryPath:spath];
    
    if (dirName == nil) {
        dirName = @"httpCache";
    }
    spath =  [spath stringByAppendingPathComponent:dirName];
    
    [fileManager changeCurrentDirectoryPath:spath];
    
}

- (void)removeAllCachedResponses {
//这里不能执行doRemoveAllCachedResponses，否则每次就会删除你写入的

}

- (void) doRemoveAllCachedResponse {
    if (spath != nil) {
        [fileManager removeItemAtPath:spath error:nil];
    }
    
}

-(NSString *)getMineType:(NSURLRequest *)request {
    NSString *ext = [[request URL] absoluteString].pathExtension;
    
    if (ext != nil) {
        NSString *str;
        if ([ext compare:@"htm"] || [ext compare:@"html"]) {
            str = @"text/html";
        }else {
            str = [NSString stringWithFormat:@"image/%@", ext];
        }
        return str;

    }
    return @"";
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    
    NSString *filename = [self getCachedFileName:request];
    
    if (spath != nil && filename.length > 0) {
        filename = [spath stringByAppendingPathComponent:filename];
        if ([fileManager fileExistsAtPath:filename]) {
#ifdef DEBUGP
            NSLog(@"\n注意：：：：Cache used: %@", [[request URL] absoluteString]);
#endif
            NSData* data = [NSData dataWithContentsOfFile:filename];
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:[self getMineType:request] expectedContentLength:data.length textEncodingName:nil];
            NSCachedURLResponse* cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            
            return cachedResponse;
        }
    }
    
    return nil;
    
}

- (NSString *)getCachedFileName:(NSURLRequest *)request {
    
    NSString *ext = [[request URL] absoluteString].pathExtension;
    
    if (ext != nil) {
        
        if ([@WILL_BE_CACHED_EXTS rangeOfString:ext.lowercaseString].length > 0) {
            
            return [NSString stringWithFormat:@"%@.%@", [ZMUtils md5:[[request URL] absoluteString]], ext];

        }
    }
    return @"";
    
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSString* filename = [self getCachedFileName:request];
    if(spath!=nil && filename.length>0){
        if(![fileManager fileExistsAtPath:filename]){
            filename = [ZMUtils writeFileToDirWithDirType:dirName dirType:dirType fileName:filename DATA:cachedResponse.data];
#ifdef DEBUGP
            NSLog(@"\n注意：：：：写入缓存文件=%@",filename );
#endif
        }
    }
#ifdef DEBUGP
    else
        NSLog(@"\n注意：：：：不缓存: %@", [[request URL] absoluteString]);
#endif
}



@end
