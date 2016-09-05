//
//  HSSortViewController.m
//  YZPullDownMenuDemo
//
//  Created by caozhen@neusoft on 16/9/2.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "HSSortViewController.h"
#import "HSSortCell.h"

extern NSString *const HSUpdateMenuTitleNote;

@interface HSSortViewController ()

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,assign) NSInteger seltColm;

@end

@implementation HSSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.seltColm = 0;
    self.titleArray = @[@"综合排序",@"人气排序",@"评价排序",@"人气最多"];
    
    [self.tableView registerClass:[HSSortCell class] forCellReuseIdentifier:[HSSortCell reuseId]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.seltColm inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HSSortCell *cell = [tableView dequeueReusableCellWithIdentifier:[HSSortCell reuseId]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.seltColm = indexPath.row;
    
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter]postNotificationName:HSUpdateMenuTitleNote object:self userInfo:@{@"title":self.titleArray[indexPath.row]}];
}

@end
