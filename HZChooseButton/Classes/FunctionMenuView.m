//
//  FunctionMenuView.m
//  Pods
//
//  Created by LiuYihua on 2017/4/11.
//
//

#import "FunctionMenuView.h"
#import "ChooseButtonViewController.h"
#import "HZSingletonManager.h"
#import "MJExtension.h"
#import "UIImage+Extension.h"
#import "CustomGridModel.h"
#import "ChooseButtonConst.h"
#import "CustomGrid.h"


@interface FunctionMenuView()<CustomGridDelegate>
{
    BOOL contain;
    
    CGFloat first_cell_Hight;
    
    //选中格子的起始位置
    CGPoint startPoint;
    //选中格子的起始坐标位置
    CGPoint originPoint;
    
    UIImage *normalImage;
    UIImage *highlightedImage;
    UIImage *deleteIconImage;
}

/**应用类型名称*/
@property (nonatomic, strong) UILabel        * gridListNameLabel;
/**按住拖动调整顺序*/
@property (nonatomic, strong) UILabel        * gridListPromptLabel;
/**您还未添加任何应用\n长按下面的应用可以添加*/
@property (nonatomic, strong) UILabel        * promptLabel;

//视图 数组
@property (nonatomic, strong) NSMutableArray * gridListArray;
/**功能菜单视图*/
@property (nonatomic, strong) UIView         * gridListView;

@end

@implementation FunctionMenuView

#pragma mark - 赖加载
-(UILabel *)gridListNameLabel{
    
    if (!_gridListNameLabel) {
        
        _gridListNameLabel = [self createLabelWithText:@"" font:16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
     
    }
    return _gridListNameLabel;
}

-(UILabel *)gridListPromptLabel{
    
    if (!_gridListPromptLabel) {
        
        _gridListPromptLabel = [self createLabelWithText:@"按住拖动调整顺序" font:12 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight];
        _gridListPromptLabel.hidden = YES;
        
    }
    return _gridListPromptLabel;
}

-(UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment{
    
    UILabel * label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    
    return label;
    
}

-(UILabel *)promptLabel{
    
    if (!_promptLabel) {
        
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.text = @"您还未添加任何应用\n长按下面的应用可以添加";
        _promptLabel.textColor = [UIColor lightGrayColor];
        _promptLabel.font = [UIFont systemFontOfSize:13];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.numberOfLines = 2;
        
    }
    return _promptLabel;
}


-(NSMutableArray *)gridListArray{
    
    if (!_gridListArray) {
        
        _gridListArray = [[NSMutableArray alloc] initWithCapacity:16];
        
    }
    return _gridListArray;
}
///**
// lazy- gridListView
// */
//-(UIView *)gridListView{
//    
//    if (!_gridListView) {
//        
//        _gridListView = [[UIView alloc]init];
//    
//    }
//    return _gridListView;
//}

#pragma mark - init

/**
 创建视图并初始化数据源

 @param frame frame
 @param gridDateSource 全部数据源
 @param number 首页呈现个数
 @return 首页呈现数图
 */
- (id)initWithFrame:(CGRect)frame gridDateSource:(NSMutableArray *)gridDateSource number:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            [self createDataWithgridDateSource:gridDateSource number:number];
            
        });
        
    }
    return self;
}

/**
 初始化数据源
 @param gridDateSource 全部数据源
 @param number 首页呈现个数
 
 */
-(void)createDataWithgridDateSource:(NSMutableArray *)gridDateSource number:(int)number
{
    
    //所有应用数据
    NSMutableArray * arrayModel = [CustomGridModel mj_objectArrayWithKeyValuesArray:gridDateSource];
    
    [HZSingletonManager shareInstance].gridDateSource = arrayModel;
    
    
    //我的所有数据
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"showGridArray"];
    NSMutableArray * showGridArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!showGridArray || showGridArray.count == 0) {//第一次启动应用，未选择时数据，默认显示前7个应用数据
        
        showGridArray = [NSMutableArray arrayWithCapacity:10];
        
        for (int i = 0; i < number; i++) {
            
            [showGridArray addObject:arrayModel[i]];
            
        }
    }
    
    //我的应用数据
    [HZSingletonManager shareInstance].myGridArray = showGridArray;
    
    
}

-(void)setGridListDataSource:(NSMutableArray *)gridListDataSource{

    _gridListDataSource = gridListDataSource;


    NSLog(@"%d",gridListDataSource.count);
    
    [self createFunctionMenuViewWithHideDeleteIconImage:YES isHomeView:YES gridListDataSource:gridListDataSource];
    

}


