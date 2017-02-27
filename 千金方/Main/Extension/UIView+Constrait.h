//
//  UIView+Constrait.h
//  千金方
//
//  Created by 周小伟 on 2017/1/17.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Constrait)

- (void)edgeInsetWithString:(NSString *)string;

- (void)edgeInsetWithString:(NSString *)string toOtherView:(UIView *)view;

@end
