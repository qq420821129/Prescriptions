//
//  XFactory.m
//  千金方
//
//  Created by 周小伟 on 2017/1/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XFactory.h"
#import "XBaseTableViewController.h"
#import "XBaseNavigationController.h"
#import "XButton.h"
@implementation XFactory

+ (XBaseNavigationController *)createBaseNavigationController{
    return [[XBaseNavigationController alloc]init];
}

+ (XBaseTableViewController *)createBaseTableViewController{
    return [[XBaseTableViewController alloc]initWithStyle:UITableViewStylePlain];
}

+ (XButton *)createXButton{
    return [[XButton alloc]init];
}

@end
