# this_Bores_Me

thisBoresMe is a mobile social media application that enables users to share media and information in real time.  Beyond the conventional social media applications, thisBoresMe features interactive geolocation-based posting and browsing capacities that advances the social media convention to an interactive 3D experience.

Perhaps the driving feature of thisBoresMe is the inversion of the the 'like' or 'retweet' genre of feedback.  Uniquely, thisBoresMe provides users the ability to rate the posts of other users as 'boring' if they see fit.  All posts on thisBoresMe feature a 'bored score' and as such popularity of a post is measured by its ability to bore other users.  This inverts the social media experience as a means to personal validation and places humor and humility as the champion cause.

At long last in the age of social media thisBoresMe not only provides users with the ability to share media with their friends and connect with new users in their proximity, but finally encourages users to let other users know when they find their posts to be tiresome, drab or even a straight up waste of time.  

# Backend

thisBoresMe is a native iOS mobile application built in Swift 2.3 via Xcode 7.3.1.

thisBoresMe uses [Parse Server deployed to Heroku](https://devcenter.heroku.com/articles/deploying-a-parse-server-to-heroku) for its backend.  Creating the database - hosted as a MLab (MongoDB) database - and deploying to Heroku is straightforward and provides an agile mobile backend that allows for all of the logic to occur within the view controllers of the application. Using [Parse-Dashboard](https://github.com/ParsePlatform/parse-dashboard) during development as a local browser-based API interface added efficiency and agility to the development process itself.

Although MongoDB is a NoSQL database platform, Parse allows thisBoresMe embrace the self-relational User class much like the classic social media applications: a user can follow another user and via the creation of a unique instance of the Follow class in which there is a 'follower' user ID and a 'followed' user ID.  Likewise, the User class permits the relation of having multiple Posts - each with their own User ID, just as Posts permit the relation of having many Comments, Hashtags and ultimately 'Boreds' which are similar to 'Likes' in Facebook or Instagram in that they connect the User class via its author to the Post of another user.  While a Post can have many 'Bored' score assessments, a User can only provide one such rating to a single Post.

# Login

thisBoresMe provides users with the ability to quickly login via Facebook OAuth


![alt text](gif1.gif)







