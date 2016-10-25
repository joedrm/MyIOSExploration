//
//  ItemModel.h
//  UITableView支持不同类型的Cell
//
//  Created by wdy on 2016/10/24.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ItemShowType) {
    ItemShowText,
    ItemShowAvatar,
    ItemShowTextAndAvatar
};


@interface ItemModel : NSObject

@property (nonatomic, assign) ItemShowType showtype;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *cellIdentifier;

@end
