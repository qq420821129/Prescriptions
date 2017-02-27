//
//  NavigationView.m
//  千金方
//
//  Created by 周小伟 on 2017/1/18.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 0, rect.size.height - 0.5);
    CGContextSetLineWidth(ctx, 1);
    [[UIColor grayColor]set];
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height - 0.5);
    CGContextStrokePath(ctx);
}


@end
