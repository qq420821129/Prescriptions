//
//  UIView+Constrait.m
//  千金方
//
//  Created by 周小伟 on 2017/1/17.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "UIView+Constrait.h"

@implementation UIView (Constrait)
/**self.bigBtn insetEdges:@"|25-H-20|14-V-25|-h:20-|-w14-|-CX25-|-CY10-|FL|*/
- (void)edgeInsetWithString:(NSString *)string{
    [self edgeInsetWithString:string toOtherView:self.superview];
}

- (void)edgeInsetWithString:(NSString *)string toOtherView:(UIView *)view{
    if (!view) {
        view = self.superview;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *array = [string componentsSeparatedByString:@"|"];
    for (int i = 0; i<array.count; i++) {
        NSString *string = array[i];
        if ([string containsString:@"H"] || [string containsString:@"V"]) {
            [self addHVConstraitWithString:string withOtherView:view];
        }
        if ([string containsString:@"h"] || [string containsString:@"w"] || [string containsString:@"CX"] || [string containsString:@"CY"]) {
            [self addSingleConstraitWithString:string withOtherView:view];
        }
        if ([string containsString:@"TL"]) {
            [self addTrailingLeft:string withOtherView:view];
        }
        if ([string containsString:@"TR"]) {
            [self addTrailingRight:string withOtherView:view];
        }
        if ([string containsString:@"TT"]) {
            [self addTrailingTop:string withOtherView:view];
        }
        if ([string containsString:@"TB"]) {
            [self addTrailingBottom:string withOtherView:view];
        }
    }
}

- (void)addTrailingLeft:(NSString *)string withOtherView:(UIView *)view{
    NSRange range = [string rangeOfString:@"TL"];
    if (range.location != NSNotFound) {
        NSString *margin = [string substringFromIndex:range.location+2];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[margin floatValue]];
        [self.superview addConstraint:constraint];
    }
}

- (void)addTrailingRight:(NSString *)string withOtherView:(UIView *)view{
    NSRange range = [string rangeOfString:@"TR"];
    if (range.location != NSNotFound) {
        NSString *margin = [string substringFromIndex:range.location+2];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:[margin floatValue]];
        [self.superview addConstraint:constraint];
    }
}

- (void)addTrailingTop:(NSString *)string withOtherView:(UIView *)view{
    NSRange range = [string rangeOfString:@"TT"];
    if (range.location != NSNotFound) {
        NSString *margin = [string substringFromIndex:range.location+2];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:[margin floatValue]];
        [self.superview addConstraint:constraint];
    }
}

- (void)addTrailingBottom:(NSString *)string withOtherView:(UIView *)view{
    NSRange range = [string rangeOfString:@"TB"];
    if (range.location != NSNotFound) {
        NSString *margin = [string substringFromIndex:range.location+2];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:[margin floatValue]];
        [self.superview addConstraint:constraint];
    }
}

- (float)getFloatFromString:(NSString *)string{
    if (string) {
        float floatNum;
        if ([string containsString:@"/"]) {
            floatNum = [[string substringToIndex:[string rangeOfString:@"/"].location]floatValue] / [[string substringFromIndex:[string rangeOfString:@"/"].location + 1]floatValue];
        }else{
            floatNum = [string floatValue];
        }
        return floatNum;
    }else{
        return 1.0;
    }
}

