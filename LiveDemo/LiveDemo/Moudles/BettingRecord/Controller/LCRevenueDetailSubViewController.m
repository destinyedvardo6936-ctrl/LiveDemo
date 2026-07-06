//
//  LCRevenueDetailSubViewController.m
//  LiveDemo
//
//  Created by mrgao on 2023/2/15.
//

#import "LCRevenueDetailSubViewController.h"

@interface LCRevenueDetailSubViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) LCBaseTableView *mainTableView;

@property (nonatomic, copy) void (^scrollBlock)(UIScrollView *scrollView);

//@property (nonatomic , strong) LCActivityListViewModel *viewModel;

@end

@implementation LCRevenueDetailSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark---- JXPagerViewListViewDelegate ----
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.mainTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollBlock = callback;
}

- (void)listScrollViewWillResetContentOffset {
    //当前的listScrollView需要重置的时候，就把所有列表的contentOffset都重置了
    self.mainTableView.contentOffset = CGPointZero;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
