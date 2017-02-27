//
//  XNavigationController.h
//  TestNav
//
//  Created by 周小伟 on 2017/1/13.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MyBlock)(NSDictionary *);
@interface XBaseNavigationController : UINavigationController

@property (nonatomic,assign) CGFloat alpha;

@property (nonatomic,copy) MyBlock block;

@end
