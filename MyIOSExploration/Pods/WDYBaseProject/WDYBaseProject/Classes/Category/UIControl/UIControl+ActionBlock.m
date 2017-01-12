//
//  UIControl+ActionBlock.m
//  Pods
//
//  Created by fang wang on 16/12/29.
//
//

#import "UIControl+ActionBlock.h"
#import <objc/runtime.h>

// TouchDown/TouchUp事件的key
static const void *s_ButtonTouchDownKey = "s_ButtonTouchDownKey";
static const void *s_ButtonTouchUpKey = "s_ButtonTouchUpKey";
static const void *s_ValueChangedKey = "s_ValueChangedKey";

@implementation UIControl (ActionBlock)

- (void)setTouchDown:(ButtonClickedBlock)touchDown {
    objc_setAssociatedObject(self, s_ButtonTouchDownKey, touchDown, OBJC_ASSOCIATION_COPY);
    
    [self removeTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    if (touchDown) {
        [self addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
}

- (ButtonClickedBlock)touchDown {
    ButtonClickedBlock downBlock = objc_getAssociatedObject(self, s_ButtonTouchDownKey);
    return downBlock;
}

- (void)setTouchUp:(ButtonClickedBlock)touchUp {
    objc_setAssociatedObject(self, s_ButtonTouchUpKey, touchUp, OBJC_ASSOCIATION_COPY);
    
    [self removeTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    if (touchUp) {
        [self addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (ButtonClickedBlock)touchUp {
    ButtonClickedBlock upBlock = objc_getAssociatedObject(self, s_ButtonTouchUpKey);
    return upBlock;
}

- (void)setValueChangedBlock:(ValueChangedBlock)valueChangedBlock {
    objc_setAssociatedObject(self, s_ValueChangedKey, valueChangedBlock, OBJC_ASSOCIATION_COPY);
    
    [self removeTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    if (valueChangedBlock) {
        [self addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

- (ValueChangedBlock)valueChangedBlock {
    ValueChangedBlock block = objc_getAssociatedObject(self, s_ValueChangedKey);
    return block;
}

- (void)onValueChanged:(id)sender {
    ValueChangedBlock block = [self valueChangedBlock];
    
    if (block) {
        block(sender);
    }
}

- (void)onTouchUp:(UIButton *)sender {
    ButtonClickedBlock touchUp = [self touchUp];
    
    if (touchUp) {
        touchUp(sender);
    }
}

- (void)onTouchDown:(UIButton *)sender {
    ButtonClickedBlock touchDown = [self touchDown];
    
    if (touchDown) {
        touchDown(sender);
    }
}
@end
