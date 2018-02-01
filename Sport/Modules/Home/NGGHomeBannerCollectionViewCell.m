//
//  NGGHomeBannerCollectionViewCell.m
//  sport
//
//  Created by Jan on 26/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGHomeBannerCollectionViewCell.h"
#import "PSCarouselView.h"
#import "Masonry.h"

@interface NGGHomeBannerCollectionViewCell ()<PSCarouselDelegate>

@property (weak, nonatomic) IBOutlet PSCarouselView *carouselView;
@property(nonatomic, strong) UIPageControl *pageControl;

@end

@implementation NGGHomeBannerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (_arrayOfURL) {
     
        _carouselView.imageURLs = _arrayOfURL;
    }
    self.contentView.backgroundColor = NGGRandomColor;
    _carouselView.pageDelegate = self;
    //pageControl
    _pageControl = [[UIPageControl alloc] init];
    [self.contentView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_carouselView.mas_bottom).with.offset(-7);
        make.height.mas_equalTo(10.f);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.width.mas_equalTo(60.f);
    }];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPageIndicatorTintColor = NGGViceColor;
    _pageControl.pageIndicatorTintColor = UIColorWithRGBA(0xcc, 0xcc, 0xcc, 240);
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = [_arrayOfURL count];
    _pageControl.contentMode = UIViewContentModeRight;
}

- (void)setArrayOfURL:(NSArray *)arrayOfURL {
    
    _arrayOfURL = arrayOfURL;
    _carouselView.imageURLs = arrayOfURL;
    _pageControl.numberOfPages = [arrayOfURL count];
}

#pragma mark - PSCarouselDelegate

- (void)carousel:(nonnull PSCarouselView *)carousel didMoveToPage:(NSUInteger)page {
    
        _pageControl.currentPage = page;
}

- (void)carousel:(nonnull PSCarouselView *)carousel didTouchPage:(NSUInteger)page {
    
    if(_imageTappedHandler) {
        
        _imageTappedHandler(page);
    }
}

- (void)carousel:(nonnull PSCarouselView *)carousel didDownloadImages:(nonnull UIImage *)image atPage:(NSUInteger)page {
    
}

@end
