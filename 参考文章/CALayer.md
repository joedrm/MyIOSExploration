### CALayer几个概念：

 1. 在iOS中，你能看得见摸得着的东西基本上都是UIView，比如一个按钮、一个文本标签、一个文本输入框、一个图标等等，这些都是UIView
 2. 其实UIView之所以能显示在屏幕上，完全是因为它内部的一个图层
 3. 在创建UIView对象时，UIView内部会自动创建一个图层(即CALayer对象)，通过UIView的layer属性可以访问这个层

        @property(nonatomic,readonly,retain) CALayer *layer;
 4. 换句话说，UIView本身不具备显示的功能，是它内部的层才有显示功能
 
### 面试题：有了UIView为什么还需要CALayer，CALayer和UIView的有什么区别？
![UIView和CALayer](http://ohgbgkbn4.bkt.clouddn.com/UIView%E5%92%8CCALayer.png)

### position和anchorPoint
![position和anchorPoint](http://ohgbgkbn4.bkt.clouddn.com/position%E5%92%8CanchorPoint.png)

### 涉及到角度的问题，起始角和结束角，这里的角度使使用弧度制来表示
![π](http://ohgbgkbn4.bkt.clouddn.com/2%CF%80.png)

### UIView与核心动画对比?   1. UIView和核 动画区别? 
    核心动画只能添加到CALayer 核 动画 切都是假象，并不会改变真实的值。
  2. 什么时候使 UIView的动画? 
    如果需要与 户交互就使 UIView的动画. 不需要与 户交互可以使 核 动画  3. 什么场景使 核 动画最多? 
    在转场动画中，核 动画的类型 较多 根据 个路径做动画，只能 核 动画(帧动画) 动画组:同时做多个动画

