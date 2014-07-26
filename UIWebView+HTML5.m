//
//  UIWebView+HTML5.m
//
//  Created by 杜子兮(duzixi) on 14-6-30.
//  Edited  by 杜子兮(duzixi) on 14-7-11. 修改网页图片显示大小
//  Edited  by 杜子兮(duzixi) on 14-7-26. 添加 canvas API 类目
//  Copyright (c) 2014年 lanou3g.com 蓝鸥. All rights reserved.
//

#import "UIWebView+HTML5.h"
#import "UIColor+Change.h"

@implementation UIWebView (JavaScript)

#pragma mark -
#pragma mark 获取网页中的数据

///  获取某个标签的结点个数
- (int)nodeCountOfTag:(NSString *)tag
{
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    int len = [[self stringByEvaluatingJavaScriptFromString:jsString] intValue];
    return len;
}

///  获取当前页面URL
- (NSString *)getCurrentURL
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
}

///  获取标题
- (NSString *)getTitle
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

///  获取所有图片链接
- (NSArray *)getImgs
{
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        [arrImgURL addObject:[self stringByEvaluatingJavaScriptFromString:jsString]];
    }
    return arrImgURL;
}

///  获取当前页面所有点击链接
- (NSArray *)getOnClicks
{
    NSMutableArray *arrOnClicks = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self nodeCountOfTag:@"a"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('a')[%d].getAttribute('onclick')", i];
        NSString *clickString = [self stringByEvaluatingJavaScriptFromString:jsString];
        NSLog(@"%@", clickString);
        [arrOnClicks addObject:clickString];
    }
    return arrOnClicks;
}

#pragma mark -
#pragma mark 改变网页样式和行为

///  改变背景颜色
- (void)setBackgroundColor:(UIColor *)color
{
    NSString * jsString = [NSString stringWithFormat:@"document.body.style.backgroundColor = '%@'",[color webColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  为所有图片添加点击事件(网页中有些图片添加无效,需要协议方法配合截取)
- (void)addClickEventOnImg
{
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        //利用重定向获取img.src，为区分，给url添加'img:'前缀
        NSString *jsString = [NSString stringWithFormat:
            @"document.getElementsByTagName('img')[%d].onclick = \
              function() { document.location.href = 'img' + this.src; }",i];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}

///  改变所有图像的宽度
- (void) setImgWidth:(int)size
{
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].width = '%d'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}

///  改变所有图像的高度
- (void) setImgHeight:(int)size
{
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].height = '%d'", i, size];
        [self stringByEvaluatingJavaScriptFromString:jsString];
    }
}

