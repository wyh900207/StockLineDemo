//
//  OTJMainViewIndicationSegmentView.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OTJMainViewIndicationSegmentView;

NS_ASSUME_NONNULL_BEGIN

@protocol OTJMainViewIndicationSegmentViewDelegate <NSObject>

@optional

- (void)mainIndicationView:(OTJMainViewIndicationSegmentView *)indicationView didSelectIndex:(NSInteger)index;

@end

@interface OTJMainViewIndicationSegmentView : UIView

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, weak  ) id<OTJMainViewIndicationSegmentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
