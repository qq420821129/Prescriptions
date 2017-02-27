//
//  UITabBar+hitTest.m
//  千金方
//
//  Created by 周小伟 on 2017/2/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "UITabBar+hitTest.h"
#import "XTabbar.h"
@implementation UITabBar (hitTest)
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.hidden == NO) {        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[XTabbar class]]) {
                CGPoint touchPoint = [view convertPoint:point fromView:self];
                for (UIView *button in view.subviews) {
                    CGPoint buttonPoint = [button convertPoint:touchPoint fromView:view];
                    if ([button pointInside:buttonPoint withEvent:event]) {
                        return [view hitTest:touchPoint withEvent:event];
                    }
                }
            }
        }
    }
    return [super hitTest:point withEvent:event];
}
@end
