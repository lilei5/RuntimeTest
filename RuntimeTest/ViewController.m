//
//  ViewController.m
//  RuntimeTest
//
//  Created by 李磊 on 2017/3/6.
//  Copyright © 2017年 李磊www. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIButton+Blocks.h"
#import "Dog.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 需要先关闭 objc_msgSend 调用保护
    Dog *dog = [[Dog alloc] init];
 
    
    // 方法调用
    [dog run:100 street:@"大街上"];
    // 发送消息
    objc_msgSend(dog, @selector(run:street:),500,@"小路上");

    
    
}



/**
 获取成员属性列表
 */
- (void)getProPerList:(Class)class{

    unsigned int count = 0;
    NSMutableArray *nameArray = [NSMutableArray array];
    
    /**
     @param class 你想要检测的类  Class类型
     @param count 数组的个数
     @return 返回c语言数组  数组里元素是  objc_property_t 类型
     */
    objc_property_t *properList =  class_copyPropertyList(class,&count);
    for (int i = 0; i<count; i++) {
        const char *name =  property_getName(properList[i]);
        NSString *ocName = [NSString stringWithUTF8String:name];
        [nameArray addObject:ocName];
    }
    NSLog(@"属性名:%@",nameArray);

}

/**
 获取成员变量列表
 */
- (void)getIvarList:(Class)class{
    unsigned int count = 0;
    NSMutableArray *nameArray = [NSMutableArray array];
    NSMutableArray *typeArray = [NSMutableArray array];
    /**
     @param class 你想要检测的类  Class类型
     @param count 数组的个数
     @return 返回c语言数组  数组里元素是  Ivar 类型
     */
    Ivar *vars = class_copyIvarList(class, &count);
    for (int i = 0; i<count; i++) {
        
        const char *name = ivar_getName(vars[i]);
        const char *type = ivar_getTypeEncoding(vars[i]);
        NSString *ocName = [NSString stringWithUTF8String:name];
        NSString *ocType = [NSString stringWithUTF8String:type];
        [nameArray addObject:ocName];
        [typeArray addObject:ocType];
        
        /*
         类型说明：基本类型 q：NSInteger   d:double   f:float  i:int  c:BOOL
         引用类型:以字符串显示  如：NSString："NSString"  NSArray:"NSArray"
         不同类型编码请参考：
         https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
         */
        
    }
    NSLog(@"变量名：%@-----变量类型：%@",nameArray,typeArray);
    
}



/**
 获取实例方法列表  类方法用class_getClassMethod
 */
- (void)getMethodList:(Class)class{
    unsigned int count = 0;
    NSMutableArray *methodArray = [NSMutableArray array];
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0 ; i<count; i++) {
        NSMutableDictionary *methodDic = [NSMutableDictionary dictionary];
        // 方法名
        SEL method = method_getName(methodList[i]);
        // 返回类型
        const char *returnTypeName = method_copyReturnType(methodList[i]);
        // 参数个数  默认会多两个  第一个接受消息的对象  第二个selector  原因:objc_msgSend(id, SEL)
        int argumentCount = method_getNumberOfArguments(methodList[i]);
        methodDic[@"methodName"] = NSStringFromSelector(method);
        methodDic[@"returnType"] = [NSString stringWithUTF8String:returnTypeName];
        for (int j = 0; j<argumentCount; j++) {
            NSString *key = [NSString stringWithFormat:@"param%i",j+1];
            methodDic[key] = [NSString stringWithUTF8String:method_copyArgumentType(methodList[i], j)];
        }
        [methodArray addObject:methodDic];
        
    }
    //  @对象类型  v为void   :为selector
    NSLog(@"%@",methodArray);

}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0://动态获取成员属性
            [self getProPerList:[Dog class]];
            break;
        case 1://动态获得成员变量
            [self getIvarList:[Dog class]];
            break;
        case 2://动态获得成员变量
            [self getMethodList:[Dog class]];
            break;
        case 3://动态添加方法实现
        {
            TestViewController *nextVc = [[TestViewController alloc] init];
            [self.navigationController pushViewController:nextVc animated:YES];
        }
            break;
        default:
            break;
    }

}


@end