#pragma mark - 初始化 页面子视图
- (void)createFunctionMenuViewWithHideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView gridListDataSource:(NSMutableArray *)gridListDataSource
{
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    
    normalImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_bg@2x.png"];
    highlightedImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_pressed_bg@2x.png"];
    
    //我的应用
    self.gridListNameLabel.frame = CGRectMake(10, 10, (ScreenWidth - 50)/4, 30);
    
    if (deleteIconImageHide) {//全部应用 及 首页应用（首页中需要控制数据源）
        
           deleteIconImage = nil;
           self.gridListNameLabel.text = @"我的应用";
        
    }else{//我的应用
    
            deleteIconImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_plus@2x.png"];
  
            self.gridListNameLabel.text = @"全部应用";
        
            self.gridListPromptLabel.frame = CGRectMake(ScreenWidth/2 + 12, 10, ScreenWidth/2 - 24, 30);
      
    }
    [_gridListView removeFromSuperview];
    [self.gridListArray removeAllObjects];
    
    _gridListView = [[UIView alloc]init];
    _gridListView.backgroundColor = [UIColor clearColor];

    
    for (NSInteger index = 0; index < [gridListDataSource count]; index++)
    {
        
        CustomGridModel * customGridM = gridListDataSource[index];
        
        BOOL isAddDelete = YES;
        if ([customGridM.name isEqualToString:@"全部"]) {
            isAddDelete = NO;
        }
        
        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero normalImage:normalImage highlightedImage:highlightedImage atIndex:index isAddDelete:isAddDelete deleteIcon:deleteIconImage withCustomGridModel:customGridM];
        
        gridItem.delegate = self;
        gridItem.gridTitle = customGridM.name;
        gridItem.gridImageString = customGridM.image;
        gridItem.gridId = customGridM.int_id;
        
        [self.gridListView addSubview:gridItem];
        [self.gridListArray addObject:gridItem];
        
    }
    
    for (CustomGrid *gridItem in self.gridListArray) {
        
        gridItem.gridCenterPoint = gridItem.center;
        
    }
    
    //更新页面
    [self loadGridListViewWithHideNameLabel:isHomeView gridListDataSource:gridListDataSource];
    
    
}

#pragma mark - 更新页面
-(void)loadGridListViewWithHideNameLabel:(BOOL)hideNameLabel gridListDataSource:(NSMutableArray *)gridListDataSource

{
    _gridListDataSource = gridListDataSource;
    
    NSInteger gridHeight;
    if (gridListDataSource.count % 4 == 0) {
        gridHeight = ((ScreenWidth-50)/4  + 10) * gridListDataSource.count/4 + 10;
    }
    else{
        gridHeight = ((ScreenWidth-50)/4  + 10) * (gridListDataSource.count/4+1) + 10;
    }
    
    if (gridListDataSource.count == 0) {
        
        gridHeight -= 5;
    }
    
    if (hideNameLabel) {//在首页显示时，不需要显示 nameLabel
        
        self.gridListNameLabel.text = @"";
        
        [_gridListView setFrame:CGRectMake(0,0, ScreenWidth, gridHeight)];

        if (gridListDataSource.count < 4) {
            
            gridHeight = ((ScreenWidth-50)/4  + 10) + gridListDataSource.count/4 + 10;
        }
        
        first_cell_Hight = gridHeight;
        
    }else{
    
        [_gridListView setFrame:CGRectMake(0, CGRectGetMaxY(self.gridListNameLabel.frame) , ScreenWidth, gridHeight)];
        
        
        if (gridListDataSource.count < 4) {
            gridHeight = ((ScreenWidth-50)/4  + 10) + gridListDataSource.count/4 + 10;
        }
        
        first_cell_Hight = gridHeight + 40;
    }
#warning todo... 高度设置
    
    
    
}
#pragma mark - 可拖动按钮
#pragma mark - 点击格子
- (void)gridItemDidClicked:(CustomGrid *)gridItem
{
    _listViweClick(gridItem);
}
#pragma mark - 长按格子
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid
{
    
    _listViweLongPress();
    
}
#pragma mark - 拖动位置
- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem
{
    NSLog(@"3333333");
}

#pragma mark - 拖动格子结束
- (void)pressGestureStateEnded:(CustomGrid *) gridItem
{
    NSLog(@"22222222");

}

-(void)layoutSubviews{

    [super layoutSubviews];
     
    [self addSubview:self.gridListNameLabel];
    [self addSubview:self.gridListPromptLabel];
    
    if (_gridListDataSource.count == 0) {
        
        self.promptLabel.frame = CGRectMake(0, CGRectGetMaxY(self.gridListNameLabel.frame), ScreenWidth, first_cell_Hight - 40);
        [self  addSubview:self.promptLabel];
        
    }else{
        
        [self  addSubview:self.gridListView];
        
    }

}




@end
