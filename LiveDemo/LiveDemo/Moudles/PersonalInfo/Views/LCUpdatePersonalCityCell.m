//
//  LCUpdatePersonalCityCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCUpdatePersonalCityCell.h"

@interface LCUpdatePersonalCityCell ()<UITextFieldDelegate>
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UITextField *nicknameTextField;

@end
@implementation LCUpdatePersonalCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(40));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.width.lessThanOrEqualTo(kUI_Width(100));
            make.centerY.equalTo(0);
           
        }];
        [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.left.mas_equalTo(self.tipLabel.mas_right);
            make.centerY.equalTo(0);
           
        }];
        WS(weakSelf)
        [self.nicknameTextField.rac_textSignal  subscribeNext:^(NSString * _Nullable x) {
            if(weakSelf.textChangeBlock){
                weakSelf.textChangeBlock(x);
            }
        }];
    }
    return self;
}
- (void)setCity:(NSString *)city{
    _city = [city copy];
    self.nicknameTextField.text = _city;
}


#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UITextField *)nicknameTextField{
    if(!_nicknameTextField){
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入城市") attributes:@{NSFontAttributeName:RegularFont(14),NSForegroundColorAttributeName:Color(@"#999999")}];
        textField.textColor = Color(@"#333333");
        textField.font = RegularFont(14);
        textField.delegate = self;
        [self.backView addSubview:textField];
        _nicknameTextField = textField;
    }
    return _nicknameTextField;
}
- (UILabel *)tipLabel{
    if(_tipLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = MediumFont(14);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"城市：");
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _tipLabel = label;
    }
    return _tipLabel;
}

@end
