//
//  DMHeadsUpView.m
//  DMHeadsUpViewExample
//
//  Created by Daniel McCarthy on 1/5/15.
//  Copyright (c) 2015 Daniel McCarthy. All rights reserved.
//

#import "DMHeadsUpView.h"

@interface DMHeadsUpView ()
@property (strong, nonatomic) UIViewController *theViewController;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *darkenedBg;
@end

@implementation DMHeadsUpView

#pragma mark - Inits

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"DMHeadsUpView" owner:self options:nil];
    
    if (!self.themeColor)
        self.themeColor = [self dmGreenColor];
    
    self.circleBgView.layer.cornerRadius    = self.circleBgView.frame.size.width/2;
    self.circleBgView.layer.masksToBounds   = YES;
    
    self.circleView.layer.cornerRadius      = self.circleView.frame.size.width/2;
    self.circleView.layer.masksToBounds     = YES;
    
    self.doneButton.layer.cornerRadius      = 3.0f;
    self.doneButton.layer.masksToBounds     = YES;
    
    self.bgView.layer.cornerRadius          = 3.0f;
    self.bgView.layer.masksToBounds         = YES;
    
    self.frame = CGRectMake(0, 0, _view.frame.size.width, _view.frame.size.height);
    self.view.frame = CGRectMake(0, 0, _view.frame.size.width, _view.frame.size.height);
    [self addSubview:self.view];
}

#pragma mark - Public Show Methods

- (void)showHeadsUpIn:(UIViewController *)vc withText:(NSString *)text {
    self.theViewController  = vc;
    self.alertLabel.text    = text;
    self.containerView      = [self theContainerViewForVC:vc];
    self.darkenedBg         = [self theDarkenedViewForVC:vc];
    self.center = CGPointMake(_theViewController.view.frame.size.width/2, -(self.frame.size.height/2));
    
    [self.containerView addSubview:self.darkenedBg];
    [[UIApplication sharedApplication].windows.lastObject addSubview:self.containerView];
    [[UIApplication sharedApplication].windows.lastObject addSubview:self];
    [[UIApplication sharedApplication].windows.lastObject bringSubviewToFront:self];
    
    if (self.themeColor)
        [self setThemeColor:_themeColor];
    else
        [self setThemeColor:[self dmGreenColor]];
    
    [self fadeTheBackgroundIn];
    [self animateAlertToCenter];
    [self addConstraintsToBackground];
}

/*--Alert--*/
- (void)showAlertIn:(UIViewController *)vc withText:(NSString *)text {
    self.themeColor = [self dmYellowColor];
    [self.iconView setImage:[UIImage imageNamed:@"!"]];
    [self showHeadsUpIn:vc withText:text];
}

- (void)showAlertIn:(UIViewController *)vc withText:(NSString *)text withCallback:(void (^)(BOOL))block {
    self.themeColor = [self dmYellowColor];
    self.callBack = block;
    [self showAlertIn:vc withText:text];
}

/*--Success--*/
- (void)showSuccessIn:(UIViewController *)vc withText:(NSString *)text {
    self.themeColor = [self dmGreenColor];
    [self.iconView setImage:[UIImage imageNamed:@"check"]];
    [self showHeadsUpIn:vc withText:text];
}

- (void)showSuccessIn:(UIViewController *)vc withText:(NSString *)text withCallback:(void (^)(BOOL))block {
    self.themeColor = [self dmGreenColor];
    self.callBack = block;
    [self showSuccessIn:vc withText:text];
}

/*--Error--*/
- (void)showErrorIn:(UIViewController *)vc withText:(NSString *)text {
    self.themeColor = [self dmRedColor];
    [self.iconView setImage:[UIImage imageNamed:@"x"]];
    [self showHeadsUpIn:vc withText:text];
}

- (void)showErrorIn:(UIViewController *)vc withText:(NSString *)text withCallback:(void (^)(BOOL))block {
    self.themeColor = [self dmRedColor];
    self.callBack = block;
    [self showErrorIn:vc withText:text];
}

/*--Custom Icon--*/
- (void)showWithCustomIcon:(UIImage *)image inVC:(UIViewController *)vc withText:(NSString *)text {
    self.themeColor = [self dmGreenColor];
    [self.iconView setImage:image];
    [self showHeadsUpIn:vc withText:text];
}

- (void)showWithCustomIcon:(UIImage *)image inVC:(UIViewController *)vc withText:(NSString *)text withCallback:(void (^)(BOOL))block {
    self.themeColor = [self dmGreenColor];
    self.callBack = block;
    [self showWithCustomIcon:image inVC:vc withText:text];
}

#pragma mark - Objects

- (UIView *)theContainerViewForVC:(UIViewController *)vc {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    view.alpha = 0.0f;
    return view;
}

- (UIView *)theDarkenedViewForVC:(UIViewController *)vc {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7f;
    return view;
}

#pragma mark - Constraints

