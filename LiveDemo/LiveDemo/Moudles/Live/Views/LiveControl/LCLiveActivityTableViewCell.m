//
//  LCLiveActivityTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/10.
//

#import "LCLiveActivityTableViewCell.h"

@interface LCLiveActivityTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *titleLabel;
@property (nonatomic , weak) UIImageView *timeBgView;
@property (nonatomic , weak) UILabel *timeLabel;
@end
@implementation LCLiveActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(148));
            make.top.bottom.equalTo(0);
        }];
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(5));
            make.right.equalTo(-kUI_Width(5));
            make.top.equalTo(kUI_Width(7));
            make.height.equalTo(kUI_Width(115));
            
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(8));
            make.centerY.mas_equalTo(self.timeBgView.mas_centerY);
            make.right.mas_equalTo(self.timeBgView.mas_left).offset(-kUI_Width(10));
            make.height.equalTo(kUI_Width(14));
        }];
        [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainImgView.mas_bottom).offset(kUI_Width(1));
            make.height.equalTo(kUI_Width(22));
            make.right.equalTo(-kUI_Width(8));
            
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(10));
            make.right.equalTo(-kUI_Width(10));
        }];
    }
    return self;
}
- (void)setDataModel:(LCActivityModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self);
    [[RACObserve(_dataModel, image) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.mainImgView setImageStr:x];
    }];
    RAC(self.titleLabel,text) = [RACObserve(_dataModel, title)  takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.timeLabel,text) = [[RACObserve(_dataModel, endtime) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(value.length){
            return [NSString stringWithFormat:@"%@%@",KLanguage(@"活动时间：") ,value];
        }
        return nil;
    }]takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----
- (UIView *)backView{
    if(!_backView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#D5D0F3", 1);
        view.layer.cornerRadius = kUI_Width(12);
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UIImageView *)mainImgView{
    if(_mainImgView == nil){
        UIImageView *imgView  = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.backView addSubview:imgView];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kUI_Width(8);
        _mainImgView = imgView;
    }
    return _mainImgView;
}
- (UIImageView *)timeBgView{
    if(_timeBgView == nil){
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectZero];
//        view.contentMode = UIViewContentModeScale
//        view.backgroundColor = ColorAlpha(@"#000000", 0.5);
        view.image = image(@"icon_liveActivityTimeBg");
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = kUI_Width(22)/2.0;
        view.clipsToBounds = YES;
        [self.backView addSubview:view];
        _timeBgView = view;
    }
    return _timeBgView;
}
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(14);
        label.textColor = Color(@"#6053C1");
//        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.backView addSubview:label];
        _titleLabel = label;
        
    }
    return _titleLabel;
}
- (UILabel *)timeLabel{
    if(_timeLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#FFFFFF");
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.timeBgView addSubview:label];
        _timeLabel = label;
        
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
