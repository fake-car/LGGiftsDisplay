//
//  SingleGiftView.h
//  wankrzhibo
//
//  Created by inter on 16/8/19.
//  Copyright © 2016年 com.wankr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gift.h"

@protocol SingleViewDelegate <NSObject>

- (void)singleViewFinishResetAnimation:(NSInteger)index;

@end

@interface SingleGiftView : UIView

@property (nonatomic, strong) Gift *gift;
@property (nonatomic, assign) NSInteger index; //播放位置 012
@property (nonatomic, weak) id<SingleViewDelegate> delegate;
- (void)giftAnimation;
- (void)reset; //重置
@end
