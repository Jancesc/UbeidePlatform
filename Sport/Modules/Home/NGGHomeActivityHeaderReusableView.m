//
//  NGGHomeActivityHeaderReusableView.m
//  sport
//
//  Created by Jan on 27/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGHomeActivityHeaderReusableView.h"

@interface NGGHomeActivityHeaderReusableView () {
    
    __weak IBOutlet UIButton *_allButton;
    
}


@end
@implementation NGGHomeActivityHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_allButton addTarget:self action:@selector(allButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)allButtonClicked:(UIButton *)button {
    
    if (_allButtonHandler) {
        
        _allButtonHandler();
    }
    
}

@end
