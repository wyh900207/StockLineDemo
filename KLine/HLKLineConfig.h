//
//  HLKLineConfig.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#ifndef HLKLineConfig_h
#define HLKLineConfig_h

#import "UIColor+Hex.h"

//Kline种类
typedef NS_ENUM(NSInteger, HLKLineMainViewType) {
    HLKLineMainViewTypeKLine= 1, //K线
    HLKLineMainViewTypeTimeLine,  //分时图
    HLKLineMainViewTypeOther
};

// K线 默认宽度
#define LINE_WIDTH 5
// K线 最大宽度
#define LINE_MAX_WIDTH 20
// K线 最大宽度
#define LINE_MIN_WIDTH 2
// k线 影线宽度
#define LINE_SHADOW_WIDTH 1
// K线间隔
#define LINE_SPACE 1;
// K线图缩放界限
#define CHART_VIEW_SCALE_BOUNDS 0.03
// K线的缩放因子
#define CHART_VIEW_SCALE_FACTOR 0.03

// 辅助背景色
#define ASSIST_BACKGROUND_COLOR HexColor(@"1d2227")
// 辅助文字颜色
#define ASSIST_TEXT_COLOR HexColor(@"565a64")

// K线 默认宽度
static CGFloat kLineWith = LINE_WIDTH;

// 获取K线宽度, 默认20
static inline CGFloat lineWidth() {
    return kLineWith;
}
// 设置K线宽度, 最大20, 最小2
static inline void setkLineWidth(CGFloat width) {
    if (width > LINE_MAX_WIDTH) {
        width = LINE_MAX_WIDTH;
    }
    else if (width < LINE_MIN_WIDTH) {
        width = LINE_MIN_WIDTH;
    }
    
    kLineWith = width;
}


#endif /* HLKLineConfig_h */
