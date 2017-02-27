//
//  PartViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/2/1.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "PartViewController.h"
#import "Prescription.h"
#import "DataArray.h"

@interface PartViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

- (IBAction)submitClick:(UIButton *)sender;

@end

@implementation PartViewController
@synthesize prescription = _prescription;

- (Prescription *)prescription{
    if (_prescription == nil) {
        _prescription = [DataArray shareArray].currentPrescription;
        if (_prescription == nil) {
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"您已背完了所有的药方" message:@"您可以点击重置药方重置所有数据" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"重置药方" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[DataArray shareArray] resetAllPrescription];
                [self reRemember];
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [vc addAction:action];
            [vc addAction:action1];
            [self presentViewController:vc animated:YES completion:^{
                [[DataArray shareArray]noResetAllPrescription];
                [self reRemember];
            }];
        }
    }
    return _prescription;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.view.backgroundColor = [UIColor backColor];
    self.navigationItem.title = self.prescription.name;
    self.contentLabel.text = self.prescription.part;
    self.textfield.delegate = self;
    self.tipLabel.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(reRemember)];
    if (self.prescription.score) {
        self.tipLabel.hidden = NO;
        self.scoreLabel.text = [NSString stringWithFormat:@"%.1f",self.prescription.score * 100];
    }
}

- (void)backClick{
    [[NSNotificationCenter defaultCenter]postNotificationName:kPartViewBackNotification object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setPrescription:(Prescription *)prescription{
    _prescription = prescription;
    self.navigationItem.title = self.prescription.name;
    self.contentLabel.text = self.prescription.part;
}

- (void)reRemember{
    [DataArray shareArray].index += 1;
    self.prescription = [DataArray shareArray].currentPrescription;
    self.textfield.enabled = YES;
    self.contentLabel.alpha = 1;
    self.textfield.text = @"";
    self.tipLabel.hidden = YES;
    self.scoreLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self submitClick:nil];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentLabel.alpha = 0;
    }];
    textField.textColor = [UIColor blackColor];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textfield resignFirstResponder];
}

- (IBAction)submitClick:(UIButton *)sender {
    [self.textfield resignFirstResponder];
    self.contentLabel.alpha = 1;
    if ([self.textfield.text isEqualToString:@""]) {
        return ;
    }
    self.textfield.enabled = NO;
    NSString *string = [self.textfield.text copy];
    NSArray *array;
    if ([string containsString:@"，"]) {
        array = [string componentsSeparatedByString:@"，"];
    }else if([string containsString:@","]){
        array = [string componentsSeparatedByString:@","];
    }else{
        array = [string componentsSeparatedByString:@" "];
    }
    NSArray *rightArr = [self.contentLabel.text componentsSeparatedByString:@" "];
    NSInteger totalNum = rightArr.count;
    __block int num = 0;
    __weak PartViewController *weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("calculate", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.textfield.text];
        for (int i = 0; i<array.count; i++) {
            for (int j = 0; j<rightArr.count; j++) {
                if ([rightArr[j] isEqualToString:array[i]]) {
                    num++;
                    for (int k = i + 1; k < array.count - i; k++) {
                        if ([array[k] isEqualToString:array[i]]) {
                            num--;
                            break;
                        }
                    }
                    break;
                }else{
                    if (j == rightArr.count - 1) {
                        NSRange range = [weakSelf.textfield.text rangeOfString:array[i]];
                        [str setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.textfield.attributedText = str;
        });
        float score = num / (float)totalNum;
        if (array.count > rightArr.count) {
           score -= 0.1;
        }
        weakSelf.prescription.score = score;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.scoreLabel.text = [NSString stringWithFormat:@"%.1f",score * 100];
            weakSelf.scoreLabel.hidden = NO;
            if ([weakSelf.textfield.text isEqualToString:@""] || !weakSelf.textfield.text) {
                weakSelf.tipLabel.hidden = YES;
            }else{
                weakSelf.tipLabel.hidden = NO;
            }
        });
    });
}
@end
