//
//  LCMineBannerTableViewCell.m
//  LiveDemo
//
//  Created by mrgao on 2023/1/7.
//

#import "LCMineBannerTableViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface LCMineBannerTableViewCell ()<SDCycleScrollViewDelegate>
@property (nonatomic , weak) SDCycleScrollView *bannerView;

@end
@implementation LCMineBannerTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kUI_Width(kViewMargin));
            make.right.equalTo(-kUI_Width(kViewMargin));
            make.top.bottom.equalTo(0);
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
        [imgArr addObject:model.slide_pic];
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
        [self.contentView addSubview:bannerView];
        bannerView.hidesForSinglePage = YES;
        bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        bannerView.autoScrollTimeInterval = 3.0;//轮播时间间隔，默认1.0秒，可自定义
        bannerView.currentPageDotColor = Color(@"#E5407B");
        bannerView.pageDotColor = Color(@"#FFFFFF");
        bannerView.pageControlDotSize = CGSizeMake(kUI_Width(3), kUI_Width(3));
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _bannerView = bannerView;
    }
    return _bannerView;
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
