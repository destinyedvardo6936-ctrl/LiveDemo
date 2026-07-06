//
//  LCWithDrawHeaderTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawHeaderTableViewCell.h"

@interface LCWithDrawHeaderTableViewCell ()
@property (nonatomic , weak) UIImageView *backImgView;
@property (nonatomic , weak) UIImageView *coinTipImgView;
@property (nonatomic , weak) UILabel *coinTipLabel;

@property (nonatomic , weak) UILabel *coinCountLabel;
@property (nonatomic , weak) UILabel *coinChangeLabel;
@end
@implementation LCWithDrawHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(16));
            make.right.equalTo(-kUI_Width(16));
            make.top.bottom.equalTo(0);
            
        }];
        [self.coinTipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(16));
            make.left.equalTo(kUI_Width(20));
            make.top.equalTo(kUI_Width(11));
        }];
        [self.coinTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(12));
            make.left.mas_equalTo(self.coinTipImgView.mas_right).offset(kUI_Width(3));
            make.centerY.mas_equalTo(self.coinTipImgView.mas_centerY);
            make.right.equalTo(-kUI_Width(12));
            
        }];
       
        [self.coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(20));
            make.height.equalTo(kUI_Width(32));
            make.top.mas_equalTo(self.coinTipImgView.mas_bottom).offset(kUI_Width(25));
            make.right.equalTo(-kUI_Width(20));
        }];
        
        [self.coinChangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(20));
            make.bottom.equalTo(-kUI_Width(10));
            make.height.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(20));
        }];
    }
    return self;
}
- (void)setDataModel:(LCWithDrawProfitModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self);
  
    RAC(self.coinCountLabel,text) = [[RACObserve(_dataModel, votes) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(value.length){
            return  [NSString stringWithFormat:@"%@：%@",KLanguage(@"数量"),value];
        }
        return [NSString stringWithFormat:@"%@：%@",KLanguage(@"数量"),@"0"];
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.coinChangeLabel,text) = [[RACObserve(_dataModel, votestotal) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(value.length){
            return [NSString stringWithFormat: @"%@：%@",KLanguage(@"累计提现"),value];
        }
        return [NSString stringWithFormat: @"%@：%@",KLanguage(@"累计提现"),@"0"];
    }] takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *backImgView = [[UIImageView alloc]initWithImage:image(@"icon_withDrawHeaderBg")];
        [self.contentView addSubview:backImgView];
        _backImgView = backImgView;
        _backImgView.userInteractionEnabled = YES;
    }
    return _backImgView;
}
- (UIImageView *)coinTipImgView{
    if(!_coinTipImgView){
        UIImageView *backImgView = [[UIImageView alloc]initWithImage:image(@"icon_myWalletMoneyImg")];
        [self.backImgView addSubview:backImgView];
        _coinTipImgView = backImgView;
       
    }
    return _coinTipImgView;
}
- (UILabel *)coinTipLabel{
    if(!_coinTipLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"可提现数量（个）") ;
        [self.backImgView addSubview:label];
        _coinTipLabel = label;
    }
    return _coinTipLabel;
}

- (UILabel *)coinCountLabel{
    if(!_coinCountLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(32);
        label.textColor = Color(@"#FFFFFF");
//        label.text = @"9999";
        [self.backImgView addSubview:label];
        _coinCountLabel = label;
    }
    return _coinCountLabel;
}
- (UILabel *)coinChangeLabel{
    if(!_coinChangeLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFD4AB");
//        label.text = @"累计兑换：5654.00元";
        [self.backImgView addSubview:label];
        _coinChangeLabel = label;
    }
    return _coinChangeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
