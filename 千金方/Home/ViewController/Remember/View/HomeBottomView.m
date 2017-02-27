//
//  HomeBottomView.m
//  千金方
//
//  Created by 周小伟 on 2017/2/1.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "HomeBottomView.h"

@interface HomeBottomView ()

@property (nonatomic,weak)UIButton *previousBtn;

@property (nonatomic,weak)UIButton *rememberBtn;

@property (nonatomic,weak)UIButton *nextBtn;

@end

@implementation HomeBottomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    [[UIColor blackColor]set];
    CGContextMoveToPoint(ctx, 1, 1);
    CGContextAddLineToPoint(ctx, rect.size.width, 1);
    CGContextStrokePath(ctx);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self startSetup];
    }
    return self;
}

- (void)startSetup{
    self.backgroundColor = [UIColor clearColor];
    UIButton *preBtn = [self addBtnWithTitle:@"上一个" action:@selector(previousClick:)];
    self.previousBtn = preBtn;
    
    UIButton *remBtn = [self addBtnWithTitle:@"背诵" action:@selector(rememberClick:)];
    self.rememberBtn = remBtn;
    
    UIButton *nextBtn = [self addBtnWithTitle:@"下一个" action:@selector(nextOneClick:)];
    self.nextBtn = nextBtn;
    
}

- (UIButton *)addBtnWithTitle:(NSString *)title action:(SEL)action{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)previousClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(homeBottomView:clickPrevious:)]) {
        [self.delegate homeBottomView:self clickPrevious:button];
    }
}

- (void)rememberClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(homeBottomView:clickRemember:)]) {
        [self.delegate homeBottomView:self clickRemember:button];
    }
}

- (void)nextOneClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(homeBottomView:clickNextOne:)]) {
        [self.delegate homeBottomView:self clickNextOne:button];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.previousBtn edgeInsetWithString:@"|-1/3w-|-1h-"];
    [self.previousBtn edgeInsetWithString:@"|-TT-|-TL|"];
    
    [self.rememberBtn edgeInsetWithString:@"|-1/3w-|-1h-|"];
    [self.rememberBtn edgeInsetWithString:@"|-CX-|-CY-|"];
    
    [self.nextBtn edgeInsetWithString:@"|-1/3w-|-1h-|-TT-|-TR-|"];
}


@end
