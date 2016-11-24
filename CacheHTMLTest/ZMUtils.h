//
//  ZMUtils.h
//  CacheHTMLTest
//
//  Created by zhangmeng on 15/2/3.
//  Copyright (c) 2015年 zhangmeng. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZMUtils : NSObject

+ (void)writeFile:(NSString *)filePath data:(NSString *)_data;

+ (NSString *)readFile:(NSString *)filePath;

+ (NSString *)md5:(NSString *)str;

+ (NSString *)replaceStringBetween:(NSString *)startStr EndString:(NSString *)endStr Str:(NSString *)str;

+ (NSInteger)getTs;

+ (NSData *)uncompressZippedData:(NSData *)compressedData;

+ (NSString *)writeFileToDirWithDirType:(NSString *)dirname dirType:(NSInteger)type fileName:(NSString*) filename DATA:(NSData *) data;;

+ (NSData *)readFileFromDirWithDirType:(NSString *)dirname dirType:(NSInteger)type fileName:(NSString*) filename;


@end
