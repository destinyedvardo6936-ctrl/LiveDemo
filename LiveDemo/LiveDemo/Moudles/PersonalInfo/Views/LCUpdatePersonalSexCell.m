//
//  LCUpdatePersonalSexCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/18.
//

#import "LCUpdatePersonalSexCell.h"

@interface LCUpdatePersonalSexCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *tipLabel;
@property (nonatomic , weak) UIButton *switchBtn;
@end
@implementation LCUpdatePersonalSexCell

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
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(20));
            make.width.equalTo(kUI_Width(44));
            make.centerY.equalTo(0);
           
        }];
        
       
    }
    return self;
}
- (void)setSex:(NSString *)sex{
    _sex = [sex copy];
    if([_sex integerValue] == 1){
        self.switchBtn.selected = YES;
    }else{
        self.switchBtn.selected = NO;
    }
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
        label.text = KLanguage(@"性别：");
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _tipLabel = label;
    }
    return _tipLabel;
}
- (UIButton *)switchBtn {
    if (!_switchBtn) {
         
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
         
        [btn setImage: image(@"icon_sexSwitchSelected") forState:(UIControlStateNormal)];
        [btn setImage:image(@"icon_sexSwitchNormal") forState:(UIControlStateSelected)];

        _switchBtn = btn;
         [self.backView addSubview:_switchBtn];
        @weakify(self)
        [[_switchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.btnClickSubject sendNext:@(x.selected)];
        }];
    
    }
    return _switchBtn;
}
- (RACSubject *)btnClickSubject{
    if(!_btnClickSubject){
        _btnClickSubject = [RACSubject subject];
    }
    return _btnClickSubject;
}
@end
