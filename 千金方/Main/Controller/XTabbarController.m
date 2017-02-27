//
//  XTabbarController.m
//  千金方
//
//  Created by 周小伟 on 2017/1/16.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XTabbarController.h"
#import "XTabbar.h"
#import "TabbarCoverView.h"
#import "HomeTableViewController.h"
#import "XBaseNavigationController.h"
#import "MeTableViewController.h"
#import "MatchViewController.h"

@interface XTabbarController ()<XTabbarDelegate>
@property (nonatomic,weak) XTabbar *customTabbar;
@property (nonatomic,weak) HomeTableViewController *home;
@property (nonatomic,weak) MatchViewController *match;
@property (nonatomic,weak) MeTableViewController *me;

@end

@implementation XTabbarController



- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.home = (HomeTableViewController *)[self addChildViewControllerwithVCClass:[HomeTableViewController class] andTitle:@"千金方"];
    self.me = (MeTableViewController *)[self addChildViewControllerwithVCClass:[MeTableViewController class] andTitle:@"我"];
    self.match = (MatchViewController *)[self addCenterViewControllerWithTitle:@"匹配药方"];
    TabbarCoverView *coverView = [[TabbarCoverView alloc]init];
    coverView.backgroundColor = [UIColor clearColor];
    self.customTabbar.tabbarCoverView = coverView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTabbar];
}

- (UIViewController *)addCenterViewControllerWithTitle:(NSString *)title{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([MatchViewController class]) bundle:nil];
    MatchViewController *match = [sb instantiateInitialViewController];
    XBaseNavigationController *nav = [[XBaseNavigationController alloc]initWithRootViewController:match];
    [self addChildViewController:nav];
    match.navigationItem.title = title;
    return match;
}

- (UIViewController *)addChildViewControllerwithVCClass:(Class)className andTitle:(NSString *)title {
    UITabBarItem *item1 = [[UITabBarItem alloc]init];
    item1.title = title;
    [self.customTabbar addItem:item1];
    UIViewController *vc = [[className alloc]init];
    XBaseNavigationController *nav = [[XBaseNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    return vc;
}


- (void)addTabbar{
    XTabbar *tabbar = [[XTabbar alloc]init];
    tabbar.delegate = self;
    tabbar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:tabbar];
    self.customTabbar = tabbar;
}

- (void)tabbar:(XTabbar *)tabbar selectedFromIndex:(NSInteger)from to:(NSInteger)to{
    self.selectedIndex = to;
}

- (void)tabbar:(XTabbar *)tabbar clickCenterBtn:(UIButton *)centerBtn{
    self.selectedIndex = self.childViewControllers.count - 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
