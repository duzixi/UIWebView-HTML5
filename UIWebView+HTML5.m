//
//  UIWebView+HTML5.m
//
//  Created by 杜子兮 on 14-6-30.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥. All rights reserved.
//

#import "UIWebView+HTML5.h"
#import "UIColor+Change.h"

@implementation UIWebView (JavaScript)

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

///  改变背景颜色
- (void)setBackgroundColor:(UIColor *)color
{
    NSString * jsString = [NSString stringWithFormat:@"document.body.style.backgroundColor = '%@'",[color webColorString]];
    [self stringByEvaluatingJavaScriptFromString:jsString];
}

///  为所有图片添加点击事件(网页中有些图片添加无效)
- (void)addClickEventOnImg
{
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        //利用重定向获取img.src，为区分，给url添加'img:'前缀
        NSString *jsString = [NSString stringWithFormat:
            @"document.getElementsByTagName('img')[%d].onclick = \
              function() { document.location.href = 'img:' + this.src; }",i];
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
