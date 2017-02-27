//
//  XCell.m
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XCell.h"

@interface XCell ()

@property (nonatomic,strong) UIImageView *arrowImageView;

@property (nonatomic,strong) UISwitch *switchBtn;

@property (nonatomic,strong) UILabel *labelView;

@property (nonatomic,strong) UIImageView *checkView;

@end

@implementation XCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ThemeChange:) name:kThemeChanged object:nil];
    }
    return self;
}

- (void)ThemeChange:(NSNotification *)notification{
    
}

- (UISwitch *)switchBtn{
    if (_switchBtn == nil) {
        _switchBtn = [[UISwitch alloc]init];
        [_switchBtn addTarget:self action:@selector(switchBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (void)switchBtnClick{
    [[NSUserDefaults standardUserDefaults]setBool:self.switchBtn.isOn forKey:self.item.title];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setItem:(XItem *)item{
    _item = item;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subTitle;
    if ([item isKindOfClass:[XArrowItem class]]) {
        self.accessoryView = self.arrowImageView;
    }else if([item isKindOfClass:[XCheckItem class]]){
        XCheckItem *checkItem = (XCheckItem *)item;
        if (checkItem.isCheck) {
            self.accessoryView = self.checkView;
        }else{
            self.accessoryView = nil;
        }
    }else if([item isKindOfClass:[XSwitchItem class]]){
        self.accessoryView = self.switchBtn;
        self.switchBtn.on = [[NSUserDefaults standardUserDefaults]boolForKey:self.item.title];
    }else if([item isKindOfClass:[XLabelItem class]]){
        XLabelItem *labelItem = (XLabelItem *)item;
        self.labelView.text = labelItem.text;
    }else{
        self.accessoryView = nil;
    }
    self.backgroundColor = [UIColor backColor];
}

- (UILabel *)labelView{
    if (_labelView == nil) {
        _labelView = [[UILabel alloc]init];
        _labelView.bounds = CGRectMake(0, 0, 100, 30);
    }
    return _labelView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
        _arrowImageView.backgroundColor = [UIColor backColor];
    }
    return _arrowImageView;
}

- (UIImageView *)checkView{
    if (_checkView == nil) {
        _checkView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_icon_checkmark"]];
    }
    return _checkView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"setting";
    XCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGPoint point = self.detailTextLabel.center;
    point.x = self.center.x;
    self.detailTextLabel.center = point;
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
}

@end
