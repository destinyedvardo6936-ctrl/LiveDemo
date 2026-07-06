//
//  LCTitleNoticeCell.h
//  LiveDemo
//
//  Created by mrgao on 2022/11/21.
//

#import "LCBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCTitleNoticeCell : LCBaseCollectionViewCell
@property (nonatomic , copy) NSString *titleStr;
@property (nonatomic , strong) UIColor *textColor;
@end

NS_ASSUME_NONNULL_END
