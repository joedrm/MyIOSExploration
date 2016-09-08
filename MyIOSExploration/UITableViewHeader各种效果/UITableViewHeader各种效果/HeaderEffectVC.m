//
//  HeaderEffectVC.m
//  UITableViewHeader各种效果
//
//  Created by wangdongyang on 16/9/6.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "HeaderEffectVC.h"
#import "Masonry.h"
#import "WDYHeaderView.h"
#import "HMSegmentedControl.h"
#import "UIView+Toast.h"

static CGFloat TopViewHeight = 200;
static CGFloat MiddleViewHeight = 44;
static CGFloat TotalHeaderHeight(){
    return TopViewHeight + MiddleViewHeight;
}

static CGFloat SCREEN_HEIGHT(){
    return [UIScreen mainScreen].bounds.size.height;
}


@interface HeaderEffectVC ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) WDYHeaderView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *middleView;
@property (strong, nonatomic) MASConstraint *headerHeight;
@end


static NSString *EffIdentifier1 = @"HeaderEffectVC2";

@implementation HeaderEffectVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    self.navigationBar.alpha = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
//    self.myTableView.separatorColor = [UIColor clearColor];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EffIdentifier1];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.contentInset = UIEdgeInsetsMake(TotalHeaderHeight(), 0, 0, 0);
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.headerView = [WDYHeaderView headerView];
    [self.myTableView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(TopViewHeight);
    }];
    
    self.middleView = [[UIView alloc] initWithFrame:CGRectZero];
    self.middleView.backgroundColor = [UIColor redColor];
    [self.myTableView addSubview:self.middleView];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(MiddleViewHeight);
    }];
    
    
    HMSegmentedControl *segCtrl = [[HMSegmentedControl alloc] initWithFrame:CGRectZero];
    segCtrl.backgroundColor = [UIColor lightGrayColor];
    segCtrl.sectionTitles = @[@"首页", @"微博", @"消息"];
    segCtrl.selectionIndicatorHeight = 2.0f;
    segCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segCtrl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segCtrl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:15]};
    segCtrl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    segCtrl.selectionIndicatorColor = [UIColor blueColor];
    segCtrl.selectedSegmentIndex = 0;
    [segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.middleView addSubview:segCtrl];
    [segCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.middleView);
    }];
    
    //这句话要加上,因为我在xib拖上去的HeaderView是和TableView并列关系,所以这里把它加到tableView并且处在下层,
    //否则会出现遮挡的bug,可以注掉这行代码试一下
    [self.myTableView insertSubview:self.headerView atIndex:0];
    
    [self.view makeToast:@"加载中"];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    
    
}


#pragma mark - TableView dataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:EffIdentifier1];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld 行", indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",self.myTableView.contentOffset.y);
    CGFloat offset_Y = self.myTableView.contentOffset.y;
    CGFloat delta = offset_Y + TotalHeaderHeight();
    
    
    //向上滑动
    CGFloat heigh = TopViewHeight-delta;
    //当减小到64,到导航栏的位置,就不再减少了
    if (heigh<64) {
        heigh = 64;
    }
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(heigh);
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(MiddleViewHeight);
    }];
    [self loadViewIfNeeded];
    
    CGFloat alpha = delta/(TopViewHeight-64);
    NSLog(@"offset_Y = %f,  delta = %f,  alpha = %f, %f",self.myTableView.contentOffset.y, delta, alpha, (TopViewHeight-64));
    if (alpha>=1) {
        alpha = 0.99;
    }
    // 设置导航条的背景图片
    self.navigationBar.alpha = alpha;
    
}


@end
