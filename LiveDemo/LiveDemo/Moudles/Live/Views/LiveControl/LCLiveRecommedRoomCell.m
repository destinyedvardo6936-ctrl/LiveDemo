//
//  LCLiveRecommedngRoomCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/12/3.
//

#import "LCLiveRecommedRoomCell.h"
#import "LCBlackShelterView.h"
@interface LCLiveRecommedRoomCell ()
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UIView *locationBgView;
@property (nonatomic , weak) UILabel *locationLabel;
@property (nonatomic , weak) LCBlackShelterView *sheleterView;
@property (nonatomic , weak) UILabel *nameLabel;
@end
@implementation LCLiveRecommedRoomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(0);
        }];
        [self.locationBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(16));
            make.top.left.equalTo(kUI_Width(4));
        }];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(kUI_Width(8));
            make.right.equalTo(-kUI_Width(8));
        }];
        [self.sheleterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(kUI_Width(39));
            
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(7));
            make.bottom.equalTo(-kUI_Width(7));
            make.height.equalTo(kUI_Width(12));
        }];
    }
    return self;
}
- (void)setDataModel:(LCHomeListModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, thumb) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
            [self.mainImgView setImageStr:x];
        

    }];
//    [[RACObserve(_dataModel, caipiao) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(LCGameListModel * _Nullable x) {
//        @strongify(self);
//
//        self.gameBackImgView.hidden = !x;
//
//
//    }];
   
//    RAC(self.gameLabel,text) = [RACObserve(_dataModel.caipiao, name) takeUntil:self.rac_prepareForReuseSignal];
//    [[RACObserve(_dataModel, type) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
//        @strongify(self);
//
//        switch (x.intValue) {
//            case 0:
//            {
//                self.chargeTypeBackView.hidden = YES;
//                self.priceBackView.hidden = YES;
//            }
////                self.chargeTypeLabel.text = @"普通";
//
//                break;
//            case 1:
//            {
//                self.chargeTypeBackView.hidden = YES;
//                self.priceBackView.hidden = YES;
//            }
//                break;
//            case 2:
//            {
//                self.chargeTypeBackView.hidden = NO;
//                self.priceBackView.hidden = NO;
//                self.chargeTypeLabel.text = KLanguage(@"按时收费") ;
//            }
//                break;
//            case 3:
//            {
//                self.chargeTypeBackView.hidden = NO;
//                self.priceBackView.hidden = NO;
//                self.chargeTypeLabel.text = KLanguage(@"按时收费") ;
//            }
//
//                break;
//            default:
//                break;
//        }
//
//    }];
    RAC(self.nameLabel,text) = [RACObserve(_dataModel, user_nicename) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.locationLabel,text) = [RACObserve(_dataModel, city) takeUntil:self.rac_prepareForReuseSignal];
//    RAC(self.numberLabel,text) = [RACObserve(_dataModel, nums) takeUntil:self.rac_prepareForReuseSignal];
// 
//    RAC(self.priceLabel,text) = [[RACObserve(_dataModel, type_val) map:^NSString * _Nullable(NSString *  _Nullable value) {
//        if(value.length){
//            return [NSString stringWithFormat:@"%@%@/%@",value,[LCConfigManager shareManager].configModel.name_coin, KLanguage(@"分钟")];
//        }
//        return nil;
//    }] takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----

- (UIImageView *)mainImgView{
    if (!_mainImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kUI_Width(8);
        [self.contentView addSubview:imgView];
        _mainImgView = imgView;
    }
    return _mainImgView;
}
- (UIView *)locationBgView{
    if(!_locationBgView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = ColorAlpha(@"#0000000", 0.5);
        view.layer.cornerRadius = kUI_Width(16)/2.0;
        [self.mainImgView addSubview:view];
        _locationBgView = view;
    }
    return _locationBgView;
}
- (UILabel *)locationLabel{
    if(!_locationLabel){
        UILabel *label = [[UILabel alloc] init];
        label.font = RegularFont(11);
        label.textColor = Color(@"#FFFFFF");
        label.textAlignment = NSTextAlignmentCenter;
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        label.backgroundColor = ColorAlpha(@"#0000000", 0.5);
//        label.layer.cornerRadius = kUI_Width(16)/2.0;
        [self.locationBgView addSubview:label];
        _locationLabel = label;
    }
    return _locationLabel;
}
- (LCBlackShelterView *)sheleterView{
    if (_sheleterView == nil) {
        LCBlackShelterView *gradientView = [LCBlackShelterView new];
      
        gradientView.gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientView.gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientView.gradientLayer.locations = @[@(0), @(1.0f)];
        gradientView.gradientLayer.colors = @[(__bridge id)ColorAlpha(@"#000000", 0).CGColor, (__bridge id)ColorAlpha(@"#000000", 1).CGColor];
//        //设置gradientView布局和JXCategoryIndicatorBackgroundView一样
//        gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _sheleterView = gradientView;
        [self.mainImgView addSubview:_sheleterView];
    }
    return _sheleterView;
}
- (UILabel *)nameLabel{
    if(!_nameLabel){
        UILabel *label = [[UILabel alloc] init];
        label.font = MediumFont(12);
        label.textColor = Color(@"#FFFFFF");
        [self.sheleterView addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
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
