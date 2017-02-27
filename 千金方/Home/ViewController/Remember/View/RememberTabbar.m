//
//  RememberTabbar.m
//  千金方
//
//  Created by 周小伟 on 2017/2/3.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "RememberTabbar.h"

@interface RememberTabbar ()

@property (nonatomic,weak) UIButton *firstBtn;

@property (nonatomic,weak) UIButton *secondBtn;

@property (nonatomic,weak) UIButton *thirdBtn;

@end

@implementation RememberTabbar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, 0, 1);
    CGContextAddLineToPoint(ctx, rect.size.width, 1);
    [[UIColor blackColor]set];
    CGContextStrokePath(ctx);
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setup{
    UIButton *firstBtn = [self createBtnWithTitle:@"上一个" andSelector:@selector(previousClick:)];
    self.firstBtn = firstBtn;
    
    UIButton *secondBtn = [self createBtnWithTitle:@"背诵" andSelector:@selector(rememberClick:)];
    self.firstBtn = secondBtn;
    
    UIButton *thirdBtn = [self createBtnWithTitle:@"下一个" andSelector:@selector(nextClick:)];
    self.firstBtn = thirdBtn;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        view.frame = CGRectMake(view.tag * self.bounds.size.width / 3.0, 0, self.bounds.size.width / 3.0, self.bounds.size.height);
    }

}

- (UIButton *)createBtnWithTitle:(NSString *)title andSelector:(SEL)action{
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.tag = self.subviews.count;
    [self addSubview:button];
    return button;
}

- (void)previousClick:(UIButton *)button{
    [[NSNotificationCenter defaultCenter]postNotificationName:kPreviousClickNotificationName object:nil];
}

- (void)nextClick:(UIButton *)button{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNextClickNotificationName object:nil];
}

- (void)rememberClick:(UIButton *)button{
    [[NSNotificationCenter defaultCenter]postNotificationName:kRememberClickNotificationName object:nil];
}



@end
