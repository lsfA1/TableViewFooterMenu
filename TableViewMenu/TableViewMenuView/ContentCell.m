//
//  ContentCell.m
//  TableViewMenu
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "ContentCell.h"
#import "SegmentWebViewVC.h"
#import "SegmentListViewVC.h"

@implementation ContentCell

#pragma mark Setter
- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    _viewControllers = viewControllers;
}

- (void)setCellCanScroll:(BOOL)cellCanScroll
{
    _cellCanScroll = cellCanScroll;
    for (UIViewController *VC in _viewControllers) {
        if([VC isKindOfClass:[SegmentListViewVC class]]){
            SegmentListViewVC *contentVc=(SegmentListViewVC *)VC;
            contentVc.vcCanScroll = cellCanScroll;
            if (!cellCanScroll) {//如果cell不能滑动，代表到了顶部，修改所有子vc的状态回到顶部
                contentVc.tableView.contentOffset = CGPointZero;
            }
        }
        else if ([VC isKindOfClass:[SegmentWebViewVC class]]){
            SegmentWebViewVC *webViewVc=(SegmentWebViewVC *)VC;
            webViewVc.vcCanScroll = cellCanScroll;
            if (!cellCanScroll) {//如果cell不能滑动，代表到了顶部，修改所有子vc的状态回到顶部
                webViewVc.webView.scrollView.contentOffset = CGPointZero;
            }
        }
    }
}

- (void)setIsRefresh:(BOOL)isRefresh
{
    _isRefresh = isRefresh;
    
    for (SegmentListViewVC *ctrl in self.viewControllers) {
        if ([ctrl.title isEqualToString:self.currentTagStr]) {
            ctrl.isRefresh = isRefresh;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
