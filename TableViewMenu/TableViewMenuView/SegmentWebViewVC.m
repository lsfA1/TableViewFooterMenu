//
//  SegmentWebViewVC.m
//  TableViewMenu
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "SegmentWebViewVC.h"
#import "ViewController.h"

@interface SegmentWebViewVC ()<UIWebViewDelegate,UIScrollViewDelegate>

@end

@implementation SegmentWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
    self.view.backgroundColor=[UIColor whiteColor];
}

-(void)initWebView{
    _webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate=self;
    _webView.scrollView.delegate=self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:_webView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateVC object:nil];//到顶通知父视图改变状态
    }
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
