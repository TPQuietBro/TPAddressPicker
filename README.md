# TPAddressPicker
#### 使用说明

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    TAddressPickerView *pick = [[TAddressPickerView alloc] initWithAddressBlock:^(NSString *address) {
        NSLog(@"address=%@",address);
    }];
    pick.frame = self.view.bounds;
    pick.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:pick];
    self.pick = pick;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.pick showPicker];
}
```
