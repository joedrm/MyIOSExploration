/**
 * Created by wdy on 2017/5/7.
 */


var arr = [1, 2, 3, [4, [5, 6]]];

Array.prototype.each = function (fn) {
    try{
        this.i || (this.i = 0);
        if (this.length>0 && (fn.constructor == Function)){
            while (this.i < this.length){
                var e = this[this.i];
                if (e && e.constructor == Array){
                    e.each(fn)
                }else {
                    fn.call(e,e);
                }
                this.i ++
            }
        }
    }catch(ex){

    }
    return this
}

arr.each(function (item) {
    console.log(item)
})