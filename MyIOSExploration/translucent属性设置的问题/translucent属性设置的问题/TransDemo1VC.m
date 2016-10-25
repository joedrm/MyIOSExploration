//
//  TransDemo1VC.m
//  translucent属性设置的问题
//
//  Created by wdy on 2016/10/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "TransDemo1VC.h"

@interface TransDemo1VC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TransDemo1VC

static NSString* identi = @"TransDemo1VC";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     
     // automaticallyAdjustsScrollViewInsets和translucnet默认为Yes
     self.automaticallyAdjustsScrollViewInsets = Yes;
     self.navigationController.navigationBar.translucent = YES
     */
    
    //对于非滚动视图，我想让它从（0，0）布局，但是又正常显示,方法是从（0，0）开始布局，self.edgesForExtendedLayout = UIRectEdgeNone
    //此属性是iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方。
    //但是这局代码好像同时把self.automaticallyAdjustsScrollViewInsets = YES;这句代码的事也做了，因为滚动视图没有再留下位置
    //UIViewController的y值 == 导航栏y + 导航栏height
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


@end
