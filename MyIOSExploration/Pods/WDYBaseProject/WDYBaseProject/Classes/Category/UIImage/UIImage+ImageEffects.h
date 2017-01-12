

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

NS_ASSUME_NONNULL_BEGIN

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(nullable UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(nullable UIImage *)maskImage;

- (UIImage *)blurryWithBlurLevel:(CGFloat)blur;

NS_ASSUME_NONNULL_END
@end
