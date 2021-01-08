---
title: Several Design Patterns By C++
data: 2020-10-10 13:23:23
categories:
  - coding
  - pattern
---
Introduce some normal design patterns,codes by cpp.
<!-- more -->
# Strategy Pattern
## Intent
- Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary independently from the clients that use it.
- Capture the abstraction in an interface, bury implementation details in derived classes.

```cpp
//By dexter @ 11/10/2020
#include <iostream>

class Strategy {
 public:
  explicit Strategy(){}
  virtual ~Strategy(){}

  virtual void exec() = 0;

 private:
  Strategy(const Strategy& rhs);
  Strategy& operator=(const Strategy& rhs);
};

class ConcreteStrategyA : public Strategy {
 public:
  explicit ConcreteStrategyA() : Strategy() {}
  ~ConcreteStrategyA() {}

  void exec(){
      std::cout<<"ConcreteStrategyA::exec()"<<std::endl;
  }

 private:
  ConcreteStrategyA(const ConcreteStrategyA& rhs);
  ConcreteStrategyA& operator=(const ConcreteStrategyA& rhs);
};

class ConcreteStrategyB : public Strategy {
 public: 
  explicit ConcreteStrategyB() : Strategy() {}
  ~ConcreteStrategyB(){}

  void exec() {
    std::cout<<"ConcreteStrategyB::exec()"<<std::endl;
  }

 private: 
  ConcreteStrategyB(const ConcreteStrategyB& rhs);
  ConcreteStrategyB& operator=(const ConcreteStrategyB& rhs);
};

class Context {
 public:
  explicit Context(Strategy* strategy) : strategy_(strategy){}
  ~Context(){}

  void setSetrategy(Strategy* strategy) {
    strategy_ = strategy;
  }

  void exec() {
    strategy_->exec();
  }
 private:
  Context(const Context& rhs);
  Context& operator=(const Context& rhs);

  Strategy* strategy_;
};

int main() {
  ConcreteStrategyA stra_a;
  ConcreteStrategyB stra_b;

  std::cerr<<"set a strategy:\n";
  Context cont(&stra_a);
  cont.exec();
  std::cerr<<"set a strategy:\n";
  cont.setSetrategy(&stra_b);
  cont.exec();

  return 0;
}
```
output:
```sh
set a strategy:
ConcreteStrategyA::exec()
set a strategy:
ConcreteStrategyB::exec()
```

# Observer Pattern
Observer pattern is used when there is one-to-many relationship between objects such as if one object is modified, its dependent objects are to be notified automatically.
```cpp
//By dexter @ 12/10/2020
#include <iostream>
#include <vector>

class Observer {
 public: 
  explicit Observer() {}
  virtual ~Observer() {}

  virtual void update() = 0;

 private:
  Observer(const Observer& rhs);
  Observer& operator=(const Observer& rhs);
};

class ConcreteObserveA : public Observer {
 public:
  explicit ConcreteObserveA() : Observer() {}
  ~ConcreteObserveA() {}

  void update() {
      std::cerr<<"ConcreteObserveA::update\n";
  }

 private: 
  ConcreteObserveA(const ConcreteObserveA& rhs);
  ConcreteObserveA& operator=(const ConcreteObserveA& rhs);
};

class ConcreteObserveB : public Observer {
 public:
  explicit ConcreteObserveB() : Observer() {}
  ~ConcreteObserveB() {}

  void update() {
      std::cerr<<"ConcreteObserveB::update\n";
  }

 private: 
  ConcreteObserveB(const ConcreteObserveB& rhs);
  ConcreteObserveB& operator=(const ConcreteObserveB& rhs);
};

class Subject {
 public:
  explicit Subject() {}
  virtual ~Subject() {}
  
  virtual void registerObserver(Observer* observer) = 0;
  virtual void removeObserver(Observer* observer) = 0;
  virtual void notifyObserver() = 0;

 private:
  Subject(const Subject& rhs);
  Subject& operator=(const Subject& rhs);
};

class ConcreteSubjectA : public Subject {
 public:
  explicit ConcreteSubjectA() : Subject() {}
  ~ConcreteSubjectA() {}

  void registerObserver(Observer* observer) {
      observer_list_.push_back(observer);
  }

  void removeObserver(Observer* observer) {
      for(auto it = observer_list_.begin(); it != observer_list_.end(); it++){
          if(*it == observer){
              observer_list_.erase(it);
              return;
          }
      }
  }

  void notifyObserver() {
      for(auto it = observer_list_.begin(); it != observer_list_.end(); it++){
          (*it)->update();
      }
  }

 private:
  ConcreteSubjectA(const ConcreteSubjectA& rhs);
  ConcreteSubjectA& operator=(const ConcreteSubjectA& rhs);
  std::vector<Observer*> observer_list_;
};

int main() {
    ConcreteObserveA obser_a;
    ConcreteObserveB obser_b;
    ConcreteSubjectA suba;

    std::cerr<<"add  two observer and update:\n";
    suba.registerObserver(&obser_a);
    suba.registerObserver(&obser_b);
    suba.notifyObserver();
    std::cout<<"remove obser_a and update:\n";

    suba.removeObserver(&obser_a);
    suba.notifyObserver();

    return 0;
}
```
output:
```sh
add  two observer and update:
ConcreteObserveA::update
ConcreteObserveB::update
remove obser_a and update:
ConcreteObserveB::update
```

