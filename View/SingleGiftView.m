
//
//  SingleGiftView.m
//  wankrzhibo
//
//  Created by inter on 16/8/19.
//  Copyright © 2016年 com.wankr. All rights reserved.
//

#import "SingleGiftView.h"

@interface SingleGiftView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation SingleGiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

#pragma mark - private method

- (void)initViews
{
        
}

#pragma mark -setter and getter

- (void)setGift:(Gift *)gift
{
    if (_gift != gift) {
        _gift = gift;
        [self setNeedsLayout];
    }
}

- (void)setIndex:(NSInteger)index
{
    if (_index != index) {
        _index = index;
    }
}

- (void)setDelegate:(id<SingleViewDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

}

#pragma mark - animation
//礼物播放动画
- (void)giftAnimation
{
    [UIView
     animateWithDuration:0.3
     delay:0
     usingSpringWithDamping:0.6
     initialSpringVelocity:0
     options:UIViewAnimationOptionCurveLinear
     animations:^{
//         self.bgView.left = 10;
         self.bgView.transform = CGAffineTransformMakeTranslation(210, 0);
     } completion:^(BOOL finished) {
         [UIView
          animateWithDuration:0.3
          delay:0
          usingSpringWithDamping:0.6
          initialSpringVelocity:0
          options:UIViewAnimationOptionCurveEaseInOut
          animations:^{
          } completion:^(BOOL finished) {
          }];
     }];
}

- (void)reset
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = self.bgView.frame;
        rect.origin.y =  rect.origin.y - 30;
        self.bgView.frame = rect;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.bgView.top += 30;
        self.bgView.transform = CGAffineTransformIdentity;

        self.bgView.alpha = 1;
        if ([self.delegate respondsToSelector:@selector(singleViewFinishResetAnimation:)]) {
            [self.delegate singleViewFinishResetAnimation:self.index];
        }
    }];
}
@end
