//
//  ViewController.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "ViewController.h"
//#import "HLKLineMainView.h"
#import "OTJKLineView.h"
#import "OTJQuotationPriceView.h"
#import "OTJSegmentView.h"

#import <Masonry/Masonry.h>

@interface ViewController ()<OTJSegmentViewDelegate>

@property (nonatomic, strong) OTJKLineView *mainview;
@property (nonatomic, strong) OTJQuotationPriceView *priceView;
@property (nonatomic, strong) OTJSegmentView *segmentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self.view addSubview:self.priceView];
    [self.view addSubview:self.mainview];
    [self.view addSubview:self.segmentView];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).inset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@70);
    }];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    [self.mainview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@200);
    }];

    [self.mainview reDraw];
}

#pragma mark - Getter

- (OTJKLineView *)mainview {
    if (!_mainview) {
        _mainview = [OTJKLineView new];
        _mainview.mainViewType = HLKLineMainViewTypeKLine;
        _mainview.kLineModels = [self allKLineModels];
    }
    return _mainview;
}

- (OTJQuotationPriceView *)priceView {
    if (!_priceView) {
        _priceView = [OTJQuotationPriceView new];
    }
    return _priceView;
}

- (OTJSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [OTJSegmentView new];
        _segmentView.delegate = self;
        _segmentView.titles = @[@"分时", @"1分", @"5分", @"15分", @"30分", @"60分"];
    }
    return _segmentView;
}

#pragma mark - Private

// 模拟假数据
- (NSArray<HLKLineModel *> *)allKLineModels {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSArray<NSArray<NSString *> *> *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    __block NSMutableArray<HLKLineModel *> *entries = @[].mutableCopy;
    
    [array enumerateObjectsUsingBlock:^(NSArray<NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HLKLineModel *model = [HLKLineModel new];
        model.date = obj[0];
        model.open = @(obj[1].doubleValue);
        model.close = @(obj[2].doubleValue);
        model.high = @(obj[3].doubleValue);
        model.low = @(obj[4].doubleValue);
        
        [entries addObject:model];
    }];
    
    return entries;
}

#pragma mark - OTJSegmentViewDelegate

- (void)segmentView:(OTJSegmentView *)segmentView didSelectIndex:(NSInteger)index {
    NSLog(@"%lu", index);
    // TODO: 更新K线展示形式
}

@end
