//
//  UIButton+Blocks.h
//  WaWaSchool
//
//  Created by ldp on 15/7/31.
//  Copyright (c) 2015年 Galaxy School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>


@interface UIButton (Blocks)
- (void)handleControlEvent:(UIControlEvents)event withBlock:(void (^)(UIButton *btn))block;
@end
