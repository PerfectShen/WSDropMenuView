//
//  TWDropMenuView.h
//  WLMenu
//
//  Created by 万匿里 on 15/8/5.
//  Copyright (c) 2015年 万匿里. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WSNoFound (-1)

#define LeftButtonTitle @"左边"
#define RightButtonTitle @"右边"


/**
 *  目前是写死的 左边三级－ 修改的话 挺简单的  只要 修改didselect 点到第二级收回  还有修改tableview的宽度 既可以了  －
 */



@interface WSIndexPath : NSObject


@property (nonatomic,assign) NSInteger column; //区分  0 为左边的   1 是 右边的
@property (nonatomic,assign) NSInteger row; //左边第一级的行
@property (nonatomic,assign) NSInteger item; //左边第二级的行
@property (nonatomic,assign) NSInteger rank; //左边第三级的行

+ (instancetype)twIndexPathWithColumn:(NSInteger )column
                                  row:(NSInteger )row
                                 item:(NSInteger )item
                                 rank:(NSInteger )rank;

@end





@class WSDropMenuView;

@protocol WSDropMenuViewDataSource <NSObject>


- (NSInteger )dropMenuView:(WSDropMenuView *)dropMenuView numberWithIndexPath:(WSIndexPath *)indexPath;

- (NSString *)dropMenuView:(WSDropMenuView *)dropMenuView titleWithIndexPath:(WSIndexPath *)indexPath;


@end



@protocol WSDropMenuViewDelegate <NSObject>


- (void)dropMenuView:(WSDropMenuView *)dropMenuView didSelectWithIndexPath:(WSIndexPath *)indexPath;


@end

@interface WSDropMenuView : UIView

@property (nonatomic,weak) id<WSDropMenuViewDataSource> dataSource;
@property (nonatomic,weak) id<WSDropMenuViewDelegate> delegate;



- (void)reloadLeftTableView;

- (void)reloadRightTableView;

@end
