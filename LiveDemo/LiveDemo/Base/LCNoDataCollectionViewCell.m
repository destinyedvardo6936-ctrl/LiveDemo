//
//  LCNoDataCollectionViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCNoDataCollectionViewCell.h"
#import "LCNoDataView.h"
@interface LCNoDataCollectionViewCell ()
@property (nonatomic , weak) LCNoDataView *mainView;
@end
@implementation LCNoDataCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LCNoDataView *emptyView = [[LCNoDataView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:emptyView];
        _mainView = emptyView;
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = [titleStr copy];
    self.mainView.title = _titleStr;
}
- (void)setImgStr:(NSString *)imgStr{
    _imgStr = [imgStr copy];
    self.mainView.customImg = image(_imgStr);
}
- (void)setCustomImageFrame:(CGRect)customImageFrame{
    _customImageFrame = customImageFrame;
    self.mainView.customImageFrame = _customImageFrame;
}
- (void)setCustomTitleFrame:(CGRect)customTitleFrame{
    _customTitleFrame = customTitleFrame;
    self.mainView.customTitleFrame = _customTitleFrame;
}
- (void)setCustomBgColor:(UIColor *)customBgColor{
    _customBgColor = customBgColor;
    self.mainView.customBgColor = _customBgColor;
}


@end
