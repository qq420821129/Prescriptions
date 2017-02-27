//
//  HelpTableViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/2/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "HelpTableViewController.h"
#import "HelpTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
@interface HelpTableViewController ()<MFMailComposeViewControllerDelegate>

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation HelpTableViewController

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        NSArray *array = @[@{@"1.为什么没有选择每日背诵数量了？":@"因为数据格式调整，取消了原来的每日背诵数量选择，现在可以根据自愿背诵药方！"},@{@"2.数据是怎么给定的？":@"因为没有服务器，所以所有的数据都是内置在应用程序中的，每次进入App会先从已经背过但未达到满分的药方开始背诵！"},@{@"3.匹配药方该如何操作？":@"匹配药方可以参照页面的说明，药方药物名以空格或逗号隔开，药物名不能重复，否则将影响匹配结果，匹配的结果是按照要查询的药方和药方数据中药方中匹配的药物数目除以后者得到匹配度！"},@"4.问题反馈"];
        _dataArray = array;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor blackColor];
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView setTableFooterView:[[UIView alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.dataArray.count - 1) {
        HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell"];
        return [cell cellHeightForDict:self.dataArray[indexPath.row]];
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell"];
    if (indexPath.row != self.dataArray.count - 1) {
        cell.helpDict = self.dataArray[indexPath.row];
    }else{
        cell.textLabel.text = self.dataArray[indexPath.row];
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
        imageV.backgroundColor = [UIColor backColor];
        cell.accessoryView = imageV;
        cell.backgroundColor = [UIColor backColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count - 1) {
        if ([MFMailComposeViewController canSendMail]) {
            if ([[Reachability reachabilityWithHostName:@"http://www.baidu.com"] currentReachabilityStatus] != NotReachable) {
                [self sendEmailAction];
            }else{
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Tips" message:@"网络连接异常，请正常设置网络！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [vc addAction:action];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }else{
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Tips" message:@"请在手机设置界面正确设置邮箱" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [vc addAction:action];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (void)sendEmailAction{
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
    [mailCompose setMailComposeDelegate:self];
    [mailCompose setSubject:@"App反馈意见提交！"];
    [mailCompose setToRecipients:@[@"420821129@qq.com"]];
    
    [mailCompose setCcRecipients:@[@"59286178@qq.com"]];
    [mailCompose setBccRecipients:@[@"1580947446@qq.com"]];
    
    NSString *emailContent = @"请在这里提交您的意见！";
    [mailCompose setMessageBody:emailContent isHTML:NO];
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Tips" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [vc addAction:action];
    
    switch (result) {
        case MFMailComposeResultCancelled:
            vc.message = @"取消发送";
            break;
        case MFMailComposeResultSaved:
            vc.message = @"邮件已保存，可以从手机邮箱中寻找";
            break;
            case MFMailComposeResultSent:
            vc.message = @"邮件已发送";
            break;
            case MFMailComposeResultFailed:
            vc.message = @"邮件发送失败";
            break;
        default:
            break;
    }
    [controller presentViewController:vc animated:YES completion:nil];
}

@end
