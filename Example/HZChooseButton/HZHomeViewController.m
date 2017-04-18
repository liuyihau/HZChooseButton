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
#import "MJExtension.h"
#import "HZTestViewController.h"

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
    
    if (myGridArray || myGridArray.count == 0) {
        
        myGridArray =  [HZSingletonManager shareInstance].gridDateSource;
        
    }
    
    //添加全部按钮
    NSMutableArray * subArray = [NSMutableArray arrayWithCapacity:8];
    
    if (myGridArray.count >= 7) {
        subArray =  [self add_All_GridItemWithItemCount:7 dateSource:myGridArray];
    }else {
        subArray = [self add_All_GridItemWithItemCount:myGridArray.count dateSource:myGridArray];
    }

    //高度设置
    CGFloat cellHeight = [self.menuView createFunctionMenuViewWithHideDeleteIconImage:YES isHomeView:YES  gridListDataSource:subArray];
    
    [self.menuView setFrame:CGRectMake(0, 100, self.view.frame.size.width, cellHeight)];
    

    //相关事件处理
    __weak typeof(self) weakSelf = self;
    
    [self.menuView functionMeunViewActionWithAddGridItem:^(CustomGrid *gridItem) {
        
    } getlistViweHeight:^(CGFloat cellHeight, CustomGrid *gridItem, BOOL allGridBtnImageChange) {
        
        [weakSelf.menuView setFrame:CGRectMake(0, 100, weakSelf.view.frame.size.width,cellHeight)];
        
        [weakSelf.view layoutSubviews];
        
    } listViweClick:^(CustomGrid *gridItem) {
        
        
        //全部点击
        if ([gridItem.int_id isEqualToNumber:[NSNumber numberWithInt:0]]){
     
            [weakSelf all_clickWithFromEditBtn:NO];
  
        }else{
            
            HZTestViewController * test = [[HZTestViewController alloc]init];
            test.title = gridItem.name;
            test.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:test animated:YES];
    
        
        }

    
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
      
        [weakSelf all_clickWithFromEditBtn:YES];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //4.显示对话框
    [self presentViewController:alertController animated:YES completion:nil];


}


#pragma mark - 全部 点击
- (void)all_clickWithFromEditBtn:(BOOL)fromEditBtn{
    
    ChooseButtonViewController * chooseButtonVC = [[ChooseButtonViewController alloc]init];
    chooseButtonVC.title = @"全部应用";
    chooseButtonVC.fromEditBtn  = fromEditBtn;
    __weak typeof(self) weakSelf = self;
    //全部应用 调整后的block，更新首页的数据列表
    chooseButtonVC.func_loadGridListViewDataSoruce = ^(NSMutableArray * dateSource){

        NSMutableArray * subArray = [NSMutableArray arrayWithCapacity:8];
        if (dateSource.count >= 7) {
            subArray =  [weakSelf add_All_GridItemWithItemCount:7 dateSource:dateSource];
        }else {
           subArray = [weakSelf add_All_GridItemWithItemCount:dateSource.count dateSource:dateSource];
        }
        [weakSelf.menuView setGridListDataSource:subArray];
    };
    
    
    //全部应用中的点击相应事件
    chooseButtonVC.func_listViweClick = ^(CustomGrid *gridItem){
        
        HZTestViewController * test = [[HZTestViewController alloc]init];
        test.title = gridItem.name;
        test.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:test animated:YES];
        
        
    };

    chooseButtonVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:chooseButtonVC animated:YES];

    
}
#pragma mark - 添加了 全部按钮 的模型数组
/**
 返回已添加全部的模型数组

 @param count 需要呈现的个数 最大7个
 @param dateSource 原来的数据源
 */

-(NSMutableArray *)add_All_GridItemWithItemCount:(long int)count dateSource:(NSMutableArray *)dateSource{

    NSMutableArray * subArray = [NSMutableArray arrayWithCapacity:8];
    
    NSArray * array = [dateSource subarrayWithRange:NSMakeRange(0,count)];
    
    subArray = [NSMutableArray arrayWithArray:array];
    
    
    NSDictionary * temp = @{@"name":@"全部",
                            @"image":@"icon_all",
                            @"int_id":@"0",};
    
    CustomGrid * customGrid = [CustomGrid mj_objectWithKeyValues:temp];
    
    
    [subArray addObject:customGrid];

    return subArray;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
