<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [MyIOSExploration](#myiosexploration)
    - [Books&文档](#books%E6%96%87%E6%A1%A3)
    - [IOS Awsome](#ios-awsome)
    - [KVO进阶](#kvo%E8%BF%9B%E9%98%B6)
    - [多线程和RunLoop](#%E5%A4%9A%E7%BA%BF%E7%A8%8B%E5%92%8Crunloop)
    - [Runtime相关](#runtime%E7%9B%B8%E5%85%B3)
    - [ReactiveCocoa相关](#reactivecocoa%E7%9B%B8%E5%85%B3)
    - [动画 & 绘图](#%E5%8A%A8%E7%94%BB--%E7%BB%98%E5%9B%BE)
    - [解析开源项目](#%E8%A7%A3%E6%9E%90%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AE)
    - [博客](#%E5%8D%9A%E5%AE%A2)
    - [优化文章](#%E4%BC%98%E5%8C%96%E6%96%87%E7%AB%A0)
    - [组件化](#%E7%BB%84%E4%BB%B6%E5%8C%96)
    - [Git SVN](#git-svn)
    - [面试](#%E9%9D%A2%E8%AF%95)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# MyIOSExploration
IOS知识点总结和实践

### Books&文档
- [objc-zen-book-cn](https://github.com/oa414/objc-zen-book-cn) - 禅与 Objective-C 编程艺术
- [the-swift-programming-language-in-chinese](https://github.com/numbbbbb/the-swift-programming-language-in-chinese) - 中文版 Apple 官方 Swift 教程《The Swift Programming Language》
- [Welcome-to-Swift](https://github.com/CocoaChina-editors/Welcome-to-Swift) - Swift中文文档
- [iOS Developer Library](https://developer.apple.com/library/content/navigation/) - Guides and Sample Code
- [swift-evolution](https://github.com/apple/swift-evolution)

### IOS Awsome
- [awesome-ios](https://github.com/vsouza/awesome-ios)
- [awesome-iOS-blog-article](https://github.com/Jiar/awesome-iOS-blog-article) - 比较好的一些博客和文章
- [ming1016/study](https://github.com/ming1016/study) - 学习记录
- [TimLiu-iOS](https://github.com/Tim9Liu9/TimLiu-iOS) - iOS开发常用三方库、插件、知名博客等等
- [nixzhu/dev-blog](https://github.com/nixzhu/dev-blog) - 翻译、开发心得或学习笔记
- [iOS10AdaptationTips](https://github.com/ChenYilong/iOS10AdaptationTips) - IOS 10适配
- [awesome-ios-cn](https://github.com/jobbole/awesome-ios-cn) - iOS资源大全中文版
- [iOS-Note](https://github.com/seedante/iOS-Note)  - 一些不错的文章

### KVO进阶
- [谈谈 KVO](http://www.jianshu.com/p/2d1c9d76153b)
- [KVO进阶 —— 源码实现探究](http://www.cocoachina.com/ios/20161117/18110.html)
- [KVC和KVO](http://ppsheep.com/categories/KVC%E5%92%8CKVO/)
- [KVC 和 KVO](https://www.objccn.io/issue-7-3/)


### 多线程和RunLoop
- [深入理解RunLoop](http://blog.ibireme.com/2015/05/18/runloop/)
- [深入理解iOS开发中的锁](https://bestswifter.com/ios-lock/?utm_source=tuicool&utm_medium=referral)
- [iOS中保证线程安全的几种方式与性能对比](http://www.jianshu.com/p/ddbe44064ca4)
- [GCD介绍](http://www.jianshu.com/p/2d1c9d76153b) - 翻译文章
- [Cocoa深入学习:NSOperationQueue、NSRunLoop和线程安全](https://blog.cnbluebox.com/blog/2014/07/01/cocoashen-ru-xue-xi-nsoperationqueuehe-nsoperationyuan-li-he-shi-yong/)
- [Concurrency](http://www.devtalking.com/tags/Concurrency/)、[Thread](http://www.devtalking.com/tags/Thread/)
- [iOS多线程操作时一些要注意的安全问题](http://www.starming.com/index.php?v=index&view=102)
- [APP 缓存数据线程安全问题探讨](http://blog.cnbang.net/tech/3262/)
- [底层并发 API](https://objccn.io/issue-2-3/)
- [常见的后台实践](https://objccn.io/issue-2-2/)
- [Facebook开源的Parse源码分析【系列】](https://github.com/ChenYilong/ParseSourceCodeStudy)

### Runtime相关
- [Objective-C中的Runtime](http://www.jianshu.com/p/3e050ec3b759)
- [Objective-C Runtime 运行时](http://southpeak.github.io/categories/objectivec/)
- [神经病院Objective-C Runtime出院第三天——如何正确使用Runtime](http://www.jianshu.com/p/db6dc23834e3)
- [OC最实用的runtime总结，面试、工作你看我就足够了！](http://www.jianshu.com/p/ab966e8a82e2#)
- [详解Runtime运行时机制](http://www.jianshu.com/p/1e06bfee99d0#)
- [Runtime 10种用法（没有比这更全的了）](http://www.jianshu.com/p/3182646001d1)
- [Runtime Method Swizzling开发实例汇总](http://www.jianshu.com/p/f6dad8e1b848)
- [手把手带你撸一个 YYModel 的精简版](http://www.jianshu.com/p/b822285f73ac)
- [苹果开源的 objc 运行时库](https://opensource.apple.com/source/objc4/)

### ReactiveCocoa相关
- [RAC中文资源列表](https://github.com/ReactiveCocoaChina/ReactiveCocoaChineseResources)
- [Awesome-ReactiveCocoa](https://github.com/hsavit1/Awesome-ReactiveCocoa)
- [ReactiveCocoa 中 RACSignal 所有变换操作底层实现分析2](http://www.jianshu.com/p/9c4459ae71c5)
- [ReactiveCocoa 中 RACSignal 是如何发送信号的](http://www.jianshu.com/p/d7d951a99db8)
- [MVVM With ReactiveCocoa](http://blog.leichunfeng.com/blog/2016/02/27/mvvm-with-reactivecocoa/)
- [iOS函数响应式编程以及ReactiveCocoa的使用](http://www.starming.com/index.php?v=index&view=101) - 一些常用的实践范例和比较完整的api说明
- [MVVMFramework](https://github.com/lovemo/MVVMFramework)
- [EasyIOS](https://github.com/zhuchaowe/EasyIOS)
- [kZMoonCommand](https://github.com/Bupterambition/kZMoonCommand#%E4%B8%AD%E6%96%87%E7%89%88)

### 动画 & 绘图
- [CoreAnimation编程指南](http://www.dreamingwish.com/article/the-concept-of-coreanimation-programming-guide.html) 
- [IOS核心动画高级技巧](https://zsisme.gitbooks.io/ios-/content/) 、[演示代码1](https://github.com/huang303513/HCDCoreAnimation) 、[演示代码2](https://github.com/ReviewCodeWorkshop1/CoreAnimationCode)
- [iOS开发系列--让你的应用“动”起来](http://www.cnblogs.com/kenshincui/p/3972100.html)
- [程序员说Animation](http://www.devtalking.com/tags/Animation/)
- [awesome-ios-animation](https://github.com/ameizi/awesome-ios-animation)
- [LayerPlayer](https://github.com/scotteg/LayerPlayer)
- [iOS开发 - 动画-CALayer-Core Animation-UIView封装](http://yimouleng.com/2014/11/23/CALayer-Animation/)
- [Quartz 2D编程指南](http://southpeak.github.io/2014/11/10/quartz2d-1/) - 南峰子翻译官方的文档
- [iOS开发系列--打造自己的“美图秀秀”](http://www.cnblogs.com/kenshincui/p/3959951.html)

### 解析开源项目
- [深入解析 iOS 开源项目](https://github.com/Draveness/iOS-Source-Code-Analyze)
- [源码分析](http://southpeak.github.io/categories/sourcecode/)

### 博客
- [Objc.io 中文版](https://www.objccn.io/issues/)
- [objccn/articles](https://github.com/objccn/articles) - objc.io的完整、准确、优雅的中文翻译版本
- [NSHipster 中文版](http://nshipster.cn/)
- [raywenderlich](https://www.raywenderlich.com/category/ios),[More](https://www.raywenderlich.com/tutorials)
- [www.appcoda.com](http://www.appcoda.com/)
- [ibireme](http://blog.ibireme.com/)
- [南峰子](http://southpeak.github.io/)
- [kenshincui](http://www.cnblogs.com/kenshincui/)
- [雷纯锋](http://blog.leichunfeng.com/)，[Github](https://github.com/leichunfeng)
- [MrPeak杂货铺](http://mrpeak.cn/)
- [Kitten's 时间胶囊](http://kittenyang.com/#blog)
- [岁寒](https://lvwenhan.com/sort/ios)
- [刚刚在线](http://www.superqq.com/)
- [刘坤的技术博客](https://blog.cnbluebox.com/)
- [casatwy](http://casatwy.com/) - 田伟宇，架构大牛，iOS应用架构经典文章
- [limboy](http://limboy.me/)
- [程序员说](http://www.devtalking.com/) - 关于多线程和动画的文章多，也深入
- [draveness](http://draveness.me/) - 不知哪位大神，很多不错的文章
- [罗朝辉的深入浅出Cocoa](http://blog.csdn.net/column/details/cocoa.html) - 涵盖 Cocoa 开发中的 runtime，class， message，KVO, 多线程，core data，网络，framework/plugin，性能，数据库，图形库等诸多方面，不仅讲述了应该如何使用这些技术，还深入底层探究这些技术是如何实现的，及其 runtime 分析。
- [我的博客](https://wangdongyang.github.io/)

### 优化文章
- [微信读书 iOS 性能优化总结](http://wereadteam.github.io/2016/05/03/WeRead-Performance/?f=tt)
- [iOS 保持界面流畅的技巧](http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)
- [WWDC心得与延伸:iOS图形性能](http://www.cocoachina.com/ios/20150429/11712.html)
- [使用 ASDK 性能调优 - 提升 iOS 界面的渲染性能](http://draveness.me/asdk-rendering/)
- [iOS底层技术文章收集](http://wiki.baixin.io/2016/06/11/iOS-Tech/)
- [优化iOS程序性能的25个方法](http://blog.csdn.net/youshaoduo/article/details/53841078) 总结的很好
- [离屏渲染优化详解：实例示范+性能测试](https://github.com/seedante/iOS-Note/wiki/Mastering-Offscreen-Render)

### 专题一：组件化
- [《iOS应用架构谈 组件化方案》](http://casatwy.com/iOS-Modulization.html)
- [蘑菇街 App 的组件化之路](http://limboy.me/tech/2016/03/10/mgj-components.html)
- [蘑菇街 App 的组件化之路·续](http://limboy.me/tech/2016/03/14/mgj-components-continued.html)
- [iOS 组件化方案探索](http://blog.cnbang.net/tech/3080/)
- [围观神仙打架，反革命工程师《iOS应用架构谈 组件化方案》和蘑菇街Limboy的《蘑菇街 App 的组件化之路》的阅读指导](http://reviewcode.cn/article.html?reviewId=20)

### 专题二：OpenGL
- [OpenGL ES 2.0 iOS教程](http://blog.csdn.net/column/details/opengl-es2-ios.html) - 详细介绍OpenGL ES 2.0 渲染管线，空间变换，光照，纹理贴图，混合，文字等3D知识。

### 专题三：WWDC
- [非官方WWDC App](https://github.com/insidegui/WWDC)
- [WWDC_2015_Video_Subtitle](https://github.com/qiaoxueshi/WWDC_2015_Video_Subtitle) - WWDC 2015 英文字幕
- [WWDC2015](https://github.com/6david9/WWDC2015) - WWDC2015下载链接

### Git SVN
- [Git常用命令清单](https://github.com/jaywcjlove/handbook/blob/master/other/Git%E5%B8%B8%E7%94%A8%E5%91%BD%E4%BB%A4%E6%B8%85%E5%8D%95.md#%E6%8A%A5%E9%94%99%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3)

### iOS安全
- [IosHackStudy](https://github.com/pandazheng/IosHackStudy) - IOS安全学习资料汇总

### 面试
- [iOSInterviewQuestions](https://github.com/ChenYilong/iOSInterviewQuestions) - iOS面试题集锦
- [chenyufeng-interview](http://blog.csdn.net/column/details/chenyufeng-interview.html) - iOS笔试面试题
- [Developer-Interview-Questions](https://github.com/lzyy/iOS-Developer-Interview-Questions) - iOS 开发面试问题
- [iOSInterviewQuestions](https://github.com/findM/iOSInterviewQuestions) - 搜集互联网上的iOS相关的面试题，并且给出详尽答案！
- [Accumulateknowledge](https://github.com/sunWaterMood/Accumulateknowledge/issues/1) - iOS面试题
- [常见面试题整理--计算机网络篇](https://zhuanlan.zhihu.com/p/24001696?refer=passer)、[常见面试题整理--操作系统篇](https://zhuanlan.zhihu.com/p/23755202?refer=passer)
- [iOS面试题大全-点亮你iOS技能树](http://www.jianshu.com/p/a3b61b2f6e66)
- [GetOfferSoldier](https://github.com/GetOfferSoldier/Objective-C) - 面试题总结

### 写作
- [Markdown - 简单的世界](https://wizardforcel.gitbooks.io/markdown-simple-world/)
- [Mac使用gitbook创建电子书](http://ppsheep.com/2016/10/25/Mac%E4%BD%BF%E7%94%A8gitbook%E5%88%9B%E5%BB%BA%E7%94%B5%E5%AD%90%E4%B9%A6/)
- [Gitbook 的使用和常用插件](http://zhaoda.net/2015/11/09/gitbook-plugins/)

### 设计
- [MakeIconsWithSketch](https://github.com/allenwong/MakeIconsWithSketch) Simple tutorials about how to make icons with Sketch.

### 工具
- [awesome-mac](https://github.com/imlifengfeng/awesome-mac) - 收集非常好用的Mac应用程序、软件以及工具
- [牛逼的ImageMagick](http://wenva.github.io/%E7%9F%A5%E8%AF%86%E5%9B%8A/2015/02/05/%E7%89%9B%E9%80%BC%E7%9A%84ImageMagick.html)
- [iOS APP图标一键生成](http://wenva.github.io/ios/2015/05/18/iOS-APP%E5%9B%BE%E6%A0%87%E4%B8%80%E9%94%AE%E7%94%9F%E6%88%90.html)
- [Awesome_API](https://github.com/marktony/Awesome_API) - 收集一些免费的API
