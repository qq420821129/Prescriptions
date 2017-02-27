//
//  XCell.h
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XItem.h"
#import "XArrowItem.h"
#import "XCheckItem.h"
#import "XSwitchItem.h"
#import "XLabelItem.h"

@interface XCell : UITableViewCell

@property (nonatomic,strong) XItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
