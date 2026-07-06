//
//  LCLiveEnterRoomView.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/27.
//

#import "LCLiveEnterRoomView.h"
//#import <SDCycleScrollView.h>
#import "LCLiveUserEnterCollectionCell.h"

@interface LCLiveEnterRoomView ()<UITableViewDelegate,UITableViewDataSource>{
    dispatch_source_t _timer;
}
@property (nonatomic , weak) LCBaseTableView *mainTableView;
//@property (nonatomic , weak) SDCycleScrollView *mainScrollView;
@property (nonatomic , strong) NSMutableArray *dataArr;
@end
@implementation LCLiveEnterRoomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}

//- (void)setDataArray:(NSArray *)dataArray{
//    _dataArray = dataArray;
//    [self.mainTableView reloadData ];
//    if(_dataArray.count){
//        if(_timer){
//            dispatch_cancel(_timer);
//            _timer = nil;
//        }
//        WS(weakSelf)
//        [self.mainTableView layoutIfNeeded];
//
//        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0,0));
//        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
//        dispatch_source_set_event_handler(_timer, ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(weakSelf.mainTableView.contentOffset.y > kUI_Width(12) * (weakSelf.dataArray.count - 1) ){
//                    [weakSelf cancelTimer];
////                    [weakSelf.mainTableView setContentOffset:CGPointZero animated:YES];
//                }else{
//                    [weakSelf.mainTableView setContentOffset:CGPointMake(0, weakSelf.mainTableView.contentOffset.y + kUI_Width(12)) animated:YES];
//                }
//
//            });
//        });
//        dispatch_resume(_timer);
//    }
//}
- (void)addUsers:(NSArray *)arr{
    [self.dataArr addObjectsFromArray:arr];
    [UIView animateWithDuration:0 animations:^{
        [self.mainTableView reloadData];
    }];
    if(_timer){
        
    }else{
        WS(weakSelf)
        [self.mainTableView layoutIfNeeded];

        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0,0));
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(weakSelf.mainTableView.contentOffset.y > kUI_Width(12) * (weakSelf.dataArr.count - 1) ){
                    [weakSelf cancelTimer];
//                    [weakSelf.mainTableView setContentOffset:CGPointZero animated:YES];
                }else{
                    [UIView animateWithDuration:1.5 animations:^{
                        weakSelf.mainTableView.contentOffset = CGPointMake(0, weakSelf.mainTableView.contentOffset.y + kUI_Width(12));
//                        [weakSelf.mainTableView setContentOffset:CGPointMake(0, weakSelf.mainTableView.contentOffset.y + kUI_Width(12)) animated:YES];
                    }];
                    
                }

            });
        });
        dispatch_resume(_timer);
    }
}
- (void)stopAnim{
    [self cancelTimer];
    
}
- (void)cancelTimer{
    if(_timer){
        dispatch_cancel(_timer);
        _timer = nil;
    }
    [self.dataArr removeAllObjects];
    [UIView animateWithDuration:0 animations:^{
        [self.mainTableView reloadData];
    }];
}
- (void)dealloc{
    if(_timer){
        dispatch_cancel(_timer);
        _timer = nil;
    }
}
#pragma mark----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_Width(12);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCLiveUserEnterCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCLiveUserEnterCollectionCell"];
    cell.backgroundColor = tableView.backgroundColor;
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.dataModel = self.dataArr[indexPath.section];
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark---- 懒加载 ----
- (NSMutableArray *)dataArr{
    if(_dataArr == nil){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (LCBaseTableView *)mainTableView{
    if(!_mainTableView){
        LCBaseTableView *tableView = [LCBaseTableView addTableGrouped];
        _mainTableView = tableView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
       
        _mainTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainTableView];
        [_mainTableView registerClass:[LCLiveUserEnterCollectionCell class] forCellReuseIdentifier:@"LCLiveUserEnterCollectionCell"];
       

    }
    return _mainTableView;
}


@end
