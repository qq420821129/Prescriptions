//
//  XItem.h
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^block)();
@interface XItem : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *subTitle;

@property (nonatomic,copy) NSString *destVCName;

@property (nonatomic,copy) block option;

- (instancetype)initWithTitle:(NSString *)title;

+ (instancetype)itemWithTitle:(NSString *)title;

@end
