//
//  ChooseButtonViewController.m
//  Pods
//
//  Created by LiuYihua on 2017/4/7.
//
//

#import "ChooseButtonViewController.h"
#import "CustomGrid.h"
#import "HZSingletonManager.h"
#import "UIImage+Extension.h"
#import "MJExtension.h"
#import "ChooseButtonConst.h"
#import "FunctionMenuView.h"

@interface ChooseButtonViewController ()<CustomGridDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL contain;
    
    CGFloat first_cell_Hight;
    
    CGFloat all_cell_Hight;
    
    //选中格子的起始位置
    CGPoint startPoint;
    //选中格子的起始坐标位置
    CGPoint originPoint;

}

@property (nonatomic, strong) UIButton           * button;

@property (nonatomic, strong) UITableView        * tableView;

//我的应用 的 gridListView
@property (nonatomic, strong) FunctionMenuView   * gridListView;
//全部的 allGridListView
@property (nonatomic, strong) FunctionMenuView   * allGridListView;

//我的应用 数据源
@property (nonatomic, strong) NSMutableArray     * showGridArray;

//全部应用 数据源
@property (nonatomic, strong) NSMutableArray     * allGridArray;

@end

@implementation ChooseButtonViewController

#pragma mark - 赖加载
#pragma  mark - Properties
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tableView.backgroundColor = UICOLOR_RGB(242, 246, 249);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorColor = UICOLOR_RGB(219, 226, 233);
        _tableView.separatorInset = UIEdgeInsetsMake(0,55, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.sectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
    }
    return _tableView;
}

-(UIButton *)button{
    
    if (!_button) {
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        [_button setTitle:@"编辑" forState:UIControlStateNormal];
        [_button setTitle:@"完成" forState:UIControlStateSelected];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [_button setFrame:CGRectMake(0, 0, 50, 44)];
        
        
    }
    return _button;
}

#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        
        self.showGridArray = [[NSMutableArray alloc] initWithCapacity:16];
        
        self.allGridArray = [[NSMutableArray alloc] initWithCapacity:16];

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
  
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:self.button], nil]];
    
    [self.view addSubview:self.tableView];
    
    [self setupUI];
}


-(void)setupUI{
#pragma mark =============我的应用===============
    self.showGridArray =  [HZSingletonManager shareInstance].myGridArray;
    self.gridListView = [[FunctionMenuView alloc]initWithFrame:CGRectZero gridDateSource:self.showGridArray number:nil];
    first_cell_Hight = [self.gridListView createFunctionMenuViewWithHideDeleteIconImage:NO isHomeView:NO  gridListDataSource:self.showGridArray];
    [self.gridListView setFrame:CGRectMake(0, 0, self.view.frame.size.width, first_cell_Hight)];
 
    __weak typeof(self) weakSelf = self;
    
    self.showGridArray = self.gridListView.gridListDataSource;
    
    
    self.gridListView.getlistViweHeight = ^(CGFloat cellHeight,CustomGrid *gridItem,BOOL allGridBtnImageChange){
        
        first_cell_Hight = cellHeight;
        
        [weakSelf.gridListView setFrame:CGRectMake(0, 0, self.view.frame.size.width,first_cell_Hight)];
        
        if (allGridBtnImageChange) {
            
            [weakSelf.allGridListView setAllGridlistViewGridItemChangeWithSelectGrid:gridItem];

        }
        
        [weakSelf.tableView reloadData];
        
        
    };
    
    //点击事件
    self.gridListView.listViweClick = ^(CustomGrid *gridItem){
        
        NSLog(@"%@",gridItem.name);
        
    };
    
    //长按事件
    self.gridListView.listViweLongPress = ^(CustomGrid *gridItem){
    
    
    
    };
    //拖动结束
    self.gridListView.listViweLongPressGestureStateEnded = ^(CustomGrid *gridItem){
    
    
    
    };
    //拖动位置
    self.gridListView.listViweLongPressGestureStateChanged = ^(CustomGrid *gridItem){
        
        
        
    };


#pragma mark =============全部应用===============
    
    self.allGridArray = [HZSingletonManager shareInstance].gridDateSource;
    self.allGridListView = [[FunctionMenuView alloc]initWithFrame:CGRectZero gridDateSource:self.allGridArray number:nil];
    
    all_cell_Hight = [self.allGridListView createFunctionMenuViewWithHideDeleteIconImage:YES isHomeView:NO  gridListDataSource:self.allGridArray];
    [self.allGridListView setFrame:CGRectMake(0, 0, self.view.frame.size.width, all_cell_Hight)];
    
    self.allGridArray = self.allGridListView.gridListDataSource;
    
    self.allGridListView.addGridItem = ^(CustomGrid *gridItem){
    
        [weakSelf.gridListView addGridItemToMyGridListViewWithselectGrid:gridItem];
        
        weakSelf.showGridArray = weakSelf.gridListView.gridListDataSource;
    
    };
    
    //点击事件
    self.allGridListView.listViweClick = ^(CustomGrid *gridItem){
        
         NSLog(@"%@",gridItem.name);
        
    };
    
    //长按事件
    self.allGridListView.listViweLongPress = ^(CustomGrid *gridItem){
        
        
        
    };
    //拖动结束
    self.allGridListView.listViweLongPressGestureStateEnded = ^(CustomGrid *gridItem){
        
        
        
    };
    //拖动位置
    self.allGridListView.listViweLongPressGestureStateChanged = ^(CustomGrid *gridItem){
        
        
        
    };
}



