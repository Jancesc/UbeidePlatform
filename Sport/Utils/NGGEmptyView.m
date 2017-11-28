//
//  NGGEmptyView.m
//  Sport
//
//  Created by Jan on 28/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGEmptyView.h"

@interface NGGEmptyView () {
    
    UIImageView *_imageView;
    UILabel *_label;
}

@end

@implementation NGGEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configueUIComponents];
    }
    return self;
}

- (void)configueUIComponents {
    
    CGFloat contentHeight = 170;
    CGFloat imageHeight = 130;

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.5 * (VIEW_H(self) - contentHeight), VIEW_W(self), imageHeight)];
    _imageView.image = [UIImage imageNamed:@"empty"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_BRY(_imageView),  VIEW_W(self), contentHeight - imageHeight)];
    _label.font = [UIFont systemFontOfSize:18.f];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = NGGColor666;
    _label.text = @"暂无数据";
    [self addSubview:_label];
}
@end
