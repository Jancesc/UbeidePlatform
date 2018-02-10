//
//  NGGDarenGameViewController.m
//  Sport
//
//  Created by Jan on 07/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameViewController.h"
#import "NGGDarenGameListViewController.h"
#import "NGGDarenGameResultViewController.h"
#import "NGGDarenGameRankViewController.h"

@interface NGGDarenGameViewController () {
    
    NGGDarenGameListViewController *_gameListViewController;
    NGGDarenGameResultViewController *_resultViewController;
    NGGDarenGameRankViewController *_gameRankController;

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (_segmentControl.selectedSegmentIndex == 0) {
        
        [_gameListViewController loadData];
    }
}

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
    _gameRankController = [NGGDarenGameRankViewController new];
    _resultViewController = [NGGDarenGameResultViewController new];
    
    [self addChildViewController:_gameListViewController];
    [self.view addSubview:_gameListViewController.view];
    
}

- (void)segmentControlValueChanged:(UISegmentedControl *) segmentControl {
    
    switch (segmentControl.selectedSegmentIndex) {
        case 0: {
            
                if (_resultViewController.parentViewController) {
                    
                    [_resultViewController removeFromParentViewController];
                    [_resultViewController.view removeFromSuperview];
                }
                if (_gameRankController.parentViewController) {
                    
                    [_gameRankController removeFromParentViewController];
                    [_gameRankController.view removeFromSuperview];
                }
                [self addChildViewController:_gameListViewController];
                [self.view addSubview:_gameListViewController.view];

                break;
            }
        case 1: {
            
            if (_gameListViewController.parentViewController) {
              
                [_gameListViewController removeFromParentViewController];
                [_gameListViewController.view removeFromSuperview];
            }
            if (_gameRankController.parentViewController) {
                
                [_gameRankController removeFromParentViewController];
                [_gameRankController.view removeFromSuperview];
            }
            
            [self addChildViewController:_resultViewController];
            [self.view addSubview:_resultViewController.view];
            break;
        }
        case 2: {
            
            if (_gameListViewController.parentViewController) {
                
                [_gameListViewController removeFromParentViewController];
                [_gameListViewController.view removeFromSuperview];
            }
            if (_resultViewController.parentViewController) {
                
                [_resultViewController removeFromParentViewController];
                [_resultViewController.view removeFromSuperview];
            }
            
            [self addChildViewController:_gameRankController];
            [self.view addSubview:_gameRankController.view];
            break;
            
        }
        default:
            break;
    }
}

#pragma mark - button actions

- (void)leftBarButtonClicked {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        [_gameListViewController clear];
    }];
}

@end

