//
//  NGGGuessDetailViewController.m
//  sport
//
//  Created by Jan on 06/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGuessDetailViewController.h"
#import "Masonry.h"
#import <pop/pop.h>
#import "NGGGuessCollectionViewCell.h"
#import "NGGGuess2RowsCollectionViewCell.h"
#import "NGGDetailHeaderReusableView.h"
#import "NGGDetailAnalyseView.h"

static NSString *kGuessCellIdentifier = @"NGGGuessCollectionViewCell";
static NSString *kGuess2RowsCellIdentifier = @"NGGGuess2RowsCollectionViewCell";
static NSString *kDetailHeaderIdentifier = @"NGGDetailHeaderReusableView";

@interface NGGGuessDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    __weak IBOutlet UIButton *_guessButton;
    __weak IBOutlet UIButton *_liveButton;
    __weak IBOutlet UIButton *_analyseButton;
    __weak IBOutlet UIView *_pageSwitchTipsView;
    __weak IBOutlet UICollectionView *_collectionView;
}

@property (nonatomic, strong) UIView *analyseView;

@end

@implementation NGGGuessDetailViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)configueUIComponents {
    
    [_guessButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_liveButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_analyseButton addTarget:self action:@selector(pageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _guessButton.selected = YES;
    
    CGFloat buttonWidth = (SCREEN_WIDTH - 50) / 3.0;
    _pageSwitchTipsView.frame = CGRectMake(15, 42, buttonWidth, 3);
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGGuessCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGuessCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGGuess2RowsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGuess2RowsCellIdentifier];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGGDetailHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailHeaderIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor =UIColorWithRGB(0xea, 0xea, 0xea);
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    
    
    _analyseView = [[[NSBundle mainBundle] loadNibNamed:@"NGGDetailAnalyseView" owner:nil options:nil] lastObject];
    [self.view addSubview:_analyseView];
    [_analyseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_collectionView.mas_top);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - button actions

- (void)pageButtonClicked:(UIButton *) button {
   
    _guessButton.selected = NO;
    _liveButton.selected = NO;
    _analyseButton.selected = NO;
    button.selected = YES;
    
    //红线的移动动画
    CGFloat buttonWidth = (SCREEN_WIDTH - 50) / 3.0;
    CGRect fromRect = _pageSwitchTipsView.frame;
    CGRect toRect = CGRectMake(15 + (buttonWidth + 10) * button.tag, 42, buttonWidth, 3);
    
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    basicAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    basicAnimation.toValue =  [NSValue valueWithCGRect:toRect];
    [_pageSwitchTipsView pop_addAnimation:basicAnimation forKey:@"move"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;
}
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
        if (section == 0) {
            
            return 3;
        } else if (section == 1) {
            
            return 2;
        } else if (section == 2) {
            
            return 8;
        } else if (section == 3) {
            
            return 3;
        }
    return 0;
}
    
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.section == 2) {
            
            NGGGuess2RowsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuess2RowsCellIdentifier forIndexPath:indexPath];
            return cell;
        } else if (indexPath.section == 1  || indexPath.section == 0 || indexPath.section == 3) {
          
            NGGGuessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuessCellIdentifier forIndexPath:indexPath];
            return cell;
        }
        return nil;
    }
    
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        NGGDetailHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailHeaderIdentifier forIndexPath:indexPath];
        return view;
    }
    return nil;
}
    
#pragma mark - UICollectionViewDelegateFlowLayout
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return CGSizeMake((SCREEN_WIDTH - 40) / 3.0, 40);
    }
    else if (indexPath.section == 1)
    {
        return CGSizeMake((SCREEN_WIDTH - 35) / 2.0, 40);
    }
    else if (indexPath.section == 2)
    {
        return CGSizeMake((SCREEN_WIDTH - 45) / 4.0, 40);
    }
    else if (indexPath.section == 3) {
        return CGSizeMake((SCREEN_WIDTH - 40) / 3.0, 40);
    }
    return CGSizeMake(SCREEN_WIDTH, 0);
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

        return CGSizeMake(SCREEN_WIDTH, 40);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
   
    return CGSizeMake(SCREEN_WIDTH, 0);
}
    
    
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
    
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
        //    NSInteger section = indexPath.section;
        //    NSInteger item = indexPath.item;
        //    NSDictionary *selectedCity = nil;
        //    if (section == 2) {
        //        selectedCity = [_arrayOfRecentCities objectAtIndex:item];
        //    }
        //    else if (section == 3)
        //    {
        //        selectedCity = [_arrayOfServingCities objectAtIndex:item];
        //    }
        //
        //    [self handleSelectCity:selectedCity];
    }

@end
