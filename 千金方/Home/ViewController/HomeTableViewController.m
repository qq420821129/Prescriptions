//
//  HomeTableViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/1/17.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "XBaseNavigationController.h"
#import "RememberTableViewController.h"
#import "ReviewTableViewController.h"
#import "RememberTabbarController.h"

@interface HomeTableViewController ()
@property (nonatomic ,weak)UIImageView *imageView;
@property (nonatomic,weak) UIView *backView;
@property (nonatomic,assign) CGFloat offSet;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的药方";
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/4.0)];
    self.tableView.tableHeaderView = view;
    
    UIView *backV = [[UIView alloc]initWithFrame:view.bounds];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:backV.bounds];
    
    imageV.image = [UIImage imageNamed:@"headImage"];
    [backV addSubview:imageV];
    self.backView = backV;
    backV.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:235/255.0f alpha:1];
    [view addSubview:backV];
    self.imageView = imageV;
    self.view.backgroundColor = [UIColor myGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}
- (UIImage *)getNewImageWithImage:(UIImage *)image andNewSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tableView.contentOffset.y > (self.imageView.bounds.size.height -self.navigationController.navigationBar.bounds.size.height -([UIApplication sharedApplication].statusBarHidden ? 0 : 20))) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"homeCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    switch (indexPath.row){
        case 0:
            cell.textLabel.text = @"开始背诵";
            cell.detailTextLabel.text = @"千里之行始于足下";
            break;
        case 1:
            cell.textLabel.text = @"开始复习";
            cell.detailTextLabel.text = @"学而时习之";
            break;
        default:
            break;
    }
    cell.contentView.backgroundColor = [UIColor myGrayColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        RememberTabbarController *tabbarVC = [[RememberTabbarController alloc]init];
        RememberTableViewController *rememberVC = [[RememberTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [tabbarVC addChildViewController:rememberVC];
        tabbarVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tabbarVC animated:YES];
    }else if(indexPath.row == 1){
        [self pushViewController:[ReviewTableViewController class] andTitle:@"复习"];
    }
}

- (void)pushViewController:(Class)VC andTitle:(NSString *)title{
    UIViewController *vc = [[[VC class]alloc]initWithStyle:UITableViewStylePlain];
    vc.navigationItem.title = title;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    XBaseNavigationController *nav = (XBaseNavigationController *)self.navigationController;
    CGFloat alpha = 1 - (self.backView.bounds.size.height - self.navigationController.navigationBar.bounds.size.height -([UIApplication sharedApplication].statusBarHidden ? 0 : 20) - scrollView.contentOffset.y) / (self.backView.bounds.size.height - self.navigationController.navigationBar.bounds.size.height -([UIApplication sharedApplication].statusBarHidden ? 0 : 20));
    if (alpha > 1) {
        alpha = 1;
    }else if(alpha < 0){
        alpha = 0;
        CGFloat offset = scrollView.contentOffset.y - self.offSet;
        self.backView.frame = CGRectMake(0, scrollView.contentOffset.y, self.backView.frame.size.width, self.backView.frame.size.height - offset);
        self.imageView.frame = CGRectMake(0, self.backView.frame.size.height - self.imageView.bounds.size.height, self.imageView.bounds.size.width, self.imageView.bounds.size.height);
        self.offSet = scrollView.contentOffset.y;
    }
    if (alpha > 0.7) {
        self.navigationItem.title = @"千金之方";
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }else{
        self.navigationItem.title = @"我的药方";
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    nav.alpha = alpha;
}


@end
