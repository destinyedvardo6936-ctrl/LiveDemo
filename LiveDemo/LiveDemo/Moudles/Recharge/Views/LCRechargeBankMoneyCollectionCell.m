//
//  LCRechargeBankMoneyCollectionCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/23.
//

#import "LCRechargeBankMoneyCollectionCell.h"

@interface LCRechargeBankMoneyCollectionCell ()<UITextFieldDelegate>
@property (nonatomic , weak) UIView *backView;
@property (nonatomic,weak)UITextField *inputTextField;
@end
@implementation LCRechargeBankMoneyCollectionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(kUI_Width(10));
            make.bottom.equalTo(-kUI_Width(10));
            
        }];
       
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.left.mas_equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
           
        }];
        WS(weakSelf)
        [self.inputTextField.rac_textSignal  subscribeNext:^(NSString * _Nullable x) {
            if(weakSelf.inputBlock){
                weakSelf.inputBlock(x);
            }
        }];
    }
    return self;
}

- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(4);
        view.layer.shadowColor = Color(@"#FFD5E7").CGColor;
        view.layer.shadowOffset = CGSizeMake(0,1);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 1;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UITextField *)inputTextField{
    if(!_inputTextField){
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入充值金额") attributes:@{NSFontAttributeName:RegularFont(14),NSForegroundColorAttributeName:Color(@"#999999")}];
        textField.textColor = Color(@"#333333");
        textField.font = RegularFont(14);
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.backView addSubview:textField];
        _inputTextField = textField;
    }
    return _inputTextField;
}
@end
