//
//  OTJVolumeView.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJVolumeView.h"

@interface OTJVolumeView ()

/**
 *  需要绘制的成交量的位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineVolumePositionModels;

/**
 *  Volume_MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA7Positions;

/**
 *  Volume_MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA30Positions;

@end

@implementation OTJVolumeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexColor(@"FFFFFF");
        self.Volume_MA7Positions = @[].mutableCopy;
        self.Volume_MA30Positions = @[].mutableCopy;
    }
    return self;
}

#pragma mark - DrawRect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.needDrawKLineVolumePositionModels) return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
}

@end
