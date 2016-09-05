//
//  HSMenuButton.m
//  YZPullDownMenuDemo
//
//  Created by caozhen@neusoft on 16/9/5.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "HSMenuButton.h"

@implementation HSMenuButton

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect titleLabelRect = self.titleLabel.frame;
    CGRect imageViewRect = self.imageView.frame;
    if (imageViewRect.origin.x < titleLabelRect.origin.x) {
    
        titleLabelRect.origin.x = imageViewRect.origin.x;
        self.titleLabel.frame = titleLabelRect;
        
        imageViewRect.origin.x = titleLabelRect.origin.x + titleLabelRect.size.width + 10;
        self.imageView.frame = imageViewRect;
   
    }
}

@end
