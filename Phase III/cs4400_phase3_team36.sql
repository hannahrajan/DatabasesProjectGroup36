-- CS4400: Introduction to Database Systems (Spring 2026)
-- Phase III: Stored Procedures [v0] [March 12th, 2026]

-- Team 36
-- Phil Abraham (pabraham9)
-- Claire Lee (clee931)
-- Hannah Rajan (hrajan30)

-- Directions:
-- Please follow all instructions for Phase III in the instructions document.
-- Fill in the team number and names and GT usernames for all members above.
-- This file must run without error. Submissions that don't compile will receive a 0.


/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set session SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'media_streaming_service';
use media_streaming_service;

-- -------------------
-- Stored Procedures
-- -------------------

-- -----------------------------------------------------------------------------
-- [1] renew_subscription()
-- -----------------------------------------------------------------------------
/* This SP extends the end_date of an existing subscription for a listener to a later date. 
Update the subscription's end date to the new end date for the given listener.
Ensure that the listener ID and the new end date are both non-null and that the listener 
exists with a current subscription. Ensure the end date is strictly after the current date 
and strictly later than the subscription's current end date. 
HINT: CURDATE() can be useful here. Also, in a family plan, anyone within the family 
is allowed to renew the subscription.*/
-- -----------------------------------------------------------------------------
drop procedure if exists renew_subscription;
delimiter //
create procedure renew_subscription(
	in ip_listenerID varchar(20), 
    in ip_new_date date
)
sp_main: begin
	-- code here
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [2] duplicate_playlist()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a copy of an existing playlist under a new playlist ID.
Ensure that both the input playlist ID and the new playlist ID are non-null, 
that the input playlist exists, and that it currently contains at least one song. 
Also, make sure the new playlist ID does not currently exist in the database.
Insert a new row into the playlist table with the new playlist ID, 
setting its name to 'Copy of ' concatenated with the original playlist's name and using the 
same listener as the owner. For all songs in the original playlist, it inserts each song into 
makes_up for the new playlist so that the copy has the same song contents.
HINT: CONCAT() can be useful here. */
-- -----------------------------------------------------------------------------
drop procedure if exists duplicate_playlist;
delimiter //
create procedure duplicate_playlist(
    in ip_playlistID varchar(20),
    in ip_new_playlistID varchar(20)
)
sp_main: begin
	-- counter to keep track of current song to select
	declare curr_song_index int default 0;
	-- check for null
	if (ip_playlistID is null or ip_new_playlistID is null) then 
		select "At least one of the playlistIDs are null.";
        leave sp_main;
	-- check if playlistID has at least one song
	elseif not exists(select songID from makes_up where playlistID = ip_playlistID) then  
		select concat("The playlist corresponding to ", ip_playlistID, " does not have any songs.");
        leave sp_main;
	-- check if playlistID already exists, either in playlist or makes_up
	elseif (exists(select playlistID from playlist where playlistID = ip_new_playlistID) or 
			exists(select playlistID from makes_up where playlistID = ip_new_playlistID)) then
		select concat("There already exists a playlist with the ID ", ip_new_playlistID, ".");
        leave sp_main;
	else 
		-- create new playlist using old playlist data
		insert into playlist(playlistID, name, listenerID) values
			(ip_new_playlistID,
            concat("Copy of ", (select name from playlist where playlistID = ip_playlistID limit 1)),
            (select listenerID from playlist where playlistID = ip_playlistID limit 1)
            );
		-- add all songs from old playlist to new playlist
		while (select count(*) from makes_up where playlistID = ip_playlistID) > 
        (select count(*) from makes_up where playlistID = ip_new_playlistID) do
			insert into makes_up(songID, playlistID, track_order) values
            ((select songID from makes_up where playlistID = ip_playlistID limit 1 offset curr_song_index),
            ip_new_playlistID,
            (select track_order from makes_up where playlistID = ip_playlistID limit 1 offset curr_song_index)
            );
            set curr_song_index = curr_song_index + 1; -- update song counter
		end while;
    end if;
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [3] add_podcast_episode()
-- -----------------------------------------------------------------------------
/* This stored procedure adds a new podcast episode for a creator and associates it with a podcast series.
If the episode is valid, this SP creates the podcast series if it does not already exist, 
inserts the episode as a new content item, links it to the creator, and assigns the next episode number 
in order for that podcast. Ensure that only the non-null input parameters are non-null and 
to enforce domain constraints. Ensure that the creator exists, that the content ID is not already used,
and that if the podcast already has episodes then those episodes belong to the same creator. 
Ensure that the episode length falls within the allowed range. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_podcast_episode;
delimiter //
create procedure add_podcast_episode(
    in ip_creatorID varchar(20),
    in ip_contentID varchar(20),
	in ip_length int,
    in ip_maturity_rating varchar(20),
	in ip_title varchar(100),
    in ip_release_date date,
	in ip_language varchar(50),
    in ip_topic varchar(50),
	in ip_podcastID varchar(20),
    in ip_podcast_title varchar(100),
	in ip_podcast_description varchar(200)
)
sp_main: begin
	-- code here
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [4] stream_content()
-- -----------------------------------------------------------------------------
/* This stored procedure starts streaming a specific piece of content for a listener 
by updating what content the listener is currently streaming. It enforces age and maturity 
restrictions so that underage listeners cannot stream explicit content. 
Ensure that the inputs are non-null and that both the listener and content exist. 
Ensure that the listener’s age is computed from their birthdate and that if the content is marked 'Explicit' 
the listener is at least 18 years old before updating their currently streamed content. Timestamp
is set to 0, when content begins streaming. 
HINT: TIMESTAMPDIFF() and CURDATE() can be useful here. */
-- -----------------------------------------------------------------------------
drop procedure if exists stream_content;
delimiter //
create procedure stream_content(
    in ip_listenerID varchar(20),
    in ip_contentID varchar(20)
)
sp_main: begin
	-- code here
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [5] add_friend_connection()
-- -----------------------------------------------------------------------------
/* This stored procedure records a friendship connection between two listeners. 
Ensure that inputs are non-null, a listener does not friend themself, and 
both listener ids refer to existing listeners and that there is not already a friendship between the 
two accounts before recording the new friendship. Also ensure that ip_listenerID1 is the friender. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_friend_connection; 
delimiter //
create procedure add_friend_connection (
	in ip_listenerID1 varchar(20), 
    in ip_listenerID2 varchar(20)
)
sp_main: begin
	-- check for null
	if (ip_listenerID1 is null or ip_listenerID2 is null) then 
		select "At least one of the listenerIDs are null.";
        leave sp_main;
	-- check if the listenerIDs are the same
	elseif (ip_listenerID1 = ip_listenerID2) then
		select "A listener cannot friend themselves.";
        leave sp_main;
	-- check if listenerID1 is within the listener table
	elseif not (exists(select accountID from listener where accountID = ip_listenerID1)) then
		select concat("The listenerID ", ip_listenerID1, " does not exist.");
        leave sp_main;
	-- check if listenerID2 is within the listener table
	elseif not (exists(select accountID from listener where accountID = ip_listenerID2)) then
		select concat("The listenerID ", ip_listenerID2, " does not exist.");
        leave sp_main;
	-- check if the friendship between listenerID1 & listenerID2 exists already
	elseif (exists(select friender, friendee from friends where ((friender = ip_listenerID1 and friendee = ip_listenerID2) or 
		   (friender = ip_listenerID2 and friendee = ip_listenerID1)))) then
		select concat("A friendship between ", ip_listenerID1, " and ", ip_listenerID2, " already exists.");
        leave sp_main;
	else
		-- record new friendship
		insert into friends(friender, friendee) values (ip_listenerID1, ip_listenerID2);
	end if;
end //
delimiter ; 

-- -----------------------------------------------------------------------------
-- [6] pin_content()
-- -----------------------------------------------------------------------------
/* This stored procedure pins one of a creator’s content to their profile.
 It updates the creator so that the given content becomes the content shown on their creator page.
 Ensure that the inputs are non-null and that the content and creator exists. 
 Ensure that the song belongs to the given creator. */
