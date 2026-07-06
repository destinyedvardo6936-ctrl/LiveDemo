//
//  LCWithDrawTextFieldTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/23.
//

#import "LCWithDrawTextFieldTableViewCell.h"

@interface LCWithDrawTextFieldTableViewCell ()<UITextFieldDelegate>
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UITextField *textField;

@property (nonatomic , weak) UIButton *allBtn;
@property (nonatomic , weak) UIView *lineView;

@end
@implementation LCWithDrawTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(16));
            make.right.equalTo(-kUI_Width(16));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
           
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(16));
            make.centerY.equalTo(0);
            make.height.equalTo(kUI_Width(18));
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.allBtn.mas_left).offset(-kUI_Width(10));
            make.height.equalTo(kUI_Width(12));
            make.left.equalTo(self.tipLabel.mas_right).offset(kUI_Width(10));
            make.centerY.equalTo(0);
        }];
        [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(17));
            make.right.equalTo(-kUI_Width(16));
            make.width.equalTo(kUI_Width(50));
            make.centerY.equalTo(0);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(16));
            make.right.equalTo(-kUI_Width(16));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kUI_Width(12));
            make.height.equalTo(1);
        }];
        @weakify(self)
        [self.textField.rac_textSignal  subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if([x integerValue]  > self.dataModel.votes.integerValue){
                [SVProgressHUD showNoMaskViewWithInfo:KLanguage(@"数量不足") ];
                return;
            }
          
            [self.textSubject sendNext:x];
        }];
    }
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
//        view.layer.cornerRadius = kUI_Width(4);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UILabel *)tipLabel{
    if(!_tipLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(18);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"数量");
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:label];
        _tipLabel = label;
    }
    return _tipLabel;
}
- (UITextField *)textField{
    if(!_textField){
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.delegate = self;
        textField.font = RegularFont(12);
        textField.backgroundColor = [UIColor clearColor];
        textField.clipsToBounds = YES;
        
        textField.textColor = Color(@"#333333");
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"最低提现数量1个")  attributes:@{
            NSForegroundColorAttributeName:Color(@"#999999"),NSFontAttributeName:RegularFont(12)
        }];
        [self.contentView addSubview:textField];
        _textField = textField;
    }
    return _textField;
}
- (UIButton *)allBtn{
    if(_allBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:KLanguage(@"全部提现")  forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
        btn.titleLabel.font = RegularFont(12);
        [self.contentView addSubview:btn];
        _allBtn = btn;
        WS(weakSelf)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            weakSelf.textField.text = [NSString stringWithFormat:@"%@",weakSelf.dataModel.votes];
            [weakSelf.textSubject sendNext:weakSelf.dataModel.votes];
        }];
    }
    return _allBtn;
}
- (UIView *)lineView{
    if(!_lineView){
        UIView *view = [[UIView alloc] init];
       

        view.backgroundColor = Color(@"#FFD2DC");
        [self.contentView addSubview:view];
        _lineView = view;
    }
    return _lineView;
}
- (RACSubject *)textSubject{
    if(!_textSubject){
        _textSubject = [RACSubject subject];
    }
    return _textSubject;
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
