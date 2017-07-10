//
//  GiftsViewShower.h
//  wankrzhibo
//
//  Created by inter on 16/8/19.
//  Copyright © 2016年 com.wankr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gift.h"
@protocol GiftsViewShowerDelegate <NSObject>

- (void)animationGift;

@end

@interface GiftsViewDisplay : UIView

@property (nonatomic, assign) CGFloat singleViewHeight;

- (void)addGift:(Gift *)gift;
- (void)destory;
@end
