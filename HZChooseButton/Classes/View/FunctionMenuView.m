//
//  GitHub: https://github.com/liuyihau/HZChooseButton.git
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
#import "NSBundle+HZChooseButtonExtension.h"
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
        
        _gridListNameLabel = [self createLabelWithText:@"" font:16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
     
    }
    return _gridListNameLabel;
}

-(UILabel *)gridListPromptLabel{
    
    if (!_gridListPromptLabel) {
        
        _gridListPromptLabel = [self createLabelWithText:[NSBundle hz_localizedStringForKey:@"FunctionMenuView.listPromptLabelText"] font:12 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight];
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
        _promptLabel.text = [NSBundle hz_localizedStringForKey:@"FunctionMenuView.promptLabelText"];
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

#pragma mark - 视图相关事件
-(void)functionMeunViewActionWithAddGridItem:(addGridItem)addGridItem getlistViweHeight:(getlistViweHeight)getlistViweHeight listViweClick:(listViweClick)listViweClick listViweLongPress:(listViweLongPress)listViweLongPress loadListViewDataSoruce:(loadListViewDataSoruce)loadListViewDataSoruce{


    self.addGridItem = addGridItem;
    self.getlistViweHeight = getlistViweHeight;
    self.listViweClick = listViweClick;
    self.listViweLongPress = listViweLongPress;
    self.loadListViewDataSoruce = loadListViewDataSoruce;


}

#pragma mark -  编辑及完成操作方法
/**
 编辑及完成操作方法

 @param isPrompthidden 是否隐藏 提示语句
 @param allGridListView 是否是全部应用
 */
-(void)editGridListViewWithPrompthidden:(BOOL)isPrompthidden isAllGridListView:(BOOL)allGridListView showGridArray:(NSMutableArray *)showGridArray animated:(BOOL)animated
{

//  按住拖动调整顺序
    self.gridListPromptLabel.hidden = !isPrompthidden;
    

    //编辑时 全部设置为可点击全部应用中 已经选中的按钮 不可点击
    if (allGridListView){
        
        for (CustomGrid * allGrid in self.gridListArray) {
            
            [allGrid setIs_can_add:YES];
            
            for (CustomGrid * showGrid in showGridArray) {
                
                if (allGrid.int_id  == showGrid.int_id) {

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
            grid.isShowBorder = YES;
            
            if (animated) {
                
                removeBtn.transform = CGAffineTransformMakeScale(0.05, 0.05);
                [UIView animateWithDuration:0.3  animations:^{
                    
                    removeBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    
                }completion:^(BOOL finish){
                    
                }];
            }
            
        }
        
    }else{
        //完成时 全部设置为可点击
        if (allGridListView) {
        
            for (CustomGrid * allGrid in self.gridListArray) {
                
                [allGrid setIs_can_add:YES];
                allGrid.isMove = NO;
            }
            
        }
        
        for (CustomGrid * grid in self.gridListArray) {
            
            grid.isChecked = NO;
            grid.isMove = NO;
            
            if (animated) {
            
                [UIView animateWithDuration:0.3 animations:^{
                    
                    grid.isShowBorder = NO;
                    UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.int_id];
                    removeBtn.hidden = YES;
                    
                }];
            
            
            }else{
            
                grid.isShowBorder = NO;
                UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.int_id];
                removeBtn.hidden = YES;
            
            }
            
            
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
- (id)initWithFrame:(CGRect)frame gridDateSource:(NSMutableArray *)gridDateSource number:(int)number hideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView isAllData:(BOOL)isAllData getheight:(void(^)(CGFloat cellheight))getheight
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
        
            [self createDataWithgridDateSource:gridDateSource number:number hideDeleteIconImage:deleteIconImageHide isHomeView:isHomeView isAllData:isAllData getheight:^(CGFloat cellheight) {
                
                getheight(cellheight);
                
            }];
            
        });
        
    }
    return self;
}

/**
 初始化数据源
 @param gridDateSource 全部数据源  字典数组
 @param number 首页呈现个数
 
 */
-(void)createDataWithgridDateSource:(NSMutableArray *)gridDateSource number:(int)number hideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView isAllData:(BOOL)isAllData getheight:(void(^)(CGFloat cellheight))getheight

{
    
    //所有应用数据 模型数组
    NSMutableArray * arrayModel = [CustomGrid mj_objectArrayWithKeyValuesArray:gridDateSource];
    
    [HZSingletonManager shareInstance].gridDateSource = arrayModel;
    
    
    //我的所有数据
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"showGridArray"];
    NSMutableArray * showGridArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    //添加一个属性，用于记录 用户是否进行过添加和删除按钮，如果有，那就项目一启动就按照用户的选择项目启动，如果没有，默认从总的数据中选择前7个进行呈现
    //获取操作的状态
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    BOOL is_user_make =  [[defaults objectForKey:@"is_user_make"] boolValue];
    
    if (!is_user_make || is_user_make == NO) {
    
        if (!showGridArray || showGridArray.count == 0) {//第一次启动应用，未选择时数据，默认显示前7个应用数据
            
            showGridArray = [NSMutableArray arrayWithCapacity:10];
        
                for (int i = 0; i < number; i++) {
                    
                    [showGridArray addObject:arrayModel[i]];
                    
                }
        }
    }
    //我的应用数据
    [HZSingletonManager shareInstance].myGridArray = showGridArray;
    
    CGFloat cellHeight = 0;
    
    if (isAllData) {
        
      cellHeight =   [self createFunctionMenuViewWithHideDeleteIconImage:deleteIconImageHide isHomeView:isHomeView gridListDataSource:arrayModel];

    }else{
    
      cellHeight =  [self createFunctionMenuViewWithHideDeleteIconImage:deleteIconImageHide isHomeView:isHomeView gridListDataSource:showGridArray];

    }
    
    getheight(cellHeight);
      
}

