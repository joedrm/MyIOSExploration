//
//  UIViewController+NaviExtentions.m
//  Pods
//
//  Created by fang wang on 16/12/29.
//
//

#import "UIViewController+NaviExtentions.h"

#ifndef kIOSVersion
#define kIOSVersion ((float)[[[UIDevice currentDevice] systemVersion] doubleValue])
#endif

static UIColor *sg_navButtonTextColor;
static UIColor *sg_navButtonBackgroundColor;
static UIFont  *sg_navButtonFont;
static UIColor *sg_navButtonBorderColor;
static CGFloat sg_navButtonCornerRadius;


@implementation UIViewController (NaviExtentions)


+ (void)initialize {
    [super initialize];
    
    if (!sg_navButtonFont) {
        sg_navButtonFont = [UIFont systemFontOfSize:16];
    }
    
    if (!sg_navButtonBackgroundColor) {
        sg_navButtonBackgroundColor = [UIColor clearColor];
    }
    
    if (!sg_navButtonTextColor) {
        sg_navButtonTextColor = [UIColor blackColor];
    }
}

#pragma mark - 全局配置导航按钮样式
+ (void)navButtonStyleWithTextColor:(UIColor *)textColor
                        backgroundColor:(UIColor *)backgroundColor
                                   font:(UIFont *)font
                            borderColor:(UIColor *)borderColor
                           cornerRadius:(CGFloat)cornerRadius {
    sg_navButtonTextColor = textColor;
    sg_navButtonBackgroundColor = backgroundColor;
    sg_navButtonFont = font;
    sg_navButtonBorderColor = borderColor;
    sg_navButtonCornerRadius = cornerRadius;
}


#pragma mark - UINavigationBar全局配置
- (void)configNavBarWithBackImage:(id)backImage
                          shadowImage:(id)shadowImage
                            tintColor:(UIColor *)tintColor
                         barTintColor:(UIColor *)barTintColor
                           titleColor:(UIColor *)titleColor
                            titleFont:(UIFont *)titleFont
                        hideBackTitle:(BOOL)hideBackTitle {
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)self;
        UINavigationBar *navBar = navController.navigationBar;
        
        NSDictionary *textAttributes = nil;
        if (kIOSVersion >= 7.0) {
            if (barTintColor) {
                [navBar setTintColor:barTintColor];//返回按钮的箭头颜色
            }
            
            textAttributes = @{NSFontAttributeName: titleFont,
                               NSForegroundColorAttributeName: titleColor};
            if (tintColor) {
                [navBar setBarTintColor:barTintColor];
            }
            
            if (backImage) {
                UIImage *image = nil;
                if ([backImage isKindOfClass:[NSString class]]) {
                    image = [UIImage imageNamed:backImage];
                } else {
                    image = backImage;
                }
                
                CGFloat w = image.size.width;
                if ([UIScreen mainScreen].bounds.size.width <= 320) {
                    w = 30;
                }
                UIImage *backButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                                  forState:UIControlStateNormal
                                                                barMetrics:UIBarMetricsDefault];
                navBar.backIndicatorImage = image;
                
                [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                                  forState:UIControlStateNormal
                                                                barMetrics:UIBarMetricsDefault];
                // 将返回标题设置为很小，否则当上一个界面的标题很长时，会出现下一个界面的标题不居中显示的问题
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:0.5]};
                [[UIBarButtonItem appearance] setTitleTextAttributes:attributes
                                                            forState:UIControlStateNormal];
            }
            
            // 将返回按钮的文字position设置不在屏幕上显示
            if (hideBackTitle) {
                [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                                                     forBarMetrics:UIBarMetricsDefault];
            }
            
            navController.interactivePopGestureRecognizer.enabled = YES;
        } else {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            textAttributes = @{
                               UITextAttributeFont: titleFont,
                               UITextAttributeTextColor: titleColor,
                               UITextAttributeTextShadowColor: [UIColor clearColor],
                               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                               };
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
            if (backImage) {
                UIImage *image = nil;
                if ([backImage isKindOfClass:[NSString class]]) {
                    image = [UIImage imageNamed:backImage];
                } else {
                    image = backImage;
                }
                
                UIImage *backButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
                [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                                  forState:UIControlStateNormal
                                                                barMetrics:UIBarMetricsDefault];
            }
            
            if (hideBackTitle) {
                [item setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
            }
            
            self.navigationItem.backBarButtonItem = item;
#endif
#pragma clang diagnostic pop
        }
        
        [navBar setTitleTextAttributes:textAttributes];
        if (shadowImage) {
            if ([shadowImage isKindOfClass:[NSString class]]) {
                navBar.shadowImage = [UIImage imageNamed:shadowImage];
            } else {
                navBar.shadowImage = shadowImage;
            }
        } else {
            navBar.shadowImage = [UIImage new];
        }
    }
}


