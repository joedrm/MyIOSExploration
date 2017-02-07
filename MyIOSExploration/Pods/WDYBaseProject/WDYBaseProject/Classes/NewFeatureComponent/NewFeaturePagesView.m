//
//  NewFeaturePagesView.m
//  Pods
//
//  Created by fang wang on 17/1/9.
//
//

#import "NewFeaturePagesView.h"

@interface NewFeaturePagesView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *bigScrollView;
@property(nonatomic)NSArray *imageArray;
@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation NewFeaturePagesView

-(instancetype)initPagesViewWithFrame:(CGRect)frame Images:(NSArray *)images
{
    if (self = [super initWithFrame:frame]) {
        self.imageArray=images;
        [self loadPageView];
    }
    return self;
}

-(void)loadPageView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    scrollView.contentSize = CGSizeMake((_imageArray.count + 1)*kScreenWidth, kScreenHeight);
    //设置反野效果，不允许反弹，不显示水平滑动条，设置代理为自己
    scrollView.pagingEnabled = YES;//设置分页
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _bigScrollView = scrollView;
    
    for (int i = 0; i < _imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight);
        UIImage *image = [UIImage imageNamed:_imageArray[i]];
        imageView.image = image;
        
        [scrollView addSubview:imageView];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight - 60, 0, 40)];
    pageControl.numberOfPages = _imageArray.count;
    pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:pageControl];
    
    _pageControl = pageControl;
    
    //添加手势
    UITapGestureRecognizer *singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleRecognizer];
}

-(void)handleSingleTapFrom
{
    if (_pageControl.currentPage == self.imageArray.count-1) {
        [self removeFromSuperview];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bigScrollView) {
        CGPoint offSet = scrollView.contentOffset;
        _pageControl.currentPage = offSet.x/(self.bounds.size.width);//计算当前的页码
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width * (_pageControl.currentPage), scrollView.contentOffset.y) animated:YES];
    }
    if (scrollView.contentOffset.x == (_imageArray.count) *kScreenWidth) {
        [self removeFromSuperview];
    }
}

@end
