//
//  NGGGuess2RowsCollectionViewCell.m
//  Sport
//
//  Created by Jan on 08/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuess2RowsCollectionViewCell.h"

@interface NGGGuess2RowsCollectionViewCell() {
    
    __weak IBOutlet UILabel *_aboveLabel;
    __weak IBOutlet UILabel *_bottomLabel;

    
}
@end

@implementation NGGGuess2RowsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
}

@end
