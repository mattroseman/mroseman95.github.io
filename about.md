---
title: About
layout: page
---

<p>I am a fullstack software engineer, using Python, JavaScript, and Golang. I am interested in open source projects
</p>

<p>I created this website to showcase my work, and to create a blog to help me learn new topics. I will be writting
about a wide array of topics, probably all related to software engineering.</p>

<h2>Projects</h2>

<h3><a href="http://www.isitcamp.com">IsItCamp</a></h3>
<small><a href="https://github.com/mroseman95/isitcamp">source</a></small>
<div class="project-description">
    <p>
        IsItCamp is a small website with a list of questions that determine how campy a movie is.
        It's written with a React frontend, and an Express backend with some Node.js side scripts.
        While not a very complicated concept (simply a list of yes or no questions, each with a certain score), there was some room to add interesting features.
    </p>
    <p>
        One of the interesting bits of this site, is the movie autocomplete.
        There are about half a million movies out there, and writing a fast autocomplete can get complicated.
        Some things I'd like to point out about how I wrote the autocomplete for this site...
    </p>
    <ul>
        <li>Results are sorted primarily by how many IMDb ratings they have, and then by title length</li>
        <li>Movies with the same title will have the year they were released appended to their title</li>
        <li>The backend code uses a Radix tree, a more efficient data structure for autocomplete than a prefix trie</li>
    </ul>
    <p>
        The Radix tree (or Trie) I used was written from scratch without using any libraries. There are libraries out there that probably could have handled this, but
        the goal of this project was to learn more about javascript.

        I'll have a blog post soon describing how I implemented this in more detail, but I'll give a brief overview here.
    </p>
    <p>
        A Prefix tree is a tree datastructure useful for autocomplete functions. Each node in a tree represents a character in a word, and it's children are the possible following characters.
        To find a words prefix, you follow the characters in a prefix, and then get all the children of the last character that are words.<br>

        A Radix tree is the same idea, but you collaps successive characters that don't represent words. So every node is essential, and edges represent a string of possible characters that can follow the current child. Radix trees are more memory efficient, and offer a quicker lookup.
    </p>
    <p>
        When developing this Radix tree datastructure I also learned more about how the javascript event loop works.
        Specifically I had issues where my depth first search of the tree was blocking the event loop, and my Express server wasn't receiving new requests.
        I needed the new requests, because if a user continued typing I didn't want to waste time on the tree search when it's results were no longer needed.
    </p>
    <p>
        With the use of async/await functions, and a carefully placed setImmediate() call, I was able to prevent the event loop from blocking on particularly expensive prefix lookups.
    </p>
</div>

<h3>Others</h3>

<ul class="project-list" style="column-count: 2;">
	<li><a href="https://github.com/mroseman95/crypto-plugin">Crypto Chat</a></li>
	<li><a href="https://github.com/mroseman95/twitch-meme-scraper">Twitch Scraper</a></li>
	<li><a href="https://github.com/mroseman95/twitch-migration-tracker">Twitch Migration</a></li>
	<li><a href="https://github.com/mroseman95/go-capture-app">Go Capture App</a></li>
	<li><a href="https://github.com/stohio/software-lab">Software Lab</a></li>
	<li><a href="https://github.com/mroseman95/go-go-piano">Piano Sheet Music Capture</a></li>
	<li><a href="https://github.com/stohio/gogonetwork">Business Card Sharing App</a></li>
</ul>
