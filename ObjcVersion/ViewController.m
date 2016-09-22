//
//  ViewController.m
//  ObjcVersion
//
//  Created by 徐开源 on 16/9/21.
//  Copyright © 2016年 徐开源. All rights reserved.
//

#import "ViewController.h"


# pragma mark - 从 NSArray 中取 CGFloat
@interface NSArray (SubCGFloat)
-(CGFloat)subscriptValueToCGFloat:(int)subscript;
@end
@implementation NSArray (SubCGFloat)
-(CGFloat)subscriptValueToCGFloat:(int)subscript {
    NSNumber* num = self[subscript];
    return [num floatValue];
}
@end



double const animationDuration = 0.8;
CGFloat const animationDamping = 0.7;
CGFloat const animationSpringVelocity = 1;


@interface ViewController ()

@property(nonatomic, strong) UIScrollView *scrollTitleView;
@property(nonatomic, strong) UIScrollView *scrollContentView;
@property(nonatomic, strong) NSArray *labelTexts;
@property(nonatomic, strong) NSArray *labelWidths;
@property(nonatomic, strong) NSMutableArray *labels;
@property(nonatomic, strong) UIView *indicator; // label 下方的深蓝色横条

@property(nonatomic, strong) UIColor *selectedTextColor;
@property(nonatomic, strong) UIColor *unselectedTextColor;
@property(nonatomic, strong) UIColor *lightBlueColor;
@property(nonatomic, strong) UIColor *darkBlueColor;

@end


@implementation ViewController

# pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _labelTexts = @[@"iPod",@"iPad",@"iPhone",@"iMac",@"MacBook",@"Mac mini",@"Mac Pro"];
    _labelWidths = @[@34,@33,@53,@37,@72,@69,@63];
    _labels = [[NSMutableArray alloc] init];
    
    _selectedTextColor = [UIColor whiteColor];
    _unselectedTextColor = [UIColor lightGrayColor];
    _lightBlueColor = [UIColor colorWithRed:0.23 green:0.51 blue:0.85 alpha:1.00];
    _darkBlueColor = [UIColor colorWithRed:0.04 green:0.31 blue:0.62 alpha:1.00];
    
    // 配置 ScrollView
    CGFloat scrollTitleHeight = 60;
    _scrollTitleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollTitleHeight)];
    _scrollContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollTitleHeight, self.view.frame.size.width, self.view.frame.size.height-scrollTitleHeight)];
    _scrollTitleView.backgroundColor = _lightBlueColor;
    _scrollContentView.pagingEnabled = YES;
    _scrollTitleView.showsHorizontalScrollIndicator = NO;
    _scrollContentView.showsHorizontalScrollIndicator = NO;
    
    _scrollTitleView.delegate = self;
    _scrollContentView.delegate = self;
    
    [self.view addSubview:_scrollTitleView];
    [self.view addSubview:_scrollContentView];
    
    // 可滑动顶部标题
    const CGFloat leftMargin = 15;
    const CGFloat topMargin = 30;
    const CGFloat labelHeight = 20;
    const CGFloat indicatorHeight = 5;
    CGFloat originX = 0;
    
    for (int i = 0; i < _labelTexts.count; i++) {
        if (_labelTexts.count != _labelWidths.count) {
            break;
        }
        CGFloat w = [_labelWidths subscriptValueToCGFloat:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX+leftMargin, topMargin, w, labelHeight)];
        originX += 30 + w;
        NSString *text = _labelTexts[i];
        label.text =  text;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        [label setUserInteractionEnabled:YES];
        label.textColor = _unselectedTextColor;
        if (i == 0) {
            label.textColor = _selectedTextColor;
        }
        
        // 点击事件
        SEL sel = @selector(lableTapped0);
        switch (i) {
            case 1:
                sel = @selector(lableTapped1);
                break;
            case 2:
                sel = @selector(lableTapped2);
                break;
            case 3:
                sel = @selector(lableTapped3);
                break;
            case 4:
                sel = @selector(lableTapped4);
                break;
            case 5:
                sel = @selector(lableTapped5);
                break;
            case 6:
                sel = @selector(lableTapped6);
                break;
            default:
                break;
        }
        [label addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:sel]];
        
        [_labels addObject:label];
        [_scrollTitleView addSubview:label];
    }
    
    _indicator = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, topMargin+labelHeight+indicatorHeight, [_labelWidths subscriptValueToCGFloat:0], indicatorHeight)];
    _indicator.backgroundColor = _darkBlueColor;
    [_scrollTitleView addSubview:_indicator];
    _scrollTitleView.contentSize = CGSizeMake(originX, 0);
    
    
    // 可滑动内容
    originX = 0;
    
    for (int i = 0; i < _labelTexts.count; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 0, self.view.frame.size.width, self.view.frame.size.height-scrollTitleHeight)];
        NSString *imageName = _labelTexts[i];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if ([imageName  isEqual: @"iPad"]) {
            imageView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
        }else if ([imageName  isEqual: @"iPhone"]) {
            imageView.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1.00];
        }else if ([imageName  isEqual: @"MacBook"]) {
            imageView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
        }else if ([imageName  isEqual: @"Mac Pro"]) {
            imageView.backgroundColor = [UIColor blackColor];
        }else {
            imageView.backgroundColor = [UIColor whiteColor];
        }
        originX += self.view.frame.size.width;
        
        [_scrollContentView addSubview:imageView];
    }
    _scrollContentView.contentSize = CGSizeMake(originX, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - 监测内容滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _scrollContentView) { return; }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat screenWidth = self.view.frame.size.width;
    
    int index = (offsetX + screenWidth/2)/screenWidth; // Current Page Index When Scroll
    int min = (int)(ceil( offsetX/screenWidth )) - 1; // Left Page Index When Scroll
    int max = min + 1; // Right Page Index When Scroll
    
    CGFloat mid = offsetX/screenWidth; // Scroll Point
    
    // 改变标题 Label 颜色
    for (UILabel *label in _labels) {
        
        if (min < 0) {
            min = 0;
            self.view.backgroundColor = [UIColor whiteColor]; // iPod Image BgColor
        }
        
        if (max >= _labelTexts.count) {
            max = (int)_labelTexts.count - 1;
            self.view.backgroundColor = [UIColor blackColor]; // Mac Pro Image BgColor
        }
        
        if ([label.text isEqualToString:_labelTexts[min]]) {
            if (min == max) {
                label.textColor = [UIColor whiteColor];
            }else {
                label.textColor = [UIColor colorWithWhite:0.67 + 0.33*(max-mid) alpha:1.00];
            }
        }else if ([label.text isEqualToString:_labelTexts[max]]) {
            label.textColor = [UIColor colorWithWhite:0.67 + 0.33*(mid-min) alpha:1.00];
        }else {
            label.textColor = _unselectedTextColor;
        }
    }
    
    // 改变 indicator 横条的位置和长度
    for (UILabel *label in _labels) {
        if (index >= _labelTexts.count) { return; }
        
        if ([label.text isEqualToString:_labelTexts[index]]) {
            [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:animationDamping
                  initialSpringVelocity:animationSpringVelocity options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                      
                      self.indicator.frame = CGRectMake(label.frame.origin.x, // same position with the selected label
                                                        self.indicator.frame.origin.y,
                                                        [_labelWidths subscriptValueToCGFloat:index], // same length with the selected label
                                                        self.indicator.frame.size.height);
                  } completion:nil];
        }
    }
    
    // 内容滚动带动标题滚动
    CGFloat selectedTitleCenterX = 15;
    for (int i = 0; i <= index; i++) {
        selectedTitleCenterX += [_labelWidths subscriptValueToCGFloat:i] + 30;
    }
    selectedTitleCenterX -= [_labelWidths subscriptValueToCGFloat:index];
    
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:animationDamping
          initialSpringVelocity:animationSpringVelocity options:UIViewAnimationOptionAllowAnimatedContent animations:^{
              
              CGFloat tempOffset = selectedTitleCenterX - screenWidth/2;
              CGFloat minOffset = 0;
              CGFloat maxOffset = self.scrollTitleView.contentSize.width - screenWidth;
              if (tempOffset > maxOffset) {
                  self.scrollTitleView.contentOffset = CGPointMake(maxOffset, self.scrollTitleView.contentOffset.y);
              }else if (tempOffset < minOffset) {
                  self.scrollTitleView.contentOffset = CGPointMake(minOffset, self.scrollTitleView.contentOffset.y);
              }else {
                  self.scrollTitleView.contentOffset = CGPointMake(tempOffset, self.scrollTitleView.contentOffset.y);
              }
          } completion:nil];
}


# pragma mark - 滑动标题点击事件
-(void)lableTapped0 {
    self.view.backgroundColor = [UIColor whiteColor]; // iPod Image BgColor
    [self lableTappedWithSelectedLabelIndex:0];
}
-(void)lableTapped1 {
    [self lableTappedWithSelectedLabelIndex:1];
}
-(void)lableTapped2 {
    [self lableTappedWithSelectedLabelIndex:2];
}
-(void)lableTapped3 {
    [self lableTappedWithSelectedLabelIndex:3];
}
-(void)lableTapped4 {
    [self lableTappedWithSelectedLabelIndex:4];
}
-(void)lableTapped5 {
    [self lableTappedWithSelectedLabelIndex:5];
}
-(void)lableTapped6 {
    self.view.backgroundColor = [UIColor blackColor]; // Mac Pro Image BgColor
    [self lableTappedWithSelectedLabelIndex:6];
}

-(void)lableTappedWithSelectedLabelIndex:(int)selectedLabelIndex {
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:animationDamping
          initialSpringVelocity:animationSpringVelocity options:UIViewAnimationOptionAllowAnimatedContent animations:^{
              self.scrollContentView.contentOffset = CGPointMake(self.view.frame.size.width * selectedLabelIndex, self.scrollContentView.contentOffset.y);
    } completion:nil];
}


# pragma mark - Status Bar Style
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end


