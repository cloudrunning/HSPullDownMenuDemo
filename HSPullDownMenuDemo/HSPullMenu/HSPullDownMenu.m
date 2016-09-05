//
//  HSPullDownMenu.m
//  YZPullDownMenuDemo
//
//  Created by caozhen@neusoft on 16/9/2.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "HSPullDownMenu.h"

@class HSCover;
NSString *const HSUpdateMenuTitleNote = @"HSUpdateMenuTitleNote";

@interface HSPullDownMenu ()

// 菜单的所有按钮
@property (nonatomic,strong) NSMutableArray *menuButtons;
// 菜单的所有分割线
@property (nonatomic,strong) NSMutableArray *separatorLines;
// 菜单的所有子控制器
@property (nonatomic,strong) NSMutableArray *controllers;
// 菜单每一列的高度
@property (nonatomic,strong) NSMutableArray *colsHeights;

@property (nonatomic,strong) UIView *contentView;

// 蒙版
@property (nonatomic,strong) HSCover *coverView;


@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,weak)   id observer;

@end

@implementation HSPullDownMenu

#pragma mark ---- 懒加载
- (NSMutableArray *)menuButtons {
    if (!_menuButtons) {
        _menuButtons = [NSMutableArray array];
    }
    return _menuButtons;
}

- (NSMutableArray *)separatorLines {
    if (!_separatorLines) {
        _separatorLines = [NSMutableArray array];
    }
    return _separatorLines;
}

- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}

- (NSMutableArray *)colsHeights {
    if (!_colsHeights) {
        _colsHeights = [NSMutableArray array];
    }
    return _colsHeights;
}

- (HSCover *)coverView {
    if (!_coverView) {
        _coverView = [[HSCover alloc]init];
        CGFloat coverViewY = CGRectGetMaxY(self.frame);
        CGFloat coverViewWidth = self.frame.size.width;
        CGFloat coverViewHeight = self.superview.bounds.size.height - coverViewY;
        _coverView.frame = CGRectMake(0, coverViewY, coverViewWidth, coverViewHeight);
        
        _coverView.backgroundColor = self.coverColor;
        [self.superview addSubview:_coverView];
        
        __weak typeof(self)weakSelf = self;
        _coverView.clickCover = ^{
            [weakSelf dismiss];
        };        
    }
    return _coverView;
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        _contentView.clipsToBounds = YES;
        [_coverView addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark ---- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    //设置默认值
    _separatorLineColor =  [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _coverColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:.7];
    _separatorLineTopMargin = 10;

    _observer = [[NSNotificationCenter defaultCenter]addObserverForName:HSUpdateMenuTitleNote object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
      // 选中操作发起通知,更改菜单对应列的title值
        [self dismiss];
        
        UIViewController *childViewController = note.object;
        
        NSInteger col = [self.controllers indexOfObject:childViewController];
        
        UIButton *relativeBtn = [self.menuButtons objectAtIndex:col];
        
        NSArray *allValues = [note.userInfo allValues];
        if (allValues.count > 1 || ![allValues.firstObject isKindOfClass:[NSString class]]) {
            return ;
        }
        
        [relativeBtn setTitle:allValues.firstObject forState:UIControlStateNormal];
    }];
    
}

