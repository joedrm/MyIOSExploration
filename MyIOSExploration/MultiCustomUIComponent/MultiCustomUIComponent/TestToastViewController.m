//
//  TestToastViewController.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "TestToastViewController.h"
#import "Toast.h"

@interface TestToastViewController ()

@property(nonatomic, strong) NSArray<NSString *> *dataSource;
@end

@implementation TestToastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"Loading",
                        @"Loading With Text",
                        @"Tips For Succeed",
                        @"Tips For Error",
                        @"Tips For Info",
                        @"Custom TintColor",
                        @"Custom BackgroundView Style",
                        @"Custom Animator",
                        @"Custom Content View"];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIView *parentView = self.navigationController.view;
    NSString* title = self.dataSource [indexPath.row];
    if ([title isEqualToString:@"Loading"]) {
        TipsView *tips = [TipsView createTipsToView:parentView];
        ToastContentView *contentView = (ToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(90, 90);
        [tips showLoadingHideAfterDelay:2];
        
        // 如果不需要修改contentView的样式，也可以直接使用下面这个工具方法
        // [TipsView showLoadingInView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Loading With Text"]) {
        [TipsView showLoading:@"加载中..." inView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Tips For Succeed"]) {
        [TipsView showSucceed:@"加载成功" inView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Tips For Error"]) {
        [TipsView showError:@"加载失败，请检查网络情况" inView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Tips For Info"]) {
        [TipsView showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
        
    } else if ([title isEqualToString:@"Custom TintColor"]) {
        TipsView *tips = [TipsView showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
        tips.tintColor = [UIColor blueColor];
        
    } else if ([title isEqualToString:@"Custom BackgroundView Style"]) {
        TipsView *tips = [TipsView showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
        ToastBackgroundView *backgroundView = (ToastBackgroundView *)tips.backgroundView;
        backgroundView.shouldBlurBackgroundView = YES;
        backgroundView.styleColor = //UIColorMakeWithRGBA(232, 232, 232, 0.8);
        tips.tintColor = [UIColor blackColor];
        
    } else if ([title isEqualToString:@"Custom Content View"]) {
//        TipsView *tips = [TipsView createTipsToView:parentView];
//        tips.toastPosition = ToastViewPositionBottom;
//        QDCustomToastAnimator *customAnimator = [[QDCustomToastAnimator alloc] initWithToastView:tips];
//        tips.toastAnimator = customAnimator;
//        QDCustomToastContentView *customContentView = [[QDCustomToastContentView alloc] init];
//        [customContentView renderWithImage:UIImageMake(@"image0") text:@"什么是QMUIToastView" detailText:@"QMUIToastView用于临时显示某些信息，并且会在数秒后自动消失。这些信息通常是轻量级操作的成功信息。"];
//        tips.contentView = customContentView;
//        [tips showAnimated:YES];
//        [tips hideAnimated:YES afterDelay:4];
        
    } else if ([title isEqualToString:@"Custom Animator"]) {
//        TipsView *tips = [TipsView createTipsToView:parentView];
//        QDCustomToastAnimator *customAnimator = [[QDCustomToastAnimator alloc] initWithToastView:tips];
//        tips.toastAnimator = customAnimator;
//        [tips showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" hideAfterDelay:2];
        
    }

}

@end
