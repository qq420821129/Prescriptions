//
//  MedicineViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/2/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "MedicineViewController.h"
#import "Medicine.h"
@interface MedicineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tasteLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation MedicineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tasteLabel.text = self.medicine.taste;
    self.positionLabel.text = self.medicine.position;
    self.functionLabel.text = self.medicine.function;
    self.effectLabel.text = self.medicine.effect;
    self.numberLabel.text = [self.medicine.number stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    self.noticeLabel.text = self.medicine.notice;
    if (self.medicine.notice.length == 0) {
        self.tipLabel.hidden = YES;
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor backColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
