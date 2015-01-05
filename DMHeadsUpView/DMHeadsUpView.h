//
//  DMHeadsUpView.h
//  DMHeadsUpViewExample
//
//  Created by Daniel McCarthy on 1/5/15.
//  Copyright (c) 2015 Daniel McCarthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMHeadsUpView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *circleBgView;
@property (strong, nonatomic) IBOutlet UIView *circleView;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) void (^callBack)(BOOL okPressed);

- (void)showAlertIn:(UIViewController *)vc withText:(NSString *)text;
- (void)showAlertIn:(UIViewController *)vc withText:(NSString *)text withCallback:(void (^)(BOOL okPressed))block;

- (void)showSuccessIn:(UIViewController *)vc withText:(NSString *)text;
- (void)showSuccessIn:(UIViewController *)vc withText:(NSString *)text withCallback:(void (^)(BOOL okPressed))block;

- (void)showErrorIn:(UIViewController *)vc withText:(NSString *)text;
- (void)showErrorIn:(UIViewController *)vc withText:(NSString *)text withCallback:(void (^)(BOOL okPressed))block;

- (void)showWithCustomIcon:(UIImage *)image inVC:(UIViewController *)vc withText:(NSString *)text;
- (void)showWithCustomIcon:(UIImage *)image inVC:(UIViewController *)vc withText:(NSString *)text withCallback:(void (^)(BOOL okPressed))block;

@end
