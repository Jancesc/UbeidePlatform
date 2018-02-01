//
//  NGGExchangeViewController.m
//  Sport
//
//  Created by Jan on 28/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGExchangeViewController.h"
#import "JYCommonTool.h"
#import "ZSBlockAlertView.h"
#import "NGGRechargeViewController.h"

@interface NGGExchangeViewController ()<UITextFieldDelegate> {
    
    __weak IBOutlet UILabel *_paymentLabel;
    __weak IBOutlet UILabel *_balanceLabel;
    __weak IBOutlet UIButton *_button_0;
    __weak IBOutlet UIButton *_button_1;
    __weak IBOutlet UIButton *_button_2;
    __weak IBOutlet UIButton *_button_3;
    __weak IBOutlet UIButton *_button_4;
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UIButton *_exchangeButton;
}

@property (nonatomic, assign) CGFloat coinCount;

@end

@implementation NGGExchangeViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
    [self refreshUI];
    self.title = @"金豆兑换";
    //监听键盘
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}
#pragma mark - private methods

- (void)configueUIComponents {
    
    self.view.backgroundColor = NGGGlobalBGColor;
    [self configueButton:_button_0];
    [self configueButton:_button_1];
    [self configueButton:_button_2];
    [self configueButton:_button_3];
    [self configueButton:_button_4];
    
    _textField.layer.cornerRadius = 4.f;
    _textField.clipsToBounds = YES;
    _textField.layer.borderColor = [NGGSeparatorColor CGColor];
    _textField.layer.borderWidth = 1.f;
    _textField.background= [UIImage imageWithColor:[UIColor whiteColor]];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];

    [_exchangeButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_exchangeButton addTarget:self action:@selector(exchangeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    _coinCount = currentUser.coin.floatValue;
}

- (void)configueButton:(UIButton *)button {
    
    [button setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0xe0,0xe0 , 0xe0)] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0xea,0xea , 0xea)] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 4.f;
    button.layer.masksToBounds = YES;
    
    [button addTarget:self action:@selector(beanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_textField resignFirstResponder];
}

- (void)refreshUI {
    
    _balanceLabel.text = [NSString stringWithFormat:@"(账户余额%@)", [JYCommonTool stringDisposeWithFloat:_coinCount]];
    
    if (_coinCount == 1) {
        
        ZSBlockAlertView *alertView = [[ZSBlockAlertView alloc] initWithTitle:nil message:@"金币不足无法兑换金豆，请充值金币后兑换" cancelButtonTitle:@"取消" otherButtonTitles:@[@"充值"]];
        [alertView setClickHandler:^(NSInteger index) {
            
            if (index == 1) {
           
                NGGRechargeViewController *controller = [[NGGRechargeViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];
        [alertView show];
    }
    
    NSArray *buttonaArray = @[_button_0, _button_1, _button_2, _button_3, _button_4];
    for (UIButton *button in buttonaArray) {
        
        button.enabled =  button.tag <= _coinCount * 100;
      
        
    }
}

- (void)textField1TextChange:(UITextField *)textField{
    
    NSString *payCount = [JYCommonTool stringDisposeWithFloat:_textField.text.floatValue * 0.01];
    _paymentLabel.text = [NSString stringWithFormat:@"支付金币:%@", payCount];
}
#pragma mark - button actions

- (void)exchangeButtonClicked:(UIButton *) button {
    
    NSString *payCount = nil;
    if (!isStringEmpty(_textField.text)) {
      
        payCount = [JYCommonTool stringDisposeWithFloat:_textField.text.floatValue * 0.01];
    } else {
        
        payCount = [[_paymentLabel.text componentsSeparatedByString:@":"] lastObject];
    }
    
    if ([payCount containsString:@"."]) {
        
        [self showErrorHUDWithText:@"请输入100倍数的金豆"];
        return;
    } else if (payCount.floatValue > _coinCount) {
        
        ZSBlockAlertView *alertView = [[ZSBlockAlertView alloc] initWithTitle:nil message:@"金币不足无法兑换金豆，请充值金币后兑换" cancelButtonTitle:@"取消" otherButtonTitles:@[@"充值"]];
        [alertView setClickHandler:^(NSInteger index) {
            
            if (index == 1) {
                
                NGGRechargeViewController *controller = [[NGGRechargeViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];
        [alertView show];
    }
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=user.exchangeBean" parameters:@{@"bean" : @(payCount.integerValue * 100)} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        BOOL success = [self noData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (success) {
            
            [self showAlertText:@"恭喜你，兑换成功!" completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
        [self dismissHUD];
    }];
}


- (void)beanButtonClicked:(UIButton *) button {
    
    [self.view endEditing:YES];
    _textField.text = nil;
    NSInteger payCount = button.tag * 0.01;
    
    _paymentLabel.text = [NSString stringWithFormat:@"支付金币:%ld", (long)payCount];
}
#pragma mark - Keyboard Notification

- (void) handleKeyboardWillShow:(NSNotification *) notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSInteger curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    float duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
        self.view.bounds = CGRectMake(0, 150, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void) handleKeyboardWillHide:(NSNotification *) notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSInteger curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    float duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0 options:curve << 16 animations:^{
        self.view.bounds = SCREEN_BOUNDS;
    } completion:^(BOOL finished) {
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_textField resignFirstResponder];
    return YES;
}
@end
