//
//  ViewController.m
//  UITableViewHeader各种效果
//
//  Created by wangdongyang on 16/9/6.
//  Copyright © 2016年 wdy. All rights reserved.
//

/*
 参考资料：
 https://github.com/JoySeeDog/JSDBanTangHomeDemo 真正的仿半塘首页效果，半糖首页核心技术解析。
 https://github.com/leejayID/Linkage  两个 TableView 之间的联动，TableView 与 CollectionView 之间的联动
 https://github.com/yuping1989/YPTabBarController 功能强大，使用方便，可高度自定义的TabBarController。
 */


#import "ViewController.h"
#import "HeaderEffectVC1.h"
#import "HeaderEffectVC.h"

static NSString *identifier = @"identifier";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView* myTableView;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationBar.alpha = 1;
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 50;
    [self.view addSubview:self.myTableView];
}

#pragma mark - TableView dataSource and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        HeaderEffectVC1* eff01 = [[HeaderEffectVC1 alloc] init];
        eff01.title = self.titleArr[indexPath.row];
        [self.navigationController pushViewController:eff01 animated:YES];
    }
    
    else if (indexPath.row == 1){
        
        HeaderEffectVC* eff01 = [[HeaderEffectVC alloc] init];
//        eff01.title = self.titleArr[indexPath.row];
        [self.navigationController pushViewController:eff01 animated:YES];
    }
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"头部下拉放大",@"头部下拉放大,上拉隐藏"];
    }
    return _titleArr;
}
@end
