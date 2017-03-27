//
//  main.cpp
//  namespace
//
//  Created by fang wang on 17/3/27.
//  Copyright © 2017年 namespace. All rights reserved.
//

// iostream是C++的输入输出库
#include <iostream>
using namespace std;


// 结构体
struct Student {
    // 成员 变量
    int age = 22;
    double height = 1.89;
    char name[10] = "jack";
    
    // 两个参数的构造函数，不用返回值
    Student(int age1, double height1){
        age = age1;
        height = height1;
    }
    
    // 成员函数
    void study(int a){
        cout << "学生年龄是: "<< age << ", 身高是: " << height << ", 名字是: "<< name << endl;
        cout << "参数a ："<< a << endl;
    }
};

// C++中的结构体 就是 类
struct Date{
    int year;
    int month;
    int day;
    void output(){
        cout << year << "-" << month << "-" << day << endl;
    }
};

//结构体 作为参数
void fa(Date d){
    d.year ++;
}
void fb(Date *d){
    d->year ++;
}

Date fc(){
    Date d;
    return d;
}

Date* fd(){
    return NULL;
}



//------------------------------------------------------函数的重载 ------------------------------------------------------

void test(){
    cout <<  "test函数"  << endl;
}

void test(int a){
    cout <<  "test(int)函数"  << endl;
}

// 不能这样写
//void test(int a = 10){
//
//    cout <<  "test(int)函数"  << endl;
//};


//------------------------------------------------------ 引用Test ------------------------------------------------------


void mySwap (int &x , int &y){
    int temp = x;
    x = y;
    y = temp;
}

int age = 10;
int & test2(){
    return age;
}

int & add(int a, int b) {
    int sum = a + b;
    return sum;
}

