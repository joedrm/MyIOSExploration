//
//  HeaderEffectVC1.m
//  UITableViewHeader各种效果
//
//  Created by wangdongyang on 16/9/6.
//  Copyright © 2016年 wdy. All rights reserved.
//


#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeigh            [UIScreen mainScreen].bounds.size.heigh
#define kImageHeigh             200 //图片的高度
#define kImageContainerHeigh    150 //图片容器的高度

#import "HeaderEffectVC1.h"

@interface HeaderEffectVC1 () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView* myTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (strong, nonatomic) UIView *imageContainerView;
@property (strong, nonatomic) UIImageView *topImageView;
@end

static NSString *EffIdentifier = @"identifier";

@implementation HeaderEffectVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EffIdentifier];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    
    
    self.imageContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    self.topImageView = [[UIImageView alloc] initWithFrame:self.imageContainerView.bounds];
    self.topImageView.image = [UIImage imageNamed:@"bg6.jpg"];
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.clipsToBounds = YES;
    [self.imageContainerView addSubview:self.topImageView];
    
    //设置内容偏移量,设置完成之后,不要忘了,这时候tableView的初始offset就不是0了,而是-kImageContainerHeigh
    self.myTableView.contentInset = UIEdgeInsetsMake(kImageContainerHeigh, 0, 0, 0);
    //将它放置在tableView下面,保证上滑的时候盖住
    [self.myTableView insertSubview:self.imageContainerView atIndex:0];
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
    CGFloat delta = kImageContainerHeigh + offset_Y;    //相对偏移量
    
    //向上拖动(offset变为正值之前)
    if (-offset_Y < kImageContainerHeigh && offset_Y < 0) {
        CGRect frame = self.topImageView.frame;
        frame.origin.y = offset_Y;
        frame.size.height = -offset_Y;
        
        
        self.topImageView.frame = frame;
        
    } else if (offset_Y < 0) {
        //向下拖动
        CGRect frame = self.topImageView.frame;
        frame.size.width = kScreenWidth - (delta)/2;
        frame.size.height = -offset_Y;
        frame.origin.y = offset_Y;
        frame.origin.x = delta / 4;
        self.topImageView.frame = frame;
    }
    
}


@end
