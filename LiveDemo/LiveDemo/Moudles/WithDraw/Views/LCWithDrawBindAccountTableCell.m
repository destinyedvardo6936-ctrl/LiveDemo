//
//  LCWithDrawBindAccountTableCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawBindAccountTableCell.h"

@interface LCWithDrawBindAccountTableCell ()<UITextFieldDelegate>
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UITextField *textField;

@end
@implementation LCWithDrawBindAccountTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
           
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(14));
            make.left.lessThanOrEqualTo(kUI_Width(70));
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.left.equalTo(self.tipLabel.mas_right).offset(kUI_Width(20));
            make.centerY.equalTo(0);
        }];
       
        WS(weakSelf)
        [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            if(weakSelf.textChangeBlock){
                weakSelf.textChangeBlock(weakSelf.leftTitle, x);
            }
        }];
    }
    return self;
}
- (void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = [leftTitle copy];
    self.tipLabel.text = _leftTitle;
}
- (void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = [rightTitle copy];
    self.textField.text = rightTitle;
}
- (void)setRightHoldTitle:(NSString *)rightHoldTitle{
    _rightHoldTitle = [rightHoldTitle copy];
   self.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:_rightHoldTitle attributes:@{
                NSForegroundColorAttributeName:Color(@"#666666"),NSFontAttributeName:RegularFont(14)
            }];
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
- (UILabel *)tipLabel{
    if(!_tipLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = MediumFont(14);
        label.textColor = Color(@"#333333");
//        label.text = @"¥";
//        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:label];
        _tipLabel = label;
    }
    return _tipLabel;
}
- (UITextField *)textField{
    if(!_textField){
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.delegate = self;
        textField.font = RegularFont(14);
        textField.backgroundColor = [UIColor clearColor];
        textField.clipsToBounds = YES;
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = Color(@"#333333");
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textField.keyboardType = UIKeyboardTypeDecimalPad;
//        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"最低提现金额0.00元" attributes:@{
//            NSForegroundColorAttributeName:Color(@"#666666"),NSFontAttributeName:RegularFont(14)
//        }];
        [self.backView addSubview:textField];
        _textField = textField;
    }
    return _textField;
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
