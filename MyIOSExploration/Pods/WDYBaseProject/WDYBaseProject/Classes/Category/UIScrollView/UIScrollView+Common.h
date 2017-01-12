//
//  UIScrollView+Common.h
//  Pods
//
//  Created by fang wang on 16/12/29.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Common)
- (BOOL)isReachTop;
- (BOOL)isReachBottom;
// 滚到底部
- (void)scrollToBottom:(BOOL)animated;
@end
