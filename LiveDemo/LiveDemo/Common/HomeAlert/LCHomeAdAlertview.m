//
//  LCHomeAdAlertview.m
//  LiveDemo
//
//  Created by mrgao on 2024/7/27.
//

#import "LCHomeAdAlertview.h"
#import "SDCycleScrollView/SDCycleScrollView.h"
@interface LCHomeAdAlertview ()<SDCycleScrollViewDelegate>
@property (nonatomic , weak) UIView *contentView;
//@property (nonatomic , weak) UIButton *closeBtn;
@property (nonatomic , weak) SDCycleScrollView *contentImgView;

@property (nonatomic , weak) UIButton *closeBtn;

@end
@implementation LCHomeAdAlertview
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorAlpha(@"#000000", 0.5);
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.height.equalTo(kUI_Width(386));
            make.top.equalTo(kUI_Width(131));
        }];
        [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.width.height.equalTo(kUI_Width(64));
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(kUI_Width(15));
        }];
    }
    return self;
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    NSMutableArray *picArr = [NSMutableArray array];
    for (LCHomeAlertModel *model in _dataArray) {
        [picArr addObject:model.image];
    }
    self.contentImgView.imageURLStringsGroup = picArr;
    
    
}
#pragma mark---- SDCycleScrollViewDelegate ----
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if(self.clickBlock){
        self.clickBlock(self.dataArray[index]);
    }
    
}
#pragma mark--   LazyLoad
- (UIView *)contentView{
    if (_contentView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
//        view.layer.cornerRadius = kUI_Width(8);
//        view.clipsToBounds = YES;
        [self addSubview:view];
        _contentView = view;
    }
    return _contentView;
}
- (SDCycleScrollView *)contentImgView{
    if (!_contentImgView ){
        SDCycleScrollView *bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectZero];
        bannerView.delegate = self;
        bannerView.backgroundColor = [UIColor clearColor];
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        bannerView.showPageControl = NO;
        [self.contentView addSubview:bannerView];
        
        bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        bannerView.autoScrollTimeInterval = 3.0;//轮播时间间隔，默认1.0秒，可自定义
        
        bannerView.clipsToBounds = YES;
//        bannerView.layer.cornerRadius = kUI_Width(8);
        _contentImgView = bannerView;
    }
    return _contentImgView;
}
- (UIButton *)closeBtn{
    if(_closeBtn == nil){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image(@"icon_homeAlertClose") forState:UIControlStateNormal];
        [self addSubview:btn];
        _closeBtn = btn;
        WS(weakSelf)
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if(weakSelf.closeBlock){
                weakSelf.closeBlock();
            }
            [weakSelf removeFromSuperview];
        }];
        
    }
    return _closeBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
