//
//  WKWebViewController.m
//  InjectJavaScriptSDK
//
//  Created by 张占凯 on 2019/11/6.
//  Copyright © 2019 Sensors Data. All rights reserved.
//

#import "WKWebViewController.h"

#import <WebKit/WebKit.h>

@interface WKWebViewController () <WKNavigationDelegate>

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *url = @"https://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    WKWebView *webView = [WKWebView.alloc initWithFrame:UIScreen.mainScreen.bounds];
    [webView setNavigationDelegate:self];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:navigationAction.request]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    //在这里添加您的逻辑代码

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
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
    [webView evaluateJavaScript:js completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    }]; // 添加到head标签中
}

@end
