//
//  UIImageView+Blur.m
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//

#import "UIImageView+Blur.h"
#import "UIImage+ImageEffects.h"


CGFloat const kWDYBlurredImageDefaultBlurRadius            = 20.0;
CGFloat const kWDYBlurredImageDefaultSaturationDeltaFactor = 1.8;

@implementation UIImageView (Blur)

- (void)setImageToBlur:(UIImage *)image
       completionBlock:(WDYBlurredImageCompletionBlock)completion
{
    [self setImageToBlur:image
              blurRadius:kWDYBlurredImageDefaultBlurRadius
         completionBlock:completion];
}

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(WDYBlurredImageCompletionBlock) completion
{
    NSParameterAssert(image);
    blurRadius = (blurRadius <= 0) ? kWDYBlurredImageDefaultBlurRadius : blurRadius;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *blurredImage = [image applyBlurWithRadius:blurRadius tintColor:nil saturationDeltaFactor:kWDYBlurredImageDefaultSaturationDeltaFactor maskImage:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = blurredImage;
            if (completion) {
                completion();
            }
        });
    });
}


@end
