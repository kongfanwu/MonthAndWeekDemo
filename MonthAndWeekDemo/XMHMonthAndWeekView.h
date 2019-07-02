//
//  XMHMonthAndWeekView.h
//  FSCalendarExample
//
//  Created by kfw on 2019/7/1.
//  Copyright © 2019 wenchaoios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMHMonthAndWeekCollectionView.h"
#import "XMHDateNavBarView.h"

// 日期导航高
extern CGFloat kDateBarHeight;

NS_ASSUME_NONNULL_BEGIN

@interface XMHMonthAndWeekView : UIView
/** <##> */
@property (nonatomic, strong) XMHMonthAndWeekCollectionView *collectionView;
/** <##> */
@property (nonatomic, strong) XMHDateNavBarView *dateNavBarView;
- (void)handleScopeGesture:(UIPanGestureRecognizer *)sender;
/** 默认 YES 收起 NO 展开 */
@property (nonatomic) BOOL isFold;
/** <#type#> */
@property (nonatomic, copy) void (^frameDidChangeBlock)(void);

/** default XMHMonthAndWeekCollectionViewTypeWeek */
@property (nonatomic) XMHMonthAndWeekCollectionViewType type;
@end

NS_ASSUME_NONNULL_END
