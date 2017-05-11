/**
 * Created by wdy on 2017/5/10.
 */

Array.prototype.unique1 = function () {
    var n = []; //一个新的临时数组
    for (var i = 0; i < this.length; i++) //遍历当前数组
    {
        //如果当前数组的第i已经保存进了临时数组，那么跳过，
        //否则把当前项push到临时数组里面
        if (n.indexOf(this[i]) == -1) n.push(this[i]);
    }
    return n;
}

Array.prototype.unique2 = function()
{
    var n = {},r=[]; //n为hash表，r为临时数组
    for(var i = 0; i < this.length; i++) //遍历当前数组
    {
        if (!n[this[i]]) //如果hash表中没有当前项
        {
            n[this[i]] = true; //存入hash表
            r.push(this[i]); //把当前数组的当前项push到临时数组里面
        }
    }
    return r;
}

Array.prototype.unique3 = function()
{
    var n = [this[0]]; //结果数组
    for(var i = 1; i < this.length; i++) //从第二项开始遍历
    {
        //如果当前数组的第i项在当前数组中第一次出现的位置不是i，
        //那么表示第i项是重复的，忽略掉。否则存入结果数组
        if (this.indexOf(this[i]) == i) n.push(this[i]);
    }
    return n;
}

Array.prototype.unique4 = function () {
    var obj = {}, newArr = [];
    for (i = this.length - 1; i >=0; i --){
        console.log(obj[this[i]]);
        
        if (obj[this[i]] == undefined || obj[this[i]] !== this[i]){
            obj[this[i]] = this[i];
            newArr.push(this[i]);
        }
    }
    // console.log(obj);
    return newArr;
};

var arr = [1,2,'2',3,3,4,5,4,6,7,8,6,9,0,'a','ab','a'];
console.log(arr.unique4());