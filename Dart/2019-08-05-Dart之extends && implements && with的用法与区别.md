# Dart之extends && implements && with的用法与区别

## 概述
- 继承（关键字 extends）
- 混入  mixins （关键字 with）
- 接口实现（关键字 implements）

这三种关系可以同时存在，但是有前后顺序：extends -> mixins -> implements（extens在前，mixins在中间，implements最后）

## 继承(extends)
Flutter中的继承和Java中的继承是一样的：Flutter中的继承是单继承

- (1) 子类使用extends关键词来继承父类
- (2) 子类会继承父类里面可见的属性和方法 但是不会继承构造函数
- (3) 子类能复写父类的方法 getter和setter
- (4) 子类重写超类的方法，要用@override
- (5) 子类调用超类的方法，要用super
- (6) 子类可以继承父类的非私有变量

```dart
class Person {
  //公有变量
  String name; 
  num age; 
  //私有变量
  String _gender;
  //类名构造函数
  Person(this.name,this.age);
  //公有的方法
  void printInfo() {
    print("${this.name}---${this.age}");  
  }

  work(){
    print("${this.name}在工作...");
  }
}

class Web extends Person{
　Web(String name, num age) : super(name, age);
  run(){
    print('run');
    super.work();  //自类调用父类的方法
  }

  //覆写父类的方法
  @override       //可以写也可以不写  建议在覆写父类方法的时候加上 @override 
  void printInfo(){
     print("姓名：${this.name}---年龄：${this.age}"); 
  }
}

main(){ 
  Web w=new Web('李四',20);
  // w.printInfo();
  w.run();
}
```

## 混合 mixins (with)
mixins的中文意思是混入，就是在类中混入其他功能。在Dart中可以使用mixins实现类似多继承的功能因为mixins使用的条件，随着Dart版本一直在变，这里说的是Dart2.x中使用mixins的条件：
- (1) 作为mixins的类只能继承自Object，不能继承其他类
- (2) 作为mixins的类不能有构造函数
- (3) 一个类可以mixins多个mixins类
- (4) mixins绝不是继承，也不是接口，而是一种全新的特性

```dart
class Person{
  String name;
  num age;
  Person(this.name,this.age);
  printInfo(){
    print('${this.name}----${this.age}');
  }
  void run(){
    print("Person Run");
  }
}

class A {
  String info="this is A";
  void printA(){
    print("A");
  }
  void run(){
    print("A Run");
  }
}

class B {  
  void printB(){
    print("B");
  }
  void run(){
    print("B Run");
  }
}

class C extends Person with B,A{
  C(String name, num age) : super(name, age);
}

void main(){  
  var c=new C('张三',20);  
  c.printInfo();
  // c.printB();
  // print(c.info);
  c.run();
}
```

## 接口实现(implements)
Flutter是没有interface的，但是Flutter中的每个类都是一个隐式的接口，这个接口包含类里的所有成员变量，以及定义的方法。如果有一个类 A,你想让类B拥有A的API，但又不想拥有A里的实现，那么你就应该把A当做接口，类B implements 类A.

所以在Flutter中:class 就是 interface

- 当class被当做interface用时，class中的方法就是接口的方法，需要在子类里重新实现，在子类实现的时候要加@override
- 当class被当做interface用时，class中的成员变量也需要在子类里重新实现。在成员变量前加@override

```dart
/*
Dart中一个类实现多个接口：
*/

abstract class A{
  String name;
  printA();
}

abstract class B{
  printB();
}

class C implements A,B{  
  @override
  String name;  
  @override
  printA() {
    print('printA');
  }
  @override
  printB() {
    // TODO: implement printB
    return null;
  }
}

void main(){
  C c=new C();
  c.printA();
}
```

> [【Dart学习】-- Dart之extends && implements && with的用法与区别](https://www.cnblogs.com/lxlx1798/p/11044101.html)