#pragma mark - UITabBarItem
- (void)setTabBarItemWithTitle:(NSString *)title
                     selectedImage:(id)selectedImage
                   unSelectedImage:(id)unSelectedImage
                 selectedTextColor:(UIColor *)selectedTextColor
               unSelectedTextColor:(UIColor *)unSelectedTextColor {
    [self setTabBarItemWithTitle:title
                       selectedImage:selectedImage
                     unSelectedImage:unSelectedImage
                   selectedTextColor:selectedTextColor
                 unSelectedTextColor:unSelectedTextColor
                        selectedFont:nil
                      unSelectedFont:nil];
}

- (void)setTabBarItemWithTitle:(NSString *)title
                     selectedImage:(id)selectedImage
                   unSelectedImage:(id)unSelectedImage
                         imageMode:(UIImageRenderingMode)imageMode
                 selectedTextColor:(UIColor *)selectedTextColor
               unSelectedTextColor:(UIColor *)unSelectedTextColor {
    [self setTabBarItemWithTitle:title
                       selectedImage:selectedImage
                     unSelectedImage:unSelectedImage
                           imageMode:imageMode
                   selectedTextColor:selectedTextColor
                 unSelectedTextColor:unSelectedTextColor
                        selectedFont:nil
                      unSelectedFont:nil];
}


- (void)setTabBarItemWithTitle:(NSString *)title
                     selectedImage:(id)selectedImage
                   unSelectedImage:(id)unSelectedImage
                 selectedTextColor:(UIColor *)selectedTextColor
               unSelectedTextColor:(UIColor *)unSelectedTextColor
                      selectedFont:(UIFont *)selectedFont
                    unSelectedFont:(UIFont *)unSelectedFont {
    [self setTabBarItemWithTitle:title
                       selectedImage:selectedImage
                     unSelectedImage:unSelectedImage
                           imageMode:UIImageRenderingModeAlwaysOriginal
                   selectedTextColor:selectedTextColor
                 unSelectedTextColor:unSelectedTextColor
                        selectedFont:selectedFont
                      unSelectedFont:unSelectedFont];
}

