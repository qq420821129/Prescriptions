//
//  SqliteTool.m
//  千金方
//
//  Created by 周小伟 on 2017/2/5.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "SqliteTool.h"
#import <sqlite3.h>
@implementation SqliteTool
static sqlite3 *db;
static SqliteTool *tool = nil;

+ (instancetype)shareTool{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        tool = [[super allocWithZone:NULL]init];
    });
    return tool;
}

- (id)copy{
    return [SqliteTool shareTool];
}

- (id)mutableCopy{
    return [SqliteTool shareTool];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [SqliteTool shareTool];
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return nil;
}

+ (void)initialize{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"allData.db" ofType:nil];
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"Prescription.db"];
    NSString *path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"MyPrescription.db"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path2]) {
        [manager removeItemAtPath:path2 error:NULL];
    }
    if (![manager fileExistsAtPath:path1]) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{}];
        if (path) {
            [manager copyItemAtPath:path toPath:path1 error:&error];
        }
    }
    if (sqlite3_open(path1.UTF8String, &db) == SQLITE_OK) {
    }else{
//        NSLog(@"打开失败");
    }
}

- (void)excuteTheSql:(NSString *)sql{
    char *errormsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errormsg);
    if (errormsg) {
//        NSLog(@"%@",[NSString stringWithUTF8String:errormsg]);
    }
}

- (NSArray *)selectPart{
    NSString *sql = @"select name,part from t_prescription";
    sqlite3_stmt *stmt;
    NSMutableArray *array = [NSMutableArray array];
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            @autoreleasepool {
                for (int i = 0; i<2; i++) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    NSString *string = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, i) encoding:NSUTF8StringEncoding];
                    [dict setObject:string forKey:[NSString stringWithUTF8String:sqlite3_column_name(stmt, i)]];
                    [array addObject:dict];
                }
            }
        }
    }
    return array;
}

- (NSArray *)selectWithSql:(NSString *)sql{
    sqlite3_stmt *stmt;
    NSMutableArray *array = [NSMutableArray array];
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            for (int i = 0; i<sqlite3_column_count(stmt)-1; i++) {
                
                NSString *string = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i + 1)];
                
                [dictionary setObject:string forKey:[NSString stringWithUTF8String:sqlite3_column_name(stmt, i+1)]];
            }
            Prescription *modal = [Prescription prescriptionWithDic:dictionary];
            [array addObject:modal];
        }
    }
    return array;
}

- (NSArray *)selectMedicineWithSql:(NSString *)sql{
    sqlite3_stmt *stmt;
    NSMutableArray *array = [NSMutableArray array];
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            for (int i = 1; i<sqlite3_column_count(stmt); i++) {
                
                NSString *string = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
                [dictionary setObject:string forKey:[NSString stringWithUTF8String:sqlite3_column_name(stmt, i)]];
            }
            Medicine *medicine = [Medicine medicineModeWithDict:dictionary];
            [array addObject:medicine];
        }
    }
    return array;
}

- (Medicine *)selectTheMedicine:(NSString *)medicineName{
    sqlite3_stmt *stmt;
    NSString *sqlString = [NSString stringWithFormat:@"select * from t_medicine where name = '%@'",medicineName];
    if (sqlite3_prepare_v2(db, sqlString.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            for (int i = 1; i<sqlite3_column_count(stmt); i++) {
                
                NSString *string = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
                [dictionary setObject:string forKey:[NSString stringWithUTF8String:sqlite3_column_name(stmt, i)]];
            }
            Medicine *medicine = [Medicine medicineModeWithDict:dictionary];
            return medicine;
        }
    }
    return nil;
}


- (void)inssertWithPrescription:(Prescription *)prescription andTableName:(NSString *)tableName{
    [self excuteTheSql:[NSString stringWithFormat:@"insert into %@ (name,junyao,chenyao,zuoyao,shiyao,zuoshiyao,song,classes,function,part,effect,cure,score,isOld) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%f,%d)",tableName,prescription.name,prescription.junyao,prescription.chenyao,prescription.zuoyao,prescription.shiyao,prescription.zuoshiyao,prescription.song,prescription.classes,prescription.function,prescription.part,prescription.effect,prescription.cure,prescription.score,prescription.isOld]];
}

@end
