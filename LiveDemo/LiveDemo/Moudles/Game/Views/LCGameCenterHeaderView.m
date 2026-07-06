//
//  LCGameCenterHeaderView.m
//  LiveDemo
//
//  Created by mrgao on 2023/6/4.
//

#import "LCGameCenterHeaderView.h"
#import "JXCategoryTitleBackgroundView.h"
#import <JXCategoryIndicatorBackgroundView.h>
#import "LCShelterGradientView.h"
@interface LCGameCenterHeaderView ()<JXCategoryTitleViewDataSource,JXCategoryViewDelegate>
@property (nonatomic, weak) JXCategoryTitleBackgroundView *segmentControl;
@end
@implementation LCGameCenterHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(kUI_Width(28));
            make.top.equalTo(kUI_Width(10));
        }];
    }
    return self;
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    NSMutableArray *titleArr = [NSMutableArray array];
    for (LCGameSubTypeModel *model in _dataArray) {
        [titleArr addObject:model.name];
    }
    self.segmentControl.titles = titleArr.copy;
    
    [self.segmentControl reloadData];
    [self.segmentControl selectItemAtIndex:0];
}
- (void)setSelectTypeModel:(LCGameSubTypeModel *)selectTypeModel{
    _selectTypeModel = selectTypeModel;
    NSInteger index = [self.dataArray indexOfObject:_selectTypeModel];
    [self.segmentControl selectItemAtIndex:index];
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    if(self.subTypeClickBlock){
        self.subTypeClickBlock(self.dataArray[index]);
    }
}
- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title{

    return  [title sizeForFont:titleView.titleSelectedFont size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping].width;

}
- (JXCategoryTitleBackgroundView *)segmentControl {
    if (_segmentControl == nil) {
        JXCategoryTitleBackgroundView *segmentView = [[JXCategoryTitleBackgroundView alloc]initWithFrame:CGRectZero];
   
        segmentView.cellWidthIncrement = kUI_Width(8) * 2;
        segmentView.contentEdgeInsetLeft = kUI_Width(kViewMargin);
        segmentView.contentEdgeInsetRight = kUI_Width(kViewMargin);
        //    segmentView.titleDataSource = self;
        segmentView.titleFont = RegularFont(12);
        segmentView.titleSelectedFont = RegularFont(14);
        segmentView.titleColor = Color(@"#333333");
        segmentView.titleSelectedColor = Color(@"#FFFFFF");
        segmentView.cellSpacing = kUI_Width(12);
        segmentView.averageCellSpacingEnabled = NO;
        segmentView.delegate = self;
        segmentView.titleDataSource = self;
        segmentView.backgroundHeight = kUI_Width(28) ;
        segmentView.normalBackgroundColor = Color(@"#EEEEEE");
        segmentView.selectedBackgroundColor = [UIColor clearColor];
        segmentView.borderLineWidth = 0.0;
        segmentView.backgroundCornerRadius = kUI_Width(28) / 2.0;
        JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
        backgroundView.indicatorHeight = kUI_Width(28);
        backgroundView.indicatorWidthIncrement = 0;
        backgroundView.indicatorCornerRadius = kUI_Width(28) / 2.0;
        backgroundView.clipsToBounds = YES;
        LCShelterGradientView *gradientView = [LCShelterGradientView new];
        gradientView.gradientLayer.startPoint = CGPointMake(1, 0.5);
        gradientView.gradientLayer.endPoint = CGPointMake(1, 0);
        gradientView.gradientLayer.colors = @[(__bridge id)Color(@"#FF76AF").CGColor, (__bridge id)Color(@"#FF2672 ").CGColor, ];
        gradientView.gradientLayer.locations = @[@(0), @(1.0f)];
        // 设置 gradientView 布局和 JXCategoryIndicatorBackgroundView 一样
        gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [backgroundView addSubview:gradientView];
        
        segmentView.indicators = @[backgroundView];
        _segmentControl = segmentView;
        [self addSubview:_segmentControl];
        
//
//        _segmentControl.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    }

    return _segmentControl;
}
@end
