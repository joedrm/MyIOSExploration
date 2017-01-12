
/**
 *  使用说明:直接引入此.h文件即可
 *  在单例的声明中直接使用 SingletonH(methodName), 其中methodName是自定义的方法名
 *  在单例的实现中直接使用 SingletonM(methodName), 其中methodName是自定义的方法名
 */

// 抽宏(包括.h\.m文件),帮助实现单例模式(ARC 和 MRC 两种情况下的单例实现)

// .h 文件的实现(##代表拼接)
#define SingletonH(methodName) + (instancetype)shared##methodName;

// .m 文件的实现(\是让下面每行变为宏的一部分)
#if __has_feature(objc_arc)  // 是 ARC

#define SingletonM(methodName) \
static id _instance = nil; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
if (_instance == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
} \
return _instance; \
} \
\
- (instancetype)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super init]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##methodName \
{ \
return [[self alloc] init]; \
}

#else   // 不是 ARC

#define SingletonM(methodName) \
static id _instance = nil; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
if (_instance == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
} \
return _instance; \
} \
\
- (instancetype)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super init]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##methodName \
{ \
return [[self alloc] init]; \
} \
\
- (oneway void)release \
{ \
\
} \
\
- (instancetype)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return 1; \
}

#endif

