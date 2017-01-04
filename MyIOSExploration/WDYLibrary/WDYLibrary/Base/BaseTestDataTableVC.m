//
//  BaseTestDataTableVC.m
//  WDYLibrary
//
//  Created by fang wang on 16/12/27.
//  Copyright © 2016年 wdy. All rights reserved.
//


static NSString* BaseTestDataTableVCIdentifier = @"BaseTestDataTableVCIdentifier";

#import "BaseTestDataTableVC.h"

@interface BaseTestDataTableVC ()

@end

@implementation BaseTestDataTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BaseTestDataTableVCIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:BaseTestDataTableVCIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BaseTestDataTableVCIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    if (self.titleArr.count) {
        cell.textLabel.text = self.titleArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.vcArr.count || !self.titleArr.count || (self.vcArr.count != self.titleArr.count)) {
        return;
    }
    id class = NSClassFromString(self.vcArr[indexPath.row]);
    UIViewController* vc = [[class alloc] init];
    vc.title = self.titleArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
