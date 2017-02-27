//
//  MatchViewController.m
//  千金方
//
//  Created by 周小伟 on 2017/1/18.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "MatchViewController.h"
#import "Prescription.h"
#import "SqliteTool.h"
#import "MatchStrViewController.h"
@interface MatchViewController ()

@property (weak, nonatomic) IBOutlet UIButton *matchBtn;
- (IBAction)matchBtnClick:(UIButton *)sender;

@end

@implementation MatchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"匹配药方";
    
//    NSLog(@"开始");
//    for (int i = 0; i<self.dataArray.count; i++) {
//        NSLog(@"%d",i);
//        Prescription *prescription = self.dataArray[i];
//
////    NSLog(@"%@\n%@",prescription.name,prescription.part);
//        NSString *part = prescription.part;
//        NSLog(@"%@",part);
//    
//    }
//    NSLog(@"结束");
    
}


- (NSString *)updatePrescription:(Prescription *)prescription{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[prescription.part componentsSeparatedByString:@" "]];
    for (int i = 0; i<array.count; i++) {
        NSString *blank = array[i];
        if ([blank isEqualToString:@""]) {
            [array removeObject:blank];
        }
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    for (int i = 0;i<arr.count;i++) {
        NSString *str = arr[i];
        NSMutableString *string = [NSMutableString stringWithString:str];
        CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformStripDiacritics, NO);
        string = (NSMutableString *)[string stringByReplacingOccurrencesOfString:@" " withString:@""];
        [arr replaceObjectAtIndex:[arr indexOfObject:str] withObject:string];
    }
    NSString *midStr;
    NSString *fMidStr;
    for (int i = 0; i<arr.count; i++) {
        for (int j = i + 1; j < arr.count; j++) {
            const char *str1 = [arr[i] cStringUsingEncoding:NSUTF8StringEncoding];
            const char *str2 = [arr[j] cStringUsingEncoding:NSUTF8StringEncoding];
            if (strcmp(str1, str2) >= 0) {
                midStr = arr[i];
                arr[i] = arr[j];
                arr[j] = midStr;
                
                fMidStr = array[i];
                array[i] = array[j];
                array[j] = fMidStr;
            }
        }
    }
    
    NSMutableString *returnStr = [NSMutableString string];
    for (int i = 0; i<array.count; i++) {
        [returnStr appendString:array[i]];
        if (i != array.count - 1) {
            [returnStr appendString:@" "];
        }
    }
    
    return returnStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)matchBtnClick:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([MatchStrViewController class]) bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




- (CGFloat)matchArray:(NSArray *)array toArray:(NSString *)otherArray{
    CGFloat right = 0;
    for (int i = 0; i<array.count; i++) {
        if ([otherArray containsString:array[i]]) {
            right++;
        }
    }
    NSArray *rightArray = [otherArray componentsSeparatedByString:@" "];
    return right/(CGFloat)rightArray.count;
}


#pragma mark - textView delegate





#pragma mark - tableView datasource

@end
