-- CS4400: Introduction to Database Systems (Spring 2026)
-- Phase II B: Insert Statements + Views [v0] [February 23rd, 2026]

-- Team __
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase II B as listed in the instructions document.
-- Fill in the team number and names and GT usernames for all members above.
-- IMPORTANT: Begin your insert statements on line 49.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'media_streaming_service';
use media_streaming_service;

drop procedure if exists magic44_reset_database_state;
delimiter //
create procedure magic44_reset_database_state ()
begin
	DELETE FROM album;
	DELETE FROM content;
	DELETE FROM creates;
    DELETE FROM creator;
	DELETE FROM friends;
	DELETE FROM genres;
    DELETE FROM listener;
	DELETE FROM makes_up;
    DELETE FROM playlist;
    DELETE FROM podcast_episode;
	DELETE FROM podcast_series;
	DELETE FROM socials;
	DELETE FROM song;
	DELETE FROM subscription;
	DELETE FROM user;

    /* You must enter your data insertion statements below here.  You may sequence them in
    any order that works for you (and runs successfully).  When executed, your statements must create 
    a functional database that contains all of the data and supports as many of the constraints as possible. */

end //
delimiter ;

call magic44_reset_database_state();

-- ---------------------------------------------------------------------------------------------------------
-- Insert statements begin on line 49, implement views below.
-- !!! Do not forget to start your queries with "create or replace view ... as" !!!
-- ---------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- [1] creator_songs_view()
-- -----------------------------------------------------------------------------
/* This view displays information about the total streams and songs for each creator.
For every creator with a non-null stage name, it displays their stage name,
the total number of listeners currently streaming any of that creator’s songs,
and a list of the creator's song titles in descending order of current streams, separated by a comma and a space.
HINT: the GROUP_CONCAT function can be useful here. */
-- -----------------------------------------------------------------------------
-- create or replace view creator_songs_view as


-- -----------------------------------------------------------------------------
-- [2] friends_view()
-- -----------------------------------------------------------------------------
/* This view displays profile information on the friends a user has.
For each user, it displays their account id, full name, and number of distinct friends.
If the user is not a listener, the view shows that the user has 0 friends.
HINT: Can be useful here: UNION and the COALESCE function */
-- -----------------------------------------------------------------------------
-- create or replace view friends_view as 

	
-- -----------------------------------------------------------------------------
-- [3] playlists_view()
-- -----------------------------------------------------------------------------
/* This view displays summary information about every playlist on the platform. 
For each playlist it displays the playlist ID and the most frequently appearing album on that playlist.
In the case of a tie between albums, order them alphabetically;
the first album from ascending alphabetical order is chosen.
If the playlist only contains songs that do not belong to any album, the playlist
should not appear in this view.
HINT: Subqueries, min(), and max() can be helpful here.
*/
-- -----------------------------------------------------------------------------
-- create or replace view playlists_view as

    
-- [4] two_creator_view
-- -------------------------------------------------------------------------
/* This view gives information about just two creators.
Retrieve a list of the creators' socials in a comma-separated list of the format, "Platform: Handle",
the song pinned on their creator profile if one exists (null if one doesn't),
and the number of genres this creator has made songs in.
This view should only look at the 3rd and 4th rows of the creator table.
*/
-- ---------------------------------------------------------------------------
-- create or replace view two_creator_view as


-- [5] podcasts_view
-- -------------------------------------------------------------------------
/* This view provides an overview of all podcasts, including the podcast ID, title,
number of episodes, and total length in hours of all episodes combined.
Report the length to 4 decimal places. */
-- ---------------------------------------------------------------------------
-- create or replace view podcasts_view as


-- [6] subscriptions_view
-- ---------------------------------------------------------------------------
/* This view lists all subscriptions by the following details:
the subscription ID, the user enrolled in this subscription,
the type of plan (Family or Individual), maximum number of users (for Family plans), 
tier (for Individual plans), start date, end date, the status of the subscription (Inactive or Active),
and if the plan is Active, how many days remaining until expiration from the current date. 
If the plan is Inactive, display null remaining days. Order this view by subscription ID ascending.
HINT: The CURDATE and TIMESTAMPDIFF functions can be helpful here.*/
-- ---------------------------------------------------------------------------
-- create or replace view subscriptions_view as


-- [7] genre_distribution_view
-- ---------------------------------------------------------------------------
/* This view shows the distribution of songs across different genres. 
It displays each genre with the number of songs that belong to that genre
and lists the content IDs of those songs ordered alphabetically 
and separated by a semi-colon and a space. 
Order the genres of this view in descending order of how many songs belong to a genre. 
HINT: GROUP_CONCAT() and the separator clause can be helpful here. */
-- ---------------------------------------------------------------------------
-- create or replace view genre_distribution_view as


-- [8] recent_subscriptions_view
-- ---------------------------------------------------------------------------
/* This view lists the details of the 3 most recent subscription enrollments.
Select each listener's full name, the subscription ID they are enrolled in, 
and the cost of the plan. Order this view from newest to oldest enrollment date,
breaking ties by the listeners' names in ascending alphabetical order. */
-- ---------------------------------------------------------------------------
-- create or replace view recent_subscriptions_view as


-- [9] count_streams_view
-- ---------------------------------------------------------------------------
/* This view shows the number of users streaming the song that holds the highest
track order in every playlist. For every playlist that contains at least 1 song,
select the song ID of the last song based on the track order. 
Then, for each of these songs, select how many users are currently streaming the song, 
even if there are 0 users streaming. 
HINT: COALESCE() can be helpful here. */
-- ---------------------------------------------------------------------------
-- create or replace view count_streams_view as




