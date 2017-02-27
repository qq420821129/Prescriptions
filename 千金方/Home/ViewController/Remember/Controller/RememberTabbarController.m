//
//  RememberTabbarController.m
//  千金方
//
//  Created by 周小伟 on 2017/2/3.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "RememberTabbarController.h"
#import "RememberTabbar.h"

@interface RememberTabbarController ()
@property (nonatomic,weak)RememberTabbar *tabbar;
@end

@implementation RememberTabbarController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIView *view in self.tabBar.subviews) {
        if (![view isKindOfClass:[RememberTabbar class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RememberTabbar *tabbar = [[RememberTabbar alloc]initWithFrame:self.tabBar.bounds];
    [self.tabBar addSubview:tabbar];
    self.view.backgroundColor = [UIColor backColor];
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
