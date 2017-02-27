//
//  MeTableViewCell.m
//  千金方
//
//  Created by 周小伟 on 2017/2/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "HelpTableViewCell.h"
@interface HelpTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation HelpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor backColor];
}

- (void)setHelpDict:(NSDictionary *)helpDict{
    self.titleLabel.text = helpDict.allKeys[0];
    self.contentLabel.text = helpDict[helpDict.allKeys[0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (CGFloat)cellHeightForDict:(NSDictionary *)dict{
    self.helpDict = dict;
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.contentLabel.frame) + 10;
}

@end