-- -----------------------------------------------------------------------------
drop procedure if exists pin_content; 
delimiter //
create procedure pin_content(
	in ip_creatorID varchar(20),
	in ip_contentID varchar(20)
)
sp_main: begin
	-- code here
end //
delimiter ; 

-- -----------------------------------------------------------------------------
-- [7] cancel_subscription()
-- -----------------------------------------------------------------------------
/* This stored procedure cancels an existing subscription and removes related data for 
listeners on that subscription. It removes friendships where either friend is a listener participating
in this subscription, deletes all playlists owned by listeners participating in this subscription, 
and removes the subscription record itself so that the plan is no longer active.
Ensure that the subscription ID is non-null and that it refers to an existing subscription. */
-- -----------------------------------------------------------------------------
drop procedure if exists cancel_subscription;
delimiter //
create procedure cancel_subscription(in ip_subscription_id varchar(20))
sp_main: begin
    -- code here
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [8] create_playlist()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new playlist for a listener and adds an initial song to it. 
It looks up the listener by username, creates a new playlist owned by the listener, 
and then adds the requested song to the new playlist. Ensure that the inputs are all non-null. 
Ensure that the username corresponds to an existing listener, that the content ID refers to an existing song, 
and that the playlist ID is not already in use in the playlist table before inserting the new playlist. Also ensure
that listeners without subscriptions will not have more than 5 playlists in total.
HINT: You should complete add_song_to_playlist before this procedure! */
-- -----------------------------------------------------------------------------
drop procedure if exists create_playlist;
delimiter //
create procedure create_playlist(
    in ip_username varchar(100),
    in ip_playlist_name varchar(100),
    in ip_playlistID varchar(20),
    in ip_contentID varchar(20)
)
sp_main: begin
	-- userID: local variable that stores the ID of the given listener via their username
	declare userID varchar(20);
    select accountID into userID from listener where username = ip_username limit 1; -- username should be unique!
    -- check for null
	if (ip_username is null or ip_playlist_name is null or ip_playlistID is null or ip_contentID is null) then 
		select "At least one of the inputs are null.";
        leave sp_main;
	-- check if the username is within the listener table
	elseif not (exists(select username from listener where username = ip_username)) then
		select concat("The listener username ", ip_username, " does not exist.");
        leave sp_main;
	-- check if the song is within the songs table
	elseif not (exists(select contentID from song where contentID = ip_contentID)) then
		select concat("The songID ", contentID, " does not exist.");
        leave sp_main;
	-- check if the playlist already exists 
	elseif not (exists(select playlistID from playlist where playlistID = ip_playlistID)) then
		select concat("A playlist with ID ", ip_playlistID, " already exists.");
        leave sp_main;
	-- check if the listener, if they don't have a subscription, doesn't make more than 5 playlists 
	elseif ((not (exists(select subscription from listener where username = ip_username))) and 
		   ((select count(*) from playlist where listenerID = userID) = 5)) then
		select concat("The ∂listener ", ip_username, " does not have a subscription and cannot make more than 5 playlists.");
        leave sp_main;
	else
		-- create playlist
		insert into playlist(playlistID, name, listenerID) values
			(ip_playlistID,
            ip_playlist_name,
            userID);
		-- add initial song to the playlist
        call add_song_to_playlist(ip_username, ip_playlistID, ip_contentID);
	end if;
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [9] add_song_to_playlist()
-- -----------------------------------------------------------------------------
/* This stored procedure adds a song to one of a listener’s playlists. 
It looks up the listener by username and inserts the song into that playlist if it is not already present. 
Ensure that the inputs are all non-null and that the username refers to an existing listener. 
Ensure that the playlist with the given ID exists and is owned by that listener, 
that the content id refers to an existing song, and that the song is not already in the playlist. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_song_to_playlist;
delimiter //
create procedure add_song_to_playlist(
    in ip_username varchar(100),
    in ip_playlistID varchar(20),
    in ip_contentID varchar(20)
)
sp_main: begin
    -- code here
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [10] start_playlist()
-- -----------------------------------------------------------------------------
/* This stored procedure starts streaming the first song (in alphabetical order by title)
from a given playlist for a given listener. Ensure non-null input, that the listener
exists, that the playlist exists, and that the playlist belongs to the listener. 
If a playlist does not have any songs, then nothing should occur. Calling another 
previously implemented stored procedure to start streaming would be useful here! */
-- -----------------------------------------------------------------------------
drop procedure if exists start_playlist;
delimiter //
create procedure start_playlist(
    in ip_username varchar(100),
    in ip_playlistID varchar(20)
)
sp_main: begin
    -- code here
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [11] create_user()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new user account, which can be a creator, listener, or both.
Ensure non-null input for account ID, full name, birthdate, and email. Ensure that the
account ID is unique in the user table. Ensure that the user
is at least 13 years old based on the birthdate provided. If the user is a listener, ensure that
the username is non-null, and if streams is non-null, it references an
existing content and that time stamp is set to 0. Use the passed in enum ip_user_type to determine if the user is a creator,
listener, or both. If the user is both, but the listener-related validations fail (e.g., username
and/or streams is invalid), then no data should be inserted into either
listener or creator.
HINT: TIMESTAMPDIFF() can be helpful here. */
-- -----------------------------------------------------------------------------
drop procedure if exists create_user; 
delimiter //
create procedure create_user (
	in ip_accountID varchar(20), 
    in ip_fullname varchar(100), 
    in ip_birthdate date, 
    in ip_email varchar(200),
    in ip_username varchar(100), 
    in ip_stagename varchar(100), 
    in ip_bio varchar(200), 
    in ip_currentlyStreaming varchar(20),
    in ip_user_type enum('creator', 'listener', 'both')
)
sp_main: begin
    -- code here
