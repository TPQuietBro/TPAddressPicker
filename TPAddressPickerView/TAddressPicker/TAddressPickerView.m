//
//  TAddressPickerView.m
//  TPAddressPickerView
//
//  Created by allentang on 2018/4/16.
//  Copyright © 2018年 allentang. All rights reserved.
//

#import "TAddressPickerView.h"
#import "TCity.h"
#import "TProvince.h"
#import "TDistricts.h"
#import "MJExtension.h"
#import <CoreGraphics/CoreGraphics.h>
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TAddressPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) NSMutableArray *allAddressInfo;
@property (nonatomic,assign) NSInteger indexP;
@property (nonatomic,assign) NSInteger indexC;
@property (nonatomic,assign) NSInteger indexD;
@end
@implementation TAddressPickerView

- (instancetype)initWithAddressBlock:(void(^)(NSString *address))block
{
    self = [super init];
    if (self) {
        self.addressInfoBlock = [block copy];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadAddressInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pickerView reloadAllComponents];
                [self initSubviews];
            });
        });
        
    }
    return self;
}

- (void)initSubviews{
    [self addSubview:self.pickerView];
    [self addSubview:self.headerView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.pickerView.frame = CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216);
}

- (void)loadAddressInfo{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address_data" ofType:@"json"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *datas = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
    
    self.allAddressInfo = [TProvince mj_objectArrayWithKeyValuesArray:datas];

}

- (void)showPicker{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect tempFrame = self.pickerView.frame;
        tempFrame.origin.y = ScreenHeight - 216;
        self.pickerView.frame = tempFrame;
        CGRect tempFrame2 = self.headerView.frame;
        tempFrame2.origin.y = ScreenHeight - 256;
        self.headerView.frame = tempFrame2;
        
    }];
}
- (void)hidePicker{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect tempFrame = self.pickerView.frame;
        tempFrame.origin.y = ScreenHeight + 40;
        self.pickerView.frame = tempFrame;
        
        CGRect tempFrame2 = self.headerView.frame;
        tempFrame2.origin.y = ScreenHeight;
        self.headerView.frame = tempFrame2;
    }];
}

#pragma mark - pickerview delegate & datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    switch (component) {
        case 0:
        {
            return self.allAddressInfo.count;
        }
            break;
        case 1:
        {
            NSInteger row1  = [pickerView selectedRowInComponent:0];
            TProvince *p = self.allAddressInfo[row1];
            return p.districts.count;
        }
            break;
        case 2:
        {
            NSInteger row1  = [pickerView selectedRowInComponent:0];
            NSInteger row2  = [pickerView selectedRowInComponent:1];
            TProvince *p = self.allAddressInfo[row1];
            TCity *c = p.districts[row2];
            return c.districts.count;
        }
            break;
    }
    return 1;
}


//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        TProvince *p = self.allAddressInfo[row];
        return p.name;
    }else if (component == 1){
        NSInteger row1 = [pickerView selectedRowInComponent:0];
        TProvince *p = self.allAddressInfo[row1];
        TCity *c = p.districts[row];
        return c.name;
    }else if (component == 2){
        NSInteger row1  = [pickerView selectedRowInComponent:0];
        NSInteger row2  = [pickerView selectedRowInComponent:1];
        TProvince *p = self.allAddressInfo[row1];
        TCity *c = p.districts[row2];
        TDistricts *d = c.districts[row];
        return d.name;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            self.indexP = [pickerView selectedRowInComponent:component];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
        case 1:
        {
            self.indexC = [pickerView selectedRowInComponent:component];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
        case 2:
        {
            self.indexD = [pickerView selectedRowInComponent:component];
            
        }
            break;
    }
    NSLog(@"P:%zd C:%zd D:%zd",self.indexP,self.indexC,self.indexD);
}
#pragma mark - event response
- (void)selectResult{
    
    [self hidePicker];
    
    NSString *titleP = [self pickerView:self.pickerView titleForRow:self.indexP forComponent:0];
    NSString *titleC = [self pickerView:self.pickerView titleForRow:self.indexC forComponent:1];
    NSString *titleD = [self pickerView:self.pickerView titleForRow:self.indexD forComponent:2];
    
    NSString *addressInfo = [NSString stringWithFormat:@"%@ %@ %@",titleP,titleC,titleD];
    self.addressInfoBlock ? self.addressInfoBlock(addressInfo) : nil;
    NSLog(@"%@",addressInfo);
}
#pragma mark - getter
- (NSMutableArray *)allAddressInfo{
    if (!_allAddressInfo) {
        _allAddressInfo = [[NSMutableArray alloc] init];
    }
    return _allAddressInfo;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, ScreenHeight - 256, ScreenWidth, 40);
        _headerView.backgroundColor = [UIColor whiteColor];
        UIButton *cancellButton = [[UIButton alloc] init];
        [cancellButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancellButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        cancellButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancellButton addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:cancellButton];
        cancellButton.frame = CGRectMake(20, (_headerView.frame.size.height - 30) / 2, 70, 30);
        
        UIButton *confirmButton = [[UIButton alloc] init];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmButton addTarget:self action:@selector(selectResult) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:confirmButton];
        confirmButton.frame = CGRectMake(ScreenWidth - 70 - 20, (_headerView.frame.size.height - 30) / 2, 70, 30);
    }
    return _headerView;
}

@end
