//
//  UIButton+Blocks.m
//  WaWaSchool
//
//  Created by ldp on 15/7/31.
//  Copyright (c) 2015年 Galaxy School. All rights reserved.
//

#import "UIButton+Blocks.h"

@implementation UIButton (Blocks)
static char overviewKey;
- (void)handleControlEvent:(UIControlEvents)event withBlock:(void (^)(UIButton *btn))block {
    
    // 关联对象方法
    // object:给哪个对象添加关联
    // key:被关联者的索引key
    // value:被关联者
    // policy:关联时采用的协议，有assign，retain，copy等协议，一般使用OBJC_ASSOCIATION_RETAIN_NONATOMIC
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    // 通过key 获取关联对象
    void (^block)(UIButton *btn) = objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block(sender);
    }
}
@end
