//
//  LCUpdatePersonalProfileCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCUpdatePersonalProfileCell.h"
#import "UITextView+LCPlaceHolder.h"
@interface LCUpdatePersonalProfileCell ()<UITextViewDelegate>
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UITextView *profileTextView;
@end
@implementation LCUpdatePersonalProfileCell

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
            make.height.equalTo(kUI_Width(20));
            make.width.lessThanOrEqualTo(kUI_Width(100));
            make.top.equalTo(kUI_Width(15));
           
        }];
        [self.profileTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tipLabel.mas_right);
            make.right.equalTo(-kUI_Width(12));
            make.top.mas_equalTo(self.tipLabel.mas_top);
            make.bottom.equalTo(-kUI_Width(15));
           
        }];
        @weakify(self)
        [self.profileTextView.rac_textSignal  subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            
            if (self.textChangeBlock) {
                CGFloat size = [self.profileTextView sizeThatFits:self.profileTextView.bounds.size].height;
                        
                self.textChangeBlock(self.profileTextView.text,size);
            }
                }];
        
        
    }
    return self;
}
- (void)setProfile:(NSString *)profile{
    _profile = [profile copy];
    self.profileTextView.text = _profile;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //检测换行
    if ([text isEqualToString:@"\n"]) {



        return NO;
    }

    if ([text isEqualToString:@""]) {
        return YES;
    }
   
    return YES;
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
- (UITextView *)profileTextView {
    if (_profileTextView == nil) {
        UITextView *textView = [[UITextView alloc] init];
        _profileTextView = textView;
        _profileTextView.font = RegularFont(14);
        _profileTextView.delegate = self;
        _profileTextView.textContainerInset = UIEdgeInsetsZero;
        _profileTextView.scrollEnabled = NO;
        _profileTextView.textColor = Color(@"#333333");
        _profileTextView.textAlignment = NSTextAlignmentLeft;
        _profileTextView.attributedPlaceholder = [[NSAttributedString alloc]initWithString:KLanguage(@"请输入个性签名") attributes:@{NSFontAttributeName:RegularFont(14),NSForegroundColorAttributeName:Color(@"#999999")}];
        [self.backView addSubview:_profileTextView];
    }
    return _profileTextView;
}
- (UILabel *)tipLabel{
    if(_tipLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = MediumFont(14);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"头像：");
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _tipLabel = label;
    }
    return _tipLabel;
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
