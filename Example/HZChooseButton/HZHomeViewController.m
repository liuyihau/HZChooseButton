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
#import "CustomGridModel.h"

@interface HZHomeViewController ()

@end

@implementation HZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MoveTag" ofType:@"plist"];
    NSMutableArray * arrayM = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    //创建视图并初始化数据源
    FunctionMenuView * menuView = [[FunctionMenuView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) gridDateSource:arrayM number:7];
    
    menuView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:menuView];
    
    
    
}
- (IBAction)click:(UIBarButtonItem *)sender {
    
    ChooseButtonViewController * chooseButtonVC = [[ChooseButtonViewController alloc]init];
    chooseButtonVC.title = @"全部应用";
    chooseButtonVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:chooseButtonVC animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
