//
//  MKTextField.m
//  MyTextField
//
//  Created by jzg on 2017/6/30.
//  Copyright © 2017年 jzg. All rights reserved.
//

#import "MKTextField.h"
#define MK_Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define NSUserDefaultsKey @"HistoryList"
const static CGFloat margin = 10.0f;
const static CGFloat tableViewH = 100.0f;
const static CGFloat animateDuration = 0.5f;

@interface MKTextField ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UITextField *textField;
/** 上浮的Label */
@property (nonatomic,strong)UILabel *placeHolderLabel;
/** 错误提示Label */
@property (nonatomic,strong)UILabel *errarLabel;
/** 左侧小图标 */
@property(nonatomic,strong)UIImageView *leftImageView;
/** textField右侧字数 */
@property(nonatomic,strong)UILabel *numLable;
/** 主窗口 */
@property (nonatomic,strong)UIWindow *window;
/** 表格视图 */
@property (nonatomic,strong)UITableView *tableView;
@end
@implementation MKTextField{
    /** 历史数据 */
    NSMutableArray *_dataArray;
}
+(instancetype)mkfieldWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.lineWarningColor = MK_Color(255, 0, 0);
        self.leftImageName = @"username_login";
        self.errarLabel.text = @"输入错误";
        self.maxLength = 11;
        [self initData];
        [self addSubview:self.line];
        [self addSubview:self.placeHolderLabel];
        [self addSubview:self.leftImageView];
        [self addSubview:self.textField];
        [self addSubview:self.numLable];
        [self addSubview:self.errarLabel];
    }
    return self;
}
-(void)deleteAllData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:NSUserDefaultsKey];
    NSLog(@"删除成功");
}
-(void)deleteData:(NSInteger)index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [defaults objectForKey:NSUserDefaultsKey];
    NSMutableArray *array = dic[NSUserDefaultsKey];
    if (array) {
        NSMutableArray *all = [NSMutableArray arrayWithArray:array];//必需复制，不然会报错
        [all removeObjectAtIndex:index];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:all forKey:NSUserDefaultsKey];
        [defaults setObject:dict forKey:NSUserDefaultsKey];
        _dataArray = [all mutableCopy];
    }
}
-(void)initData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [defaults objectForKey:NSUserDefaultsKey];
    NSMutableArray *array = dic[NSUserDefaultsKey];
    if (array) {
        _dataArray = [array mutableCopy];
    }
}
-(void)saveContent:(UITextField *)textField
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *oldContent = [defaults objectForKey:NSUserDefaultsKey];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (oldContent == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithObject:textField.text];
        [dic setObject:array forKey:NSUserDefaultsKey];
    }else{
        NSMutableArray *allContent = oldContent[NSUserDefaultsKey];
        NSMutableArray *all = [NSMutableArray arrayWithArray:allContent];//必需复制，不然会报错
        if (textField.text !=nil && textField.text.length !=0) {
            if (![all containsObject:textField.text]) {
                [all insertObject:textField.text atIndex:0];
                }
        }
        [dic setObject:all forKey:NSUserDefaultsKey];
    }
    [defaults setObject:dic forKey:NSUserDefaultsKey];
    [defaults synchronize];
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setPlaceHolderLabelHidden:NO];
    if (_dataArray.count !=0) {
        [self showTableView:CGRectGetMaxY(self.frame)];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setPlaceHolderLabelHidden:YES];
    [self dismissTableView];
    if (textField.text.length < self.maxLength) {
        [self saveContent:textField];
    }
    [self initData];
}
-(void)textFieldEditingChanged:(UITextField *)sender
{
    if (sender.text.length > self.maxLength) {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.numLable.textColor = self.lineWarningColor;
            self.textField.textColor = self.lineWarningColor;
            self.errarLabel.alpha = 1.0f;
        } completion:nil];
    }else if(sender.text.length == self.maxLength){
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.numLable.textColor = MK_Color(0,0,0);
            self.textField.textColor = MK_Color(0,0,0);
            self.errarLabel.alpha = 0.0f;
        } completion:nil];
    }else{
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.numLable.textColor = MK_Color(150,150,150);
            self.textField.textColor = MK_Color(150,150,150);
            self.errarLabel.alpha = 0.0f;
        } completion:nil];
    }
    self.numLable.text = [NSString stringWithFormat:@"%zd/%zd",sender.text.length,self.maxLength];
}
#pragma mark - tableView
-(void)showTableView:(CGFloat)y
{
    self.window = [UIApplication sharedApplication].keyWindow;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window addSubview:self.tableView];
    self.tableView.frame = CGRectMake(margin * 1.5, y, self.line.width, tableViewH);
    [self.tableView reloadData];
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.tableView.alpha = 1.0;
    }];
}
- (void)dismissTableView
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.tableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        self.window = nil;
    }];
}
#pragma mark - UITableViewDataSource\UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MKTextFieldCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = MK_Color(150,150,150);
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.textField.text = _dataArray[indexPath.row];
    self.numLable.text = [NSString stringWithFormat:@"%zd/%zd",self.textField.text.length,self.maxLength];
    [self dismissTableView];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [self deleteData:indexPath.row];
    }];
    NSArray *arr = @[action];
    return arr;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - animate
