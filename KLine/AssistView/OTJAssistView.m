//
//  OTJAssistView.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJAssistView.h"
#import "OTJKLineView.h"
#import "OTJVolumePositionModel.h"
#import "OTJAssistLine.h"
#import "OTJMALine.h"
#import "HLKLinePositionModel.h"

@interface OTJAssistView()

/**
 *  需要绘制的Volume_MACD位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineAccessoryPositionModels;

/**
 *  Volume_DIF位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_DIFPositions;

/**
 *  Volume_DEA位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_DEAPositions;

/**
 *  KDJ_K位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_KPositions;

/**
 *  KDJ_D位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_DPositions;

/**
 *  KDJ_J位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_JPositions;

@end

@implementation OTJAssistView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.Accessory_DIFPositions = @[].mutableCopy;
        self.Accessory_DEAPositions = @[].mutableCopy;
        self.Accessory_KDJ_KPositions = @[].mutableCopy;
        self.Accessory_KDJ_DPositions = @[].mutableCopy;
        self.Accessory_KDJ_JPositions = @[].mutableCopy;
    }
    return self;
}

#pragma mark - DrawRect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.needDrawKLineAccessoryPositionModels) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (self.targetLineStatus != HLKLineTypeKDJ) {
        // MACD
        OTJAssistLine *assist_line = [[OTJAssistLine alloc] initWithContext:ctx];
        [self.needDrawKLineAccessoryPositionModels enumerateObjectsUsingBlock:^(OTJVolumePositionModel * _Nonnull volumePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            assist_line.positionModel = volumePositionModel;
            assist_line.kLineModel = self.needDrawKLineModels[idx];
            assist_line.lineColor = self.kLineColors[idx];
            [assist_line draw];
        }];
        
        // DIF
        OTJMALine * MALine = [[OTJMALine alloc] initWithContext:ctx];
        MALine.MAPositions = self.Accessory_DIFPositions;
        [MALine draw];
        
        // DEA
        MALine.MAType = Y_MA30Type;
        MALine.MAPositions = self.Accessory_DEAPositions;
        [MALine draw];
    } else {
        // KDJ
        OTJMALine * MALine = [[OTJMALine alloc] initWithContext:ctx];
        
        //画KDJ_K线
        MALine.MAType = Y_MA7Type;
        MALine.MAPositions = self.Accessory_KDJ_KPositions;
        [MALine draw];
        
        //画KDJ_D线
        MALine.MAType = Y_MA30Type;
        MALine.MAPositions = self.Accessory_KDJ_DPositions;
        [MALine draw];
        
        //画KDJ_J线
        MALine.MAType = -1;
        MALine.MAPositions = self.Accessory_KDJ_JPositions;
        [MALine draw];
    }
}

- (void)draw {
    NSInteger kLineModelcount = self.needDrawKLineModels.count;
    NSInteger kLinePositionModelCount = self.needDrawKLinePositionModels.count;
    NSInteger kLineColorCount = self.kLineColors.count;
    NSAssert(self.needDrawKLineModels && self.needDrawKLinePositionModels && self.kLineColors && kLineColorCount == kLineModelcount && kLinePositionModelCount == kLineModelcount, @"数据异常，无法绘制Volume");
    self.needDrawKLineAccessoryPositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    [self setNeedsDisplay];
}

- (NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels {
    CGFloat minY = 20;
    CGFloat maxY = self.frame.size.height;
    
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = CGFLOAT_MIN;
    
    NSMutableArray *volumePositionModels = @[].mutableCopy;
    
    if (self.targetLineStatus != HLKLineTypeKDJ) {
        [kLineModels enumerateObjectsUsingBlock:^(HLKLineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.DIF) {
                if(model.DIF.floatValue < minValue) {
                    minValue = model.DIF.floatValue;
                }
                if(model.DIF.floatValue > maxValue) {
                    maxValue = model.DIF.floatValue;
                }
            }
            
            if (model.DEA) {
                if (minValue > model.DEA.floatValue) {
                    minValue = model.DEA.floatValue;
                }
                if (maxValue < model.DEA.floatValue) {
                    maxValue = model.DEA.floatValue;
                }
            }
            
            if(model.MACD)
            {
                if (minValue > model.MACD.floatValue) {
                    minValue = model.MACD.floatValue;
                }
                if (maxValue < model.MACD.floatValue) {
                    maxValue = model.MACD.floatValue;
                }
            }
        }];
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.Accessory_DIFPositions removeAllObjects];
        [self.Accessory_DEAPositions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(HLKLineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            HLKLinePositionModel * kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.high_point.x;
            //MA坐标转换
            CGFloat KDJ_K_Y = maxY;
            CGFloat KDJ_D_Y = maxY;
            CGFloat KDJ_J_Y = maxY;
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_K)
                {
                    KDJ_K_Y = maxY - (model.KDJ_K.floatValue - minValue)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_D)
                {
                    KDJ_D_Y = maxY - (model.KDJ_D.floatValue - minValue)/unitValue;
                }
            }
            if(unitValue > 0.0000001)
            {
                if(model.KDJ_J)
                {
                    KDJ_J_Y = maxY - (model.KDJ_J.floatValue - minValue)/unitValue;
                }
            }
            
            NSAssert(!isnan(KDJ_K_Y) && !isnan(KDJ_D_Y) && !isnan(KDJ_J_Y), @"出现NAN值");
            
            CGPoint KDJ_KPoint = CGPointMake(xPosition, KDJ_K_Y);
            CGPoint KDJ_DPoint = CGPointMake(xPosition, KDJ_D_Y);
            CGPoint KDJ_JPoint = CGPointMake(xPosition, KDJ_J_Y);
            
            
            if(model.KDJ_K)
            {
                [self.Accessory_KDJ_KPositions addObject: [NSValue valueWithCGPoint: KDJ_KPoint]];
            }
            if(model.KDJ_D)
            {
                [self.Accessory_KDJ_DPositions addObject: [NSValue valueWithCGPoint: KDJ_DPoint]];
            }
            if(model.KDJ_J)
            {
                [self.Accessory_KDJ_JPositions addObject: [NSValue valueWithCGPoint: KDJ_JPoint]];
            }
        }];
    }
    
    return volumePositionModels;
}

@end
