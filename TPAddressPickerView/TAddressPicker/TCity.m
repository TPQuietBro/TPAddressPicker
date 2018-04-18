//
//  TCity.m
//  TPAddressPickerView
//
//  Created by allentang on 2018/4/16.
//  Copyright © 2018年 allentang. All rights reserved.
//

#import "TCity.h"

@implementation TCity
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"districts" : @"TDistricts",
             };
}
@end
