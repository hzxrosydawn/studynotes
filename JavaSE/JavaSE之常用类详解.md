Java 常用类详解

Random 类详解

该类的实例用来生成伪随机数。

Random类中实现的随机算法是伪随机，也就是有规则的随机。在进行随机时，随机算法的起源数字称为种子数(seed)，在种子数的基础上进行一定的变换，从而产生需要的随机数字。

相同种子数的Random对象，相同次数生成的随机数字是完全相同的。也就是说，两个种子数相同的Random对象，第一次生成的随机数字完全相同，第二次生成的随机数字也完全相同。这点在生成多个随机数字时需要特别注意。

> 伪随机性（Pseudorandomness）是指一个过程似乎是随机的，但实际上并不是。例如伪随机数（或称伪乱数），是使用一个确定性的伪随机算法计算出来的似乎是随机的数值序列，因此伪随机数实际上并不随机。在计算伪随机数时假如使用的开始值不变的话，那么伪随机数的数值序列也不变。伪随机数的随机性可以用它的统计特性来衡量，其主要特征是每个数出现的可能性和它出现时与数序中其它数的关系。伪随机数的优点是它的计算比较简单，而且只使用少数数值很难推算出计算它的算法。一般人们使用一个假的随机数，比如电脑上的时间作为计算伪随机数的开始值。

下面介绍一下Random类的使用，以及如何生成指定区间的随机数组以及实现程序中要求的几率。

```
An instance of this class is used to generate a stream of
pseudorandom numbers. The class uses a 48-bit seed, which is
modified using a linear congruential formula. (See Donald Knuth,
* <i>The Art of Computer Programming, Volume 3</i>, Section 3.2.1.)
* <p>
* If two instances of {@code Random} are created with the same
* seed, and the same sequence of method calls is made for each, they
* will generate and return identical sequences of numbers. In order to
* guarantee this property, particular algorithms are specified for the
* class {@code Random}. Java implementations must use all the algorithms
* shown here for the class {@code Random}, for the sake of absolute
* portability of Java code. However, subclasses of class {@code Random}
* are permitted to use other algorithms, so long as they adhere to the
* general contracts for all the methods.
* <p>
* The algorithms implemented by class {@code Random} use a
* {@code protected} utility method that on each invocation can supply
* up to 32 pseudorandomly generated bits.
* <p>
* Many applications will find the method {@link Math#random} simpler to use.
```