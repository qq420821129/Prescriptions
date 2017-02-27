//
//  CenterButton.m
//  千金方
//
//  Created by 周小伟 on 2017/2/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "CenterButton.h"

@implementation CenterButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.height > 0) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGFloat radius = self.height/2.0f + (rect.size.width) * (rect.size.width) / (8 * self.height);
        radius = (radius > rect.size.width / 2.0) ? radius: (rect.size.width / 2.0);
        CGContextAddArc(ctx, rect.size.width/2.0f, radius, radius, 0, 2 * M_PI, 0);
        [[UIColor orangeColor]set];
        CGContextFillPath(ctx);
    }
    
}



- (void)setHeight:(CGFloat)height{
    _height = height;
    if (height > 0) {
        [self setNeedsDisplay];
    }
}

@end
