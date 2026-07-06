//
//  ChessCardWebVC.h
//  yunbaolive
//
//  Created by 陶成堂 on 2020/5/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "LCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChessCardWebVC : LCBaseViewController
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *push;
@property (nonatomic , copy) NSString *coin;
@property (nonatomic,copy)NSString *biaoshi;
@end

NS_ASSUME_NONNULL_END
