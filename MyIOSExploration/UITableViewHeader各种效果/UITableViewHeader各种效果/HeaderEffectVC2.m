//
//  HeaderEffectVC1.m
//  UITableViewHeader各种效果
//
//  Created by wangdongyang on 16/9/6.
//  Copyright © 2016年 wdy. All rights reserved.
//


#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeigh            [UIScreen mainScreen].bounds.size.heigh

#define kImageContainerHeigh    150
#define kMiddleBarHeigh         40
#define kTotalHeigh             kImageContainerHeigh+kMiddleBarHeigh

#import "HeaderEffectVC2.h"

@interface HeaderEffectVC2 () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView* myTableView;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) UIView *middleView;
@property (weak, nonatomic) NSLayoutConstraint *headerHeigh;
@property (weak, nonatomic) NSLayoutConstraint *weiboLeft;
@property (weak, nonatomic) NSLayoutConstraint *zhuyeLeft;
@end

static NSString *EffIdentifier = @"HeaderEffectVC2";

@implementation HeaderEffectVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.weiboLeft.constant = (kScreenWidth-(200+120))/2;
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EffIdentifier];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.contentInset = UIEdgeInsetsMake(kTotalHeigh, 0, 0, 0);
    [self.view addSubview:self.myTableView];
    
    
//    self.headerView = [[UIView alloc] init];
//    UIImageView* bgIm = [[UIImageView alloc] initWithFrame:self.headerView.bounds];
//    bgIm.image = [UIImage imageNamed:@"bg6.jpg"];
//    [self.headerView addSubview:bgIm];
//    [self.view addSubview:self.headerView];
//    
//    self.middleView = [[UIView alloc] init];
//    self.middleView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.middleView];
    
    //这句话要加上,因为我在xib拖上去的HeaderView是和TableView并列关系,所以这里把它加到tableView并且处在下层,
    // 否则会出现遮挡的bug,可以注掉这行代码试一下
    [self.myTableView insertSubview:self.headerView atIndex:0];
    
}

#pragma mark - TableView dataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:EffIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld 行", indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",self.myTableView.contentOffset.y);
    CGFloat offset_Y = self.myTableView.contentOffset.y;
    CGFloat delta = offset_Y + kTotalHeigh;
    
    //向上滑动
    CGFloat heigh = kImageContainerHeigh-delta;
    //当减小到64,到导航栏的位置,就不再减少了
    if (heigh<64) {
        heigh = 64;
    }
    self.headerHeigh.constant = heigh;
    
    CGFloat alpha = delta/(kImageContainerHeigh-64);
    if (alpha>=1) {
        alpha = 0.99;
    }
    
    self.navigationBar.alpha = alpha;
}



@end