- (void)setTabBarItemWithTitle:(NSString *)title
                     selectedImage:(id)selectedImage
                   unSelectedImage:(id)unSelectedImage
                         imageMode:(UIImageRenderingMode)imageMode
                 selectedTextColor:(UIColor *)selectedTextColor
               unSelectedTextColor:(UIColor *)unSelectedTextColor
                      selectedFont:(UIFont *)selectedFont
                    unSelectedFont:(UIFont *)unSelectedFont {
    UITabBarItem *item = [[UITabBarItem alloc] init];
    item.title = title;
    
    UIImage *normalImg = nil;
    if (unSelectedImage != nil) {
        if ([unSelectedImage isKindOfClass:[NSString class]]) {
            normalImg = [UIImage imageNamed:unSelectedImage];
        } else {
            normalImg = unSelectedImage;
        }
    }
    
    UIImage *selectedImg = nil;
    if (selectedImage != nil) {
        if ([selectedImage isKindOfClass:[NSString class]]) {
            selectedImg = [UIImage imageNamed:selectedImage];
        } else {
            selectedImg = selectedImage;
        }
    }
    
    if (kIOSVersion >= 7) {
        if (selectedImg) {
            item.selectedImage = [selectedImg imageWithRenderingMode:imageMode];
        }
        
        if (normalImg) {
            item.image = [normalImg imageWithRenderingMode:imageMode];
        }
        
        NSMutableDictionary *titleSelectedAttributes = [[NSMutableDictionary alloc] init];
        if (selectedTextColor) {
            [titleSelectedAttributes setObject:selectedTextColor forKey:NSForegroundColorAttributeName];
        }
        if (selectedFont) {
            [titleSelectedAttributes setObject:selectedFont forKey:NSFontAttributeName];
        }
        
        NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc] init];
        if (unSelectedTextColor) {
            [titleAttributes setObject:unSelectedTextColor forKey:NSForegroundColorAttributeName];
        }
        if (unSelectedFont) {
            [titleAttributes setObject:unSelectedFont forKey:NSFontAttributeName];
        }
        
        if (titleSelectedAttributes) {
            [item setTitleTextAttributes:titleSelectedAttributes forState:UIControlStateSelected];
        }
        
        if (titleAttributes) {
            [item setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
        }
    } else { // 6.0
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [item setFinishedSelectedImage:selectedImg
           withFinishedUnselectedImage:normalImg];

        NSMutableDictionary *titleSelectedAttributes = [[NSMutableDictionary alloc] init];
        if (selectedTextColor) {
            [titleSelectedAttributes setObject:selectedTextColor forKey:UITextAttributeTextColor];
        }
        if (selectedFont) {
            [titleSelectedAttributes setObject:selectedFont forKey:UITextAttributeFont];
        }
        
        NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc] init];
        if (unSelectedTextColor) {
            [titleAttributes setObject:unSelectedTextColor forKey:UITextAttributeTextColor];
        }
        if (unSelectedFont) {
            [titleAttributes setObject:unSelectedFont forKey:NSFontAttributeName];
        }
        
        if (titleSelectedAttributes) {
            [item setTitleTextAttributes:titleSelectedAttributes forState:UIControlStateSelected];
        }
        
        if (titleAttributes) {
            [item setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
        }
    }
#pragma clang diagnostic pop
    
    self.tabBarItem = item;
}


#pragma mark - UINavigationBar or UINavigationItem
- (void)navWithTitle:(id)title {
    [self navWithTitle:title rightImage:nil rightClicked:nil];
}

- (void)navWithTitle:(id)title rightTitle:(id)rightTitle rightClicked:(ButtonClickedBlock)rightBlock {
    if (rightTitle) {
        [self navWithTitle:title rightTitles:@[rightTitle] rightClicked:^(NSUInteger atIndex, UIButton *sender) {
            if (rightBlock) {
                rightBlock(sender);
            }
        }];
    } else {
        [self navWithTitle:title rightTitles:nil rightClicked:nil];
    }
}

- (void)navWithTitle:(id)title rightTitles:(NSArray *)rightTitles rightClicked:(ButtonArrayBlock)rightBlock {
    [self navWithLeftImage:nil title:title rightTitles:rightTitles leftClicked:nil rightClicked:rightBlock];
}

- (void)navWithLeftImage:(id)leftImage
                       title:(id)title
                 rightTitles:(id)rightTitles
                 leftClicked:(ButtonClickedBlock)leftClicked
                rightClicked:(ButtonArrayBlock)rightClicked {
    [self privateConfigTitleView:title];
    [self privateConfigLeftItem:leftImage isImage:YES leftBlock:leftClicked];
    [self privateConfigRightItems:rightTitles isImage:NO rightClicked:rightClicked];
}

