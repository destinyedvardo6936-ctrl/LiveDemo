//
//  LCActivityTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/3.
//

#import "LCActivityTableViewCell.h"

@interface LCActivityTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UIView *timeBgView;
@property (nonatomic , weak) UILabel *timeLabel;
@end
@implementation LCActivityTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(10));
            make.right.equalTo(-kUI_Width(10));
            make.height.equalTo(kUI_Width(134));
            make.top.bottom.equalTo(0);
        }];
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(kUI_Width(12));
            make.height.equalTo(kUI_Width(110));
            make.bottom.equalTo(-kUI_Width(12));
        }];
        [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kUI_Width(5));
            make.height.equalTo(kUI_Width(18));
            make.left.equalTo(kUI_Width(8));
            
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(5));
            make.right.equalTo(-kUI_Width(5));
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
    RAC(self.timeLabel,text) = [[RACObserve(_dataModel, endtime) map:^NSString * _Nullable(NSString *  _Nullable value) {
        if(value.length){
            return [NSString stringWithFormat:@"%@%@",KLanguage(@"活动时间："),value];
        }
        return nil;
    }]takeUntil:self.rac_prepareForReuseSignal];
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
- (UIImageView *)mainImgView{
    if(_mainImgView == nil){
        UIImageView *imgView  = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.backView addSubview:imgView];
        imgView.clipsToBounds = YES;
        _mainImgView = imgView;
    }
    return _mainImgView;
}
- (UIView *)timeBgView{
    if(_timeBgView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#000000", 0.5);
        view.layer.cornerRadius = kUI_Width(18)/2.0;
        view.clipsToBounds = YES;
        [self.backView addSubview:view];
        _timeBgView = view;
    }
    return _timeBgView;
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
