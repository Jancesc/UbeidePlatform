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
    
    
    if ([model.title containsString:@"("] && [model.title containsString:@")" ]) {
        
        NSMutableAttributedString *mAttrString = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : NGGColor333}];
        
       if ([model.title containsString:@"+"]) {
            
            NSRange range = [model.title rangeOfString:@"+"];
            NSRange colorRange = NSMakeRange(range.location, model.title.length - range.location -1);
            [mAttrString addAttribute:NSForegroundColorAttributeName value:NGGThirdColor range:colorRange];
        } else  if ([model.title containsString:@"-"]){
            
            NSRange range = [model.title rangeOfString:@"-"];
            NSRange colorRange = NSMakeRange(range.location,  model.title.length - range.location -1);
            [mAttrString addAttribute:NSForegroundColorAttributeName value:NGGPrimaryColor range:colorRange];
        }
        _titleLabel.attributedText = [mAttrString copy];

        } else {
            _titleLabel.attributedText = nil;
            _titleLabel.text = model.title;

        }
    _descriptionLabel.text = model.detail;
}

@end
