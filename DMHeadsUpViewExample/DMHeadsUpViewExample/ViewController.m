//
//  ViewController.m
//  DMHeadsUpViewExample
//
//  Created by Daniel McCarthy on 1/5/15.
//  Copyright (c) 2015 Daniel McCarthy. All rights reserved.
//

#import "ViewController.h"
#import "DMHeadsUpView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *demoTextContainer;
@property (strong, nonatomic) IBOutlet UITextView *demoTextView;
@property (strong, nonatomic) IBOutlet UIButton *alertButton;
@property (strong, nonatomic) IBOutlet UIButton *successButton;
@property (strong, nonatomic) IBOutlet UIButton *errorButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Demo Setup

- (void)setup {
    CGFloat cornerRad = 5.0f;
    self.demoTextContainer.layer.cornerRadius = cornerRad;
    self.demoTextContainer.layer.masksToBounds = YES;
    
    self.successButton.layer.cornerRadius = cornerRad;
    self.successButton.layer.masksToBounds = YES;
    
    self.alertButton.layer.cornerRadius = cornerRad;
    self.alertButton.layer.masksToBounds = YES;
    
    self.errorButton.layer.cornerRadius = cornerRad;
    self.errorButton.layer.masksToBounds = YES;
    
    self.demoTextView.delegate = self;
}


#pragma mark - Control Setup Example

- (void)showSuccessHeadsUp {
    DMHeadsUpView *success = [[DMHeadsUpView alloc] init];
    [success showSuccessIn:self withText:self.demoTextView.text withCallback:^(BOOL okPressed) {
        //do stuff when user dismisses
    }];
}

- (void)showAlertHeadsUp {
    DMHeadsUpView *alert = [[DMHeadsUpView alloc] init];
    [alert showAlertIn:self withText:self.demoTextView.text withCallback:^(BOOL okPressed) {
        //do stuff when user dismisses
    }];
}

- (void)showErrorHeadsUp {
    DMHeadsUpView *error = [[DMHeadsUpView alloc] init];
    [error showErrorIn:self withText:self.demoTextView.text withCallback:^(BOOL okPressed) {
        //do stuff when user dismisses
    }];
}

#pragma mark - Button Action Methods
- (IBAction)successButtonAction:(id)sender {
    [self playButtonClickSound];
    [self showSuccessHeadsUp];
}

- (IBAction)alertButtonAction:(id)sender {
    [self playButtonClickSound];
    [self showAlertHeadsUp];
}

- (IBAction)errorButtonAction:(id)sender {
    [self playButtonClickSound];
    [self showErrorHeadsUp];
}

- (void)playButtonClickSound {
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"buttonClick" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AudioServicesDisposeSystemSoundID(audioEffect);
    });
}

#pragma mark - TextView Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else
        return YES;
}

@end
