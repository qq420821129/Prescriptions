//
//  HomeBottomView.h
//  千金方
//
//  Created by 周小伟 on 2017/2/1.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeBottomView;
@protocol HomeBottomViewDelegate <NSObject>

- (void)homeBottomView:(HomeBottomView *)bottomView clickPrevious:(UIButton *)button;

- (void)homeBottomView:(HomeBottomView *)bottomView clickRemember:(UIButton *)button;

- (void)homeBottomView:(HomeBottomView *)bottomView clickNextOne:(UIButton *)button;

@end
@interface HomeBottomView : UIView
@property (nonatomic,weak) id<HomeBottomViewDelegate> delegate;
@end
