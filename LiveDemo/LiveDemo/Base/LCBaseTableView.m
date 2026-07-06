//
//  ZNBaseTableView.m
//  zhunong
//
//  Created by mrgao on 2022/10/20.
//  Copyright © 2022 WY. All rights reserved.
//

#import "LCBaseTableView.h"

@implementation LCBaseTableView

- (void)awakeFromNib {
    [super awakeFromNib];

    if (@available
    (iOS
    11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delaysContentTouches = NO;
        if (@available
        (iOS
        11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;


            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
        if (@available(iOS 15.0, *)) {
            self.sectionHeaderTopPadding = 0;
        }
    }
    return self;
}

+ (LCBaseTableView *)addTableGrouped {

    LCBaseTableView *table = [[LCBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.estimatedRowHeight = 0;
    table.estimatedSectionHeaderHeight = 0;
    table.estimatedSectionFooterHeight = 0;
    table.rowHeight = UITableViewAutomaticDimension;
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0000000000000001)];
    return table;
}

+ (LCBaseTableView *)addTablePlain {

    LCBaseTableView *table = [[LCBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.estimatedRowHeight = 0;
    table.estimatedSectionHeaderHeight = 0;
    table.estimatedSectionFooterHeight = 0;
    table.rowHeight = UITableViewAutomaticDimension;
    
    return table;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//
//
//    /*
//     直接拖动UISlider，此时touch时间在150ms以内，UIScrollView会认为是拖动自己，从而拦截了event，导致UISlider接受不到滑动的event。但是只要按住UISlider一会再拖动，此时此时touch时间超过150ms，因此滑动的event会发送到UISlider上。
//     */
//    UIView *view = [super hitTest:point withEvent:event];
//
//    if([view isKindOfClass:[UISlider class]])
//    {
//        //如果响应view是UISlider,则scrollview禁止滑动
//        self.scrollEnabled = NO;
//    }
//    else
//    {   //如果不是,则恢复滑动
//        self.scrollEnabled = YES;
//    }
//    return view;
//}

@end