#pragma mark - 初始化 页面子视图
- (CGFloat)createFunctionMenuViewWithHideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView gridListDataSource:(NSMutableArray *)gridListDataSource
{
    
    
    normalImage = [NSBundle hz_imageNamed:@"app_item_bg"];
    highlightedImage = [NSBundle hz_imageNamed:@"app_item_pressed_bg"];
    
    
    self.gridListNameLabel.frame = CGRectMake(10, 10, (ScreenWidth - 50)/3, 30);
    
    
    
    // 全部应用
    if (deleteIconImageHide) {//全部应用 及 首页应用（首页中需要控制数据源）
        
        deleteIconImage = nil;
        self.gridListNameLabel.text = [NSBundle hz_localizedStringForKey:@"FunctionMenuView.allApplication"];
        
        
    }else{//我的应用
        
        deleteIconImage = [NSBundle hz_imageNamed:@"app_item_plus"];

        self.gridListNameLabel.text = [NSBundle hz_localizedStringForKey:@"FunctionMenuView.myApplication"];
        
        self.gridListPromptLabel.frame = CGRectMake(ScreenWidth/2, 10, ScreenWidth/2 - 10, 30);
        
        [self addSubview:self.gridListNameLabel];
        
    }
    
    [_gridListView removeFromSuperview];
    [self.gridListArray removeAllObjects];
    
    _gridListView = [[UIView alloc]init];
    _gridListView.backgroundColor = [UIColor clearColor];
    
    
    //全部按钮的模型数组
    NSMutableArray * subArray = [NSMutableArray arrayWithCapacity:8];
    
    if (!isHomeView) {
        
        subArray = gridListDataSource;
        
    }else{
        
        self.gridListNameLabel.text = @"";
        
        if (gridListDataSource.count >= 7) {
            
            subArray =  [self add_All_GridItemWithItemCount:7 dateSource:gridListDataSource isAdd:YES];
        }else {
            subArray = [self add_All_GridItemWithItemCount:gridListDataSource.count dateSource:gridListDataSource isAdd:YES];
        }
        
        
    }
    

    for (NSInteger index = 0; index < [subArray count]; index++)
    {
        
        CustomGrid * customGridM = subArray[index];
        
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
    CGFloat height =  [self loadGridListViewWithHideNameLabel:isHomeView gridListDataSource:subArray];
    
    _isHomeView = isHomeView;
    
    
    return height;
    
    
}


#pragma mark - 首页的数据进行刷新重新排序

-(void)setGridListDataSource:(NSMutableArray *)gridListDataSource{

    NSMutableArray * subArray = [NSMutableArray arrayWithCapacity:8];
    if (gridListDataSource.count >= 7) {
        subArray =  [self add_All_GridItemWithItemCount:7 dateSource:gridListDataSource isAdd:NO];
    }else {
        subArray = [self add_All_GridItemWithItemCount:gridListDataSource.count dateSource:gridListDataSource isAdd:NO];
    }

    _gridListDataSource = subArray;
    
    CGFloat cellHeight = [self createFunctionMenuViewWithHideDeleteIconImage:YES isHomeView:YES gridListDataSource:subArray];
    
    
    if (self.getlistViweHeight != nil) {
        
        self.getlistViweHeight(cellHeight,nil,NO);
    }
    

}

#pragma mark - 添加 全部按钮 的模型数组
/**
 返回已添加全部的模型数组
 
 @param count 需要呈现的个数 最大7个
 @param dateSource 原来的数据源
 */

-(NSMutableArray *)add_All_GridItemWithItemCount:(long int)count dateSource:(NSMutableArray *)dateSource isAdd:(BOOL)isAdd{
    
    NSMutableArray * subArray = [NSMutableArray arrayWithCapacity:8];
    
    NSArray * array = [dateSource subarrayWithRange:NSMakeRange(0,count)];
    
    subArray = [NSMutableArray arrayWithArray:array];
    
    
    NSDictionary * temp = @{@"name":@"全部",
                            @"image":@"icon_all",
                            @"int_id":@"0",};
    
    CustomGrid * customGrid = [CustomGrid mj_objectWithKeyValues:temp];
    
    if (isAdd) {
        
         [subArray addObject:customGrid];
    }
    
    return subArray;
    
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
        
        [self.gridListNameLabel removeFromSuperview];
        [self.promptLabel removeFromSuperview];
        
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
    
    if (self.listViweClick != nil) {
        self.listViweClick(gridItem);
    }

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
                    CGFloat height = [self loadGridListViewWithHideNameLabel:NO gridListDataSource:self.gridListArray];
                    
                    if (self.getlistViweHeight != nil) {
                        
                        self.getlistViweHeight(height,removeGrid,YES);
                    }
                
                    
          
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
                    
                    if (allGrid.int_id == removeGrid.int_id) {
                        
                        [allGrid setIs_can_add:NO];
                        
                        break;
                        
                    }
                    
                }
                
                //再添加 属性转换
                if (self.addGridItem != nil) {
                      self.addGridItem(removeGrid);
                }

                //小图标变化
                deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    deleteButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        
                    } completion:^(BOOL finished) {
 
                        
                    }];
                    
                    
                }];
                
                
            }
        }
        
    }
    
}

