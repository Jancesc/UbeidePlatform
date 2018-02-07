//
//  NGGDarenGameViewController.m
//  Sport
//
//  Created by Jan on 07/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameViewController.h"
#import "NGGDarenGameListViewController.h"

@interface NGGDarenGameViewController () {
    
    NGGDarenGameListViewController *_gameListViewController;
    UIView *_headerView;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation NGGDarenGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
    self.title = @"盈利达人赛";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked)];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)configueUIComponents {
    
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //        [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGSeparatorColor] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_segmentControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.tintColor = NGGSeparatorColor;
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [_segmentControl setSelectedSegmentIndex:0];
    _segmentControl.layer.borderColor = [NGGSeparatorColor CGColor];
    _segmentControl.layer.cornerRadius = 5.f;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.layer.borderWidth = 1.f;
    
    _gameListViewController = [[NGGDarenGameListViewController alloc] init];
    [self addChildViewController:_gameListViewController];
    [self.view addSubview:_gameListViewController.view];
}

- (void)segmentControlValueChanged:(UISegmentedControl *) segmentControl {
    
}

#pragma mark - button actions

- (void)leftBarButtonClicked {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        [_gameListViewController clear];
    }];
}

@end

