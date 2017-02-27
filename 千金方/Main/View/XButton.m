//
//  XButton.m
//  千金方
//
//  Created by 周小伟 on 2017/1/16.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XButton.h"

@implementation XButton


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self baseButtonSetup];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self baseButtonSetup];
    }
    return self;
}

- (void)baseButtonSetup{
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeCenter;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ThemeChange:) name:kThemeChanged object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kThemeChanged object:nil];
}

- (void)ThemeChange:(NSNotification *)notification{
    
}

@end
