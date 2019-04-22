//
//  OTJKLineView.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/22.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLKLineModel.h"
#import "HLKLineConfig.h"

@interface OTJKLineView : UIView

// 主视图高度比例
@property (nonatomic, assign) CGFloat mainViewRatio;
// 成交量视图高度比例
@property (nonatomic, assign) CGFloat volumeViewRatio;
// 数据源
@property (nonatomic, assign) NSArray<HLKLineModel *> *kLineModels;
// 主视图K线类型
@property (nonatomic, assign) HLKLineMainViewType mainViewType;

- (void)reDraw;

@end
