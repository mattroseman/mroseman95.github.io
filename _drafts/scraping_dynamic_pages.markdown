---
title: "Scraping Dynamic Pages with Scrapy + Selenium"
layout: post
date: 2018-05-09 19:30
image: /assets/images/markdown.jpg
headerImage: false
tag:
- web-scraping
- scrapy
- selenium
- python
- tutorial
star: true
category: blog
author: Matthew Roseman
description: How to integrate Selenium into Scrapy to scrape dynamic web pages
---

### Contents
- [Overview](#overview)
- [Scrapy](#scrapy)
- [Selenium](#selenium)
- [Integration](#integration)

## Overview

[Scrapy](https://scrapy.org/) is a python framework used for scraping websites, and [Selenium](https://www.seleniumhq.org/) is a tool that automates web browsers for testing
purposes. Selenium was originally designed for testing purposes, but it is useful for much more.

The goal is to combine Selenium and Scrapy so we can load a website in Selenium (executing any JavaScript), and then
scrape it using the tools Scrapy gives us.

Lets say we want to scrape [Twitch](https://www.twitch.tv/) for the currently featured stream. There is probably a way to
do it through the API, but lets pretend there isn't.

To start we can go to Twitch and inspect the page through your browser and see what the HTML looks like.

You'll probably see something like this...

![Twitch Featured]({{ site.url }}/assets/images/twitch_featured_html.png)

pretty much all the data you see on twitch is loaded through JS. Without it you would just get a blank page with a
loading icon like this...

![Twitch No JS]({{ site.url }}/assets/images/twitch_no_js.png)

So we are going to need to use Scrapy and Selenium to get the data we want.

## Scrapy

To set up your dev environment install scrapy.

{% highlight bash %}
pip install scrapy
{% endhighlight %}

Make sure to check the documentation [here](https://docs.scrapy.org/en/latest/intro/install.html)

Then create scrapy's files.

{% highlight bash %}
scrapy startproject twitch_featured
{% endhighlight %}

Now we are going to create a spider to crawl twitch.

Go to your spiders directory.

{% highlight bash %}
cd twitch_featured/twitch_featured/spiders
{% endhighlight %}

And create a new spider **twitch.py**

{% highlight python %}
import scrapy


class TwitchSpider(scrapy.Spider):
    name = 'twitch-spider'
    start_urls = [
        'https://twitch.tv',
    ]

    def parse(self, response):
        pass
{% endhighlight %}

Scrapy will send a request to each url in **start_urls** and pass the response to the **parse** method.

Right now we aren't doing anything with Twitch's response, so lets use scrapy selectors to get data off of the page.

{% highlight python %}
import scrapy


class TwitchSpider(scrapy.Spider):
    name = 'twitch-spider'
    start_urls = [
        'https://twitch.tv',
    ]

    def parse(self, response):
        return response.xpath('//p[@data-a-target="carousel-broadcaster-displayname"]/text()').extract()
{% endhighlight %}

We are giving scrapy an xpath, and it uses that to grab the text that tells you the broadcaster's displayname.

For more information about how xpaths work, look at this [tutorial](https://www.w3schools.com/xml/xpath_intro.asp).

To test our code we can run

{% highlight bash %}
scrapy crawl twitch-spider -o output.json
{% endhighlight %}

We are telling the twitch-spider to crawl it's URLs and send the data it scrapes to output.json file.

But the output.json file is empty because we havn't added Selenium yet. The data we want isn't there.

## Selenium

## Integration

## Example
