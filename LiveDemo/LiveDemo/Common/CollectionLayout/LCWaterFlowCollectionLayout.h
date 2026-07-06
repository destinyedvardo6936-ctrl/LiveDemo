//
//  LCWaterFlowCollectionLayout.h
//  liveCommon
//
//  Created by mrgao on 2022/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    LCWaterFlowVerticalEqualWidth = 0, /** 竖向瀑布流 item等宽不等高 */
    LCWaterFlowHorizontalEqualHeight = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图*/
    LCWaterFlowVerticalEqualHeight = 2,  /** 竖向瀑布流 item等高不等宽 */
    LCWaterFlowHorizontalGrid = 3,  /**水平栅格布局  仅供学习交流*/
    LCLineWaterFlow = 4 /** 线性布局 待完成，敬请期待 */
} LCWaterFlowCollectionLayoutStyle; //样式
@class LCWaterFlowCollectionLayout;
@protocol LCWaterFlowCollectionLayoutDelegate <NSObject>

/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为WSLWaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 WSLWaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 WSLWaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 WSLWaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 头视图Size */
-(CGSize )waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )waterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

@optional //以下都有默认值
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout;
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout;

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout;
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout;
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(LCWaterFlowCollectionLayout *)waterFlowLayout;

@end
@interface LCWaterFlowCollectionLayout : UICollectionViewLayout
/** delegate*/
@property (nonatomic, weak) id<LCWaterFlowCollectionLayoutDelegate> delegate;
/** 瀑布流样式*/
@property (nonatomic, assign) LCWaterFlowCollectionLayoutStyle  flowLayoutStyle;
@end

NS_ASSUME_NONNULL_END
