//
//  UIWebView+HTML5.h
//  WebViewJS
//
//  Created by 杜子兮(duzixi) on 14-6-30.
//  Edited  by 杜子兮(duzixi) on 14-7-11. 修改网页图片显示大小
//  Edited  by 杜子兮(duzixi) on 14-7-26. 添加 canvas API 类目
//  Copyright (c) 2014年 lanou3g.com 蓝鸥. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWebView (JavaScript)

#pragma mark -
#pragma mark 获取网页中的数据

///  获取某个标签的结点个数
- (int)nodeCountOfTag:(NSString *)tag;

///  获取当前页面URL
- (NSString *) getCurrentURL;

///  获取标题
- (NSString *) getTitle;

///  获取图片
- (NSArray *) getImgs;

///  获取当前页面所有链接
- (NSArray *) getOnClicks;

#pragma mark -
#pragma mark 改变网页样式和行为

///  改变背景颜色
- (void) setBackgroundColor:(UIColor *)color;

///  为所有图片添加点击事件(网页中有些图片添加无效)
- (void) addClickEventOnImg;

///  改变所有图像的宽度
- (void) setImgWidth:(int)size;

///  改变所有图像的高度
- (void) setImgHeight:(int)size;

///  改变指定标签的字体颜色
- (void) setFontColor:(UIColor *) color withTag:(NSString *)tagName;

///  改变指定标签的字体大小
- (void) setFontSize:(int) size withTag:(NSString *)tagName;

@end

#pragma mark -
#pragma mark 在网页上画图

@interface UIWebView (Canvas)

///  创建一个指定大小的画布
- (void)createCanvas:(NSString *)canvasId
               width:(NSInteger)width
              height:(NSInteger)height;

///  在指定位置创建一个指定大小的画布
- (void)createCanvas:(NSString *)canvasId
               width:(NSInteger)width
              height:(NSInteger)height
                   x:(NSInteger)x
                   y:(NSInteger)y;

///  绘制矩形填充  context.fillRect(x,y,width,height)
- (void)fillRectOnCanvas:(NSString *)canvasId
                       x:(NSInteger)x
                       y:(NSInteger)y
                   width:(NSInteger)width
                  height:(NSInteger)height
                 uicolor:(UIColor *)color;

///  绘制矩形边框  context.strokeRect(x,y,width,height)
- (void)strokeRectOnCanvas:(NSString *)canvasId
                         x:(NSInteger)x
                         y:(NSInteger)y
                     width:(NSInteger)width
                    height:(NSInteger)height
                   uicolor:(UIColor *)color
                 lineWidth:(NSInteger)lineWidth;

///  清除矩形区域  context.clearRect(x,y,width,height)
- (void)clearRectOnCanvas:(NSString *)canvasId
                        x:(NSInteger)x
                        y:(NSInteger)y
                    width:(NSInteger)width
                   height:(NSInteger) height;

///  绘制圆弧填充  context.arc(x, y, radius, starAngle,endAngle, anticlockwise)
- (void)arcOnCanvas:(NSString *)canvasId
            centerX:(NSInteger)x
            centerY:(NSInteger)y
             radius:(NSInteger)r
         startAngle:(float)startAngle
           endAngle:(float)endAngle
      anticlockwise:(BOOL)anticlockwise
            uicolor:(UIColor *)color;

///  绘制一条线段 context.moveTo(x,y)  context.lineTo(x,y)
- (void)lineOnCanvas:(NSString *)canvasId
                  x1:(NSInteger)x1
                  y1:(NSInteger)y1
                  x2:(NSInteger)x2
                  y2:(NSInteger)y2
             uicolor:(UIColor *)color
           lineWidth:(NSInteger)lineWidth;

///  绘制一条折线
- (void)linesOnCanvas:(NSString *)canvasId
               points:(NSArray *)points
             unicolor:(UIColor *)color
            lineWidth:(NSInteger)lineWidth;

///  绘制贝塞尔曲线 context.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y)
- (void)bezierCurveOnCanvas:(NSString *)canvasId
                         x1:(NSInteger)x1
                         y1:(NSInteger)y1
                       cp1x:(NSInteger)cp1x
                       cp1y:(NSInteger)cp1y
                       cp2x:(NSInteger)cp2x
                       cp2y:(NSInteger)cp2y
                         x2:(NSInteger)x2
                         y2:(NSInteger)y2
                   unicolor:(UIColor *)color
                  lineWidth:(NSInteger)lineWidth;

///  绘制二次样条曲线 context.quadraticCurveTo(qcpx,qcpy,qx,qy)
//     coming soon...

///  显示图像的一部分 context.drawImage(image,sx,sy,sw,sh,dx,dy,dw,dh)
- (void)drawImage:(NSString *)src
         onCanvas:(NSString *)canvasId
               sx:(NSInteger)sx
               sy:(NSInteger)sy
               sw:(NSInteger)sw
               sh:(NSInteger)sh
               dx:(NSInteger)dx
               dy:(NSInteger)dy
               dw:(NSInteger)dw
               dh:(NSInteger)dh;

@end
