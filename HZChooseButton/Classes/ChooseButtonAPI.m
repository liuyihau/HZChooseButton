//
//  ChooseButtonAPI.m
//  Pods
//
//  Created by LiuYihua on 2017/4/28.
//
//

#import "ChooseButtonAPI.h"


@interface ChooseButtonAPI()

@property (nonatomic, strong) FunctionMenuView * functionMenuView;


@end

@implementation ChooseButtonAPI

- (void)createChooseButtonFrame:(CGRect)frame gridDateSource:(NSMutableArray *)gridDateSource number:(int)number hideDeleteIconImage:(BOOL)deleteIconImageHide isHomeView:(BOOL)isHomeView isAllData:(BOOL)isAllData getheight:(void(^)(CGFloat cellheight))getheight{

    self.functionMenuView =  [[FunctionMenuView alloc] initWithFrame:frame gridDateSource:gridDateSource number:number hideDeleteIconImage:deleteIconImageHide isHomeView:isHomeView isAllData:isAllData getheight:getheight];
    
}

-(void)functionMeunViewActionWithAddGridItem:(addGridItem)addGridItem getlistViweHeight:(getlistViweHeight)getlistViweHeight listViweClick:(listViweClick)listViweClick listViweLongPress:(listViweLongPress)listViweLongPress loadListViewDataSoruce:(loadListViewDataSoruce)loadListViewDataSoruce{

    [self.functionMenuView functionMeunViewActionWithAddGridItem:addGridItem getlistViweHeight:getlistViweHeight listViweClick:listViweClick listViweLongPress:listViweLongPress loadListViewDataSoruce:loadListViewDataSoruce];

}


@end
