//
//  IPMaskConvert.h
//  SubCalc
//
//  Created by Asuk Nath on 7/12/16.
//  Copyright (c) 2016 NathTel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IPMaskConvert : NSObject

+(int)IPtoInt:(NSString*)ip;
+(NSString*)intIPtoStr:(int)ip;
+(int)maskOctetValidation :(int)octet :(int)octnum;
@end
