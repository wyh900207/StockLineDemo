//
//  OTJSegmentView.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/22.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJSegmentView.h"
#import <Masonry/Masonry.h>

@interface OTJSegmentView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@end

@implementation OTJSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


#pragma mark - Private

- (void)exchangedMainViewType:(UIButton *)button {
    
}

#pragma mark - Getter

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    
    [self layoutIfNeeded];
    
    UIButton *tmp_button;
    
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = [UIButton new];
        button.tag = i;
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitle:self.titles[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(exchangedMainViewType:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat count = self.titles.count;
        CGFloat width = self.bounds.size.width / count;
        
        button.frame = CGRectMake(count * i, 0, width, self.bounds.size.height);
        
        [self addSubview:button];
        
        //        if (i == 0) {
        //            [tmp_button mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.bottom.top.equalTo(self);
        //                make.left.equalTo(self);
        //            }];
        //        }
        //        else if (i == self.titles.count - 1) {
        //            [tmp_button mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.bottom.top.equalTo(self);
        //                make.left.equalTo(tmp_button.mas_right);
        //                make.width.equalTo(tmp_button);
        //                make.right.equalTo(self);
        //            }];
        //        }
        //        else {
        //            [tmp_button mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.bottom.top.equalTo(self);
        //                make.left.equalTo(tmp_button.mas_right);
        //                make.width.equalTo(tmp_button);
        //            }];
        //        }
        
        
        
        tmp_button = button;
    }
}

- (NSMutableArray<UIButton *> *)buttons {
    if (!_buttons) {
        _buttons = @[].mutableCopy;
    }
    return _buttons;
}

@end
