//
//  UIView+Animation.m
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//

#import "UIView+Animation.h"


const NSTimeInterval UIAViewAnimationDefaultDuraton = 0.2;

@implementation UIView (Animation)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated {
    if (!animated || self.hidden == hidden) {
        self.hidden = hidden;
        return;
    }
    
    CGFloat backupAlpha = self.alpha;
    CGFloat endAlpha;
    
    if (hidden) {
        endAlpha = .0;
    } else {
        self.alpha = .0;
        endAlpha = backupAlpha;
        self.hidden = NO;
    }
    
    [[self class] animateWithDuration:UIAViewAnimationDefaultDuraton animations:^(void) {
        self.alpha = endAlpha;
    } completion:^(BOOL finished) {
        if (hidden) {
            self.alpha = backupAlpha;
            self.hidden = YES; // value compatibility - this delayed action may be cause of unknown strange behavior.
        }
    }];
}


@end
