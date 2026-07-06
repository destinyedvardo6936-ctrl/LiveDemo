//
//  LCQuatoBalanceTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/10.
//

#import "LCQuatoBalanceTableViewCell.h"

@interface LCQuatoBalanceTableViewCell ()
@property (nonatomic,weak)UIImageView *backImgView;
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak)UILabel *balanceLabel;

@property (nonatomic,weak)UIButton *transOutBtn;
@end
@implementation LCQuatoBalanceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.bottom.equalTo(0);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.mas_equalTo(self.transOutBtn.mas_left).offset(-kUI_Width(12));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(kUI_Width(12));
        }];
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kUI_Width(15));
            make.height.equalTo(kUI_Width(16));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.transOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(80));
            make.top.equalTo(kUI_Width(12));
        }];
       
    }
    return self;
}
- (void)setBalance:(NSString *)balance{
    _balance = balance;
    self.balanceLabel.text = _balance;
}

- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"backimg1")];
        imgView.userInteractionEnabled = YES;
//        imgView.backgroundColor = Color(@"#FFFFFF");
        [self.contentView addSubview:imgView];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kUI_Width(8);
        _backImgView = imgView;
    }
    return _backImgView;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(16);
        label.textColor = Color(@"#FFFFFF");
        label.text = KLanguage(@"账户余额");
//        label.textAlignment = NSTextAlignmentCenter;
        [self.backImgView addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}
- (UILabel *)balanceLabel{
    if(!_balanceLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(16);
        label.textColor = Color(@"#FFFFFF");
      
//        label.textAlignment = NSTextAlignmentCenter;
        [self.backImgView addSubview:label];
        _balanceLabel = label;
    }
    return _balanceLabel;
}

- (UIButton *)transOutBtn{
    if(_transOutBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:Color(@"#FF2828") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(14);
        btn.backgroundColor = Color(@"#FFFFFF");
        btn.layer.cornerRadius = kUI_Width(28)/2.0;
        btn.clipsToBounds = YES;
        [btn setTitle:KLanguage(@"刷新数据") forState:UIControlStateNormal];
        [self.backImgView addSubview:btn];
        _transOutBtn = btn;
        WS(weakSelf)
        [[_transOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.refreshBlock){
                weakSelf.refreshBlock();
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
