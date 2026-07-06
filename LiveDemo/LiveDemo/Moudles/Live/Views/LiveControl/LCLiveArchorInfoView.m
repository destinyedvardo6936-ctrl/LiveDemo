//
//  LCLiveArchorInfoView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import "LCLiveArchorInfoView.h"

@interface LCLiveArchorInfoView ()
@property (nonatomic , weak) UIImageView *archorAvaterImgView;
@property (nonatomic , weak) UILabel *archorNameLabel;
@property (nonatomic , weak) UILabel *archorIDLabel;
@property (nonatomic , weak) UIButton *followBtn;
@end
@implementation LCLiveArchorInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.archorAvaterImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(0);
            make.width.mas_equalTo(self.archorAvaterImgView.mas_height);
        }];
        [self.archorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.archorAvaterImgView.mas_right).offset(kUI_Width(4));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(4));
            
        }];
        [self.archorIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.archorAvaterImgView.mas_right).offset(kUI_Width(4));
            make.height.equalTo(kUI_Width(12));
            make.bottom.equalTo(-kUI_Width(4));
        }];
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.height.width.equalTo(kUI_Width(22));
            make.right.equalTo(-kUI_Width(5));
        }];
    }
    return self;
}
- (void)setDataModel:(LCLiveArchorModel *)dataModel{
    _dataModel = dataModel;
    @weakify(self)
    [[RACObserve(_dataModel, avatar_thumb) takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        [self.archorAvaterImgView setImageStr:x];
    }];
    [[RACObserve(_dataModel, isAttention) takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self)
        if([x boolValue]){
            self.followBtn.hidden = YES;
        }else{
            self.followBtn.hidden = NO;
        }
        [self setNeedsUpdateConstraints];
    }];
    RAC(self.archorNameLabel,text) = [RACObserve(_dataModel, user_nicename) takeUntil:self.rac_willDeallocSignal];
    RAC(self.archorIDLabel,text) = [RACObserve(_dataModel, uid) takeUntil:self.rac_willDeallocSignal];
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.archorNameLabel layoutIfNeeded];
    CGFloat nameWidth = self.archorNameLabel.width;
    [self.archorIDLabel layoutIfNeeded];
    CGFloat idWidth = self.archorIDLabel.width;
    if (nameWidth > idWidth){
        [self.archorNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.archorAvaterImgView.mas_right).offset(kUI_Width(4));
            make.height.equalTo(kUI_Width(12));
            make.top.equalTo(kUI_Width(4));
            make.width.equalTo(nameWidth);
            make.right.equalTo(self.followBtn.hidden? (-kUI_Width(12)):(-kUI_Width(12) - kUI_Width(36) - kUI_Width(9)));
        }];
    }else{
        [self.archorIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.archorAvaterImgView.mas_right).offset(kUI_Width(4));
            make.height.equalTo(kUI_Width(12));
            make.bottom.equalTo(-kUI_Width(4));
            make.width.equalTo(idWidth);
            make.right.equalTo(self.followBtn.hidden? (-kUI_Width(12)):(-kUI_Width(12) - kUI_Width(36) - kUI_Width(9)));
        }];
    }
}
#pragma mark---- 懒加载 ----
- (UIImageView *)archorAvaterImgView{
    if (!_archorAvaterImgView){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kUI_Width(36)/2.0;
        imgView.userInteractionEnabled = YES;
        [self addSubview:imgView];
        _archorAvaterImgView = imgView;
        WS(weakSelf)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if(weakSelf.avaterClickBlock){
                weakSelf.avaterClickBlock(weakSelf.dataModel);
            }
        }];
        [_archorAvaterImgView addGestureRecognizer:tap];
    }
    return _archorAvaterImgView;
}
- (UILabel *)archorNameLabel{
    if(!_archorNameLabel){
        UILabel *label = [[UILabel alloc] init];
        label.font = BoldFont(12);
        label.textColor = Color(@"#FFFFFF");
        [self addSubview:label];
        _archorNameLabel = label;
    }
    return _archorNameLabel;
}
- (UILabel *)archorIDLabel{
    if(!_archorIDLabel){
        UILabel *label = [[UILabel alloc] init];
        label.font = BoldFont(10);
        label.textColor = Color(@"#CCCCCC");
        [self addSubview:label];
        _archorIDLabel = label;
    }
    return _archorIDLabel;
}
- (UIButton *)followBtn{
    if(!_followBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image(@"icon_liveFollowImg") forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        _followBtn = btn;
        WS(weakSelf)
        [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            weakSelf.followBtn.hidden = YES;
//            [weakSelf.ar]
            if(weakSelf.followBtn){
                weakSelf.followBlock();
            }
        }];
    }
    return _followBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
