//
//  XCheckSection.m
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XCheckSection.h"
#import "XCheckItem.h"

@implementation XCheckSection

- (void)setSelectIndex:(NSInteger)selectIndex{
    if (selectIndex > self.items.count) {
        selectIndex = 0;
    }
    _selectIndex = selectIndex;
    for (int i = 0; i<self.items.count; i++) {
        XCheckItem *item = self.items[i];
        if (i == _selectIndex) {
            item.check = YES;
        }else{
            item.check = NO;
        }
    }
}

- (void)setItems:(NSArray *)items{
    [super setItems:items];
    self.selectIndex = _selectIndex;
}

@end
