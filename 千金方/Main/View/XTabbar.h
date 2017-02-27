//
//  XTabbar.h
//  千金方
//
//  Created by 周小伟 on 2017/1/16.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTabbar;
@protocol XTabbarDelegate<NSObject>


- (void)tabbar:(XTabbar *)tabbar clickCenterBtn:(UIButton *)centerBtn;

- (void)tabbar:(XTabbar *)tabbar selectedFromIndex:(NSInteger)from to:(NSInteger)to;

@end

@interface XTabbar : UIView


- (void)addItem:(UITabBarItem *)item;


@property (nonatomic,weak) UIView *tabbarCoverView;
@property (nonatomic,weak) id<XTabbarDelegate> delegate;
@end
