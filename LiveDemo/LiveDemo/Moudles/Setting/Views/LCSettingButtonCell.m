//
//  LCSettingButtonCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCSettingButtonCell.h"

@interface LCSettingButtonCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *leftTitleLabel;
@property (nonatomic , weak) UIButton *rightImgView;
@end
@implementation LCSettingButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(40));
            make.top.equalTo(0);
            make.bottom.equalTo(-kUI_Width(1));
        }];
        [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(20));
            make.centerY.equalTo(0);
            make.right.mas_equalTo(self.rightImgView.mas_left).offset(-kUI_Width(10));
            make.left.equalTo(kUI_Width(kViewMargin));
        }];
       
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(28));
            make.width.equalTo(kUI_Width(61));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.centerY.equalTo(0);
        }];
    }
    return self;
}

- (void)setDataModel:(LCSettingModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    RAC(self.leftTitleLabel,text) = [RACObserve(_dataModel, leftTitle) takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(_dataModel, rightValue) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.rightImgView setTitle:x forState:UIControlStateNormal];
    }];
    
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(_backView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = Color(@"#FFFFFF");
        view.layer.cornerRadius = kUI_Width(4);
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        UILabel *lab = [UILabel new];
        lab.font = MediumFont(14);
        lab.textColor = Color(@"#333333");
        [lab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [lab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _leftTitleLabel = lab;
        [self.backView addSubview:_leftTitleLabel];
        
    }
    return _leftTitleLabel;
}

- (UIButton *)rightImgView {
    if (!_rightImgView) {
        UIButton *imgView = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgView setBackgroundImage:image(@"icon_settingVersionBtnBg") forState:UIControlStateNormal];
        imgView.titleLabel.font = MediumFont(14);
        _rightImgView =  imgView;
        
        [self.backView addSubview:_rightImgView];
        WS(weakSelf)
        [[_rightImgView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:weakSelf.dataModel];
        }];
    }
    return _rightImgView;
}
- (RACSubject *)clickSubject{
    if(_clickSubject){
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
