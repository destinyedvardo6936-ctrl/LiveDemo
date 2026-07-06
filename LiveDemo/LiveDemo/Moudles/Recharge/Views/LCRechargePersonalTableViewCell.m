//
//  LCRechargePersonalTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/16.
//

#import "LCRechargePersonalTableViewCell.h"

@interface LCRechargePersonalTableViewCell ()

@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *nameLabel;
@property (nonatomic , weak) UIButton *wxBtn;
@property (nonatomic , weak) UIButton *qqBtn;
@end
@implementation LCRechargePersonalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.width.height.equalTo(kUI_Width(55));
           
            make.top.equalTo(kUI_Width(10));
            make.bottom.equalTo(-kUI_Width(12));
           
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(12));
            make.height.equalTo(kUI_Width(16));
            make.right.mas_equalTo(self.wxBtn.mas_left).offset(-kUI_Width(12));
            make.centerY.mas_equalTo(self.mainImgView.mas_centerY);
           
        }];
        [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.qqBtn.mas_left).offset(-kUI_Width(12));
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(61));
            make.centerY.equalTo(0);
           
        }];
        [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(61));
            make.centerY.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataModel:(LCRechargeConnetPersonModel *)dataModel{
    _dataModel = dataModel;
//    @weakify(self);
//        [[RACObserve(_dataModel, icon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
//            @strongify(self)
//            [self.mainImgView setImageStr:x];
//        }];
        RAC(self.nameLabel,text) = [RACObserve(_dataModel, name) takeUntil:self.rac_prepareForReuseSignal];
}
//- (void)setDataModel:(WYMessionModel *)dataModel{
//    _dataModel = dataModel;
//    @weakify(self);
//    [[RACObserve(_dataModel, icon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
//        @strongify(self)
//        [self.mainImgView setImageStr:x];
//    }];
//    RAC(self.titleLabel,text) = [RACObserve(_dataModel, title) takeUntil:self.rac_prepareForReuseSignal];
//    RAC(self.valueLabel,text) = [RACObserve(_dataModel, remark) takeUntil:self.rac_prepareForReuseSignal];
//}
#pragma mark---- 懒加载 ----

- (UIImageView *)mainImgView {
    if (_mainImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mainImgView = imgView;
        _mainImgView.contentMode = UIViewContentModeScaleAspectFit;
        _mainImgView.backgroundColor = Color(@"#666666");
        _mainImgView.layer.masksToBounds = YES;
        _mainImgView.layer.cornerRadius = kUI_Width(55)/2.0;
        _mainImgView.clipsToBounds = YES;
        [self.contentView addSubview:_mainImgView];
    }

    return _mainImgView;
}
- (UILabel *)nameLabel{
    if(_nameLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = MediumFont(16);
        label.textColor = Color(@"#333333");
        
 
        [self.contentView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _nameLabel = label;
    }
    return _nameLabel;
}
- (UIButton *)wxBtn{
    if (_wxBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_settingVersionBtnBg") forState:UIControlStateNormal];
        [btn setTitle:KLanguage(@"微信")  forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = MediumFont(14);
        _wxBtn = btn;
        
        [self.contentView addSubview:_wxBtn];
        WS(weakSelf)
        [[_wxBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.btnClickBlock){
                weakSelf.btnClickBlock(weakSelf.dataModel, 2);
            }
        }];
    }
    return _wxBtn;
}
- (UIButton *)qqBtn{
    if (_qqBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image(@"icon_settingVersionBtnBg") forState:UIControlStateNormal];
        [btn setTitle:KLanguage(@"QQ")  forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        btn.titleLabel.font = MediumFont(14);
        _qqBtn = btn;
        
        [self.contentView addSubview:_qqBtn];
        WS(weakSelf)
        [[_qqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.btnClickBlock){
                weakSelf.btnClickBlock(weakSelf.dataModel, 1);
            }
        }];
    }
    return _qqBtn;
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
