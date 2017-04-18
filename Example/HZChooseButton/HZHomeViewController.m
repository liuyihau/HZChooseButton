//
//  HZHomeViewController.m
//  HZChooseButton
//
//  Created by LiuYihua on 2017/4/7.
//  Copyright © 2017年 liuyihua2015@sina.com. All rights reserved.
//

#import "HZHomeViewController.h"
#import "ChooseButtonViewController.h"
#import "FunctionMenuView.h"
#import "HZSingletonManager.h"
#import "CustomGrid.h"

@interface HZHomeViewController ()
@property (nonatomic, strong) FunctionMenuView * menuView;
@end

@implementation HZHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self setupFunctionMenuView];
}


-(void)setupFunctionMenuView{

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoveTag" ofType:@"plist"];
    NSMutableArray * arrayM = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    //创建视图并初始化数据源
    self.menuView = [[FunctionMenuView alloc]initWithFrame:CGRectZero gridDateSource:arrayM number:7];
    self.menuView.isHomeView = YES;
    
    NSMutableArray * myGridArray =  [HZSingletonManager shareInstance].myGridArray;
    
    CGFloat cellHeight = [self.menuView createFunctionMenuViewWithHideDeleteIconImage:YES isHomeView:YES  gridListDataSource:myGridArray];
    
    [self.menuView setFrame:CGRectMake(0, 100, self.view.frame.size.width, cellHeight)];
    

    //相关事件处理
    __weak typeof(self) weakSelf = self;
    
    [self.menuView functionMeunViewActionWithAddGridItem:^(CustomGrid *gridItem) {
        
    } getlistViweHeight:^(CGFloat cellHeight, CustomGrid *gridItem, BOOL allGridBtnImageChange) {
        
        [weakSelf.menuView setFrame:CGRectMake(0, 100, weakSelf.view.frame.size.width,cellHeight)];
        
        [weakSelf.view layoutSubviews];
        
    } listViweClick:^(CustomGrid *gridItem) {
        
        NSLog(@"%@",gridItem.name);

    } listViweLongPress:^(CustomGrid *gridItem) {
        
        [weakSelf listViweLongPress];
        
    } loadListViewDataSoruce:^(NSMutableArray *dateSource) {
        
        
    }];
    
    
    [self.view addSubview:self.menuView];

    
    

}

#pragma mark - 长按编辑
-(void)listViweLongPress{

    //1.创建UIAlertController控制器
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"想调整排序?进入全部应用进行编辑吧"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //2.创建按钮
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"去编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
        
        ChooseButtonViewController * chooseButtonVC = [[ChooseButtonViewController alloc]init];
        chooseButtonVC.title = @"全部应用";
        chooseButtonVC.fromEditBtn  = YES;
        chooseButtonVC.func_loadGridListViewDataSoruce = ^(NSMutableArray * dateSource){
            
            [weakSelf.menuView setGridListDataSource:dateSource];
        };
        
        chooseButtonVC.func_listViweClick = ^(CustomGrid *gridItem){
            
            
            NSLog(@"%@",gridItem.name);
            
        };
    
        chooseButtonVC.view.backgroundColor = [UIColor whiteColor];
        [weakSelf.navigationController pushViewController:chooseButtonVC animated:YES];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //4.显示对话框
    [self presentViewController:alertController animated:YES completion:nil];


}


#pragma mark - 全部 点击
- (IBAction)click:(UIBarButtonItem *)sender {
    
    ChooseButtonViewController * chooseButtonVC = [[ChooseButtonViewController alloc]init];
    chooseButtonVC.title = @"全部应用";
    __weak typeof(self) weakSelf = self;
    chooseButtonVC.func_loadGridListViewDataSoruce = ^(NSMutableArray * dateSource){

        
        [weakSelf.menuView setGridListDataSource:dateSource];
        
        
    };
    
    chooseButtonVC.func_listViweClick = ^(CustomGrid *gridItem){
        
        NSLog(@"%@",gridItem.name);
        
    };

    chooseButtonVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:chooseButtonVC animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
