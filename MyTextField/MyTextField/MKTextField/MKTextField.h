//
//  MKTextField.h
//  MyTextField
//
//  Created by jzg on 2017/6/30.
//  Copyright © 2017年 jzg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>
#import <Masonry.h>
@interface MKTextField : UIView
/** 占位文字 */
@property(nonatomic,copy)NSString *placeHolder;
/** 左侧图标名称(有默认图片) */
@property (nonatomic,copy) NSString *leftImageName;
/** 最大字数(必填) */
@property (nonatomic,assign) NSInteger maxLength;
/** 警告颜色(默认红色) */
@property (nonatomic,strong) UIColor *lineWarningColor;

+(instancetype)mkfieldWithFrame:(CGRect)frame;
@end