- (void)navWithLeftTitle:(id)leftTitle
                       title:(id)title
                 rightTitles:(NSArray *)rightTitles
                 leftClicked:(ButtonClickedBlock)leftClicked
                rightClicked:(ButtonArrayBlock)rightClicked {
    [self privateConfigTitleView:title];
    [self privateConfigLeftItem:leftTitle isImage:NO leftBlock:leftClicked];
    [self privateConfigRightItems:rightTitles isImage:NO rightClicked:rightClicked];
}


- (void)navWithLeftTitle:(id)leftTitle
                       title:(id)title
                 rightImages:(id)rightImages
                 leftClicked:(ButtonClickedBlock)leftClicked
                rightClicked:(ButtonArrayBlock)rightClicked {
    [self privateConfigTitleView:title];
    [self privateConfigLeftItem:leftTitle isImage:NO leftBlock:leftClicked];
    [self privateConfigRightItems:rightImages isImage:YES rightClicked:rightClicked];
}

- (void)navWithLeftImage:(id)leftImage
                       title:(id)title
                 rightImages:(NSArray *)rightImages
                 leftClicked:(ButtonClickedBlock)leftClicked
                rightClicked:(ButtonArrayBlock)rightClicked {
    [self privateConfigTitleView:title];
    [self privateConfigLeftItem:leftImage isImage:YES leftBlock:leftClicked];
    [self privateConfigRightItems:rightImages isImage:YES rightClicked:rightClicked];
}

- (void)navWithTitle:(id)title rightImage:(id)rightImage rightClicked:(ButtonClickedBlock)rightBlock {
    if (rightImage) {
        [self navWithLeftTitle:nil title:title rightImages:@[rightImage] leftClicked:nil rightClicked:^(NSUInteger atIndex, UIButton *sender) {
            if (rightBlock) {
                rightBlock(sender);
            }
        }];
    } else {
        [self navWithLeftTitle:nil title:title rightTitles:nil leftClicked:nil rightClicked:nil];
    }
}

- (void)navWithTitle:(id)title rightImages:(NSArray *)rightImages rightClicked:(ButtonArrayBlock)rightBlock {
    [self navWithLeftTitle:nil title:title rightImages:rightImages leftClicked:nil rightClicked:rightBlock];
}

- (void)navWithLeftTitle:(id)leftTitle title:(id)title leftClicked:(ButtonClickedBlock)leftClicked {
    [self navWithLeftTitle:leftTitle title:title rightTitle:nil leftClicked:leftClicked rightClicked:nil];
}

- (void)navWithLeftImage:(id)leftImage title:(id)title leftClicked:(ButtonClickedBlock)leftClicked {
    [self navWithLeftImage:leftImage title:title rightTitles:nil leftClicked:leftClicked rightClicked:nil];
}

- (void)navWithLeftTitle:(id)leftTitle
                       title:(id)title
                  rightTitle:(id)rightTitle
                 leftClicked:(ButtonClickedBlock)leftClicked
                rightClicked:(ButtonClickedBlock)rightClicked {
    NSArray *rightTitles = nil;
    if (rightTitle) {
        rightTitles = @[rightTitle];
    }
    
    [self navWithLeftTitle:leftTitle title:title rightTitles:rightTitles leftClicked:leftClicked rightClicked:^(NSUInteger atIndex, UIButton *sender) {
        if (rightClicked) {
            rightClicked(sender);
        }
    }];
}

- (void)navWithLeftImage:(id)leftImage
                       title:(id)title
                  rightTitle:(id)rightTitle
                 leftClicked:(ButtonClickedBlock)leftClicked
                rightClicked:(ButtonClickedBlock)rightClicked {
    NSArray *rightTitles = nil;
    if (rightTitle) {
        rightTitles = @[rightTitle];
    }
    
    [self navWithLeftImage:leftImage title:title rightTitles:rightTitles leftClicked:leftClicked rightClicked:^(NSUInteger atIndex, UIButton *sender) {
        if (rightClicked) {
            rightClicked(sender);
        }
    }];
}

