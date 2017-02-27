//
//  DataArray.h
//  千金方
//
//  Created by 周小伟 on 2017/2/5.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prescription.h"
@interface DataArray : NSObject

@property (nonatomic,weak) Prescription *currentPrescription;

@property (nonatomic,strong) NSMutableArray *wrongPrescription;

@property (nonatomic,strong) NSArray * totalPrescritions;

@property (nonatomic,strong) NSArray *everyDayPrescription;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) NSInteger wrongIndex;

+ (instancetype)shareArray;

- (void)appendOldPrescription:(Prescription *)prescription;

- (void)appendScorePrescription:(Prescription *)prescription;

- (void)appendRightPrescription:(Prescription *)prescription;

- (void)resetAllPrescription;

- (void)noResetAllPrescription;

@end
//熟地 山药 枸杞子 炙甘草 茯苓 山茱萸
