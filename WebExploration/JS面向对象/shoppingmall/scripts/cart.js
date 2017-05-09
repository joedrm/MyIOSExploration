//定义产品对象

var Cart = Class.extend({
    init: function(){
        this.products=[]
        this.sum=3
        this.allPrice=2000
    },
    bindBasic:function(){
        //绑定
        $('.cartsum').html(this.getSum())
        $('#cartprice').html(this.getAllPrice())
    },
    //绑定产品列表,每次点击到购物车执行的方法
    bindList:function(){
        var str=''
        for(var i= 0,len=this.products.length;i<len;i++){
            str+='<div class="cart_box">'
            str+='<div class="message">'
            str+=' <div class="alert-close"> </div>'
            str+=' <div class="list_img"> <img src="'+this.products[i].images[0].small+'" class="img-responsive" alt=""/> </div>'
            str+=' <div class="list_desc"><h4><a href="#">'+this.products[i].name+'</a></h4><span class="actual">'+ this.products[i].groupbuyPrice+'</span></div>'
            str+=' <div class="clearfix"></div>'
            str+='  <div class="clearfix"></div>'
            str+='  </div>'
            str+='   </div>'
        }
        $('.shopping_cart').html(str)

    },
    /*结算*/
    calcalate:function(){},
    /*获取产品个数*/
    getSum:function(){
        this.sum=this.products.length;
        return this.sum;
    },
    /*获取产品总价*/
    getAllPrice:function(){
        for(var i= 0,len=this.products.length;i<len;i++){
            this.allPrice+=this.products[i].groupbuyPrice;
        }
        return this.allPrice;
    }
});
