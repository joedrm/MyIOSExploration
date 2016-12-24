
## GCD总结


### 几个概念：
 串行队列：在队列中，采用先进先出（FIFO）的方式从RunLoop取出任务
 并行队行：同样，在并行队列当中，依然也是采用先进先出(FIFO)的方式从RunLoop取出来
 
 异步执行：不会阻塞当前线程
 同步执行：会阻塞当前线程，直到当前的block任务执行完毕
 
 1. 同步和异步决定了是否开启新的线程。main队列除外，在main队列中，同步或者异步执行都会阻塞当线的main线程，且不会另开线程。当然，永远不要使用sync向主队列中添加任务，这样子会线程卡死，具体原因看main线程
 2. 串行和并行，决定了任务是否同时执行。
 
 [](gcd_image.png)
 
### 主队列（main queue）的四种通用调度队列
 * QOS_CLASS_USER_INTERACTIVE：user interactive等级表示任务需要被立即执行提供好的体验，用来更新UI，响应事件等。这个等级最好保持小规模。
 * QOS_CLASS_USER_INITIATED：user initiated等级表示任务由UI发起异步执行。适用场景是需要及时结果同时又可以继续交互的时候。
 * QOS_CLASS_UTILITY：utility等级表示需要长时间运行的任务，伴有用户可见进度指示器。经常会用来做计算，I/O，网络，持续的数据填充等任务。这个任务节能。
 * QOS_CLASS_BACKGROUND：background等级表示用户不会察觉的任务，使用它来处理预加载，或者不需要用户交互和对时间不敏感的任务。

### 何时使用何种队列类型

 1. 主队列（顺序）：队列中有任务完成需要更新UI时，dispatch_after在这种类型中使用。
 2. 并发队列：用来执行与UI无关的后台任务，dispatch_sync放在这里，方便等待任务完成进行后续处理或和dispatch barrier同步。dispatch groups放在这里也不错。
 3. 自定义顺序队列：顺序执行后台任务并追踪它时。这样做同时只有一个任务在执行可以防止资源竞争。dipatch barriers解决读写锁问题的放在这里处理。dispatch groups也是放在这里。
 
 
### 使用Crearte函数创建的并发队列和全局并发队列的主要区别：
 
 1. 全局并发队列在整个应用程序中本身是默认存在的，并且对应有高优先级、默认优先级、低优先级和后台优先级一共四个并发队列，我们只是选择其中的一个直接拿来用。而Crearte函数是实打实的从头开始去创建一个队列。
 2. 在iOS6.0之前，在GCD中凡是使用了带Create和retain的函数在最后都需要做一次release操作。而主队列和全局并发队列不需要我们手动release。当然了，在iOS6.0之后GCD已经被纳入到了ARC的内存管理范畴中，即便是使用retain或者create函数创建的对象也不再需要开发人员手动释放，我们像对待普通OC对象一样对待GCD就OK。
 3. 在使用栅栏函数的时候，苹果官方明确规定栅栏函数只有在和使用create函数自己的创建的并发队列一起使用的时候才有效（没有给出具体原因）
 4. 其它区别涉及到XNU内核的系统级线程编程，不一一列举。
 5. 给出一些参考资料（可以自行研究）：[GCDAPI](https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html#//apple_ref/c/func/dispatch_queue_create)、[Libdispatch版本源码](http://www.opensource.apple.com/source/libdispatch/libdispatch-187.5/)
 
### GCD和NSOperationQueue的区别：
 
 1. GCD是底层的C语言构成的API，而NSOperationQueue及相关对象是Objc的对象。在GCD中，在队列中执行的是由block构成的任务，这是一个轻量级的数据结构；而Operation作为一个对象，为我们提供了更多的选择；
 2. 在NSOperationQueue中，我们可以随时取消已经设定要准备执行的任务(当然，已经开始的任务就无法阻止了)，而GCD没法停止已经加入queue的block(其实是有的，但需要许多复杂的代码)；
 3. NSOperation能够方便地设置依赖关系，我们可以让一个Operation依赖于另一个Operation，这样的话尽管两个Operation处于同一个并行队列中，但前者会直到后者执行完毕后再执行；
 4. 我们能将KVO应用在NSOperation中，可以监听一个Operation是否完成或取消，这样子能比GCD更加有效地掌控我们执行的后台任务；
 5. 在NSOperation中，我们能够设置NSOperation的priority优先级，能够使同一个并行队列中的任务区分先后地执行，而在GCD中，我们只能区分不同任务队列的优先级，如果要区分block任务的优先级，也需要大量的复杂代码；
 6. 我们能够对NSOperation进行继承，在这之上添加成员变量与成员方法，提高整个代码的复用度，这比简单地将block任务排入执行队列更有自由度，能够在其之上添加更多自定制的功能。
 
### 单例模式实现：


```
/*
 1、提供一个static修饰全局的静态变量：static SingleTool* _instance;
 2、重写allocWithZone:方法，采用GCD中的dispatch_once_t创建一个线程安全的实例
 3、提供一个类方法，方便外界来访问
 4、重写 copyWithZone:(NSZone *)zone 和 mutableCopyWithZone:(NSZone *)zone方法
 */
// GCD来实现
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    // 本身线程就是安全的
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareInstance
{
    return [[self alloc] init];
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

// ------ MRC环境下
// 重写 release retain 和  retainCount方法
/*
- (oneway void)release
{
    return _instance;
}

- (oneway void)retain
{
    return _instance;
}

- (oneway void)retainCount
{
    return _instance;
}＊/
```
 
### 参考资料：
 
- [iOS多线程之GCD](http://www.jianshu.com/p/456672967e75)
- [iOS笔记(一)GCD多线程：信号量和条件锁](https://my.oschina.net/u/2436242/blog/518318)
- [细说GCD（Grand Central Dispatch）如何用](http://www.jianshu.com/p/fbe6a654604c)
- [Facebook开源的Parse源码分析【系列】](https://github.com/ChenYilong/ParseSourceCodeStudy)




