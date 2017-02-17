//
//  VideoThemeModel.h
//  LearningAVFoundation
//
//  Created by fang wang on 17/2/17.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoThemeModel : NSObject
@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *thumbImageName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *textStar;
@property (nonatomic, copy) NSString *textSparkle;
@property (nonatomic, copy) NSString *textGradient;
@property (nonatomic, copy) NSString *bgMusicFile;
@property (nonatomic, copy) NSString *imageFile;
@property (nonatomic, strong) NSMutableArray *scrollText;
@property (nonatomic, strong) NSMutableArray *animationImages;
@property (nonatomic, strong) NSArray *keyFrameTimes;
@property (nonatomic, copy) NSString *imageVideoBorder;
@property (nonatomic, strong) NSURL *bgVideoFile;
@property (nonatomic, strong) NSArray *animationActions;
@end
