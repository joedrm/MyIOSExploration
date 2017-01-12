//
//  DeafultViewController.m
//  translucent属性设置的问题
//
//  Created by wdy on 2016/10/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//


#import "DeafultViewController.h"

@interface DeafultViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DeafultViewController

static NSString* identi = @"identifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     取消自动滚动调整，默认为YES
     系统没有再做上面那件事了，所以滚动视图没有为里面 的内容留下对应的空间，所以我们看不到最上面的内容了（滚动也会滚回去）
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, self.view.frame.size.height - 84)];
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
