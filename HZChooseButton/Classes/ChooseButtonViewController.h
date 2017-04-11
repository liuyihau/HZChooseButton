//
//  ChooseButtonViewController.h
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import <UIKit/UIKit.h>

typedef void (^chooseButtonDataSource)(NSMutableArray * choosebuttonDateSource);

@interface ChooseButtonViewController : UIViewController

//我的应用
@property (nonatomic, strong) NSMutableArray * gridListArray;
@property (nonatomic, strong) NSMutableArray * showGridArray;

//全部应用
@property (nonatomic, strong) NSMutableArray * allGridItemArray;
@property (nonatomic, strong) NSMutableArray * allGridArray;

//所有按钮数据
@property (nonatomic, strong) chooseButtonDataSource  chooseButtonDataSource;


@end
