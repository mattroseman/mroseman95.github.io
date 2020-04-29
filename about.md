---
title: About
layout: page
---

<p>I am a fullstack software engineer, using Python, JavaScript, and Golang. I am interested in open source projects
</p>

<p>I created this website to showcase my work, and to create a blog to help me learn new topics. I will be writting
about a wide array of topics, probably all related to software engineering.</p>

<h2>Projects</h2>

<h3><a href="https://moviemap.io">Movie Map</a></h3>
<small><a href="https://github.com/mattroseman/filmlocations">source</a></small>
<div class="project-description">
    <p>
        Movie Map is an interactive map built with Leaflet.js on React with an Express backend.
        I scraped IMDb to get a list of all movies, and their shooting locations around the world.
        I then hit Google's geocoding API to get location infomation (like latitude/longitude coordinates) and stored all that information in MongoDB.

        When you view the map location data is clustered based on your zoom level. This is done using <a href="https://en.wikipedia.org/wiki/Geohash">geohashes</a>.
        For each lat/lon coordinate in the database, I also compute the geohash of that coordiante, and using the prefixes of the geohash,
        I can quickly look up which locations belong in each cluster.

        This also allowed me to cache the location clusters, making the map update even faster.
    </p>
</div>

<h3><a href="http://www.isitcamp.com">IsItCamp</a></h3>
<small><a href="https://github.com/mattroseman/isitcamp">source</a></small>
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

        A more detailed explanation of how I built this can be read in this <a href="http://mroseman.com/radix-tree/">blog post</a>
    </p>
</div>

<h3>Others</h3>

<ul class="project-list" style="column-count: 2;">
	<li><a href="https://github.com/mattroseman/crypto-plugin">Crypto Chat</a></li>
	<li><a href="https://github.com/mattroseman/twitch-meme-scraper">Twitch Scraper</a></li>
	<li><a href="https://github.com/mattroseman/twitch-migration-tracker">Twitch Migration</a></li>
	<li><a href="https://github.com/mattroseman/go-capture-app">Go Capture App</a></li>
	<li><a href="https://github.com/stohio/software-lab">Software Lab</a></li>
	<li><a href="https://github.com/mattroseman/go-go-piano">Piano Sheet Music Capture</a></li>
	<li><a href="https://github.com/stohio/gogonetwork">Business Card Sharing App</a></li>
</ul>
