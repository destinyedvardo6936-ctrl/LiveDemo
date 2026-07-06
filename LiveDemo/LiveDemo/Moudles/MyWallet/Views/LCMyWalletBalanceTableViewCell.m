//
//  LCMyWalletBalanceTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import "LCMyWalletBalanceTableViewCell.h"

@interface LCMyWalletBalanceTableViewCell ()
@property (nonatomic , weak) UIImageView *backImgView;
@property (nonatomic , weak) UIButton *rechargeRecordBtn;
@property (nonatomic , weak) UILabel *balanceLabel;
@property (nonatomic , weak) UILabel *balanceTipLabel;
@property (nonatomic , weak) UIButton *rechargeBtn;
@property (nonatomic , weak) UIButton *withdrawBtn;
@end
@implementation LCMyWalletBalanceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(200));
            make.bottom.equalTo(0);
            make.top.equalTo(0);
        }];
        [self.rechargeRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(14));
            make.top.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(kUI_Width(40));
            make.height.equalTo(kUI_Width(24));
            
        }];
        [self.balanceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.mas_equalTo(self.balanceLabel.mas_bottom).offset(kUI_Width(20));
            make.height.equalTo(kUI_Width(16));
        }];
        [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(133));
            make.height.equalTo(kUI_Width(40));
            make.left.equalTo(kUI_Width(20));
            make.bottom.equalTo(-kUI_Width(28));
        }];
        [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(133));
            make.height.equalTo(kUI_Width(40));
            make.right.equalTo(-kUI_Width(20));
            make.bottom.equalTo(-kUI_Width(28));
        }];
    }
    return self;
}
- (void)setBalanceStr:(NSString *)balanceStr{
    _balanceStr = [balanceStr copy];
    self.balanceLabel.text = _balanceStr;
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_myWalletBalanceBg")];
        imgView.userInteractionEnabled = YES;
        [self.contentView addSubview:imgView];
        _backImgView = imgView;
    }
    return _backImgView;
}
- (UIButton *)rechargeRecordBtn{
    if(!_rechargeRecordBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backImgView addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.recordSubject sendNext:x];
        }];
        _rechargeRecordBtn = btn;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(14);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"充值记录");
        [_rechargeRecordBtn addSubview:label];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_myWalletRechargeAccess")];
        [_rechargeRecordBtn addSubview:imgView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(0);
            make.right.mas_equalTo(imgView.mas_left).offset(-kUI_Width(4));
        }];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(0);
            make.width.equalTo(imgView.mas_height);
        }];
    }
    return _rechargeRecordBtn;
}
- (UILabel *)balanceLabel{
    if(!_balanceLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(24);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backImgView addSubview:label];
        _balanceLabel = label;
    }
    return _balanceLabel;
}
- (UILabel *)balanceTipLabel{
    if(!_balanceTipLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(16);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"余额(钻石)");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backImgView addSubview:label];
        _balanceTipLabel = label;
    }
    return _balanceTipLabel;
}
- (UIButton *)rechargeBtn{
    if(!_rechargeBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:KLanguage(@"充值") forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(16);
        btn.layer.cornerRadius = kUI_Width(40)/2.0;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = Color(@"#FFFFFF").CGColor;
        [self.backImgView addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.rechargeSubject sendNext:x];
        }];
        _rechargeBtn = btn;
    }
    return _rechargeBtn;
}
- (UIButton *)withdrawBtn{
    if(!_withdrawBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:KLanguage(@"提现") forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(16);
        btn.layer.cornerRadius = kUI_Width(40)/2.0;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = Color(@"#FFFFFF").CGColor;
        [self.backImgView addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.withdrawSubject sendNext:x];
        }];
        _withdrawBtn = btn;
    }
    return _withdrawBtn;
}
- (RACSubject *)recordSubject{
    if(!_recordSubject){
        _recordSubject = [RACSubject subject];
    }
    return _recordSubject;
}
- (RACSubject *)rechargeSubject{
    if(!_rechargeSubject){
        _rechargeSubject = [RACSubject subject];
    }
    return _rechargeSubject;
}
- (RACSubject *)withdrawSubject{
    if(!_withdrawSubject){
        _withdrawSubject = [RACSubject subject];
    }
    return _withdrawSubject;
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
