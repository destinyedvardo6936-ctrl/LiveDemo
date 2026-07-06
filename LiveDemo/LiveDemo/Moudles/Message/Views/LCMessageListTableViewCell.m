//
//  LCMessageListTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCMessageListTableViewCell.h"

@interface LCMessageListTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *valueLabel;
@property (nonatomic , weak) UIImageView *accessImgView;
@end
@implementation LCMessageListTableViewCell

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
            make.left.equalTo(kUI_Width(12));
            make.width.height.equalTo(kUI_Width(60));
           
            make.centerY.equalTo(0);
           
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.right.mas_equalTo(self.accessImgView.mas_left).offset(-kUI_Width(12));
            make.top.mas_equalTo(self.mainImgView.mas_top).offset(kUI_Width(12));
           
        }];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(12));
            make.height.equalTo(kUI_Width(12));
            make.right.mas_equalTo(self.accessImgView.mas_left).offset(-kUI_Width(12));
            make.bottom.mas_equalTo(self.mainImgView.mas_bottom).offset(-kUI_Width(10));
           
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
- (void)setDataModel:(LCMessageListModel *)dataModel{
    _dataModel = dataModel;
    RAC(self.valueLabel,text) = [RACObserve(_dataModel, content) takeUntil:self.rac_prepareForReuseSignal];
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
        _mainImgView.image = image(@"icon_systemMessageImg");
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
       
        label.font = MediumFont(14);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"系统消息");
 
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
        label.textColor = Color(@"#666666");
        
 
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