#pragma mark -  添加item到我的应用中
/**
 添加item到我的应用中

 @param selectGrid 选择的项目
 */
-(void)addGridItemToMyGridListViewWithselectGrid:(CustomGrid *)selectGrid{

    [self layoutSubviews];
    
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
 
    
    if (self.getlistViweHeight != nil) {
        
        self.getlistViweHeight(cellHight,gridItem,NO);
    }


    [self sortGridList];
    
    self.promptLabel.hidden = YES;

}

#pragma mark -  删除我的应用
/**
 我的应用删除，改变全部应用中的某个应用
 
 @param selectGrid 删除的应用信息
 */
-(void)setAllGridlistViewGridItemChangeWithSelectGrid:(CustomGrid *)selectGrid{

    for (CustomGrid * allGrid in self.gridListArray) {

        if (allGrid.int_id  == selectGrid.int_id) {

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

    //保存操作的状态
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"is_user_make"];
    
    
    [HZSingletonManager shareInstance].myGridArray = self.gridListArray;
    
    //归档
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"showGridArray"];
    [NSKeyedArchiver archiveRootObject:self.gridListArray toFile:filePath];
    
    if (self.loadListViewDataSoruce != nil) {
        
        self.loadListViewDataSoruce(self.gridListArray);
        
    }

    
}

