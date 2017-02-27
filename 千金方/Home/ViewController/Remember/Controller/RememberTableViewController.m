//
//  RememberTableViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/1/18.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "RememberTableViewController.h"
#import "RememberCell.h"
#import "Prescription.h"
#import "HomeBottomView.h"
#import "PartViewController.h"
#import "RememberHeaderFooterView.h"
#import "RememberFooterView.h"
#import "SqliteTool.h"
#import "DataArray.h"
#import "MedicineViewController.h"
#import "FinishViewController.h"
@interface RememberTableViewController ()<RememberCellDelegate>

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,weak) Prescription *prescription;

@end

@implementation RememberTableViewController

- (Prescription *)prescription{
    if (_prescription == nil) {
        _prescription = [DataArray shareArray].currentPrescription;
        if (_prescription == nil) {
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Tips" message:@"你已经背完了所有的药方" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"重置药方" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[DataArray shareArray] resetAllPrescription];
                [self addAnimation];
                [self clickNextOne:nil];
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [vc addAction:action];
            [vc addAction:action1];
            [self presentViewController:vc animated:YES completion:^{
                [[DataArray shareArray]noResetAllPrescription];
                [self addAnimation];
                [self clickNextOne:nil];
            }];
        }
    }
    return _prescription;
}

- (NSInteger)index{
    return [DataArray shareArray].index;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [DataArray shareArray].index = 0;
    self.view.backgroundColor = [UIColor backColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RememberCell class] forCellReuseIdentifier:@"homeCell"];
    self.tableView.estimatedRowHeight = 80;
    self.tabBarController.navigationItem.title = self.prescription.name;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(homeClick)];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickPrevious:) name:kPreviousClickNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickNextOne:) name:kNextClickNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickRemember:) name:kRememberClickNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView) name:@"PartViewBackNotification" object:nil];
    
}

- (void)refreshView{
    self.prescription = nil;
    [self.tableView reloadData];
    [self addAnimation];
}


- (void)homeClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cell:(RememberCell *)cell clickMedicine:(Medicine *)medicine{
    if (medicine) {
        MedicineViewController *medicineVC = [[MedicineViewController alloc]initWithNibName:NSStringFromClass([MedicineViewController class]) bundle:nil];
        medicineVC.medicine = medicine;
        medicineVC.navigationItem.title = medicine.name;
        [self.navigationController pushViewController:medicineVC animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.prescription.contentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.prescription.lineNumber + 1;
    }else{
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        RememberHeaderFooterView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"rememberHeader"];
        if (head == nil) {
            head = [[RememberHeaderFooterView alloc]initWithReuseIdentifier:@"rememberHeader"];
        }
        return head;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.prescription.contentArray.count - 1) {
        RememberFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"rememberFooter"];
        if (footer == nil) {
            footer = [[RememberFooterView alloc]initWithReuseIdentifier:@"rememberFooter"];
        }
        footer.contentView.backgroundColor = [UIColor backColor];
        return footer;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.prescription.contentArray.count - 1) {
        return 25.0f;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RememberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    if (indexPath.section == 0) {
        return [cell heightWithContent:self.prescription.contentArray[0][indexPath.row]];
    }else{
        return [cell heightWithContent:self.prescription.contentArray[indexPath.section]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RememberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    if (cell == nil) {
        cell = [[RememberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCell"];
    }
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.needClick = YES;
        cell.contentString = self.prescription.contentArray[0][indexPath.row];
    }else{
        cell.needClick = NO;
        if (indexPath.section == self.prescription.contentArray.count - 1) {
            cell.contentString = [self dealSongString:self.prescription.contentArray[indexPath.section]];
        }else{
            cell.contentString = self.prescription.contentArray[indexPath.section];
        }
    }
    cell.type = PresentAll;
    cell.titleString = [self getTitleStringWithIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)dealSongString:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@"。"];
    NSMutableString *string = [NSMutableString string];
    if (array.count > 0) {
        for (int i = 0; i<array.count; i++) {
            if ([array[array.count - 1] isEqualToString:@""]) {
                if (i == array.count - 1) {
                    continue;
                }
                if (i < array.count - 2) {
                    [string appendFormat:@"%@。\n",array[i]];
                }else{
                    [string appendFormat:@"%@。",array[i]];
                }
            }
        }
    }
    return string;
}

- (NSString *)getTitleStringWithIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [NSArray arrayWithObjects:@[@"成分",@"君药",@"臣药",@"佐药",@"使药",@"佐使药"],@"功效",@"主治",@"歌诀", nil];
    if (indexPath.section == 0) {
        return array[0][indexPath.row];
    }else{
        return array[indexPath.section];
    }
}

- (void)clickNextOne:(NSNotification *)notification{
    if ([self.tableView.layer animationKeys][0]) {
        return;
    }
    self.prescription = nil;
    [DataArray shareArray].index += 1;
    [self addAnimation];
}

- (void)addAnimation{
    if ([self.tableView.layer animationKeys][0]) {
        return;
    }
    [self.tableView reloadData];
    self.tabBarController.navigationItem.title = self.prescription.name;
    CATransition *animation = [CATransition animation];
    animation.type = @"rippleEffect";
    animation.duration = 2;
    animation.removedOnCompletion = NO;
    animation.subtype = kCAAnimationPaced;
    animation.fillMode = kCAFillModeBoth;
    [self.tableView.layer addAnimation:animation forKey:@"animation"];
    RememberTableViewController __weak *WeakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WeakSelf.tableView.layer removeAllAnimations];
    });
}

- (void)clickRemember:(NSNotification *)notification{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([PartViewController class]) bundle:nil];
    PartViewController *vc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickPrevious:(NSNotification *)notification{
    if ([self.tableView.layer animationKeys][0]) {
        return;
    }
    self.prescription = nil;
    [DataArray shareArray].index -= 1;
    [self addAnimation];
}

- (void)dealloc{
    self.prescription = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