end //
delimiter ; 

-- -----------------------------------------------------------------------------
-- [12] upload_song()
-- -----------------------------------------------------------------------------
/* This stored procedure allows a creator to upload a new song to the platform.
Ensure non-null inputs for all fields except album name (which is optional).
Ensure that the content ID is unique, that the creator ID exists in the creator table,
that the album (if provided) exists and is owned by the creator, and that the
album has fewer than 16 songs. Also, ensure that the content length is between
60 and 600 seconds. All creators with songs on the platform need a stage name.
If this artist does not already have a stage name, set it to their full name
(from the user table). Otherwise, leave it as it currently is.

HINT: Make sure to add data to all relevant tables within the database. */
-- -----------------------------------------------------------------------------
drop procedure if exists upload_song; 
delimiter //
create procedure upload_song (
	in ip_contentID varchar(20), 
    in ip_contentLength int, 
    in ip_title varchar(100), 
    in ip_maturity enum('Not Explicit', 'Explicit'), 
    in ip_contentLanguage varchar(50), 
    in ip_releaseDate date, 
    in ip_creatorID varchar(20), 
    in ip_albumName varchar(100)
)
sp_main: begin
	-- code here
end //
delimiter ; 

-- -----------------------------------------------------------------------------
-- [HELPER PROCEDURE] resequence_track_order()
-- -----------------------------------------------------------------------------
/* This helper procedure resequences the track order of all songs in a given
playlist so that they are numbered consecutively starting from 1, preserving
their original relative order. */
-- -----------------------------------------------------------------------------
drop procedure if exists resequence_track_order;
delimiter //
create procedure resequence_track_order (
    in ip_playlistID varchar(20)
)
sp_main: begin
    declare curr_songID varchar(20);
    declare counter int default 1;
	declare total int;

    select count(*) into total from makes_up where playlistID = ip_playlistID;

    while counter <= total do
        select songID into curr_songID from makes_up
        where playlistID = ip_playlistID and track_order >= counter
        order by track_order asc
        limit 1;

        update makes_up
        set track_order = counter
        where songID = curr_songID and playlistID = ip_playlistID;

        set counter = counter + 1;
    end while;
