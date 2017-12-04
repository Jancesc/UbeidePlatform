//
//  NGGDateListItemView.m
//  sport
//
//  Created by Jan on 30/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGDateListItemView.h"
#import "JYCommonTool.h"

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
    _titleLabel.textColor = NGGColor333;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];

    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frame.size.width, 15)];
    _dateLabel.textColor = NGGColor333;
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dateLabel];


}

- (void)setModel:(NGGGameDateModel *)model {

    _model = model;

    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)", model.dateName, model.count];
    if (!isStringEmpty(_model.timeStamp)) {
        
        _dateLabel.text = [JYCommonTool dateFormatWithInterval:_model.timeStamp.integerValue format:@"MM/dd"];
    }
    
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        
        _titleLabel.textColor = NGGPrimaryColor;
        _dateLabel.textColor = NGGPrimaryColor;
    } else {
        
        _titleLabel.textColor = NGGColor333;
        _dateLabel.textColor = NGGColor333;
    }
}

@end
