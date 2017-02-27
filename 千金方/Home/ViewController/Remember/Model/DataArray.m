//
//  DataArray.m
//  千金方
//
//  Created by 周小伟 on 2017/2/5.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "DataArray.h"
#import "Prescription.h"
#import "SqliteTool.h"

@interface DataArray ()
@property (nonatomic,strong) NSMutableArray *totalArray;
@end

@implementation DataArray
@synthesize index = _index;
static DataArray *singleArray = nil;
+ (instancetype)shareArray{
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        singleArray = [[super allocWithZone:NULL]init];
    });
    return singleArray;
}

- (NSInteger)index{
    NSInteger num = [[NSUserDefaults standardUserDefaults]integerForKey:@"index"];
    _index = num;
    return _index;
}

- (void)setIndex:(NSInteger)index{
    
    if (index < 0) {
        _index = self.totalPrescritions.count + self.wrongPrescription.count - 1;
    }else if(index > self.totalPrescritions.count - 1 + self.wrongPrescription.count){
        _index = 0;
    }else{
        _index = index;
    }
    [[NSUserDefaults standardUserDefaults]setInteger:_index forKey:@"index"];
}

- (void)noResetAllPrescription{
    self.totalPrescritions = [[SqliteTool shareTool] selectWithSql:@"select * from t_prescription"];
}

- (void)resetAllPrescription{
    [[SqliteTool shareTool] excuteTheSql:@"update t_prescription set isOld = 'NO',score = 0.0"];
    self.wrongPrescription = nil;
    self.totalPrescritions = nil;
}

- (Prescription *)currentPrescription{
//    NSLog(@"%@,wrong:%@",@(self.index),@(self.wrongPrescription.count));
    if (self.wrongPrescription.count == 0) {
        if (self.totalPrescritions.count == 0) {
            return nil;
        }else{
            return self.totalPrescritions[self.index];
        }
    }else{
        if (self.index > self.wrongPrescription.count - 1) {
            return self.totalPrescritions[self.index - self.wrongPrescription.count];
        }else{
            return self.wrongPrescription[self.index];
        }
    }
}

- (id)copy{
    return [DataArray shareArray];
}

- (id)mutableCopy{
    return [DataArray shareArray];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [DataArray shareArray];
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return nil;
}

- (NSArray *)totalPrescritions{
    if (_totalPrescritions == nil) {
        NSArray *array = [[SqliteTool shareTool]selectWithSql:@"select * from t_prescription where isOld = 'NO' and score = 0.0;"];
        _totalPrescritions = array;
    }
    return _totalPrescritions;
}

- (NSMutableArray *)wrongPrescription{
    if (_wrongPrescription == nil) {
        NSArray *array = [[SqliteTool shareTool]selectWithSql:@"select * from t_prescription where score < 0.99 and score > 0.0 order by score;"];
        NSMutableArray *wrongArray = [NSMutableArray arrayWithArray:array];
        _wrongPrescription = wrongArray;
    }
    return _wrongPrescription;
}
// 熟地 山药 枸杞 山茱萸 川牛膝 鹿角胶 龟板胶 菟丝子
- (void)appendOldPrescription:(Prescription *)prescription{
    [[SqliteTool shareTool] excuteTheSql:[NSString stringWithFormat:@"update t_prescription set isOld = 'YES' where name = '%@';",prescription.name]];
    self.totalPrescritions = nil;
}

- (void)appendScorePrescription:(Prescription *)prescription{
    [[SqliteTool shareTool] excuteTheSql:[NSString stringWithFormat:@"update t_prescription set score = %f where name = '%@';",prescription.score,prescription.name]];
    self.wrongPrescription = nil;
}

- (void)appendRightPrescription:(Prescription *)prescription{
    [self appendOldPrescription:prescription];
}


@end
