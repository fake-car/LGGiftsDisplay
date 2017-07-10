//
//  GiftsViewShower.m
//  wankrzhibo
//
//  Created by inter on 16/8/19.
//  Copyright © 2016年 com.wankr. All rights reserved.
//
#import "GiftsViewDisplay.h"
#import "SingleGiftView.h"
#define TimeInterval 3
#define maxGiftsSeats 2
@interface GiftsViewDisplay ()<SingleViewDelegate>
{
    //当前礼物播放列表
    NSMutableArray *_currentGiftArr;
    //当前礼物块
    BOOL full[maxGiftsSeats];
    //礼物队列
    NSMutableArray *_giftsArr;
    //定时清除过期礼物
    NSTimer *_giftTimer;
    //添加礼物定时器
    NSTimer *_addGiftTimer;
    dispatch_source_t _timer;
    //礼物数组，固定放几个礼物对象
    NSMutableArray *_giftViewArr;
    
}
@end
@implementation GiftsViewDisplay

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _giftTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(delGifts) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_giftTimer forMode:NSRunLoopCommonModes];
        
        
        _addGiftTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addGiftToCurrent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_addGiftTimer forMode:NSRunLoopCommonModes];
        _currentGiftArr =  [NSMutableArray array];
        _giftsArr = [NSMutableArray array];
        
        _giftViewArr = [NSMutableArray array];
    }
    return self;
}
- (void)destory
{
    [_addGiftTimer invalidate];
    _addGiftTimer = nil;
    [_giftTimer invalidate];
    _giftTimer = nil;
}

#pragma mark -setter and getter
//设置单行礼物高度
- (void)setSingleViewHeight:(CGFloat)singleViewHeight
{
    if (_singleViewHeight != singleViewHeight) {
        _singleViewHeight = singleViewHeight;
        
        [self addGiftViewsToArr];
    }
}

#pragma mark - 添加
/*************添加***************/

- (void)addGiftViewsToArr
{
    for (int i = 0; i< maxGiftsSeats; i++) {
        SingleGiftView *singleView = [[SingleGiftView alloc] initWithFrame:CGRectMake(0, self.singleViewHeight * i, self.width, self.singleViewHeight)];
        singleView.delegate = self;
        singleView.index = i;
        [self addSubview:singleView];
        [_giftViewArr addObject:singleView];
        
    }
}

//添加到礼物队列
- (void)addGift:(Gift *)gift
{
    BOOL isSearil = [self isSearil:gift];
    if (!isSearil) {
        [_giftsArr addObject:gift];
        
        if (_addGiftTimer == nil) {
            _addGiftTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addGiftToCurrent) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_addGiftTimer forMode:NSRunLoopCommonModes];
            
        }
        if (_giftTimer == nil) {
            _giftTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(delGifts) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_giftTimer forMode:NSRunLoopCommonModes];
            [_giftTimer fire];
        }
    }
}

//添加到播放队列
- (void)addGiftToCurrent
{
    if (_giftsArr.count  == 0) {
        [_addGiftTimer invalidate];
        _addGiftTimer = nil;
        return;
    }
    for (int i = 0; i < maxGiftsSeats; i++) {
        BOOL isFull = full[i];
        if (!isFull) {
            //有空位
            full[i] = !full[i];
            
            //从礼物数组中取一个礼物
            Gift *gift = _giftsArr[0];
            gift.date = [NSDate date];
            //从礼物视图数组里取空闲视图
            SingleGiftView *singleView = _giftViewArr[i];
            
            singleView.gift = gift;
            
            //把当前播放礼物加入当前播放数组
            [_currentGiftArr addObject:gift];
            
            //移除掉已经添加过的礼物
            [_giftsArr removeObjectAtIndex:0];
            
            [self isGif:singleView];
            [singleView giftAnimation];
            break;
        }
    }
}
#pragma mark - 播放
/*************播放*******************/
//是否连击
- (BOOL)isSearil:(Gift *)gift
{
    return NO;
}

//是否是gif
- (void)isGif:(SingleGiftView *)singleView
{
    
}

#pragma mark - 删除
/*************删除**************/
- (void)delGifts
{
    if (_currentGiftArr.count == 0) {
//        [_giftTimer invalidate];
//        _giftTimer = nil;
        return;
    }
    
    for (int index = 0; index < _giftViewArr.count; index++) {
        
        SingleGiftView *singleView = _giftViewArr[index];
        //判断礼物时间
        NSInteger second = [self getTimeIntervalFromNow:singleView.gift.date];
        if (second >= TimeInterval) {
            //过时删除
            [_currentGiftArr removeObject:singleView.gift];
            singleView.gift = nil;
            [singleView reset];
            -- index;
        }
    }
}

#pragma mark 计算时间间隔
- (NSInteger)getTimeIntervalFromNow:(NSDate*)from{
    if (!from) {
        return 0;
    }
    NSDate *to = [NSDate date];
    NSTimeInterval aTimer = [to timeIntervalSinceDate:from];
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    return second;
}

#pragma mark - SingleViewDelegate
- (void)singleViewFinishResetAnimation:(NSInteger)index
{
    full[index] = !full[index];
}

@end