- (void)addSingleConstraitWithString:(NSString *)string withOtherView:(UIView *)view{/**  -1/3w- */
    NSRange widthR = [string rangeOfString:@"w"];
    if (widthR.location != NSNotFound) {
        NSString *width = [string substringWithRange:NSMakeRange(widthR.location + 1, string.length - 1 - widthR.location - 1)];
        NSInteger widthValue = [width floatValue] ? : 0;
        NSString *mutiplierString = [string substringWithRange:NSMakeRange(1, widthR.location - 1)];
        float mutiplier = [self getFloatFromString:mutiplierString];
        NSLayoutConstraint *widthLayout;
        if(self.superview == view){
            if (mutiplier) {
                widthLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:mutiplier constant:widthValue];
            }else{
                widthLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:widthValue];
            }
        }else{
            widthLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:mutiplier constant:widthValue];
        }
        [self.superview addConstraints:@[widthLayout]];
    }
    NSRange heightR = [string rangeOfString:@"h"];
    if (heightR.location != NSNotFound) {
        NSString *height = [string substringWithRange:NSMakeRange(heightR.location + 1, string.length - 1 - heightR.location - 1)];
        NSInteger heightValue = [height floatValue] ? : 0;
        NSString *mutiplierString = [string substringWithRange:NSMakeRange(1, heightR.location - 1)];
        float mutiplier = [self getFloatFromString:mutiplierString];
        NSLayoutConstraint *heightLayout;
        if(self.superview == view){
            if (mutiplier) {
                heightLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:mutiplier constant:heightValue];
            }else{
                heightLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:heightValue];
            }
        }else{
            heightLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:mutiplier constant:heightValue];
        }
        [self.superview addConstraint:heightLayout];
    }
    
    NSRange range = [string rangeOfString:@"CX"];
    if (range.location != NSNotFound) {
        NSString *centerX = [string substringWithRange:NSMakeRange(range.location + 2, string.length - 1 - range.location - 2)];
        NSString *mutiplierString = [string substringWithRange:NSMakeRange(1, range.location - 1)];
        float mutiplier = [mutiplierString floatValue] ?:1.0;
        NSLayoutConstraint *centerXLayout;
        centerXLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:mutiplier constant:centerX.floatValue];
        [self.superview addConstraint:centerXLayout];
    }
    
    NSRange rangeY = [string rangeOfString:@"CY"];
    if (rangeY.location != NSNotFound) {
        NSString *centerY = [string substringWithRange:NSMakeRange(rangeY.location + 2, string.length - 1 - rangeY.location - 2)];
        NSString *mutiplierString = [string substringWithRange:NSMakeRange(1, rangeY.location - 1)];
        float mutiplier = [mutiplierString floatValue] ?:1.0;
        NSLayoutConstraint *centerYLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:mutiplier constant:centerY.floatValue];
        [self.superview addConstraint:centerYLayout];
    }
    
}
/**  |0-H-0|  view */
- (void)addHVConstraitWithString:(NSString *)string withOtherView:(UIView *)view{
    NSRange range = [string rangeOfString:@"H"];
    if (range.location != NSNotFound) {
        NSString *left = [string substringToIndex:range.location - 1];
        NSString *right = [string substringFromIndex:range.location + 2];
        NSLayoutConstraint *leftLayout,*rightLayout;
        if (self.superview == view) {
            if (![left isEqualToString:@""]) {
                leftLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:left.floatValue];
            }
            if (![right isEqualToString:@""]) {
                rightLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:right.floatValue];
            }
        }else{
            if ([left isEqualToString:@""] && ![right isEqualToString:@""]) {
                rightLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:right.floatValue];
            }else if (![left isEqualToString:@""] && [right isEqualToString:@""]) {
                leftLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:left.floatValue];
            }else{
//                NSLog(@"可能是个错误的布局,如果不是请自己添加");
                return;
            }
            
        }
        if (leftLayout) {
            [self.superview addConstraint:leftLayout];
        }
        if (rightLayout) {
            [self.superview addConstraint:rightLayout];
        }
    }
    NSRange rangeV = [string rangeOfString:@"V"];
    if (rangeV.location != NSNotFound) {
        NSString *top = [string substringToIndex:rangeV.location - 1];
        NSString *bottom = [string substringFromIndex:rangeV.location + 2];
        NSLayoutConstraint *topLayout,*bottomLayout;
        if (self.superview == view) {
            if (![top isEqualToString:@""]) {
                topLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:top.floatValue];
            }
            if (![bottom isEqualToString:@""]) {
                bottomLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottom.floatValue];
            }
        }else{
            if ([top isEqualToString:@""] && ![bottom isEqualToString:@""]) {
                bottomLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:bottom.floatValue];
            }else if(![top isEqualToString:@""] && [bottom isEqualToString:@""]){
                topLayout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:top.floatValue];
            }
        }
        if (topLayout) {
            [self.superview addConstraint:topLayout];
        }
        if (bottomLayout) {
            [self.superview addConstraint:bottomLayout];
        }
    }
}

@end
