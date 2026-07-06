//
//  LCRechargeTypeCollectionViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/4.
//

#import "LCRechargeTypeCollectionViewCell.h"

@interface LCRechargeTypeCollectionViewCell ()
@property (nonatomic , weak) UIImageView *backImgView;

@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCRechargeTypeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
            
        }];
        
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(14));
            make.centerY.equalTo(0);
            make.left.right.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataModel:(LCRechargeTypeModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        self.backImgView.image = [x boolValue]?image(@"icon_rechargeTypeBgSelected"):image(@"icon_rechargeTypeBgNormal");
        self.mainLabel.font = [x boolValue]?BoldFont(14):RegularFont(14);
        self.mainLabel.textColor = [x boolValue]?Color(@"#333333"):Color(@"#666666");
    }];
    RAC(self.mainLabel,text) = [RACObserve(_dataModel, name) takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _backImgView = imgView;
        _backImgView.image = image(@"icon_rechargeTypeBgNormal");
        _backImgView.layer.masksToBounds = YES;
        _backImgView.layer.cornerRadius = kUI_Width(4);
       
        [self.contentView addSubview:_backImgView];
        
    }
    return _backImgView;
}

- (UILabel *)mainLabel{
    if(_mainLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.textColor = Color(@"#666666");
        label.textAlignment = NSTextAlignmentCenter;
        _mainLabel = label;
        [self.backImgView addSubview:_mainLabel];

    }
    return _mainLabel;
}
@end
