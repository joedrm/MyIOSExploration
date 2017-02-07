
#import "SafeCategory.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

#define LOG_Error {if(error)NSLog(@"%@",error.debugDescription);error = nil;}
// NSArray 分类
@interface NSArray(SafeCategory)
-(id)safeObjectAtIndex:(int)index;
-(id)safeInitWithObjects:(const id [])objects count:(NSUInteger)cnt;
@end

// NSMutableArray 分类
@interface NSMutableArray(SafeCategory)
-(void)safeAddObject:(id)anObject;
@end

// NSDictionary 分类
@interface NSDictionary(SafeCategory)
-(id)safeObjectForKey:(id)aKey;
@end

// NSMutableDictionary 分类
@interface NSMutableDictionary(SafeCategory)
-(void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end


@implementation NSArray(SafeCategory)
-(id)safeObjectAtIndex:(int)index{
    if(index>=0 && index < self.count)
    {
        return [self safeObjectAtIndex:index];
    }
    return nil;
}
-(id)safeInitWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    for (int i=0; i<cnt; i++) {
        if(objects[i] == nil)
            return nil;
    }
    
    return [self safeInitWithObjects:objects count:cnt];
}
@end


@implementation NSMutableArray(SafeCategory)
-(void)safeAddObject:(id)anObject
{
    if(anObject != nil){
        [self safeAddObject:anObject];
    }
}
@end


@implementation NSDictionary(SafeCategory)
-(id)safeObjectForKey:(id)aKey
{
    if(aKey == nil)
        return nil;
    id value = [self safeObjectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
@end

@implementation NSMutableDictionary(SafeCategory)
-(void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if(anObject == nil || aKey == nil)
        return;
    
    [self safeSetObject:anObject forKey:aKey];
}
@end

@interface NSURL(SafeCategory)
@end;
@implementation NSURL(SafeCategory)
+(id)safeFileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir
{
    if(path == nil)
        return nil;
    
    return [self safeFileURLWithPath:path isDirectory:isDir];
}
@end
@interface NSFileManager(SafeCategory)

@end


@implementation NSFileManager(SafeCategory)
-(NSDirectoryEnumerator *)safeEnumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *, NSError *))handler
{
    if(url == nil)
        return nil;
    
    return [self safeEnumeratorAtURL:url includingPropertiesForKeys:keys options:mask errorHandler:handler];
}
@end


@implementation SafeCategory
+(void)callSafeCategory
{
    NSError* error = nil;
    [objc_getClass("__NSPlaceholderArray") jr_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(safeInitWithObjects:count:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSArrayI") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:) error:&error];
    LOG_Error
    [objc_getClass("__NSArrayM") jr_swizzleMethod:@selector(addObject:) withMethod:@selector(safeAddObject:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSDictionaryI") jr_swizzleMethod:@selector(objectForKey:) withMethod:@selector(safeObjectForKey:) error:&error];
    LOG_Error
    
    [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(objectForKey:) withMethod:@selector(safeObjectForKey:) error:&error];
    LOG_Error
    [objc_getClass("__NSDictionaryM") jr_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(safeSetObject:forKey:) error:&error];
    LOG_Error
    
    
    [NSURL jr_swizzleClassMethod:@selector(fileURLWithPath:isDirectory:) withClassMethod:@selector(safeFileURLWithPath:isDirectory:) error:&error];
    LOG_Error
    
    [NSFileManager jr_swizzleMethod:@selector(enumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) withMethod:@selector(safeEnumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) error:&error];
    LOG_Error
}
@end
