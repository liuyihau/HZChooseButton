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
#import "ChooseButtonConst.h"
#import "CustomGrid.h"


@interface FunctionMenuView()<CustomGridDelegate>
{
    BOOL contain;
    
    CGFloat cell_Hight;
    
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
#pragma mark -  编辑及完成操作方法
/**
 编辑及完成操作方法

 @param isPrompthidden 是否隐藏 提示语句
 @param allGridListView 是否是全部应用
 */
-(void)editGridListViewWithPrompthidden:(BOOL)isPrompthidden isAllGridListView:(BOOL)allGridListView showGridArray:(NSMutableArray *)showGridArray
{

//  按住拖动调整顺序
    self.gridListPromptLabel.hidden = !isPrompthidden;
    

    //编辑时 全部设置为可点击全部应用中 已经选中的按钮 不可点击
    if (allGridListView){
        
        for (CustomGrid * allGrid in self.gridListArray) {
            
            [allGrid setIs_can_add:YES];
            
            for (CustomGrid * showGrid in showGridArray) {
                
                if ([allGrid.int_id isEqualToNumber:showGrid.int_id]) {

                    [allGrid setIs_can_add:NO];

                    break;
                    
                }
                
            }
        }
 
     }
    
    if (isPrompthidden) {
        
        for (CustomGrid * grid in self.gridListArray) {
            
            grid.isChecked = YES;
            
            if (allGridListView) {
           
                grid.isMove = NO;
                
            }else{
                
                grid.isMove = YES;
            
            }
    
            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.int_id];
            removeBtn.hidden = NO;
            
            removeBtn.transform = CGAffineTransformMakeScale(0.05, 0.05);
            
            grid.isShowBorder = YES;
            
            [UIView animateWithDuration:0.3  animations:^{
                
                removeBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            }completion:^(BOOL finish){
                
                
                
            }];
            
        }
        
    }else{
        //完成时 全部设置为可点击
        if (allGridListView) {
        
            for (CustomGrid * allGrid in self.gridListArray) {
                
                [allGrid setIs_can_add:YES];
            }
            
        }
        
        for (CustomGrid * grid in self.gridListArray) {
            
            grid.isChecked = NO;
            grid.isMove = NO;
            [UIView animateWithDuration:0.3 animations:^{
                
                grid.isShowBorder = NO;
                UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.int_id];
                removeBtn.hidden = YES;
                
            }];
            
        }
        
    }
    

}



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
    NSMutableArray * arrayModel = [CustomGrid mj_objectArrayWithKeyValuesArray:gridDateSource];
    
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
- (CGFloat)createFunctionMenuViewWithHideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView gridListDataSource:(NSMutableArray *)gridListDataSource
{
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    
    normalImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_bg@2x.png"];
    highlightedImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_pressed_bg@2x.png"];
    

    self.gridListNameLabel.frame = CGRectMake(10, 10, (ScreenWidth - 50)/4, 30);
//    全部应用
    if (deleteIconImageHide) {//全部应用 及 首页应用（首页中需要控制数据源）
        
           deleteIconImage = nil;
           self.gridListNameLabel.text = @"全部应用";
        
    }else{//我的应用
    
            deleteIconImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_plus@2x.png"];
  
            self.gridListNameLabel.text = @"我的应用";
        
            self.gridListPromptLabel.frame = CGRectMake(ScreenWidth/2 + 12, 10, ScreenWidth/2 - 24, 30);
        
            [self addSubview:self.gridListNameLabel];
      
    }
    [_gridListView removeFromSuperview];
    [self.gridListArray removeAllObjects];
    
    _gridListView = [[UIView alloc]init];
    _gridListView.backgroundColor = [UIColor clearColor];

    
    for (NSInteger index = 0; index < [gridListDataSource count]; index++)
    {
        
        CustomGrid * customGridM = gridListDataSource[index];
        
        BOOL isAddDelete = YES;
        if ([customGridM.name isEqualToString:@"全部"]) {
            isAddDelete = NO;
        }
        
        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero normalImage:normalImage highlightedImage:highlightedImage atIndex:index isAddDelete:isAddDelete deleteIcon:deleteIconImage withCustomGridModel:customGridM];
        
        gridItem.delegate = self;
        gridItem.name = customGridM.name;
        gridItem.image = customGridM.image;
        gridItem.int_id = customGridM.int_id;
        
        [self.gridListView addSubview:gridItem];
        [self.gridListArray addObject:gridItem];
        
        gridItem.gridCenterPoint = gridItem.center;
        
    }
    

    
    //更新页面
    CGFloat cellHeight =  [self loadGridListViewWithHideNameLabel:isHomeView gridListDataSource:gridListDataSource];
    
    return cell_Hight;
    
    
}

