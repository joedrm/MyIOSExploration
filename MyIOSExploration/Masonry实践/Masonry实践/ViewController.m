//
//  ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/2.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

/*
 参考地址：
 
 http://tutuge.me/tags/Autolayout/
 https://github.com/zekunyan/AutolayoutExampleWithMasonry
 https://github.com/CoderJackyHuang/MasonryDemo
 */


#import "ViewController.h"
#import "Case1ViewController.h"

static NSString* identifier = @"cell";

@interface ViewController ()
@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, strong) NSArray* vcArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Masonry实践";
    self.titleArr = @[@"Case1: 并排两个label，宽度由内容决定。父级View宽度不够时，优先显示左边label的内容",
                      @"Case2: 四个ImageView整体居中，可以任意显示、隐藏",
                      @"Case3: 子View的宽度始终是父级View的一半（或者任意百分比）",
                      @"Case4: 动态计算cell高度",
                      @"Case5: Header头部拉伸效果",
                      @"Case6: Cell的展开和收缩",
                      @"Case7: 两种方式实现等间距",
                      @"Case8: 约束动画"];
    self.vcArr = @[@"Case1ViewController",
                   @"Case2ViewController",
                   @"Case3ViewController",
                   @"Case4ViewController",
                   @"Case5ViewController",
                   @"Case6ViewController",
                   @"Case7ViewController",
                   @"Case8ViewController"
                   ];
    self.tableView.rowHeight = 55;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
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


