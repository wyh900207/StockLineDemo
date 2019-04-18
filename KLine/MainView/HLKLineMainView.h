//
//  HLKLineMainView.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLKLineConfig.h"


@protocol HLKLineMainViewDelegate <NSObject>

@optional

@end

@interface HLKLineMainView : UIView

/**
 模型数组
 */
@property (nonatomic, strong) NSArray *kLineModels;

/**
 代理
 */
@property (nonatomic, weak) id<HLKLineMainViewDelegate> delegate;

/**
 K线类型: K线 / 分时 / 其他
 */
@property (nonatomic, assign) HLKLineMainViewType *type;

/**
 画MainView所有线
 */
- (void)drawMainView;

/**
 更新MainView宽度
 */
- (void)updateMainViewWidth;

/**
 移除所有监听
 */
- (void)removeAllObserver;


@end
