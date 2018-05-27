//
//  CollectionMainViewController.m
//  UICollectionView深入理解和实践
//
//  Created by fang wang on 17/2/27.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CollectionMainViewController.h"

@interface CollectionMainViewController ()

@end

@implementation CollectionMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"UICollectionView深入理解和实践";
    self.titleArr = @[
                      @"case1：自定义分页"
                      ];
    
    self.vcArr = @[
                   @"CustomPageVC"
                   
                   ];
}



@end


/*
 参考资料：
 https://github.com/Instagram/IGListKit  近期关注度比较高的UICollectionView框架
 
 http://www.jianshu.com/p/d75a9a8d13b5
 
 https://github.com/KelvinJin/AnimatedCollectionViewLayout   CollectionView切换动画
 
 https://github.com/Tidusww/WWCollectionWaterfallLayout  UICollectionView 实现瀑布流布局
 
 https://github.com/BestJoker/FJSPicMixCollectionViewLayout  模仿IMDb和格瓦拉的图片集混合排布展示效果.2.普通瀑布流waterFlow3.跨列混合瀑布流waterFlow4.中间图片放大
 */
