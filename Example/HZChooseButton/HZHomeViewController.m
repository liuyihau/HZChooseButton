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
#import "CustomGrid.h"
#import "MJExtension.h"

#import "HZTestViewController.h"

@interface HZHomeViewController ()
@property (nonatomic, strong) FunctionMenuView * menuView;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation HZHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self setupFunctionMenuView];
}


-(void)setupFunctionMenuView{

    //原始数据源
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoveTag" ofType:@"plist"];
    NSMutableArray * arrayM = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];

    //相关事件处理
    __weak typeof(self) weakSelf = self;
    
    //创建视图并初始化数据源
    self.menuView = [[FunctionMenuView alloc] initWithFrame:CGRectZero gridDateSource:arrayM number:7 hideDeleteIconImage:YES isHomeView:YES isAllData:NO getheight:^(CGFloat cellheight) {
        
        weakSelf.cellHeight = cellheight;

    }];

    self.menuView.isHomeView = YES;
    
    //设置Frame
    [self.menuView setFrame:CGRectMake(0, 100, self.view.frame.size.width, self.cellHeight)];
    
    //设置相关事件处理
    [self.menuView functionMeunViewActionWithAddGridItem:^(CustomGrid *gridItem) {}
     
                   getlistViweHeight:^(CGFloat cellHeight, CustomGrid *gridItem, BOOL allGridBtnImageChange) {

                    [weakSelf.menuView setFrame:CGRectMake(0, 100, weakSelf.view.frame.size.width,cellHeight)];
                    
                    [weakSelf.view layoutSubviews];
                   }
                   listViweClick:^(CustomGrid *gridItem) {

                        //"全部"点击
                        if (gridItem.int_id  ==  0){
                     
                            [weakSelf all_clickWithFromEditBtn:NO];
                  
                        }else{//其他按钮点击
                            
                            HZTestViewController * test = [[HZTestViewController alloc]init];
                            test.title = gridItem.name;
                            test.view.backgroundColor = [UIColor whiteColor];
                            [self.navigationController pushViewController:test animated:YES];
                  
                        }

                    }
                   listViweLongPress:^(CustomGrid *gridItem) {
                    //长按
                        [weakSelf listViweLongPress];
                        
                    }
                   loadListViewDataSoruce:^(NSMutableArray *dateSource) {
               
                       
               }
     ];
    
    [self.view addSubview:self.menuView];

    
}

#pragma mark - 首页长按编辑
-(void)listViweLongPress{

    //1.创建UIAlertController控制器
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"想调整排序?进入全部应用进行编辑吧"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //2.创建按钮
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"去编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
      
        [weakSelf all_clickWithFromEditBtn:YES];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //4.显示对话框
    [self presentViewController:alertController animated:YES completion:nil];


}

#pragma mark - "全部" 点击 事件处理
- (void)all_clickWithFromEditBtn:(BOOL)fromEditBtn{
    
    ChooseButtonViewController * chooseButtonVC = [[ChooseButtonViewController alloc]init];

    chooseButtonVC.fromEditBtn  = fromEditBtn;
    __weak typeof(self) weakSelf = self;
    
    //全部应用 调整后的block，更新首页的数据列表
    chooseButtonVC.func_loadGridListViewDataSoruce = ^(NSMutableArray * dateSource){

        [weakSelf.menuView setGridListDataSource:dateSource];
    };
    
#pragma mark - 应用 点击相应事件
    //全部应用 中的 应用 点击相应事件
    chooseButtonVC.func_listViweClick = ^(CustomGrid *gridItem){
        
        HZTestViewController * test = [[HZTestViewController alloc]init];
        test.title = gridItem.name;
        test.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:test animated:YES];
        
        
    };

    chooseButtonVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:chooseButtonVC animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
