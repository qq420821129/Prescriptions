//
//  XFactory.h
//  千金方
//
//  Created by 周小伟 on 2017/1/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XBaseTableViewController,XBaseNavigationController,XButton;
@interface XFactory : NSObject

+ (XBaseNavigationController *)createBaseNavigationController;

+ (XBaseTableViewController *)createBaseTableViewController;

+ (XButton *)createXButton;

@end
