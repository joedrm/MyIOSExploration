//
//  LBETimelineItemViewModel.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBETimelineItem.h"

@interface LBETimelineItemViewModel : NSObject
@property (nonatomic) CGFloat widthInTimeline;
@property (nonatomic) CGFloat maxWidthInTimeline;
@property (nonatomic) CGPoint positionInTimeline;
@property (strong, nonatomic) LBETimelineItem *timelineItem;

+ (id)modelWithTimelineItem:(LBETimelineItem *)timelineItem;
- (void)updateTimelineItem;
@end
