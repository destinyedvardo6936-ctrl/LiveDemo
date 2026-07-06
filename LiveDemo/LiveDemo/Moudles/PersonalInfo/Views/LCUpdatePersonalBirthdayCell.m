//
//  LCUpdatePersonalBirthdayCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCUpdatePersonalBirthdayCell.h"
#import "NSDate+LCExtension.h"
#import "LCLanguageManager.h"
@interface LCUpdatePersonalBirthdayCell ()<UITextFieldDelegate>
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UITextField *nicknameTextField;
@property (nonatomic , weak) UIImageView *imgView;
@end
@implementation LCUpdatePersonalBirthdayCell

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
            make.right.mas_equalTo(self.imgView.mas_left).offset(-kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.left.mas_equalTo(self.tipLabel.mas_right);
            make.centerY.equalTo(0);
           
        }];
       
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(14));
            make.centerY.equalTo(0);
            make.right.equalTo(-kUI_Width(12));
        }];
        
    }
    return self;
}
- (void)setBirthday:(NSString *)birthday{
    _birthday = [birthday copy];
    self.nicknameTextField.text =  _birthday ;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
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
    if(_tipLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = MediumFont(14);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"生日：");
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _tipLabel = label;
    }
    return _tipLabel;
}
- (UITextField *)nicknameTextField{
    if(!_nicknameTextField){
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请选择生日") attributes:@{NSFontAttributeName:RegularFont(14),NSForegroundColorAttributeName:Color(@"#999999")}];
        textField.textColor = Color(@"#333333");
        textField.font = RegularFont(14);
        textField.delegate = self;
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        
        //自定义位置
        datePicker.frame = CGRectMake(0, 0, SCREEN_WIDTH, kUI_Width(200));
        //设置背景颜色
        datePicker.backgroundColor = Color(@"#FFFFFF");
        //datePicker.center = self.center;
        //设置本地化支持的语言（在此是中文)
         datePicker.locale = [NSLocale localeWithLocaleIdentifier:[[LCLanguageManager shareManager]getCurrentLanguageEncode]];
        datePicker.calendar = nil;
         //显示方式是只显示年月日
         datePicker.datePickerMode = UIDatePickerModeDate;

    NSDateFormatter *fMinDate = [[NSDateFormatter alloc] init];
    [fMinDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [fMinDate dateFromString:@"1930-09-09"];
    datePicker.minimumDate = minDate;

        
    NSDate *maxDate = [NSDate dateWithString:[NSString currentTimeString] format:@"yyyy-MM-dd"];
        datePicker.maximumDate = maxDate;
        //放在盖板上
       
        WS(weakSelf)
        [[[datePicker rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIDatePicker * _Nullable x) {
            NSDate *date = [x date];
            weakSelf.nicknameTextField.text =[date stringWithFormat:@"yyyy-MM-dd"];
            if(weakSelf.textChangeBlock){
//
                weakSelf.textChangeBlock([date stringWithFormat:@"yyyy-MM-dd"]);
            }
//            weakSelf.viewModel.birthday = [date stringWithFormat:@"yyyy-MM-dd"];
//            [weakSelf.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }];
        textField.inputView = datePicker;
        [self.backView addSubview:textField];
        _nicknameTextField = textField;
    }
    return _nicknameTextField;
}
- (UIImageView *)imgView{
    if(!_imgView){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_personalUpdateAccessImg")];
        [self.backView addSubview:imgView];
        _imgView = imgView;
    }
    return _imgView;
}
@end
