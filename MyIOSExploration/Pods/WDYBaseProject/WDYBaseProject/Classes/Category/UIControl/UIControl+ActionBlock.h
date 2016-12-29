//
//  UIControl+ActionBlock.h
//  Pods
//
//  Created by fang wang on 16/12/29.
//
//

#import <UIKit/UIKit.h>

//
// 值改变时的回调block
//
typedef void(^SwitchValueChangedBlock)(UISwitch *sender);
typedef void(^ValueChangedBlock)(id sender);
typedef void(^ButtonClickedBlock)(UIButton *sender);

@interface UIControl (ActionBlock)

/**
 *  按钮按下事件回调
 */
@property (nonatomic, copy) ButtonClickedBlock touchDown;

/**
 *  按钮松开事件回调
 */
@property (nonatomic, copy) ButtonClickedBlock touchUp;

/**
 *  值改变时的回调block
 */
@property (nonatomic, copy) ValueChangedBlock valueChangedBlock;

@end
