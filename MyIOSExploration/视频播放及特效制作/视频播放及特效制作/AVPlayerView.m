//
//  AVPlayerView.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/1/17.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "AVPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "FullPlayerViewController.h"

#define KToolViewHeight     45
#define kToolViewMaxAlpha   0.7

@interface AVPlayerView ()
@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) AVPlayerLayer* playerLayer;
@property (nonatomic, strong) AVPlayerItem* playerItem;
/** tap手势 */
@property (nonatomic, strong) UITapGestureRecognizer* tapAction;
/** 背景图片 */
@property (nonatomic, strong) UIImageView* bgImageView;
/** 底部的工具条容器View */
@property (nonatomic, strong) UIView* toolView;
/** 播放和暂停按钮 */
@property (nonatomic, strong) UIButton* playOrPauseBtn;
/** 屏幕中央的开始按钮 */
@property (nonatomic, strong) UIButton* playOrPauseBigBtn;
/** 播放进度条 */
@property (nonatomic, strong) UISlider* progressSlider;
/** 当前的播放时间 */
@property (nonatomic, strong) UILabel* timeLabel;
/** 总播放时间 */
@property (nonatomic, strong) UILabel* allTimeLabel;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton* fullScreenButton;
/** slider和播放时间定时器 */
@property (nonatomic, strong) NSTimer* progressTimer;
/** 全屏播放控制器 */
@property (nonatomic, strong) FullPlayerViewController *fullVc;
/** 播放完毕遮盖View */
@property (nonatomic, strong) UIView *coverView;
/** 是否显示toolView */
@property (nonatomic, assign) BOOL isShowToolView;
/** toolView显示时间的timer */
@property (nonatomic, strong) NSTimer* showTime;
/** 重播按钮 */
@property (nonatomic, strong) UIButton* repeatBtn;
/** 分享按钮 */
@property (nonatomic, strong) UIButton* shareBtn;
@property (nonatomic, strong) AVURLAsset* firstAsset;
@property (nonatomic, strong) AVURLAsset* secondAsset;
@end

@implementation AVPlayerView

- (instancetype)init{

    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    [self addSubview:self.bgImageView];
    [self.bgImageView.layer addSublayer:self.playerLayer];
    [self addSubview:self.playOrPauseBigBtn];
    [self addSubview:self.toolView];
    [self.toolView addSubview:self.playOrPauseBtn];
    [self.toolView addSubview:self.fullScreenButton];
    [self.toolView addSubview:self.progressSlider];
    [self.toolView addSubview:self.timeLabel];
    [self.toolView addSubview:self.allTimeLabel];
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.repeatBtn];
    [self.coverView addSubview:self.shareBtn];
    
    self.isShowToolView = NO;
    self.playOrPauseBtn.selected = NO;
    self.coverView.hidden = YES;
    self.toolView.alpha = 0;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.playOrPauseBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(64);
        make.center.equalTo(self);
    }];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(KToolViewHeight);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.toolView);
        make.width.mas_equalTo(KToolViewHeight);
    }];
    
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.toolView);
        make.width.mas_equalTo(KToolViewHeight);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.toolView);
        make.left.equalTo(self.playOrPauseBtn.mas_right);
    }];
    
    [self.allTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.toolView);
        make.left.equalTo(self.timeLabel.mas_right).offset(15);
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.toolView);
        make.top.equalTo(self.toolView.mas_top).offset(-8);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(64);
        make.centerY.equalTo(self.coverView.mas_centerY);
        make.centerX.equalTo(self.coverView.mas_centerX).multipliedBy(0.75);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(64);
        make.centerY.equalTo(self.coverView.mas_centerY);
        make.centerX.equalTo(self.coverView.mas_centerX).multipliedBy(1.25);
    }];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    self.playerLayer.frame = self.bgImageView.bounds;
}

/** slider定时器添加 */
-(void)addProgressTimer{
    [self progressTimer];
}

/** toolView显示时开始计时，5s后隐藏toolView */
-(void)addShowTime{
    [self showTime];
}

-(void)removeShowTime{
    [self.showTime invalidate];
    self.showTime = nil;
}