- (void)setPlaceHolderLabelHidden:(BOOL)isHidden
{
    if (isHidden) {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.placeHolderLabel.alpha = 0.0f;
            self.textField.placeholder = self.placeHolder;
        } completion:nil];
    }else{
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.placeHolderLabel.alpha = 1.0f;
            self.textField.placeholder = @"";
        } completion:nil];
    }
}
#pragma mark - layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.top.right.equalTo(self);
        make.height.equalTo(@20.0f);
    }];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.top.equalTo(self.placeHolderLabel.mas_bottom).offset(margin);
        make.height.equalTo(@30.0f);
        make.width.equalTo(@21.5f);
    }];
    [self.numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self.textField);
        make.height.equalTo(@13.5f);
        make.width.equalTo(@35.f);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(margin);
        make.right.equalTo(self.numLable.mas_left).offset(-margin);
        make.centerY.equalTo(self.leftImageView);
        make.height.equalTo(@30.0f);
    }];
    [self.errarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(margin);
        make.right.equalTo(self);
        make.left.equalTo(self.leftImageView);
        make.height.equalTo(@20.f);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeHolderLabel.mas_bottom).offset(margin * 0.5);
        make.left.equalTo(self).offset(margin * 0.5);
        make.right.equalTo(self).offset(- margin * 0.5);
        make.bottom.equalTo(self.textField.mas_bottom).offset(margin * 0.5);
    }];
}
#pragma mark - setting
-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}
-(void)setLeftImageName:(NSString *)leftImageName
{
    _leftImageName = leftImageName;
    self.leftImageView.image = [UIImage imageNamed:leftImageName];
}
- (void)setMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
    self.numLable.text = [NSString stringWithFormat:@"0/%zd",maxLength];
}
-(void)setLineWarningColor:(UIColor *)lineWarningColor
{
    _lineWarningColor = lineWarningColor;
}
#pragma mark - lazy
-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.layer.cornerRadius = 5.0f;
        _line.layer.borderWidth = 1.0f;
        _line.layer.borderColor = MK_Color(150,150,150).CGColor;
        _line.layer.masksToBounds = YES;
    }
    return _line;
}
-(UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc]init];
        _placeHolderLabel.font = [UIFont systemFontOfSize:13];
        _placeHolderLabel.alpha = 0.f;
    }
    return _placeHolderLabel;
}
-(UILabel *)errarLabel
{
    if (!_errarLabel) {
        _errarLabel = [[UILabel alloc]init];
        _errarLabel.font = [UIFont systemFontOfSize:13];
        _errarLabel.alpha = 0.f;
        _errarLabel.textColor = MK_Color(255, 0, 0);
    }
    return _errarLabel;
}
-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.image = [UIImage imageNamed:_leftImageName];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}
-(UILabel *)numLable
{
    if (!_numLable) {
        _numLable = [[UILabel alloc]init];
        _numLable.font = [UIFont systemFontOfSize:11];
        _numLable.textColor = MK_Color(150,150,150);
    }
    return _numLable;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40.0f;
        _tableView.alpha = 0.0f;
        _tableView.layer.borderWidth = 1.0f;
        _tableView.layer.borderColor = MK_Color(220, 220, 220).CGColor;
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
@end