# Decorator Pattern
Decorator pattern allows a user to add new functionality to an existing object without altering its structure. This type of design pattern comes under structural pattern as this pattern acts as a wrapper to existing class.
This pattern creates a decorator class which wraps the original class and privides additional functionality keeping class methods signature inact;

```cpp
//By dexter @ 12/10/2020

#include <iostream>
#include <string>
#include <memory>

class Component {
 public:
  explicit Component() {}
  Component(const Component& rhs) = delete;
  Component& operator=(const Component& rhs) = delete;

  virtual ~Component() {}

  virtual std::string methodA() = 0;
  virtual std::string methodB() = 0;

 private:
};

class ConcreteComponentA : public Component {
 public:
  ConcreteComponentA() : Component() {}
  ~ConcreteComponentA() {}
  ConcreteComponentA(const ConcreteComponentA& rhs) = delete;
  ConcreteComponentA& operator=(const ConcreteComponentA& rhs) = delete;

  std::string methodA(){
      return "ConcreteComponentA methodA";
  }
  std::string methodB(){
      return "ConcreteComponentA methodB";
  }

 private:
  
};

class Decorator : public Component {
 public:
  Decorator(std::shared_ptr<Component> component) : component_(component) {}
  ~Decorator() {}
  Decorator(const Decorator& rhs) = delete;
  Decorator& operator=(const Decorator& rhs) = delete;

  std::string methodA() {
      return component_->methodA();
  }

  std::string methodB() {
      return component_->methodB();
  }


 private:
 protected:
  std::shared_ptr<Component> component_;
};

class ConcreteDecoratorA : public Decorator {
 public:
  ConcreteDecoratorA(std::shared_ptr<Component> component) : Decorator(component) {}
  ~ConcreteDecoratorA() {}
  ConcreteDecoratorA(const ConcreteDecoratorA& rhs) = delete;
  ConcreteDecoratorA& operator=(const ConcreteDecoratorA& rhs) = delete;

  std::string methodA(){
      return component_->methodA() + "  ConcreteDecoratorA methodA";
  }

  std::string methodB(){
      return component_->methodB() + "  ConcreteDecoratorA methodB";
  }

 private:
};

class ConcreteDecoratorB : public Decorator {
 public:
  ConcreteDecoratorB(std::shared_ptr<Component> component) : Decorator(component) {}
  ~ConcreteDecoratorB() {}
  ConcreteDecoratorB(const ConcreteDecoratorB& rhs) = delete;
  ConcreteDecoratorB& operator=(const ConcreteDecoratorB& rhs) = delete;
  
  std::string methodA(){
      return component_->methodA() + "  ConcreteDecoratorB methodA";
  }

  std::string methodB(){
      return component_->methodB() + "  ConcreteDecoratorB methodB";
  }

 private:
};

int main() {
  std::shared_ptr<ConcreteComponentA> ptr_component_a = std::make_shared<ConcreteComponentA>();
  std::cout << ptr_component_a->methodA() << ", " << ptr_component_a->methodB() << std::endl;
  
  std::shared_ptr<ConcreteDecoratorA> ptr_decorator_a = std::make_shared<ConcreteDecoratorA>(
      ptr_component_a);
  std::cout << ptr_decorator_a->methodA() << ", " << ptr_decorator_a->methodB() << std::endl;

  std::shared_ptr<ConcreteDecoratorB> ptr_decorator_b = std::make_shared<ConcreteDecoratorB>(
      ptr_component_a);
  std::cout << ptr_decorator_b->methodA() << ", " << ptr_decorator_b->methodB() << std::endl;

  std::shared_ptr<ConcreteDecoratorB> ptr_decorator_a_b = std::make_shared<ConcreteDecoratorB>(
      ptr_decorator_a);
  std::cout << ptr_decorator_a_b->methodA() << ", " << ptr_decorator_a_b->methodB() << std::endl;

  return 0;
}
```
output:
```sh
ConcreteComponentA methodA, ConcreteComponentA methodB
ConcreteComponentA methodA  ConcreteDecoratorA methodA, ConcreteComponentA methodB  ConcreteDecoratorA methodB
ConcreteComponentA methodA  ConcreteDecoratorB methodA, ConcreteComponentA methodB  ConcreteDecoratorB methodB
ConcreteComponentA methodA  ConcreteDecoratorA methodA  ConcreteDecoratorB methodA, ConcreteComponentA methodB  ConcreteDecoratorA methodB  ConcreteDecoratorB methodB
```
# Factory Pattern
The factory pattern is a creational pattern that uses factory methods to deal with the problem of creating objects without having to specify the exact calss of the object that will be created. This is done by creating objects by calling a factory method, either specified in an interface and implemented by child classes, or implemented in a base class and optionally overridden by derived classes rather than by calling a constructor.
According to the type of problems, there are three kinds of `Factory Pattern`:
- Simple Factory
- Normal Factory
- Abstract Factory

