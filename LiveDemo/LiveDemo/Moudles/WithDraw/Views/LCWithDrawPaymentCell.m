//
//  LCWithDrawPaymentCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCWithDrawPaymentCell.h"

@interface LCWithDrawPaymentCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *valueLabel;
@property (nonatomic , weak) UIImageView *accessImgView;
@end
@implementation LCWithDrawPaymentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(80));
        }];
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(24));
            make.width.height.equalTo(kUI_Width(40));
           
            make.centerY.equalTo(0);
           
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(16));
            make.height.equalTo(kUI_Width(18));
            make.right.mas_equalTo(self.accessImgView.mas_left).offset(-kUI_Width(16));
            make.top.equalTo(kUI_Width(19));
           
        }];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(16));
            make.height.equalTo(kUI_Width(12));
            make.right.mas_equalTo(self.accessImgView.mas_left).offset(-kUI_Width(16));
            make.bottom.equalTo(-kUI_Width(19));
           
        }];
        [self.accessImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-kUI_Width(12));
            make.width.equalTo(kUI_Width(14));
            make.height.equalTo(kUI_Width(14));
            make.centerY.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataModel:(LCWithDrawPaymentModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self);
    [[RACObserve(_dataModel, icon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.mainImgView setImageStr:x];
    }];
    RAC(self.titleLabel,text) = [RACObserve(_dataModel, name) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.valueLabel,text) = [[RACObserve(_dataModel, cash_take) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(!value.length){
            return nil;
        }
        return [NSString stringWithFormat:@"%@：%@%%",KLanguage(@"手续费"),value];
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
       
        label.font = MediumFont(18);
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
       
        label.font = RegularFont(12);
        label.textColor = Color(@"#999999");
        
 
        [self.backView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _valueLabel = label;
    }
    return _valueLabel;
}
- (UIImageView *)accessImgView{
    if(!_accessImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_withdrawAccessImg")];
        [self.backView addSubview:imgView];
        _accessImgView = imgView;
    }
    return _accessImgView;
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
