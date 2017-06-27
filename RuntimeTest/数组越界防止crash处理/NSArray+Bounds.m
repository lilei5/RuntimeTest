//
//  NSArray+Bounds.m
//  internationalStudy
//
//  Created by lilei on 16/11/1.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import "NSArray+Bounds.h"
#import <objc/runtime.h>

@implementation NSArray (Bounds)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            /*__NSArray0：空数组 
             __NSSingleObjectArrayI：只有一个元素的数组
             __NSArrayI: 不可变数组
             __NSArrayM: 可变数组
             */
            [self exchangeMethodWithClass:objc_getClass("__NSArray0") orginSelector:@selector(objectAtIndex:) customSelector:@selector(emptyObjectIndex:)];
            [self exchangeMethodWithClass:objc_getClass("__NSSingleObjectArrayI") orginSelector:@selector(objectAtIndex:) customSelector:@selector(singleArrObjectIndex:)];
            [self exchangeMethodWithClass:objc_getClass("__NSArrayI") orginSelector:@selector(objectAtIndex:) customSelector:@selector(arrObjectIndex:)];
            [self exchangeMethodWithClass:objc_getClass("__NSArrayM") orginSelector:@selector(objectAtIndex:) customSelector:@selector(mutableObjectIndex:)];
            [self exchangeMethodWithClass:objc_getClass("__NSArrayM") orginSelector:@selector(insertObject:atIndex:) customSelector:@selector(mutableInsertObject:atIndex:)];
        }
    });
}

+ (void)exchangeMethodWithClass:(Class)class orginSelector:(SEL)orginS customSelector:(SEL)customS{
    Method orginMethod = class_getInstanceMethod(class, orginS);
    Method customMethod = class_getInstanceMethod(class, customS);
    method_exchangeImplementations(orginMethod, customMethod);
}

- (id)emptyObjectIndex:(NSInteger)index{
    return nil;
}

- (id)singleArrObjectIndex:(NSInteger)index{
    @autoreleasepool {
        if (index >= self.count || index < 0) {
            return nil;
        }
        return [self singleArrObjectIndex:index];
    }
}

- (id)arrObjectIndex:(NSInteger)index{
    @autoreleasepool {
        if (index >= self.count || index < 0) {
            return nil;
        }
        return [self arrObjectIndex:index];
    }
}

- (id)mutableObjectIndex:(NSInteger)index{
    @autoreleasepool {
        if (index >= self.count || index < 0) {
            return nil;
        }
        return [self mutableObjectIndex:index];
    }
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    @autoreleasepool {
        if (object) {
            [self mutableInsertObject:object atIndex:index];
        }
    }
}
- (id)myObjectAtIndex:(NSUInteger)index
{
    @autoreleasepool {
        if (index < self.count) {
            return [self myObjectAtIndex:index];
        } else {
            return nil;
        }
    }
}





@end
