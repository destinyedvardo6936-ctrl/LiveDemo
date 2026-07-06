//
//  LCMineOptionTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/6.
//

#import "LCMineOptionTableViewCell.h"

@interface LCMineOptionTableViewCell ()
@property (nonatomic , weak) UIView *backView;
@property (nonatomic , weak) UIImageView *leftImgView;
@property (nonatomic , weak) UILabel *mainTitleLabel;
@property (nonatomic , weak) UIImageView *rightImgView;

@end
@implementation LCMineOptionTableViewCell
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
        [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(24));
            make.centerY.equalTo(0);
        
            make.left.equalTo(kUI_Width(kViewMargin));
        }];
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(kUI_Width(20));
            make.left.mas_equalTo(self.leftImgView.mas_right).offset(kUI_Width(8));
            make.right.mas_equalTo(self.rightImgView.mas_left).offset(-kUI_Width(10));
            make.centerY.equalTo(0);
        }];
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(14));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.centerY.equalTo(0);
        }];
    }
    return self;
}

- (void)setDataModel:(LCMineOptionModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, leftImgName) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if(x){
            self.leftImgView.image = image(x);
        }
    }];
    RAC(self.mainTitleLabel,text) = [RACObserve(_dataModel, title) takeUntil:self.rac_prepareForReuseSignal];
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
- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
   

        _leftImgView =  imgView;
        
        [self.backView addSubview:_leftImgView];
        
    }
    return _leftImgView;
}
- (UILabel *)mainTitleLabel {
    if (!_mainTitleLabel) {
        UILabel *lab = [UILabel new];
        lab.font = RegularFont(14);
        lab.textColor = Color(@"#333333");

        _mainTitleLabel = lab;
        [self.backView addSubview:_mainTitleLabel];
    }
    return _mainTitleLabel;
}
- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image(@"icon_mineUserInfoAcess")];
       
        _rightImgView =  imgView;
        
        [self.backView addSubview:_rightImgView];
        
    }
    return _rightImgView;
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