#pragma mark - 编辑与完成
-(void)editAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;

    [self.gridListView editGridListViewWithPrompthidden:btn.selected isAllGridListView:NO showGridArray:nil];
    [self.allGridListView editGridListViewWithPrompthidden:btn.selected isAllGridListView:YES showGridArray:self.showGridArray];

    
}

#pragma mark - UITabelViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        return first_cell_Hight ? first_cell_Hight : 212;
        
    }else{
        
        return all_cell_Hight ? all_cell_Hight : 212;
        
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = UICOLOR_RGB(242, 246, 249);
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.1;
    }
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"personalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    
    if(indexPath.section == 0){
        
        [cell.contentView  addSubview:self.gridListView];
        
    }else if(indexPath.section == 1){
        [cell.contentView addSubview:self.allGridListView];
           
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

#pragma mark - 可拖动按钮
#pragma mark - 点击格子
- (void)gridItemDidClicked:(CustomGrid *)gridItem
{
    
    NSLog(@"%@",gridItem.int_id);
    
}

#pragma mark - 格子选择操作
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton selectGrid:(CustomGrid *)selectGrid
{
    //删除格子
    if (selectGrid.isChecked && selectGrid.isMove){     
        
        for (NSInteger i = 0; i < self.showGridArray.count; i++) {
            CustomGrid *removeGrid = self.showGridArray[i];
            if (removeGrid.int_id == deleteButton.tag) {
                
                removeGrid.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.4 animations:^{
                    
                    removeGrid.transform = CGAffineTransformMakeScale(0.05, 0.05);
                    removeGrid.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    [removeGrid removeFromSuperview];
                    
                    NSInteger count = self.showGridArray.count - 1;
                    for (NSInteger index = removeGrid.gridIndex; index < count; index++) {
                        CustomGrid *preGrid = self.showGridArray[index];
                        CustomGrid *nextGrid = self.showGridArray[index+1];
                        [UIView animateWithDuration:0.4 animations:^{
                            nextGrid.center = preGrid.gridCenterPoint;
                        }];
                        nextGrid.gridIndex = index;
                    }
                    
                    [self.showGridArray removeObjectAtIndex:removeGrid.gridIndex];
                    
                    //排列格子顺序和更新格子坐标信息
                    [self sortGridList];
                
                    
                    //删除的应用添加到更多应用数组
                    for (CustomGrid * customGridM  in self.showGridArray) {
                        
                        if (customGridM.int_id == selectGrid.int_id) {
                            
                            [self.showGridArray removeObject:customGridM];
                            
                            [self saveArray];
                            
                            break;
                        }
                        
                    }
                    
         
                    for (CustomGrid * allGrid in self.allGridArray) {
                        
                        if ([allGrid.int_id isEqualToNumber:removeGrid.int_id]) {
                            
                            [allGrid setIs_can_add:YES];
                            
                            break;
                            
                        }
                        
                    }
                    
                    //更新页面
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
//                        [self getGridListNewData];
                        
                    });
                    
                    
                }];
            }
            
        }
        
    }
    
    //不能点击的已经设置为 不能使用状态，现在能点击的都可以进行添加
    else{
        
        for (NSInteger i = 0; i < self.allGridArray.count; i++) {
            CustomGrid *removeGrid = self.allGridArray[i];
            if (removeGrid.int_id == deleteButton.tag) {
                
                for (CustomGrid * customGridM  in _allGridArray) {
                    
                    if (customGridM.int_id == selectGrid.int_id) {
                        
                        [self.showGridArray addObject:customGridM];
                    }
                    
                }

    //将已经选中的 Grid 的状态改为不可点击
                for (CustomGrid * allGrid in self.allGridArray) {
                    
                    if ([allGrid.int_id isEqualToNumber:removeGrid.int_id]) {
                        
                        [allGrid setIs_can_add:NO];
                        
                        break;
                        
                    }
                    
                }
                
                
                deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    deleteButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    
                } completion:^(BOOL finished) {
                    
                    //更新页面
//                    [self creatMyScrollViewOnView];
                    
                    [self saveArray];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        
                    } completion:^(BOOL finished) {
                        
                        for (CustomGrid * grid in self.showGridArray) {
                            
                            grid.isChecked = YES;
                            grid.isMove = YES;
                            
                            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.int_id];
                            removeBtn.hidden = NO;
                            
                            grid.isShowBorder = YES;
                            
                        }
                    }];

                    
                }];
                

            }
        }
        
    }
    
}
#pragma mark - 长按格子
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid
{
 
    self.button.selected = YES;
    
    //整个视图可编辑
    for (CustomGrid * grid in self.showGridArray) {
        
        grid.isChecked = YES;
        grid.isMove = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            grid.isShowBorder = YES;
            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.int_id];
            removeBtn.hidden = NO;
            
        }];
        //获取移动格子的起始位置
        startPoint = [longPressGesture locationInView:longPressGesture.view];
        //获取移动格子的起始位置中心点
        originPoint = longPressGesture.view.center;
        
    }
    //整个视图可编辑
    for (CustomGrid * grid in self.allGridArray) {
        
        grid.isChecked = YES;
        grid.isMove = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            grid.isShowBorder = YES;
            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.int_id];
            removeBtn.hidden = NO;
            
        }];
        //获取移动格子的起始位置
        startPoint = [longPressGesture locationInView:longPressGesture.view];
        //获取移动格子的起始位置中心点
        originPoint = longPressGesture.view.center;
        
    }
    
    //判断格子是否已经被选中并且是否可移动状态,如果选中就加一个放大的特效
    if (grid.isChecked) {
        
        grid.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            grid.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        
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
        NSInteger toIndex = [CustomGrid indexOfPoint:gridItem.center withButton:gridItem gridArray:self.showGridArray];
        
        NSInteger borderIndex = [self.showGridArray indexOfObject:@"0"];
        
        if (toIndex < 0 || toIndex >= borderIndex) {
            contain = NO;
        }else{
            //获取移动到目标格子
            CustomGrid *targetGrid = self.showGridArray[toIndex];
            gridItem.center = targetGrid.gridCenterPoint;
            originPoint = targetGrid.gridCenterPoint;
            gridItem.gridIndex = toIndex;
            
            //判断格子的移动方向，是从后往前还是从前往后拖动
            if ((fromIndex - toIndex) > 0) {
                //                NSLog(@"从后往前拖动格子.......");
                //从移动格子的位置开始，始终获取最后一个格子的索引位置
                NSInteger lastGridIndex = fromIndex;
                for (NSInteger i = toIndex; i < fromIndex; i++) {
                    CustomGrid *lastGrid = self.showGridArray[lastGridIndex];
                    CustomGrid *preGrid = self.showGridArray[lastGridIndex-1];
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
                    CustomGrid *topOneGrid = self.showGridArray[i];
                    CustomGrid *nextGrid = self.showGridArray[i+1];
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
#pragma mark - 排列格子顺序和更新格子坐标信息
- (void)sortGridList
{
    //重新排列数组中存放的格子顺序
    [self.showGridArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CustomGrid *tempGrid1 = (CustomGrid *)obj1;
        CustomGrid *tempGrid2 = (CustomGrid *)obj2;
        return tempGrid1.gridIndex > tempGrid2.gridIndex;
    }];
    
    //更新所有格子的中心点坐标信息
    for (NSInteger i = 0; i < self.showGridArray.count; i++) {
        CustomGrid *gridItem = self.showGridArray[i];
        gridItem.gridCenterPoint = gridItem.center;
    }
    
    // 保存更新后数组
    [self saveArray];
}

#pragma mark - 保存更新后数组
-(void)saveArray
{
    
    [HZSingletonManager shareInstance].myGridArray = self.showGridArray;
    
    //归档
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"showGridArray"];
    [NSKeyedArchiver archiveRootObject:self.showGridArray toFile:filePath];
    
    
    _loadGridListViewDataSoruce(self.showGridArray);
}

@end
