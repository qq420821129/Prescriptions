//
//  XNavigationController.m
//  TestNav
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XBaseNavigationController.h"
#import "NavigationView.h"
#import "RememberTableViewController.h"
@interface XBaseNavigationController ()
@property (nonatomic,weak) UIView *backView;
@end

@implementation XBaseNavigationController

+ (void)initialize{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    NSMutableDictionary *hiDict = [NSMutableDictionary dictionary];
    hiDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:hiDict forState:UIControlStateHighlighted];
    
    NSMutableDictionary *disDict = [NSMutableDictionary dictionary];
    disDict[NSForegroundColorAttributeName] = [UIColor myGrayColor];
    [item setTitleTextAttributes:disDict forState:UIControlStateDisabled];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        if (![rootViewController isKindOfClass:NSClassFromString(@"HomeTableViewController")]) {
            self.alpha = 1;
            self.backView.backgroundColor = [UIColor backColor];
        }
    }
    return self;
}

- (void)loadView{
    [super loadView];
    CGRect rect = self.navigationBar.bounds;
    if ([UIApplication sharedApplication].isStatusBarHidden) {
    }else{
        rect.size.height += 20;
    }
    UIView *view = [[NavigationView alloc]initWithFrame:rect];
    view.tag = 100;
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    self.backView = view;
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc]init];
    self.alpha = 0;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    if (self.childViewControllers.count > 1) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        self.navigationBar.shadowImage = [[UIImage alloc]init];
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.navigationBar.barTintColor = [UIColor backColor];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.childViewControllers.count == 2) {
        self.navigationBar.shadowImage = [[UIImage alloc]init];
        [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    }
    return [super popViewControllerAnimated:animated];
}

- (void)backClick{
    [self popViewControllerAnimated:YES];
}


- (void)setAlpha:(CGFloat)alpha{
    _alpha = alpha;
    self.backView.alpha = alpha;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
