//
//  ViewController.m
//  Draging
//
//  Created by administator on 16/3/30.
//  Copyright © 2016年 YNuo. All rights reserved.
//

#import "ViewController.h"
#define kHomeGridViewPerRowItemCount 3
#define sd_width [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
{
UIButton *_placeholderButton;
}
@property(nonatomic,strong)NSMutableArray *dataSourse;
@property(nonatomic,weak)UILabel *label;
@property(nonatomic,weak)UILongPressGestureRecognizer *pan;
@property(nonatomic,strong)NSMutableArray *arrayItem;
@end

@implementation ViewController

-(NSMutableArray *)dataSourse
{
    if (_dataSourse==nil) {
        _dataSourse=[NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    }
    return _dataSourse;
    
}
-(NSMutableArray *)arrayItem
{
    if (_arrayItem==nil) {
        _arrayItem=[NSMutableArray array];
    }
    return _arrayItem;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
       for (int i=0; i<self.dataSourse.count; i++) {
       
        _placeholderButton = [[UIButton alloc] init];

        UILabel *label=[[UILabel alloc]init];
        [self.arrayItem  addObject:label];
        label.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
        label.layer.borderWidth=1;
        label.userInteractionEnabled=YES;
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor grayColor];
        [self.view addSubview:label];
        label.text=self.dataSourse[i];
        self.label=label;
        UILongPressGestureRecognizer *pan=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
         self.pan=pan;
        [self.label addGestureRecognizer:pan];
    }
    //设置item的frame
    [self setupSubViewsFrame];
    
   
}
- (void)setupSubViewsFrame
{
    CGFloat itemW = sd_width / kHomeGridViewPerRowItemCount;
    CGFloat itemH = itemW * 1.1;
   [_arrayItem enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
       long rowIndex = idx / kHomeGridViewPerRowItemCount;
       long columnIndex = idx % kHomeGridViewPerRowItemCount;
       CGFloat x = itemW * columnIndex;
       CGFloat y = 0;
       y = itemH * rowIndex;
       obj.frame=CGRectMake(x, y, itemW, itemH);
   }];
    
   
    
}
-(void)handlePan:(UILongPressGestureRecognizer *)pan
{
    UIGestureRecognizerState state = pan.state;
    UILabel *view = (UILabel *)pan.view;
    CGPoint point = [pan locationInView:self.view];
    if (state == UIGestureRecognizerStateBegan)
    {
      
//        CGPoint location = [pan locationInView:pan.view.superview];
        [view.superview bringSubviewToFront:view];
         view.transform=CGAffineTransformMakeScale(1.1, 1.1);
        long index = [_arrayItem indexOfObject:pan.view];
        [_arrayItem  removeObject:pan.view];
        [_arrayItem  insertObject:_placeholderButton atIndex:index];
        
    }
    
    
    [_arrayItem enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        if (CGRectContainsPoint(view.frame, point) && view != pan.view) {
            [_arrayItem removeObject:_placeholderButton];
            [_arrayItem insertObject:_placeholderButton atIndex:idx];
            
            
            [UIView animateWithDuration:0.5 animations:^{
                [self setupSubViewsFrame];
            }];
        }
        
    }];

    
    if (state == UIGestureRecognizerStateChanged)
    {
        UILabel *view = (UILabel *)pan.view;
        CGPoint location = [pan locationInView:pan.view.superview];
        view.center = location;
    }
    
    
    if (state==UIGestureRecognizerStateEnded){
        long index = [_arrayItem indexOfObject:_placeholderButton];
        [_arrayItem removeObject:_placeholderButton];
        [_arrayItem insertObject:pan.view atIndex:index];
        view.transform=CGAffineTransformIdentity;
//       [self.view sendSubviewToBack:pan.view];
        // 获取手指在屏幕中的坐标
        CGPoint location = [pan locationInView:pan.view.superview];
        pan.view.center = location;// 重新设置视图的位置
        [UIView animateWithDuration:.3 animations:^{
            [self setupSubViewsFrame];

        }];
        
    }
}
@end
