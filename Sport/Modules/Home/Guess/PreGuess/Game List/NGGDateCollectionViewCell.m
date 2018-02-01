//
//  NGGDateCollectionViewCell.m
//  Sport
//
//  Created by Jan on 04/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGDateCollectionViewCell.h"
#import "JYCommonTool.h"

@interface NGGDateCollectionViewCell () {
    
    __weak IBOutlet UILabel *_weekLabel;
    __weak IBOutlet UILabel *_countLabel;
    __weak IBOutlet UILabel *_dateLabel;
}

@end

@implementation NGGDateCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(NGGGameDateModel *)model {
    
    _model = model;
    _weekLabel.text = model.dateName;
    _countLabel.text = [NSString stringWithFormat:@"(%@)", _model.count];
    if (!isStringEmpty(_model.timeStamp) && ![_model.timeStamp isEqualToString:@"0"]) {
        
        _dateLabel.text = [JYCommonTool dateFormatWithInterval:_model.timeStamp.integerValue format:@"MM/dd"];
    } else {
        
        _dateLabel.text = nil;
    }
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    _weekLabel.textColor = selected ? NGGPrimaryColor : NGGColor333;
    _countLabel.textColor = selected ? NGGPrimaryColor : NGGColor333;
    _dateLabel.textColor = selected ? NGGPrimaryColor : NGGColor333;
}

@end
