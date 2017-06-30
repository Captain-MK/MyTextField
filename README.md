# MyTextField
封装了一个TextField带错误提示、记录、滑动删除
# Use
    _mkfield = [MKTextField mkfieldWithFrame:CGRectMake(10, 50, 350, 100)];
    _mkfield.maxLength = 11;
    _mkfield.placeHolder = @"请输入用户名";
    [self.view addSubview:_mkfield];