## Simple Factory
Simple Factory defines a method to create an object. It voilates the `Open/close Principle(OCP)`
```cpp
//By dexter @ 13/10/2020
#include <iostream>
#include <string>
#include <memory>

class Product {
 public:
  explicit Product() {}
  virtual ~Product() {}
  Product(const Product &rhs) = delete;
  Product &operator=(const Product &rhs) = delete;

  virtual void operation() = 0;
};

class ConcreteProductA : public Product {
 public:
  explicit ConcreteProductA()  : Product() {}
  ~ConcreteProductA() {}
  ConcreteProductA(const ConcreteProductA &rhs) = delete;
  ConcreteProductA &operator=(const ConcreteProductA &rhs) = delete;

  void operation() {
      std::cerr<<"ConcreteProductA is called..."<<std::endl;
  }
};

class ConcreteProductB : public Product {
 public:
  explicit ConcreteProductB()  : Product() {}
  ~ConcreteProductB() {}
  ConcreteProductB(const ConcreteProductB &rhs) = delete;
  ConcreteProductB &operator=(const ConcreteProductB &rhs) = delete;

  void operation() {
      std::cerr<<"ConcreteProductB is called..."<<std::endl;
  }
};

class Factory {
 public:
  Factory() {}
  ~Factory() {}
  Factory(const Factory &rhs) = delete;
  Factory &operator=(const Factory &rhs) = delete;

  std::shared_ptr<Product> createProduct(const std::string &product) {
      if(product == "A") {
          return std::make_shared<ConcreteProductA>();
      }
      if(product == "B") {
          return std::make_shared<ConcreteProductB>();
      }
  }
};

int main() {
    Factory factory;
    std::shared_ptr<Product> product_a = factory.createProduct("A");
    std::shared_ptr<Product> product_b = factory.createProduct("B");

    product_a->operation();
    product_b->operation();

    return 0;
}
```
output:
```sh
ConcreteProductA is called...
ConcreteProductB is called...
```

## Normal Factory
Normal Factory not only encapsulates the creation of object but also put the creation of object into derived class. It only provides the method of creating objects, and the realization is in `ConcreteFactory`.
Disadvantage: the addition of factory object will cause the increasing of classes.
```cpp
//By dexter @ 13/10/2020
#include <iostream>
#include <string>
#include <memory>

class Product{
 public:
  explicit Product() {}
  virtual ~Product() {}
  Product(const Product &rhs) = delete;
  Product &operator=(const Product &rhs) = delete;

  virtual void operation() = 0;
};

class ConcreteProductA : public Product {
 public:
  explicit ConcreteProductA() : Product() {}
  ~ConcreteProductA() {}
  ConcreteProductA(const ConcreteProductA &rhs) = delete;
  ConcreteProductA &operator=(const ConcreteProductA &rhs) = delete;

  void operation() {
      std::cerr<<"ConcreteProductA is called..."<<std::endl;
  }
};

class ConcreteProductB : public Product {
 public:
  explicit ConcreteProductB() : Product(){}
  ~ConcreteProductB() {}
  ConcreteProductB(const ConcreteProductB &rhs) = delete;
  ConcreteProductB &operator=(const ConcreteProductB &rhs) = delete;

  void operation() {
      std::cerr<<"ConcreteProductB is called..."<<std::endl;
  }
};

class Factory {
 public:
  explicit Factory() {}
  virtual ~Factory() {}
  Factory(const Factory &rhs) = delete;
  Factory &operator=(const Factory &rhs) = delete;

  virtual std::shared_ptr<Product> createProduct() = 0;
};

class ConcreteFactoryA : public Factory {
 public:
  explicit ConcreteFactoryA() : Factory() {}
  ~ConcreteFactoryA() {}
  ConcreteFactoryA(const ConcreteFactoryA &rhs) = delete;
  ConcreteFactoryA &operator=(const ConcreteFactoryA &rhs) = delete;

  std::shared_ptr<Product> createProduct() {
      return std::make_shared<ConcreteProductA>();
  }
};

class ConcreteFactoryB : public Factory {
 public:
  explicit ConcreteFactoryB() : Factory() {}
  ~ConcreteFactoryB() {}
  ConcreteFactoryB(const ConcreteFactoryB &rhs) = delete;
  ConcreteFactoryB &operator=(const ConcreteFactoryB &rhs) = delete;

  std::shared_ptr<Product> createProduct() {
      return std::make_shared<ConcreteProductB>();
  }
};

int main() {
    auto factor_a = std::make_shared<ConcreteFactoryA>();
    auto product_a = factor_a->createProduct();
    product_a->operation();

    auto factor_b = std::make_shared<ConcreteFactoryB>();
    auto product_b = factor_b->createProduct();
    product_b->operation();

    return 0;
}
```
output:
```sh
ConcreteProductA is called...
ConcreteProductB is called...
```