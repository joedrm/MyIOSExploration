//
//  BaseTableView.m
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#import "BaseTableView.h"

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.tableFooterView = [UIView new];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/** 注册普通的UITableViewCell*/
- (void)wdy_registerCellClass:(Class)cellClass identifier:(NSString *)identifier {
    if (cellClass && identifier.length) {
        [self registerClass:cellClass forCellReuseIdentifier:identifier];
    }
}
/** 注册一个从xib中加载的UITableViewCell*/
- (void)wdy_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier {
    if (cellNib && nibIdentifier.length) {
        UINib *nib = [UINib nibWithNibName:[cellNib description] bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:nibIdentifier];
    }
}

/** 注册一个普通的UITableViewHeaderFooterView*/
- (void)wdy_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier {
    if (headerFooterClass && identifier.length) {
        [self registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:identifier];
    }
}
/** 注册一个从xib中加载的UITableViewHeaderFooterView*/
- (void)wdy_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier {
    if (headerFooterNib && nibIdentifier.length) {
        UINib *nib = [UINib nibWithNibName:[headerFooterNib description] bundle:nil];
        [self registerNib:nib forHeaderFooterViewReuseIdentifier:nibIdentifier];
    };
}

- (void)wdy_updateWithUpdateBlock:(void (^)(BaseTableView *tableView))updateBlock {
    if (updateBlock) {
        [self beginUpdates];
        updateBlock(self);
        [self endUpdates];
    }
}
- (UITableViewCell *)wdy_cellAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) return nil;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
        NSLog(@"刷新section: %@ 已经越界, 总组数: %@", @(indexPath.section), @(sectionNumber));
        return nil;
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
        NSLog(@"刷新row: %@ 已经越界, 总行数: %@ 所在section: %@", @(indexPath.row), @(rowNumber), @(section));
        return nil;
    }
    return [self cellForRowAtIndexPath:indexPath];
}
/** 刷新单行、动画默认*/
- (void)wdy_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self wdy_reloadSingleRowAtIndexPath:indexPath animation:None];
}
- (void)wdy_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(BaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
        NSLog(@"刷新section: %@ 已经越界, 总组数: %@", @(indexPath.section), @(sectionNumber));
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
        NSLog(@"刷新row: %@ 已经越界, 总行数: %@ 所在section: %@", @(indexPath.row), @(rowNumber), @(section));
    } else {
        [self beginUpdates];
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 刷新多行、动画默认*/
- (void)wdy_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self wdy_reloadRowsAtIndexPaths:indexPaths animation:None];
}
- (void)wdy_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(BaseTableViewRowAnimation)animation {
    if (!indexPaths.count) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf wdy_reloadSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

/** 刷新某个section、动画默认*/
- (void)wdy_reloadSingleSection:(NSInteger)section {
    [self wdy_reloadSingleSection:section animation:None];
}
- (void)wdy_reloadSingleSection:(NSInteger)section animation:(BaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) { // section越界
        NSLog(@"刷新section: %@ 已经越界, 总组数: %@", @(section), @(sectionNumber));
    } else {
        [self beginUpdates];
        [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 刷新多个section、动画默认*/
- (void)wdy_reloadSections:(NSArray <NSNumber *>*)sections {
    [self wdy_reloadSections:sections animation:None];
}
- (void)wdy_reloadSections:(NSArray<NSNumber *> *)sections animation:(BaseTableViewRowAnimation)animation {
    if (!sections.count) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf wdy_reloadSingleSection:obj.integerValue animation:animation];
        }
    }];
}

/** 删除单行、动画默认*/
- (void)wdy_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self wdy_deleteSingleRowAtIndexPath:indexPath animation:Fade];
}
- (void)wdy_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(BaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    
    NSLog(@"sectionNumber %@  section%@ rowNumber%@",@(sectionNumber), @(section) , @(rowNumber));
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
        NSLog(@"删除section: %@ 已经越界, 总组数: %@", @(indexPath.section), @(sectionNumber));
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
        NSLog(@"删除row: %@ 已经越界, 总行数: %@ 所在section: %@", @(indexPath.row), @(rowNumber), @(section));
    } else {
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 删除多行、动画默认*/
- (void)wdy_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self wdy_deleteRowsAtIndexPaths:indexPaths animation:Fade];
}
- (void)wdy_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(BaseTableViewRowAnimation)animation {
    if (!indexPaths.count) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf wdy_deleteSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

/** 删除某个section、动画默认*/
- (void)wdy_deleteSingleSection:(NSInteger)section {
    
    [self wdy_deleteSingleSection:section animation:Fade];
}
- (void)wdy_deleteSingleSection:(NSInteger)section animation:(BaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) { // section 越界
        NSLog(@"刷新section: %@ 已经越界, 总组数: %@", @(section), @(sectionNumber));
    } else {
        [self beginUpdates];
        [self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 删除多个section*/
- (void)wdy_deleteSections:(NSArray *)sections {
    [self wdy_deleteSections:sections animation:Fade];
}
- (void)wdy_deleteSections:(NSArray<NSNumber *> *)sections animation:(BaseTableViewRowAnimation)animation {
    if (!sections.count) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf wdy_deleteSingleSection:obj.integerValue animation:animation];
        }
    }];
}

/** 增加单行 动画无*/
- (void)wdy_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self wdy_insertSingleRowAtIndexPath:indexPath animation:None];
}
/** 增加单行，动画自定义*/
- (void)wdy_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(BaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (section > sectionNumber || section < 0) {
        // section 越界
        NSLog(@"section 越界 : %@", @(section));
    } else if (row > rowNumber || row < 0) {
        NSLog(@"row 越界 : %@", @(row));
    } else {
        [self beginUpdates];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
    
}

/** 增加单section，动画无*/
- (void)wdy_insertSingleSection:(NSInteger)section {
    [self wdy_insertSingleSection:section animation:None];
}
/** 增加单section，动画自定义*/
- (void)wdy_insertSingleSection:(NSInteger)section animation:(BaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) {
        // section越界
        NSLog(@" section 越界 : %@", @(section));
    } else {
        [self beginUpdates];
        [self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 增加多行，动画无*/
- (void)wdy_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self wdy_insertRowsAtIndexPaths:indexPaths animation:None];
}
/** 增加多行，动画自定义*/
- (void)wdy_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(BaseTableViewRowAnimation)animation {
    if (indexPaths.count == 0) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf wdy_insertSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

/** 增加多section，动画无*/
- (void)wdy_insertSections:(NSArray <NSNumber *>*)sections {
    [self wdy_insertSections:sections animation:None];
}
/** 增加多section，动画默认*/
- (void)wdy_insertSections:(NSArray <NSNumber *>*)sections animation:(BaseTableViewRowAnimation)animation {
    if (sections.count == 0) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf wdy_insertSingleSection:obj.integerValue animation:animation];
        }
    }];
}

/** 当有输入框的时候 点击tableview空白处，隐藏键盘*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id view = [super hitTest:point withEvent:event];
    if (![view isKindOfClass:[UITextField class]]) {
        [self endEditing:YES];
    }
    return view;
}

@end
