//
//  LCNoDataCollectionViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/5/7.
//

#import "LCBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCNoDataCollectionViewCell : LCBaseCollectionViewCell
@property (nonatomic , copy) NSString *titleStr;
@property (nonatomic , copy) NSString *imgStr;
@property (nonatomic,assign)CGRect customTitleFrame;
@property (nonatomic , strong) UIColor *customBgColor;
//@property (nonatomic , strong) UIImage *customImg;
@property (nonatomic,assign)CGRect customImageFrame;
@end

NS_ASSUME_NONNULL_END
