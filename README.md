# MYPhotoBrowser

<b>简易照片图片浏览器 。 实现滑动浏览 ， 点击捏合放大缩小 ，照片说明，照片回调操作 。从当前点击照片开始动画，当前照片结束动画等 . 功能继续完善中 ... 逐渐会加入GIF ， 小视频等功能 ...一般项目中需求已经足够。


<p>

## 1. 常规使用 ， 照片预览，照片放大缩小 ， 长按保存等操作。

<b>值得注意的是： 一般来说 ， 展示的小照片服务器会返回一个小图URL , 这个URL是你用于页面展示使用，每张图服务器还会返回一个大图的URL ，这个大图的URL则是用于照片放大预览后加载使用 。 所以你只需要把大图的URL参数传入即可 ，详情请见demo
<p>
![image](https://github.com/coderMyy/MYPhotoBrowser/MYPhotoBrowser/MYPhotoBrowser_Example/blob/master/descImg/GIF.gif)

<p>

## 2. 带有文本描述使用
<b> 当只有一张图时 ， 默认指示器是不显示的 ， 指示器默认为小圆点 ， 你也可以设置成数字，比如 1/9 这样的格式 ， 文本描述只要你赋值了就会显示,详情请见demo
<p>
![image](https://github.com/coderMyy/MYPhotoBrowser/blob/master/descImg/GIF1.gif)