#pragma mark - 更新页面
-(CGFloat)loadGridListViewWithHideNameLabel:(BOOL)hideNameLabel gridListDataSource:(NSMutableArray *)gridListDataSource

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
        
        cell_Hight = gridHeight;
        
    }else{
    
        [_gridListView setFrame:CGRectMake(0, CGRectGetMaxY(self.gridListNameLabel.frame) , ScreenWidth, gridHeight)];
        
        
        if (gridListDataSource.count < 4) {
            gridHeight = ((ScreenWidth-50)/4  + 10) + gridListDataSource.count/4 + 10;
        }
        
        cell_Hight = gridHeight + 40;
    }
    
    return cell_Hight;
    
}
#pragma mark - 可拖动按钮
#pragma mark - 点击格子
- (void)gridItemDidClicked:(CustomGrid *)gridItem
{
    _listViweClick(gridItem);
}

#pragma mark - 格子选择操作
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton selectGrid:(CustomGrid *)selectGrid
{
    //删除格子
    if (selectGrid.isChecked && selectGrid.isMove){
        
        for (NSInteger i = 0; i < self.gridListArray.count; i++) {
            CustomGrid *removeGrid = self.gridListArray[i];
            if (removeGrid.int_id == deleteButton.tag) {
                
                removeGrid.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.4 animations:^{
                    
                    removeGrid.transform = CGAffineTransformMakeScale(0.05, 0.05);
                    removeGrid.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    [removeGrid removeFromSuperview];
                    
                    NSInteger count = self.gridListArray.count - 1;
                    for (NSInteger index = removeGrid.gridIndex; index < count; index++) {
                        CustomGrid *preGrid = self.gridListArray[index];
                        CustomGrid *nextGrid = self.gridListArray[index+1];
                        [UIView animateWithDuration:0.4 animations:^{
                            nextGrid.center = preGrid.gridCenterPoint;
                        }];
                        nextGrid.gridIndex = index;
                    }
                    
                    [self.gridListArray removeObjectAtIndex:removeGrid.gridIndex];
                    
                    //排列格子顺序和更新格子坐标信息
                    [self sortGridList];
                    
                    
                    //删除的应用添加到更多应用数组
                    for (CustomGrid * customGridM  in self.gridListArray) {
                        
                        if (customGridM.int_id == selectGrid.int_id) {
                            
                            [self.gridListArray removeObject:customGridM];
                            
                            [self saveArray];
                            
                            break;
                        }
                        
                    }
                    
                    
                    //更新页面
                    CGFloat cell_Hight = [self loadGridListViewWithHideNameLabel:NO gridListDataSource:self.gridListArray];
                    
                    _getlistViweHeight(cell_Hight,removeGrid,YES);
                    
          
                }];
            }
            
        }
        
    }
    
    //不能点击的已经设置为 不能使用状态，现在能点击的都可以进行添加
    else{
        
        for (NSInteger i = 0; i < self.gridListArray.count; i++) {
            CustomGrid *removeGrid = self.gridListArray[i];
            if (removeGrid.int_id == deleteButton.tag) {
                
              //将已经选中的 Grid 的状态改为不可点击
                for (CustomGrid * allGrid in self.gridListArray) {
                    
                    if ([allGrid.int_id isEqualToNumber:removeGrid.int_id]) {
                        
                        [allGrid setIs_can_add:NO];
                        
                        break;
                        
                    }
                    
                }
                
                
                deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    deleteButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        
                    } completion:^(BOOL finished) {
 
//                        [self.gridListArray removeObject:removeGrid];
                        [HZSingletonManager shareInstance].gridDateSource = self.gridListArray;
                        
                        //属性转换
                        _addGridItem(removeGrid);
                        
                    }];
                    
                    
                }];
                
                
            }
        }
        
    }
    
}