#pragma mark - 长按格子
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid
{
  
    if (self.listViweLongPress != nil) {
        
        self.listViweLongPress(grid);
    }
    
    
    if (!_isHomeView) {
        
        //1.获取移动格子的起始位置
        startPoint = [longPressGesture locationInView:longPressGesture.view];
           //获取移动格子的起始位置中心点
        originPoint = longPressGesture.view.center;
        
        //2.改变选择状态
        grid.isChecked = YES;
        
        //3.选中可移动的视图进行偏移5
        if (grid.isMove) {
            //向右下角偏移5
            CGRect frame = grid.frame;
            frame.origin.x += 10;
            frame.origin.y += 10;
            grid.frame = frame;
        }
        

        //4.我的应用中 改为可移动
        for (CustomGrid * gridItem in [HZSingletonManager shareInstance].myGridArray) {
            
            if (gridItem.int_id == grid.int_id) {
                
                grid.isMove = YES;
                
            }
            
        }
        
        //5.选中视图 缩放
        if (grid.isChecked) {
            
            grid.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
            [UIView animateWithDuration:0.3 animations:^{
                
                grid.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
            
        }
    }
    

}
#pragma mark - 拖动位置
- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem
{
    
    if ( gridItem.isChecked && gridItem.isMove) {
        
        [_gridListView bringSubviewToFront:gridItem];
        //应用移动后的X坐标
        CGFloat deltaX = gridPoint.x - startPoint.x;
        //应用移动后的Y坐标
        CGFloat deltaY = gridPoint.y - startPoint.y;
        //拖动的应用跟随手势移动
        gridItem.center = CGPointMake(gridItem.center.x + deltaX, gridItem.center.y + deltaY);
        
        //移动的格子索引下标
        NSInteger fromIndex = gridItem.gridIndex;
        //移动到目标格子的索引下标
        NSInteger toIndex = [CustomGrid indexOfPoint:gridItem.center withButton:gridItem gridArray:self.gridListArray];
        
        NSInteger borderIndex = [self.gridListArray indexOfObject:@"0"];
        
        if (toIndex < 0 || toIndex >= borderIndex) {
            contain = NO;
        }else{
            //获取移动到目标格子
            CustomGrid *targetGrid = self.gridListArray[toIndex];
            gridItem.center = targetGrid.gridCenterPoint;
            originPoint = targetGrid.gridCenterPoint;
            gridItem.gridIndex = toIndex;
            
            //判断格子的移动方向，是从后往前还是从前往后拖动
            if ((fromIndex - toIndex) > 0) {
                //                NSLog(@"从后往前拖动格子.......");
                //从移动格子的位置开始，始终获取最后一个格子的索引位置
                NSInteger lastGridIndex = fromIndex;
                for (NSInteger i = toIndex; i < fromIndex; i++) {
                    CustomGrid *lastGrid = self.gridListArray[lastGridIndex];
                    CustomGrid *preGrid = self.gridListArray[lastGridIndex-1];
                    [UIView animateWithDuration:0.5 animations:^{
                        preGrid.center = lastGrid.gridCenterPoint;
                    }];
                    //实时更新格子的索引下标
                    preGrid.gridIndex = lastGridIndex;
                    lastGridIndex--;
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
                
            }else if((fromIndex - toIndex) < 0){
                //从前往后拖动格子
                //                NSLog(@"从前往后拖动格子.......");
                //从移动格子到目标格子之间的所有格子向前移动一格
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    CustomGrid *topOneGrid = self.gridListArray[i];
                    CustomGrid *nextGrid = self.gridListArray[i+1];
                    //实时更新格子的索引下标
                    nextGrid.gridIndex = i;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextGrid.center = topOneGrid.gridCenterPoint;
                    }];
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
            }
        }
    }

    
}

#pragma mark - 拖动格子结束
- (void)pressGestureStateEnded:(CustomGrid *) gridItem
{
    
    if ( gridItem.isChecked && gridItem.isMove) {
        //撤销格子的放大特效
        [UIView animateWithDuration:0.5 animations:^{
            gridItem.transform = CGAffineTransformIdentity;
            gridItem.alpha = 1.0;
            
            if (!contain) {
                gridItem.center = originPoint;
            }
        }];
        
        //排列格子顺序和更新格子坐标信息
        [self sortGridList];
    }

    
    

}


#pragma mark - layoutSubviews
-(void)layoutSubviews{

    [super layoutSubviews];
     
    [self addSubview:self.gridListNameLabel];
    [self addSubview:self.gridListPromptLabel];
    
    if (_gridListDataSource.count == 0) {
        
        self.promptLabel.hidden = NO;
        
        self.promptLabel.frame = CGRectMake(0, CGRectGetMaxY(self.gridListNameLabel.frame), ScreenWidth, cell_Hight - 40);
        
        [self  addSubview:self.promptLabel];
        
    }else{
     
        [self  addSubview:self.gridListView];
        
    }

}




@end
