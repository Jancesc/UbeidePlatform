//
//  NGGGuessOrderView.m
//  Sport
//
//  Created by Jan on 13/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessOrderView.h"
#import "ZSBlockAlertView.h"

@interface NGGGuessOrderView () {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_oddsLabel;
    __weak IBOutlet UILabel *_sectionLabel;
    __weak IBOutlet UILabel *_beanLabel;
    __weak IBOutlet UILabel *_profitLabel;
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UIButton *_clearButton;
    __weak IBOutlet UIButton *_confirmButton;
    __weak IBOutlet UIButton *_10Button;
    __weak IBOutlet UIButton *_100Button;
    __weak IBOutlet UIButton *_1000Button;
    __weak IBOutlet UIButton *_10000Button;
    __weak IBOutlet UIButton *_allInButton;
    __weak IBOutlet UIButton *_closeButton;
}

@property (nonatomic, strong) NGGGuessItemModel *itemModel;
@property (nonatomic, strong) NGGGuessSectionModel *sectionModel;

@end
@implementation NGGGuessOrderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [_clearButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0xe0, 0x3f,0x40)] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0x5c, 0x5e,0x66)] forState:UIControlStateNormal];
    [_10Button setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_100Button setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_1000Button setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_10000Button setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_allInButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
   
    [_10Button addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_100Button addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_1000Button addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_10000Button addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_allInButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    ZSBlockAlertView *alert = [[ZSBlockAlertView alloc] initWithTitle:@"提示" message:@"金豆不足，无法完成投注，请充值" cancelButtonTitle:@"取消" otherButtonTitles:@[@"充值"]];
    [alert setClickHandler:^(NSInteger index) {
       
        if (index == 0) {
           
            NSLog(@"0");
        } else {
            
            NSLog(@"%ld", index);
        }
    }];
    [alert show];
    _textField.userInteractionEnabled = NO;

}
- (void) updateWithItemModel:(NGGGuessItemModel *)itemModel sectionModel:(NGGGuessSectionModel *)sectionModel {
    
    _itemModel = itemModel;
    _sectionModel = sectionModel;
    
    _titleLabel.text = itemModel.title;
    _oddsLabel.text = itemModel.odds;
    _sectionLabel.text = [NSString stringWithFormat:@"(%@)", _sectionModel.title];
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    _beanLabel.text = [NSString stringWithFormat:@"剩余：%@金豆", currentUser.bean];
    _profitLabel.text = [NSString stringWithFormat:@"预计盈利：0"];
    _textField.text = nil;
}

#pragma mark - button actions

- (void)orderButtonClicked:(UIButton *) button {
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    CGFloat becnCount = currentUser.bean.floatValue;
   
    CGFloat orderCount = button.tag;
    if ([button.currentTitle isEqualToString: @"All in"]) {
        
        orderCount = becnCount;
    }

    if (orderCount < becnCount) {//金豆不足
        
        ZSBlockAlertView *alert = [[ZSBlockAlertView alloc] initWithTitle:@"提示" message:@"金豆不足，无法完成投注，请充值" cancelButtonTitle:@"取消" otherButtonTitles:@[@"充值"]];
        [alert show];
    }
}

- (void)rechargeButtonClicked {
    
}
@end
