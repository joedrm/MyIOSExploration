//
//  ViewController.m
//  多控制器切换(容器类控制器)
//
//  Created by fang wang on 16/12/29.
//  Copyright © 2016年 wdy. All rights reserved.
//

// 参考资料
/*
    https://github.com/daria-kopaliani/DAPagesContainer
    https://github.com/daria-kopaliani/DARecycledScrollView
    https://github.com/daria-kopaliani/DAPageControlView
 */


#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()
@property(nonatomic,strong)TestViewController *VC1;
@property(nonatomic,strong)TestViewController *VC2;
@property(nonatomic,strong)TestViewController *VC3;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) UIScrollView *headScrollView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.title = @"视图切换";
    [self setUpUI];
    
    // Do any additional setup after loading the view.
}
-(void)setUpUI{
    
    
    //向导航栏集合中添加横向按钮列表
    NSArray *buttons = [NSArray arrayWithObjects:@"已下单", @"已支付",@"已完成",nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:buttons];
    
    // 属性
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    segmentedControl.frame =CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 44);
    
    segmentedControl.tintColor = [UIColor blueColor];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
    //添加按钮响应事件
    [segmentedControl addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 64)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    [self addSubControllers];
    
}

#pragma mark - privatemethods
- (void)addSubControllers{
    _VC1 = [[TestViewController alloc]init];
    _VC1.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:_VC1];
    
    _VC2 = [[TestViewController alloc]init];
    _VC2.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:_VC2];
    
    _VC3 = [[TestViewController alloc]init];
    _VC3.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:_VC3];
    
    //调整子视图控制器的Frame已适应容器View
    [self fitFrameForChildViewController:_VC1];
    //设置默认显示在容器View的内容
    [self.contentView addSubview:_VC1.view];
    
    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
    NSLog(@"%@",NSStringFromCGRect(_VC1.view.frame));
    
    _currentVC = _VC1;
    
    
    
}


-(void)buttonAction:(id)sender{
    
    switch([sender selectedSegmentIndex])
    {
        case 0:
            [self fitFrameForChildViewController:_VC1];
            [self transitionFromOldViewController:_currentVC toNewViewController:_VC1];
            break;
        case 1:
            [self fitFrameForChildViewController:_VC2];
            [self transitionFromOldViewController:_currentVC toNewViewController:_VC2];
            break;
        case 2:
            [self fitFrameForChildViewController:_VC3];
            [self transitionFromOldViewController:_currentVC toNewViewController:_VC3];
            break;
        default:
            NSLog(@"ccc");
            break;
    }
}

///转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
}

//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}
- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
}

@end












