//
//  CustomGrid.m
//  MoveGrid
//
//  Created by Jerry.li on 14-11-6.
//  Copyright (c) 2014年 51app. All rights reserved.
//

#import "CustomGrid.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"
////颜色  ! 参数格式为：0xFFFFFF
#define RandomColorWithRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define ISIPHONE5s ( [UIScreen mainScreen].bounds.size.width >=320 && [UIScreen mainScreen].bounds.size.width <375)

@interface CustomGrid()

@property(nonatomic, strong)UIButton * deleteBtn;

@end

@implementation CustomGrid



@synthesize delegate;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//创建格子
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
             gridId:(NSInteger)gridId
            atIndex:(NSInteger)index
        isAddDelete:(BOOL)isAddDelete
         deleteIcon:(UIImage *)deleteIcon
      withIconImage:(NSString *)imageString
{
    self = [super initWithFrame:frame];
    if (self) {
        //计算每个格子的X坐标
        CGFloat pointX = (index % PerRowGridCount) * (GridWidth + PaddingX) + PaddingX;
        //计算每个格子的Y坐标
        CGFloat pointY = (index / PerRowGridCount) * ((ScreenWidth-50)/4  + PaddingY) + PaddingY;
        
        [self setFrame:CGRectMake(pointX, pointY, GridWidth, (ScreenWidth-50)/4)];
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addTarget:self action:@selector(gridClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setBackgroundColor:[UIColor whiteColor]];

        // 图片icon
        UIImageView * imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,GridWidth, 34)];
        imageIcon.contentMode = UIViewContentModeCenter;
        imageIcon.centerY = GridWidth/3;
        imageIcon.image = [UIImage imageNamed:imageString];
        imageIcon.tag = self.gridId;
        [self addSubview:imageIcon];
        
        
        // 标题
        UILabel * title_label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageIcon.frame) + PaddingY/2, GridWidth, 20)];
        title_label.text = title;
        title_label.textAlignment = NSTextAlignmentCenter;
        title_label.font = [UIFont systemFontOfSize:14];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.textColor = [UIColor blackColor];
        [self addSubview:title_label];
        

        //////////
        [self setGridId:gridId];
        [self setGridIndex:index];
        [self setGridCenterPoint:self.center];
        
        //判断是否要添加删除图标
        if (isAddDelete) {
            //当长按时添加删除按钮图标
             _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_deleteBtn setFrame:CGRectMake(GridWidth - 20, 5, 15, 15)];
            [_deleteBtn setBackgroundColor:[UIColor clearColor]];
            [_deleteBtn setBackgroundImage:deleteIcon forState:UIControlStateNormal];
            _deleteBtn.userInteractionEnabled = NO;
            
//            [_deleteBtn addTarget:self action:@selector(deleteGrid:) forControlEvents:UIControlEventTouchUpInside];
            
            [_deleteBtn setHidden:YES];
            
            if (ISIPHONE5s) {
                
                [_deleteBtn setFrame:CGRectMake(GridWidth - 18, 5, 13, 13)];

                title_label.font = [UIFont systemFontOfSize:12];
            }
            
            //添加编辑时的点击手势
            [_deleteBtn setTag:gridId];
            [self addSubview:_deleteBtn];
            
            //添加长按手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gridLongPress:)];
            [self addGestureRecognizer:longPressGesture];
             longPressGesture = nil;
            
        }
    }
    return self;
}


//响应格子点击事件
- (void)gridClick:(CustomGrid *)clickItem
{
    
    if (clickItem.deleteBtn.hidden == YES) {
        
         [self.delegate gridItemDidClicked:clickItem];
     
    }else{
    
         [self.delegate gridItemDidDeleteClicked:clickItem.deleteBtn selectGrid:self];
    
    }
    
    
}

//响应格子删除事件
- (void)deleteGrid:(UIButton *)deleteButton
{
    [self.delegate gridItemDidDeleteClicked:deleteButton selectGrid:self];
}

//响应格子的长安手势事件
- (void)gridLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.delegate pressGestureStateBegan:longPressGesture withGridItem:self];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            //应用移动后的新坐标
            CGPoint newPoint = [longPressGesture locationInView:longPressGesture.view];
            [self.delegate pressGestureStateChangedWithPoint:newPoint gridItem:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.delegate pressGestureStateEnded:self];
            break;
        }
        default:
            break;
    }
}

//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray
{
    for (NSInteger i = 0;i< gridListArray.count;i++)
    {
        UIButton *appButton = gridListArray[i];
        if (appButton != btn)
        {
            if (CGRectContainsPoint(appButton.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}


-(void)setIsShowBorder:(BOOL)isShowBorder{

    if (isShowBorder) {//显示
        [UIView animateWithDuration:0.3  animations:^{
        
            self.layer.borderWidth = 0.5;
            self.layer.borderColor = RandomColorWithRGB(0xdddddd).CGColor;
            
        }completion:^(BOOL finish){

            
        }];

        
    }else{//不显示
    
        [UIView animateWithDuration:0.3  animations:^{
        
            self.layer.borderWidth = 0;
            self.layer.borderColor = RandomColorWithRGB(0xdddddd).CGColor;
            
        }completion:^(BOOL finish){
            
            
        }];

    
    }


}

-(void)setIs_can_add:(BOOL)is_can_add{

    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    
    if (is_can_add) {//能点击
        
        [_deleteBtn setImage:[UIImage getImageWithCurrentBundle:currentBundle imageName: @"app_item_add@2x.png"] forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        
    }else{//不能点击
        
        [_deleteBtn setImage:[UIImage getImageWithCurrentBundle:currentBundle imageName: @"app_item_no@2x.png"] forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;

    }

}



@end
