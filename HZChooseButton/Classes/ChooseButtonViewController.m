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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        self.showGridImageArray = [[NSMutableArray alloc] initWithCapacity:16];
        self.showGridIDArray = [[NSMutableArray alloc] initWithCapacity:16];
        
        self.allGridItemArray = [[NSMutableArray alloc] initWithCapacity:16];
        
        self.allGridIdArray = [[NSMutableArray alloc] initWithCapacity:16];
        self.allGridTitleArray = [[NSMutableArray alloc]initWithCapacity:16];
        self.allGridImageArray = [[NSMutableArray alloc]initWithCapacity:16];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.hidesBottomBarWhenPushed = YES;
    
    
    self.navigationItem.title = @"全部应用";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:self.button], nil]];
    
    
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height);
    
    [self.view addSubview:self.tableView];
    
    
    _allGridTitleArray = [NSMutableArray arrayWithObjects:@"1收银台",@"2结算",@"3分享", @"4T+0", @"5中心",@"6D+1", @"7商店",@"8P2P", @"9开通", @"10充值", @"11转账", @"12扫码", @"13记录" , @"14快捷支付", @"15明细", @"16收款", nil];
    
    _allGridImageArray = [NSMutableArray arrayWithObjects:
                          @"more_icon_Transaction_flow",@"more_icon_cancle_deal", @"more_icon_Search",
                          @"more_icon_t0",@"more_icon_shouyin" ,@"more_icon_d1",
                          @"more_icon_Settlement",@"more_icon_Mall", @"more_icon_gift",
                          @"more_icon_licai",@"more_icon_-transfer",@"more_icon_Recharge" ,
                          @"more_icon_Transfer-" , @"more_icon_Credit-card-",@"more_icon_Manager",@"work-order", nil];
    
    _allGridIdArray =  [NSMutableArray arrayWithObjects:
                        @"1000",@"1001", @"1002",
                        @"1003",@"1004",@"1005" ,@"1006",
                        @"1007",@"1008", @"1009",
                        @"1010",@"1011",@"1012" ,
                        @"1013" , @"1014",@"1015", nil];
    
    [self drawMoreGridView];
    
    
    NSMutableArray *titleArr = [HZSingletonManager shareInstance].showGridArray;
    NSMutableArray *imageArr = [HZSingletonManager shareInstance].showImageGridArray;
    NSMutableArray *idArr = [HZSingletonManager shareInstance].showGridIDArray;
    
    _showGridArray = [[NSMutableArray alloc]initWithArray:titleArr];
    _showGridImageArray = [[NSMutableArray alloc]initWithArray:imageArr];
    _showGridIDArray = [[NSMutableArray alloc]initWithArray:idArr];
    
    [self creatMyScrollViewOnView];
    
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (CustomGrid * showGrid in _gridListArray) {
        
        for (CustomGrid * allGrid in _allGridItemArray) {
            
            if (allGrid.gridId == showGrid.gridId) {
                
                [allGrid setIs_can_add:NO];
                
                break;
                
            }
            
        }
    }
    
    
    
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
    
    for (NSInteger index = 0; index < [_showGridArray count]; index++)
    {
        NSString *gridTitle = _showGridArray[index];
        NSString *gridImage = _showGridImageArray[index];
        NSInteger gridID = [_showGridIDArray[index] integerValue];
        BOOL isAddDelete = YES;
        if ([gridTitle isEqualToString:@"更多"]) {
            isAddDelete = NO;
        }
        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero title:gridTitle normalImage:normalImage highlightedImage:highlightedImage gridId:gridID atIndex:index isAddDelete:isAddDelete deleteIcon:deleteIconImage  withIconImage:gridImage];
        gridItem.delegate = self;
        gridItem.gridTitle = gridTitle;
        gridItem.gridImageString = gridImage;
        gridItem.gridId = gridID;
        
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
    
    
    for (NSInteger index = 0; index < _allGridIdArray.count; index++)
    {
        NSString *gridTitle = _allGridTitleArray[index];
        NSString *gridImageStr = _allGridImageArray[index];
        NSInteger gridID = [_allGridIdArray[index] integerValue];
        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero title:gridTitle normalImage:normalImage highlightedImage:highlightedImage gridId:gridID atIndex:index isAddDelete:YES deleteIcon:deleteIconImg withIconImage:gridImageStr];
        gridItem.delegate = self;
        gridItem.gridTitle = gridTitle;
        gridItem.gridImageString = gridImageStr;
        gridItem.gridId = gridID;
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
                
                removeBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
                
            }completion:^(BOOL finish){
                
                
                
            }];
            
        }
        
        
    }else{
        
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
    return 15;
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
    
        NSLog(@"点击了%@格子",gridItem.gridTitle);
    
}

