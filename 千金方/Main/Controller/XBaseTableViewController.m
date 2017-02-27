//
//  XBaseTableViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "XBaseTableViewController.h"

@interface XBaseTableViewController ()

@end

@implementation XBaseTableViewController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backColor];
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XSection *xSection = self.dataArray[section];
    return xSection.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XCell *cell = [XCell cellWithTableView:tableView];
    XSection *section = self.dataArray[indexPath.section];
    XItem *item = section.items[indexPath.row];
    cell.contentView.backgroundColor = [UIColor backColor];
    cell.item = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray != nil && self.dataArray.count >0) {
        XSection *section = self.dataArray[indexPath.section];
        XItem *item = section.items[indexPath.row];
        if (item.option != nil) {
            item.option();
            return;
        }
        if ([item isKindOfClass:[XArrowItem class]]) {
            XArrowItem *arrowItem = (XArrowItem *)item;
            if (arrowItem.destVCName) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:arrowItem.destVCName bundle:nil];
                UIViewController *vc = [sb instantiateInitialViewController];
                vc.title = arrowItem.title;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    XSection *xSection = self.dataArray[section];
    return (xSection.sectionTitle != nil ? xSection.sectionTitle : nil);
}

@end
