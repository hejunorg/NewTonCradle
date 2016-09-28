//
//  ViewController.m
//  NewTonCradle
//
//  Created by hejun on 9/20/16.
//  Copyright © 2016 teamleader. All rights reserved.
//

#import "ViewController.h"
#import "NewTonCradle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	//
	CGFloat width = 300.f;
	CGFloat height = 500.f;
	CGFloat x = (self.view.frame.size.width - width) * 0.5;
	CGFloat y = (self.view.frame.size.height - height) * 0.5;
	NewTonCradle *cradle = [[NewTonCradle alloc] initWithFrame:CGRectMake(x, y, width, height)];
	cradle.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview:cradle];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
