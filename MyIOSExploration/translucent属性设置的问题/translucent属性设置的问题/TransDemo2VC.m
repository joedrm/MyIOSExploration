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

