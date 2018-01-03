//  Created by Jason Morrissey

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
/**
 *  色值转换成UIColor
 *  @param hexColor:16进制色值
 *  @return UIColor类型
 */
+ (UIColor *)colorWithHex:(long)hexColor;
/**
 *  色值转换成UIColor
 *  @param hexColor:16进制色值
 *  @param opacity:颜色的透明度0~1
 *  @return UIColor类型
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

+ (UIColor *)getColorWithQulityLevel:(int)qulityLevel;


@end

@interface DRColorHex : NSObject
#pragma mark- 颜色转换
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert withAlpha:(float)alpha;

@end
