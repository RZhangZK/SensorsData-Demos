# 使用说明

## 1.测试时需要修改的内容

**数据接收地址**：AppDelegate.m 中 16 行

```objective-c
static NSString *const SAServerURL = @"数据接收地址";
```

**网页地址**：App.js 中 39 行

```javascript
source={{uri: '网页地址'}}
```

**注意**：网页中设置的数据接收地址要与 App 内设置的一致。

---

## 2.需要修改的代码

 [AppDelegate.m](ios/RNGetThroughH5/AppDelegate.m) 

44 行添加：

```objective-c
[SensorsAnalyticsSDK.sharedInstance addWebViewUserAgentSensorsDataFlag];
```

 [RNCWebView.m](../node_modules/react-native-webview/ios/RNCWebView.m) 

823 行添加：

```objective-c
    Class SensorsAnalyticsSDKClass = NSClassFromString(@"SensorsAnalyticsSDK");
    if (SensorsAnalyticsSDKClass) {
        SEL sharedInstanceSelector = NSSelectorFromString(@"sharedInstance");
        SEL showUpWebViewWithRequestSelector = NSSelectorFromString(@"showUpWebView:WithRequest:");
        if (sharedInstanceSelector && showUpWebViewWithRequestSelector) {
            IMP sharedInstanceImp = [SensorsAnalyticsSDKClass methodForSelector:sharedInstanceSelector];
            id (*sharedInstanceImplementation)(id, SEL) = (id (*)(id, SEL))sharedInstanceImp;
            id sharedInstance = sharedInstanceImplementation(SensorsAnalyticsSDKClass, sharedInstanceSelector);

            IMP showUpWebViewWithRequestImp = [sharedInstance methodForSelector:showUpWebViewWithRequestSelector];
            BOOL (*showUpWebViewWithRequestImplementation)(id, SEL, id, NSURLRequest *) = (BOOL (*)(id, SEL, id, NSURLRequest *))showUpWebViewWithRequestImp;
            if (showUpWebViewWithRequestImplementation(sharedInstance, showUpWebViewWithRequestSelector, webView, navigationAction.request)) {
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }
    }
```

添加后效果：

```objective-c
- (void)                  webView:(WKWebView *)webView
  decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                  decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  static NSDictionary<NSNumber *, NSString *> *navigationTypes;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    navigationTypes = @{
      @(WKNavigationTypeLinkActivated): @"click",
      @(WKNavigationTypeFormSubmitted): @"formsubmit",
      @(WKNavigationTypeBackForward): @"backforward",
      @(WKNavigationTypeReload): @"reload",
      @(WKNavigationTypeFormResubmitted): @"formresubmit",
      @(WKNavigationTypeOther): @"other",
    };
  });

  Class SensorsAnalyticsSDKClass = NSClassFromString(@"SensorsAnalyticsSDK");
  if (SensorsAnalyticsSDKClass) {
      SEL sharedInstanceSelector = NSSelectorFromString(@"sharedInstance");
      SEL showUpWebViewWithRequestSelector = NSSelectorFromString(@"showUpWebView:WithRequest:");
      if (sharedInstanceSelector && showUpWebViewWithRequestSelector) {
          IMP sharedInstanceImp = [SensorsAnalyticsSDKClass methodForSelector:sharedInstanceSelector];
          id (*sharedInstanceImplementation)(id, SEL) = (id (*)(id, SEL))sharedInstanceImp;
          id sharedInstance = sharedInstanceImplementation(SensorsAnalyticsSDKClass, sharedInstanceSelector);

          IMP showUpWebViewWithRequestImp = [sharedInstance methodForSelector:showUpWebViewWithRequestSelector];
          BOOL (*showUpWebViewWithRequestImplementation)(id, SEL, id, NSURLRequest *) = (BOOL (*)(id, SEL, id, NSURLRequest *))showUpWebViewWithRequestImp;
          if (showUpWebViewWithRequestImplementation(sharedInstance, showUpWebViewWithRequestSelector, webView, navigationAction.request)) {
              decisionHandler(WKNavigationActionPolicyCancel);
              return;
          }
      }
  }

  WKNavigationType navigationType = navigationAction.navigationType;
  NSURLRequest *request = navigationAction.request;

  if (_onShouldStartLoadWithRequest) {
    NSMutableDictionary<NSString *, id> *event = [self baseEvent];
    [event addEntriesFromDictionary: @{
      @"url": (request.URL).absoluteString,
      @"mainDocumentURL": (request.mainDocumentURL).absoluteString,
      @"navigationType": navigationTypes[@(navigationType)]
    }];
    if (![self.delegate webView:self
      shouldStartLoadForRequest:event
                   withCallback:_onShouldStartLoadWithRequest]) {
      decisionHandler(WKNavigationActionPolicyCancel);
      return;
    }
  }

  if (_onLoadingStart) {
    // We have this check to filter out iframe requests and whatnot
    BOOL isTopFrame = [request.URL isEqual:request.mainDocumentURL];
    if (isTopFrame) {
      NSMutableDictionary<NSString *, id> *event = [self baseEvent];
      [event addEntriesFromDictionary: @{
        @"url": (request.URL).absoluteString,
        @"navigationType": navigationTypes[@(navigationType)]
      }];
      _onLoadingStart(event);
    }
  }

  // Allow all navigation by default
  decisionHandler(WKNavigationActionPolicyAllow);
}
```

