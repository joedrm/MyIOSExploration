//
//  MixCell.m
//  UITableView支持不同类型的Cell
//
//  Created by wdy on 2016/10/24.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "MixCell.h"


@interface MixCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *lb;

@end

@implementation MixCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.lb = [[ UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 40)];
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_lb];
    }
    return self;
}

- (void)configerItem:(ItemModel *)item
{
    _imgView.image = [UIImage imageNamed:item.avatar];
    _lb.text = item.name;
}

@end