end //
delimiter ;

-- -----------------------------------------------------------------------------
-- [13] delete_playlist_songs()
-- -----------------------------------------------------------------------------
/* This stored procedure deletes song IDs containing the input character/phrase
from the input playlist. Ensure non-null inputs and that the playlist exists. If 
no songs in the playlist contain the input character/phrase, then nothing is deleted.
After deleting songs, you will have to rearrange the track orders. We have provided you
a helper function, resequence_track_order(), that you might find especially useful. 
If a playlist has no songs left, then also delete the entire playlist. */
-- -----------------------------------------------------------------------------
drop procedure if exists delete_playlist_songs;
delimiter //
create procedure delete_playlist_songs (
    in ip_playlistID varchar(20),
    in ip_char_phrase varchar(20)
)
sp_main: begin
	-- code here
end //
delimiter ;


-- -----------------------------------------------------------------------------
-- [14] merge_playlists()
-- -----------------------------------------------------------------------------
/* This stored procedure merges two playlists into one. The songs from the second
playlist are added to the first playlist with track orders continuing from the
first playlist's current maximum, and then the second playlist is deleted. Duplicate 
songs (already in the first playlist) are removed from the second playlist before 
merging. Due to duplicate songs, the track_order might lose sequential order. We have
provided you a helper function, resequence_track_order(), that you might find especially 
useful to handle this issue.  Ensure non-null inputs, that both playlists exist, that 
both playlists are not the same, and that both playlists belong to the same listener. 

HINT: When you delete songs from playlist 2 that are already in playlist 1, you might need 
to use a nested query with aliasing. 
*/
-- -----------------------------------------------------------------------------
drop procedure if exists merge_playlists;
delimiter //
create procedure merge_playlists (
    in ip_playlistID1 varchar(20), -- first playlist
    in ip_playlistID2 varchar(20) -- second playlist
)
sp_main: begin
	-- code here
