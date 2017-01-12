//
//  UIScrollView+Common.m
//  Pods
//
//  Created by fang wang on 16/12/29.
//
//

#import "UIScrollView+Common.h"

@implementation UIScrollView (Common)

- (BOOL)isReachTop
{
    return self.contentOffset.y <= 0;
}

- (BOOL)isReachBottom
{
    return self.contentOffset.y >= (self.contentSize.height - self.bounds.size.height);
}

- (void)scrollToBottom:(BOOL)animated
{
    if (self.contentSize.height <= self.bounds.size.height)
    {
        return;
    }
    
    [self setContentOffset:CGPointMake(self.contentOffset.x, (self.contentSize.height - self.bounds.size.height)) animated:animated];
}

@end
