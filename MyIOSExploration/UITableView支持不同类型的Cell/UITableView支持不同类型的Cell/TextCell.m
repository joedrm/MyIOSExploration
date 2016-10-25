//
//  TextCell.m
//  UITableView支持不同类型的Cell
//
//  Created by wdy on 2016/10/24.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "TextCell.h"

@interface TextCell ()

@property (nonatomic, strong) UILabel *myTextLabel;

@end

@implementation TextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _myTextLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _myTextLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_myTextLabel];
    }
    return self;
}

- (void)configerItem:(ItemModel *)item
{
    _myTextLabel.text = item.name;
}

@end
