//
//  CustomPageVC.m
//  UICollectionView深入理解和实践
//
//  Created by wdy on 2018/5/27.
//  Copyright © 2018年 wdy. All rights reserved.
//

#import "CustomPageVC.h"

#define screenW     [UIScreen mainScreen].bounds.size.width
#define itemW       screenW - 20 - 34

@interface CustomPageVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation CustomPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemW, 200);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, screenW, 200) collectionViewLayout:layout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.view addSubview:_collectionView];
    
    _selectedIndex = 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat x = targetContentOffset->x;
    CGFloat pageWidth = itemW + 20;
    CGFloat movedX = x - pageWidth * _selectedIndex;
    if (movedX < -pageWidth * 0.5) {
        // Move left
        _selectedIndex--;
    } else if (movedX > pageWidth * 0.5) {
        // Move right
        _selectedIndex ++;
    }
    
    if (ABS(velocity.x) >= 2){
        targetContentOffset->x = pageWidth * _selectedIndex;
    } else {
        targetContentOffset->x = scrollView.contentOffset.x;
        [scrollView setContentOffset:CGPointMake(pageWidth * _selectedIndex, scrollView.contentOffset.y) animated:YES];
    }
    NSLog(@"%ld",_selectedIndex);
}

#pragma mark FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(itemW, 200);
}

@end









