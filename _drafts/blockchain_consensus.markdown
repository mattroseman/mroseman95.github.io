---
title: "Alternatives to Proof of Work"
layout: post
date: 2016-02-24 22:44
image: /assets/images/markdown.jpg
headerImage: false
tag:
- markdown
- elements
star: true
category: blog
author: johndoe
description: Markdown summary with different options
---
___

## What is Blockchain Consensus

A blockchain can be thought of as a community driven ledger for a cryptocurrency. It logs every transaction and keeps
track of who has how many "coins". These ledgers are broken into blocks, each block pointing back to the previous one.
As of March 29, 2017 [the average number of transactions per block is about
2000](https://blockchain.info/charts/n-transactions-per-block).

![blockchain diagram]({{ site.url }}/assets/en-blockchain-overview.svg)

Now these blocks, before being commited to the chain, must be approved. Since there is no central authority, this must
be done through a group consensus. Obviously there must be some way to hold people accountable to checking transactions
honostly, and not trying to approve bad or perhaps malicious transactions.

As an example scenario without some checks and balances:
- Alice has 1 btc
- Alice buys something from Bob and gives him that 1 btc
- Quickly Alice also buys something from Eve and gives her that 1 btc
- Alice then approves the block that these transactions are both a part of, and she successfully spends her 1btc 2
times

The above is an example of what's called [Double Spending](https://en.wikipedia.org/wiki/Double-spending).

An easy solution to this problem is to require a certain number of people to approve blocks. Although an easy attack
would be to create many false identities, all of whom approve the block your transaction is in. This is called the
[Sybil Attack](https://en.wikipedia.org/wiki/Sybil_attack).

Many of the following consensus protocols are based off of this naive solution, but they add on a cost to approving
blocks, so that a single person can't freely create new identities.

## Proof of Work

### Overview

One method to prevent users from using multiple fake identities on the network in order to approve their bad
transactions is to include some sort of cost to approving. The basic idea of proof of work is to force users to do
some amount of computational work before they can sign off on a block. A malicious user can easily fake multiple
identities, but they cannot fake computational work.

The basic proof of work algorithm bitcoin uses is based off of a similar algorithm called
[hashcash](ftp://sunsite.icm.edu.pl/site/replay.old/programs/hashcash/hashcash.pdf). Some key elements of both bitcoins
algorithm and the hashcash algorithm is that they are:
1. **publicly auditable** - anyone can check the result of the proof of work to see that it is correct
2. **non-interactive** - the server doesn't need to issue some challenge to the user. The user picks the challenge
   themselves
3. **trapdoor free** - there is no known solution to the challenge beforehand
4. **unbounded probabalistic cost** - It could theoretically take forever to solve the challenge

Bitcoin's proof of work algorithm is based on the [SHA-256](https://en.wikipedia.org/wiki/SHA-2) hashing algorithm. You
are given a block of transactions, and after making sure that every transaction is possible given the previous blocks,
you create a header for this block. This header consists of...
1. **Version**
2. **Hash of previous block's header**
3. **Hash of all transactions in current block**
4. **Current timestamp**
5. **Current target** (explained later)
5. **Nonce** (explained later)

Now your goal is to find a hash of this header, that is less than a certain target number. The only values that you can
change is the 32 bit nonce at the end. Normally you would start with a nonce of 0 and increment every try, but it
doesn't really matter.

Since SHA-256 is a trapdoor function, meaning you can't work backwards from a hash to a particular starting number, and
there is no way to predict what you are going to get until you calculate it, the only way to try and find a nonce that
produces a hash below the target is by brute force. Once you do find a correct nonce that produces a hash below the
target number, you can broadcast the block with the correct header, and receive your payment. 

There must be some way to
incetivize people to confirm that transactions are valid, and this is done by paying them in bitcoin every time they
successfuly confirm a block.

Now the target value is a result of an algorithm based on previous blocks time to mine, and the goal is to mine a block
every 10 minutes. So as computers get more powerful the target number can get smaller and smaller, making a successful
hash harder and harder to find.

### Pros
### Cons

## Proof of Stake
### Overview
### Pros
### Cons

## Proof of Burn
### Overview
### Pros
### Cons


A blockquote:

> We are Hitchhikers in the road of open source knowledge.

## Header 2

Duis lacinia commodo dui, vel aliquam metus hendrerit eu. Integer et scelerisque dui. Sed nec molestie quam. Donec sit amet nisl a massa commodo ultrices nec quis nunc. Aenean aliquet eu arcu adipiscing dignissim. Nunc dictum elit vitae dolor molestie aliquet.


Example code:

{% highlight javascript %}
var light = new Light();
var switchUp = new FlipUpCommand(light);
var switchDown = new FlipDownCommand(light);
var s = new Switch();

s.storeAndExecute(switchUp);
s.storeAndExecute(switchDown);
{% endhighlight %}


A list:

- Praesent nisi elit, bibendum ut consectetur ac, aliquet in nunc
- Donec ante est, volutpat in mi et, pulvinar congue dolor.
- Quisque ultrices pulvinar sollicitudin.
- Duis elementum odio eu euismod suscipit.
- Integer enim lorem, interdum sit amet consectetur non, bibendum eget neque.

A numbered list:

1. Praesent nisi elit, bibendum ut consectetur ac, aliquet in nunc.
2. Donec ante est, volutpat in mi et, pulvinar congue dolor.
3. Quisque ultrices pulvinar sollicitudin.
4. Duis elementum odio eu euismod suscipit.
5. Integer enim lorem, interdum sit amet consectetur non, bibendum eget neque.

Definition list:

Curabitur cursus magna eu sem cursus
: ac ultrices urna pharetra.
: Duis scelerisque ipsum eu luctus elementum.

Pellentesque habitant morbi tristique senectus
: Curabitur malesuada lacus ac gravida porttitor
: Duis sodales feugiat lorem et mollis.

Want to suggest something? Please [Send me a request](https://github.com/kronik3r/daktilo/issues/new).

