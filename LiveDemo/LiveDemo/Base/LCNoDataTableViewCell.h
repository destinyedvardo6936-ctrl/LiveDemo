//
//  LCNoDataTableViewCell.h
//  LiveDemo
//
//  Created by mrgao on 2023/3/17.
//

#import "LCBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCNoDataTableViewCell : LCBaseTableViewCell
@property (nonatomic , copy) NSString *titleStr;
@property (nonatomic , copy) NSString *imgStr;
@property (nonatomic,assign)CGRect customTitleFrame;
@property (nonatomic , strong) UIColor *customBgColor;
//@property (nonatomic , strong) UIImage *customImg;
@property (nonatomic,assign)CGRect customImageFrame;
@end

NS_ASSUME_NONNULL_END
