//
//  HZHomeViewController.m
//  HZChooseButton
//
//  Created by LiuYihua on 2017/4/7.
//  Copyright © 2017年 liuyihua2015@sina.com. All rights reserved.
//

#import "HZHomeViewController.h"
#import "ChooseButtonViewController.h"

@interface HZHomeViewController ()

@end

@implementation HZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
