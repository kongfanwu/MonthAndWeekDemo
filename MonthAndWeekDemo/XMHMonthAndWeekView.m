//
//  XMHMonthAndWeekView.m
//  FSCalendarExample
//
//  Created by kfw on 2019/7/1.
//  Copyright © 2019 wenchaoios. All rights reserved.
//

#import "XMHMonthAndWeekView.h"

// 日期导航高
CGFloat kDateBarHeight = 50.f;

@interface XMHMonthAndWeekView()
/** self 高 */
@property (nonatomic) CGFloat originHeight;
/** cell 高 */
@property (nonatomic) CGFloat cellMinHeight;
/** cell 行间距 */
@property (nonatomic) CGFloat cellMinimumLineSpacing;
/** cell 间间距 */
@property (nonatomic) CGFloat cellMinimumInteritemSpacing;
/** collectionView 每行cell数量 */
@property (nonatomic) NSUInteger lineItemCount;
/** 开始滑动偏移量 */
@property(nonatomic) CGPoint beginContentOffset;
/** <##> */
@property (nonatomic, strong) UIView *dateNavBarView;
@end

@implementation XMHMonthAndWeekView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.originHeight = self.height - kDateBarHeight;
        _isFold = YES;
        
        self.dateNavBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kDateBarHeight)];
        _dateNavBarView.backgroundColor = UIColor.orangeColor;
        [self addSubview:_dateNavBarView];
        
        UICollectionViewScrollDirection direction = UICollectionViewScrollDirectionVertical;
        UICollectionViewFlowLayout *layout = [XMHMonthAndWeekCollectionView layoutFromScrollDirection:direction];
        self.collectionView = [[XMHMonthAndWeekCollectionView alloc] initWithFrame:CGRectMake(0, kDateBarHeight, self.width, self.height - kDateBarHeight) collectionViewLayout:layout];
        _collectionView.xmhScrollDirection = direction;
        [self addSubview:_collectionView];
        
        _cellMinHeight = [XMHMonthAndWeekCollectionView cellHeightType:_collectionView.type];
        _cellMinHeight += kDateBarHeight;
        [_collectionView reloadData];
        
        _cellMinimumLineSpacing = [XMHMonthAndWeekCollectionView cellMinimumLineSpacingType:_collectionView.type];
        _cellMinimumInteritemSpacing = [XMHMonthAndWeekCollectionView cellMinimumInteritemSpacingType:_collectionView.type];
        _lineItemCount = [XMHMonthAndWeekCollectionView lineItemCountType:_collectionView.type];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, kDateBarHeight, self.width, self.height - kDateBarHeight);
}

#pragma mark - Public

- (void)handleScopeGesture:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            [self scopeTransitionDidBegan:sender];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self scopeTransitionDidUpdate:sender];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            [self scopeTransitionDidEnd:sender];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Private

- (void)scopeTransitionDidBegan:(UIPanGestureRecognizer *)sender {
    // 记录开始滑动时，之前的偏移量
    self.beginContentOffset = _collectionView.contentOffset;
    
    // 收起状态
    if (!_isFold) {
        // 展开布局
        _collectionView.xmhScrollDirection = UICollectionViewScrollDirectionVertical;
    }
}

- (void)scopeTransitionDidUpdate:(UIPanGestureRecognizer *)sender {
    CGFloat translation = ABS([sender translationInView:sender.view].y);
//    NSLog(@"translation:%lf", translation);
    // 收起
    if (_isFold) {
        if (self.height > _cellMinHeight) {
            self.height = _originHeight  - translation;
            [self foldCollectionViewTranslation:translation];
        }
        // 最小区域限制
        if (self.height <= _cellMinHeight) {
            self.height = _cellMinHeight;
        }
    }
    // 展开
    else {
        if (self.height < _originHeight) {
            self.height = _cellMinHeight + translation;
            [self noFoldCollectionViewTranslation:translation];
        }
        // 最大区域限制
        if (self.height >= _originHeight) {
            self.height = _originHeight;
        }
    }
    
    if (self.frameDidChangeBlock) self.frameDidChangeBlock();
}

