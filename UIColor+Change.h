//
//  UIColor+Change.h
//  ChangeColor
//
//  Created by 杜子兮 on 14-3-13.
//  Edited  by 杜子兮 on 14-5-23.
//  Edited  by 杜子兮 on 14-7-12. for Canvas.
//  Copyright (c) 2014年 莲兮奈若何. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Change)

///  获取canvas用的颜色字符串
- (NSString *)canvasColorString;

///获取网页颜色字串
- (NSString *) webColorString;

///获取RGB值
- (CGFloat *) getRGB;

///让颜色更亮
- (UIColor *) lighten;

///让颜色更暗
- (UIColor *) darken;

///取两个颜色的中间
- (UIColor *) mix: (UIColor *) color;



@end
