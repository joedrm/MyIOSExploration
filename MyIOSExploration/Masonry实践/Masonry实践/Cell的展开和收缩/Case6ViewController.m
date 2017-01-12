//
//  Case6ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/2.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "Case6ViewController.h"
#import "Case6Model.h"
#import "Case6Cell.h"

@interface Case6ViewController ()<UITableViewDelegate, UITableViewDataSource, Case6CellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (strong, nonatomic) NSArray *cellItemArr;
@property (strong, nonatomic) Case6Cell *templateCell;
@end

@implementation Case6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
}

- (void)case8Cell:(Case6Cell *)cell switchExpandedStateWithIndexPath:(NSIndexPath *)index {
    // 改变数据
    Case6Model *case6M = self.cellItemArr[(NSUInteger) index.row];
    case6M.expanded = !case6M.expanded; // 切换展开还是收回
    case6M.cellHeight = 0; // 重置高度缓存
    
    // **********************************
    // 下面两种方法均可实现高度更新，都尝试下吧
    // **********************************
    
    // 刷新方法1：只会重新计算高度,不会reload cell,所以只是把原来的cell撑大了而已,还是同一个cell实例
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    // 刷新方法2：先重新计算高度,然后reload,不是原来的cell实例
    //    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    
    // 让展开/收回的Cell居中，酌情加，看效果决定
    [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellItemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Case6Cell *cell = [tableView dequeueReusableCellWithIdentifier:Case6CellIidentifier forIndexPath:indexPath];
    [cell setEntity:self.cellItemArr[(NSUInteger) indexPath.row] indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_templateCell) {
        _templateCell = [tableView dequeueReusableCellWithIdentifier:Case6CellIidentifier];
    }
    
    // 获取对应的数据
    Case6Model *dataEntity = self.cellItemArr[(NSUInteger) indexPath.row];
    
    // 判断高度是否已经计算过
    if (dataEntity.cellHeight <= 0) {
        // 填充数据
        // 设置-1只是为了方便调试，在log里面可以分辨出哪个cell被调用
        [_templateCell setEntity:dataEntity indexPath:[NSIndexPath indexPathForRow:-1 inSection:-1]];
        // 根据当前数据，计算Cell的高度，注意+1
        dataEntity.cellHeight = [_templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 0.5f;
        NSLog(@"Calculate height: %ld", (long) indexPath.row);
    } else {
        NSLog(@"Get cache %ld", (long) indexPath.row);
    }
    return dataEntity.cellHeight;
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
        [_tableView registerClass:[Case6Cell class] forCellReuseIdentifier:Case6CellIidentifier];
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
            Case6Model *cellM = [Case6Model mj_objectWithKeyValues:dict];
            cellM.name = @"Mario";
            [frameCellMArray addObject:cellM];
        }
        _cellItemArr = frameCellMArray;
    }
    return _cellItemArr;
}

@end
