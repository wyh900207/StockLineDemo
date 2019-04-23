//
//  OTJVolumePositionModel.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJVolumePositionModel.h"

@implementation OTJVolumePositionModel

+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    OTJVolumePositionModel *volumePositionModel = [OTJVolumePositionModel new];
    volumePositionModel.StartPoint = startPoint;
    volumePositionModel.EndPoint = endPoint;
    
    return volumePositionModel;
}

@end
