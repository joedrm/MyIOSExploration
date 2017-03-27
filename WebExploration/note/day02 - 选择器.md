**目录**

* [css基础选择器](#basic_selector)
    * [标签选择器](#tag_selector)
    * [id 选择器](#id_selector)
    * [类选择器](#class_selector)
    * [到底用id还是用class？](#discuss_selector)
* [高级选择器](#classic_selector)
    * [后代选择器](#houdai_selector)
    * [交集选择器](#jiaoji_selector)
    * [并集选择器（分组选择器）](#binji_selector)
    * [通配符](#tongpeifu_selector)
    * [儿子选择器](#son_selector)
    * [序选择器](#xu_selector)
    * [下一个兄弟选择器](#brother_selector)

<a name="basic_selector"></a>
### css基础选择器
html负责结构，css负责样式，js负责行为。css写在head标签里面，容器style标签。先写选择器，然后写大括号，大括号里面是样式

```css
body{
    background-color: pink;
}
/** 常见属性*/
h1{
    color:blue;
    font-size: 60px;
    font-weight: normal;
    text-decoration: underline;
    font-style: italic;
}
```

<a name="tag_selector"></a>
#### 标签选择器

标签选择器: 就是用标签名来当做选择器。
- 所有标签都能够当做选择器，比如body、h1、dl、ul、span等等
- 不管这个标签藏的多深，都能够被选择上。
- 选择的是所有的，而不是某一个。所以是共性，而不是特性。

```css

a{
    /*去掉下划线：*/
    text-decoration: none; 
}
```
<a name="id_selector"></a>
#### id 选择器
`#`表示选择 id
```css
#lj1{
    font-size: 60px;
    font-weight: bold;
    color:black;
}
```

- 任何的标签都可以有 `id`，`id` 的命名要以字母开头，可以有数字、下划线。大小写严格区别，也就是说 mm 和 MM 是两个不同的`id`。
- 同一个页面内`id`不能重复，即使不一样的标签，也不能是相同的 `id`。
- 也就是说，如果有一个 `p` 的 `id` 叫做 `haha`，这个页面内，其他所有的元素的 `id` 都不能叫做 `haha`。

<a name="class_selector"></a>
#### 类选择器

`.`就是类的符号。类的英语叫做class。

所谓的类，就是class属性，class属性和id非常相似，任何的标签都可以携带class属性。

1. class属性可以重复，比如，页面上可能有很多标签都有teshu这个类：

```html
    <h3>我是一个h3啊</h3>	
    <h3 class="teshu">我是一个h3啊</h3>	
    <h3>我是一个h3啊</h3>	
    <p>我是一个段落啊</p>	
    <p class="teshu">我是一个段落啊</p>	
    <p class="teshu">我是一个段落啊</p>
```

css 代码
```css
.teshu{
    color: red;
}
```
同一个标签，可能同时属于多个类，用空格隔开
这个h3就同时属于teshu类，也同时属于zhongyao类
```html
<h3 class="teshu  zhongyao">我是一个h3啊</h3>
```

例子：实现如下效果
正确的思路，就是用所谓“公共类”的思路，就是我们类就是提供“公共服务”，比如有绿、大、线，一旦携带这个类名，就有相应的样式变化：
```html
<p class="lv da">段落1</p><p class="lv xian">段落2</p><p class="da xian">段落3</p>
```
`css`代码
```css
.lv{
    color:green;
    }
.da{
    font-size: 60px;
    }
.xian{
    text-decoration: underline;
    }
```
也就是说：
1. 不要去试图用一个类名，把某个标签的所有样式写完。这个标签要多携带几个类，共同造成这个标签的样式。
2. 每一个类要尽可能小，有“公共”的概念，能够让更多的标签使用。

<a name="discuss_selector"></a>

#### 到底用id还是用class？

**答案**：标准：类上样式，id上行为。尽可能的用class，除非极特殊的情况可以用id。
**原因**：id是js用的。也就是说，js要通过id属性得到标签，所以我们css层面尽量不用id，要不然js就很别扭。另一层面，我们会认为一个有id的元素，有动态效果。

![class&id](http://omnfttj93.bkt.clouddn.com/class&id.png)

<a name="classic_selector"></a>

### css高级选择器

<a name="houdai_selector"></a>
#### 后代选择器

```css
.div1 p{
    color:red;
}
```
` `空格就表示后代，`.div1 p` 就是`.div1`的后代所有的`p`。强调一下，选择的是后代，不一定是儿子。

```html
<ul>
	<li>
		<p>段落</p>
		<p>段落</p>
		<p>段落</p>
	</li>
</ul>
```

能够被下面的选择器选择上：

```css
div1 p{
    color:red;
}
```
所以，看见这个选择器要知道是后代，而不是儿子。选择的是所有.div1“中的”p，就是后代p
空格可以多次出现。
```css

.div1 .li2 p{
         color:red;
 }
```

就是`.div1`里面的后代`.li2`里面的`p`。

总结：
* 后代选择器，就是一种平衡：共性、特性的平衡。当要把某一个部分的所有的什么，进行样式改变，就要想到后代选择器。
* 后代选择器，描述的是祖先结构。
![](http://omnfttj93.bkt.clouddn.com/%E5%90%8E%E4%BB%A3%E9%80%89%E6%8B%A9%E5%99%A8.png)

<a name="jiaoji_selector"></a>

#### 交集选择器
![](http://omnfttj93.bkt.clouddn.com/%E4%BA%A4%E9%9B%86%E9%80%89%E6%8B%A9%E5%99%A8.png)
```css
h3.special{	color:red;}
```
选择的元素是同时满足两个条件：必须是h3标签，然后必须是special标签。
**注意**：
    1. 交集选择器没有空格。`h3.special` 和 `h3 .special`完全是两个意思
    2. 交集选择器，我们一般都是以标签名开头，比如 `div.haha`  比如:`p.special`。
    
<a name="binji_selector"></a>

#### 并集选择器（分组选择器）
```css
h3,li{	color:red;}
```
`,` 用逗号就表示并集

<a name="tongpeifu_selector"></a>

#### 通配符
```css
*{	color:red;}
```
`*` 就表示所有元素。效率不高，如果页面上的标签越多，效率越低，所以页面上不能出现这个选择器。

<a name="son_selector"></a>

#### 儿子选择器
```css
div>p{	color:red;}
```
div的儿子p。和div的后代p的截然不同。
```html
<div>	<p>我是div的儿子</p></div>
```
这样是不能选的：
```html
    <div>		<ul>			<li>				<p>我是div的重孙子</p>			</li>		</ul>	</div>
```

<a name="xu_selector"></a>


#### 序选择器
**注：**IE8开始兼容；IE6、7都不兼容

选择第1个li：
```css
ul li:first-child{			color:red;		}
```
选择最后一个1i：
```css
ul li:last-child{			color:blue;}
```
浏览器不兼容解决方案：由于浏览器的更新需要过程，所以现在如果公司还要求兼容IE6、7，那么就要自己写类名：
```html
    <ul>		<li class="first">项目</li>		<li>项目</li>		<li>项目</li>		<li>项目</li>		<li>项目</li>		<li>项目</li>		<li>项目</li>		<li>项目</li>		<li>项目</li>		<li class="last">项目</li>	</ul>
```
用类选择器来选择第一个或者最后一个：
```css
ul li.first{			color:red;		}		
ul li.last{			color:blue;		}
```

<a name="brother_selector"></a>


#### 下一个兄弟选择器
**注：**IE7开始兼容，IE6不兼容。
`+` 表示选择下一个兄弟
```css
h3+p{		color:red;	}
```
选择上的是h3元素后面紧挨着的第一个兄弟。
```html
<div class="adjacent">
        <h3>这是一个标题</h3>
        <p>这是一个文字段落</p>
        <p>这是一个文字段落</p>
        <h3>这是一个标题</h3>
        <p>这是一个文字段落</p>
        <h3>这是一个标题</h3>
        <p>这是一个文字段落</p>
        <p>这是一个文字段落</p>
        <p>这是一个文字段落</p>
        <p>这是一个文字段落</p>
</div>
```
显示效果：
![相邻选择器](http://omnfttj93.bkt.clouddn.com/%E7%9B%B8%E9%82%BB%E9%80%89%E6%8B%A9%E5%99%A8.png?imageView2/2/w/300/h/300)
















