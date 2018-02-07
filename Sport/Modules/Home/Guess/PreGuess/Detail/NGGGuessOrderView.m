//
//  NGGGuessOrderView.m
//  Sport
//
//  Created by Jan on 13/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessOrderView.h"
#import "ZSBlockAlertView.h"
#import "SCLAlertView.h"
#import "JYCommonTool.h"
#import "SVProgressHUD.h"

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
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:NGGThirdColor] forState:UIControlStateNormal];
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
  
    [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_clearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _textField.userInteractionEnabled = NO;

}
- (void) updateWithItemModel:(NGGGuessItemModel *)itemModel sectionModel:(NGGGuessSectionModel *)sectionModel {
    
    _itemModel = itemModel;
    _sectionModel = sectionModel;
    
    _titleLabel.text = itemModel.title;
    _oddsLabel.text = [NSString stringWithFormat:@"@%@", itemModel.odds];
    _sectionLabel.text = [NSString stringWithFormat:@"(%@)", _sectionModel.title];
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    _beanLabel.text = [NSString stringWithFormat:@"剩余：%@ 金豆", currentUser.bean];
    _profitLabel.text = [NSString stringWithFormat:@"预计盈利：0"];
    _textField.text = nil;
}

- (void)showMakeOrderAlert {
    
    SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];
    [alertView setHorizontalButtons:YES];
    alertView.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    SCLButton *closeButton = [alertView addButton:@"取消" actionBlock:^{
        
    }];
    closeButton.buttonFormatBlock = ^NSDictionary* (void) {
        
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = UIColorWithRGB(0x72, 0x73, 0x75);
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        buttonConfig[@"font"] = [UIFont boldSystemFontOfSize:14.f];
        return buttonConfig;
    };
    
    SCLButton *guessButton = [alertView addButton:@"投注" actionBlock:^{
        
        if (_delegate && [_delegate respondsToSelector:@selector(guessOrderViewMakeOrder:itemModel:sectionModel:)]) {
            
            [_delegate guessOrderViewMakeOrder:_textField.text itemModel:_itemModel sectionModel:_sectionModel];
        }
    }];
    guessButton.buttonFormatBlock = ^NSDictionary* (void) {
        
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = NGGViceColor;
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        buttonConfig[@"font"] = [UIFont boldSystemFontOfSize:14.f];
        return buttonConfig;
    };
    
    alertView.attributedFormatBlock = ^NSAttributedString* (NSString *value) {
        
        NSMutableAttributedString *subTitleAttr = [[NSMutableAttributedString alloc] initWithString:value];
        [subTitleAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, value.length)];
        
        NSString *tmpString = [[value componentsSeparatedByString:@"金豆"] firstObject];
        NSString *valueString = [[tmpString componentsSeparatedByString:@"即将投注"] lastObject];
        
        NSRange range = [value rangeOfString:valueString options:NSCaseInsensitiveSearch];
        [subTitleAttr addAttribute:NSForegroundColorAttributeName value:NGGViceColor range:range];
        [subTitleAttr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:range];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        style.paragraphSpacing = 5.f;
        [subTitleAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, value.length)];
        return subTitleAttr;
    };
    
    NSString *subTitleString = [NSString stringWithFormat:@"即将投注%@金豆\n系统将在20秒内确认是否投注成功",_textField.text];
    [alertView showNotice:@"投注确认" subTitle:subTitleString closeButtonTitle:nil duration:0.0];
}

#pragma mark - button actions

- (void)orderButtonClicked:(UIButton *) button {
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    CGFloat becnCount = currentUser.bean.floatValue;
    if (becnCount == 0) {
        
        ZSBlockAlertView *alert = [[ZSBlockAlertView alloc] initWithTitle:@"提示" message:@"金豆不足，无法完成投注，请充值" cancelButtonTitle:@"取消" otherButtonTitles:@[@"充值"]];
        [alert setClickHandler:^(NSInteger index) {
            
            if (index == 1) {
                
                [self rechargeButtonClicked];
            }
        }];
        [alert show];
        return;
    }
    
    CGFloat orderCount = button.tag;
    if (_textField.text) {
        
        orderCount = orderCount + _textField.text.floatValue;
    }
    
    if ([button.currentTitle isEqualToString: @"All in"]) {
        
        orderCount = becnCount;
    }

    if (orderCount > becnCount) {//金豆不足
        
        ZSBlockAlertView *alert = [[ZSBlockAlertView alloc] initWithTitle:@"提示" message:@"金豆不足，无法完成投注，请充值" cancelButtonTitle:@"取消" otherButtonTitles:@[@"充值"]];
        [alert setClickHandler:^(NSInteger index) {
            
            if (index == 1) {
                
                [self rechargeButtonClicked];
            }
        }];
        [alert show];
        return;
    }

    if (orderCount > 50000) {
        orderCount = 50000;
        [SVProgressHUD showErrorWithStatus:@"最高投注50000"];
    }
    _textField.text = @(orderCount).stringValue;
    CGFloat profit = orderCount * _itemModel.odds.doubleValue;
    _profitLabel.text = [NSString stringWithFormat:@"预计盈利：%@", [JYCommonTool stringDisposeWithFloat:profit]];

}

- (void)rechargeButtonClicked {
    
    if (_delegate  && [_delegate respondsToSelector:@selector(guessOrderViewDidClickRechargeButton)]) {
        
        [_delegate guessOrderViewDidClickRechargeButton];
    }
}

- (void)closeButtonClicked:(UIButton *) button {
    
    self.hidden = YES;
}

- (void)clearButtonClicked:(UIButton *) button {
 
    _textField.text = nil;
    _profitLabel.text = [NSString stringWithFormat:@"预计盈利：0"];
}

- (void)confirmButtonClicked:(UIButton *) button {
    
    if (isStringEmpty(_textField.text)) {
        
        [SVProgressHUD showErrorWithStatus:@"请先输入投注金额"];
        return;
    }
    [self showMakeOrderAlert];
}

- (NGGGuessItemModel *) currentItemModel {
    
    return _itemModel;
}
@end
