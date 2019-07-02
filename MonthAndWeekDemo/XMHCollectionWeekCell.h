//
//  XMHCollectionWeekCell.h
//  MonthAndWeekDemo
//
//  Created by kfw on 2019/7/1.
//  Copyright © 2019 kfw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMHMonthAndWeekModel;

NS_ASSUME_NONNULL_BEGIN

@interface XMHCollectionWeekCell : UICollectionViewCell
/** <##> */
@property (nonatomic, strong) UILabel *label;

- (void)configModel:(XMHMonthAndWeekModel *)model;

@end

NS_ASSUME_NONNULL_END
