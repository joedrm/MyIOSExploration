//
//  BaseTableViewCell.m
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//

#import "BaseTableViewCell.h"

#define COLOR_HEX(rgbValue)       [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
                                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0f \
                                    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0f]

@implementation BaseTableViewCell

- (UITableView *)tableView {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        return  (UITableView *)self.superview.superview;
    } else {
        return (UITableView *)self.superview;
    }
}

+ (instancetype)nibCellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [self getCellIdentifier];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}


+ (instancetype)cellWithDefaultStyleTableView:(UITableView *)tableView{
    return [self cellWithStyle:UITableViewCellStyleDefault resuseIdentifier:[self getCellIdentifier] tableView:tableView];
}

+ (instancetype)cellWithDefaultStyleAndReuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView{
    return [self cellWithStyle:UITableViewCellStyleDefault resuseIdentifier:reuseIdentifier tableView:tableView];
}

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style tableView:(UITableView *)tableView{
    return [self cellWithStyle:style resuseIdentifier:[self getCellIdentifier] tableView:tableView];
}

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style resuseIdentifier:(NSString *)identifier tableView:(UITableView *)tableView{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView.backgroundColor = COLOR_HEX(0xF0EFF0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

+ (CGFloat)getCellHeight{
    return 44;
}

+ (CGFloat)getCellHeightWithModel:(id)model{
    return 44;
}

+ (NSString *)getCellIdentifier{
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"CellID"];
    return identifier;
}

- (void)setupUI{
    // implementation in sub class
}

- (void)refreshUIWithModel:(id)model{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
