//
//  NGGExchangeViewController.m
//  Sport
//
//  Created by Jan on 28/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGExchangeViewController.h"

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

@end

@implementation NGGExchangeViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
    
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
    _textField.layer.borderColor = [UIColorWithRGB(0xe0, 0xe0, 0xe0) CGColor];
    _textField.layer.borderWidth = 1.f;
    _textField.background= [UIImage imageWithColor:[UIColor whiteColor]];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [_exchangeButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_exchangeButton addTarget:self action:@selector(exchangeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configueButton:(UIButton *)button {
    
    [button setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0xe0,0xe0 , 0xe0)] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0xea,0xea , 0xea)] forState:UIControlStateHighlighted];

    button.layer.cornerRadius = 4.f;
    button.layer.masksToBounds = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_textField resignFirstResponder];
}

#pragma mark - button actions

- (void)exchangeButtonClicked:(UIButton *) button {
    
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
