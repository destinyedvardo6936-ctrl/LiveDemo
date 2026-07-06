//
//  LCVirtualCurrencyTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCVirtualCurrencyTableViewCell.h"

@interface LCVirtualCurrencyTableViewCell ()<UITextFieldDelegate>
@property (nonatomic , weak) UILabel *accountlabel;
//@property (nonatomic , weak) UITextField *countTextField;
@end
@implementation LCVirtualCurrencyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *tipView = [[UIView alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(kUI_Width(10));
            make.height.equalTo(kUI_Width(16));
            make.right.equalTo(0);
            
        }];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_rechargeTipAcessImg")];
        [tipView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.width.equalTo(kUI_Width(4));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(0);
        }];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        tipLabel.text =  KLanguage(@"TEC20地址");
        tipLabel.textColor = Color(@"#333333");
        tipLabel.font = BoldFont(16);
        [tipView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(kUI_Width(4));
            make.height.equalTo(kUI_Width(16));
            make.top.equalTo(0);
            make.right.equalTo(-kUI_Width(16));
        }];
        UIView *accountBgImgView = [[UIView alloc]initWithFrame:CGRectZero];
        accountBgImgView.backgroundColor = Color(@"#FFFFFF");
        [self.contentView addSubview:accountBgImgView];
        accountBgImgView.layer.cornerRadius = 4;
        accountBgImgView.layer.shadowColor = Color(@"#FFD5E7").CGColor;
        accountBgImgView.layer.shadowOffset = CGSizeMake(0,1);
        accountBgImgView.layer.shadowOpacity = 1;
        accountBgImgView.layer.shadowRadius = 1;
        [accountBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(36));
            make.top.mas_equalTo(tipView.mas_bottom).offset(kUI_Width(10));
        }];
        UILabel *accountLabel = [[UILabel alloc]init];
        accountLabel.font = RegularFont(14);
        accountLabel.textColor = Color(@"#666666");
        
//        accountLabel.numberOfLines = 0;
        [accountBgImgView addSubview:accountLabel];
        _accountlabel = accountLabel;
        
        UIButton *accCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        accCopyBtn.tag = 200;
        accCopyBtn.backgroundColor = Color(@"#F2F2F2");
        accCopyBtn.layer.cornerRadius = kUI_Width(4);
        [accCopyBtn setTitle:KLanguage(@"复制")  forState:UIControlStateNormal];
        [accCopyBtn setTitleColor:Color(@"#666666") forState:UIControlStateNormal];
        accCopyBtn.titleLabel.font = RegularFont(14);
        
        [accountBgImgView addSubview:accCopyBtn];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.mas_equalTo(accCopyBtn.mas_left).offset(-kUI_Width(10));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(14));
        }];
        [accCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.width.equalTo(kUI_Width(39));
            make.centerY.equalTo(0);
        }];
        [accCopyBtn addTarget:self action:@selector(copyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        UIView *accountTipView = [[UIView alloc]initWithFrame:CGRectZero];
//
//        [self.contentView addSubview:accountTipView];
//        [accountTipView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(0);
//            make.top.mas_equalTo(accountBgImgView.mas_bottom).offset(kUI_Width(10));
//            make.height.equalTo(kUI_Width(16));
//            make.right.equalTo(0);
//
//        }];
//        UIImageView *accountImgView = [[UIImageView alloc]initWithImage:image(@"icon_rechargeTipAcessImg")];
//        [accountTipView addSubview:accountImgView];
//        [accountImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(12));
//            make.width.equalTo(kUI_Width(4));
//            make.height.equalTo(kUI_Width(16));
//            make.top.equalTo(0);
//        }];
//        UILabel *accountTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        accountTipLabel.text =  KLanguage(@"转账数量");
//
//        accountTipLabel.textColor = Color(@"#333333");
//        accountTipLabel.font = BoldFont(16);
//        [accountTipView addSubview:accountTipLabel];
//        [accountTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(accountImgView.mas_right).offset(kUI_Width(4));
//            make.height.equalTo(kUI_Width(16));
//            make.top.equalTo(0);
//            make.right.equalTo(-kUI_Width(16));
//        }];
//
//        UIView *textBackView = [[UIView alloc]initWithFrame:CGRectZero];
//        textBackView.backgroundColor = Color(@"#FFFFFF");
//        textBackView.layer.cornerRadius = kUI_Width(4);
//        textBackView.layer.shadowColor = Color(@"#FFD5E7").CGColor;
//        textBackView.layer.shadowOffset = CGSizeMake(0,1);
//        textBackView.layer.shadowOpacity = 1;
//        textBackView.layer.shadowRadius = 1;
//        [self.contentView addSubview:textBackView];
//        [textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(12));
//            make.right.equalTo(-kUI_Width(12));
//            make.height.equalTo(kUI_Width(36));
//            make.top.mas_equalTo(accountTipView.mas_bottom).offset(kUI_Width(10));
//
//        }];
//        UITextField *countTextField = [[UITextField alloc]initWithFrame:CGRectZero];
//
//        [textBackView addSubview:countTextField];
//        _countTextField = countTextField;
//        _countTextField.font = RegularFont(14);
//        _countTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入转账数量") attributes:@{NSFontAttributeName:RegularFont(14),NSForegroundColorAttributeName:Color(@"#666666")}];
//        _countTextField.delegate = self;
//        _countTextField.keyboardType = UIKeyboardTypeNumberPad;
//        [_countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(kUI_Width(12));
//            make.right.equalTo(-kUI_Width(12));
//            make.top.bottom.equalTo(0);
//        }];
        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setBackgroundImage:image(@"icon_logoutBtnBg") forState:UIControlStateNormal];
        [submitBtn setTitle:KLanguage(@"我已转账") forState:UIControlStateNormal];
        
        [submitBtn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        submitBtn.titleLabel.font = BoldFont(18);
        [self.contentView addSubview:submitBtn];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(205));
            make.height.equalTo(kUI_Width(40));
            make.centerX.equalTo(0);
            make.top.mas_equalTo(accountBgImgView.mas_bottom).offset(kUI_Width(10));
            make.bottom.equalTo(-kUI_Width(10));
        }];
        [submitBtn addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setDataModel:(LCRechargeConnetPersonModel *)dataModel{
    _dataModel = dataModel;
    _accountlabel.text = _dataModel.bankno;
}

- (void)copyBtnClicked:(UIButton *)btn{
   
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:[[self accountlabel]text]];
        [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"已复制成功") ];
    
}
////设置文本框只能输入数字
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//
//{
//
//   //如果是限制只能输入数字的文本框
//
//   if (self.countTextField==textField) {
//
//
//
//       return [self validateNumber:string];
//
//
//
//   }
//
//   //否则返回yes,不限制其他textfield
//
//   return YES;
//
//}
//
//
//- (BOOL)validateNumber:(NSString*)number
//
//{
//
//   BOOL res =YES;
//
//   NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//
//   int i =0;
//
//   while (i < number.length) {
//
//       NSString * string = [number substringWithRange:NSMakeRange(i,1)];
//
//       NSRange range = [string rangeOfCharacterFromSet:tmpSet];
//
//       if (range.length ==0) {
//
//           res =NO;
//
//           break;
//
//       }
//
//       i++;
//
//   }
//
//   return res;
//
//}
//

- (void)submitButtonClicked{
//    [self.countTextField resignFirstResponder];
//    if(!self.countTextField.text.length){
//        [SVProgressHUD showMaskViewWithInfo:KLanguage(@"请输入转账数量")];
//        return;
//    }
    if (self.submitBlock) {
        self.submitBlock();
    }
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
