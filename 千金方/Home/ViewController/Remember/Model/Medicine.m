//
//  Medicine.m
//  千金方
//
//  Created by 周小伟 on 2017/2/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "Medicine.h"

@implementation Medicine

- (instancetype)initWithDic:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)medicineModeWithDict:(NSDictionary *)dict{
    return [[[self class]alloc]initWithDic:dict];
}

@end
