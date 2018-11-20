//
//  ViewController.m
//  TableViewMenu
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "ViewController.h"
#import "MainTableView.h"
#import "SegmentTitleView.h"
#import "DetailViewContentView.h"
#import "ContentCell.h"
#import "SegmentWebViewVC.h"
#import "SegmentListViewVC.h"

#define tableViewSectionOneHeight 200

#define tableViewSectionTwoHeight  [UIScreen mainScreen].bounds.size.height

#define SegmentTitleViewHeight 50

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SegmentTitleViewDelegate,PageContentViewDelegate>

@property(nonatomic,strong)MainTableView *mainTableView;

@property(nonatomic,strong)SegmentTitleView *titleView;

@property(nonatomic,copy)NSArray *segmentTitleArray;

@property(nonatomic,strong)ContentCell *contentCell;

@property(nonatomic,strong)SegmentWebViewVC *webViewVC;

@property(nonatomic,strong)SegmentListViewVC *listViewVC;

@property (nonatomic, assign) BOOL canScroll;

@property(nonatomic,assign)BOOL isTableViewRefesh;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:UpdateVC object:nil];
    [self.view addSubview:self.mainTableView];
    _segmentTitleArray=@[@"详情",@"目录"];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)changeScrollStatus{
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[MainTableView alloc]initWithFrame:self.view.frame];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        _mainTableView.separatorStyle=UITableViewCellAccessoryNone;
    }
    return _mainTableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return tableViewSectionOneHeight;
    }
    return tableViewSectionTwoHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return SegmentTitleViewHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0){
        return 10;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.titleView = [[SegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SegmentTitleViewHeight) titles:_segmentTitleArray delegate:self indicatorType:IndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    _titleView.indicatorExtension=1;
    [_titleView setIndicatorColor:[UIColor colorWithRed:0/255.0 green:142/255.0 blue:109/255.0 alpha:1.0]];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetHeight(self.titleView.bounds)-0.5, [UIScreen mainScreen].bounds.size.width-30, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [_titleView addSubview:line];
    return self.titleView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *headViewCell = @"headViewCell";
    static NSString *contentViewCell=@"contentViewCell";
    if(indexPath.section==0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headViewCell];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headViewCell];
        }
        for(UIView *subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, tableViewSectionOneHeight)];
        headView.backgroundColor=[UIColor redColor];
        [cell.contentView addSubview:headView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==1){
        if (!_contentCell) {
            _contentCell = [[ContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentViewCell];
        }
        for(UIView *subViews in _contentCell.contentView.subviews){
            [subViews removeFromSuperview];
        }
        NSMutableArray *contentVCs = [NSMutableArray array];
        for(int i=0;i<_segmentTitleArray.count;i++){
            if(i==0){
                _webViewVC = [[SegmentWebViewVC alloc]init];
                [contentVCs addObject:_webViewVC];
            }
            else{
                _listViewVC= [[SegmentListViewVC alloc]init];
                [contentVCs addObject:_listViewVC];
            }
        }
        _contentCell.viewControllers = contentVCs;
        _contentCell.pageContentView = [[DetailViewContentView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) childVCs:contentVCs parentVC:self delegate:self];
        [_contentCell.contentView addSubview:_contentCell.pageContentView];
        return _contentCell;
    }
    else{
        return nil;
    }
}

#pragma mark SegmentTitleViewDelegate
- (void)ContenViewDidEndDecelerating:(DetailViewContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    _mainTableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}

- (void)SegmentTitleView:(SegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)ContentViewDidScroll:(DetailViewContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    _mainTableView.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomCellOffset = [_mainTableView rectForSection:1].origin.y;
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
    self.mainTableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}



@end
