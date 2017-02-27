//
//  TabbarCoverView.m
//  千金方
//
//  Created by 周小伟 on 2017/1/17.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "TabbarCoverView.h"

@implementation TabbarCoverView

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, rect.size.width / 3.0, rect.size.height- 10);
    CGContextAddLineToPoint(ctx, rect.size.width / 3.0 * 2, rect.size.height - 10);
    CGContextSetLineWidth(ctx, 5);
    [[UIColor grayColor]set];
    CGContextStrokePath(ctx);
}

@end
