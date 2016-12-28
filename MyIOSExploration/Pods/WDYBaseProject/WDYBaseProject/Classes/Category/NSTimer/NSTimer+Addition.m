
#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

-(void)pauseTimer
{
    if (![self isValid])
    {
        return ;
    }
    
    [self setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimer
{
    if (![self isValid])
    {
        return ;
    }
    
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid])
    {
        return ;
    }
    
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}
@end
