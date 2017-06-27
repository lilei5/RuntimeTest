//
//  Dog.m
//  RuntimeTest
//
//  Created by 李磊 on 2017/3/6.
//  Copyright © 2017年 李磊www. All rights reserved.
//

#import "Dog.h"
#import <objc/runtime.h>


@interface Dog ()
{
    NSInteger  _age;
}
@property(nonatomic,copy) NSString *address;
@end

@implementation Dog

+(void)load{
     Method orginMethod = class_getInstanceMethod([Dog class], @selector(run:street:));
     Method myMethod = class_getInstanceMethod([Dog class], @selector(myRun:street:));
    method_exchangeImplementations(orginMethod, myMethod);
}

- (NSString *)myRun:(NSInteger)runLong street:(NSString *)streetName{
    NSLog(@"交换方法了");
    return nil;
}


- (NSString *)run:(NSInteger)runLong street:(NSString *)streetName{
     NSLog(@"在%@跑了%li米",streetName,runLong);
    return nil;
}
- (void)_sleep{
     NSLog(@"%s",__func__);
}


// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    // 遍历,对父类的属性执行归档方法
    Class c = self.class;
    while (c &&c != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            // 通过KVC取值
            id value = [self valueForKeyPath:key];
            [aCoder encodeObject:value forKey:key];
        }
        
        free(ivars);
        c = [c superclass];
    }
}

// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =  [super init]) {
        // 遍历，对父类的属性执行解档方法
        Class c = self.class;
        while (c &&c != [NSObject class]) {
            unsigned int outCount = 0;
            Ivar *ivars = class_copyIvarList(c, &outCount);
            for (int i = 0; i < outCount; i++) {
                Ivar ivar = ivars[i];
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                id value = [aDecoder decodeObjectForKey:key];
                [self setValue:value forKey:key];
            }
            free(ivars);
            c = [c superclass];
        }

    }
    return self;
}


@end
