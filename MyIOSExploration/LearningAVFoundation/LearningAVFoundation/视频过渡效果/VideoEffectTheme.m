//
//  VideoEffectTheme.m
//  LearningAVFoundation
//
//  Created by fang wang on 17/2/17.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "VideoEffectTheme.h"

@interface VideoEffectTheme ()

@property (strong, nonatomic) NSMutableDictionary *themesDic;
@end

@implementation VideoEffectTheme


+ (VideoEffectTheme *) sharedInstance
{
    static VideoEffectTheme *singleton = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        singleton = [[VideoEffectTheme alloc] init];
    });
    
    return singleton;
}

- (id)init
{
    if (self = [super init])
    {
        [self initThemesData];
    }
    
    return self;
}


- (void)dealloc
{
    [self clearAll];
}

- (void) clearAll
{
    if (self.themesDic && [self.themesDic count]>0)
    {
        [self.themesDic removeAllObjects];
        self.themesDic = nil;
    }
}

- (void) initThemesData
{
    self.themesDic = [NSMutableDictionary dictionaryWithCapacity:15];
    VideoThemeModel *theme = nil;
    for (int i = kThemeNone; i <= kThemeCloud; ++i) {
        switch (i) {
            case kThemeNone:
                break;
            case kThemeButterfly:
                theme = [self createThemeButterfly];
                break;
            case kThemeLeaf:
                theme = [self createThemeLeaf];
                break;
            case kThemeStarshine:
                theme = [self createThemeStarshine];
                break;
            case kThemeFlare:
                theme = [self createThemeFlare];
                break;
            case kThemeFruit:
                theme = [self createThemeFruit];
                break;
            case kThemeCartoon:
                theme = [self createThemeCartoon];
                break;
            case kThemeScience:
                theme = [self createThemeScience];
                break;
            case kThemeCloud:
                theme = [self createThemeCloud];
                break;
            case kThemeCustom:
                theme = [self createThemeCustom];
                break;
            default:
                break;
        }
        if (i == kThemeNone) {
            [self.themesDic setObject:[NSNull null] forKey:[NSNumber numberWithInt:kThemeNone]];
        } else {
            [self.themesDic setObject:theme forKey:[NSNumber numberWithInt:i]];
        }
    }
}

#pragma mark - Init themes
- (VideoThemeModel*) createThemeButterfly
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeButterfly;
    theme.thumbImageName = @"themeButterfly";
    theme.name = @"Butterfly";
    theme.textStar = @"butterfly";
    theme.textSparkle = @"beautifully";
    theme.textGradient = nil;
    theme.bgMusicFile = @"Because I Love You.mp3";
    theme.imageFile = nil;
    theme.scrollText = nil;
    theme.bgVideoFile = [self getFileURL:@"bgVideo01.mov"];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationTextStar], [NSNumber numberWithInt:kAnimationPhotoLinearScroll], [NSNumber numberWithInt:KAnimationPhotoCentringShow], [NSNumber numberWithInt:kAnimationTextSparkle], nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (VideoThemeModel*) createThemeLeaf
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeLeaf;
    theme.thumbImageName = @"themeLeaf";
    theme.name = @"Leaf";
    theme.textStar = nil;
    theme.textSparkle = nil;
    theme.textGradient = nil;
    theme.bgMusicFile = @"Big Big World.mp3";
    theme.imageFile = nil;
    theme.scrollText = nil;
    theme.bgVideoFile = [self getFileURL:@"bgVideo02.m4v"];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects: [NSNumber numberWithInt:kAnimationMeteor], nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (VideoThemeModel*) createThemeStarshine
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeStarshine;
    theme.thumbImageName = @"themeStarshine";
    theme.name = @"Star";
    theme.textStar = nil;
    theme.textSparkle = nil;
    theme.textGradient = nil;
    theme.bgMusicFile = @"I love you more than I can say.mp3";
    theme.imageFile = nil;
    theme.scrollText = nil;
    theme.bgVideoFile = [self getFileURL:@"bgVideo03.m4v"];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationPhotoParabola], [NSNumber numberWithInt:kAnimationMoveDot], nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (VideoThemeModel*) createThemeFlare
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeFlare;
    theme.thumbImageName = @"themeFlare";
    theme.name = @"Flare";
    theme.textStar = nil;
    theme.textSparkle = nil;
    theme.textGradient = nil;
    theme.bgMusicFile = @"Pretty Boy.mp3";
    theme.imageFile = nil;
    theme.scrollText = nil;
    theme.bgVideoFile = [self getFileURL:@"bgVideo04.mov"];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationPhotoFlare], [NSNumber numberWithInt:kAnimationSky], nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (VideoThemeModel*) createThemeFruit
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeFruit;
    theme.thumbImageName = @"themeFruit";
    theme.name = @"Fruit";
    theme.textStar = nil;
    theme.textSparkle = nil;
    theme.textGradient = nil;
    theme.bgMusicFile = @"Rhythm Of Rain.mp3";
    theme.imageFile = nil;
    theme.scrollText = nil;
    theme.bgVideoFile = [self getFileURL:@"bgVideo05.mov"];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationPhotoEmitter], nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (VideoThemeModel*) createThemeCartoon
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeCartoon;
    theme.thumbImageName = @"themeCartoon";
    theme.name = @"Cartoon";
    theme.textStar = nil;
    theme.textSparkle = nil;
    theme.textGradient = nil;
    theme.bgMusicFile = @"The Day You Went Away.mp3";
    theme.imageFile = nil;
    theme.scrollText = nil;
    theme.bgVideoFile = [self getFileURL:@"bgVideo06.mov"];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationPhotoExplode], [NSNumber numberWithInt:kAnimationPhotoSpin360], nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (VideoThemeModel*) createThemeScience
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeScience;
    theme.thumbImageName = @"themeScience";
    theme.name = @"Science";
    theme.textStar = nil;
    theme.textSparkle = nil;
    theme.textGradient = nil;
    theme.bgMusicFile = @"The mood of love.mp3";
    theme.imageFile = nil;
    theme.scrollText = nil;
    theme.bgVideoFile = [self getFileURL:@"bgVideo07.mov"];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationPhotoExplodeDrop], [NSNumber numberWithInt:KAnimationPhotoCentringShow],nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (VideoThemeModel*) createThemeCloud
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeCloud;
    theme.thumbImageName = @"themeCloud";
    theme.name = @"Cloud";
    theme.textStar = nil;
    theme.textSparkle = nil;
    theme.textGradient = nil;
    theme.bgMusicFile = @"Untitled.mp3";
    theme.imageFile = nil;
    theme.scrollText = nil;
    theme.bgVideoFile = [self getFileURL:@"bgVideo08.mov"];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationPhotoCloud], [NSNumber numberWithInt:KAnimationPhotoCentringShow],nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (VideoThemeModel*) createThemeCustom
{
    VideoThemeModel *theme = [[VideoThemeModel alloc] init];
    theme.ID = kThemeCustom;
    theme.thumbImageName = @"themeCustom";
    theme.name = @"Custom";
    theme.textStar = @"My Love";
    theme.textSparkle = @"Miss You!";
    theme.textGradient = @"To My Lover!";
    theme.bgMusicFile = @"Yesterday Once More.mp3";
    theme.imageFile = nil;
    
    // Scroll text
    NSMutableArray *scrollText = [[NSMutableArray alloc] init];
    [scrollText addObject:[self stringWithFormat:@"yyyy/MM/dd" date:[NSDate date]]];
    [scrollText addObject:[self getWeekdayFromDate:[NSDate date]]];
    [scrollText addObject:@"It's a valuable day!"];
    theme.scrollText = scrollText;
    
    theme.imageVideoBorder = [NSString stringWithFormat:@"border_%i",(arc4random()%(int)5)];
    
    NSString *defaultVideo = @"Cloud02.mov";
    theme.bgVideoFile = [self getFileURL:defaultVideo];
    
    theme.animationActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder], [NSNumber numberWithInt:kAnimationSky], [NSNumber numberWithInt:kAnimationTextStar], [NSNumber numberWithInt:kAnimationTextScroll], [NSNumber numberWithInt:kAnimationTextGradient], [NSNumber numberWithInt:kAnimationTextSparkle], nil];
    
    return theme;
}

