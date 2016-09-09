
## GCD

使用Crearte函数创建的并发队列和全局并发队列的主要区别：

1. 全局并发队列在整个应用程序中本身是默认存在的，并且对应有高优先级、默认优先级、低优先级和后台优先级一共四个并发队列，我们只是选择其中的一个直接拿来用。而Crearte函数是实打实的从头开始去创建一个队列。
2. 在iOS6.0之前，在GCD中凡是使用了带Create和retain的函数在最后都需要做一次release操作。而主队列和全局并发队列不需要我们手动release。当然了，在iOS6.0之后GCD已经被纳入到了ARC的内存管理范畴中，即便是使用retain或者create函数创建的对象也不再需要开发人员手动释放，我们像对待普通OC对象一样对待GCD就OK。
3. 在使用栅栏函数的时候，苹果官方明确规定栅栏函数只有在和使用create函数自己的创建的并发队列一起使用的时候才有效（没有给出具体原因）
4. 其它区别涉及到XNU内核的系统级线程编程，不一一列举。
5. 给出一些参考资料（可以自行研究）：[GCDAPI](https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html#//apple_ref/c/func/dispatch_queue_create)、[Libdispatch版本源码](http://www.opensource.apple.com/source/libdispatch/libdispatch-187.5/)

单例模式实现：

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
