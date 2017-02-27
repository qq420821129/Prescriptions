//
//  MatchStrViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/2/9.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "MatchStrViewController.h"
#import "Prescription.h"
#import "SqliteTool.h"
#import "ReviewPresentController.h"

@interface MatchStrViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *matchBtn;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *dataDict;
- (IBAction)matchBtnClick:(UIButton *)sender;
@property (nonatomic,strong) NSArray *prescriptionArray;
@end

@implementation MatchStrViewController

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[SqliteTool shareTool]selectWithSql:@"select * from t_prescription"];
    }
    return _dataArray;
}

- (NSMutableArray *)dataDict{
    NSDictionary *midDict;
    for (int i = 0; i<_dataDict.count; i++) {
        for (int j = i + 1; j<_dataDict.count ; j++) {
            NSDictionary *dict = _dataDict[i];
            NSDictionary *dict1 = _dataDict[j];
            if ([dict[dict.allKeys[0]] floatValue] < [dict1[dict1.allKeys[0]] floatValue]) {
                midDict = dict;
                dict = dict1;
                dict1 = midDict;
                [_dataDict replaceObjectAtIndex:i withObject:dict];
                [_dataDict replaceObjectAtIndex:j withObject:dict1];
            }
        }
    }
    return _dataDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.title = @"匹配药方";
    self.matchBtn.enabled = NO;
    self.textfield.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor backColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardPush:) name:UIKeyboardWillChangeFrameNotification object:nil];
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

- (void)keyboardPush:(NSNotification *)notification{
    
    CGRect beginRect = [notification.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect endRect = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect frame = self.textfield.frame;
    CGRect frame1 = self.matchBtn.frame;
    self.tableView.hidden  = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.textfield.frame = CGRectMake(frame.origin.x, frame.origin.y - beginRect.origin.y + endRect.origin.y, frame.size.width, frame.size.height);
        self.matchBtn.frame = CGRectMake(frame1.origin.x, frame1.origin.y - beginRect.origin.y + endRect.origin.y, frame1.size.width, frame1.size.height);
    }];
}

- (IBAction)matchBtnClick:(UIButton *)sender {
    [self.textfield resignFirstResponder];
    if ([self.textfield.text isEqualToString:@""]) {
        self.matchBtn.enabled = NO;
        return;
    }else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *dict = [self dealStringToThePrescription:self.textfield.text];
            self.dataDict = dict;
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            });
        });
    }
}

- (NSMutableArray *)dealStringToThePrescription:(NSString *)string{
    NSArray *array;
    if ([string containsString:@","]) {
        array = [string componentsSeparatedByString:@","];
    }else if([string containsString:@" "]){
        array = [string componentsSeparatedByString:@" "];
    }else if([string containsString:@"，"]){
        array = [string componentsSeparatedByString:@"，"];
    }else{
        array = [string componentsSeparatedByString:@" "];
    }
    NSMutableArray *contentArr = [NSMutableArray array];
    for (Prescription *dict in self.dataArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *str = dict.part;
        CGFloat score = [self matchArray:array toArray:str];
        if (score > 0.10f) {
            [dic setValue:[NSString stringWithFormat:@"%.2f%%",score * 100] forKey:dict.name];
        }
        if (dic.allKeys.count > 0) {
            [contentArr addObject:dic];
        }
    }
    return contentArr;
}


- (CGFloat)matchArray:(NSArray *)array toArray:(NSString *)otherArray{
    CGFloat right = 0;
    NSArray *otherArr = [otherArray componentsSeparatedByString:@" "];
    for (int i = 0; i<array.count; i++) {
        for (int j = 0; j<otherArr.count; j++) {
            if ([array[i] isEqualToString:otherArr[j]]) {
                right++;
            }
        }
    }
    NSArray *rightArray = [otherArray componentsSeparatedByString:@" "];
    return right/(array.count > rightArray.count ? (CGFloat)array.count : (CGFloat)rightArray.count);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textfield resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataDict.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell"];
    NSDictionary *dict = self.dataDict[indexPath.row];
    cell.textLabel.text = dict.allKeys[0];
    cell.contentView.backgroundColor = [UIColor backColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"匹配度:%@",dict[dict.allKeys[0]]];
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataDict[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([ReviewPresentController class]) bundle:nil];
    ReviewPresentController *review = [sb instantiateInitialViewController];
    review.prescription = [[SqliteTool shareTool]selectWithSql:[NSString stringWithFormat:@"select * from t_prescription where name = '%@'",dict.allKeys[0]]].firstObject;
    [self.navigationController pushViewController:review animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textfield resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.matchBtn.enabled = YES;
}

@end
