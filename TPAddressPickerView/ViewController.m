//
//  ViewController.m
//  TPAddressPickerView
//
//  Created by allentang on 2018/4/16.
//  Copyright © 2018年 allentang. All rights reserved.
//

#import "ViewController.h"
#import "TAddressPickerView.h"
@interface ViewController ()
@property (nonatomic,strong) TAddressPickerView *pick;
@end

@implementation ViewController

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

@end
