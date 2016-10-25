//
//  TransDemo3VC.m
//  translucent属性设置的问题
//
//  Created by wdy on 2016/10/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "TransDemo3VC.h"

@interface TransDemo3VC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TransDemo3VC

static NSString* identi = @"TransDemo3VC";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 在IOS7.0下 实现每个group头部等高效果
    if ([[[UIDevice currentDevice] systemVersion] floatValue] == 7.0) {
        tableView.sectionHeaderHeight = 64;
        tableView.sectionFooterHeight = 0;
        tableView.contentInset = UIEdgeInsetsMake(64 - 35, 0, 0, 0);
    }
    tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