/**
 添加item到我的应用中

 @param selectGrid 选择的项目
 */
-(void)addGridItemToMyGridListViewWithselectGrid:(CustomGrid *)selectGrid{

    CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero normalImage:normalImage highlightedImage:highlightedImage atIndex:self.gridListArray.count isAddDelete:YES deleteIcon:deleteIconImage withCustomGridModel:selectGrid];
    
    gridItem.delegate = self;
    gridItem.name = selectGrid.name;
    gridItem.image = selectGrid.image;
    gridItem.int_id = selectGrid.int_id;
    gridItem.isChecked = YES;
    gridItem.isMove = YES;
    gridItem.isShowBorder = YES;
    UIButton *gridBtn = (UIButton *)[gridItem viewWithTag:gridItem.int_id];
    gridBtn.hidden = NO;
   
    [self.gridListView addSubview:gridItem];
    [self.gridListArray addObject:gridItem];
    
    gridItem.gridCenterPoint = gridItem.center;
    
    CGFloat cellHight =  [self loadGridListViewWithHideNameLabel:NO gridListDataSource:self.gridListArray];
 
    _getlistViweHeight(cellHight,gridItem,NO);

    [self sortGridList];

}

/**
 我的应用删除，改变全部应用中的某个应用
 
 @param selectGrid 删除的应用信息
 */
-(void)setAllGridlistViewGridItemChangeWithSelectGrid:(CustomGrid *)selectGrid{

    for (CustomGrid * allGrid in self.gridListArray) {

        if ([allGrid.int_id isEqualToNumber:selectGrid.int_id]) {

            [allGrid setIs_can_add:YES];

            break;

        }

    }

}


#pragma mark - 排列格子顺序和更新格子坐标信息
- (void)sortGridList
{
    //重新排列数组中存放的格子顺序
    [self.gridListArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CustomGrid *tempGrid1 = (CustomGrid *)obj1;
        CustomGrid *tempGrid2 = (CustomGrid *)obj2;
        return tempGrid1.gridIndex > tempGrid2.gridIndex;
    }];
    
    //更新所有格子的中心点坐标信息
    for (NSInteger i = 0; i < self.gridListArray.count; i++) {
        CustomGrid *gridItem = self.gridListArray[i];
        gridItem.gridCenterPoint = gridItem.center;
    }
    
    // 保存更新后数组
    [self saveArray];
}

#pragma mark - 保存更新后数组
-(void)saveArray
{
    
    [HZSingletonManager shareInstance].myGridArray = self.gridListArray;
    
    //归档
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"showGridArray"];
    [NSKeyedArchiver archiveRootObject:self.gridListArray toFile:filePath];
    
//    _loadGridListViewDataSoruce(self.gridListArray);
}



#pragma mark - 长按格子
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid
{
    
    _listViweLongPress(grid);
    
}
#pragma mark - 拖动位置
- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem
{
    _listViweLongPressGestureStateChanged(gridItem);
}

#pragma mark - 拖动格子结束
- (void)pressGestureStateEnded:(CustomGrid *) gridItem
{
    _listViweLongPressGestureStateEnded(gridItem);

}


#pragma mark - layoutSubviews
-(void)layoutSubviews{

    [super layoutSubviews];
     
    [self addSubview:self.gridListNameLabel];
    [self addSubview:self.gridListPromptLabel];
    
    if (_gridListDataSource.count == 0) {
        
        self.promptLabel.frame = CGRectMake(0, CGRectGetMaxY(self.gridListNameLabel.frame), ScreenWidth, cell_Hight - 40);
        [self  addSubview:self.promptLabel];
        
    }else{
        
        [self  addSubview:self.gridListView];
        
    }

}




@end
