//
//  SegmentWebViewVC.h
//  TableViewMenu
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegmentWebViewVC : UIViewController

@property (nonatomic, assign) BOOL vcCanScroll;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *text;

@end

NS_ASSUME_NONNULL_END
