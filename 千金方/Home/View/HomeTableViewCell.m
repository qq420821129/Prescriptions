//
//  HomeTableViewCell.m
//  千金方
//
//  Created by 周小伟 on 2017/1/18.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell ()

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
