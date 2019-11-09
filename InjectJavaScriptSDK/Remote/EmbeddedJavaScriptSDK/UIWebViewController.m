//
//  UIWebViewController.m
//  InjectJavaScriptSDK
//
//  Created by 张占凯 on 2019/11/6.
//  Copyright © 2019 Sensors Data. All rights reserved.
//

#import "UIWebViewController.h"

@interface UIWebViewController () <UIWebViewDelegate>

@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *url = @"https://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    UIWebView *webView = [UIWebView.alloc initWithFrame:UIScreen.mainScreen.bounds];
    [webView setDelegate:self];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    // 在这里添加您的逻辑代码

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 1.远程文件地址
    NSString *remotePath = @"https://rzhangzk.github.io/SensorsData-Demos/inject_js_sdk.js";
    // 2.拼接在 script.src 位置，拼接可执行的 JS 字符串
    NSString *js = [NSString stringWithFormat:
                    @"var script = document.createElement('script');\n"
                    "script.type = 'text/javascript';\n"
                    "script.src = \'%@\';"
                    "document.getElementsByTagName('head')[0].appendChild(script);\n"
                    , remotePath];

    // 4.执行上面的代码，注入 JS SDK
    [webView stringByEvaluatingJavaScriptFromString:js]; // 添加到head标签中
}

@end
