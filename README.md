GetAroundTweet
==============

Coding challenge for getaround

Objective

Construct a small iPhone application that queries Twitter for the mention’s of ‘@Getaround’.
The resulting tweets are to be displayed in a UITableview with refresh and paging support.
Bonus points for native Twitter service integration.

Services

The application will interface with the Twitter API; more specifically, the /search/tweets endpoint.
Feel free to leverage any other third party services you wish, although it’s unlikely you will need any.

Resource URL

http://search.twitter.com/search.json?q=%40Getaround

Requirements

1. Initial launch: fetch the latest set of Tweets containing the mention ‘@Getaround’. Each table cell should contain:
A user avatar
A user name
The tweet itself
2. Pull to refresh: fetch a fresh set of tweets.
3. Infinite scrolling: fetch the next 15 tweets via the ?page= query parameter.

Bonus Requirements

1. Swipe to delete: in-memory delete via swiping a table cell.
2. Alternating row colors: break up the list of tweets via alternating row colors.
3. Retweet: authenticate a user via the Twitter Framework to add ‘retweet’ functionality.

Libraries

You are allowed to use third party libraries when appropriate (for example, we don’t expect you to write a brand new
pull to refresh library).
Please justify the use (when necessary) of any third party library (either in code comments or via email submission).

Specifications

Development environment: Xcode 4.0 and above.
Target: iOS 5.0 and above.
Memory: Full ARC support (exceptions for 3rd party libraries).
Interface Builder: Xibs are allowed, but we prefer views to be constructed in code.
