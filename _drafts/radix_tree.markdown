---
title: "Autocomplete Radix Tree (Trie) in Javascript"
layout: post
data: 2020-02-03 00:00
image: /assets/images/markdown.jpg
headerImage: false
tag:
- javascript
- data-structures
- tutorial
star: true
category: blog
author: Matthew Roseman
description: Building a Radix Tree data structure in JS for autocomplete
---

### Contents
- [Overview](#overview)
- [Prefix Trees](#prefix-trees)
- [Radix Trees](#radix-trees)
- [Adding Words](#adding-words)
- [Searching Wrods](#searching-words)
- [Event Loop Blocking](#event-loop-blocking)

## Overview

A [Radix Tree](https://en.wikipedia.org/wiki/Radix_tree) is a data structure that can be used for writing autocomplete functions.
The basic process is iterating all the autocomplete options, adding them to the tree, creating new nodes for each word. And then when
a user has typed something, you take what they type, traverse the tree, and then collect all children in the subtree you are left with.

Radix trees are actually optimized (compressed) prefix trees, so I'll explain what those are, how radix trees improve the idea.
Then I'll describe how a radix tree can be generated in JS, and then how searching for words works.

Finally I'll describe some javascript specific issues I had, and how I solved them (event loop blocking)

## Prefix Trees

<div class="side-by-side">
    <div class="toleft" style="width: 75%;">
        <p>
            A prefix tree is a tree datastructure with each node representing a character in a word. The root representing the beginning of a word.
            If cat was added to a prefix tree it would go <b>root -> c -> a -> t</b>, and it car was added as well the a node would have a <b>r</b> and <b>t</b> child node.
        </p>

        <p>
            Nodes that represent an end of a word have to be specifically marked as word nodes. So <b>c</b>, and <b>a</b> in the above example would not be word nodes,
            but <b>t</b>, and <b>r</b> would be.
        </p>
    </div>

    <div class="toright" style="width: 20%;">
        <img class="image" src="{{ site.url }}/assets/images/prefix_tree_01.png" alt="Basic Prefix Tree" height="250">
    </div>
</div>

When adding words you simply loop through the word's characters, start at root and look for the child representing the current character.<br />
If you reach the last character, and there is a node for the last character, mark it as a word.<br />
If you reach a point where the current node doesn't have a child for the next character, start adding children nodes for each remaining character.

When searching words given a prefix, you traverse the tree similar to how you did when adding words until you reach the end of the prefix, or the
tree is missing a character in the prefix. If the tree is missing a character then there are no words with the prefix.<br />
However if you reach the last character of the prefix you can then perform a search of the subtree rooted at that last characters node, and find all
child nodes that are marked as words. These will be the words that begin with the prefix.

## Radix Trees

<div class="side-by-side">
    <div class="toleft" style="width: 60%;">
        <p>
            A radix tree takes the prefix tree and optimizes it. There are a lot of unecessary nodes in a prefix tree. In the example above, there is no need for a
            <b>c</b> or an <b>a</b> node, and they can be combined into one node. That node would then have the two children <b>r</b> and <b>t</b>
        </p>

        <p>
            Radix trees typically use edges to represent a string of characters, instead of the nodes. So the radix tree of the node above has one edge coming off
            the root node, with the string <b>CA</b>. That means that all words in the subtree rooted at that first child begin with <b>CA</b>.
        </p>

        <p>
            Where this gets complicated is if we wanted to add a word like <b>company</b> which would split up our <b>CA</b> edge up, and modify the already existing tree.<br />
            This is the payoff of radix trees: increased complexity when inserting words for a more efficient data structure with faster lookup.
        </p>
    </div>

    <div class="toright" style="width: 35%;">
        <img class="image" src="{{ site.url }}/assets/images/radix_tree_01.png" alt="Basic Radix Tree" height="350">
    </div>
</div>

## Adding Words

I'll start with some skeleton code for the classes I'll use...

{% highlight js %}
class RadixNode {
  constructor(edgeLabel, isWord=false) {
    this.edgeLabel = edgeLabel;
    this.children = {};

    this.isWord = isWord;
  }
}

class RadixTree {
  constructor() {
    this.root = new RadixNode('');
  }

  addWord(word) {
  }

  getWords(prefix) {
  }
}
{% endhighlight %}

Each node will be initialized with the edge label that leads to it, and it will have an object of all it's children.

To make the code easier to write later, I'll store the children as a dictionary, with the key bing the first character of that child's edge label.

Now let's figure out how the first word will be added

{% highlight js %}
  addWord(word) {
    word = word.toLowerCase();

    let currentNode = this.root;

    // make a new node that's a word and has an edge label of the given word
    const newNode = new RadixNode(word, true);
    currentNode.children[word[0]] = newNode;
  }
{% endhighlight %}

So we make a new RadixNode instance, with the given word, and make it a child of the root node.<br />
The root node (currentNode) has a property children that we treat like a dictionary. We add a key **word[0]** which is the first character of the given word. We then set the value to the new node we made.

So we now have a radix tree with two nodes and one word.

Adding other words gets more complicated, because we need logic to split apart the existing nodes to make room for the new nodes.

{% highlight js %}
  addWord(word) {
    word = word.toLowerCase();

    let currentNode = this.root;

    // iterate over the characters of the given word
    for (let i = 0; i < word.length; i++) {
      const currentCharacter = word[i];

      // check to see if there is a child of the currentNode with an edge label starting with the currentCharacter
      if (currentCharacter in currentNode.children) {
        // TODO add logic to move nodes around to make room for new node
      } else {
        const newNode = new RadixNode(word.substr(i), true);
        currentNode.children[currentCharacter] = newNode;

        return;
      }
    }
  }
{% endhighlight %}

We now iterate over each character of the given word, and check to see if that character is the beginning of one of the current nodes edges.

If there isn't an edge that matches, we simply create a new child node, and make the edge label the remaining characters of the given word.

For the complicated part we'll need a helper function to get the common prefix between two strings.

{% highlight js %}
/*
 * getCommonPrefix calculates the largest common prefix of two given strings
 */
function getCommonPrefix(a, b) {
  let commonPrefix = '';
  for (let i = 0; i < Math.min(a.length, b.length); i++) {
    if (a[i] !== b[i]) {
      return commonPrefix;
    }

    commonPrefix += a[i];
  }

  return commonPrefix;
}
{% endhighlight %}

Add this function outside of both classes.

Now when the current node has an edge we can follow there are 4 scenarios.

1. The edge label is exactly the same as what's left of the word.
2. The edge label contains all of what's left of the word plus some extra. (edge label is **facebook** and the word is **face**)
3. The word contains all of the edge label plus some extra. (edge label is **face** and the word is **facebook**)
4. The edge label and the word share a common prefix, but both differ at some point. (edge label is **farm** and the word is **face**)

{% highlight js %}
  addWord(word) {
    word = word.toLowerCase();

    let currentNode = this.root;

    // iterate over the characters of the given word
    for (let i = 0; i < word.length; i++) {
      const currentCharacter = word[i];

      // check to see if there is a child of the currentNode with an edge label starting with the currentCharacter
      if (currentCharacter in currentNode.children) {
        const edgeLabel = currentNode.children[currentCharacter].edgeLabel;

        // get the common prefix of this child's edge label and what's left of the word
        const commonPrefix = getCommonPrefix(edgeLabel, word.substr(i));

        // if the edge label and what's left of the word are the same
        if (edgeLabel === word.substr(i)) {
          // TODO add new node
          return;
        }

        // if the edge label contains the entirety of what's left of the word plus some extra
        if (commonPrefix.length < edgeLabel.length && commonPrefix.length == word.substr(i).length) {
          // TODO add new node
          return;
        }

        // if the edge label and what's left of the word share a common prefix, but differ at some point
        if (commonPrefix.length < edgeLabel.length && commonPrefix.length < word.substr(i).length) {
          // TODO add new node
          return;
        }

        // the last option is what's left of the word contains the entirety of the edge label plus some extra
        // TODO follow the edge label, and increment the for loop to take off all of the edge label characters
      } else {
        const newNode = new RadixNode(word.substr(i), true);
        currentNode.children[currentCharacter] = newNode;

        return;
      }
    }
  }
{% endhighlight %}

## Searching Words

## Event Loop Blocking
