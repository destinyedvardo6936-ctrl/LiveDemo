//
//  LCUserContributeCollectionViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCUserContributeCollectionViewCell.h"

@interface LCUserContributeCollectionViewCell ()
@property (nonatomic , weak) UIImageView *mainImgView;
@end
@implementation LCUserContributeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataModel:(LCUserContributeModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, avatar) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.mainImgView setImageStr:x];
        [self setNeedsLayout];
    }];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.mainImgView.layer.cornerRadius = self.width/2.0;
}
#pragma mark---- 懒加载 ----
- (UIImageView *)mainImgView{
    if(!_mainImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:imgView];
        _mainImgView = imgView;
    }
    return _mainImgView;
}
@end
