//
//  TestViewController.m
//  RuntimeTest
//
//  Created by 李磊 on 2017/6/27.
//  Copyright © 2017年 李磊www. All rights reserved.
//

#import "TestViewController.h"
#import "UIButton+Blocks.h"
#import "Dog.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"点击执行未实现的方法，会crash" forState:UIControlStateNormal];
    btn.frame = CGRectMake(50, 100 ,self.view.frame.size.width - 100, 50);
    
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *btn) {
        Dog *dog = [Dog new];
        [dog performSelector:@selector(haha)];
    }];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"动态添加上面方法的实现" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(50, 300 ,self.view.frame.size.width - 100, 50);
    [self.view addSubview:btn1];
    
    [btn1 handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *btn) {
        
        // class: 给哪个类添加方法
        // SEL: 方法选择器，即调用时候的名称（只是一个编号）
        // IMP: 方法的实现（函数指针）
        // type: 方法类型，(返回值+隐式参数) v:void @对象->self :表示SEL->_cmd
        class_addMethod([Dog class], @selector(haha),(IMP)abc, "v@:");

    }];

    
}


// 任何方法默认都有两个隐式参数,self,_cmd
void abc(id self, SEL _cmd) {
    NSLog(@"哈哈大笑");
}


@end
