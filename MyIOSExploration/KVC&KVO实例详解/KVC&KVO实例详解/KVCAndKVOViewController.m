//
//  ViewController.m
//  KVC&KVO实例详解
//
//  Created by fang wang on 16/12/21.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "KVCAndKVOViewController.h"

static NSString* KVOAndKVCIdentifier = @"KVOAndKVCIdentifier";

@interface KVCAndKVOViewController ()


@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, strong) NSArray* vcArr;
@end

@implementation KVCAndKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KVC&KVO实例详解";
    self.titleArr = @[@"KVO监听数组",
                      @"手动触发KVO"];
    
    self.vcArr = @[@"KVOObserveArrayVC",
                   @"SetKVOViewController"
                   ];
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KVOAndKVCIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:KVOAndKVCIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:KVOAndKVCIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id class = NSClassFromString(self.vcArr[indexPath.row]);
    UIViewController* vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
