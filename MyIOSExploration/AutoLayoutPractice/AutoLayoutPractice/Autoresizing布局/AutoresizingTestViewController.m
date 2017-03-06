//
//  AutoresizingTestViewController.m
//  AutoLayoutPractice
//
//  Created by fang wang on 17/3/6.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "AutoresizingTestViewController.h"

@interface AutoresizingTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AutoresizingTestViewController

static NSString* identi = @"TransDemo3VC";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    // autoresizingMask 能保证在ViewController的view尺寸变化时能自适应，如屏幕旋转，热点，电话等
    // 当然此处也可以使用AutoLayout来实现
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
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