/** 移除slider定时器 */
-(void)removeProgressTimer{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

/** 更新播放进度条 */
- (void)updateProgressInfo{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval durationTime = CMTimeGetSeconds(self.player.currentItem.duration);
    
    self.timeLabel.text = [self timeToStringWithTimeInterval:currentTime];
    self.allTimeLabel.text = [self timeToStringWithTimeInterval:durationTime];
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (self.progressSlider.value == 1) {
        [self removeProgressTimer];
        self.coverView.hidden = NO;
        NSLog(@"播放完了");
    }
}

/** 将toolView隐藏 */
-(void)upDateToolView{
    self.isShowToolView = !self.isShowToolView;
    [UIView animateWithDuration:0.5 animations:^{
        self.toolView.alpha = 0;
    }];
    NSLog(@"timer显示或者隐藏");
}

#pragma mark - User Interaction

/** imageView的tap手势方法 */
- (void)tap:(UIGestureRecognizer *)sender{
    if (self.player.status == AVPlayerStatusUnknown) {
        [self playOrPauseBigBtnClick:self.playOrPauseBigBtn];
        return;
    }
    self.isShowToolView = !self.isShowToolView;
    if (self.isShowToolView){
        [UIView animateWithDuration:0.5 animations:^{
            self.toolView.alpha = kToolViewMaxAlpha;
        }];
        if (self.playOrPauseBtn.selected) {
            [self addShowTime];
        }
    }else{
        [self removeShowTime];
        [UIView animateWithDuration:0.5 animations:^{
            self.toolView.alpha = 0;
        }];
    }
}

// 开始播放
- (void)playOrPauseBigBtnClick:(UIButton *)sender{
    sender.hidden = YES;
    self.playOrPauseBtn.selected = YES;
    
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.player play];
    [self addProgressTimer];
}
/** toolView上暂停按钮的点击事件 */
- (void)playOrPauseBtnClick:(UIButton *)sender {
    // 播放状态按钮selected为YES,暂停状态selected为NO。
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.toolView.alpha = kToolViewMaxAlpha;
        [self removeShowTime];
        [self.player pause];
        [self removeProgressTimer];
    }else{
        [self addShowTime];
        [self.player play];
        [self addProgressTimer];
    }
}

/** 转换播放时间和总时间的方法 */
-(NSString *)timeToStringWithTimeInterval:(NSTimeInterval)interval;{
    NSInteger Min = interval / 60;
    NSInteger Sec = (NSInteger)interval % 60;
    NSString *intervalString = [NSString stringWithFormat:@"%02ld:%02ld",Min,Sec];
    return intervalString;
}

/** slider拖动和点击事件 */
- (void)touchDownSlider:(UISlider *)sender {
    // 按下去 移除监听器
    [self removeProgressTimer];
    [self removeShowTime];
}
- (void)valueChangedSlider:(UISlider *)sender {
    
    // 计算slider拖动的点对应的播放时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * sender.value;
    self.timeLabel.text = [self timeToStringWithTimeInterval:currentTime];
}
- (void)touchUpInside:(UISlider *)sender {
    [self addProgressTimer];
    //计算当前slider拖动对应的播放时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * sender.value;
    // 播放移动到当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self addShowTime];
}

- (void)fullViewBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self videoplayViewSwitchOrientation:sender.selected];
}

/** 弹出全屏播放器 */
- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (isFull) {
        [self.contrainerViewController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self];
            self.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.fullVc.view.bounds;
            } completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.contrainerViewController.view addSubview:self];
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = CGRectMake(0, 200, self.contrainerViewController.view.bounds.size.width, self.contrainerViewController.view.bounds.size.width * 9 / 16);
            } completion:nil];
        }];
    }
}

- (void)repeatBtnClick:(UIButton*)sender{
    self.progressSlider.value = 0;
    [self touchUpInside:self.progressSlider];
    self.coverView.hidden = YES;
    [self playOrPauseBigBtnClick:self.playOrPauseBigBtn];
}

- (void)shareBtnClick:(UIButton*)sender{
    
}

#pragma mark - Setter Method

/** 需要播放的视频资源set方法 */
-(void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    NSURL *url = [NSURL URLWithString:urlString];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
}

- (void)setImages:(NSMutableArray *)images{
    
    _images = images;
    
}

#pragma mark - Getter Method

- (AVPlayer *)player{
    if (!_player) {
        AVPlayer* player = [[AVPlayer alloc] init];
        _player = player;
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer = playerLayer;
    }
    return _playerLayer;
}

- (UITapGestureRecognizer *)tapAction{
    if (!_tapAction) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _tapAction = tap;
    }
    return _tapAction;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:self.tapAction];
        [imageView.layer addSublayer:self.playerLayer];
        imageView.image = [UIImage imageWithColor:[UIColor blackColor]];
        _bgImageView = imageView;
    }
    return _bgImageView;
}

