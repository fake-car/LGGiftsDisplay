//
//  WKLivingView.m
//  wankrzhibo
//
//  Created by inter on 16/8/15.
//  Copyright © 2016年 com.wankr. All rights reserved.
//

#import "GiftsView.h"
@interface GiftsView ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImage *judou;
@property (nonatomic, strong) UIView *numView; //数量视图
@property (nonatomic, strong) NSArray *numArr; //数量数组
@property (nonatomic, strong) NSArray *titleArr; //标题数组

@end
@implementation GiftsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numArr = @[@"1314", @"520", @"188", @"60", @"30", @"10", @"1"];
        self.titleArr = @[@"一生一世", @"我爱你", @"要抱抱", @"一切顺利", @"想你", @"十全十美", @"一心一意"];
        //注册监听改变方向的通知

    }
    return self;
}
- (id)initWIthBlock:(SelectedBlock)block
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _customView = [[CustomView alloc] initWithFrame:CGRectZero];
        
        _customView.block = block;
    }
    return self;
}
- (void)setIsVertical:(BOOL)isVertical
{
    _isVertical = isVertical;
    if (!_isVertical) {
        self.backgroundColor = [UIColor whiteColor];

    }
    _customView.isVertical = _isVertical;
}
- (void)setGiftList:(NSArray *)giftList
{
    if (_giftList != giftList) {
        _giftList = giftList;
        [self _initViews];
        [self createNumBgView];
    }
}

