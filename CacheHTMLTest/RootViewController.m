//
//  RootViewController.m
//  CacheHTMLTest
//
//  Created by zhangmeng on 15/2/3.
//  Copyright (c) 2015年 zhangmeng. All rights reserved.
//

#import "RootViewController.h"
#import "MyUrlCache.h"
#import "seconedViewController.h"

@interface RootViewController ()<UIWebViewDelegate>

@end

@implementation RootViewController
{
    UIActivityIndicatorView *activityIndicator;
    
    MyUrlCache *testCache;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    testCache = [[MyUrlCache alloc]initWithMemoryCapacity:1024*1024*12 diskCapacity:1024*1024*120 diskPath:@"jiayuanAssitant1.db"];
    [testCache initilize];
    
    [NSURLCache setSharedURLCache:testCache];
    
    NSLog(@" 沙盒路径为：%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject]);
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(write)];
    [self loadSubviews];
    
}
- (void)write{
    seconedViewController *seonedVC = [[seconedViewController alloc] init];
//    [self.navigationController pushViewController:seonedVC animated:YES];
    [self presentViewController:seonedVC animated:YES completion:nil];
}

#pragma load subviews of the controllers view
- (void)loadSubviews {
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://121.199.38.85/mishiclient/houtai/Public/message_tmp/1419308512.html"]];
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

#pragma UIWebViewDelegate method
- (void)webViewDidStartLoad:(UIWebView *)webView
{
 //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    view.tag = 100;
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    activityIndicator.center = view.center;
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:100];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error  {
    
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:100];
    [view removeFromSuperview];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}








@end
