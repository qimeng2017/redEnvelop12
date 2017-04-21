//
//  HRHelpTableView.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRHelpTableView.h"
#import "HRHelpCell.h"
#import "HRHelpCellFrame.h"
#import "HRHelpModel.h"
static NSString *helpTableCellID = @"helpTableCellID";
@interface HRHelpTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *problemDatas;
@end

@implementation HRHelpTableView

- (NSMutableArray *)problemDatas{
    if (_problemDatas == nil) {
        _problemDatas = [HRHelpCellFrame cellSourceWithName:@"HelpInfomation"];
    }
    return _problemDatas;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.backgroundColor = [UIColor whiteColor];
        self.tableFooterView = [[UIView alloc]init];
        [self registerClass:[HRHelpCell class] forCellReuseIdentifier:helpTableCellID];
    }
    return self;
}
#pragma mark - tableView的数据源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HRHelpCellFrame *cellF = self.problemDatas[indexPath.row];
    return cellF.cellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.problemDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HRHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:helpTableCellID];
    HRHelpCellFrame *cFrame = self.problemDatas[indexPath.row];
    cell.cellFrame = cFrame;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取出对应位置的模型
    HRHelpCellFrame *cellF = self.problemDatas[indexPath.row];
    
    HRHelpModel *cellM = cellF.cellModel;
    
    if (cellF.isOpened) {
        //  改变开关状态 开 --> 关
        cellF.opened = NO;
    }else
    {//  改变开关状态 关 --> 开
        cellF.opened = YES;
    }
    // 注意:每次点击需要重新设置frame 并刷新表格数据
    [cellF setCellModel:cellM];
    
    //    [self reloadData];
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 获取当前选中Cell的最大Y值
    //    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    //    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
}

@end
