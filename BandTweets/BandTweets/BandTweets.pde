import twitter4j.conf.*;
import twitter4j.internal.async.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
import twitter4j.json.*;
import twitter4j.internal.util.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;
import twitter4j.internal.json.*;
import de.umass.lastfm.*;
import de.umass.lastfm.cache.*;
import de.umass.xml.*;
import de.umass.lastfm.scrobble.*;
import de.umass.util.*;
import java.util.*;
//access keys
String lastfm_key = "88837f85d0d12a6c3678fd1f6c7fbefe";
String consumer_key = "LDwH7z5El5o0BW9V20nvw";
String consumer_secret = "XT4ldRIbuyVrKo6iMuWWxW25dzZxkufXceaq5ZEc";
String access_token = "61054644-bbb7rzkbwJ4TEg1Fd5GSY3f5K9XEUm1uKjr5rgCGg";
String access_token_secret = "H3CkKknJV6ozDM0uBffbmDJNlR6mtQEPxDXpOy2Jtw";
//end access keys

boolean typing;
String input = "", band = "";
//PFont font_optien = loadFont("Optien-18.vlw");
//PFont font_arial = loadFont("ArialRoundedMTBold-12.vlw");

void setup() {
  size(500, 500);
}

void draw() {
  //textFont(font_optien);
  textSize(18);
  
  //draws instructions
  background(#4099ff);
  fill(#ffffff);
  text("Name a band or musician, and then hit enter:", 10, 20);
  
  //input box
  noStroke();
  if (input.length() > 28){
    rect(10, 52, 400, -26);
  } else if (input.length() > 14){
    rect(10, 52, 300, -26);
  } else{
    rect(10, 52, 200, -26);
  }
  
  //input text
  fill(#000000);
  text(input, 12, 45);
  
  fill(#ffffff);
  if (band != ""){
    text("Looks like other people like these \nartists similar to " + band + ":", 10, 90);
    
    textSize(12);
    text(similar(0) + "\n" + similar(1) + "\n" + similar(2), 30, 150);
    
    textSize(18);
    text("Here's why: ", 10, 220);
    
    rect(10, 230, 480, 260);
    
    fill(#000000);
    textSize(12);
    
    //if user is typing, this prevents the program from slowing down due to Tweet/lastfm fetching
    if (!typing){
      text(searchTweets(similar(0)) + "\n" + searchTweets(similar(1)) + "\n" + searchTweets(similar(2)), 12, 245);
    }
  }
}

void keyPressed() {
  typing = true;
  if (key != CODED){
    switch (key){
      case ENTER: case RETURN:
        if (input.length() > 0){
          band = input;
        }
        input = "";
        typing = false; 
        break;
      case BACKSPACE:
        if (input.length() > 0){
          input = input.substring(0, input.length() - 1);
        }
        break;
      default:
        input += key;
    }
  }
}

String similar(int ndx){
  String[] artists = new String[3];
  Collection<Artist> similarArtists = Artist.getSimilar(band, 3, lastfm_key);
  int i = 0;
  for (Artist artist : similarArtists) {
    artists[i] = artist.getName();
    i++;
  }
  if (artists[ndx] == null){
    return "No match";
  } else{
    return artists[ndx];
  }
}

String searchTweets(String simBand){  
  Twitter twitter = new TwitterFactory().getInstance ();
  twitter.setOAuthConsumer(consumer_key, consumer_secret);
  twitter.setOAuthAccessToken(new AccessToken(access_token, access_token_secret));
  try {
    Query query = new Query(simBand);
    query.setRpp(1);
    QueryResult result = twitter.search(query);
    
    ArrayList tweets = (ArrayList) result.getTweets();
    String[] oneTweet = new String[1];
    int j = 0;
    for (int i = 0; i < tweets.size(); i++) {
      Tweet t = (Tweet) tweets.get(i);
      String user = t.getFromUser();
      String msg = t.getText();
      Date d = t.getCreatedAt();
      
      if (msg.length() > 65){
        if (msg.indexOf(" ", 65) > -1){
          int ndxSpace = msg.indexOf(" ", 65);
          String substr1 = msg.substring(0, ndxSpace);
          String substr2 = msg.substring(ndxSpace + 1, msg.length() - 1);
          msg = substr1 + "\n" + substr2;
        } else{
          int ndxSpace = 65;
          String substr1 = msg.substring(0, ndxSpace);
          String substr2 = msg.substring(ndxSpace + 1, msg.length());
          msg = substr1 + "...\n" + substr2;
        }
      }
      
      oneTweet[j] = (user + " tweeted at " + d + "\n\"" + msg + "\"" + "\n\n");
      j++;
    }
    
    if (oneTweet[0] == null){
      return "Tweet unavailable";
    } else{
      return oneTweet[0];
    }
  } catch (TwitterException e) {
    return "Error: " + Integer.toString(e.getStatusCode());
  }
}
