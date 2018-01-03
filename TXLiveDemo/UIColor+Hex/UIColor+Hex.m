//  Created by Jason Morrissey

#import "UIColor+Hex.h"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]
#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@implementation UIColor (Hex)

+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.0];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];  
}

+ (UIColor *)getColorWithQulityLevel:(int)qulityLevel
{
    UIColor *color = [UIColor colorWithHex:0x42badc];
    if(qulityLevel<=50){
        color = [UIColor colorWithHex:0x29a532];
    }else if (qulityLevel > 50 &&  qulityLevel <= 100){
        color = [UIColor colorWithHex:0xc5e801];
    }else if (qulityLevel > 100 && qulityLevel <= 150){
        color = [UIColor colorWithHex:0xf49a0b];
    }else if (qulityLevel > 150 && qulityLevel <= 200){
        color = [UIColor colorWithHex:0xfb1c1c];
    }else if (qulityLevel > 200 && qulityLevel <= 300){
        color = [UIColor colorWithHex:0xaf00bf];
    }else if (qulityLevel > 300){
       color = [UIColor colorWithHex:0x6000b1];
    }
    return color;
}


@end



@implementation DRColorHex

#pragma mark- 颜色转换
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    return [self colorWithHexString:stringToConvert withAlpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert withAlpha:(float)alpha{
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}


@end
