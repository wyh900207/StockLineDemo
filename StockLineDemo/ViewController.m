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

@interface ViewController ()

@property (nonatomic, strong) OTJKLineView *mainview;
@property (nonatomic, strong) OTJQuotationPriceView *priceView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self.view addSubview:self.priceView];
    [self.view addSubview:self.mainview];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).inset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@70);
    }];
    [self.mainview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [self.mainview reDraw];
}

#pragma mark - Getter

- (OTJKLineView *)mainview {
    if (!_mainview) {
        _mainview = [OTJKLineView new];
        _mainview.mainViewRatio = 0.5;
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

@end
