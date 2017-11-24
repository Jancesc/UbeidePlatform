//
//  NGGDateListItemView.m
//  sport
//
//  Created by Jan on 30/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGDateListItemView.h"

@interface NGGDateListItemView () {
    
    UILabel *_titleLabel;
    UILabel *_dateLabel;
}

@end

@implementation NGGDateListItemView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        [self setup:frame];
    }
    
    return self;
}


- (void)setup:(CGRect)frame  {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, frame.size.width, 15)];
    _titleLabel.textColor = NGGColor999;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];

    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frame.size.width, 15)];
    _dateLabel.textColor = NGGColor999;
    _dateLabel.font = [UIFont systemFontOfSize:15];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dateLabel];

    _dateLabel.text = @"09/21";
    _titleLabel.text = @"今天(3)";
    
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        
        _titleLabel.textColor = NGGPrimaryColor;
        _dateLabel.textColor = NGGPrimaryColor;
    } else {
        
        _titleLabel.textColor = NGGColor999;
        _dateLabel.textColor = NGGColor999;
    }
}

@end
