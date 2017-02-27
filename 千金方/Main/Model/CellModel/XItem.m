//
//  XItem.m
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XItem.h"

@implementation XItem

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        self.title = title;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title{
    return [[self alloc]initWithTitle:title];
}

@end