#pragma mark - 删除格子
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton selectGrid:(CustomGrid *)selectGrid
{
    
    if (selectGrid.isChecked && selectGrid.isMove){//删除格子
        
        
        for (NSInteger i = 0; i < _gridListArray.count; i++) {
            CustomGrid *removeGrid = _gridListArray[i];
            if (removeGrid.gridId == deleteButton.tag) {
                
                removeGrid.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.4 animations:^{
                    
                    removeGrid.transform = CGAffineTransformMakeScale(0.05, 0.05);
                    removeGrid.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    [removeGrid removeFromSuperview];
                    
                    NSInteger count = _gridListArray.count - 1;
                    for (NSInteger index = removeGrid.gridIndex; index < count; index++) {
                        CustomGrid *preGrid = _gridListArray[index];
                        CustomGrid *nextGrid = _gridListArray[index+1];
                        [UIView animateWithDuration:0.4 animations:^{
                            nextGrid.center = preGrid.gridCenterPoint;
                        }];
                        nextGrid.gridIndex = index;
                    }
                    
                    [_gridListArray removeObjectAtIndex:removeGrid.gridIndex];
                    
                    //排列格子顺序和更新格子坐标信息
                    [self sortGridList];
                    
                    NSString *gridTitle = removeGrid.gridTitle;
                    NSString *gridImage = removeGrid.gridImageString;
                    NSString *gridID = [NSString stringWithFormat:@"%ld", (long)selectGrid.gridId];
                    //删除的应用添加到更多应用数组
                    [_showGridArray removeObject:gridTitle];
                    [_showGridImageArray removeObject:gridImage];
                    [_showGridIDArray removeObject:gridID];
                    
                    
                    for (CustomGrid * allGrid in _allGridItemArray) {
                        
                        if (allGrid.gridId == removeGrid.gridId) {
                            
                            [allGrid setIs_can_add:YES];
                            
                            break;
                            
                        }
                        
                    }
                    
                    
                    //更新页面
                    // 保存更新后数组
                    [self saveArray];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self getGridListNewData];
                        
                    });
                    
                    
                }];
            }
            
        }
        
    }
    else{//不能点击的已经设置为 不能使用状态，现在能点击的都可以进行添加
        
        for (NSInteger i = 0; i < self.allGridItemArray.count; i++) {
            CustomGrid *removeGrid = self.allGridItemArray[i];
            if (removeGrid.gridId == deleteButton.tag) {
                
                NSString *gridId = [NSString stringWithFormat:@"%ld", (long)selectGrid.gridId];
                
                [self.showGridArray addObject:removeGrid.gridTitle];
                [self.showGridImageArray addObject:removeGrid.gridImageString];
                [self.showGridIDArray addObject:gridId];
                
                for (CustomGrid * allGrid in _allGridItemArray) {
                    
                    if (allGrid.gridId == removeGrid.gridId) {
                        
                        [allGrid setIs_can_add:NO];
                        
                        break;
                        
                    }
                    
                }
                
                
                [self saveArray];
                
                
                deleteButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    deleteButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    
                } completion:^(BOOL finished) {
                    
                    //更新页面
                    [self creatMyScrollViewOnView];
                    
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
    NSLog(@"长按.........");
    
    self.gridListPromptLabel.hidden = NO;
    self.button.selected = YES;
    
    //整个视图可编辑
    for (CustomGrid * grid in _gridListArray) {
        
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
        NSInteger toIndex = [CustomGrid indexOfPoint:gridItem.center withButton:gridItem gridArray:_gridListArray];
        
        NSInteger borderIndex = [self.showGridIDArray indexOfObject:@"0"];
        NSLog(@"borderIndex: %ld", (long)borderIndex);
        
        if (toIndex < 0 || toIndex >= borderIndex) {
            contain = NO;
        }else{
            //获取移动到目标格子
            CustomGrid *targetGrid = _gridListArray[toIndex];
            gridItem.center = targetGrid.gridCenterPoint;
            originPoint = targetGrid.gridCenterPoint;
            gridItem.gridIndex = toIndex;
            
            //判断格子的移动方向，是从后往前还是从前往后拖动
            if ((fromIndex - toIndex) > 0) {
                //                NSLog(@"从后往前拖动格子.......");
                //从移动格子的位置开始，始终获取最后一个格子的索引位置
                NSInteger lastGridIndex = fromIndex;
                for (NSInteger i = toIndex; i < fromIndex; i++) {
                    CustomGrid *lastGrid = _gridListArray[lastGridIndex];
                    CustomGrid *preGrid = _gridListArray[lastGridIndex-1];
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
                    CustomGrid *topOneGrid = _gridListArray[i];
                    CustomGrid *nextGrid = _gridListArray[i+1];
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

- (void)sortGridList
{
    //重新排列数组中存放的格子顺序
    [_gridListArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CustomGrid *tempGrid1 = (CustomGrid *)obj1;
        CustomGrid *tempGrid2 = (CustomGrid *)obj2;
        return tempGrid1.gridIndex > tempGrid2.gridIndex;
    }];
    
    //更新所有格子的中心点坐标信息
    for (NSInteger i = 0; i < _gridListArray.count; i++) {
        CustomGrid *gridItem = _gridListArray[i];
        gridItem.gridCenterPoint = gridItem.center;
    }
    
    // 保存更新后数组
    [self saveArray];
}

#pragma mark - 保存更新后数组
-(void)saveArray
{
    // 保存更新后数组
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    NSMutableArray * array3 = [[NSMutableArray alloc]init];
    for (int i = 0; i < _gridListArray.count; i++) {
        CustomGrid * grid = _gridListArray[i];
        [array1 addObject:grid.gridTitle];
        [array2 addObject:grid.gridImageString];
        [array3 addObject:[NSString stringWithFormat:@"%ld",(long)grid.gridId]];
    }
    NSArray * titleArray = [array1 copy];
    NSArray * imageArray = [array2 copy];
    NSArray * idArray = [array3 copy];
    
    [HZSingletonManager shareInstance].showGridArray = [[NSMutableArray alloc]initWithArray:titleArray];
    [HZSingletonManager shareInstance].showImageGridArray = [[NSMutableArray alloc]initWithArray:imageArray];
    [HZSingletonManager shareInstance].showGridIDArray = [[NSMutableArray alloc]initWithArray:idArray];
    
    //主页中的版块更改
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"title"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gridID"];
    
    [[NSUserDefaults standardUserDefaults] setObject:titleArray forKey:@"title"];
    [[NSUserDefaults standardUserDefaults] setObject:imageArray forKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:idArray forKey:@"gridID"];
    
    
    
}

@end
