//
//  LCHomeBannerCollectionCell.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/21.
//

#import "LCHomeBannerCollectionCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

static CGFloat LCHomeBannerVerticalSpacing(void) {
    return kUI_Width(5);
}

@interface LCHomeBannerCollectionCell ()<SDCycleScrollViewDelegate>
@property (nonatomic , weak) SDCycleScrollView *bannerView;
@end

@implementation LCHomeBannerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(LCHomeBannerVerticalSpacing());
            make.bottom.equalTo(-LCHomeBannerVerticalSpacing());
        }];
    }
    return self;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.clickBlock){
        self.clickBlock(index);
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = [dataArray copy];
    NSMutableArray *imgArr = [NSMutableArray array];
    for (LCBannerModel *model in _dataArray) {
        [imgArr addObject:model.slide_pic ? model.slide_pic : @""];
    }
    self.bannerView.imageURLStringsGroup = imgArr;
}

#pragma mark---- 懒加载 ----
- (SDCycleScrollView *)bannerView{
    if (_bannerView == nil){
        SDCycleScrollView *bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectZero];
        bannerView.delegate = self;
        bannerView.backgroundColor = [UIColor clearColor];
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        bannerView.hidesForSinglePage = YES;
        bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        bannerView.autoScrollTimeInterval = 3.0;
        bannerView.currentPageDotColor = Color(@"#E5407B");
        bannerView.pageDotColor = Color(@"#FFFFFF");
        bannerView.pageControlDotSize = CGSizeMake(kUI_Width(3), kUI_Width(3));
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        [self.contentView addSubview:bannerView];
        _bannerView = bannerView;
    }
    return _bannerView;
}

@end
