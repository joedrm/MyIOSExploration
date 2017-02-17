//
//  VideoEffectTheme.h
//  LearningAVFoundation
//
//  Created by fang wang on 17/2/17.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoThemeModel.h"


typedef enum
{
    kAnimationNone = 0,
    kAnimationFireworks,
    kAnimationSnow,
    kAnimationSnow2,
    kAnimationHeart,
    kAnimationRing,
    kAnimationStar,
    kAnimationMoveDot,
    kAnimationSky,
    kAnimationMeteor,
    kAnimationRain,
    kAnimationFlower,
    kAnimationFire,
    kAnimationSmoke,
    kAnimationSpark,
    kAnimationSteam,
    kAnimationBirthday,
    kAnimationBlackWhiteDot,
    kAnimationScrollScreen,
    kAnimationSpotlight,
    kAnimationScrollLine,
    kAnimationRipple,
    kAnimationImage,
    kAnimationImageArray,
    kAnimationVideoFrame,
    kAnimationTextStar,
    kAnimationTextSparkle,
    kAnimationTextScroll,
    kAnimationTextGradient,
    kAnimationFlashScreen,
    kAnimationPhotoLinearScroll,
    KAnimationPhotoCentringShow,
    kAnimationPhotoDrop,
    kAnimationPhotoParabola,
    kAnimationPhotoFlare,
    kAnimationPhotoEmitter,
    kAnimationPhotoExplode,
    kAnimationPhotoExplodeDrop,
    kAnimationPhotoCloud,
    kAnimationPhotoSpin360,
    kAnimationPhotoCarousel,
    kAnimationVideoBorder,
    
} AnimationActionType;

// Themes
typedef enum
{
    // none
    kThemeNone = 0,
    
    kThemeCustom,
    
    // fruit
    kThemeFruit,
    
    // cartoon
    kThemeCartoon,
    
    // flare
    kThemeFlare,
    
    // starshine
    kThemeStarshine,
    
    // cubical
    kThemeScience,
    
    // leaf
    kThemeLeaf,
    
    // butterfly
    kThemeButterfly,
    
    // cloud
    kThemeCloud,
    
    // Custom
    //    kThemeCustom,
    
} ThemesType;

@interface VideoEffectTheme : NSObject

+ (VideoEffectTheme *) sharedInstance;

- (NSMutableDictionary*) getThemesData;
- (VideoThemeModel*) getThemeByType:(ThemesType)themeType;

- (NSArray*) getRandomAnimation;
- (NSArray*) getAnimationByIndex:(int)index;

- (NSString*) getVideoBorderByIndex:(int)index;
@end
