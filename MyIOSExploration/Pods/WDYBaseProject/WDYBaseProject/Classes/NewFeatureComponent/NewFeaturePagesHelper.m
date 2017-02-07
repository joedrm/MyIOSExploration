//
//  NewFeaturePagesHelper.m
//  Pods
//
//  Created by fang wang on 17/1/9.
//
//

#import "NewFeaturePagesHelper.h"
#import "NewFeaturePagesView.h"

@interface NewFeaturePagesHelper ()

@property (nonatomic) UIWindow *rootWindow;
@property(nonatomic,strong)NewFeaturePagesView *curNewFeaturePagesView;
@end

@implementation NewFeaturePagesHelper

+ (instancetype)shareInstance
{
    static NewFeaturePagesHelper *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[NewFeaturePagesHelper alloc] init];
    });
    
    return shareInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+(void)showIntroductoryPageView:(NSArray *)imageArray
{
    if (![NewFeaturePagesHelper shareInstance].curNewFeaturePagesView) {
        [NewFeaturePagesHelper shareInstance].curNewFeaturePagesView = [[NewFeaturePagesView alloc] initPagesViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) Images:imageArray];
    }
    
    [NewFeaturePagesHelper shareInstance].rootWindow = [UIApplication sharedApplication].keyWindow;
    [[NewFeaturePagesHelper shareInstance].rootWindow addSubview:[NewFeaturePagesHelper shareInstance].curNewFeaturePagesView];
}


@end
