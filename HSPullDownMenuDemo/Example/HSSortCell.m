//
//  HSSortCell.m
//  YZPullDownMenuDemo
//
//  Created by caozhen@neusoft on 16/9/2.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "HSSortCell.h"

@interface HSSortCell ()
@property (nonatomic,strong) UIImageView *checkView;
@end

@implementation HSSortCell


- (UIImageView *)checkView {
    
    if (!_checkView) {
        _checkView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选中对号"]];
        self.accessoryView = _checkView;
    }
    return _checkView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkView.hidden = !selected;

}

+ (NSString *)reuseId {
    return NSStringFromClass([self class]);
}

@end