///  改变指定标签的字体颜色
- (void)setFontColor:(UIColor *)color withTag:(NSString *)tagName
{
    NSString *jsString = [NSString stringWithFormat:
        @"var nodes = document.getElementsByTagName('%@'); \
          for(var i=0;i<nodes.length;i++){\
              nodes[i].style.color = '%@';}", tagName, [color webColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  改变指定标签的字体大小
- (void)setFontSize:(int)size withTag:(NSString *)tagName
{
    NSString *jsString = [NSString stringWithFormat:
        @"var nodes = document.getElementsByTagName('%@'); \
          for(var i=0;i<nodes.length;i++){\
              nodes[i].style.fontSize = '%dpx';}", tagName, size];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}
@end


#pragma mark -
#pragma mark 在网页上画图

@implementation UIWebView (Canvas)

///  创建一个指定大小的透明画布
- (void)createCanvas:(NSString *)canvasId width:(NSInteger)width height:(NSInteger)height
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.createElement('canvas');"
                          "canvas.id = %@; canvas.width = %d; canvas.height = %d;"
                          "document.body.appendChild(canvas);"
                          "var g = canvas.getContext('2d');"
                          "g.strokeRect(%d,%d,%d,%d);",
                          canvasId, width, height, 0 ,0 ,width,height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  在指定位置创建一个指定大小的透明画布
- (void)createCanvas:(NSString *)canvasId width:(NSInteger)width height:(NSInteger)height x:(NSInteger)x y:(NSInteger)y
{
    //[self createCanvas:canvasId width:width height:height];
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.createElement('canvas');"
                          "canvas.id = %@; canvas.width = %d; canvas.height = %d;"
                          "canvas.style.position = 'absolute';"
                          "canvas.style.top = '%d';"
                          "canvas.style.left = '%d';"
                          "document.body.appendChild(canvas);"
                          "var g = canvas.getContext('2d');"
                          "g.strokeRect(%d,%d,%d,%d);",
                          canvasId, width, height, y, x, 0 ,0 ,width,height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  绘制矩形填充  context.fillRect(x,y,width,height)
- (void)fillRectOnCanvas:(NSString *)canvasId x:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger) height uicolor:(UIColor *)color
{
    
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"                          
                          "context.fillStyle = '%@';"
                          "context.fillRect(%d,%d,%d,%d);"
                          ,canvasId, [color canvasColorString], x, y, width, height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  绘制矩形边框  strokeRect(x,y,width,height)
- (void)strokeRectOnCanvas:(NSString *)canvasId x:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger) height uicolor:(UIColor *)color lineWidth:(NSInteger)lineWidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.strokeStyle = '%@';"
                          "context.lineWidth = '%d';"
                          "context.strokeRect(%d,%d,%d,%d);"
                          ,canvasId, [color canvasColorString], lineWidth, x, y, width, height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  清除矩形区域  context.clearRect(x,y,width,height)
- (void)clearRectOnCanvas:(NSString *)canvasId x:(NSInteger)x y:(NSInteger)y width:(NSInteger)width height:(NSInteger) height
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.clearRect(%d,%d,%d,%d);"
                          ,canvasId, x, y, width, height];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  绘制圆弧填充  context.arc(x, y, radius, starAngle,endAngle, anticlockwise)
- (void)arcOnCanvas:(NSString *)canvasId centerX:(NSInteger)x centerY:(NSInteger)y radius:(NSInteger)r startAngle:(float)startAngle endAngle:(float)endAngle anticlockwise:(BOOL)anticlockwise uicolor:(UIColor *)color
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.beginPath();"
                          "context.arc(%d,%d,%d,%f,%f,%@);"
                          "context.closePath();"
                          "context.fillStyle = '%@';"
                          "context.fill();",
                          canvasId, x, y, r, startAngle, endAngle, anticlockwise ? @"true" : @"false", [color canvasColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  绘制一条线段 context.moveTo(x,y)  context.lineTo(x,y)
- (void)lineOnCanvas:(NSString *)canvasId x1:(NSInteger)x1 y1:(NSInteger)y1 x2:(NSInteger)x2 y2:(NSInteger)y2 uicolor:(UIColor *)color lineWidth:(NSInteger)lineWidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.beginPath();"
                          "context.moveTo(%d,%d);"
                          "context.lineTo(%d,%d);"
                          "context.closePath();"
                          "context.strokeStyle = '%@';"
                          "context.lineWidth = %d;"
                          "context.stroke();",
                          canvasId, x1, y1, x2, y2, [color canvasColorString], lineWidth];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  绘制一条折线
- (void)linesOnCanvas:(NSString *)canvasId points:(NSArray *)points unicolor:(UIColor *)color lineWidth:(NSInteger)lineWidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.beginPath();",
                          canvasId];
    
    for (int i = 0; i < [points count] / 2; i++) {
        jsString = [jsString stringByAppendingFormat:@"context.lineTo(%@,%@);",
                    points[i * 2], points[i * 2 + 1]];
    }
    
    jsString = [jsString stringByAppendingFormat:@""
                "context.strokeStyle = '%@';"
                "context.lineWidth = %d;"
                "context.stroke();",
                [color canvasColorString], lineWidth];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

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
                  lineWidth:(NSInteger)lineWidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.beginPath();"
                          "context.moveTo(%d,%d);"
                          "context.bezierCurveTo(%d,%d,%d,%d,%d,%d);"
                          "context.strokeStyle = '%@';"
                          "context.lineWidth = %d;"
                          "context.stroke();",
                          canvasId, x1, y1, cp1x, cp1y, cp2x, cp2y, x2, y2, [color canvasColorString], lineWidth];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

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
               dh:(NSInteger)dh
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var image = new Image();"
                          "image.src = '%@';"
                          "var canvas = document.getElementById('%@');"
                          "var context = canvas.getContext('2d');"
                          "context.drawImage(image,%d,%d,%d,%d,%d,%d,%d,%d)",
                          src, canvasId, sx, sy, sw, sh, dx, dy, dw, dh];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

@end
