//
//  LCLiveGameRecommendView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import "LCLiveGameRecommendView.h"
#import <SDCycleScrollView.h>

@interface LCLiveGameRecommendView ()<SDCycleScrollViewDelegate>
@property (nonatomic , weak) SDCycleScrollView *mainScrollView;
@end
@implementation LCLiveGameRecommendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    self.mainScrollView.imageURLStringsGroup = _dataArr;
}
#pragma mark---- SDCycleScrollViewDelegate ----
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if(self.gameClickBlock){
        self.gameClickBlock(self.dataArr[index]);
    }
}
#pragma mark---- 懒加载 ----
- (SDCycleScrollView *)mainScrollView{
    if (!_mainScrollView){
        SDCycleScrollView *bannerView = [[SDCycleScrollView alloc]initWithFrame: CGRectZero];
        _mainScrollView = bannerView;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _mainScrollView.delegate = self;
        _mainScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        [self addSubview:_mainScrollView];
        _mainScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mainScrollView.autoScrollTimeInterval = 3.0;//轮播时间间隔，默认1.0秒，可自定义
    
       
//        _cycleScroll.imageURLStringsGroup = sliderMuArr;
        
    }
    return _mainScrollView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
