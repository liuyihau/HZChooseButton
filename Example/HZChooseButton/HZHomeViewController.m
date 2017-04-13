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


//-(FunctionMenuView *)menuView{
//    
//    if (!_menuView) {
//        
//        _menuView = [[FunctionMenuView alloc]init];
//     
//    }
//    return _menuView;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoveTag" ofType:@"plist"];
    NSMutableArray * arrayM = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    //创建视图并初始化数据源
    self.menuView = [[FunctionMenuView alloc]initWithFrame:CGRectZero gridDateSource:arrayM number:7];
    
    NSMutableArray * myGridArray =  [HZSingletonManager shareInstance].myGridArray;
    
    
    CGFloat cellHeight = [self.menuView createFunctionMenuViewWithHideDeleteIconImage:YES isHomeView:YES  gridListDataSource:myGridArray];
    

    [self.menuView setFrame:CGRectMake(0, 100, self.view.frame.size.width, cellHeight)];

    
    __weak typeof(self) weakSelf = self;
    
    self.menuView.listViweClick = ^(CustomGrid *gridItem){
    
        NSLog(@"%@",gridItem.int_id);
        
    };

    _menuView.listViweLongPress = ^(CustomGrid *gridItem){
    
        //1.创建UIAlertController控制器
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"想调整排序?进入全部应用进行编辑吧"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //2.创建按钮
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];

        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"去编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
 
            ChooseButtonViewController * chooseButtonVC = [[ChooseButtonViewController alloc]init];
            chooseButtonVC.title = @"全部应用";
            chooseButtonVC.loadGridListViewDataSoruce = ^(NSMutableArray * dateSource){
                
                
                
            };
            chooseButtonVC.view.backgroundColor = [UIColor whiteColor];
            [weakSelf.navigationController pushViewController:chooseButtonVC animated:YES];

        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        //4.显示对话框
        [weakSelf presentViewController:alertController animated:YES completion:nil];
        
    
    };
    _menuView.listViweLongPressGestureStateEnded = ^(CustomGrid *gridItem){};
    
    
    [self.view addSubview:_menuView];
    
}



- (IBAction)click:(UIBarButtonItem *)sender {
    
    ChooseButtonViewController * chooseButtonVC = [[ChooseButtonViewController alloc]init];
    chooseButtonVC.title = @"全部应用";
    __weak typeof(self) weakSelf = self;
    chooseButtonVC.loadGridListViewDataSoruce = ^(NSMutableArray * dateSource){

        
        [weakSelf.menuView setGridListDataSource:dateSource];
        
        
    };

    chooseButtonVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:chooseButtonVC animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