//------------------------------------------------------ main ------------------------------------------------------
int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    
    int age = 20;
    double height = 1.89;
    char name[10] = "jack";
    // std::cout << "my age is " << age << ", height is " << height << ", name is " << name  << std::endl;
    
    // 如果导入了命名空间 using namespace std; 也可以这样输出
    cout << "my age is " << age << ", height is " << height << ", name is " << name  << endl;
    
    /*
     1、endl——》end line  表示换行的意思，相当于\n；
     2、std::cout cout这个对象是定义在 std 命名空间中的，使用命名空间，可以避免由于无意中使用了与库中所定义名字相同的名字儿引起冲突。
     :: 作用域操作符，表示使用的是定义在命名空间std中的cout
     3、using namespace std; 放在头文件下面，提前使用命名空间std
     4、输出函数 cin 的使用   cin << age；
     5、namespace  命名空间也称名字空间，是一种描述逻辑分组的机制，防止命名冲突，一个名字空间的成员必须采用如下的记法形式引入：
     namespace namespace-name{ //声明和定义
     
     } 。// 一个名字空间也是一个作用域，一个程序越大，通过名字空间去描述其中逻辑上独立的各个部分也就越重要
     */
    
    // ------------------------------------------------------ 结构体 ------------------------------------------------------
    
    //    struct Student s2 = Student(22, 1.78);
    Student s2 = Student(22, 1.78);
    s2.study(12);
    /*
     1）C++中定义结构体变量时， struct可有可无的
     2）C语言的结构体里面是不能加函数的，而在C++里面是有成员函数的
     3）也可以有构造函数
     */
    
    
    // ------------------------------------------------------指针与结构体的关系 ------------------------------------------------------
    
    Date d = {2013,12,18};//给结构体里面的变量赋值
    //用”.“直接利用结构体变量 访问结构体内部的 成员变量 和 成员方法
    cout << d.year << endl;
    d.output();
    
    
    //把结构体变量 d 的地址给了指针变量 p，也就是说指针p指向了d的地址
    Date *p = &d;
    // "->" 利用指针变量间接访问它所指向的结构体内部的 成员变量 和 成员函数
    cout << p->year << endl;
    p->output();
    
    fa(d);// 值传递
    fb(&d);// 地址传递
    
    
    //------------------------------------------------------默认值 ------------------------------------------------------
    /**
     默认值：在C++语言里面，形参可以给默认的值，而在C语言里面是不行的
     原则：如果某个形参没有默认值，那么它左边的参数就不能有默认值的，
     比如 void test(int a = 20, int b) 的写法是错误的
     **/
    
    
    //------------------------------------------------------函数的重载 ------------------------------------------------------
    test(); // 调用的是第一个函数
    test(20); // 调用的是第二个函数
    // 上面两个函数构成重构
    
    /*
     void test() 与 void test(int a) 构成重载，函数的名字相同，而参数列表不同。
     void test(int a = 10) 再去调用 test();会报错的，此时编译器出现歧义，
     因为 void test(int a = 10) 有默认值时也可以用 test();来调用。
     两个方法共存时就会报错的，这个歧义称为”二义性“
                 
     C++之所以能构成重载，是因为编译器在编译的时候有一个名字改变机制，
     如：void test() 编译器会给它取一个别名 _test
     void test(int a) 的别名是 _test_int。
     所以 void test(int a) 与 void test(int b) 是不能构成重载的，因为他们的别名都是 _test_int
     而C语言是没有重载的，因为C语言没有名字改变机制
     */
    
    
    //------------------------------------------------------ const 常量 ------------------------------------------------------
    
    const int count = 100; //a的值是不允许更改，a变量对应的存储空间不允许改的
    // int *p = &count; 报错，想通过指针变量p简介修改a的值，而a的值是不允许修改的
    
    int a = 10;
    const int *p2 = &a;
    // *p2 = 15; //报错，此时 *p 是常量，不能通过 *p 来修改 a 的值
    int b = 20;
    p2 = &b; // 准确，p是变量，*p是常量
    
    int c = 30;
    int * const p3 = &c;
    int e = 40;
    //    p3 = &e;  // 报错，此时 p3 是常量，不能改,    *p能改
    *p3 = 50; // 准确
    
    int f = 20;
    // const int *const p = &f; // 指针变量 p3 不能改变指向，也不能通过 *p 来改变 a 的值
    
    /*
     注：1、const int a = 10;const修饰就是常量，在定义的时候必须要给她赋值，且不能更改，相当于定义了一个宏，保证数据的安全性。
        2、const的常量性判断：const右边永远是常量，是不可改变的，int const* const p1,p2;//表示p1、*p1、p2不能改的
        3、const和数据类型是可以调换位置 int const a = 10 与  const int a = 10;是等价的
        4、const和#define都能用来定义常量，可以造成一改全部跟着一起改的效果。const定义常量从汇编的角度来看，只是给出了对应的内存地址，而不是象#define一样给出的是立即数，所以，const定义的常量在程序运行过程中只有一份拷贝，而#define定义的常量在内存中有若干个拷贝。更推荐使用const或者enum来定义常量 const推出的初始目的，正是为了取代预编译指令，消除它的缺点，同时继承它的优点 const可以节省空间，避免不必要的内存分配。
     
     const定义的常量与#define定义的符号常量的区别
     a、const定义的常量有类型，而#define定义的没有类型，编译可以对前者进行类型安全检查，而后者仅仅只是做简单替换
     b、const定义的常量在编译时分配内存，而#define定义的常量是在预编译时进行替换，不分配内存。
     c、作用域不同，const定义的常变量的作用域为该变量的作用域范围。而#define定义的常量作用域为它的定义点到程序结束，当然也可以在某个地方用#undef取消
     d、定义常量还可以用enum，尽量用const、enum替换#define定义常量
     
     */
    
    
    
    
    //------------------------------------------------------ 引用 (reference) ------------------------------------------------------
    /*
     概念：其实就是给变量起一个别名
     引用的特点： 引用没有独立的存储空间，跟被引用的变量共享存储空间 ，对引用所做的改变，就是对所引用变量所做的改变
     */
    int h = 10;
    int &ah = h; // 此时，ah 就是一个引用，不是变量，没有独立的存储空间，ah 相当于 h 的别名，ah 引用着变量 h
    ah = 90;   // 改变 ah 的值就相当于改变了 h 的值
    cout << h << endl;  // 此时打印的 h = 90；
    cout << &ah << ", " << &h <<endl; // 此时打印的都是这个地址：0x7fff5fbff694, 0x7fff5fbff694
    
    int i = 10;
    int &ai = i;
    int &bi = ai;   // int &bf = a；这两句代码是等价的
    cout << &bi << ", " << &ai << ", " << &i << endl; //打印出来的内存地址是一致的：0x7fff5fbff674, 0x7fff5fbff674, 0x7fff5fbff674
    
    // 注意点:
    int g = 10;
    // int &ag; 这种写法是错误的, 引用只能在定义的时候确定所引用的变量，以后都不能再引用其他变量
    int &ag = g;
    int k = 20;
    // 并不代表 ag 引用了变量 k，而是将变量 k 的值赋值给了 ag 引用，也就是将变量 k 的值给了g
    // 而且此时 ag 和 k 的内存地址是不一样的
    cout << &ag << ", " << &k <<endl;
    ag = k;
    
    // 和 const 一起用的时候，不能通过 al 引用修改变量a的值。称 al 为 const 引用
    int l = 10;
    const int &al = l;
    
    // 和其他数据类型一起用的时候
    double m = 1.78;
    //    int &ref = m; // 这句是错误的，但是将ref改为const引用，就能编译通过
    double n = 1.78;
    const int &ref = n;//这一句是对的
    // 编译能通过的原因是const int &ref = d;等价于下面2句：
    int temp = n; //相当于用一个临时int类型变量temp来储存d的值，此时temp的值为10；
    const int &ref2 = temp;
    //也就是说ref引用 跟 变量d 并不共享同一块存储空间
    
    // 引用的好处:
    // 1. 引用不占用额外的存储空间 ，当函数内部要修改外面的实参的时候就可以用到这个特点，如果用指针：void mySwap (int *x , int *y)，此时需要单独给x，y分配内存空间
    int o = 10;
    int q = 20;
    mySwap (o, q);
    cout << "o = " << o << ",q = " << q <<endl; //打印的结果：a = 20;b = 10.
    
    // 2. 引用也可以作为函数的返回值，主要目的是：可以将函数调用放在赋值运算符（=）的左边
    test2() = 30;
    cout << age << endl; // 此时age = 30；
    
    
    int r = add(10, 20);
    int &rf = add(10, 10); // 在调用这个方法的时候，返回局部变量在出来上面的代码段就销毁了，但是还未被使用
    cout << "r = " << r << endl;// 当执行这个输出的时候，此时销毁的局部变量就被占用了
    cout << "rf = " << rf << endl;// 所以 最后输出的时候不会再是20
    // 上面的程序会造成nf引用的值是不确定的，并不是20
    
    // 与指针的区别：
    /*
     1、指针有独立的存储空间，并且64位占8个字节；而引用是没有独立的存储空间的
     2、引用只能在定义的时候被初始化一次，之后不可变；指针的值是可变的
     3、引用不能为空，必须确保引用和一块合法的存储单元关联，而指针可以为空 int *p = NULL;
     4、“sizeof引用”得到的是所引用变量的大小；“sizeof指针”得到的是指针的大小
     5、引用和指针的自增和自减。运算含义是不一样的
     */
    
    
    
    
    //------------------------------------------------------ 类型转换运算符 ------------------------------------------------------
    /*
     static_cast<类型>()： 转换时做静态检查，即在编译时进行，void* 到其他指针的转换
     reinterprect_cast<类型>()：允许强转任何类型的指针，把整数强转成指针，指针强转成整数
     const_cast<类型>()：去掉cv限制
     dynamic_case<类型>()：动态转换
     */
    double pi = 3.1415026;
    int test_pi = static_cast<int>(pi);
    cout << "test_pi = " << test_pi << endl;
    
    void *pc = new long(123);
    long *pl = static_cast<long *>(pc);
    cout << "*pl" << *pl << endl;
    //不能转换 因为 static_cast 在检查的时候，发现 long* 转换 double* 是一个不合理的转换
    //    double *pd = static_cast<double*>(pl);
    
    // reinterpret_cast 比较强悍， 不会进行类型检查， 你想转它就给你转， 但是后果自负, 重新解释该片内存空间
    double *pd = reinterpret_cast<double*>(pl);
    cout << *pl << "===" << *pd << endl;
    
    // 去掉 cv 限制
    volatile const int s = 100; //编译器已经自认为后面的a不可能被修改
    //&a   const int*
    int * a1 = const_cast<int*>(&a);
    *a1 = 200;
    cout << "a1 = " << a1 <<endl;
    
    //大多数情况 我们开发中还是使用 强转
    float f1 = 2.12;
    int x1 = (int)f1;
    
    
    
    //------------------------------------------------------ 类型转换运算符 ------------------------------------------------------
    
    return 0;
}
