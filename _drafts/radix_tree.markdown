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

## Searching Words

## Event Loop Blocking
