//
//  ChooseButtonViewController.h
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import <UIKit/UIKit.h>

@interface ChooseButtonViewController : UIViewController

@property(nonatomic, strong)NSMutableArray *addGridTitleArray;//接收更多标签页面传过来的值
@property(nonatomic, strong)NSMutableArray *addGridImageArray;//image
@property(nonatomic, strong)NSMutableArray *addGridIDArray;//gridId

@property(nonatomic, strong)NSMutableArray *gridListArray;

@property(nonatomic, strong)NSMutableArray *showGridArray; //title
@property(nonatomic, strong)NSMutableArray *showGridImageArray;//image
@property(nonatomic, strong)NSMutableArray *showGridIDArray;//gridId


//全部应用
@property (nonatomic, strong) NSMutableArray * allGridItemArray;

@property(nonatomic, strong)NSMutableArray *allGridTitleArray;
@property(nonatomic, strong)NSMutableArray *allGridIdArray;
@property(nonatomic, strong)NSMutableArray *allGridImageArray;//image


@end
