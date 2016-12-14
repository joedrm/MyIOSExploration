1. 字面意思: 运行循环 跑圈

2. 基本作用（作用重大）
    * 保持程序的持续运行(ios程序为什么能一直活着不会死)
	* 处理app中的各种事件（比如触摸事件、定时器事件【NSTimer】、selector事件【选择器·performSelector···】）
	* 节省CPU资源，提高程序性能，有事情就做事情，没事情就休息

3. 重要说明
    
    * 如果没有Runloop,那么程序一启动就会退出，什么事情都做不了。
    * 如果有了Runloop，那么相当于在内部有一个死循环，能够保证程序的持续运行
    * main函数中的Runloop
       - 在UIApplication函数内部就启动了一个Runloop
       - 该函数返回一个int类型的值
    * 这个默认启动的Runloop是跟主线程相关联的

4. Runloop对象
    
    * 在iOS开发中有两套api来访问Runloop
       - foundation框架【NSRunloop】
       - core foundation框架【CFRunloopRef】
    * NSRunLoop和CFRunLoopRef都代表着RunLoop对象,它们是等价的，可以互相转换
    * NSRunLoop是基于CFRunLoopRef的一层OC包装，所以要了解RunLoop内部结构，需要多研究CFRunLoopRef层面的API（Core Foundation层面）

5. Runloop与线程
    * Runloop和线程的关系：一个Runloop对应着一条唯一的线程
    		* 问题：如何让子线程不死
    		* 回答：给这条子线程开启一个Runloop
	* Runloop的创建：主线程Runloop已经创建好了，子线程的runloop需要手动创建
	* Runloop的生命周期：在第一次获取时创建，在线程结束时销毁

6. 获得Runloop对象

```objc
1.获得当前Runloop对象
    //01 NSRunloop
     NSRunLoop * runloop1 = [NSRunLoop currentRunLoop];
    //02 CFRunLoopRef
    CFRunLoopRef runloop2 =   CFRunLoopGetCurrent();

2.拿到当前应用程序的主Runloop（主线程对应的Runloop）
    //01 NSRunloop
     NSRunLoop * runloop1 = [NSRunLoop mainRunLoop];
    //02 CFRunLoopRef
     CFRunLoopRef runloop2 =   CFRunLoopGetMain();

3.注意点：开一个子线程创建runloop,不是通过alloc init方法创建，而是直接通过调用currentRunLoop方法来创建，它本身是一个懒加载的。
4.在子线程中，如果不主动获取Runloop的话，那么子线程内部是不会创建Runloop的。可以下载CFRunloopRef的源码，搜索_CFRunloopGet0,查看代码。
5.Runloop对象是利用字典来进行存储，而且key是对应的线程Value为该线程对应的Runloop。

```


7. Runloop相关类

* Runloop运行原理图

