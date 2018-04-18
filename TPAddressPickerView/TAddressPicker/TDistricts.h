//
//  TDistricts.h
//  TPAddressPickerView
//
//  Created by allentang on 2018/4/16.
//  Copyright © 2018年 allentang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDistricts : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger cityCode;
@property (nonatomic,strong) NSArray *districts;
@end
