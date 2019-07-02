//
//  XMHCollectionWeekCell.m
//  MonthAndWeekDemo
//
//  Created by kfw on 2019/7/1.
//  Copyright © 2019 kfw. All rights reserved.
//

#import "XMHCollectionWeekCell.h"

@implementation XMHCollectionWeekCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_label];
    }
    return self;
}
@end
