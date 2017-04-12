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
#import "CustomGridModel.h"
#import "MJExtension.h"

#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"========<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif

#define UICOLOR_RGB(R,G,B)                  ([UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1])

@interface ChooseButtonViewController ()<CustomGridDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL contain;
    
    CGFloat first_cell_Hight;
    
    CGFloat more_cell_Hight;
    
    //选中格子的起始位置
    CGPoint startPoint;
    //选中格子的起始坐标位置
    CGPoint originPoint;
    
    UIImage *normalImage;
    UIImage *highlightedImage;
    UIImage *deleteIconImage;
}

@property (nonatomic, strong) UIButton       * button;

/**我的应用*/
@property (nonatomic, strong) UILabel        * gridListNameLabel;
/**提示：按住拖动调整顺序*/
@property (nonatomic, strong) UILabel        * gridListPromptLabel;
/**全部应用*/
@property (nonatomic, strong) UILabel        * allGridListLabel;

@property (nonatomic, strong) UITableView    * tableView;

//我的应用 的 gridListView
@property (nonatomic, strong) UIView         * gridListView;
//全部的 showMoreGridView
@property (nonatomic, strong) UIView         * showMoreGridView;

@property (nonatomic, strong) UILabel        * promptLabel;



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

-(UILabel *)gridListNameLabel{
    
    if (!_gridListNameLabel) {
        
        _gridListNameLabel = [self createLabelWithText:@"我的应用" font:16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        
        
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

-(UILabel *)allGridListLabel{
    
    if (!_allGridListLabel) {
        
        _allGridListLabel = [self createLabelWithText:@"全部应用" font:16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        
    }
    return _allGridListLabel;
    
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



#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        
        self.gridListArray = [[NSMutableArray alloc] initWithCapacity:16];
        
        self.showGridArray = [[NSMutableArray alloc] initWithCapacity:16];
        
        self.allGridItemArray = [[NSMutableArray alloc] initWithCapacity:16];
        
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
    

    //我的应用
    self.showGridArray =  [HZSingletonManager shareInstance].myGridArray;
    [self creatMyScrollViewOnView];
    
    //全部应用
    self.allGridArray = [HZSingletonManager shareInstance].gridDateSource;
    [self drawMoreGridView];
   
}


#pragma mark - 初始化 我的应用
- (void)creatMyScrollViewOnView
{
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    
    normalImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_bg@2x.png"];
    highlightedImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_pressed_bg@2x.png"];
    deleteIconImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_plus@2x.png"];
    
    //我的应用
    self.gridListNameLabel.frame = CGRectMake(10, 10, (ScreenWidth - 50)/4, 30);
    
    self.gridListPromptLabel.frame = CGRectMake(ScreenWidth/2 + 12, 10, ScreenWidth/2 - 24, 30);
    
    //_gridListView
    _gridListView = [[UIView alloc] init];
    
    [_gridListView setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.gridListArray removeAllObjects];
    
    for (NSInteger index = 0; index < [self.showGridArray count]; index++)
    {
        
        CustomGridModel * customGridM = self.showGridArray[index];
        
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
    [self getGridListNewData];
    
    
}

#pragma mark - 更新页面
-(void)getGridListNewData
{
    NSInteger gridHeight;
    if (self.showGridArray.count % 4 == 0) {
        gridHeight = ((ScreenWidth-50)/4  + 10) * self.showGridArray.count/4 + 10;
    }
    else{
        gridHeight = ((ScreenWidth-50)/4  + 10) * (self.showGridArray.count/4+1) + 10;
    }
    
    if (self.showGridArray.count == 0) {
        
        gridHeight -= 5;
    }
    
    [_gridListView setFrame:CGRectMake(0, CGRectGetMaxY(self.gridListNameLabel.frame) , ScreenWidth, gridHeight)];
    
    
    if (self.showGridArray.count < 4) {
        gridHeight = ((ScreenWidth-50)/4  + 10) + self.showGridArray.count/4 + 10;
    }
    
    
    first_cell_Hight = gridHeight + 40;
  
    
    [self.tableView reloadData];
    
    
}


#pragma mark - 全部应用

- (void)drawMoreGridView
{
    
    //我的应用
    self.allGridListLabel.frame = CGRectMake(10, 10, (ScreenWidth - 50)/4, 30);
    
    [self.allGridItemArray removeAllObjects];
    
    [_showMoreGridView removeFromSuperview];
    
    _showMoreGridView = [[UIView alloc] init];
    
    [_showMoreGridView setBackgroundColor:[UIColor whiteColor]];
    
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    
    normalImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_bg@2x.png"];
    highlightedImage = [UIImage getImageWithCurrentBundle:currentBundle imageName:@"app_item_pressed_bg@2x.png"];
    
    UIImage *deleteIconImg = nil;
    

    
    for (NSInteger index = 0; index < _allGridArray.count; index++)
    {

        CustomGridModel * customGridM = _allGridArray[index];
        
        BOOL isAddDelete = YES;
        if ([customGridM.name isEqualToString:@"全部"]) {
            isAddDelete = NO;
        }
        
        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero  normalImage:normalImage highlightedImage:highlightedImage  atIndex:index isAddDelete:isAddDelete deleteIcon:deleteIconImg withCustomGridModel:customGridM];
        gridItem.delegate = self;

        gridItem.gridTitle = customGridM.name;
        gridItem.gridImageString = customGridM.image;
        gridItem.gridId = customGridM.int_id;
        gridItem.is_can_add = YES;
        
        [self.allGridItemArray addObject:gridItem];
        [self.showMoreGridView addSubview:gridItem];
      
    }
    
    
    [self getshowMoreGridViewNewData];
    
}



#pragma mark - 更新页面
-(void)getshowMoreGridViewNewData
{
    NSInteger gridHeight;
    if (self.allGridItemArray.count % 4 == 0) {
        gridHeight = ((ScreenWidth-50)/4  + 10) * self.allGridItemArray.count/4 + 10;
    }
    else{
        gridHeight = ((ScreenWidth-50)/4  + 10) * (self.allGridItemArray.count/4+1) + 10;
    }
    
    if (self.allGridItemArray.count == 0) {
        
        gridHeight -= 5;
    }
    
    [self.showMoreGridView setFrame:CGRectMake(0, CGRectGetMaxY(self.allGridListLabel.frame) , ScreenWidth, gridHeight)];
    
    if (self.allGridItemArray.count < 4) {
        gridHeight = ((ScreenWidth-50)/4  + 10) + self.allGridItemArray.count/4 + 10;
    }
    
    more_cell_Hight = gridHeight + 40;
    
    [self.tableView reloadData];
    
    
}



#pragma mark - 编辑与完成
-(void)editAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    //编辑时 全部设置为可点击全部应用中 已经选中的按钮 不可点击
    for (CustomGrid * showGrid in self.gridListArray) {

        for (CustomGrid * allGrid in self.allGridItemArray) {

            if ([allGrid.gridId isEqualToNumber:showGrid.gridId]) {

                [allGrid setIs_can_add:NO];

                break;

            }
            
        }
    }
    
    self.gridListPromptLabel.hidden = NO;
    if (btn.selected) {
        
        for (CustomGrid * grid in self.gridListArray) {
            
            grid.isChecked = YES;
            grid.isMove = YES;
            
            
            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.gridId];
            removeBtn.hidden = NO;
            
            removeBtn.transform = CGAffineTransformMakeScale(0.05, 0.05);
            
            grid.isShowBorder = YES;
            
            [UIView animateWithDuration:0.3  animations:^{
                
                removeBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            }completion:^(BOOL finish){
                
                
                
            }];
            
        }
        
        for (CustomGrid * grid in self.allGridItemArray) {
    
            grid.isChecked = YES;
            
            grid.isMove = NO;
            
            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.gridId];
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
        for (CustomGrid * allGrid in self.allGridItemArray) {
            
                [allGrid setIs_can_add:YES];
        }
        
        
        self.gridListPromptLabel.hidden = YES;
        for (CustomGrid * grid in self.gridListArray) {
            
            grid.isChecked = NO;
            grid.isMove = NO;
            [UIView animateWithDuration:0.3 animations:^{
                
                grid.isShowBorder = NO;
                UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.gridId];
                removeBtn.hidden = YES;
                
            }];
            
            
        }
        
        for (CustomGrid * grid in self.allGridItemArray) {
            
            grid.isChecked = NO;
            grid.isMove = NO;
            [UIView animateWithDuration:0.3 animations:^{
                
                grid.isShowBorder = NO;
                UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.gridId];
                removeBtn.hidden = YES;
                
            }];
            
            
        }
        
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        return first_cell_Hight ? first_cell_Hight : 140;
        
    }else{
        
        return more_cell_Hight ? more_cell_Hight : 140;
        
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
        
        [cell.contentView addSubview:self.gridListNameLabel];
        [cell.contentView  addSubview:self.gridListPromptLabel];
        
        if (self.showGridArray.count == 0) {
            
            self.promptLabel.frame = CGRectMake(0, CGRectGetMaxY(self.gridListNameLabel.frame), ScreenWidth, first_cell_Hight - 40);
            [cell.contentView  addSubview:self.promptLabel];
            
        }else{
            
            [cell.contentView  addSubview:self.gridListView];
            
        }
        
    }else if(indexPath.section == 1){
        
        [cell.contentView addSubview:self.allGridListLabel];
        
        [cell.contentView addSubview:self.showMoreGridView];
        
        
        
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
    
    NSLog(@"%@",gridItem.gridTitle);
    
}

#pragma mark - 格子选择操作
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton selectGrid:(CustomGrid *)selectGrid
{
    //删除格子
    if (selectGrid.isChecked && selectGrid.isMove){
        
        
        for (NSInteger i = 0; i < self.gridListArray.count; i++) {
            CustomGrid *removeGrid = self.gridListArray[i];
            if (removeGrid.gridId == deleteButton.tag) {
                
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
                    for (CustomGridModel * customGridM  in self.showGridArray) {
                        
                        if (customGridM.int_id == selectGrid.gridId) {
                            
                            [self.showGridArray removeObject:customGridM];
                            
                            [self saveArray];
                            
                            break;
                        }
                        
                    }
                    
         
                    for (CustomGrid * allGrid in _allGridItemArray) {
                        
                        if ([allGrid.gridId isEqualToNumber:removeGrid.gridId]) {
                            
                            [allGrid setIs_can_add:YES];
                            
                            break;
                            
                        }
                        
                    }
                    
                    //更新页面
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self getGridListNewData];
                        
                    });
                    
                    
                }];
            }
            
        }
        
    }
    
    //不能点击的已经设置为 不能使用状态，现在能点击的都可以进行添加
    else{
        
        for (NSInteger i = 0; i < self.allGridItemArray.count; i++) {
            CustomGrid *removeGrid = self.allGridItemArray[i];
            if (removeGrid.gridId == deleteButton.tag) {
                
                for (CustomGridModel * customGridM  in _allGridArray) {
                    
                    if (customGridM.int_id == selectGrid.gridId) {
                        
                        [self.showGridArray addObject:customGridM];
                    }
                    
                }

    //将已经选中的 Grid 的状态改为不可点击
                for (CustomGrid * allGrid in _allGridItemArray) {
                    
                    if ([allGrid.gridId isEqualToNumber:removeGrid.gridId]) {
                        
                        [allGrid setIs_can_add:NO];
                        
                        break;
                        
                    }
                    
                }
                
                
                deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    deleteButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    
                } completion:^(BOOL finished) {
                    
                    //更新页面
                    [self creatMyScrollViewOnView];
                    
                    [self saveArray];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        
                    } completion:^(BOOL finished) {
                        
                        for (CustomGrid * grid in self.gridListArray) {
                            
                            grid.isChecked = YES;
                            grid.isMove = YES;
                            
                            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.gridId];
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
 
    self.gridListPromptLabel.hidden = NO;
    self.button.selected = YES;
    
    //整个视图可编辑
    for (CustomGrid * grid in self.gridListArray) {
        
        grid.isChecked = YES;
        grid.isMove = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            grid.isShowBorder = YES;
            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.gridId];
            removeBtn.hidden = NO;
            
        }];
        //获取移动格子的起始位置
        startPoint = [longPressGesture locationInView:longPressGesture.view];
        //获取移动格子的起始位置中心点
        originPoint = longPressGesture.view.center;
        
    }
    //整个视图可编辑
    for (CustomGrid * grid in self.allGridItemArray) {
        
        grid.isChecked = YES;
        grid.isMove = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            grid.isShowBorder = YES;
            UIButton *removeBtn = (UIButton *)[grid viewWithTag:grid.gridId];
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
        NSInteger toIndex = [CustomGrid indexOfPoint:gridItem.center withButton:gridItem gridArray:self.gridListArray];
        
        NSInteger borderIndex = [self.showGridArray indexOfObject:@"0"];
        
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
    
    [HZSingletonManager shareInstance].myGridArray = self.showGridArray;
    
    //归档
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"showGridArray"];
    [NSKeyedArchiver archiveRootObject:self.showGridArray toFile:filePath];
    
    
}

@end
