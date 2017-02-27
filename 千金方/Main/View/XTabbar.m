//
//  XTabbar.m
//  千金方
//
//  Created by 周小伟 on 2017/1/16.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XTabbar.h"
#import "XTabbarButton.h"
#import "TabbarCoverView.h"
#import "CenterButton.h"
@interface XTabbar ()
@property (nonatomic,strong) NSMutableArray *tabbarButtons;

@property (nonatomic,weak) UIButton *currentSelectBtn;
@property (nonatomic,weak) CenterButton *bigBtn;
@property (nonatomic,assign) CGRect coverFrame;

@end

@implementation XTabbar

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
    CGContextSetLineWidth(ctx, 2);
    [[UIColor darkGrayColor]set];
    CGContextStrokePath(ctx);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor myGrayColor];
    [self addBigButton];
}

- (void)addBigButton{
    CenterButton *button = [[CenterButton alloc]init];
    [button setTitle:@"匹配药方" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag = 999;
    [button addTarget:self action:@selector(bigBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.bigBtn = button;
}

- (void)bigBtnClick:(UIButton *)button{
//    NSLog(@"%@",button.currentTitle);
    self.currentSelectBtn = button;
    [self coverViewAnimation];
    if ([self.delegate respondsToSelector:@selector(tabbar:clickCenterBtn:)]) {
        [self.delegate tabbar:self clickCenterBtn:button];
    }
    self.backgroundColor = [UIColor backColor];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint touchPoint = [self.bigBtn convertPoint:point fromView:self];
    if ([self.bigBtn pointInside:touchPoint withEvent:event]) {
        return self.bigBtn;
    }
    for (UIView *view in self.subviews) {
        CGPoint p = [view convertPoint:point fromView:self];
        if ([view pointInside:p withEvent:event]) {
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)addItem:(UITabBarItem *)item{
    XTabbarButton *button = [[XTabbarButton alloc]init];
    button.item = item;
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    button.tag = self.tabbarButtons.count;
    [self.tabbarButtons addObject:button];
    if (self.tabbarButtons.count == 1) {
        [self btnOnClick:button];
    }
}

- (void)coverViewAnimation{
    if (self.tabbarCoverView) {
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.tabbarCoverView.frame = self.currentSelectBtn.frame;
        } completion:nil];
    }
}

- (void)btnOnClick:(XTabbarButton *)button{
    if ([self.delegate respondsToSelector:@selector(tabbar:selectedFromIndex:to:)]) {
        [self.delegate tabbar:self selectedFromIndex:self.currentSelectBtn.tag to:button.tag];
    }
    self.currentSelectBtn.selected = NO;
    button.selected = YES;
    self.currentSelectBtn = button;
    [self coverViewAnimation];
    if (button.tag) {
        self.backgroundColor = [UIColor backColor];
    }else{
        self.backgroundColor = [UIColor myGrayColor];
    }
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.bigBtn.frame = CGRectMake(self.bounds.size.width / 3.0, - 0.3 * self.bounds.size.height, self.bounds.size.width / 3.0, self.bounds.size.height * 1.3);
    
    
    for (UIView *view in self.subviews) {
        if (view.tag == 999) {
            continue;
        }
        view.frame = CGRectMake(view.tag * self.bounds.size.width * 2 / 3.0 , 0, self.bounds.size.width/3.0, self.bounds.size.height);
    }
    self.tabbarCoverView.frame = self.currentSelectBtn.frame;
    self.bigBtn.height = self.bigBtn.bounds.size.height - self.currentSelectBtn.frame.size.height;
}


- (NSMutableArray *)tabbarButtons{
    if (_tabbarButtons == nil) {
        _tabbarButtons = [NSMutableArray array];
    }
    return _tabbarButtons;
}

- (void)setTabbarCoverView:(UIView *)tabbarCoverView{
    _tabbarCoverView = tabbarCoverView;
    tabbarCoverView.frame = CGRectMake(0, 0, self.bigBtn.frame.size.width, self.frame.size.height);
    [self addSubview:tabbarCoverView];
}

@end
