//
//  XMHMonthAndWeekCollectionView.h
//  MonthAndWeekDemo
//
//  Created by kfw on 2019/7/1.
//  Copyright © 2019 kfw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMHMonthAndWeekModel;

/**
 日历类型
 */
typedef NS_ENUM(NSInteger, XMHMonthAndWeekCollectionViewType) {
    XMHMonthAndWeekCollectionViewTypeMonth, // 月
    XMHMonthAndWeekCollectionViewTypeWeek,  // 周
};


NS_ASSUME_NONNULL_BEGIN

@interface XMHMonthAndWeekCollectionView : UICollectionView
/** default XMHMonthAndWeekCollectionViewTypeWeek */
@property (nonatomic) XMHMonthAndWeekCollectionViewType type;

/** 最后一个cell frame */
@property(nonatomic) CGRect lastFrame;

/**
 滑动方向
 UICollectionViewScrollDirectionVertical,  默认，上下滑动，展开样式。
 UICollectionViewScrollDirectionHorizontal 左右滑动，收起状态。
 */
@property (nonatomic) UICollectionViewScrollDirection xmhScrollDirection;

/** <##> */
@property (nonatomic, strong) NSArray <XMHMonthAndWeekModel *> *dataArray;

/**
 返回cell 高
 
 @param type 类型
 @return cell 高
 */
+ (CGFloat)cellHeightType:(XMHMonthAndWeekCollectionViewType)type;

/**
 返回cell 行间距
 */
+ (CGFloat)cellMinimumLineSpacingType:(XMHMonthAndWeekCollectionViewType)type;

/**
 返回cell 间间距
 */
+ (CGFloat)cellMinimumInteritemSpacingType:(XMHMonthAndWeekCollectionViewType)type;

/**
 每行cell 数量
 */
+ (NSUInteger)lineItemCountType:(XMHMonthAndWeekCollectionViewType)type;

/**
 通过滑动方向创建layout
 */
+ (UICollectionViewFlowLayout *)layoutFromScrollDirection:(UICollectionViewScrollDirection)xmhScrollDirection;
@end

NS_ASSUME_NONNULL_END
