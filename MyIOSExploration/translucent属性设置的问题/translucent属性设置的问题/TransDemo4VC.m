//
//  TransDemo4VC.m
//  translucent属性设置的问题
//
//  Created by fang wang on 17/3/6.
//  Copyright © 2017年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "TransDemo4VC.h"

@interface TransDemo4VC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TransDemo4VC

static NSString* identi = @"TransDemo3VC";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏不透明 （设置translucent）
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
    // 与上面代码效果一样
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
    
    
    // 导航栏透明 （设置edgesForExtendedLayout）
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeRight | UIRectEdgeLeft;
    // 与上面代码效果一样
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeRight | UIRectEdgeLeft;
    
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView];
    
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
