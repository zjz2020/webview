//
//  seconedViewController.m
//  CacheHTMLTest
//
//  Created by 张君泽 on 16/5/16.
//  Copyright © 2016年 zhangmeng. All rights reserved.
//

#import "seconedViewController.h"
#import "MyUrlCache.h"
@interface seconedViewController (){
     MyUrlCache *testCache;
}

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation seconedViewController
- (void)viewDidAppear:(BOOL)animated{
    testCache = [[MyUrlCache alloc]initWithMemoryCapacity:1024*1024*12 diskCapacity:1024*1024*120 diskPath:@"jiayuanAssitant1.db"];
    [testCache initilize];
    
    [NSURLCache setSharedURLCache:testCache];
    
    NSLog(@" 沙盒路径为：%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"seconedViewController" owner:self options:nil] firstObject];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