![Runloop运行原理图](http://ohgbgkbn4.bkt.clouddn.com/Runloop%E8%BF%90%E8%A1%8C%E5%8E%9F%E7%90%86%E5%9B%BE.png)

* 五个相关的类

```objc
	CFRunloopRef
	CFRunloopModeRef // Runloop的运行模式
	CFRunloopSourceRef // Runloop要处理的事件源
	CFRunloopTimerRef // Timer事件
	CFRunloopObserverRef //Runloop的观察者（监听者）
```

* Runloop和相关类之间的关系图

 ![Runloop和相关类之间的关系图](http://ohgbgkbn4.bkt.clouddn.com/Runloop%E5%92%8C%E7%9B%B8%E5%85%B3%E7%B1%BB%E4%B9%8B%E9%97%B4%E7%9A%84%E5%85%B3%E7%B3%BB%E5%9B%BE.png)

* Runloop要想跑起来，它的内部必须要有一个mode,这个mode里面必须有source\observer\timer，至少要有其中的一个。

* CFRunloopModeRef

    * CFRunloopModeRef代表着Runloop的运行模式
    * 一个Runloop中可以有多个mode,一个mode里面又可以有多个source\observer\timer等等
    * 每次runloop启动的时候，只能指定一个mode,这个mode被称为该Runloop的当前mode
    * 如果需要切换mode,只能先退出当前Runloop,再重新指定一个mode进入
    * 这样做主要是为了分割不同组的定时器等，让他们相互之间不受影响
    * 系统默认注册了5个mode
    	* kCFRunLoopDefaultMode：App的默认Mode，通常主线程是在这个Mode下运行
        * UITrackingRunLoopMode：界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
        * UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用
        * GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到
        * kCFRunLoopCommonModes: 这是一个占位用的Mode，不是一种真正的Mode


* CFRunloopTimerRef

    * NSTimer相关代码
    
```objc
/*
	说明：
	（1）runloop一启动就会选中一种模式，当选中了一种模式之后其它的模式就都不鸟。一个mode里面可以添加多个NSTimer,也就是说以后当创建NSTimer的时候，可以指定它是在什么模式下运行的。
	（2）它是基于时间的触发器，说直白点那就是时间到了我就触发一个事件，触发一个操作。基本上说的就是NSTimer
	（3）相关代码
*/
- (void)timer2
{
    //NSTimer 调用了scheduledTimer方法，那么会自动添加到当前的runloop里面去，而且runloop的运行模式kCFRunLoopDefaultMode

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];

    //更改模式
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

}

- (void)timer1
{
    //    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];

    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];

    //定时器添加到UITrackingRunLoopMode模式，一旦runloop切换模式，那么定时器就不工作
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];

    //定时器添加到NSDefaultRunLoopMode模式，一旦runloop切换模式，那么定时器就不工作
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    //占位模式：common modes标记
    //被标记为common modes的模式 kCFRunLoopDefaultMode  UITrackingRunLoopMode
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    //    NSLog(@"%@",[NSRunLoop currentRunLoop]);
}

- (void)run
{
    NSLog(@"---run---%@",[NSRunLoop currentRunLoop].currentMode);
}

- (IBAction)btnClick {

    NSLog(@"---btnClick---");
}

```

  * GCD中的定时器
 
```objc
//0.创建一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    //1.创建一个GCD的定时器
    /*
     第一个参数：说明这是一个定时器
     第四个参数：GCD的回调任务添加到那个队列中执行，如果是主队列则在主线程执行
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    //2.设置定时器的开始时间，间隔时间以及精准度

    //设置开始时间，三秒钟之后调用
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW,3.0 *NSEC_PER_SEC);
    //设置定时器工作的间隔时间
    uint64_t intevel = 1.0 * NSEC_PER_SEC;

    /*
     第一个参数：要给哪个定时器设置
     第二个参数：定时器的开始时间DISPATCH_TIME_NOW表示从当前开始
     第三个参数：定时器调用方法的间隔时间
     第四个参数：定时器的精准度，如果传0则表示采用最精准的方式计算，如果传大于0的数值，则表示该定时切换i可以接收该值范围内的误差，通常传0
     该参数的意义：可以适当的提高程序的性能
     注意点：GCD定时器中的时间以纳秒为单位（面试）
     */

    dispatch_source_set_timer(timer, start, intevel, 0 * NSEC_PER_SEC);

    //3.设置定时器开启后回调的方法
    /*
     第一个参数：要给哪个定时器设置
     第二个参数：回调block
     */
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"------%@",[NSThread currentThread]);
    });

    //4.执行定时器
    dispatch_resume(timer);

    //注意：dispatch_source_t本质上是OC类，在这里是个局部变量，需要强引用
    self.timer = timer;

GCD定时器补充
/*
 DISPATCH_SOURCE_TYPE_TIMER         定时响应（定时器事件）
 DISPATCH_SOURCE_TYPE_SIGNAL        接收到UNIX信号时响应

 DISPATCH_SOURCE_TYPE_READ          IO操作，如对文件的操作、socket操作的读响应
 DISPATCH_SOURCE_TYPE_WRITE         IO操作，如对文件的操作、socket操作的写响应
 DISPATCH_SOURCE_TYPE_VNODE         文件状态监听，文件被删除、移动、重命名
 DISPATCH_SOURCE_TYPE_PROC          进程监听,如进程的退出、创建一个或更多的子线程、进程收到UNIX信号

 下面两个都属于Mach相关事件响应
    DISPATCH_SOURCE_TYPE_MACH_SEND
    DISPATCH_SOURCE_TYPE_MACH_RECV
 下面两个都属于自定义的事件，并且也是有自己来触发
    DISPATCH_SOURCE_TYPE_DATA_ADD
    DISPATCH_SOURCE_TYPE_DATA_OR
 */
```

* CFRunloopSourceRef

    * 是事件源也就是输入源，有两种分类模式；
    	  一种是按照苹果官方文档进行划分的
    	  另一种是基于函数的调用栈来进行划分的（source0和source1）。
    * 具体的分类情况
        * 以前的分法
                Port-Based Sources
                Custom Input Sources
                Cocoa Perform Selector Sources
        * 现在的分法
                Source0：非基于Port的
                Source1：基于Port的
        3.可以通过打断点的方式查看一个方法的函数调用栈

* CFRunLoopObserverRef

 1. CFRunLoopObserverRef是观察者，能够监听RunLoop的状态改变

 2. 如何监听
 
```objc
 //创建一个runloop监听者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(),kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {

        NSLog(@"监听runloop状态改变---%zd",activity);
    });

    //为runloop添加一个监听者
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);

    CFRelease(observer);
```
    
 3. 监听的状态

```objc
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry = (1UL << 0),   //即将进入Runloop
    kCFRunLoopBeforeTimers = (1UL << 1),    //即将处理NSTimer
    kCFRunLoopBeforeSources = (1UL << 2),   //即将处理Sources
    kCFRunLoopBeforeWaiting = (1UL << 5),   //即将进入休眠
    kCFRunLoopAfterWaiting = (1UL << 6),    //刚从休眠中唤醒
    kCFRunLoopExit = (1UL << 7),            //即将退出runloop
    kCFRunLoopAllActivities = 0x0FFFFFFFU   //所有状态改变
};
```

8. Runloop运行逻辑

-
![Runloop事件队列](http://ohgbgkbn4.bkt.clouddn.com/Runloop%E4%BA%8B%E4%BB%B6%E9%98%9F%E5%88%97.png)

--------------------
![Runloop运行逻辑](http://ohgbgkbn4.bkt.clouddn.com/Runloop%E8%BF%90%E8%A1%8C%E9%80%BB%E8%BE%91.png)

---


9. Runloop应用

    1）NSTimer
    2）ImageView显示：控制方法在特定的模式下可用
    3）PerformSelector
    4）常驻线程：在子线程中开启一个runloop
    5）自动释放池
        第一次创建：进入runloop的时候
        最后一次释放：runloop退出的时候
        其它创建和释放：当runloop即将休眠的时候会把之前的自动释放池释放，然后重新创建一个新的释放池

---



10. Runloop参考资料
    * [苹果官方文档](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html)
    * [深入理解RunLoop](http://blog.ibireme.com/2015/05/18/runloop/) - YY大牛的文章
    * [Cocoa深入学习:NSOperationQueue、NSRunLoop和线程安全](https://blog.cnbluebox.com/blog/2014/07/01/cocoashen-ru-xue-xi-nsoperationqueuehe-nsoperationyuan-li-he-shi-yong/)




