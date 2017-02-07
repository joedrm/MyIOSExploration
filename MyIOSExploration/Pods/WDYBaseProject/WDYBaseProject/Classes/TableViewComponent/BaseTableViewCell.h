//
//  BaseTableViewCell.h
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell
@property (nonatomic, weak) UITableView *tableView;

+ (instancetype)cellWithDefaultStyleTableView:(UITableView *)tableView;
+ (instancetype)cellWithDefaultStyleAndReuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView;
+ (instancetype)cellWithStyle:(UITableViewCellStyle)style tableView:(UITableView *)tableView;

+ (instancetype)nibCellWithTableView:(UITableView *)tableView;


/** 设置(添加)子控件，此方法在子类重写 */
- (void)setupUI;

- (void)refreshUIWithModel:(id)model;

/** 得到Cell默认的高度 */
+ (CGFloat)getCellHeight;
+ (CGFloat)getCellHeightWithModel:(id)model;
@end
