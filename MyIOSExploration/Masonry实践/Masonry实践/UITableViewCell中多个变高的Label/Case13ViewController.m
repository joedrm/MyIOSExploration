//
//  Case13ViewController.m
//  Masonry实践
//
//  Created by fang wang on 17/3/15.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import "Case13ViewController.h"
#import "Case13TableViewCell.h"

@interface Case13ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSArray <NSString *> *> *data;
@end

@implementation Case13ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    http://tutuge.me/2017/03/12/autolayout-example-with-masonry5/
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 80;
    [_tableView registerClass:[Case13TableViewCell class] forCellReuseIdentifier:kCase13TableViewCellIdentifier];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 生成数据
    NSString *string = @"Masonry is a light-weight layout framework which wraps AutoLayout with a nicer syntax.";
    _data = [NSMutableArray new];
    
    for (NSInteger i = 0; i < 100; i++) {
        NSMutableArray *cellTexts = [NSMutableArray new];
        for (NSInteger j = 0; j < 3; j++) {
            [cellTexts addObject:[string substringToIndex:arc4random_uniform((uint32_t)string.length)]];
        }
        [_data addObject:cellTexts];
    }
    
    // 刷新
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Case13TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCase13TableViewCellIdentifier forIndexPath:indexPath];
    [cell configWithTexts:_data[indexPath.row]];
    return cell;
}

@end
