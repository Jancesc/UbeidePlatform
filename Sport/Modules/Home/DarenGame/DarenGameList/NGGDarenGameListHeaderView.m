//
//  NGGDarenGameListHeaderView.m
//  Sport
//
//  Created by Jan on 08/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameListHeaderView.h"
#import "UIImageView+WebCache.h"

@interface NGGDarenGameListHeaderView() {
    
    __weak IBOutlet UIImageView *_avatarLogo;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_countLabel;
    __weak IBOutlet UIButton *_recordButton;
}
@end

@implementation NGGDarenGameListHeaderView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    [_recordButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0x23, 0x4d, 0xf1)] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _recordButton.layer.cornerRadius = 4.f;
    _recordButton.clipsToBounds = YES;
}

- (void)setCount:(NSString *)count {
    
    _count = count;
    _countLabel.text = [NSString stringWithFormat:@"参赛场次:%@", _count];
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    [_avatarLogo sd_setImageWithURL:[NSURL URLWithString:currentUser.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _nameLabel.text = currentUser.nickname;
    
}

#pragma mark - button actions

- (void)recordButtonClicked:(UIButton *) button {
    
    if (_recordButtonHandler) {
        
        _recordButtonHandler();
    }
}




@end
