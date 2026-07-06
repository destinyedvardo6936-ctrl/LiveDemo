//
//  LCAudienceCollectionViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import "LCAudienceCollectionViewCell.h"

@interface LCAudienceCollectionViewCell ()
@property (nonatomic , weak) UIImageView *mainImgView;
@end
@implementation LCAudienceCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataModel:(LCLiveUserModel *)dataModel{
    _dataModel = dataModel;
    [self.mainImgView setImageStr:_dataModel.avatar];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.mainImgView.layer.cornerRadius = self.width/2.0;
}
#pragma mark---- 懒加载 ----
- (UIImageView *)mainImgView{
    if(!_mainImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:imgView];
        _mainImgView = imgView;
    }
    return _mainImgView;
}
@end
