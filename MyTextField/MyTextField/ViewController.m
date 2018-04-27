//
//  ViewController.m
//  MyTextField
//
//  Created by jzg on 2017/6/30.
//  Copyright © 2017年 jzg. All rights reserved.
//

#import "ViewController.h"
#import "MKTextField.h"
@interface ViewController (){
    MKTextField *_mkfield;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mkfield = [MKTextField mkfieldWithFrame:CGRectMake(10, 50, 350, 90)];
    _mkfield.maxLength = 11;
    _mkfield.placeHolder = @"请输入用户名";
    [self.view addSubview:_mkfield];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
