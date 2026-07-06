//
//  QuotaConversionVC.m
//  yunbaolive
//
//  Created by 陶成堂 on 2020/3/26.
//  Copyright © 2020 cat. All rights reserved.
//

#import "QuotaConversionVC.h"

#import "LCQuotaViewModel.h"
#import "LCQuatoBalanceTableViewCell.h"
#import "LCQuotaTableViewCell.h"
@interface QuotaConversionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)LCBaseTableView *mainTableView;

@property (nonatomic,strong)LCQuotaViewModel *viewModel;

@end

@implementation QuotaConversionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
  

   
    
   
    
}
- (void)lc_addSubviews{
    self.view.backgroundColor = RGB(240, 240, 240);
    [self.navView setLeftButtonType:LCBaseNavigationViewLeftType_BlackBack];
    [self.navView setCenterLabelFont:BoldFont(18)];
    [self.navView setCenterLabelTextColor:Color(@"#333333")];
    [self.navView setCenterLabelText:KLanguage(@"额度转换")];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(kNavBarHeight);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(kNavBarHeight);
    }];
}
- (void)lc_bindViewModel{
    @weakify(self)
    [[[self.viewModel.loadDataCommend.executing skip:1] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            self.mainTableView.mj_footer.hidden = YES;
            if (self.mainTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.mainTableView.mj_footer resetNoMoreData];
                
            }
        }else{
            self.mainTableView.mj_footer.hidden = NO;
        }
    }];
//      [[self.viewModel.nextPageCommand.executing takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber * _Nullable x) {
//          @strongify(self)
//          self.isPreloading = x.boolValue;
//    }];
    
    [[self.viewModel.loadDataFinishLoadSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.mainTableView.mj_header.isRefreshing) {
            [self.mainTableView.mj_header endRefreshing];
        }
        if (self.mainTableView.mj_footer.isRefreshing) {
            [self.mainTableView.mj_footer endRefreshing];
        }
//        self.loadingView.hidden = YES;
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
      
        self.mainTableView.hidden = NO;
        
        self.mainTableView.mj_footer.hidden = !self.viewModel.dataArray.count;
        
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView reloadData];
        }];
        
        
    }];

    
    
    [[self.viewModel.noMoreDataSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber  *_Nullable x) {
        @strongify(self)
        if (x.boolValue) {
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    [[self.viewModel.balanceSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        [self.mainTableView reloadData];
        
    }];
//    [[self.viewModel.gameBalanceSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(NSNumber  *_Nullable x) {
//        @strongify(self)
//        if ([x isKindOfClass:[NSError class]]) {
//            NSError *er = x;
//            [SVProgressHUD showErrorWithStatus:er.domain];
//            return;
//        }
//        [self.mainTableView reloadData];
//
//    }];
    [[self.viewModel.gameTransInSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        [SVProgressHUD showMaskViewWithSuccess:x[@"msg"]];
        
    }];
    [[self.viewModel.gameTransOutSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSError class]]) {
            NSError *er = x;
            [SVProgressHUD showErrorWithStatus:er.domain];
            return;
        }
        [SVProgressHUD showMaskViewWithSuccess:x[@"msg"]];
        
    }];
    [self.mainTableView.mj_header beginRefreshing];
    [self.viewModel.balanceCommand execute:@(YES)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count + 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_Width(120);
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kUI_Width(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  WS(weakSelf)
    if (indexPath.section==0) {
        LCQuatoBalanceTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LCQuatoBalanceTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.balance = self.viewModel.balanceStr;
        cell.refreshBlock = ^{
            [weakSelf.mainTableView.mj_header beginRefreshing];
        };
        return cell;
        
        
        
    }
    
        LCQuotaTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LCQuotaTableViewCell"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataModel = self.viewModel.dataArray[indexPath.section - 1];
        cell.selectBalanceBlock = ^(LCQuotaModel * _Nonnull selectModel) {
            [SVProgressHUD show];
            [weakSelf.viewModel.gameBalanceCommand execute:selectModel];
        };
        cell.transInBlock = ^(LCQuotaModel * _Nonnull selectModel) {
            [weakSelf turnInClick:selectModel];
        };
        cell.transOutBlock = ^(LCQuotaModel * _Nonnull selectModel) {
            [weakSelf turnOutClick:selectModel];
        };
        
        return cell;
        

}






//转入
-(void)turnInClick:(LCQuotaModel *)sender{
    WS(weakSelf)
   UIAlertController  *md5AlertController = [UIAlertController alertControllerWithTitle:KLanguage(@"提示") message:KLanguage(@"请输入转入金额") preferredStyle:UIAlertControllerStyleAlert];
    //添加一个取消按钮
    [md5AlertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    }]];
    
    //在AlertView中添加一个输入框
    [md5AlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = KLanguage(@"请输入转入额度");
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [md5AlertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *alertTextField = md5AlertController.textFields.firstObject;
        //输出 检查是否正确无误
        NSLog(@"你输入的文本%@",alertTextField.text);
        [SVProgressHUD show];
        [weakSelf.viewModel.gameTransInCommand execute:[RACTuple tupleWithObjects:sender,alertTextField.text, nil]];
        
        
    }]];
    //present出AlertView
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:md5AlertController animated:true completion:nil];
    });
    
}

//转出
-(void)turnOutClick:(LCQuotaModel *)sender{
    WS(weakSelf)
    UIAlertController  *md5AlertController = [UIAlertController alertControllerWithTitle:KLanguage(@"提示") message:KLanguage(@"请输入转出金额") preferredStyle:UIAlertControllerStyleAlert];
    //添加一个取消按钮
    [md5AlertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    }]];
    
    //在AlertView中添加一个输入框
    [md5AlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = KLanguage(@"请输入转出额度");
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [md5AlertController addAction:[UIAlertAction actionWithTitle:KLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *alertTextField = md5AlertController.textFields.firstObject;
        //输出 检查是否正确无误
        
        [SVProgressHUD show];
        [weakSelf.viewModel.gameTransOutCommand execute:[RACTuple tupleWithObjects:sender,alertTextField.text, nil]];
        
    }]];
    //present出AlertView
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:md5AlertController animated:true completion:nil];
    });
}







#pragma mark---- 懒加载 ----
- (LCBaseTableView *)mainTableView{
    if (_mainTableView == nil){
        LCBaseTableView *tableView = [LCBaseTableView addTableGrouped];
        _mainTableView = tableView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = Color(@"#F7F7F7");
        [self.view addSubview:_mainTableView];
        [_mainTableView registerClass:[LCQuatoBalanceTableViewCell class] forCellReuseIdentifier:@"LCQuatoBalanceTableViewCell"];
        [_mainTableView registerClass:[LCQuotaTableViewCell class] forCellReuseIdentifier:@"LCQuotaTableViewCell"];
       
        WS(weakSelf)
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           
            [weakSelf.viewModel.loadDataCommend execute:@(YES)];
        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
          
                [weakSelf.viewModel.nextPageCommand execute:@(YES)];
            
        }];
        _mainTableView.mj_footer.hidden = YES;
    }
    return _mainTableView;
}
- (LCQuotaViewModel *)viewModel{
    if(_viewModel == nil){
        _viewModel = [LCQuotaViewModel new];
        
    }
    return _viewModel;
}


@end
