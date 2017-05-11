/**
 * Created by wdy on 2017/5/10.
 */
function A(name){
    this.name = name;
    this.sayHello = function(){
        console.log(this.name+"say Hello!");
    };
}

function B(name,id){
    this.temp = A;
    this.temp(name);        //相当于new A();
    delete this.temp;
    this.id = id;
    this.checkId = function(ID){
        console.log(this.id==ID)
    };
}

var b = new B('zhang', 12);
console.log(b.name);
console.log(b.id);
console.log(b.sayHello());
console.log(b.checkId());