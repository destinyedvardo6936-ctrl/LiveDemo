//
//  LCGameTypeTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/3/16.
//

#import "LCGameTypeTableViewCell.h"

@interface LCGameTypeTableViewCell ()
@property (nonatomic , weak) UIImageView *backImgView;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *mainLabel;
@end
@implementation LCGameTypeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(kUI_Width(29));
            make.centerX.equalTo(0);
            make.top.equalTo(kUI_Width(7));
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainImgView.mas_bottom).offset(kUI_Width(1));
            make.left.right.equalTo(0);
            make.height.equalTo(kUI_Width(12));
        }];
    }
    return self;
}
- (void)setDataModel:(LCGameTypeModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        self.backImgView.image = [x boolValue]?image(@"icon_gameOpitionSelectBgImg"):image(@"icon_gameOpitionBgImg");
        
        
    }];
    [[RACObserve(_dataModel, icon) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self.mainImgView setImageStr:x];
        
        
    }];
    RAC(self.mainLabel,text) = [RACObserve(_dataModel, name) takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark---- 懒加载 ----
- (UIImageView *)backImgView{
    if(!_backImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:imgView];
        imgView.image = image(@"icon_gameOpitionBgImg");
        _backImgView = imgView;
    }
    return _backImgView;
}
- (UIImageView *)mainImgView{
    if(!_mainImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.backImgView addSubview:imgView];
        _mainImgView = imgView;
    }
    return _mainImgView;
}
- (UILabel *)mainLabel{
    if(!_mainLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = RegularFont(12);
        label.textColor = Color(@"#6F5AA2");
        label.textAlignment = NSTextAlignmentCenter;
        [self.backImgView addSubview:label];
        _mainLabel = label;
    }
    return _mainLabel;
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
