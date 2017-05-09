


//页面的业务逻辑
$(document).ready(function(){


    /*开始编程*/
    /*产品相关*/
    /*实例化*/
    var product =  new Product()
    product.name='HM休闲服登山包44'
    product.description='棒棒的，棒棒的，登山一流，服务一流，你好，我好，他也好，太棒了，一口气等上珠穆朗玛峰'
    product.normalPrice=144
    product.groupbuyPrice=120
    product.buySum=100;
    product.images=[
        {small:'images/s11.jpg',big:'images/s11.jpg'},
        {small:'images/s12.jpg',big:'images/s12.jpg'},
        {small:'images/s13.jpg',big:'images/s13.jpg'}
    ]
    /*使用对象中的方法属性*/
    product.bindDOMDetail()
    product.bindDOMImage()

    /*绑定事件*/
    $('#btnaddcart').click(function(){
        /*购物车新增一个产品*/
        console.log('12222')
        cart.products.push(product)
        ///*更新购物车 - 重新绑定购物车*/
        /*如果不封装，这里就可能产生代码重复*/
        cart.bindBasic()
        cart.bindList()
        $(window).scrollTop(0);
    });





    /*实例购物车*/
    var cart =  new Cart()
    cart.sum=3
    cart.allPrice=2000

    /*假设购物车中已经有三个产品*/
    cart.products.push(product)
    cart.products.push(product)
    cart.products.push(product)

    /*使用对象中的方法属性*/
    cart.bindBasic()
    cart.bindList()

});