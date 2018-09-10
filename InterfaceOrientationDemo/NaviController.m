//
//  NaviController.m
//  InterfaceOrientationDemo
//
//  Created by xiaoyuan on 2018/7/17.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "NaviController.h"
#import "InterfaceOrientationUtil.h"
#import "SupportViewController.h"

@implementation NaviController

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)dealloc {
    if (self.supportRotatingScreen) {
        [[InterfaceOrientationUtil sharedInsatnce] stopListeningDirectionOfDevice];
        [[InterfaceOrientationUtil sharedInsatnce] rotateInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[InterfaceOrientationUtil sharedInsatnce] startListeningDirectionOfDevice];
    UIButton *btn = [UIButton new];
    [self.view addSubview:btn];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [btn.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [btn setTitle:@"support" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(supportAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.supportRotatingScreen) {
        [[InterfaceOrientationUtil sharedInsatnce] rotateInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        [[InterfaceOrientationUtil sharedInsatnce] autorotateInterfaceOrientation];
    }
    [[InterfaceOrientationUtil sharedInsatnce] stopListeningDirectionOfDevice];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.supportRotatingScreen) {
        [[InterfaceOrientationUtil sharedInsatnce] startListeningDirectionOfDeviceWithImmediately:NO];
    }
}

- (BOOL)supportRotatingScreen {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)supportAction:(id)sender {
    SupportViewController *support = [SupportViewController new];
    support.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:support animated:YES];
}
@end
