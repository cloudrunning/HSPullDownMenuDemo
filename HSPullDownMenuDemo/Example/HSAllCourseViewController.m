//
//  HSAllCourseViewController.m
//  YZPullDownMenuDemo
//
//  Created by caozhen@neusoft on 16/9/5.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "HSAllCourseViewController.h"

extern NSString *HSUpdateMenuTitleNote;
static NSString *categoryCellId = @"categoryCellId";
static NSString *categoryDetailCellId = @"categoryDetailCellId";

@interface HSAllCourseViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *categoryDetailTableView;
@property (nonatomic,strong) NSString *categoryName;


@end

@implementation HSAllCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:categoryCellId];
    [self.categoryDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:categoryDetailCellId];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.categoryTableView didSelectRowAtIndexPath:indexPath];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) {
        return 5;
    }
    return 10;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellId];
        cell.textLabel.text = [NSString stringWithFormat:@"小学 %ld",(long)indexPath.row];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryDetailCellId];
    cell.textLabel.text = [NSString stringWithFormat:@"小学 %@,详情:%ld",self.categoryName, (long)indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.categoryName = cell.textLabel.text;
        [self.categoryDetailTableView reloadData];
        return;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:HSUpdateMenuTitleNote object:self userInfo:@{@"title":[NSString stringWithFormat:@"%@,详情%ld",self.categoryName,indexPath.row]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
