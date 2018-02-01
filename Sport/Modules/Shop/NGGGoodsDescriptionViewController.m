//
//  NGGGoodsDescriptionViewController.m
//  Sport
//
//  Created by Jan on 27/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGoodsDescriptionViewController.h"
#import "PSCarouselView.h"

@interface NGGGoodsDescriptionViewController ()<PSCarouselDelegate> {
    
    __weak IBOutlet PSCarouselView *_carouselView;
    
    __weak IBOutlet UITextView *_textView;
}

@property (nonatomic, strong) NSDictionary *detailInfo;

@end

@implementation NGGGoodsDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"物品信息";
    [self loadDescription];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDescription {
    
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=goods.goodsDetail" parameters:@{@"goods_id" : _goodsID} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self dismissHUD];
        NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
            
            [self showErrorHUDWithText:msg];
        }];
        if (dict) {
            
            _detailInfo = dict;
            [self refreshUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

- (void)configueUIComponents {
    
    _carouselView.pageDelegate = self;
    _textView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
    _textView.contentOffset = CGPointMake(-200, -200);
    _textView.editable = NO;
}

- (void)refreshUI {
    
//    "goods_id": "1",
//    "cid": "4",
//    "goods_name": "20元充值卡",
//    "goods_pic": "http://wx7.bigh5.com/fb/web/uploads/1711/081011231434.png",
//    "goods_explain": "",
//    "need_bean": "2500"
    
    _carouselView.imageURLs = @[[_detailInfo stringForKey:@"goods_pic"]];
    
    NSMutableAttributedString *mAttributedString = [NSMutableAttributedString new];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 16.f;
    style.lineSpacing = 3.f;
    style.paragraphSpacing = 5.f;
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:[_detailInfo stringForKey:@"goods_name"] attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName : NGGColor333, NSParagraphStyleAttributeName : style}];
    
    NSAttributedString *contentAttributedString = [[NSAttributedString alloc] initWithString:[_detailInfo stringForKey:@"goods_explain"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : NGGColor333, NSParagraphStyleAttributeName : style}];
    
    [mAttributedString appendAttributedString:titleAttributedString];
    [mAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [mAttributedString appendAttributedString:contentAttributedString];
    _textView.attributedText = [mAttributedString copy];

}
@end
