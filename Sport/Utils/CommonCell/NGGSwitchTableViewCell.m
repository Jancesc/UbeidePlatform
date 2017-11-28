//
//  NGGSwitchTableViewCell.m
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGSwitchTableViewCell.h"

@interface NGGSwitchTableViewCell () {
    
    __weak IBOutlet UILabel *_namelabel;
    __weak IBOutlet UILabel *_descLabel;
    __weak IBOutlet UISwitch *_switch;
}

@end
@implementation NGGSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _switch.onTintColor = NGGViceColor;
    [_switch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NGGCommonCellModel *)model {
    
    [super setModel:model];
    _namelabel.text = model.title;
    _descLabel.text = model.desc;
    
    if (model.value && [model.value isEqualToString:@"0"]) {
        
        _switch.on = NO;
    } else {
        
        _switch.on = YES;
    }
}

- (void)switchValueChanged:(UISwitch *)theSwitch {
    
    if (_valueChanged) {
        
        _valueChanged(theSwitch.on);
    }
}
@end
