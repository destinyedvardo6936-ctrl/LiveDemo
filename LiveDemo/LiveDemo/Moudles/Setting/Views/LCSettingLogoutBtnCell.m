//
//  LCSettingLogoutBtnCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCSettingLogoutBtnCell.h"

@interface LCSettingLogoutBtnCell ()
@property (nonatomic , weak) UIButton *mainBtn;
@end
@implementation LCSettingLogoutBtnCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kUI_Width(205));
            make.height.equalTo(kUI_Width(40));
            make.centerX.equalTo(0);
            make.top.bottom.equalTo(0);
        }];
        
    }
    return self;
}
#pragma mark---- 懒加载 ----
- (UIButton *)mainBtn{
    if(_mainBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_logoutBtnBg") forState:UIControlStateNormal];
        [btn setTitle:KLanguage(@"退出登录") forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = BoldFont(18);
        _mainBtn = btn;
        [self.contentView addSubview:_mainBtn];
        WS(weakSelf)
        [[_mainBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:@(YES)];
        }];
    }
    return _mainBtn;
}
- (RACSubject *)clickSubject{
    if(!_clickSubject){
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
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
