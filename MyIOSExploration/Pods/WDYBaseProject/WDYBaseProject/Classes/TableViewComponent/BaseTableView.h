//
//  BaseTableView.h
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BaseTableViewRowAnimation) {
    Fade = UITableViewRowAnimationFade,
    Right = UITableViewRowAnimationRight,           // slide in from right (or out to right)
    Left = UITableViewRowAnimationLeft,
    Top = UITableViewRowAnimationTop,
    Bottom = UITableViewRowAnimationBottom,
    None = UITableViewRowAnimationNone,            // available in iOS 3.0
    Middle = UITableViewRowAnimationMiddle,          // available in iOS 3.2.  attempts to keep cell centered in the space it will/did occupy
    Automatic = 100  // available in iOS 5.0.  chooses an appropriate animation style for you
};
@class BaseTableViewCell;

@interface BaseTableView : UITableView

- (void)wdy_updateWithUpdateBlock:(void(^)(BaseTableView *tableView ))updateBlock;

- (UITableViewCell *)wdy_cellAtIndexPath:(NSIndexPath *)indexPath;

/** 注册普通的UITableViewCell*/
- (void)wdy_registerCellClass:(Class)cellClass identifier:(NSString *)identifier;

/** 注册一个从xib中加载的UITableViewCell*/
- (void)wdy_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier;

/** 注册一个普通的UITableViewHeaderFooterView*/
- (void)wdy_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier;

/** 注册一个从xib中加载的UITableViewHeaderFooterView*/
- (void)wdy_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier;

#pragma mark - 只对已经存在的cell进行刷新，没有类似于系统的 如果行不存在，默认insert操作
/** 刷新单行、动画默认*/
- (void)wdy_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 刷新单行、动画默认*/
- (void)wdy_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(BaseTableViewRowAnimation)animation;

/** 刷新多行、动画默认*/
- (void)wdy_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 刷新多行、动画默认*/
- (void)wdy_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(BaseTableViewRowAnimation)animation;

/** 刷新某个section、动画默认*/
- (void)wdy_reloadSingleSection:(NSInteger)section;

/** 刷新某个section、动画自定义*/
- (void)wdy_reloadSingleSection:(NSInteger)section animation:(BaseTableViewRowAnimation)animation;

/** 刷新多个section、动画默认*/
- (void)wdy_reloadSections:(NSArray <NSNumber *>*)sections;

/** 刷新多个section、动画自定义*/
- (void)wdy_reloadSections:(NSArray <NSNumber *>*)sections animation:(BaseTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 删除单行、动画默认*/
- (void)wdy_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 删除单行、动画自定义*/
- (void)wdy_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(BaseTableViewRowAnimation)animation;

/** 删除多行、动画默认*/
- (void)wdy_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 删除多行、动画自定义*/
- (void)wdy_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(BaseTableViewRowAnimation)animation;

/** 删除某个section、动画默认*/
- (void)wdy_deleteSingleSection:(NSInteger)section;

/** 删除某个section、动画自定义*/
- (void)wdy_deleteSingleSection:(NSInteger)section animation:(BaseTableViewRowAnimation)animation;

/** 删除多个section*/
- (void)wdy_deleteSections:(NSArray <NSNumber *>*)sections;

/** 删除多个section*/
- (void)wdy_deleteSections:(NSArray <NSNumber *>*)sections animation:(BaseTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 增加单行 动画无*/
- (void)wdy_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 增加单行，动画自定义*/
- (void)wdy_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(BaseTableViewRowAnimation)animation;

/** 增加单section，动画无*/
- (void)wdy_insertSingleSection:(NSInteger)section;

/** 增加单section，动画自定义*/
- (void)wdy_insertSingleSection:(NSInteger)section animation:(BaseTableViewRowAnimation)animation;

/** 增加多行，动画无*/
- (void)wdy_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 增加多行，动画自定义*/
- (void)wdy_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(BaseTableViewRowAnimation)animation;

/** 增加多section，动画无*/
- (void)wdy_insertSections:(NSArray <NSNumber *>*)sections;

/** 增加多section，动画自定义*/
- (void)wdy_insertSections:(NSArray <NSNumber *>*)sections animation:(BaseTableViewRowAnimation)animation;


@end