// 清空旧数据，保存新数据，添加所有子控件
- (void)reloadData {
    
    [self clear];

    if (![self.dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        @throw [NSException exceptionWithName:@"HSError" reason:@"numberOfColumnsInMenu:没有实现" userInfo:nil];
    }
    
    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:buttonForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"HSError" reason:@"pullDownMenu:buttonForColAtIndex:没有实现" userInfo:nil];
    }
    

    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:heightForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"HSError" reason:@"pullDownMenu:heightForColAtIndex:没有实现" userInfo:nil];
    }

    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:childViewControllerForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"HSError" reason:@"pullDownMenu:childViewControllerForColAtIndex:没有实现" userInfo:nil];
    }
    
    NSInteger cols = [self.dataSource numberOfColumnsInMenu:self];
    
    if (cols == 0) return;
    
    // 保存新数据 并添加子控件
    for (int i = 0; i < cols; i++) {
        UIButton *btn = [self.dataSource pullDownMenu:self buttonForColAtIndex:i];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (btn == nil) {
            @throw [NSException exceptionWithName:@"HSError" reason:@"pullDownMenu:buttonForColAtIndex:不能返回nilbutton" userInfo:nil];
            return;
        }
        [self.menuButtons addObject:btn];
        [self addSubview:btn];
        
        UIViewController *childVC = [self.dataSource pullDownMenu:self childViewControllerForColAtIndex:i];
        [self.controllers addObject:childVC];
        
        CGFloat colHeight = [self.dataSource pullDownMenu:self heightForColAtIndex:i];
        [self.colsHeights addObject:@(colHeight)];

    }
    
    NSInteger separatorLineCount = cols -1;
    for (int i = 0; i < separatorLineCount; i++) {
        UIView *separarorLine = [UIView new];
        [self addSubview:separarorLine];
        separarorLine.backgroundColor = _separatorLineColor;
        [self.separatorLines addObject:separarorLine];
    }
    
    self.bottomLine = [UIView new];
    [self addSubview:self.bottomLine];
    self.bottomLine.backgroundColor = _separatorLineColor;
    
    [self layoutSubviews];
}

// 布局所有子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    // 布局 buttons 分割线 底部分割线
    NSInteger cnt = self.menuButtons.count;
    
    CGFloat btnWidth = self.bounds.size.width / cnt;
    CGFloat btnHeight = self.bounds.size.height;
    CGFloat btnX = 0;
    
    for (int i = 0; i < cnt; i++) {
        UIButton *btn = self.menuButtons[i];
        btn.frame = CGRectMake(btnX, 0, btnWidth, btnHeight);
        btnX += btnWidth;
        if (i < cnt - 1) {
            UIView *separaterLine = self.separatorLines[i];
            separaterLine.frame = CGRectMake(CGRectGetMaxX(btn.frame), self.separatorLineTopMargin, 1, 2*self.separatorLineTopMargin);
        }
    }
    
    self.bottomLine.frame = CGRectMake(0, btnHeight - 1, self.bounds.size.width, 1);
    
    
}

- (void)btnClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    for (UIButton *menuBtn in self.menuButtons) {
        if (btn == menuBtn) continue;
        menuBtn.selected = NO;
    }
    
    
    if (btn.selected) {
        
        self.coverView.hidden = NO;
        
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSInteger index = btn.tag;
        UIViewController *childVC = [self.controllers objectAtIndex:index];
        [self.contentView addSubview:childVC.view];
        childVC.view.frame = self.contentView.bounds;
        
        CGFloat colHeight = [[self.colsHeights objectAtIndex:index]floatValue];
        
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = self.contentView.frame;
            rect.size.height = colHeight;
            self.contentView.frame = rect;
            
        }];
        
        
        
    } else {
        [self dismiss];
    }
}
// 菜单弹回，相关操作：1.菜单按钮全部未选中 2.隐藏蒙版3.收回contentView
- (void)dismiss {
    
    for (UIButton *btn in self.menuButtons) {
        btn.selected = NO;
    }
    
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:.0 alpha:0];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.contentView.frame;
        rect.size.height = 0;
        self.contentView.frame = rect;
        
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        self.coverView.backgroundColor = self.coverColor;
        
    }];
   

}

// 删除要清空所有数据，并且移除所有子空间
- (void)clear {
    [self.separatorLines removeAllObjects];
    [self.controllers removeAllObjects];
    [self.menuButtons removeAllObjects];
    [self.colsHeights removeAllObjects];
    
    self.bottomLine = nil;
    self.coverView = nil;
    self.contentView = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
#pragma mark ---- 进入窗口需刷新
- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [self reloadData];
}


- (void)dealloc {
    [self clear];
    [[NSNotificationCenter defaultCenter]removeObserver:self.observer];
}
@end






//--------- 蒙版 --------
@implementation HSCover

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.clickCover) {
        self.clickCover();
    }
}

@end

















