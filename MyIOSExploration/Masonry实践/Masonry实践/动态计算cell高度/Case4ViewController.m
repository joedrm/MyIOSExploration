//
//  Case4ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/2.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "Case4ViewController.h"
#import "Case4Cell.h"
#import "Case4Model.h"

@interface Case4ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (strong, nonatomic) NSArray *cellItemArr;
@property (strong, nonatomic) Case4Cell *templateCell;
@end

@implementation Case4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UITableViewCell的动态高度";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellItemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Case4Cell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setupData:self.cellItemArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef IOS_8_NEW_FEATURE_SELF_SIZING
    // iOS 8 的Self-sizing特性
    return UITableViewAutomaticDimension;
#else
    
    if (!_templateCell) {
        _templateCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        _templateCell.tag = -1000;
    }
    
    // 获取对应的数据
    Case4Model *dataEntity = self.cellItemArr[(NSUInteger) indexPath.row];
    
    // 判断高度是否已经计算过
    if (dataEntity.cellHeight <= 0) {
        // 填充数据
        [_templateCell setupData:dataEntity];
        // 根据当前数据，计算Cell的高度，注意+1
        dataEntity.cellHeight = [_templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 0.5f;
        NSLog(@"Calculate: %ld, height: %g", (long) indexPath.row, dataEntity.cellHeight);
    } else {
        NSLog(@"Get cache: %ld, height: %g", (long) indexPath.row, dataEntity.cellHeight);
    }
    return dataEntity.cellHeight;
#endif
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[Case4Cell class] forCellReuseIdentifier:identifier];
#ifdef IOS_8_NEW_FEATURE_SELF_SIZING
        // iOS 8 的Self-sizing特性
        if ([UIDevice currentDevice].systemVersion.integerValue > 7) {
            _tableView.rowHeight = UITableViewAutomaticDimension;
        }
#endif

    }
    return _tableView;
}

- (NSArray *)cellItemArr
{
    if (_cellItemArr == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *frameCellMArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            Case4Model *cellM = [Case4Model mj_objectWithKeyValues:dict];
            cellM.name = @"Mario";
            [frameCellMArray addObject:cellM];
        }
        _cellItemArr = frameCellMArray;
    }
    return _cellItemArr;
}


@end

/*
 用systemLayoutSizeFittingSize:获取Cell的高度
 在设定好Cell的约束以后，就可以用systemLayoutSizeFittingSize:方法获取Cell的实际高度，它的参数可以设定为两个系统常量，如下：
 
 UILayoutFittingCompressedSize: 返回合适的最小大小。
 UILayoutFittingExpandedSize: 返回合适的最大大小。
 */














