//
//  Prescription.h
//  千金方
//
//  Created by 周小伟 on 2017/1/29.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prescription : NSObject

@property (nonatomic,copy) NSString *name;      //方名

@property (nonatomic,copy) NSString *junyao;    //君药

@property (nonatomic,copy) NSString *chenyao;   //臣药

@property (nonatomic,copy) NSString *zuoyao;    //佐药

@property (nonatomic,copy) NSString *shiyao;    //使药

@property (nonatomic,copy) NSString *zuoshiyao; //佐使药

@property (nonatomic,copy) NSString *song;      //歌诀

@property (nonatomic,copy) NSString *classes;   //方剂分组

@property (nonatomic,copy) NSString *function;  //功效分类

@property (nonatomic,copy) NSString *part;      //药剂组成

@property (nonatomic,copy) NSString *effect;    //功效

@property (nonatomic,copy) NSString *cure;      //主治

@property (nonatomic,assign) float score;

@property (nonatomic,assign) BOOL isOld;

@property (nonatomic,assign) NSInteger lineNumber;

@property (nonatomic,strong) NSArray *contentArray;

- (instancetype)initWithDic:(NSDictionary *)dict;

+ (instancetype)prescriptionWithDic:(NSDictionary *)dict;

@end
