//
//  BaseCell.h
//  UITableView支持不同类型的Cell
//
//  Created by wdy on 2016/10/24.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

@interface BaseCell : UITableViewCell

- (void)configerItem:(ItemModel *)item;
@end
