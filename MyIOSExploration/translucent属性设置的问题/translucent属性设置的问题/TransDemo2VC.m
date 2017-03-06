//
//  TransDemo2VC.m
//  translucent属性设置的问题
//
//  Created by wdy on 2016/10/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "TransDemo2VC.h"

@interface TransDemo2VC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TransDemo2VC

static NSString* identi = @"TransDemo1VC";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 不保留半透明效果：也就是将tabBar和navigationBar的translucnet属性都改为NO，其他不做修改，
    self.navigationController.navigationBar.translucent = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //总结，self.navigationController.navigationBar.translucent = YES，即navigationBar默认是透明的，而此时设置 extendedLayoutIncludesOpaqueBars 的值其实没有作用，
    //只有当 self.navigationController.navigationBar.translucent = NO 的时候 extendedLayoutIncludesOpaqueBars 的作用才能显现出来。
    //extendedLayoutIncludesOpaqueBars = YES，控制器view的起始位置将从顶部开始。
    
    // 在ios7.1以后，ios会根据navigationBar的translucent来自动确定是否全屏。
//    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


@end

