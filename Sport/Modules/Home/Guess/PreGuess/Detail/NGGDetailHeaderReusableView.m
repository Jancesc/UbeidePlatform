//
//  NGGDetailHeaderReusableView.m
//  Sport
//
//  Created by Jan on 08/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGDetailHeaderReusableView.h"

@interface NGGDetailHeaderReusableView () {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_descriptionLabel;
}

@end

@implementation NGGDetailHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NGGGuessSectionModel *)model {
    
    _model = model;
    
    _titleLabel.text = model.title;
    _descriptionLabel.text = model.detail;
}

@end
