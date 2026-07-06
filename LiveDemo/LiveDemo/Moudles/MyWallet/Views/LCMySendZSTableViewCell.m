//
//  LCMySendZSTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/17.
//

#import "LCMySendZSTableViewCell.h"

@interface LCMySendZSTableViewCell ()
@property (nonatomic , weak) UIImageView *backImgView;

@property (nonatomic , weak) UILabel *balanceLabel;

@property (nonatomic , weak) UIButton *rechargeBtn;
@end
@implementation LCMySendZSTableViewCell

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
       
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(kUI_Width(40));
            make.height.equalTo(kUI_Width(24));
            
        }];
        
        [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(133));
            make.height.equalTo(kUI_Width(40));
            make.centerX.equalTo(0);
            make.bottom.equalTo(-kUI_Width(28));
        }];
       
    }
    return self;
}
- (void)setSendZSStr:(NSString *)sendZSStr{
    _sendZSStr = [sendZSStr copy];
    self.balanceLabel.text = _sendZSStr;
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_myWalletSendZSBg")];
        imgView.userInteractionEnabled = YES;
        [self.contentView addSubview:imgView];
        _backImgView = imgView;
    }
    return _backImgView;
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

- (UIButton *)rechargeBtn{
    if(!_rechargeBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:KLanguage(@"我送出的钻石") forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(16);
        btn.layer.cornerRadius = kUI_Width(40)/2.0;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = Color(@"#FFFFFF").CGColor;
        [self.backImgView addSubview:btn];
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.btnClickSubject sendNext:x];
        }];
        _rechargeBtn = btn;
    }
    return _rechargeBtn;
}
- (RACSubject *)btnClickSubject{
    if(!_btnClickSubject){
        _btnClickSubject = [RACSubject subject];
    }
    return _btnClickSubject;
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
