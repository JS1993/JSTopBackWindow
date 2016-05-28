//
//  JSTopBackWindow.m
//  JSTopBackWindow
//
//  Created by  江苏 on 16/5/28.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "JSTopBackWindow.h"

@implementation JSTopBackWindow

static UIWindow* window_;

-(void)initialize{
    
    window_=[[UIWindow alloc]init];
    window_.frame=CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,20);
    window_.backgroundColor=[UIColor clearColor];
    window_.windowLevel=UIWindowLevelAlert;
    window_.rootViewController=[UIApplication sharedApplication].keyWindow.rootViewController;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(winClick)]];
    
}

+(void)show{
    window_.hidden=NO;
}

+(void)hide{
    window_.hidden=YES;
}

/**
 *  监听窗口点击
 */
+(void)winClick{
    
    UIWindow* window=[UIApplication sharedApplication].keyWindow;
    
    [self searchScrollViewInView:window];
}


+(void)searchScrollViewInView:(UIView*)superView{
    
    //递归遍历，找出显示在当前窗口的，然后恢复偏移量到最上面
    for (UIScrollView* scrollView in superView.subviews) {
        
        if ([scrollView isKindOfClass:[UIScrollView class]]&&[self isShowInKeyWindowWithView:scrollView]) {
            
            //改变偏移量
            CGPoint offset=scrollView.contentOffset;
            offset.y=-scrollView.contentInset.top;
            [scrollView setContentOffset:offset animated:YES];
        }
        
        [self searchScrollViewInView:scrollView];
    }
    
}

/**
 *  判断是否显示在当前窗口内
 */
+(BOOL)isShowInKeyWindowWithView:(UIView*)view{
    
    UIWindow* keyWindow=[UIApplication sharedApplication].keyWindow;
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame=[keyWindow convertRect:view.frame fromView:view.superview];
    
    BOOL isInRect=CGRectIntersectsRect(newFrame, keyWindow.bounds);
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL isShowInKeyWindow=view.alpha>0.01&&!view.isHidden&&isInRect&&view.window==keyWindow;
    
    return isShowInKeyWindow;
    
}
@end
