//
//  Dog.h
//  RuntimeTest
//
//  Created by 李磊 on 2017/3/6.
//  Copyright © 2017年 李磊www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject<NSCoding>
{
    float _weight;
}

@property(nonatomic,copy) NSString *name;

- (NSString *)run:(NSInteger)runLong street:(NSString *)streetName;

@end
