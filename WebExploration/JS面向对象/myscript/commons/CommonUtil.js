/**
 * @author	Direction
 */


/**
 *  BH 命名空间  namespace
 */
var BH = {} ;

/**
 * Interface Class
 * 接口类需要2个参数
 * 参数1: 接口的名字 (string)
 * 参数2: 接受方法名称的集合(数组) (array)
 */
BH.Interface = function(name,methods){
	//判断接口的参数个数
	if(arguments.length != 2){
		throw new Error('this instance interface constructor arguments must be 2 length!');
	}
	this.name = name ; 
	this.methods = [] ; //定义一个内置的空数组对象 等待接受methods里的元素(方法名字)
	for(var i = 0,len = methods.length ; i <len ; i++){
		 if( typeof methods[i] !== 'string'){
		 		throw new Error('the Interface method name is error!');
		 }
		 this.methods.push(methods[i]);
	}
}


/**
 * Interface static method 
 * @param {Object} object
 */
// 三：检验接口里的方法
// 如果检验通过 不做任何操作 不通过：浏览器抛出error
// 这个方法的目的 就是检测方法的
BH.Interface.ensureImplements = function(object){
	// 如果检测方法接受的参数小于2个 参数传递失败!
	if(arguments.length < 2 ){
		throw new Error('Interface.ensureImplements method constructor arguments must be  >= 2!');
	}
	
	// 获得接口实例对象 
	for(var i = 1 , len = arguments.length; i<len; i++ ){
		var instanceInterface = arguments[i];
		// 判断参数是否是接口类的类型
		if(instanceInterface.constructor !== BH.Interface){
			throw new Error('the arguments constructor not be Interface Class');
		}
		// 循环接口实例对象里面的每一个方法
		for(var j = 0 ; j < instanceInterface.methods.length; j++){
			// 用一个临时变量 接受每一个方法的名字(注意是字符串)
			var methodName = instanceInterface.methods[j];
			// object[key] 就是方法
			if( !object[methodName] || typeof object[methodName] !== 'function' ){
				throw new Error("the method name '" + methodName + "' is not found !");
			}
		}
	}
};



/**
 * EXTEND method
 * @param {Object} sub
 * @param {Object} sup
 */			
BH.extend=function(sub ,sup){
	 // 目的： 实现只继承父类的原型对象
	 var F = new Function();	// 1 创建一个空函数    目的：空函数进行中转
	 F.prototype = sup.prototype; // 2 实现空函数的原型对象和超类的原型对象转换
	 sub.prototype = new F(); 	// 3 原型继承 
	 sub.prototype.constructor = sub ; // 4还原子类的构造器
	 //保存一下父类的原型对象: 一方面方便解耦  另一方面方便获得父类的原型对象
	 sub.superClass = sup.prototype; //自定义一个子类的静态属性 接受父类的原型对象
	 //判断父类的原型对象的构造器 (加保险)
	 if(sup.prototype.constructor == Object.prototype.constructor){
	 	sup.prototype.constructor = sup ; //手动欢迎父类原型对象的构造器
	 }
};


/**
 * 单体模式
 * 实现一个跨浏览器的事件处理程序
 */
BH.EventUtil = {
	addHandler:function(element , type , handler){
		if(element.addEventListener){		//FF
			element.addEventListener(type,handler,false);
		} else if(element.attachEvent){		//IE
			element.attachEvent('on'+type , handler);
		}
	} , 
	removeHandler:function(element , type , handler){
		if(element.removeEventListener){		//FF
			element.removeEventListener(type,handler,false);
		} else if(element.detachEvent){		//IE
			element.detachEvent('on'+type , handler);
		}		
	}
};


/**
 * 扩展Array的原型对象 添加变量数组的每一个元素,并让每一个元素都执行fn函数 (可变量多维数组)
 * @param {Object} fn
 */
Array.prototype.each = function(fn){
	try{
		//1 目的： 遍历数组的每一项 //计数器 记录当前遍历的元素位置
		this.i || (this.i=0);  //var i = 0 ;
		//2 严谨的判断什么时候去走each核心方法
		// 当数组的长度大于0的时候 && 传递的参数必须为函数
		if(this.length >0 && fn.constructor == Function){
			// 循环遍历数组的每一项
			while(this.i < this.length){	//while循环的范围 
				//获取数组的每一项
				var e = this[this.i];
				//如果当前元素获取到了 并且当前元素是一个数组
				if(e && e.constructor == Array){
					// 直接做递归操作
					e.each(fn);
				} else {
					//如果不是数组 （那就是一个单个元素）
					// 这的目的就是为了把数组的当前元素传递给fn函数 并让函数执行
					//fn.apply(e,[e]);
					fn.call(e,e);
				}
				this.i++ ;
			}
			this.i = null ; // 释放内存 垃圾回收机制回收变量
		}
		
	} catch(ex){
		// do something 
	}
	return this ;
}


	

