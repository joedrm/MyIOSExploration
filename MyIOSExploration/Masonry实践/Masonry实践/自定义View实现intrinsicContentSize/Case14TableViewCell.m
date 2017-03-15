//
//  Case14TableViewCell.m
//  Masonry实践
//
//  Created by fang wang on 17/3/15.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import "Case14TableViewCell.h"

@implementation Case14TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        
        _stairView = [Case14StairView new];
        _stairView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
        [self.contentView addSubview:_stairView];
        
        [_stairView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(4, 4, 4, 4));
        }];
    }
    return self;
}


@end
