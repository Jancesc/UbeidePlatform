//
//  NGGModifyNicknameViewController.m
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModifyNicknameViewController.h"

@interface NGGModifyNicknameViewController () {
    
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UILabel *_countLabel;
    __weak IBOutlet UIButton *_confirmButton;
    
}

@end

@implementation NGGModifyNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改昵称";
    
    [self configueUIComponents];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(handleBackButtonClicked:)];
}

- (void)configueUIComponents {
    
    _textField.tintColor = NGGPrimaryColor;
    [_textField addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    _confirmButton.layer.cornerRadius = 5.f;
    _confirmButton.clipsToBounds = YES;
    [_confirmButton addTarget:self action:@selector(handleConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_textField resignFirstResponder];
}

- (void)textField1TextChange:(UITextField *)textField{
    
    if (_textField.text.length > _maxCount) {
        
        _textField.text = [_textField.text substringToIndex:_maxCount];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"剩余%ld/%ld",_maxCount - _textField.text.length, _maxCount];
    
}

#pragma mark - button actions

- (void)handleConfirmButtonClicked:(UIButton *)button {
    
    if (_textField.text == 0) {
        
        [self showErrorHUDWithText:@"昵称不能为空!"];
    }
    if (_completion) {
        
        [_textField resignFirstResponder];
        _completion(_textField.text);
    }
}

- (void)handleBackButtonClicked:(UIButton *) button {
    
    [_textField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
