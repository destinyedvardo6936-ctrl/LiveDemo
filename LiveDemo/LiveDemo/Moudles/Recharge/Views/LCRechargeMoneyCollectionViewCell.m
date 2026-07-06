//
//  LCRechargeMoneyCollectionViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCRechargeMoneyCollectionViewCell.h"

@interface LCRechargeMoneyCollectionViewCell ()
@property (nonatomic , weak) UIImageView *backImgView;
@property (nonatomic , weak) UILabel *coinLabel;
@property (nonatomic , weak) UILabel *moneyLabel;
@property (nonatomic , weak) UIImageView *giveImgView;
@property (nonatomic , weak) UILabel *giveLabel;
@property (nonatomic , weak) UIImageView *coinImgView;
@end
@implementation LCRechargeMoneyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
            
        }];
        [self.giveImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(20));
            make.left.equalTo(-kUI_Width(5));
            make.top.equalTo(kUI_Width(7));
        }];
        [self.giveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(5));
            make.height.equalTo(kUI_Width(15));
            make.right.equalTo(kUI_Width(-10));
            make.centerY.equalTo(0);
        }];
        [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(14));
            make.centerX.equalTo(-kUI_Width(12)/2.0-kUI_Width(6)/2.0);
            make.centerY.equalTo(0);
        }];
        [self.coinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.coinLabel.mas_right).offset(kUI_Width(6));
            make.width.height.equalTo(kUI_Width(12));
            make.centerY.mas_equalTo(self.coinLabel.mas_centerY);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.height.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.coinLabel.mas_bottom).offset(kUI_Width(5));
        }];
        
    }
    return self;
}
- (void)setDataModel:(LCRechargeMoneyModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        self.backImgView.image = [x boolValue]?image(@"icon_rechargeTypeBgSelected"):image(@"icon_rechargeTypeBgNormal");
        
    }];
    [[RACObserve(_dataModel, give) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.giveImgView.hidden = self.giveLabel.hidden = x.intValue == 0;
        if(x.length){
            self.giveLabel.text = [NSString stringWithFormat:@"%@ %@",KLanguage(@"赠送"),x];
        }else{
            self.giveLabel.text = nil;
        }
    }];
    RAC(self.coinLabel,text) = [RACObserve(_dataModel, coin) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.moneyLabel,text) = [[RACObserve(_dataModel, money) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(value.length){
            return [NSString stringWithFormat:@"%@ %@",@"¥",value];
        }
        return nil;
    }] takeUntil:self.rac_prepareForReuseSignal];
    
    
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _backImgView = imgView;
        _backImgView.image = image(@"icon_rechargeMoneyBgNormal");
        _backImgView.layer.masksToBounds = YES;
        _backImgView.layer.cornerRadius = kUI_Width(4);
       
        [self.contentView addSubview:_backImgView];
        
    }
    return _backImgView;
}
- (UILabel *)coinLabel{
    if(_coinLabel == nil){
        UILabel *titleL = [[UILabel alloc]init];
        titleL.font = BoldFont(14);
        titleL.textColor = Color(@"#333333");
     
        [self.backImgView addSubview:titleL];
        _coinLabel=titleL;
    }
    return _coinLabel;
}
- (UILabel *)moneyLabel{
    if(_moneyLabel == nil){
        UILabel *titleL = [[UILabel alloc]init];
        titleL.font = BoldFont(12);
        titleL.textColor = Color(@"#666666");
     
        [self.backImgView addSubview:titleL];
        _moneyLabel=titleL;
    }
    return _moneyLabel;
}
- (UIImageView *)coinImgView{
    if(!_coinImgView){
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.image = image(@"icon_rechargeMoneyZsImg");
        [self.backImgView addSubview:imgV];
        _coinImgView = imgV;
    }
    return _coinImgView;
}
- (UIImageView *)giveImgView{
    if(!_giveImgView){
        UIImageView *giveImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
//        UIImageView *giveImgV = [[UIImageView alloc]initWithFrame:CGRectMake(btn.left-5, btn.top-7.5, widddth+10, 20)];
            giveImgV.image = image(@"icon_rechargeSend");
            [self.backImgView addSubview:giveImgV];
        _giveImgView = giveImgV;
    }
    return _giveImgView;
}
- (UILabel *)giveLabel{
    if(_giveLabel == nil){
        UILabel *giveLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        UILabel *giveLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, widddth, 15)];
//            giveLabel.text = [NSString stringWithFormat:@"赠送%@%@",give,[common name_coin]];
        giveLabel.font = RegularFont(10);
        giveLabel.textColor = Color(@"#FFFFFF");
        [self.giveImgView addSubview:giveLabel];
    _giveLabel = giveLabel;
    }
    return _giveLabel;
}
@end
