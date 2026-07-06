//
//  LCQuotaTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCQuotaTableViewCell.h"

@interface LCQuotaTableViewCell ()
@property (nonatomic,weak)UIImageView *backImgView;
@property (nonatomic,weak)UIImageView *logoImgView;
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak)UIButton *balanceBtn;
@property (nonatomic,weak)UIButton *transInBtn;
@property (nonatomic,weak)UIButton *transOutBtn;

@end
@implementation LCQuotaTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.bottom.equalTo(0);
        }];
        [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.width.height.equalTo(kUI_Width(25));
            make.top.equalTo(kUI_Width(12));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.logoImgView.mas_right).offset(kUI_Width(8));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(16));
            make.centerY.mas_equalTo(self.logoImgView.mas_centerY);
        }];
        [self.balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.logoImgView.mas_bottom).offset(kUI_Width(15));
            make.height.equalTo(kUI_Width(16));
            make.width.lessThanOrEqualTo(kUI_Width(80));
        }];
        [self.transOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(50));
            make.bottom.equalTo(-kUI_Width(20));
        }];
        [self.transInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.transOutBtn.mas_left).offset(-kUI_Width(20));
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(50));
            make.bottom.equalTo(-kUI_Width(20));
        }];
    }
    return self;
}
- (void)setDataModel:(LCQuotaModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, icon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.logoImgView setImageStr:x];
        

    }];
    
    RAC(self.nameLabel,text) = [RACObserve(_dataModel, name) takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, balance) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if(x.length){
            self.balanceBtn.selected = NO;
            [self.balanceBtn setTitle:KLanguage(@"****点击查询") forState:UIControlStateNormal];
        }else{
            self.balanceBtn.selected = YES;
            [self.balanceBtn setTitle:x forState:UIControlStateSelected];
        }
        

    }];
}
- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.userInteractionEnabled = YES;
        imgView.backgroundColor = Color(@"#FFFFFF");
        [self.contentView addSubview:imgView];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kUI_Width(8);
        _backImgView = imgView;
    }
    return _backImgView;
}
- (UIImageView *)logoImgView{
    if(!_logoImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        imgView.userInteractionEnabled = YES;
        [self.backImgView addSubview:imgView];
        _logoImgView = imgView;
    }
    return _logoImgView;
}
- (UILabel *)nameLabel{
    if(!_nameLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(16);
        label.textColor = Color(@"#333333");
//        label.textAlignment = NSTextAlignmentCenter;
        [self.backImgView addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}
- (UIButton *)balanceBtn{
    if(_balanceBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:Color(@"#FF2828") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(16);
        [btn setTitleColor:Color(@"#FF2828") forState:UIControlStateSelected];
        [btn setTitle:KLanguage(@"****点击查询") forState:UIControlStateNormal];
        [self.backImgView addSubview:btn];
        _balanceBtn = btn;
        WS(weakSelf)
        [[_balanceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            x.selected = YES;
            if(weakSelf.selectBalanceBlock){
                weakSelf.selectBalanceBlock(weakSelf.dataModel);
            }
        }];
    }
    return _balanceBtn;
}
- (UIButton *)transInBtn{
    if(_transInBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:Color(@"#FF2828") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(14);
        btn.backgroundColor = Color(@"#E6E8EB");
        btn.layer.cornerRadius = kUI_Width(28)/2.0;
        btn.clipsToBounds = YES;
        [btn setTitle:KLanguage(@"转入") forState:UIControlStateNormal];
        [self.backImgView addSubview:btn];
        _transInBtn = btn;
        WS(weakSelf)
        [[_transInBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.transInBlock){
                weakSelf.transInBlock(weakSelf.dataModel);
            }
        }];
    }
    return _transInBtn;
}
- (UIButton *)transOutBtn{
    if(_transOutBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:Color(@"#FF2828") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(14);
        btn.backgroundColor = Color(@"#E6E8EB");
        btn.layer.cornerRadius = kUI_Width(28)/2.0;
        btn.clipsToBounds = YES;
        [btn setTitle:KLanguage(@"转出") forState:UIControlStateNormal];
        [self.backImgView addSubview:btn];
        _transOutBtn = btn;
        WS(weakSelf)
        [[_transOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.transOutBlock){
                weakSelf.transOutBlock(weakSelf.dataModel);
            }
        }];
    }
    return _transOutBtn;
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
