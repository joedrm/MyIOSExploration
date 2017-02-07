//
//  UINavigationItem+Addition.m
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//

#import "UINavigationItem+Addition.h"

@implementation UINavigationItem (Addition)
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        // 此处修改到边界的距离
        negativeSeperator.width = -10;
        
        if (_leftBarButtonItem) {
            [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
        } else {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
    }
}

#endif
@end
