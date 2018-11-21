# TableViewFooterMenu
### tableView滚动的时候，下部分选择栏置顶
```
#pragma mark - UIScrollView
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
```
#### tableView滚动的时候通过contentoffset判断哪个VC滑动
```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateVC object:nil];//到顶通知父视图改变状态
    }
}
```
### 当里面的VC滑动到顶部的时候，通知mainTableView可以滑动，里面的VC是不可以滑动

![image](https://github.com/lsfA1/TableViewFooterMenu/raw/master/TableViewMenu/img/01.png)
![image](https://github.com/lsfA1/TableViewFooterMenu/raw/master/TableViewMenu/img/02.png)
