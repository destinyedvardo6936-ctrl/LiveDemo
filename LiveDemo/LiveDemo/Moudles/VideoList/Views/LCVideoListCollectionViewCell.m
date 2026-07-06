//
//  LCVideoListCollectionViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCVideoListCollectionViewCell.h"

@interface LCVideoListCollectionViewCell ()
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UIImageView *vipImgView;
@property (nonatomic , weak) UILabel *timeLabel;
@property (nonatomic , weak) UILabel *titleLabel;

@end
@implementation LCVideoListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(0);
            make.height.equalTo(kUI_Width(96));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.mas_equalTo(self.mainImgView.mas_bottom).offset(kUI_Width(8));
        
        }];
        [self.vipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(kUI_Width(5));
            make.height.equalTo(kUI_Width(14));
            make.width.equalTo(kUI_Width(28));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(-kUI_Width(7));
            make.height.equalTo(kUI_Width(10));
            
        }];
    }
    return self;
}
- (void)setDataModel:(LCVideoListModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, thumb) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.mainImgView setImageStr:x];
        

    }];
    [[RACObserve(_dataModel,isvip ) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.vipImgView.hidden = ![x boolValue];
        

    }];
    RAC(self.titleLabel,text) = [RACObserve(_dataModel, title) takeUntil:self.rac_prepareForReuseSignal];
 
//    RAC(self.timeLabel,text) = [[RACObserve(_dataModel, addtime) map:^NSString * _Nullable(NSString *  _Nullable value) {
//        if(value.length){
//            return [NSString stringWithFormat:@"%@  %@",value, KLanguage(@"发布")];
//        }
//        return nil;
//    }] takeUntil:self.rac_prepareForReuseSignal];
//    RAC(self.valueLabel,text) = [RACObserve(_dataModel, content) takeUntil:self.rac_prepareForReuseSignal];
}
//- (void)setDataModel:(LCMessageListModel *)dataModel{
//    _dataModel = dataModel;
//    RAC(self.valueLabel,text) = [RACObserve(_dataModel, content) takeUntil:self.rac_prepareForReuseSignal];
//}

#pragma mark---- 懒加载 ----
//- (UIView *)backView{
//    if(!_backView){
//        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
//        view.backgroundColor = ColorAlpha(@"#FFFFFF", 1);
//        view.layer.cornerRadius = kUI_Width(4);
//        view.clipsToBounds = YES;
//        [self.contentView addSubview:view];
//        _backView = view;
//    }
//    return _backView;
//}
- (UIImageView *)mainImgView {
    if (_mainImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mainImgView = imgView;
       
        _mainImgView.contentMode = UIViewContentModeScaleAspectFill;
    
        _mainImgView.layer.masksToBounds = YES;
        _mainImgView.layer.cornerRadius = kUI_Width(4);
        _mainImgView.clipsToBounds = YES;
        [self.contentView addSubview:_mainImgView];
    }

    return _mainImgView;
}
- (UIImageView *)vipImgView {
    if (_vipImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _vipImgView = imgView;
        _vipImgView.image = image(@"icon_videoListVip");
        _vipImgView.contentMode = UIViewContentModeScaleAspectFit;
    
//        _mainImgView.layer.masksToBounds = YES;
//        _mainImgView.clipsToBounds = YES;
        [self.mainImgView addSubview:_vipImgView];
    }

    return _vipImgView;
}
- (UILabel *)timeLabel{
    if(_timeLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = RegularFont(10);
        label.textColor = Color(@"#FFFFFF");
        
        
        [self.mainImgView addSubview:label];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _timeLabel = label;
    }
    return _timeLabel;
}
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
       
        label.font = RegularFont(12);
        label.textColor = Color(@"#333333");
        label.numberOfLines = 2;
 
        [self.contentView addSubview:label];
        
        _titleLabel = label;
    }
    return _titleLabel;
}
@end
