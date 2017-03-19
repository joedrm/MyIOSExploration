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
    /*
     UIViewAutoresizingFlexibleLeftMargin 距离父控件的左边是可以伸缩的
     UIViewAutoresizingFlexibleBottomMargin 距离父控件的底部是可以伸缩的
     UIViewAutoresizingFlexibleRightMargin 距离父控件的右边是可以伸缩的
     UIViewAutoresizingFlexibleTopMargin 距离父控件的顶边是可以伸缩的
     
     UIViewAutoresizingFlexibleHeight 高度会随着父控件的高度进行伸缩
     UIViewAutoresizingFlexibleWidth 宽度会随着父控件的宽度进行伸缩
     
     
     缺陷：仅仅能解决子空间和父控件之间的相对关系
     */
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
