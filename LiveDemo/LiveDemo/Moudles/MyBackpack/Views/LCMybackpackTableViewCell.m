//
//  LCMybackpackTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCMybackpackTableViewCell.h"

@interface LCMybackpackTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *valueLabel;
//@property (nonatomic , weak) UIButton *buyBtn;
@end
@implementation LCMybackpackTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(100));
        }];
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.width.height.equalTo(kUI_Width(76));
           
            make.centerY.equalTo(0);
           
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(12));
            make.height.equalTo(kUI_Width(18));
            make.right.equalTo(-kUI_Width(12));
            make.top.mas_equalTo(self.mainImgView.mas_top).offset(kUI_Width(17));
           
        }];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.right.equalTo(-kUI_Width(12));
            make.bottom.mas_equalTo(self.mainImgView.mas_bottom).offset(-kUI_Width(17));
           
        }];
//        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(-kUI_Width(12));
//            make.width.equalTo(kUI_Width(61));
//            make.height.equalTo(kUI_Width(28));
//            make.centerY.equalTo(0);
//        }];
    }
    return self;
}
- (void)setDataModel:(LCMyBackPackModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self);
    [[RACObserve(_dataModel, gifticon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.mainImgView setImageStr:x];
    }];
    RAC(self.titleLabel,text) = [RACObserve(_dataModel, giftname) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.valueLabel,text) = [[RACObserve(_dataModel, needcoin) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return nil;
        }
        return [NSString stringWithFormat:@"%@%@",value,KLanguage(@"钻石")];
    }] takeUntil:self.rac_prepareForReuseSignal];
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
- (UIImageView *)mainImgView {
    if (_mainImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mainImgView = imgView;
        _mainImgView.contentMode = UIViewContentModeScaleAspectFit;
    
//        _mainImgView.layer.masksToBounds = YES;
//        _mainImgView.clipsToBounds = YES;
        [self.backView addSubview:_mainImgView];
    }

    return _mainImgView;
}
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = RegularFont(16);
        label.textColor = Color(@"#333333");
        
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UILabel *)valueLabel{
    if(_valueLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = RegularFont(14);
        label.textColor = Color(@"#999999");
        
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _valueLabel = label;
    }
    return _valueLabel;
}
//- (UIButton *)buyBtn{
//    if(!_buyBtn){
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:image(@"icon_myBackPackBugBtnBg") forState:UIControlStateNormal];
//        [btn setTitle:KLanguage(@"获取") forState:UIControlStateNormal];
//        [self.backView addSubview:btn];
//        _buyBtn = btn;
//        WS(weakSelf)
//        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            [weakSelf.clickSubject sendNext:x];
//        }];
//    }
//    return _buyBtn;
//}
- (RACSubject *)clickSubject{
    if(_clickSubject == nil){
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
