//
//  ViewController.m
//  WTAlbumView
//
//  Created by vaexiin on 2017/4/25.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "ViewController.h"

#import "AutoSubVC.h"
#import "NotSubVC.h"
#import "TextScrollVC.h"
#import "OtherVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"WTAlbumView";
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)btn1:(UIButton *)sender {
    [self.navigationController pushViewController:[AutoSubVC new] animated:YES];
}

- (IBAction)btn2:(UIButton *)sender {
    [self.navigationController pushViewController:[NotSubVC new] animated:YES];
}

- (IBAction)btn3:(UIButton *)sender {
    [self.navigationController pushViewController:[TextScrollVC new] animated:YES];
}

- (IBAction)btn4:(UIButton *)sender {
    [self.navigationController pushViewController:[OtherVC new] animated:YES];
}
@end
