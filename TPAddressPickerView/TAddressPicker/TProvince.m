//
//  TProvince.m
//  TPAddressPickerView
//
//  Created by allentang on 2018/4/16.
//  Copyright © 2018年 allentang. All rights reserved.
//

#import "TProvince.h"

@implementation TProvince
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"districts" : @"TCity",
             @"TCity.districts" : @"TDistricts"
             };
}
@end
