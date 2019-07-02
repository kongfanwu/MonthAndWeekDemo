//
//  XMHMonthAndWeekCollectionView.m
//  MonthAndWeekDemo
//
//  Created by kfw on 2019/7/1.
//  Copyright © 2019 kfw. All rights reserved.
//

#import "XMHMonthAndWeekCollectionView.h"
#import "XMHCollectionWeekCell.h"
#import "XMHCollectionMonthCell.h"

@interface XMHMonthAndWeekCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource>

/** <##> */
@property (nonatomic, strong) UICollectionViewCell *lastCell;
/** <##> */
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@end

@implementation XMHMonthAndWeekCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        _type = XMHMonthAndWeekCollectionViewTypeWeek;
        _xmhScrollDirection = UICollectionViewScrollDirectionVertical;
        self.delegate = self;
        self.dataSource = self;

        [self registerClass:[XMHCollectionWeekCell class] forCellWithReuseIdentifier:@"XMHCollectionWeekCellIdentifier"];
        [self registerClass:[XMHCollectionMonthCell class] forCellWithReuseIdentifier:@"XMHCollectionMonthCellIdentifier"];
        
    }
    return self;
}

#pragma mark - Private

- (void)setXmhScrollDirection:(UICollectionViewScrollDirection)xmhScrollDirection {
    _xmhScrollDirection = xmhScrollDirection;
    self.collectionViewLayout = [self.class layoutFromScrollDirection:xmhScrollDirection];
    [self reloadData];
}

#pragma mark - Public

/**
 返回cell 高

 @param type 类型
 @return cell 高
 */
+ (CGFloat)cellHeightType:(XMHMonthAndWeekCollectionViewType)type {
    return type == XMHMonthAndWeekCollectionViewTypeWeek ? 50 : 25;
}

/**
 返回cell 行间距
 */
+ (CGFloat)cellMinimumLineSpacingType:(XMHMonthAndWeekCollectionViewType)type {
    if (type == XMHMonthAndWeekCollectionViewTypeWeek) {
        return 10;
    } else {
        return 20;
    }
}

/**
 返回cell 间间距
 */
+ (CGFloat)cellMinimumInteritemSpacingType:(XMHMonthAndWeekCollectionViewType)type {
    if (type == XMHMonthAndWeekCollectionViewTypeWeek) {
        return 10;
    } else {
        return 27;
    }
}

/**
 每行cell 数量
 */
+ (NSUInteger)lineItemCountType:(XMHMonthAndWeekCollectionViewType)type {
    return 4;
}

/**
 通过滑动方向创建layout
 */
+ (UICollectionViewFlowLayout *)layoutFromScrollDirection:(UICollectionViewScrollDirection)xmhScrollDirection {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = xmhScrollDirection;
    return layout;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == XMHMonthAndWeekCollectionViewTypeWeek) {
        XMHCollectionWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMHCollectionWeekCellIdentifier" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(150)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        cell.label.text = [NSString stringWithFormat:@"%ld",indexPath.item];
        if (_lastIndexPath && indexPath.item == _lastIndexPath.item) {
            cell.backgroundColor = UIColor.redColor;
        }
        return cell;
    } else {
        XMHCollectionMonthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMHCollectionMonthCellIdentifier" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(150)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        if (_lastIndexPath && indexPath.item == _lastIndexPath.item) {
            cell.backgroundColor = UIColor.redColor;
        }
        return cell;
    }
    return UICollectionViewCell.new;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == XMHMonthAndWeekCollectionViewTypeWeek) {
        NSInteger lineItemCount = [self.class lineItemCountType:_type];
        CGFloat itemW = (collectionView.width - (10 * (lineItemCount - 1)) - 15 * 2) / lineItemCount;
        return CGSizeMake(itemW, [self.class cellHeightType:_type]);
    } else {
        NSInteger lineItemCount = [self.class lineItemCountType:_type];;
        CGFloat itemW = (collectionView.width - (27 * (lineItemCount - 1)) - 20 * 2) / lineItemCount;
        return CGSizeMake(itemW, [self.class cellHeightType:_type]);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (_type == XMHMonthAndWeekCollectionViewTypeWeek) {
        return UIEdgeInsetsMake(0, 15, 0, 15);
    } else {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self.class cellMinimumLineSpacingType:_type];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self.class cellMinimumInteritemSpacingType:_type];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastCell) {
        self.lastCell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    }
    
    self.lastIndexPath = indexPath;
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    self.lastCell = cell;
    cell.backgroundColor = UIColor.redColor;
    
    self.lastFrame = cell.frame;
}

@end
