//
//  UnDashLine.m
//  千金方
//
//  Created by 周小伟 on 2017/2/1.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "UnDashLine.h"

@implementation UnDashLine

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 0, 1);
    CGContextAddLineToPoint(ctx, rect.size.width, 1);
    CGContextSetLineWidth(ctx, 2);
    [[UIColor blackColor]set];
    CGContextStrokePath(ctx);
}


- (instancetype)init{
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, ScreenSize.width, 2);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
