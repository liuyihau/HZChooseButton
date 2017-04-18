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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_fromEditBtn) {
        
        [self editAction:self.button];
    }


}


-(void)setupUI{
#pragma mark =============我的应用===============
    self.showGridArray =  [HZSingletonManager shareInstance].myGridArray;
    self.gridListView = [[FunctionMenuView alloc]initWithFrame:CGRectZero gridDateSource:self.showGridArray number:nil];
    first_cell_Hight = [self.gridListView createFunctionMenuViewWithHideDeleteIconImage:NO isHomeView:NO  gridListDataSource:self.showGridArray];
    [self.gridListView setFrame:CGRectMake(0, 0, self.view.frame.size.width, first_cell_Hight)];
 
    __weak typeof(self) weakSelf = self;
    
    self.showGridArray = self.gridListView.gridListDataSource;
    
    [self.gridListView functionMeunViewActionWithAddGridItem:^(CustomGrid *gridItem) {
        
    } getlistViweHeight:^(CGFloat cellHeight, CustomGrid *gridItem, BOOL allGridBtnImageChange) {
        
        first_cell_Hight = cellHeight;
        
        [weakSelf.gridListView setFrame:CGRectMake(0, 0, self.view.frame.size.width,first_cell_Hight)];
        
        if (allGridBtnImageChange) {
            
            [weakSelf.allGridListView setAllGridlistViewGridItemChangeWithSelectGrid:gridItem];
            
            weakSelf.showGridArray = weakSelf.gridListView.gridListDataSource;
        }
        
        [weakSelf.tableView reloadData];
        
    } listViweClick:^(CustomGrid *gridItem) {
        
        if (weakSelf.func_listViweClick != nil) {
            
            weakSelf.func_listViweClick(gridItem);
            
        }
        
    } listViweLongPress:^(CustomGrid *gridItem) {
        
         [weakSelf func_listViweLongPress];
        
    } loadListViewDataSoruce:^(NSMutableArray *dateSource) {
        
        if (weakSelf.func_loadGridListViewDataSoruce) {
            
            weakSelf.func_loadGridListViewDataSoruce(dateSource);

        }
        
    }];
    

#pragma mark =============全部应用===============
    
    self.allGridArray = [HZSingletonManager shareInstance].gridDateSource;
    self.allGridListView = [[FunctionMenuView alloc]initWithFrame:CGRectZero gridDateSource:self.allGridArray number:nil];
    
    all_cell_Hight = [self.allGridListView createFunctionMenuViewWithHideDeleteIconImage:YES isHomeView:NO  gridListDataSource:self.allGridArray];
    
    [self.allGridListView setFrame:CGRectMake(0, 0, self.view.frame.size.width, all_cell_Hight)];
    
    self.allGridArray = self.allGridListView.gridListDataSource;
 
    [self.allGridListView functionMeunViewActionWithAddGridItem:^(CustomGrid *gridItem) {
        
        [weakSelf.gridListView addGridItemToMyGridListViewWithselectGrid:gridItem];
        
        weakSelf.showGridArray = weakSelf.gridListView.gridListDataSource;
        
        
    } getlistViweHeight:^(CGFloat cellHeight, CustomGrid *gridItem, BOOL allGridBtnImageChange) {
        
        
        
    } listViweClick:^(CustomGrid *gridItem) {
        
        if (weakSelf.func_listViweClick != nil) {
            
            weakSelf.func_listViweClick(gridItem);
            
        }
        
    } listViweLongPress:^(CustomGrid *gridItem) {
        
        [weakSelf func_listViweLongPress];
        
    } loadListViewDataSoruce:^(NSMutableArray *dateSource) {
        
    }];
   
}

#pragma mark - 视图长按
-(void)func_listViweLongPress{

    self.button.selected = YES;
    
    [self.gridListView editGridListViewWithPrompthidden:YES isAllGridListView:NO showGridArray:nil animated:NO];
    [self.allGridListView editGridListViewWithPrompthidden:YES isAllGridListView:YES showGridArray:self.showGridArray animated:NO];


}


#pragma mark - 编辑与完成
-(void)editAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;

    [self.gridListView editGridListViewWithPrompthidden:btn.selected isAllGridListView:NO showGridArray:nil animated:YES];
    [self.allGridListView editGridListViewWithPrompthidden:btn.selected isAllGridListView:YES showGridArray:self.showGridArray animated:YES];

    
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

@end
