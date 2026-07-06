//
//  LCLiveGameListCollectionCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCLiveGameListCollectionCell.h"

@interface LCLiveGameListCollectionCell ()
@property (nonatomic , weak) UIImageView *mainImgView;

@end
@implementation LCLiveGameListCollectionCell
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
- (void)setDataModel:(LCGameListModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, icon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.mainImgView setImageStr:x];
    }];
}
#pragma mark---- 懒加载 ----
- (UIImageView *)mainImgView{
    if(!_mainImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:imgView];
        _mainImgView = imgView;
    }
    return _mainImgView;
}
@end
