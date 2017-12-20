//
//  NGGTaskLotteryViewController.m
//  Sport
//
//  Created by Jan on 11/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGTaskLotteryViewController.h"

@interface NGGTaskLotteryViewController () {
    
    __weak IBOutlet UIButton *_closeButton;
    
}

@end

@implementation NGGTaskLotteryViewController

#pragma mark - view life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configueUIComponents {
 
    [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - button actions

- (void)closeButtonClicked:(UIButton *) button {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
