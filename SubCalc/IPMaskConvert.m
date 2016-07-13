//
//  IPMaskConvert.m
//  SubCalc
//
//  Created by Asuk Nath on 7/12/16.
//  Copyright (c) 2016 NathTel. All rights reserved.
//

#import "IPMaskConvert.h"

@implementation IPMaskConvert

+(NSString*)intIPtoStr:(int)ip {
    NSMutableString *mutablestr = [NSMutableString string];
    for (int s = 24; s > 0; s -= 8) {
        [mutablestr appendString:[NSString stringWithFormat:@"%d", (ip >> s) & 255]];
        [mutablestr appendString:@"."];
    }
    [mutablestr appendString:[NSString stringWithFormat:@"%d", (ip & 255)]];
    return mutablestr;
}

+(int)IPtoInt:(NSString*)ip {
    NSArray *st = [ip componentsSeparatedByString: @"."];
    int i = 24;
    int ipa = 0;
    for (int n = 0; n < st.count; n++) {
        int value = [(NSString*)st[n] intValue];
        ipa += value << i;
        i -= 8;
    }
    return ipa;
}

+(int)maskOctetValidation :(int)octet :(int)octnum{
    if((octnum==2) || (octnum==3)){
        if((octet == 0) || (octet == 128) || (octet == 192) || (octet == 224) || (octet == 240) || (octet == 248)  || (octet == 252) || (octet == 254) || (octet == 255)){
            return 1;
        }else{
            return 0;
        }
    }else{
        if((octet == 0) || (octet == 128) || (octet == 192) || (octet == 224) || (octet == 240) || (octet == 248)  || (octet == 252)){
            return 1;
        }else{
            return 0;
        }
    }
}

@end
