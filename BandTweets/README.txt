==ABOUT==
BandTweets is a program that takes a user's band, artist, performer, etc. and suggests three other ones and shows via Twitter why they are popular. Perhaps someone tweeted that they're a great thing to wake up to, or maybe their frequent appearances in Atlanta make them very accessible and real. Internet connection is required for this program to work.

==TECHNICAL==
BandTweets uses two sites' APIs: last.fm and Twitter. A simulated text box that auto-adjusts in case the user uses a really long band name "holds" the user's input. Once enter or return is pressed, a request is sent to last.fm to find similar artists. Because I was not familiar with Java's collections, as last.fm returned, I converted to an array. Once these artists are fetched ("No match" prints in case this is impossible), it searches Twitter for tweets associated with those artists. For brevity's sake, I took one tweet per band to display at a time; however, since draw is repeatedly called, this allows multiple tweets to be displayed *over* time (per redraw). In case the tweet is too long for the window, it linebreaks after a space is found after 65 characters. This is not accurate all the time, especially if it consists of few spaces, in which case it breaks at 65 characters exactly and adds "..." to indicate overflow of that line. In case no tweets can be found, it simply prints "Tweet unavailable," and if there is a Twitter error, it prints that error.

==ISSUES==
Attempts at using another font via PFont/loadFont did not work for some reason, and it would have allowed the interface to be more Twitter-y with the selected fonts.

Again, overflow for individual tweets may occur due to my limited knowledge of how to most efficiently word-wrap in processing.