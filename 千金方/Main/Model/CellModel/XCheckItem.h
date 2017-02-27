//
//  XCheckItem.h
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XItem.h"

@interface XCheckItem : XItem

@property (nonatomic,assign,getter=isCheck) BOOL check;

@property (nonatomic,copy) NSString *text;
@end
