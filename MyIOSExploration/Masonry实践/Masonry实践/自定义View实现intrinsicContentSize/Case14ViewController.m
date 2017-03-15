//
//  Case13ViewController.m
//  Masonry实践
//
//  Created by fang wang on 17/3/15.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import "Case14ViewController.h"
#import "Case14TableViewCell.h"

@interface Case14ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation Case14ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    http://tutuge.me/2017/03/12/autolayout-example-with-masonry5/
    //    https://www.mgenware.com/blog/?p=491  iOS: 在代码中使用Autolayout (2) – intrinsicContentSize和Content Hugging Priority
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 80;
    [_tableView registerClass:[Case14TableViewCell class] forCellReuseIdentifier:kCase14TableViewCellIdentifier];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 数据
    _titles = @[@"AutoLayout AutoLayout AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                @"on", @"constraints", @"placed", @"on", @"those", @"views"];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // UITableViewAutomaticDimension不会自动在外部frame变化时刷新，所以手动reload下
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Case14TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCase14TableViewCellIdentifier forIndexPath:indexPath];
    [cell.stairView setStairTitles:[_titles subarrayWithRange:NSMakeRange(0, indexPath.row % 4 + 1)]];
    return cell;
}


@end
