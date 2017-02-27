//
//  ReviewTableViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/1/19.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "ReviewTableViewController.h"
#import "SqliteTool.h"
#import "Prescription.h"
#import "ReviewPresentController.h"
@interface ReviewTableViewController ()
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation ReviewTableViewController

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        NSArray *firstArray = [[SqliteTool shareTool]selectWithSql:@"select * from t_prescription where score > 0"];
        NSArray *secondArr = [[SqliteTool shareTool]selectWithSql:@"select * from t_prescription where score = 0"];
        _dataArray = @[firstArray,secondArr];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"复习模式";
    self.view.backgroundColor = [UIColor backColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reviewCell"];
    }
    Prescription *prescription = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = prescription.name;
    if (prescription.score > 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"分数：%.1f",prescription.score * 100];
    }else{
        cell.detailTextLabel.text = @"";
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.contentView.backgroundColor = [UIColor backColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return @"已背过";
//    }else{
//        return @"没背过";
//    }
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]init];
    header.contentView.backgroundColor = [UIColor backColor];
    if (section == 0) {
        header.textLabel.text = @"已背过";
    }else{
        header.textLabel.text = @"没背过";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([ReviewPresentController class]) bundle:nil];
    ReviewPresentController *vc = [sb instantiateInitialViewController];
    vc.prescription = self.dataArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
