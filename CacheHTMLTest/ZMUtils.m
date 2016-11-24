//
//  ZMUtils.m
//  CacheHTMLTest
//
//  Created by zhangmeng on 15/2/3.
//  Copyright (c) 2015年 zhangmeng. All rights reserved.
//

#import "ZMUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>



@implementation ZMUtils

+ (void)writeFile:(NSString *)filePath data:(NSString *)_data {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *fileName = [[paths firstObject] stringByAppendingPathComponent:filePath];
    
    //用这个方法判断当前的文件是否存在，如果不存在就创建一个文件
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:fileName]) {
        
        NSLog(@"File %@ not exists!",fileName);
        
        [fileManager createFileAtPath:fileName contents:nil attributes:nil];
    }else {
        NSLog(@"File %@ exists!",fileName);
    }
    
    NSLog(@"File %@ will write!",fileName);
    
    [_data writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString *)replaceStringBetween:(NSString *)startStr EndString:(NSString *)endStr Str:(NSString *)str{
   
    NSRange range1 = [str rangeOfString:startStr];
    
    NSInteger len = str.length - range1.location - range1.length;
    
    NSRange range2 = [str rangeOfString:endStr options:NSCaseInsensitiveSearch range:NSMakeRange(range1.location+range1.length, len)];
    
    NSInteger start = range1.length + range1.location;
    
    len = range2.location - (range1.location + range1.length);
    
    NSString * toReplace = [str substringWithRange:NSMakeRange(start, len)];
    
    return [str stringByReplacingOccurrencesOfString:toReplace withString:@""];
}

+ (NSString *)readFile:(NSString *)filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *fileName = [[paths firstObject] stringByAppendingPathComponent:filePath];
    
    NSLog(@"File %@ will be read!",fileName);
    
    NSString *myString = [NSString stringWithContentsOfFile:fileName usedEncoding:NULL error:nil];
   
    return myString;
}

//md5 32位 加密 （小写）

+ (NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    
    return [[NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
}

//获得当前时间
+ (NSInteger)getTs {
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    
    return (NSInteger)timestamp;
}

+ (NSData *)uncompressZippedData:(NSData *)compressedData {
    
    if ([compressedData length] == 0) {
        return compressedData;
    }
    NSUInteger full_length = [compressedData length];
    
    NSUInteger half_length = [compressedData length]/2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength:full_length + half_length];
    
    BOOL done = NO;
    
    int status;
    
    z_stream strm;
    
    strm.next_in = (Bytef *)[compressedData bytes];
    
    strm.avail_in = (uInt)[compressedData length];
    
    strm.total_out = 0;
    
    strm.zalloc = Z_NULL;
    
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15 + 32)) != Z_OK) {
        return nil;
    }
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            
            [decompressed increaseLengthBy:half_length];
            
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        // Inflate another chunk
        status = inflate(&strm, Z_SYNC_FLUSH);
        
        if (status == Z_STREAM_END) {
            done = YES;
        }else if (status != Z_OK){
            break;
        }
    }
    if (inflateEnd(&strm) != Z_OK) {
        return nil;
    }
    //set real length
    if (done) {
        [decompressed setLength:strm.total_out];
        
        return [NSData dataWithData:decompressed];
    }else {
        return nil;
    }
}

+ (NSString *)writeFileToDirWithDirType:(NSString *)dirname dirType:(NSInteger)type fileName:(NSString *)filename DATA:(NSData *)data{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains((type==0?NSDocumentDirectory:(type==1?NSLibraryDirectory:NSCachesDirectory)), NSUserDomainMask, YES);
    
    NSString *spath = [paths firstObject];
    
    [fileManager changeCurrentDirectoryPath:spath];
    
    if (dirname.length > 0) {
        [fileManager createDirectoryAtPath:dirname withIntermediateDirectories:YES attributes:nil error:nil];
        
        spath = [NSString stringWithFormat:@"%@/%@/%@", spath, dirname, filename];
        
    }else {
        
        spath = [NSString stringWithFormat:@"%@/%@", spath, filename];
        
    }
    [fileManager createFileAtPath:spath contents:data attributes:nil];
    
    return spath;
}


+ (NSData *)readFileFromDirWithDirType:(NSString *)dirname dirType:(NSInteger)type fileName:(NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains((type==0?NSDocumentDirectory:(type==1?NSLibraryDirectory:NSCachesDirectory)), NSUserDomainMask, YES);
    
    NSString *spath = [paths firstObject];
    
    if (dirname.length > 0) {
        
        spath = [NSString stringWithFormat:@"%@/%@/%@", spath, dirname, filename];
        
    }else {
        
        spath = [NSString stringWithFormat:@"%@/%@", spath, filename];

    }
    return [[NSData alloc] initWithContentsOfFile:spath];

}

@end
