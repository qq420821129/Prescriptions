//
//  PartView.m
//  千金方
//
//  Created by 周小伟 on 2017/2/1.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "PartView.h"

@interface PartView ()

@property (nonatomic,weak) UILabel *titleLabel;

@property (nonatomic,weak) UILabel *contentLabel;

@property (nonatomic,weak) UITextField *textField;

@end

@implementation PartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 0, 1);
    CGContextAddLineToPoint(ctx, rect.size.width, 1);
    CGContextSetLineWidth(ctx, 2);
    [[UIColor blackColor]set];
    CGContextStrokePath(ctx);
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
}

@end
