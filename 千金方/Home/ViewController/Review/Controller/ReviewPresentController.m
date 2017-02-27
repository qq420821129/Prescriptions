//
//  ReviewPresentController.m
//  千金方
//
//  Created by 周小伟 on 2017/2/6.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "ReviewPresentController.h"
#import "Prescription.h"

@interface ReviewPresentController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *cureLabel;

@end

@implementation ReviewPresentController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backColor];
    self.titleLabel.text = self.prescription.name;
    self.contentLabel.text = self.prescription.part;
    self.functionLabel.text = self.prescription.function;
    self.songLabel.text = [self dealSongString:self.prescription.song];
    self.cureLabel.text = self.prescription.cure;
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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
