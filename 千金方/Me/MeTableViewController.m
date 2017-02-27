//
//  MeViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/1/17.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "MeTableViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
@interface MeTableViewController ()

@end

@implementation MeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XSection *section = [[XSection alloc]init];
    XItem *item = [[XItem alloc]initWithTitle:@"分享"];
    XArrowItem *item1 = [[XArrowItem alloc]initWithTitle:@"帮助" andDestVC:@"HelpTableViewController"];
    section.items = @[item,item1];
    [self.dataArray addObject:section];
    
    self.navigationItem.title = @"我";
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsCompact];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        [self startShare];
    }
}

- (void)startShare{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor backColor]];
    [SSUIEditorViewStyle setTitleColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setTitle:@"分享"];
    [shareParams SSDKSetupShareParamsByText:@"记忆药方，匹配药方，无需注册，没有广告！"
                                     images:[UIImage imageNamed:@"shareImage"]
                                        url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/qian-jin-fang/id1168251397?l=zh&ls=1&mt=8"]
                                      title:@"想要告别无脑的背诵药方的方式，那就来玩千金方！"
                                       type:SSDKContentTypeAuto];
    // 显示分享菜单
    [ShareSDK showShareActionSheet:nil
                             items:@[
                                     @(SSDKPlatformSubTypeWechatFav),                                                                              @(SSDKPlatformTypeSinaWeibo),                                                                             @(SSDKPlatformTypeQQ),@(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     ]                                                               shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state)
                   {
                       case SSDKResponseStateBegin:
                           break;
                       case SSDKResponseStateSuccess:
                           if (platformType == SSDKPlatformTypeCopy)
                           {
                               NSLog(@"复制成功");
                           }
                           else
                           {
                               NSLog(@"分享成功");
                           }
                           break;
                       case  SSDKResponseStateFail:
                           if (platformType == SSDKPlatformTypeCopy)
                           {                                                                      NSLog(@"复制失败");
                           }
                           else
                           {
                               NSLog(@"分享失败");
                           }
//                           NSLog(@"失败：%@", error);
                           break;
                       default:
                           break;
                   }
               }];
}

@end
