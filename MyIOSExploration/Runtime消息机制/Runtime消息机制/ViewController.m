//
//  ViewController.m
//  Runtime消息机制
//
//  Created by wangdongyang on 16/9/7.
//  Copyright © 2016年 wdy. All rights reserved.
//

/*
 参考资料：
 https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html 官方RuntimeGuide
 
 https://github.com/huang303513/iOSRunTimeExplore   ios运行时的学习与实践
 
 https://github.com/HHuiHao/Universal-Jump-ViewController  根据规则跳转到指定的界面
 
 http://dreamerpanda.cn/2016/05/11/Runtime-tabBarItem/  Runtime实战之定制TabBarItem大小
 
 http://bbs.520it.com/forum.php?mod=viewthread&tid=3045  runtime+KVC实现全屏滑动移除控制器
 
 http://www.imlifengfeng.com/blog/?tag=runtime   iOS Runtime
 
 https://github.com/leejayID/RuntimeDemo  Objective-C中的Runtime
 
 http://www.jianshu.com/p/8345a79fd572  你会遇到的runtime面试题（详）
 
 http://www.jianshu.com/p/f6dad8e1b848  Runtime Method Swizzling开发实例汇总（持续更新中）
 
 https://github.com/Magic-Unique/Runtime  Runtime基础知识点总结
 
 https://github.com/huang303513/iOSRunTimeRunLoopExplore  runloop、runtime学习与实践
 
 https://github.com/cyanzhong/RuntimeInvoker  使用方法名称调用方法，可以用在一些奇技淫巧或是私有方法调试
 
 */

#import "ViewController.h"
#import <objc/message.h>
#import "Student.h"
#import "NSArray+SafeArr.h"
#import "WDYGameModel.h"
#import "WDYSubAreaModel.h"
#import "NSObject+ObjectMap.h"
#import "NSObject+Property.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test5];
}



/*
 runtime字典转模型
 */
- (void)test5
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"LOL_reamls" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:jsonPath];
    WDYGameModel* model = [WDYGameModel modelWithDict:dict];
    NSLog(@"%@", model.gameName);
    
    for (WDYSubAreaModel* subModel in model.realms) {
        NSLog(@"realmName = %@", subModel.realmName);
    }
}


/*
 动态添加属性
 */
- (void)test4
{
    NSObject *objc = [[NSObject alloc] init];
    
    objc.name = @"123";
    
    NSLog(@"%@",objc.name);
}


/* 
 动态添加方法
*/
- (void)test3
{
    Student* stu = [[Student alloc] init];
    [stu performSelector:@selector(goToSchool:) withObject:@10];
}

/* 方法交换
1.给系统的方法添加分类
2.自己实现一个带有扩展功能的方法
3.交互方法,只需要交互一次,
*/
- (void)test2
{
    NSArray* arr = @[@"1", @"2"];
    [arr objectAtIndex:2];
}


/* 使用步骤
 1、 必须要导入头文件 <objc/message.h>
 2、 没有提示：到build setting -> 搜索msg -> 把‘YES’改为‘NO’
 3、 查看源码：
 id objc = ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("alloc"));
 objc = ((id (*)(id, SEL))(void *)objc_msgSend)((id)objc, sel_registerName("init"));
 4、方法调用流程，怎么去调用learn方法 ,对象方法:类对象的方法列表 类方法:元类中方法列表
 a.通过isa去对应的类中查找
 b.注册方法编号
 c.根据方法编号去查找对应方法
 d.找到只是最终函数实现地址,根据地址去方法区调用对应函数
 */
- (void)test1
{
    Student* stu = objc_msgSend(objc_getClass("Student"), sel_registerName("alloc"));
    stu = objc_msgSend(stu, sel_registerName("init"));
    
    // 调用对象方法
    [stu learn];
    
    // 本质：让对象发送消息
    objc_msgSend(stu, @selector(learn));
    
    // 调用类方法的方式：两种
    // 第一种通过类名调用
    [Student exam];
    // 第二种通过类对象调用
    [[Student class] exam];
    
    // 用类名调用类方法，底层会自动把类名转换成类对象调用
    // 本质：让类对象发送消息
    objc_msgSend([Student class], @selector(exam));
}


@end
