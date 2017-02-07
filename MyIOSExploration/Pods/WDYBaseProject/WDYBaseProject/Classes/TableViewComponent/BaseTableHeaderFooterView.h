//
//  BaseTableHeaderFooterView.h
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//

#import <UIKit/UIKit.h>

@interface BaseTableHeaderFooterView : UITableViewHeaderFooterView
/**
 *  快速创建一个不是从xib中加载的tableview header footer
 */
+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView;
/**
 *  快速创建一个从xib中加载的tableview header footer
 */
+ (instancetype)nibHeaderFooterViewWithTableView:(UITableView *)tableView;

@end
