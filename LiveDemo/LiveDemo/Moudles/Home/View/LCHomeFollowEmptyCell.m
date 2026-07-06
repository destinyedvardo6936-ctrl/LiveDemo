//
//  LCHomeFollowEmptyCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/23.
//

#import "LCHomeFollowEmptyCell.h"
#import "LCNoDataView.h"
@implementation LCHomeFollowEmptyCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LCNoDataView *emptyView = [[LCNoDataView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:emptyView];
        emptyView.title = KLanguage(@"主播在赶来的路上~");
//        emptyView.backgroundColor = self.contentView.backgroundColor;
        emptyView.customImageFrame = CGRectMake((SCREEN_WIDTH - kUI_Width(157))/2.0, kUI_Width(40), kUI_Width(157), kUI_Width(157));
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(0);
        }];
    }
    return self;
}
@end
