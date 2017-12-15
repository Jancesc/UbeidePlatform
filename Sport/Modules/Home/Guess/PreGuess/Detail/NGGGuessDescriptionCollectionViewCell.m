//
//  NGGGuessDescriptionCollectionViewCell.m
//  Sport
//
//  Created by Jan on 13/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessDescriptionCollectionViewCell.h"

@interface NGGGuessDescriptionCollectionViewCell () {
    
    __weak IBOutlet UILabel *_titleLabel;
}

@end
@implementation NGGGuessDescriptionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NGGGuessItemModel *)model {
    
    _model = model;
    _titleLabel.text = model.title;
}
@end
