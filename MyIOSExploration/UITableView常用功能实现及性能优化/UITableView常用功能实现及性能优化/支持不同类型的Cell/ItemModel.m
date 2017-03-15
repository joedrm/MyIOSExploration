//
//  ItemModel.m
//  UITableView支持不同类型的Cell
//
//  Created by wdy on 2016/10/24.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "ItemModel.h"
#import "ImageCell.h"
#import "TextCell.h"
#import "MixCell.h"

@implementation ItemModel

- (NSString *)cellIdentifier
{
    if (_showtype == ItemShowTextAndAvatar) {
        return NSStringFromClass([MixCell class]);
    } else if (_showtype == ItemShowAvatar){
        return NSStringFromClass([ImageCell class]);
    } else {
        return NSStringFromClass([TextCell class]);
    }
}



@end
