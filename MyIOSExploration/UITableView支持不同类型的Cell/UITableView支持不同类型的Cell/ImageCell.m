//
//  ImageCell.m
//  UITableView支持不同类型的Cell
//
//  Created by wdy on 2016/10/24.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()


@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

- (void)configerItem:(ItemModel *)item
{
    _imgView.image = [UIImage imageNamed:item.avatar];
}

@end
