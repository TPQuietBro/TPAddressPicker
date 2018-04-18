//
//  TAddressPickerView.h
//  TPAddressPickerView
//
//  Created by allentang on 2018/4/16.
//  Copyright © 2018年 allentang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAddressPickerView : UIView
@property (nonatomic,strong) void(^addressInfoBlock)(NSString *address);
- (instancetype)initWithAddressBlock:(void(^)(NSString *address))block;
- (void)showPicker;
- (void)hidePicker;
@end
