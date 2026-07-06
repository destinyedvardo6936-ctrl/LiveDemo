//
//  LCVideoListCollectionHeaderView.m
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCVideoListCollectionHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
@interface LCVideoListCollectionHeaderView ()<SDCycleScrollViewDelegate>
@property (nonatomic , weak) SDCycleScrollView *bannerView;
@property (nonatomic , weak) UIImageView *mainImgView;
@property (nonatomic , weak) UILabel *mainLabel;

@end
@implementation LCVideoListCollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self){
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(12));
            make.right.equalTo(-kUI_Width(12));
            make.height.equalTo(kUI_Width(120));
            make.top.equalTo(kUI_Width(10));
        }];
        [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.bannerView.mas_bottom).offset(kUI_Width(10));
            make.width.height.equalTo(kUI_Width(25));
        }];
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mainImgView.mas_centerY);
            make.height.equalTo(kUI_Width(16));
            make.left.mas_equalTo(self.mainImgView.mas_right).offset(kUI_Width(4));
            make.right.equalTo(-kUI_Width(kViewMargin));
        }];
        
    }
    return self;
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if(_dataArray.count == 0){
        self.bannerView.hidden = YES;
        [self.mainImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.bannerView.mas_bottom);
            make.width.height.equalTo(kUI_Width(25));
        }];
    }else{
        self.bannerView.hidden = NO;
        NSMutableArray *imgArrr = [NSMutableArray array];
        for (LCBannerModel *model in _dataArray) {
            [imgArrr addObject:model.slide_pic];
        }
        self.bannerView.imageURLStringsGroup = imgArrr;
        [self.mainImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.top.mas_equalTo(self.bannerView.mas_bottom).offset(kUI_Width(10));
            make.width.height.equalTo(kUI_Width(25));
        }];
    }
    
    
}
#pragma mark---- SDCycleScrollViewDelegate ----
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if(self.clickBlock){
        self.clickBlock(self.dataArray[index]);
    }
    
}
#pragma mark---- 懒加载 ----
- (UIImageView *)mainImgView{
    if (_mainImgView == nil){
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = image(@"icon_videoListHeaderImg");
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImgView = imgView;
        [self addSubview:_mainImgView];
    }
    return _mainImgView;
}
- (UILabel *)mainLabel{
    if (!_mainLabel){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.font = BoldFont(16);
        label.textColor = Color(@"#333333");
        label.text = KLanguage(@"为您推荐");
        _mainLabel = label;
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}

- (SDCycleScrollView *)bannerView{
    if (_bannerView == nil){
        SDCycleScrollView *bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectZero];
        bannerView.delegate = self;
        bannerView.backgroundColor = [UIColor clearColor];
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        [self addSubview:bannerView];
        bannerView.hidesForSinglePage = YES;
        bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        bannerView.autoScrollTimeInterval = 3.0;//轮播时间间隔，默认1.0秒，可自定义
        bannerView.currentPageDotColor = Color(@"#E5407B");
        bannerView.pageDotColor = Color(@"#FFFFFF");
        bannerView.pageControlDotSize = CGSizeMake(kUI_Width(3), kUI_Width(3));
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        bannerView.clipsToBounds = YES;
        bannerView.layer.cornerRadius = kUI_Width(8);
        _bannerView = bannerView;
    }
    return _bannerView;
}
@end
