//
//  OTJSegmentView.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/22.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OTJSegmentView;

NS_ASSUME_NONNULL_BEGIN

@protocol OTJSegmentViewDelegate <NSObject>

@optional

- (void)segmentView:(OTJSegmentView *)segmentView didSelectIndex:(NSInteger)index;

@end

@interface OTJSegmentView : UIView

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, weak  ) id<OTJSegmentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
