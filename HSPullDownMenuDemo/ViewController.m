//
//  ViewController.m
//  HSPullDownMenuDemo
//
//  Created by caozhen@neusoft on 16/9/5.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "ViewController.h"
#import "HSPullDownMenu.h"
#import "HSMenuButton.h"
#import "YZMoreMenuViewController.h"
#import "HSSortViewController.h"
#import "HSAllCourseViewController.h"

#define YZScreenW [UIScreen mainScreen].bounds.size.width
#define YZScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<HSPullDownMenuDataSource>
@property (nonatomic, strong) NSArray *titles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor brownColor];
    
    // 创建下拉菜单
    HSPullDownMenu *menu = [[HSPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 20, YZScreenW, 44);
    [self.view addSubview:menu];
    
    // 设置下拉菜单代理
    menu.dataSource = self;
    
    // 初始化标题
    _titles = @[@"小学",@"排序",@"更多"];
    
    // 添加子控制器
    [self setupAllChildViewController];
}

#pragma mark - 添加子控制器
- (void)setupAllChildViewController
{
    HSAllCourseViewController *allCourse = [[HSAllCourseViewController alloc] init];
    HSSortViewController *sort = [[HSSortViewController alloc] init];
    YZMoreMenuViewController *moreMenu = [[YZMoreMenuViewController alloc] init];
    [self addChildViewController:allCourse];
    [self addChildViewController:sort];
    [self addChildViewController:moreMenu];
}

#pragma mark - YZPullDownMenuDataSource
// 返回下拉菜单多少列
- (NSInteger)numberOfColumnsInMenu:(HSPullDownMenu *)menu
{
    return 3;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(HSPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    HSMenuButton *button = [HSMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:25 /255.0 green:143/255.0 blue:238/255.0 alpha:1] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"标签-向下箭头"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateSelected];
    
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(HSPullDownMenu *)pullDownMenu childViewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(HSPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    if (index == 0) {
        return 400;
    }
    
    // 第2列 高度
    if (index == 1) {
        return 180;
    }
    
    // 第3列 高度
    return 240;
}


@end