- (UIView *)toolView{
    if (!_toolView) {
        UIView* toolView = [[UIView alloc] init];
        toolView.backgroundColor = [UIColor blackColor];
        toolView.alpha = 0.7;
        _toolView = toolView;
    }
    return _toolView;
}

- (UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        UIButton* playOrPauseBtn = [[UIButton alloc] init];
        [playOrPauseBtn setImage:[UIImage imageNamed:@"full_play_btn"] forState:UIControlStateNormal];
        [playOrPauseBtn setImage:[UIImage imageNamed:@"full_pause_btn"] forState:UIControlStateSelected];
        [playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _playOrPauseBtn = playOrPauseBtn;
    }
    return _playOrPauseBtn;
}

- (UIButton *)playOrPauseBigBtn{
    if (!_playOrPauseBigBtn) {
        UIButton* playOrPauseBigBtn = [[UIButton alloc] init];
        [playOrPauseBigBtn setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
        [playOrPauseBigBtn addTarget:self action:@selector(playOrPauseBigBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _playOrPauseBigBtn = playOrPauseBigBtn;
    }
    return _playOrPauseBigBtn;
}

- (UISlider *)progressSlider{
    if (!_progressSlider) {
        UISlider* progressSlider = [[UISlider alloc] init];
        [progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
        [progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
        [progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
        [progressSlider addTarget:self action:@selector(touchDownSlider:) forControlEvents:UIControlEventTouchDown];
        [progressSlider addTarget:self action:@selector(valueChangedSlider:) forControlEvents:UIControlEventValueChanged];
        [progressSlider addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _progressSlider = progressSlider;
    }
    return _progressSlider;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorWithHexString:@"DE4C5E"];
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

- (UILabel *)allTimeLabel{
    if (!_allTimeLabel) {
        UILabel* allTimeLabel = [[UILabel alloc] init];
        allTimeLabel.font = [UIFont systemFontOfSize:13];
        allTimeLabel.textColor = [UIColor lightGrayColor];
        _allTimeLabel = allTimeLabel;
    }
    return _allTimeLabel;
}

- (UIButton *)fullScreenButton{
    if (!_fullScreenButton) {
        UIButton* fullScreenButton = [[UIButton alloc] init];
        [fullScreenButton setImage:[UIImage imageNamed:@"mini_launchFullScreen_btn"] forState:UIControlStateNormal];
        [fullScreenButton setImage:[UIImage imageNamed:@"full_minimize_btn"] forState:UIControlStateSelected];
        [fullScreenButton addTarget:self action:@selector(fullViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenButton = fullScreenButton;
    }
    return _fullScreenButton;
}

- (NSTimer *)progressTimer{
    if (!_progressTimer) {
        NSTimer* progressTimer = [NSTimer timerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(updateProgressInfo)
                                                       userInfo:nil
                                                        repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:progressTimer forMode:NSDefaultRunLoopMode];
        _progressTimer = progressTimer;
    }
    return _progressTimer;
}

- (NSTimer *)showTime{
    if (!_showTime) {
        NSTimer* showTime = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                             target:self
                                                           selector:@selector(upDateToolView)
                                                           userInfo:nil
                                                            repeats:NO];
        [[NSRunLoop mainRunLoop]addTimer:showTime forMode:NSRunLoopCommonModes];
        _showTime = showTime;
    }
    return _showTime;
}

- (UIView *)coverView{
    if (!_coverView) {
        UIView* coverView = [[UIView alloc] init];
        _coverView = coverView;
    }
    return _coverView;
}

- (FullPlayerViewController *)fullVc{
    
    if (!_fullVc) {
        _fullVc = [[FullPlayerViewController alloc] init];
    }
    return _fullVc;
}

- (UIButton *)repeatBtn{
    if (!_repeatBtn) {
        UIButton* repeatBtn = [[UIButton alloc] init];
        [repeatBtn setImage:[UIImage imageNamed:@"chongbo"] forState:UIControlStateNormal];
        [repeatBtn setImage:[UIImage imageNamed:@"chongbo"] forState:UIControlStateSelected];
        [repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _repeatBtn = repeatBtn;
    }
    return _repeatBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        UIButton* shareBtn = [[UIButton alloc] init];
        [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateSelected];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn = shareBtn;
    }
    return _shareBtn;
}

@end