- (void)addConstraintsToBackground {
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self.containerView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:[UIApplication sharedApplication].windows.lastObject
                                                                         attribute:NSLayoutAttributeLeading
                                                                         multiplier:1.0
                                                                         constant:0.0]];
    
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self.containerView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:[UIApplication sharedApplication].windows.lastObject
                                                                         attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                         constant:0.0]];
    
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self.containerView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:[UIApplication sharedApplication].windows.lastObject
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                         constant:0.0]];
    
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self.containerView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:[UIApplication sharedApplication].windows.lastObject
                                                                         attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                         constant:0.0]];
    
    //The constaints to the darkened view
    self.darkenedBg.translatesAutoresizingMaskIntoConstraints = NO;
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self.darkenedBg
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.containerView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         multiplier:1.0
                                                                         constant:0.0]];
    
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self.darkenedBg
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.containerView
                                                                         attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                         constant:0.0]];
    
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self.darkenedBg
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.containerView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                         constant:0.0]];
    
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self.darkenedBg
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.containerView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                         constant:0.0]];
}

- (void)addConstraintToTheAlertView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *width         = [NSString stringWithFormat:@"H:[alertView(%f)]",self.frame.size.width];
    NSString *height        = [NSString stringWithFormat:@"V:[alertView(%f)]",self.frame.size.width];
    NSDictionary *viewsDict = @{@"alertView":self};
    
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:height
                                                                    options:0
                                                                    metrics:nil
                                                                    views:viewsDict];
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:width
                                                                    options:0
                                                                    metrics:nil
                                                                    views:viewsDict];
    [self addConstraints:constraint_H];
    [self addConstraints:constraint_V];
    
    
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:[UIApplication sharedApplication].windows.lastObject
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.0
                                                                         constant:0.0]];
    
    [[UIApplication sharedApplication].windows.lastObject addConstraint:[NSLayoutConstraint
                                                                         constraintWithItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                         toItem:[UIApplication sharedApplication].windows.lastObject
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0
                                                                         constant:0.0]];
}

- (void)removeConstraintsFromAlert {
    NSString *width         = [NSString stringWithFormat:@"H:[alertView(%f)]",self.frame.size.width];
    NSString *height        = [NSString stringWithFormat:@"V:[alertView(%f)]",self.frame.size.width];
    NSDictionary *viewsDict = @{@"alertView":self};
    
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:height
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDict];
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:width
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDict];
    [self removeConstraints:constraint_H];
    [self removeConstraints:constraint_V];
    
    
    [[UIApplication sharedApplication].windows.lastObject removeConstraint:[NSLayoutConstraint
                                                                            constraintWithItem:self
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                            toItem:[UIApplication sharedApplication].windows.lastObject
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                            constant:0.0]];
    
    [[UIApplication sharedApplication].windows.lastObject removeConstraint:[NSLayoutConstraint
                                                                            constraintWithItem:self
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                            toItem:[UIApplication sharedApplication].windows.lastObject
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1.0
                                                                            constant:0.0]];
}

#pragma mark - Animations

- (void)fadeTheBackgroundIn {
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeTheBackground {
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.containerView removeFromSuperview];
        self.darkenedBg     = nil;
        self.containerView  = nil;
    }];
}

- (void)animateAlertToCenter {
    CGPoint thePoint = CGPointMake(self.center.x, self.theViewController.view.center.y);
    [self bounceView:self
             toPoint:thePoint
              inView:self.theViewController.view
        withCallback:^(BOOL isDone) {
            [self addConstraintToTheAlertView];
        }];
}

- (void)animateAlertAway {
    [self removeConstraintsFromAlert];
    [UIView animateWithDuration:0.2 animations:^{
        self.center = CGPointMake(self.center.x, self.theViewController.view.frame.size.height + self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)bounceView:(UIView *)view toPoint:(CGPoint)point inView:(UIView *)containingView withCallback:(void (^)(BOOL))block {
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.45f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         view.center = point;
                     }
                     completion:^(BOOL finished) {
                         if (block)
                             block (YES);
                     }];
}

#pragma mark - Button Actions

- (IBAction)doneButtonAction:(id)sender {
    [self removeTheBackground];
    [self animateAlertAway];
    if (self.callBack)
        self.callBack (YES);
}

#pragma mark - Colors

- (void)setControlThemeColor:(UIColor *)color {
    self.circleView.backgroundColor = color;
    self.doneButton.backgroundColor = color;
}

- (void)setThemeColor:(UIColor *)themeColor {
    _themeColor = themeColor;
    [self setControlThemeColor:_themeColor];
}

- (UIColor *)dmGreenColor {
    return [UIColor colorWithRed:0.0f/255.0f
                           green:217.0f/255.0f
                            blue:184.0f/255.0f
                           alpha:1.0f];
}

- (UIColor *)dmRedColor {
    return [UIColor colorWithRed:217.0f/255.0f
                           green:118.0f/255.0f
                            blue:111.0f/255.0f
                           alpha:1.0f];
}

- (UIColor *)dmYellowColor {
    return [UIColor colorWithRed:255.0f/255.0f
                           green:227.0f/255.0f
                            blue:119.0f/255.0f
                           alpha:1.0f];
}

@end
