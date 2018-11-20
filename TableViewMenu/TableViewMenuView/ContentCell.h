//
//  ContentCell.h
//  TableViewMenu
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentCell : UITableViewCell

@property (nonatomic, strong) DetailViewContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) BOOL cellCanScroll;
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, strong) NSString *currentTagStr;

@end

NS_ASSUME_NONNULL_END