end //
delimiter ;


-- -----------------------------------------------------------------------------
-- [15] stop_stream()
-- -----------------------------------------------------------------------------
/* This stored procedure stops a listener from streaming any content by setting
their currently streaming content to null. Ensure non-null input, that the
account is a listener, and that the listener is currently streaming content. */
-- -----------------------------------------------------------------------------
drop procedure if exists stop_stream;
delimiter //
create procedure stop_stream (
	in ip_accountID varchar(20) -- listener
)
sp_main: begin
    -- code here
end //
delimiter ;


-- -----------------------------------------------------------------------------
-- [16] add_feature
-- -----------------------------------------------------------------------------
/* This stored procedure associates a creator to an existing piece of content. 
Ensure non-null parameters and that the creator ID is valid. Because the creator
is being featured rather than creating the content, the referenced content must
already exist. Also, ensure that this feature is not already recorded. Ensure that
the content has no more than 5 creators associated with it. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_feature;
delimiter //
create procedure add_feature (
	in ip_contentID varchar(20), 
    in ip_creatorID varchar(20)
)
sp_main: begin
    -- code here
end //
delimiter ;


-- -----------------------------------------------------------------------------
-- [17] delete_episodes()
-- -----------------------------------------------------------------------------
/* This stored procedure deletes the given number of podcast episodes from a podcast 
series as well as from the database. Ensure non-null parameters and that the podcast series
exists. Also ensure that the given number is non-negative. If the number is 
greater than the number of episodes in the series, do not delete any episodes. 
Delete episodes in descending order, starting from the highest episode number. */
-- -----------------------------------------------------------------------------
drop procedure if exists delete_episodes;
delimiter //
create procedure delete_episodes (
	in ip_podcastID varchar(20),
    in ip_num_episodes int
)
sp_main: begin
    -- code here
end //
delimiter ;


-- -----------------------------------------------------------------------------
-- [18] remove_socials
-- -----------------------------------------------------------------------------
/* This stored procedure deletes all except for one social media handle for a
creator. Ensure that the input creator ID is a valid creator ID. The handle to 
keep is determined by the following priority rules (from highest to lowest): 
1) If the creator participates in any podcast series, keep the TikTok handle 
if the creator has one. 2) If the creator has created at least 2 albums, keep 
the creator's SoundCloud handle. 3) If the creator was born on or after January 1, 2000, 
keep the creator's Snapchat. 4) Otherwise, delete all handles except
for the alphabetically first social media handle under that creator.

After these deletions, if the creator doesn't have any social media information listed,
add back the creator's originally alphabetically first social media handle. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_socials;
delimiter //
create procedure remove_socials (
	in ip_creatorID varchar(20)
)
sp_main: begin
    -- code here
end //
delimiter ;
