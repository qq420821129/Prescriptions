//
//  SqliteTool.h
//  千金方
//
//  Created by 周小伟 on 2017/2/5.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prescription.h"
#import "Medicine.h"
@interface SqliteTool : NSObject

+ (instancetype)shareTool;

- (NSArray *)selectWithSql:(NSString *)sql;

- (NSArray *)selectPart;

- (void)excuteTheSql:(NSString *)sql;

- (void)inssertWithPrescription:(Prescription *)prescription andTableName:(NSString *)tableName;

- (NSArray *)selectMedicineWithSql:(NSString *)sql;

- (Medicine *)selectTheMedicine:(NSString *)medicineName;
@end
