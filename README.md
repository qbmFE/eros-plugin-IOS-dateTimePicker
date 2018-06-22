# 日期时间选择器插件

基于WEEX二次开发的日期时间选择器插件

安装 
====================================

1. 打开iOS目录`工程目录/platforms/ios/WeexEros`，编辑Podfile文件（'pod v1.4.0,这个非常重要'），增加以下代码；

```
 pod 'QBMDateTimePicker', :git => 'https://github.com/qbmFE/eros-plugin-IOS-dateTimePicker.git', :tag => '1.0.2'
```

2. 到此目录下执行 `pod update`


使用
====================================


```js
//引入module
const dateTimePicker = weex.requireModule('dateTimePicker');
```

API
====================================

```js
// 示例 具体用法参考demo/dateTimePicker.vue
dateTimePicker.open({
  value: '',//必选,选中的值，格式为yyyy-MM-dd HH:mm;当value为空,默认选中当前时间;当value不为空时,选中value的返回值
  max: '',//可选，日期最大值,默认2099-12-31 23:59
  min: '',//可选，日期最小值,默认1900-12-31 00:00
  title: '',//可选，标题的文案，默认为空
  titleColor: '',//可选，默认为空,title不为空时有效，颜色值（#313131）
  confirmTitle: '', //确认按钮的文案,默认值（完成）
  confirmTitleColor: '', //确认按钮的文字颜色，默认值(#00b4ff)
  cancelTitle: '', //取消按钮的文案,默认值（取消）
  cancelTitleColor: '', //取消按钮的文字颜色,默认值(#313131)
},(res) =>{//回调
  //返回字段
  //result{string}：success,cancel
  //data {string}：格式为yyyy-MM-dd HH:mm
  if(res.result === "success"){
    //业务逻辑
  }else{
    //业务逻辑
  }
});

```
界面截图
====================================

![](https://image.qbm360.com/demo/IOS-dateTimePicker.gif)

更新日志
====================================

* 发布iOS版日期时间选择器1.0.0 beta1(2018-05-31)；
* 调整插件UI,适配iPhone X，版本更新至1.0.1(2018-06-22)；

License
====================================
Copyright (c) 2018 钱保姆大前端

