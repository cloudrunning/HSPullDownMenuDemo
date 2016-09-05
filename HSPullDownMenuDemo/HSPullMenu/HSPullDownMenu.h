//
//  HSPullDownMenu.h
//  YZPullDownMenuDemo
//
//  Created by caozhen@neusoft on 16/9/2.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSPullDownMenu;
@protocol HSPullDownMenuDataSource <NSObject>
// 有多少列
- (NSInteger)numberOfColumnsInMenu:(HSPullDownMenu *)menu;

// 每一列的高度
- (CGFloat)pullDownMenu:(HSPullDownMenu *)menu heightForColAtIndex:(NSInteger)index;

// 每一列对应的子控制器
- (UIViewController *)pullDownMenu:(HSPullDownMenu *)menu childViewControllerForColAtIndex:(NSInteger)index;

// 每一列对应的按钮外观样式
- (UIButton *)pullDownMenu:(HSPullDownMenu *)menu buttonForColAtIndex:(NSInteger)index;
@end

extern NSString *const HSUpdateMenuTitleNote;

@interface HSPullDownMenu : UIView

@property (nonatomic,weak)   id<HSPullDownMenuDataSource> dataSource;

// 分割线 颜色和上边距
@property (nonatomic,strong) UIColor *separatorLineColor;

@property (nonatomic,assign) CGFloat separatorLineTopMargin;


//蒙版颜色
@property (nonatomic,strong) UIColor *coverColor;

- (void)reloadData;

@end


//-------- 蒙版------

@interface HSCover : UIView

@property (nonatomic,strong) void(^clickCover)();

@end
