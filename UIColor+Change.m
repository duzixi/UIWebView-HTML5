//
//  UIColor+Change.m
//  ChangeColor
//
//  Created by 杜子兮 on 14-3-13.
//  Edited  by 杜子兮 on 14-5-23.
//  Edited  by 杜子兮 on 14-7-12. for Canvas.
//  Copyright (c) 2014年 莲兮奈若何. All rights reserved.
//

#import "UIColor+Change.h"

@implementation UIColor (Change)

///  获取canvas用的颜色字符串
- (NSString *)canvasColorString
{
    CGFloat *arrRGBA = [self getRGB];
    int r = arrRGBA[0] * 255;
    int g = arrRGBA[1] * 255;
    int b = arrRGBA[2] * 255;
    float a = arrRGBA[3];
    return [NSString stringWithFormat:@"rgba(%d,%d,%d,%f)", r, g, b, a];
}

///  获取网页颜色字串
- (NSString *)webColorString
{
    CGFloat *arrRGBA = [self getRGB];
    int r = arrRGBA[0] * 255;
    int g = arrRGBA[1] * 255;
    int b = arrRGBA[2] * 255;
    NSLog(@"%d,%d,%d", r, g, b);
    NSString *webColor = [NSString stringWithFormat:@"#%02X%02X%02X", r, g, b];
    return webColor;
}

/// 加亮
- (UIColor *) lighten
{
    CGFloat *rgb = [self getRGB];
    CGFloat r = rgb[0];
    CGFloat g = rgb[1];
    CGFloat b = rgb[2];
    CGFloat alpha = rgb[3];
    
    r = r + (1 - r) / 6.18;
    g = g + (1 - g) / 6.18;
    b = b + (1 - b) / 6.18;
    
    UIColor * uiColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    return uiColor;
}

- (UIColor *) darken{ //变暗
    CGFloat *rgb = [self getRGB];
    CGFloat r = rgb[0];
    CGFloat g = rgb[1];
    CGFloat b = rgb[2];
    CGFloat alpha = rgb[3];
    
    r = r * 0.618;
    g = g * 0.618;
    b = b * 0.618;
    
    UIColor *uiColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    return uiColor;
}

- (UIColor *) mix: (UIColor *) color{
    CGFloat * rgb1 = [self getRGB];
    CGFloat r1 = rgb1[0];
    CGFloat g1 = rgb1[1];
    CGFloat b1 = rgb1[2];
    CGFloat alpha1 = rgb1[3];

    CGFloat * rgb2 = [color getRGB];
    CGFloat r2 = rgb2[0];
    CGFloat g2 = rgb2[1];
    CGFloat b2 = rgb2[2];
    CGFloat alpha2 = rgb2[3];
    
    //mix them!!
    CGFloat r = (r1 + r2) / 2.0;
    CGFloat g = (g1 + g2) / 2.0;
    CGFloat b = (b1 + b2) / 2.0;
    CGFloat alpha = (alpha1 + alpha2) / 2.0;
    
    UIColor * uiColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    return uiColor;
}

- (CGFloat *) getRGB{
    UIColor * uiColor = self;
    
    CGColorRef cgColor = [uiColor CGColor];
    
    int numComponents = CGColorGetNumberOfComponents(cgColor);

    if (numComponents == 4){
        static CGFloat * components = Nil;
        components = (CGFloat *) CGColorGetComponents(cgColor);
        return (CGFloat *)components;
    } else { //否则默认返回黑色
        static CGFloat components[4] = {0};
        CGFloat f = 0;
         //非RGB空间的系统颜色单独处理
        if ([uiColor isEqual:[UIColor whiteColor]]) {
            f = 1.0;
        } else if ([uiColor isEqual:[UIColor lightGrayColor]]) {
            f = 0.8;
        } else if ([uiColor isEqual:[UIColor grayColor]]) {
            f = 0.5;
        }
        components[0] = f;
        components[1] = f;
        components[2] = f;
        components[3] = 1.0;
        return (CGFloat *)components;
    }
}

@end
