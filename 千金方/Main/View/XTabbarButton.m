//
//  XTabbarButton.m
//  千金方
//
//  Created by 周小伟 on 2017/1/16.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XTabbarButton.h"
@interface XTabbarButton()

@property (nonatomic,weak) UIButton *badgeButton;

@end

@implementation XTabbarButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
    self.titleLabel.font = [UIFont systemFontOfSize:13.0];
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:button];
    self.badgeButton = button;
    self.badgeButton.hidden = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.badgeButton.frame = CGRectMake(self.bounds.size.width - 10, 0, 10, 10);
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect{
//    CGFloat imageW = contentRect.size.width;
//    CGFloat imageH = contentRect.size.height * 0.6;
//    CGFloat imageX = 0;
//    return CGRectMake(imageX, imageX, imageW, imageH);
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect{
//    CGFloat titleY = contentRect.size.height * 0.6;
//    CGFloat titleW = contentRect.size.width;
//    CGFloat titleH = contentRect.size.height - contentRect.size.height * 0.6;
//    CGFloat titleX = 0;
//    return CGRectMake(titleX, titleY, titleW, titleH);
//}

- (void)setItem:(UITabBarItem *)item{
    _item = item;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [item addObserver:self forKeyPath:@"badgeChange" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.badgeButton.hidden = YES;
    if ([keyPath isEqualToString:@"badgeChage"]) {
        if([change[@"new"] intValue] != 0){
            self.badgeButton.hidden = NO;
        }
        if ([change[@"new"] intValue] > 99){
            [self.badgeButton setTitle:@"N+" forState:UIControlStateNormal];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 99;
        }else{
            [self.badgeButton setTitle:[change[@"new"] description] forState:UIControlStateNormal];
            [UIApplication sharedApplication].applicationIconBadgeNumber = [change[@"new"] intValue];
        }
    }
}

- (void)dealloc{
    [_item removeObserver:self forKeyPath:@"badgeChange"];
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
