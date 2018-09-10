//
//  SupportViewController.m
//  InterfaceOrientationDemo
//
//  Created by xiaoyuan on 2018/7/17.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "SupportViewController.h"
#import "InterfaceOrientationUtil.h"

@interface SupportViewController ()

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[InterfaceOrientationUtil sharedInsatnce] rotateInterfaceOrientation:UIInterfaceOrientationPortrait];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 即使此页面不允许横屏，也需要设置此处YES，不然会造成从横屏页面进入此页面，无法旋转为竖屏的问题
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