- (void)navWithLeftTitle:(id)leftTitle
                       title:(id)title
                  rightImage:(id)rightImage
                 leftClicked:(ButtonClickedBlock)leftClicked
                rightClicked:(ButtonClickedBlock)rightClicked {
    NSArray *rightImages = nil;
    if (rightImage) {
        rightImages = @[rightImage];
    }
    
    [self navWithLeftTitle:leftTitle title:title rightImages:rightImages leftClicked:leftClicked rightClicked:^(NSUInteger atIndex, UIButton *sender) {
        if (rightClicked) {
            rightClicked(sender);
        }
    }];
}

- (void)navWithLeftImage:(id)leftImage
                       title:(id)title
                  rightImage:(id)rightImage
                 leftClicked:(ButtonClickedBlock)leftClicked
                rightClicked:(ButtonClickedBlock)rightClicked {
    NSArray *rightImages = nil;
    if (rightImage) {
        rightImages = @[rightImage];
    }
    
    [self navWithLeftImage:leftImage title:title rightImages:rightImages leftClicked:leftClicked rightClicked:^(NSUInteger atIndex, UIButton *sender) {
        if (rightClicked) {
            rightClicked(sender);
        }
    }];
}

- (void)updateTitle:(id)title {
    [self privateConfigTitleView:title];
}

#pragma mark - Private
- (void)privateConfigTitleView:(id)title {
    if ([title isKindOfClass:[NSString class]]) {
        self.navigationItem.title = title;
    } else {
        self.navigationItem.titleView = title;
    }
}

- (void)privateConfigLeftItem:(id)leftItem isImage:(BOOL)isImage leftBlock:(ButtonClickedBlock)leftBlock {
    if (leftItem == nil) {
        return;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (isImage) {
        if ([leftItem isKindOfClass:[NSString class]]) {
            [btn setImage:[UIImage imageNamed:leftItem] forState:UIControlStateNormal];
        } else {
            [btn setImage:leftItem forState:UIControlStateNormal];
        }
    } else {
        [self privateConfigTitleButton:leftItem btn:btn];
    }
    
    btn.touchUp = leftBlock;
    
    [self privateSetNavItems:@[btn] isLeft:YES];
}

- (void)privateSetNavItems:(NSArray *)buttons isLeft:(BOOL)isLeft {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
    negativeSpacer.width = -8;
    if (kIOSVersion < 7) {
        negativeSpacer.width = 0;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:buttons.count];
    [items addObject:negativeSpacer];
    
    for (NSUInteger i = 0; i < buttons.count; ++i) {
        UIButton *btn = [buttons objectAtIndex:i];
        [btn sizeToFit];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)privateConfigRightItems:(NSArray *)rightItems
                        isImage:(BOOL)isImage
                   rightClicked:(ButtonArrayBlock)rightClicked {
    if ([rightItems isKindOfClass:[NSArray class]] && rightItems.count >= 1) {
        NSUInteger i = 0;
        NSMutableArray *rightItemButotns = [[NSMutableArray alloc] init];
        for (id item in rightItems) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (isImage) {
                if ([item isKindOfClass:[NSString class]]) {
                    [btn setImage:[UIImage imageNamed:item] forState:UIControlStateNormal];
                } else {
                    [btn setImage:item forState:UIControlStateNormal];
                }
            } else {
                [self privateConfigTitleButton:item btn:btn];
            }
            
            btn.touchUp = ^(UIButton *sender) {
                if (rightClicked) {
                    rightClicked(i, sender);
                }
            };
            
            [rightItemButotns addObject:btn];
            i++;
        }
        
        [self privateSetNavItems:rightItemButotns isLeft:NO];
    }
}

- (void)privateConfigTitleButton:(id)buttonTitle btn:(UIButton *)btn {
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    [btn setTitleColor:sg_navButtonTextColor forState:UIControlStateNormal];
    [btn setBackgroundColor:sg_navButtonBackgroundColor];
    btn.titleLabel.font = sg_navButtonFont;
}

@end
