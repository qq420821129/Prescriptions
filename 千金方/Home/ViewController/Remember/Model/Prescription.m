//
//  Prescription.m
//  千金方
//
//  Created by 周小伟 on 2017/1/29.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "Prescription.h"
#import "DataArray.h"
@implementation Prescription

- (instancetype)initWithDic:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.lineNumber = 0;
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:self.part];
        if (![dict[@"junyao"] isEqualToString:@"缺失"]) {
            self.lineNumber += 1;
            [array addObject:self.junyao];
        }
        if (![dict[@"chenyao"] isEqualToString:@"缺失"]) {
            self.lineNumber += 1;
            [array addObject:self.chenyao];
        }
        if (![dict[@"zuoyao"] isEqualToString:@"缺失"]) {
            self.lineNumber += 1;
            [array addObject:self.zuoyao];
        }
        if (![dict[@"shiyao"] isEqualToString:@"缺失"]) {
            self.lineNumber += 1;
            [array addObject:self.shiyao];
        }
        if (![dict[@"zuoshiyao"] isEqualToString:@"缺失"]) {
            self.lineNumber += 1;
            [array addObject:self.zuoshiyao];
        }
        NSMutableArray *array1 = [NSMutableArray array];
        [array1 addObject:array];
        [array1 addObject:self.effect];
        [array1 addObject:self.cure];
        [array1 addObject:self.song];
        self.contentArray = array1;
    }
    return self;
}

+ (instancetype)prescriptionWithDic:(NSDictionary *)dict{
    return [[self alloc]initWithDic:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setScore:(float)score{
    _score = score;
    if (score  >= 0.99f) {
        [[DataArray shareArray] appendRightPrescription:self];
    }
        [[DataArray shareArray]appendScorePrescription:self];
    
}


@end
