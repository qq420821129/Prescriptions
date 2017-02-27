//
//  XArrowItem.m
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XArrowItem.h"

@implementation XArrowItem

- (instancetype)initWithTitle:(NSString *)title andDestVC:(NSString *)destVC{
    if (self = [super initWithTitle:title]) {
        self.destVCName = destVC;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title andDestVC:(NSString *)destVC{
    return [[self alloc]initWithTitle:title andDestVC:destVC];
}

@end
