//
//  Medicine.h
//  千金方
//
//  Created by 周小伟 on 2017/2/14.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Medicine : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *taste;

@property (nonatomic,copy) NSString *position;

@property (nonatomic,copy) NSString *function;

@property (nonatomic,copy) NSString *effect;

@property (nonatomic,copy) NSString *number;

@property (nonatomic,copy) NSString *notice;

- (instancetype)initWithDic:(NSDictionary *)dict;

+ (instancetype)medicineModeWithDict:(NSDictionary *)dict;

@end
