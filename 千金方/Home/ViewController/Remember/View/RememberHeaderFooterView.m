//
//  HomeHeaderView.m
//  千金方
//
//  Created by 周小伟 on 2017/2/1.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "RememberHeaderFooterView.h"
#import "DashLine.h"
@implementation RememberHeaderFooterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        DashLine *line = [[DashLine alloc]init];
        [self.contentView addSubview:line];
    }
    return self;
}


@end