- (void)_initViews
{
    self.width = self.superview.width;
    _customView.giftList = self.giftList;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_Width, _customView.height)];
    _scrollView.contentSize = CGSizeMake(_customView.width, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    [_scrollView addSubview:_customView];
    
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    _pageCtrl.backgroundColor = self.isVertical? [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00] : [UIColor colorWithWhite:0 alpha:0.6];
    [_pageCtrl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    _pageCtrl.numberOfPages = _customView.items.count;
    _pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
    _pageCtrl.currentPageIndicatorTintColor =hllColor(197, 26, 0, 1);
    [self addSubview:_pageCtrl];
    [_pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_scrollView).offset(_scrollView.height);
        make.size.mas_equalTo(CGSizeMake(MainScreen_Width, 15));
    }];
    
    self.frame = CGRectMake(0, MainScreen_Hight, self.superview.width, _customView.height + _pageCtrl.height + 33);




}
//数量选择背景视图
- (void)createNumBgView
{
    self.numBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_Width, 0)];
    self.numBgView.hidden = YES;
    [self addSubview:self.numBgView];
    [self.numBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.superview);
    }];
    
    self.numView = [[UIView alloc] initWithFrame:CGRectMake((self.isVertical? MainScreen_Width : MainScreen_Hight) - (68 + 68 / 2.0 + 125 / 2.0), (self.isVertical? MainScreen_Hight : MainScreen_Width - 50) - (250 +33 - 20) , 125 , 250 )];
    self.numView.alpha = 0;
    [self.numBgView addSubview:self.numView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 125, (250 - 12.5)) style:UITableViewStylePlain];
    tableView.layer.borderWidth = 0.5;
    tableView.layer.borderColor = self.isVertical? [UIColor colorWithRed:0.89 green:0.88 blue:0.89 alpha:1.00].CGColor : [UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1.00].CGColor;
    if (!self.isVertical) {
        tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];

    }
    tableView.clipsToBounds = NO;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.numView addSubview:tableView];
   
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake((tableView.width - 12.5 *ADAPT_IPHONE_SCALE) / 2, tableView.height - 0.5 *ADAPT_IPHONE_SCALE, 12.5 *ADAPT_IPHONE_SCALE, 13.0 *ADAPT_IPHONE_SCALE)];
    arrowView.image = self.isVertical? [UIImage imageNamed:@"gift_num_arrow_white"] : [UIImage imageNamed:@"gift_num_arrow_black"];
    [self.numView addSubview:arrowView];
    
    [self bringSubviewToFront:self.bottomView];
}
//余额
- (NSMutableAttributedString *)remainMoney
{
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *pStr = [[NSMutableAttributedString alloc] initWithString:@"余额:" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: (self.isVertical? BlackColor : WhiteColor)}];
    [pStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", [Config currentConfig].userDiamond] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName : hllColor(197, 27, 8, 1)}]];
    [mStr appendAttributedString:pStr];
    
    [mStr appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:self.judou contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(13.0, 13.0) alignToFont:[UIFont systemFontOfSize:13.0] alignment:YYTextVerticalAlignmentCenter]];
    
    return mStr;
}
- (void)pageAction:(UIPageControl *)pageCtrl
{
    [_scrollView setContentOffset:CGPointMake(pageCtrl.currentPage * self.width, 0) animated:YES];
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NumTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell= [[NumTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        if (!self.isVertical) {
//            cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
            cell.titleLabel.textColor = WhiteColor;
            UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
            view.backgroundColor = hllColor(59, 59, 59, 1);
            cell.selectedBackgroundView = view;
            
        }
    }
    cell.title = self.titleArr[indexPath.row];
//    if (indexPath.row != self.titleArr.count - 1) {
//        cell.num = self.numArr[indexPath.row];
//    }
    cell.num = self.numArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == self.titleArr.count -1) {
//        //自定义
//        [self.textField becomeFirstResponder];
//        [self showNumBgView:NO];
//    } else {
//        //可选数量
//        self.textField.text = self.numArr[indexPath.row];
//    }
    self.numLabel.text = self.numArr[indexPath.row];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.numView.height - 12.5 *ADAPT_IPHONE_SCALE)/ (CGFloat)self.titleArr.count;
}
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        _pageCtrl.currentPage = scrollView.contentOffset.x / self.width;
        
    }
}
#pragma mark -event respond
- (void)show:(BOOL)animated
{
     [UIView
      animateWithDuration:0.4
      delay:0
      usingSpringWithDamping:0.8
      initialSpringVelocity:0
      options:UIViewAnimationOptionCurveEaseInOut
      animations:^{
          if (self.isVertical) {
              self.bottom = self.superview.bottom;
          } else {
              self.right = self.superview.width;
          }
      } completion:^(BOOL finished) {
          
    }];
}
- (void)dismiss:(BOOL)animate
{
    if (animate) {
        [UIView
         animateWithDuration:0.4
         delay:0
         usingSpringWithDamping:0.8
         initialSpringVelocity:0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             if (self.isVertical) {
                 self.top = self.superview.bottom;
                 
             } else {
                 self.left = self.superview.width;
             }
         } completion:^(BOOL finished) {
             self.superview.hidden = YES;
             if ([self.delegate respondsToSelector:@selector(giftsViewWasDismissed)]) {
                 [self.delegate giftsViewWasDismissed];
             }

         }];

    } else {
        if (self.isVertical) {
            self.top = self.superview.bottom;
            
        } else {
            self.left = self.superview.width;
        }
        self.superview.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(giftsViewWasDismissed)]) {
            [self.delegate giftsViewWasDismissed];
        }
    }
    
}
- (void)showNumBgView:(BOOL)show
{
    if (show) {
        [UIView
         animateWithDuration:0.1
         delay:0
         options:UIViewAnimationOptionCurveEaseIn animations:^{
             self.numBgView.hidden = NO;
             self.numView.alpha = 1;
             self.numView.transform = CGAffineTransformMakeTranslation(0, -20 *ADAPT_IPHONE_SCALE);
         } completion:^(BOOL finished) {
             
         }];
    } else {
        [UIView
         animateWithDuration:0.1
         delay:0
         options:UIViewAnimationOptionCurveEaseIn animations:^{
             self.numView.alpha = 0;
         } completion:^(BOOL finished) {
             self.numBgView.hidden= YES;
             self.numView.transform = CGAffineTransformIdentity;
             if (self.arrow.selected) {
                 self.arrow.selected = !self.arrow.selected;
             }
         }];
    }

}
//改变旋转方向监听
//- (void)changeRotate:(NSNotification*)noti {
//    UIDevice* device = [noti valueForKey:@"object"];
//    if (device.orientation == UIInterfaceOrientationPortrait
//        || device.orientation == UIInterfaceOrientationPortraitUpsideDown) {
//        //竖屏
//        [self vertical];
//    } else {
//        //横屏
//        [self horizontal];
//    }
//}
////横屏
//- (void)horizontal
//{
//    self.isVertical = NO;
//    self.frame = CGRectMake(MainScreen_Hight, MainScreen_Width - 50 -self.height, MainScreen_Width, _customView.height + _pageCtrl.height + 33 *ADAPT_IPHONE_SCALE);
//    WKLog(@"%f,%f,%@", MainScreen_Width, MainScreen_Hight, NSStringFromCGRect(self.frame));
//}
////垂直
//- (void)vertical
//{
//    self.isVertical = YES;
//    self.frame = CGRectMake(0, MainScreen_Hight, self.superview.width, _customView.height + _pageCtrl.height + 33 *ADAPT_IPHONE_SCALE);
//    WKLog(@"%@", NSStringFromCGRect(self.frame));
//
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.numBgView.hidden == NO) {
        [self showNumBgView:NO];
    }

}
@end
