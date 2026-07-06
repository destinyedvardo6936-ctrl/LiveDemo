//
//  LCMineFunTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/6.
//

#import "LCMineFunTableViewCell.h"

@interface LCMineFunTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@end
@implementation LCMineFunTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(75));
            make.top.bottom.equalTo(0);
        }];
        UIButton *walletBtn = [self createBtnWithTitle:KLanguage(@"钱包") image:@"icon_mineWallet"];
        
        [self.backView addSubview:walletBtn];
        UIButton *withdrawalBtn = [self createBtnWithTitle:KLanguage(@"提现") image:@"icon_mineWithdrawal"];
        [self.backView addSubview:withdrawalBtn];
//        UIButton *nobleBtn = [self createBtnWithTitle:KLanguage(@"贵族") image:@"icon_mineNobleImg"];
//        [self.backView addSubview:nobleBtn];
        UIButton *activityBtn = [self createBtnWithTitle:KLanguage(@"活动") image:@"icon_mineActivityImg"];
        [self.backView addSubview:activityBtn];
        UIButton *spreadBtn = [self createBtnWithTitle:KLanguage(@"推广") image:@"icon_mineSpreadImg"];
        [self.backView addSubview:spreadBtn];
        WS(weakSelf)
        [[walletBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.btnClickSubject sendNext:@(0)];
        }];
        [[withdrawalBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.btnClickSubject sendNext:@(1)];
        }];
//        [[nobleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            [weakSelf.btnClickSubject sendNext:@(2)];
//        }];
        [[activityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.btnClickSubject sendNext:@(3)];
        }];
        [[spreadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.btnClickSubject sendNext:@(4)];
        }];
        
        [walletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(16));
            make.centerY.equalTo(0);
            make.width.mas_equalTo(spreadBtn.mas_width);
        }];
        [withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(walletBtn.mas_right).offset(kUI_Width(30));
            make.centerY.equalTo(0);
            make.width.mas_equalTo(walletBtn.mas_width);
        }];
//        [nobleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(withdrawalBtn.mas_right).offset(kUI_Width(30));
//            make.centerY.equalTo(0);
//            make.width.mas_equalTo(withdrawalBtn.mas_width);
//        }];
        [activityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(withdrawalBtn.mas_right).offset(kUI_Width(30));
            make.centerY.equalTo(0);
            make.width.mas_equalTo(withdrawalBtn.mas_width);
        }];
        [spreadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(activityBtn.mas_right).offset(kUI_Width(30));
            make.centerY.equalTo(0);
            make.width.mas_equalTo(activityBtn.mas_width);
            make.right.equalTo(-kUI_Width(16));
        }];
    }
    return self;
}
- (UIButton *)createBtnWithTitle:(NSString *)title image:(NSString *)imgaeName{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image(imgaeName)];
    [btn addSubview:imgView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = RegularFont(14);
    label.textColor = Color(@"#333333");
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:label];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.width.height.equalTo(kUI_Width(40));
        make.centerX.equalTo(0);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(kUI_Width(14));
        make.top.mas_equalTo(imgView.mas_bottom).offset(kUI_Width(6));
        make.bottom.equalTo(0);
    }];
    return btn;
}
- (UIView *)backView{
    if(_backView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(4);
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (RACSubject *)btnClickSubject{
    if(_btnClickSubject == nil){
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
