//
//  TransitionViewController.m
//  关于导航条的处理
//
//  Created by fang wang on 17/1/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "TransitionViewController.h"
#import "TransitionDetailVC.h"

@interface TransitionViewController ()<UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end


static NSString * const reuseIdentifier = @"Cell";

@implementation TransitionViewController

- (instancetype)init{

    if (self = [self initWithCollectionViewLayout:self.flowLayout]) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UICollectionViewFlowLayout *)flowLayout{
    
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(60, 60);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TransitionDetailVC* detailVC = [[TransitionDetailVC alloc] init];
    self.navigationController.delegate = self;
    [self.rt_navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - UINavigationController Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
        return self;
    return nil;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return UINavigationControllerHideShowBarDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    RTContainerController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    RTContainerController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [containerView addSubview:toVC.view];
    
    // following is required!
    [containerView setNeedsLayout];
    [containerView layoutIfNeeded];
    
    toVC.view.alpha = 0.f;
    
    NSIndexPath *selected = ((TransitionViewController *)fromVC.contentViewController).collectionView.indexPathsForSelectedItems.firstObject;
    UICollectionViewCell *cell = [((TransitionViewController *)fromVC.contentViewController).collectionView cellForItemAtIndexPath:selected];
    CGRect frame = [toVC.contentViewController.view convertRect:cell.frame
                                                       fromView:cell.superview];
    CGRect finalFrame = ((TransitionDetailVC *)toVC.contentViewController).itemImageView.frame;
    ((TransitionDetailVC *)toVC.contentViewController).itemImageView.frame = frame;
    [UIView transitionWithView:containerView
                      duration:[self transitionDuration:transitionContext]
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        toVC.view.alpha = 1.f;
                        ((TransitionDetailVC *)toVC.contentViewController).itemImageView.frame = finalFrame;
                    }
                    completion:^(BOOL finished) {
                        if (finished) {
                            [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view removeFromSuperview];
                        }
                        [transitionContext completeTransition:finished];
                    }];
}


@end
