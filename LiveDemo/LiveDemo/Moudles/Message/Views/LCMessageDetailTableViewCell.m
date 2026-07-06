//
//  LCMessageDetailTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/22.
//

#import "LCMessageDetailTableViewCell.h"

@interface LCMessageDetailTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UILabel *contentLabel;
@property (nonatomic , weak) UILabel *timeLabel;
@end
@implementation LCMessageDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.top.equalTo(0);
            make.bottom.equalTo(0);
           
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(14));
            make.right.equalTo(-kUI_Width(12));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kUI_Width(6));

            make.right.equalTo(-kUI_Width(12));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(kUI_Width(6));
            make.height.equalTo(kUI_Width(14));
            make.right.equalTo(-kUI_Width(12));
            make.bottom.equalTo(-kUI_Width(12));
        }];
    }
    return self;
}
- (void)setDataModel:(LCMessageListModel *)dataModel{
    _dataModel = dataModel;
//    @weakify(self);
  
   
    RAC(self.contentLabel,text) = [RACObserve(_dataModel, content) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.timeLabel,text) = [RACObserve(_dataModel, addtime) takeUntil:self.rac_prepareForReuseSignal];
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
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel = label;
        _titleLabel.font = MediumFont(14);
        _titleLabel.textColor = Color(@"#333333");
        _timeLabel.text = KLanguage(@"系统通知");
//        _titleLabel.numberOfLines = 2;
//        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        _ti
        [self.backView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel = label;
        _contentLabel.font = RegularFont(14);
        _contentLabel.textColor = Color(@"#666666");
        _contentLabel.numberOfLines = 0;
        [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_contentLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        _ti
        [self.backView addSubview:_contentLabel];
    }
    return _contentLabel;
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel = label;
        _timeLabel.font = RegularFont(10);
        _timeLabel.textColor = Color(@"#999999");

        [self.backView addSubview:_timeLabel];
    }
    return _timeLabel;
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
