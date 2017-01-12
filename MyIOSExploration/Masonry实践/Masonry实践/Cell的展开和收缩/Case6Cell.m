//
//  Case6Cell.m
//  Masonry实践
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "Case6Cell.h"
#import "Case6Model.h"

@interface Case6Cell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *moreButton;

@property (strong, nonatomic) MASConstraint *contentHeightConstraint;

@property (weak, nonatomic) Case6Model *entity;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation Case6Cell


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - Init

// 调用UITableView的dequeueReusableCellWithIdentifier方法时会通过这个方法初始化Cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - Public method

- (void)setEntity:(Case6Model *)entity indexPath:(NSIndexPath *)indexPath {
    _entity = entity;
    _indexPath = indexPath;
    _titleLabel.text = entity.name;
    _contentLabel.text = entity.content;
    
    if (entity.expanded) {
        [_contentHeightConstraint uninstall];
    } else {
        [_contentHeightConstraint install];
    }
}

#pragma mark - Actions

- (void)switchExpandedState:(UIButton *)button {
    [_delegate case8Cell:self switchExpandedStateWithIndexPath:_indexPath];
}

#pragma mark - Private method

- (void)initView {
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // Title
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@21);
        make.left.and.right.and.top.equalTo(self.contentView).insets(UIEdgeInsetsMake(4, 8, 4, 8));
    }];
    
    // More button
    _moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_moreButton setTitle:@"More" forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(switchExpandedState:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_moreButton];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32);
        make.left.and.right.and.bottom.equalTo(self.contentView);
    }];
    
    // Content
    // 计算UILabel的preferredMaxLayoutWidth值，多行时必须设置这个值，否则系统无法决定Label的宽度
    CGFloat preferredMaxWidth = [UIScreen mainScreen].bounds.size.width - 16;
    
    // Content - 多行
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.clipsToBounds = YES;
    _contentLabel.preferredMaxLayoutWidth = preferredMaxWidth; // 多行时必须设置
    [self.contentView addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(4, 8, 4, 8));
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(4);
        make.bottom.equalTo(_moreButton.mas_top).with.offset(-4);
        // 先加上高度的限制
        _contentHeightConstraint = make.height.equalTo(@64).with.priorityHigh(); // 优先级只设置成High,比正常的高度约束低一些,防止冲突
    }];
    
    /*
     为什么正文UILabel的高度约束的优先级要调整为High
     在UITableView刷新时，会先计算高度，即先调用tableView: heightForRowAtIndexPath:方法，如果高度约束为默认的1000最高的话，会产生冲突。
     
     因为在计算的时候，我们的高度是由一个“template cell”填充内容后计算得来，这个时候的高度已经是展开以后的高度，当前的Cell还来不及调整约束（甚至不会调整，如果只用beginUpdates和endUpdates更新的话，Cell不会reload），所以降低这个高度约束的优先级，去掉冲突。
     
     使用install和uninstall控制约束
     为了能得正确高度，Cell需要根据具体的数据、状态更新约束。
     这里可以使用install和uninstall来控制正文UILabel高度约束是否生效。在填充Cell的数据时，就可以根据状态BOOL值来选择调用：
     */
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    NSValue *frameValue = change[NSKeyValueChangeOldKey];
    CGFloat oldHeight = [frameValue CGRectValue].size.height;
    
    frameValue = change[NSKeyValueChangeNewKey];
    CGFloat newHeight = [frameValue CGRectValue].size.height;
    
    NSLog(@"contentView: %p, height change from: %g, to: %g.", (__bridge void *) self.contentView, oldHeight, newHeight);
}

@end
