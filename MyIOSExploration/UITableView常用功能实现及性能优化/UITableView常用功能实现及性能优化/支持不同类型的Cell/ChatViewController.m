//
//  ChatViewController.m
//  UITableView常用功能实现及性能优化
//
//  Created by fang wang on 17/3/15.
//  Copyright © 2017年 wdy. All rights reserved.
//


/*
 在某些业务场景下，同一个UITableView需要支持多种UITableViewCell。类似于即时通信的聊天对话列表
 参考文章：https://github.com/la0fu/MultipleCells
 */

#import "ChatViewController.h"
#import "ImageCell.h"
#import "ItemModel.h"
#import "TextCell.h"
#import "ImageCell.h"
#import "MixCell.h"
#import "BaseCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *ItemModels;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    ItemModel *p1 = [[ItemModel alloc] init];
    p1.showtype = ItemShowText;
    p1.name = @"Peter";
    
    ItemModel *p2 = [[ItemModel alloc] init];
    p2.showtype = ItemShowAvatar;
    p2.avatar = @"dancing-minion-icon.png";
    
    ItemModel *p3 = [[ItemModel alloc] init];
    p3.showtype = ItemShowTextAndAvatar;
    p3.name = @"James";
    p3.avatar = @"shy-minion-icon.png";
    
    ItemModel *p4 = [[ItemModel alloc] init];
    p4.showtype = ItemShowText;
    p4.name = @"Peter";
    
    ItemModel *p5 = [[ItemModel alloc] init];
    p5.showtype = ItemShowAvatar;
    p5.avatar = @"dancing-minion-icon.png";
    
    ItemModel *p6 = [[ItemModel alloc] init];
    p6.showtype = ItemShowTextAndAvatar;
    p6.name = @"James";
    p6.avatar = @"shy-minion-icon.png";
    
    ItemModel *p7 = [[ItemModel alloc] init];
    p7.showtype = ItemShowText;
    p7.name = @"Peter";
    
    ItemModel *p8 = [[ItemModel alloc] init];
    p8.showtype = ItemShowAvatar;
    p8.avatar = @"dancing-minion-icon.png";
    
    ItemModel *p9 = [[ItemModel alloc] init];
    p9.showtype = ItemShowTextAndAvatar;
    p9.name = @"James";
    p9.avatar = @"shy-minion-icon.png";
    
    ItemModel *p10 = [[ItemModel alloc] init];
    p10.showtype = ItemShowText;
    p10.name = @"Peter";
    
    ItemModel *p11 = [[ItemModel alloc] init];
    p11.showtype = ItemShowAvatar;
    p11.avatar = @"dancing-minion-icon.png";
    
    ItemModel *p12 = [[ItemModel alloc] init];
    p12.showtype = ItemShowTextAndAvatar;
    p12.name = @"James";
    p12.avatar = @"shy-minion-icon.png";
    
    self.ItemModels = [NSMutableArray arrayWithObjects:p1, p2, p3,p4, p5, p6, p7, p8, p9,p10, p11, p12,nil];
    
    [self registerCell];
}

- (void)registerCell
{
    [_tableView registerClass:[TextCell class] forCellReuseIdentifier:NSStringFromClass([TextCell class])];
    [_tableView registerClass:[ImageCell class] forCellReuseIdentifier:NSStringFromClass([ImageCell class])];
    [_tableView registerClass:[MixCell class] forCellReuseIdentifier:NSStringFromClass([MixCell class])];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ItemModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemModel *p = _ItemModels[indexPath.row];
    BaseCell *cell;
    NSString *cellIdentifier;
    cellIdentifier = p.cellIdentifier;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell configerItem:p];
    return cell;
}

@end
