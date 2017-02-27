//
//  RememberCell.m
//  千金方
//
//  Created by 周小伟 on 2017/1/21.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "RememberCell.h"
#import "SqliteTool.h"
@interface RememberCell ()<RTLabelDelegate>

@property (nonatomic,weak) UIButton *titleButton;

@property (nonatomic,weak) RTLabel *contentLabel;



@end

@implementation RememberCell

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url{
    
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithString:(NSString *)string{
    Medicine *medicine = [[SqliteTool shareTool]selectTheMedicine:string];
    if([self.delegate respondsToSelector:@selector(cell:clickMedicine:)]){
        [self.delegate cell:self clickMedicine:medicine];
    }
}

- (UIButton *)titleButton{
    if (_titleButton == nil) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:button];
        
        _titleButton = button;
    }
    return _titleButton;
}

- (RTLabel *)contentLabel{
    if (_contentLabel == nil) {
        RTLabel *label = [[RTLabel alloc]init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        [label setLineBreakMode:RTTextLineBreakModeWordWrapping];
        [label setLinkAttributes:@{@"color":@"black"}];
        [label setSelectedLinkAttributes:@{@"color":@"gray"}];
        [label setLineSpacing:2];
        [label setDelegate:self];
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
        [self.contentView addSubview:label];
        _contentLabel = label;
    }
    return _contentLabel;
}

- (void)setNeedClick:(BOOL)needClick{
    _needClick = needClick;
    if (needClick) {
        self.titleButton.userInteractionEnabled = YES;
    }else{
        self.titleButton.userInteractionEnabled = NO;
    }
}

- (void)changeType:(UIButton *)button{
    if (self.contentLabel.layer.animationKeys[0]) {
        return;
    }
    _type = (_type == ClearAll ? PresentAll : ClearAll);
    __weak RememberCell *WeakSelf = self;
    if (_type == ClearAll) {
        CAAnimation *keyFrame = [self getBasicAnimationWithKeyPath:@"opacity" from:@1 toValue:@0 byValue:@0.1 duration:1 repeatCount:1 isRemove:NO];
        [self.contentLabel.layer addAnimation:keyFrame forKey:@"Clear"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WeakSelf.contentLabel.layer.opacity = 0;
            [WeakSelf.contentLabel.layer removeAllAnimations];
        });
    }else{
        CAAnimation *keyFrame = [self getBasicAnimationWithKeyPath:@"opacity" from:@0 toValue:@1 byValue:@0.1 duration:1 repeatCount:1 isRemove:NO];
        [self.contentLabel.layer addAnimation:keyFrame forKey:@"Clear"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WeakSelf.contentLabel.layer.opacity = 1;
            [WeakSelf.contentLabel.layer removeAllAnimations];
        });
    }
}

- (CAAnimation *)getBasicAnimationWithKeyPath:(NSString *)keyPath from:(id)fromValue toValue:(id)toValue byValue:(id)byValue duration:(CFTimeInterval)duration repeatCount:(float)repeatCount isRemove:(BOOL)isRemove{
    CABasicAnimation *keyFrame = [CABasicAnimation animation];
    [keyFrame setKeyPath:keyPath];
    keyFrame.fromValue = fromValue;
    keyFrame.toValue = toValue;
    keyFrame.byValue = byValue;
    keyFrame.duration = duration;
    keyFrame.repeatCount = repeatCount;
    if (!isRemove) {
        keyFrame.fillMode = kCAFillModeBoth;
        keyFrame.removedOnCompletion = NO;
    }
    return keyFrame;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
//        self.type = PresentAll;
    }
    return self;
}

- (void)setType:(RememberType)type{
    _type = type;
    if (type == ClearAll) {
        self.contentLabel.layer.opacity = 0;
    }else{
        self.contentLabel.layer.opacity = 1;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//- (void)setType:(RememberType)type{
//    _type = type;
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleButton edgeInsetWithString:@"|-TT0-|-TL10-|"];
    self.contentLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleButton.frame), [UIScreen mainScreen].bounds.size.width - 20, self.contentLabel.optimumSize.height);
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    [self.titleButton setTitle:titleString forState:UIControlStateNormal];
}

- (void)setContentString:(NSString *)contentString{
    _contentString = contentString;
    if (self.isNeedClick) {
        NSMutableString *string = [NSMutableString string];
        NSArray *array;
        if ([contentString containsString:@"，"]) {
            array = [contentString componentsSeparatedByString:@"，"];
        }else{
            array = [contentString componentsSeparatedByString:@" "];
        }
        for (NSString *str in array) {
            if ([[SqliteTool shareTool]selectTheMedicine:str]) {
                NSString *midStr = [NSString stringWithFormat:@"<a href='%@'><u>%@</u></a>",str,str];
                [string appendString:midStr];
                [string appendString:@" "];
            }else{
                [string appendString:str];
                [string appendString:@" "];
            }
        }
        self.contentLabel.text = string;
    }else{
        self.contentLabel.text = contentString;
    }
    [self layoutIfNeeded];
}

- (CGFloat)heightWithContent:(NSString *)string{
    self.contentString = string;
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.titleButton.frame) + 10 + self.contentLabel.optimumSize.height;
}

@end
