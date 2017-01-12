
#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

/** 暂停NSTimer */
- (void)pauseTimer;

/** 开始NSTimer */
- (void)resumeTimer;

/** 延迟开始NSTimer */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
