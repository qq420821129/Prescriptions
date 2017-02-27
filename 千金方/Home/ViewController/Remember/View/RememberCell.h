//
//  RememberCell.h
//  千金方
//
//  Created by 周小伟 on 2017/1/21.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum Type{
    ClearAll,
    PresentAll
}RememberType;
@class RememberCell;
@class Medicine;
@protocol RememberCellDelegate <NSObject>
@optional
- (void)cell:(RememberCell *)cell clickMedicine:(Medicine *)medicine;

@end

@interface RememberCell : UITableViewCell

@property (nonatomic,assign) RememberType type;

@property (nonatomic,copy) NSString *contentString;

@property (nonatomic,copy) NSString *titleString;

@property (nonatomic,assign,getter=isNeedClick) BOOL needClick;

@property (nonatomic,weak) id<RememberCellDelegate> delegate;

- (CGFloat)heightWithContent:(NSString *)string;

@end
