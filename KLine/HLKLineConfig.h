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
#define LINE_WIDTH 20
// k线 影线宽度
#define LINE_SHADOW_WIDTH 1

// 辅助背景色
#define ASSIST_BACKGROUND_COLOR HexColor(@"1d2227")
// 辅助文字颜色
#define ASSIST_TEXT_COLOR HexColor(@"565a64")


#endif /* HLKLineConfig_h */
