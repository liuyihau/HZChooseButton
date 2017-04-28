//
//  HZBaseViewController.m
//  Pods
//
//  Created by LiuYihua on 2017/4/28.
//
//

#import "HZBaseViewController.h"
#import "NSBundle+HZChooseButtonExtension.h"

@interface HZBaseViewController (){

    UIBarButtonItem* negativeSpacer;
    UIBarButtonItem* backItem;
    UIBarButtonItem * lineItem;
    UIBarButtonItem* titleItem;

}

@end

@implementation HZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    negativeSpacer = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                      target:nil
                      action:nil];
    negativeSpacer.width = -8;
    
    backItem = [self itemWithTitle:@"" image:[NSBundle hz_imageNamed:@"back"] highImage:nil target:self action:@selector(back) alignmentRight:NO];
    
    lineItem = [self itemWithTitle:@"" image:[NSBundle hz_imageNamed:@"line"] highImage:[NSBundle hz_imageNamed:@"line"] target:self action:nil alignmentRight:NO];
    
    titleItem = [self itemWithTitle:self.itemTitle image:nil highImage:nil target:self action:nil alignmentRight:NO];
    titleItem.enabled = NO;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backItem,lineItem,titleItem,nil]];
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIBarButtonItem *) itemWithTitle:(NSString * )title image:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action alignmentRight:(BOOL)alignmentRight{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button sizeToFit];
    
    [button setFrame:CGRectMake(0, 0, button.frame.size.width + 5, button.frame.size.height)];
    
    if (alignmentRight) {
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
    }else{
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
