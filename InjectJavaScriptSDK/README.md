# EmbeddedJavaScriptSDK

此为 [iOS 在第三方 H5 页面中插入 JS 的方案说明](https://www.sensorsdata.cn/manual/ios_sdk_js.html) 的演示文档。其中：

1. LocalFile 的 Demo 代表注入的 JS 代码是以文件形式存储在客户端中；
2. Remote 的 Demo 代表注入的 JS 代码是以文件形式存储在客户的服务器中（在 Demo 中使用的是 GitHub Pages ）。

JS 代码是通过神策后台数据接入模块的 JavaScript SDK 自动生成工具来生成的，但在存储为本地文件或上传到服务器前要把首尾的 <script> 标签删除。删除后的代码形如：

```javascript
(function(para) {
  var p = para.sdk_url, n = para.name, w = window, d = document, s = 'script',x = null,y = null;
  if(typeof(w['sensorsDataAnalytic201505']) !== 'undefined') {
      return false;
  }
  w['sensorsDataAnalytic201505'] = n;
  w[n] = w[n] || function(a) {return function() {(w[n]._q = w[n]._q || []).push([a, arguments]);}};
  var ifs = ['track','quick','register','registerPage','registerOnce','trackSignup', 'trackAbtest', 'setProfile','setOnceProfile','appendProfile', 'incrementProfile', 'deleteProfile', 'unsetProfile', 'identify','login','logout','trackLink','clearAllRegister','getAppStatus'];
  for (var i = 0; i < ifs.length; i++) {
    w[n][ifs[i]] = w[n].call(null, ifs[i]);
  }
  if (!w[n]._t) {
    x = d.createElement(s), y = d.getElementsByTagName(s)[0];
    x.async = 1;
    x.src = p;
    x.setAttribute('charset','UTF-8');
    w[n].para = para;
    y.parentNode.insertBefore(x, y);
  }
})({
  sdk_url: 'https://static.sensorsdata.cn/sdk/1.14.13/sensorsdata.min.js',
  heatmap_url: 'https://static.sensorsdata.cn/sdk/1.14.13/heatmap.min.js',
  name: 'sa',
  // 打通 App 与 H5
  use_app_track:true,
  server_url: 'https://sdktest.datasink.sensorsdata.cn/sa?token=21f2e56df73988c7&project=zhangzhankai',
  heatmap:{}
});
sa.quick('autoTrack');
```

