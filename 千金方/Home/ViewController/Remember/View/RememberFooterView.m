//
//  RememberFooterView.m
//  千金方
//
//  Created by 周小伟 on 2017/2/1.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "RememberFooterView.h"
#import "UnDashLine.h"

@interface RememberFooterView ()

@property (nonatomic,weak) UnDashLine *line;

@property (nonatomic,weak) UILabel *signLabel;

@end

@implementation RememberFooterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UnDashLine *line = [[UnDashLine alloc]init];
        [self.contentView addSubview:line];
        self.line = line;
        UILabel *label = [[UILabel alloc]init];
        label.text = @"千金方";
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        self.signLabel = label;
        [self.contentView addSubview:label];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.signLabel edgeInsetWithString:@"|-TT5-|-TR-10-|"];
    [self.line edgeInsetWithString:@"|0-H-0|0-V-0|"];
}

@end
