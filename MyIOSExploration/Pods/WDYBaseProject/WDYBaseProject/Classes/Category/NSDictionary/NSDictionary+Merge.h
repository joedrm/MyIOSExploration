
#import <Foundation/Foundation.h>

@interface NSDictionary (Merge)

/** 合并两个NSDictionary */
+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;

/** 并入一个NSDictionary */
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict;

#pragma mark - Manipulation
- (NSDictionary *)dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryByRemovingEntriesWithKeys:(NSSet *)keys;

@end
