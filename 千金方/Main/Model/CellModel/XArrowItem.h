//
//  XArrowItem.h
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XItem.h"

@interface XArrowItem : XItem

- (instancetype)initWithTitle:(NSString *)title andDestVC:(NSString *)destVC;

+ (instancetype)itemWithTitle:(NSString *)title andDestVC:(NSString *)destVC;

@end
