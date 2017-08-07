---
title: "Erasure Coding in Hadoop"
layout: post
image: /assets/images/markdown.jpg
headerImage: false
tag:
- hadoop
- data science
star: false
category: blog
author: matthewroseman
description: How hadoop replaces replication with erasure code
---

## Summary:

With release 3.0 the Hadoop file system (HDFS) uses erasure coding as a replacement for replication in ensuring the
durability of stored data. Instead of replicating the data 3x times, erasure coding uses error correcting algorithms so
that if any nodes are lost, the data should be savable.

## Overview:

Using erasure coding requires that the way files are stored changes. A method called stripping is used which divides up
the data into units and stores consecutive units on seperate disks.
![Stripping]({{site.url}}/assets/images/stripping.png)
For each stripe parity data is calulated using erasure coding, and they are stored on a seperate disk.

With this setup, if any node in a stripe is lost, as long as the parity machines remain, and a certain percent of a stripes data is
still up, the data can be recovered.

Before, if you had 6 blocks of data, you would have 3x replication so 6*3=18 blocks of disk space, but with erasure
coding, you just need 3 blocks for parity data, so 6+3=9 blocks of disk space.

## Algorithm:

An erasure code is a forward error correctin code, that transforms a message of length **k** into a longer message with **n**
*"code word"* symbols, such that the original message can be recovered from a subset of the **n** *"code word"* symbols.

The specific erasure code algorithm HDFS uses is Reed-Solomon Error Correction. This algorithm takes k data symbols of s
bits each, and adds parity symbols to make n symbol code words. A RS decoder can correct up to t symbols, where 2t =
n-k.
![Code Word]({{site.url}}/assets/images/reed_solomon_code_word.gif)

### Galois Field

This is a very **simplistic** explanation of Galois Fields, and is missing a lot of key details, but I think it is a good
start to understanding what they are, without an understanding of abstract algebra.

First of all a [ring](https://en.wikipedia.org/wiki/Ring_%28mathematics%29) is a set with addition and multiplication.
Any addition or multiplication on elements in the ring will produce another element of the ring. Also rings have
additive identities and additive inverses.

Additive Identity:

{% highlight raw %}
There is an element 0 such that a + 0 = a for all a in ring R
{% endhighlight %}

Additive Inverse:

{% highlight raw %}
For each a in ring R there exists -a in R such that a + (-a) = 0
{% endhighlight %}

If we take the integers mod 256 (or 0 to 255), then we have a simple ring. We already have a 0 in this ring, and for the
additive inverse just mod -a by 256.

But these integers mod 256 do not make a field. At least not without changing how multiplication and addition operators
work. For Galois fields we consider the elements as if they where polynomials.

To find the representation of 42 in a Galois field we first convert it to binary. Then we consider a polynomial where
each bit represents a coefficient of a polynomial.

{% highlight raw %}
42 = 0b00101010
0x^8 + 0x^7 + 0x^6 + 1x^5 + 0x^4 + 1x^3 + 0x^2 + 1x + 0 = x^5 + x^3 + x
{% endhighlight %}

Now if we want to add two elements in a Galois field we add the polynomials. The coefficients are all mod 2 though, so
after adding coefficients of 2 become 0.

{% highlight raw %}
42 + 100 = 0b00101010 + 0b01100100
(x^5 + x^3 + x) + (x^6 + x^5 + x^2) = x^5 + x^3 + x + x^6 + x^5 + x^2
= x^6 + 2x^5 + x^3 + x^2 + x = x^6 + x^3 + x^2 + x
42 + 100 = 0b01001110 = 78
{% endhighlight %}

The same process can be used when multiplying. Since we have converted our integers to polynomials, we need something to
mod them by. There are ways to generate a polynomial that will give you a Galois field of n polynomials, but I'm not
going to talk about that process. Whats important is that the polynomial is irreducible, which is important when using it
in division. For these examples I will use a pregenerated polynomial.

{% highlight raw %}
0b1 0001 1101 = x^8 + x^4 + x^3 + x^2 + 1
{% endhighlight %}

For another example consider 42 * 20 in a Galois Field. I'm not going to go through the [polynomial
division](https://en.wikipedia.org/wiki/Polynomial_long_division) in this example, but remember the coefficients are
modular 2.

{% highlight raw %}
42 = x^5 + x^3 + x
20 = 0b00010100 = x^4 + x^2
42 * 20 = (x^5 + x^3 + x) * (x^4 + x^2) = x^9 + x^7 + x^5 + x^7 + x^5 + x^3 = x^9 + x^3
(x^9 + x^3) / (x^8 + x^4 + x^3 + x^2 + 1) = x r x^5 + x^4 + x
x^9 + x^3 (mod x^8 + x^4 + x^3 + x^2 + 1) = x^5 + x^4 + x = 0b00110010 = 50
42 * 20 = 50
{% endhighlight %}

If you are curious, there are better ways to do this math while staying in binary form. A good example of this can be
found [here](https://en.wikiversity.org/wiki/Reed%E2%80%93Solomon_codes_for_coders#Finite_field_arithmetic)

So what can we do with this Galois Field. Well the reason we need this in Erasure Codes, is that we can have a field of
8 bit bytes, where any addition and subtraction with these bytes always result in more 8 bit bytes. We can reference
this field by GF(2^8) where 2 is the **characteristic**, 8 is the **exponent**, and 256 is the **cardinality**.

### Encoding:

The encoder takes in k data symbols, and represents them as a polynomial. Then the encoder mods by the generator
polynomial to create the parity polynomial. This parity polynomial is converted back to n-k parity symbols and this is
appended to the k data symbols. These n symbols are then sent as the message.

{% highlight raw %}
original message: 0b0010 0000 1000 => x^9 + x^3
parity bits: x^5 + x^4 + x => 0b0011 0010
sent message: 0b0010 0000 1000 0011 0010 => x^9 + x^3 + x^5 + x^4 + x = x^9 + x^5 + x^4 + x^3 + x
{% endhighlight %}

Encoding is a very simple process, but the complication comes from decoding.

### Decoding:

In order to decode we first check to see if there are any errors in the received message. This is easy to do, since we
know the received message should be divisible by the generator polynomial. So we can take the zeros of the generator
polynomial a^0, a^1, ..., a^n and evaluate the received message at each of these. If we get 0 for each generator 0 then
the message is good.

For example say the message we want to send is 0b1 0000 1000, and after modding by the generator polynomial we get a
remainder of x^5 + x^4 + x. This means the message sent, in polynomial form is...

{% highlight raw %}
original message: x^9 + x^3
parity bits: x^5 + x^4 + x
sent message: x^9 + x^3 + x^5 + x^4 + x = x^9 + x^5 + x^4 + x^3 + x
{% endhighlight %}

If we mod the sent message by the generator polynomial we will get 0.
