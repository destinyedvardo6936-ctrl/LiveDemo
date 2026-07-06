//
//  LCGameCollectionListCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCGameCollectionListCell.h"

@interface LCGameCollectionListCell ()
@property (nonatomic , weak) UIImageView *backImgView;
@property (nonatomic , weak) UIImageView *mainImgView;
//@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCGameCollectionListCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
//        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mainImgView.mas_bottom).offset(kUI_Width(10));
//            make.left.right.equalTo(0);
//            make.height.equalTo(kUI_Width(14));
//        }];
    }
    return self;
}


- (void)setDataModel:(LCGameListModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
//    [[RACObserve(_dataModel, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
//        @strongify(self)
//        self.backImgView.image = [x boolValue]?image(@"icon_gameOpitionSelectBgImg"):image(@"icon_gameOpitionBgImg");
//
//
//    }];
    [[RACObserve(_dataModel, icon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self.mainImgView setImageStr:x];
        
        
    }];
//    RAC(self.mainLabel,text) = [RACObserve(_dataModel, name) takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:imgView];
        imgView.image = image(@"icon_gameCenterListBg");
        _backImgView = imgView;
    }
    return _backImgView;
}
- (UIImageView *)mainImgView{
    if(!_mainImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.backImgView addSubview:imgView];
        _mainImgView = imgView;
    }
    return _mainImgView;
}
//- (UILabel *)mainLabel{
//    if(!_mainLabel){
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//        label.font = BoldFont(14);
//        label.textColor = Color(@"#6F5AA2");
//        label.textAlignment = NSTextAlignmentCenter;
//        [self.backImgView addSubview:label];
//        _mainLabel = label;
//    }
//    return _mainLabel;
//}


@end
