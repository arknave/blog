---
title: Final Blog Post
---

_This post summarizes my work in LASA's Computer Science Independent Study class._

_TL;DR: I wrote a [quizbowl database](qbdb.arknave.com), among other small projects._

A majority of my time was spent working on a Quiz Bowl database for LASA. Despite our recent success, LASA has a relatively new quiz bowl team. A group of students approached Mr. Flowers about forming a team after reading Ken Jennings' _Brainiac_, and the rest is history. Many other top quiz bowl programs like Dorman High School or the Thomas Jefferson High School for Science and Technology have programs that started in the  nineties. Many of them have cultivated large, private databases of questions to use for practice and to study. I decided it's time to bring LASA in line with the established programs and develop a solid database that could be used for years to come.
###The Problem

The goal was to build a general-purpose quiz bowl website. We didn't strictly lay out requirements beforehand, but we wanted a large, searchable repository of questions that were tagged by subject area. There were two primary use cases: exploring new topics and learning about specific answers. 

Freed and I started devloping this site our junior year. We came up with a decent interface, but we lacked questions. All of the questions in "JagDB v1" were ripped from Protobowl's repository. This meant that the database only had tossups, and most questions were from pre-2012 high school questions. The most useful questions are modern collegiate questions, so this wouldn't do.

###Getting Started
Over the summer, Dr. Jerry Vinokurov, a quiz bowl player asked for help on a database online. Freed and I emailed him soon, and he gave us access to his repository. He was primarily asking for help on the frontend of the site. We ended up changing almost all aspects of the site. Backbone.js was replaced with Angular.js. MongoDB was replaced by PostgreSQL. Handlebars.js was replaced with Jade templates. Every time we swapped out a component, it required a large rewrite of the codebase, but it was worth it for developer ease-of-use.

While Dr. Vinokurov was unable to contribute during the year because of a packed quiz bowl schedule, the question parse he had thrown together was a godsend for us. Our shot at a parser converted all of the .doc, .pdf, and .rtf quiz bowl questions are normally distributed as into plaintext and then parsed the plaintext based on line breaks. Dr. Vinokurov's parser converted all of these files to HTML, and then used the [BeautifulSoup](http://www.crummy.com/software/BeautifulSoup/) library to parse the questions. This had the added benefit of preserving text formatting like bolding and italics, but converting similar files to HTML could produce wildly different HTML outputs. Thus, this parser was only practical for .doc files formatted a particular way.

###Handlin' Distribution

One of the improvements of this database over our attempt from last year was a more detailed categorization system. We were planning on writing a Naive Bayes classifier to determine what a question was, but we never got to it (more on that later). In preparation for the classifier, we got our quiz bowl team (around 15 students and 1 bearded history teacher) to classify over **15,000** questions! I generated splits (documents which contain all questions of a specific category) for each category and distributed them to the team. I think they definitely helped our B team patch up some of their last-minute weaknesses.

###Motivation

Unfortunately, both Freed and I stopped development soon after spring break. There's a number of reasons for this: school was picking up, we had to study for Texas Invitational, state, and then nationals, and then other competitions like HSCTF stole my attention. The difficult parts of building this system are in classification and parsing. Classification isn't hard, it just needs to be written. Before classification can happen, we need a large bank of parsed questions. Parsing questions is one of the most infuriating challenges in the world. Almost every tournament we've looked at has inconsistencies in their formatting from packet-to-packet, some worse than others (I'm looking at you, 2013 ACF Regionals). Parsing isn't an interesting computational complexity challenge, it's boring grunt-work, where most edge-cases have to either be hard-coded in or fixed by hand. Neither appealed to me, so I stopped development.

###Other Projects
I've worked on many other projects over the past year. I've competed in innumerable algorithm competions offered by TopCoder, CodeForces, and USACO, I've become more comfortable in Haskell and Clojure, and I worked with Sam on the software for Frank's bass canon. This summer, I'll be working at [Indeed](http://www.indeed.com/) again, so I'll spend my remaining time brushing up on Java eccentricities and try building something cool.