- (void)scopeTransitionDidEnd:(UIPanGestureRecognizer *)sender {
    // 展开状态
    if (_isFold) {
        // 收起
        self.height = _cellMinHeight;
        [self foldCollectionViewTranslation:_originHeight - _cellMinHeight];
        _isFold = NO;
        
        if (self.frameDidChangeBlock) self.frameDidChangeBlock();
        
        _collectionView.xmhScrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        [self foldStateSelectCellPositionAlign];
    }
    // 收起状态
    else {
        // 展开
        self.height = _originHeight;
        [self noFoldCollectionViewTranslation:_originHeight - _cellMinHeight];
        _isFold = YES;
    
        if (self.frameDidChangeBlock) self.frameDidChangeBlock();
        
        // 收拾begin时候，可能已经设置了 UICollectionViewScrollDirectionVertical
        if (_collectionView.xmhScrollDirection != _collectionView.xmhScrollDirection) {
            _collectionView.xmhScrollDirection = UICollectionViewScrollDirectionVertical;
        }
    }
}

/**
 收起，处理CollectionView 滑动效果
 */
- (void)foldCollectionViewTranslation:(CGFloat)translation {
//    CGFloat contentSizeHeith = _collectionView.contentSize.height;
    CGFloat upOffsetYGap = CGRectGetMinY(_collectionView.lastFrame);
//    CGFloat bottomOffsetYGap = CGRectGetMaxY(_collectionView.lastFrame);

    // 一屏够用
    // 滑动百分比 = 根据点击cell y / 手势滑动总高度
    CGFloat baiFenBi = upOffsetYGap / (_originHeight - _cellMinHeight);
    // _collectionView偏移量 = 手势偏移量 * 百分比
    CGFloat upOffsetY = baiFenBi * translation;
    
    // 如果开始滑动时存在偏移量
    if (_beginContentOffset.y > 0) {
        // 开始滑动时偏移量百分比 = 开始滑动时偏移量 / 手势滑动总高度
        CGFloat baiFenBi2 = _beginContentOffset.y / (_originHeight - _cellMinHeight);
        // _collectionView偏移量 - _collectionView开始滑动时偏移量。逐渐抵消掉开始滑动时存在偏移量
        upOffsetY = upOffsetY - (baiFenBi2 * translation);
    }
    
//    NSLog(@"translation:%f upOffsetY:%lf baiFenBi:%lf", translation, upOffsetY, baiFenBi);
    [_collectionView setContentOffset:CGPointMake(_collectionView.contentOffset.x, _beginContentOffset.y + upOffsetY) animated:NO];
}

/**
 展开，处理CollectionView 滑动效果
 */
- (void)noFoldCollectionViewTranslation:(CGFloat)translation {
//    CGFloat contentSizeHeith = _collectionView.contentSize.height;
    CGFloat upOffsetYGap = CGRectGetMinY(_collectionView.lastFrame);
//    CGFloat bottomOffsetYGap = CGRectGetMaxY(_collectionView.lastFrame);
    
    // 目标位置在第几屏高
    NSInteger jiPing = floor(upOffsetYGap / _originHeight);
    CGFloat jiPingHeight = jiPing * _originHeight;
    
    // 计算需要滑动的距离 = upOffsetYGap - 目标位置在第几屏高（屏高是 _originHeight），之前的屏高。例如在第5屏，之前的屏高就是 （4 * _originHeight）
    CGFloat computeScrollGap = upOffsetYGap - jiPingHeight;
    CGFloat baiFenBi = computeScrollGap / (_originHeight - _cellMinHeight);
    // 180 - translation(10) * 0.72
    CGFloat upOffsetY = upOffsetYGap - (baiFenBi * translation);
//    NSLog(@"translation:%f upOffsetY:%lf baiFenBi:%lf", translation, upOffsetY, baiFenBi);

    // 开始滑动可能为负数
    if (upOffsetY >= upOffsetYGap) {
        return;
    }
    [_collectionView setContentOffset:CGPointMake(_collectionView.contentOffset.x, upOffsetY) animated:NO];
}

/**
 展开状态选中的按钮，对齐到收起状态相应的按钮位置
 */
- (void)foldStateSelectCellPositionAlign {
    // 收起后、collectionView 为 UICollectionViewScrollDirectionHorizontal 后。将展开状态选中的按钮 X 位置,映射到收起状态相同的 X 位置.
    // 选中按钮之前有几行
    NSInteger lineCount = _collectionView.lastFrame.origin.y / ((_cellMinHeight - kDateBarHeight) + _cellMinimumLineSpacing);
    // 便宜X位置 = 每个按钮宽 * 每行有几个按钮 * 几行.  只需要计算选中按钮之前有几行的偏移量即可。
    CGFloat offsetX = ((_collectionView.lastFrame.size.width + _cellMinimumInteritemSpacing) * _lineItemCount) * lineCount;
    [_collectionView setContentOffset:CGPointMake(offsetX, _collectionView.contentOffset.y)];
}

@end