- (NSString*) getVideoBorderByIndex:(int)index
{
    NSString *videoBorder = nil;
    if (index >= 0 && index < 12)
    {
        videoBorder = [NSString stringWithFormat:@"border_%i", index];
    }
    return videoBorder;
}

- (NSArray*) getAnimationByIndex:(int)index
{
    NSArray *aniActions = nil;
    switch (index)
    {
        case 0:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationPhotoCloud],
                          [NSNumber numberWithInt:KAnimationPhotoCentringShow],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
        case 1:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationPhotoExplodeDrop],
                          [NSNumber numberWithInt:KAnimationPhotoCentringShow],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
        case 2:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationPhotoExplode],
                          [NSNumber numberWithInt:kAnimationPhotoSpin360],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
        case 3:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationPhotoEmitter],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
        case 4:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationPhotoFlare],
                          [NSNumber numberWithInt:kAnimationSky],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
        case 5:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationPhotoParabola],
                          [NSNumber numberWithInt:kAnimationMoveDot],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
        case 6:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationMeteor],
                          [NSNumber numberWithInt:kAnimationPhotoDrop],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
        case 7:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationPhotoFlare],
                          [NSNumber numberWithInt:KAnimationPhotoCentringShow],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
        default:
        {
            aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationVideoBorder],
                          [NSNumber numberWithInt:kAnimationSky],
                          [NSNumber numberWithInt:kAnimationTextStar],
                          [NSNumber numberWithInt:kAnimationTextScroll],
                          [NSNumber numberWithInt:kAnimationTextGradient],
                          [NSNumber numberWithInt:kAnimationTextSparkle], nil];
            
            break;
        }
    }
    
    return aniActions;
}

- (NSArray*) getRandomAnimation
{
    NSArray *aniActions = [self getAnimationByIndex:(arc4random() % 8)];
    return aniActions;
}

- (NSMutableDictionary*) getThemesData
{
    NSLog(@"self.themesDic = %@", self.themesDic);
    return self.themesDic;
}

- (VideoThemeModel*) getThemeByType:(ThemesType)themeType
{
    if (self.themesDic && [self.themesDic count]>0)
    {
        VideoThemeModel* theme = [self.themesDic objectForKey:[NSNumber numberWithInt:themeType]];
        if (theme && ((NSNull*)theme != [NSNull null]))
        {
            return theme;
        }
    }
    return nil;
}


- (NSURL*) getFileURL:(NSString*)inputFileName
{
    NSString *fileName = [inputFileName stringByDeletingPathExtension];
    NSString *fileExt = [inputFileName pathExtension];
    NSURL *inputVideoURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExt];
    return inputVideoURL;
}

- (NSString *)stringWithFormat:(NSString *)format date:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:date];
}

- (NSString*) getWeekdayFromDate:(NSDate*)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = nil;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday = [components weekday];
    NSString *result = nil;
    NSArray* weekdayStringArr = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    if (weekday <= weekdayStringArr.count) {
        result = weekdayStringArr[weekday];
    }
    return result;
}

@end
