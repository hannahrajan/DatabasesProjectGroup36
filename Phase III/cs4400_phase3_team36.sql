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
	-- variable declaration
	declare subID varchar(20);
    declare current_end_date date;
    
    -- check both inputs are non-null
    if ip_listenerID is null or ip_new_date is null then
    leave sp_main;
	end if;
    -- check if listener exists
    select subscription into subID from listener where accountID = ip_listenerID;
	if subID is null then
	leave sp_main;
	end if;
    
    -- check if end date is after the current date
    select end_date into current_end_date from subscription where subscriptionID = subID;
	if ip_new_date <= curdate() then
	leave sp_main;
	end if;
    
    -- check if end date is later than the subscription's current end date
	if ip_new_date <= current_end_date then
	leave sp_main;
	end if;
    
    -- update
    update subscription set end_date = ip_new_date where subscriptionID = subID;
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
    declare old_playlist_name varchar(100);
    declare old_listenerID varchar(20);
    declare song_count int default 0;
    declare playlist_exists int default 0;
    declare curr_songID varchar(20);
    declare curr_track_order int default 0;
	-- check for null
	if (ip_playlistID is null or ip_new_playlistID is null) then 
		select 'At least one of the playlistIDs are null.';
        leave sp_main;
	end if;
	-- update song count
    select count(*) into song_count from makes_up where playlistID = ip_playlistID;
	-- check if playlistID has at least one song
	if song_count = 0 then  
		select concat('The playlist corresponding to ', ip_playlistID, ' does not have any songs.');
        leave sp_main;
	end if;
    -- update number of playlists that currently exist with the same ID as the new playlist
    select count(*) into playlist_exists from playlist where playlistID = ip_new_playlistID;
	-- check if the new playlistID already exists
	if playlist_exists > 0 then
		select concat('There already exists a playlist with the ID ', ip_new_playlistID, '.');
        leave sp_main;
	else 
		-- grab old playlist data
		select name, listenerID into old_playlist_name, old_listenerID from playlist where playlistID = ip_playlistID;
		-- create new playlist using old playlist data
		insert into playlist(playlistID, name, listenerID) values
		(ip_new_playlistID, concat('Copy of ', old_playlist_name), old_listenerID);
		-- add all songs from old playlist to new playlist
		while curr_song_index < song_count do
			-- fetch values to add into the new playlist
			select songID, track_order into curr_songID, curr_track_order from 
            makes_up where playlistID = ip_playlistID limit 1 offset curr_song_index;
            -- insert current song and its values into the new playlist
			insert into makes_up(songID, playlistID, track_order) values
            (curr_songID, ip_new_playlistID,curr_track_order);
			-- update song counter
            set curr_song_index = curr_song_index + 1;
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
	declare creator_ID varchar(20);
    declare content_ID varchar(20);
    declare podcast_ID varchar(20);
    declare max_episode int;
    declare numb_episodes int default 1;
    declare episode_creatorID varchar(20);
    declare episode_index int default 1;
    
    -- check only non-null input parameters are non-null
	if ip_creatorID is null or ip_contentID is null or ip_length is null or ip_maturity_rating is null or ip_title is null
		or ip_release_date is null or ip_language is null or ip_topic is null or ip_podcastID is null or ip_podcast_title is null
		then
	select 'At least one non-null field is null.';
	leave sp_main;
    end if;
    
    -- enforce domain constraints
	
    -- check creator exists
	select accountID into creator_ID from creator where accountID = ip_creatorID;
    if creator_ID is null then
	select 'At least one creator is null.';
    leave sp_main;
    end if;
    
    -- check content id is not already used
    select contentID into content_ID from content where contentID = ip_contentID;
    if content_ID is not null then
	select 'Content ID is already in use.';
    leave sp_main;
    end if;
    
    -- check if podcast already has episodes, they belong to the same creator
    select count(pe.contentID) into numb_episodes from podcast_episode pe
    where pe.podcastID = ip_podcastID;
    
    select max(pe.episode_number) into max_episode from podcast_episode pe
    where pe.podcastID = ip_podcastID;
    
    if numb_episodes > 0 then 
		while episode_index <= max_episode do
			select c.creatorID into episode_creatorID from creates c join podcast_episode p on c.contentID = p.contentID
			where episode_number = episode_index and p.podcastID = ip_podcastID;
			if episode_creatorID != ip_creatorID then
				leave sp_main;
            end if;
            
            set episode_index = episode_index + 1;
		end while;
	end if;
    
    -- check if episode length falls within the allowed range
    if ip_length < 0 or ip_length > 3600 then
		leave sp_main;
    end if;
    
    -- create podcast series if it does not already exist
    if not (exists(select podcastID from podcast_series where podcastID = ip_podcastID)) then
    insert into podcast_series(podcastID, title, description)
    values (ip_podcastID, ip_podcast_title, ip_podcast_description);
    end if;
    
    -- insert episode as new content item
    insert into content(contentID, title, content_length, maturity, content_language, release_date)
    values(ip_contentID, ip_title, ip_length, ip_maturity_rating, ip_language, ip_release_date);

    -- link to creator
    insert into creates (contentID, creatorID) values (ip_contentID, ip_creatorID);
    
    -- assign the next episode number in order for that podcast
    select max(pe.episode_number) into max_episode from podcast_episode pe join podcast_series ps on pe.podcastID = ps.podcastID
    where ps.title = ip_podcast_title;
    set max_episode = max_episode + 1; -- add next episode number
    
    insert into podcast_episode(contentID, podcastID, topic, episode_number)
    values(ip_contentID, ip_podcastID, ip_topic, max_episode);
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
	-- variable declaration
	declare listener_ID varchar(20);
    declare content_ID varchar(20);
    declare age int;
    declare content_maturity varchar(20);
    
    -- check if both inputs are non-null
    if ip_listenerID is null or ip_contentID is null then
	leave sp_main;
	end if;
    
    -- check if listener exists
    select accountID into listener_ID from listener where accountID = ip_listenerID;
    if listener_ID is null then
	leave sp_main;
	end if;
    
    -- check if content exists
	select contentID into content_ID from content where contentID = ip_contentID;
    if content_ID is null then
	leave sp_main;
	end if;
    
    -- age computation
    select timestampdiff(year, bdate, curdate()) into age from user where accountID = ip_listenerID;
    
    -- maturity
    select maturity into content_maturity from content where contentID = ip_contentID;
    
    -- check if the content is marked 'Explicit' and the listener is at least 18 years old
    if age < 18 and content_maturity = 'EXPLICIT' then
	leave sp_main;
	end if;
    
    -- update
    update listener set streams = ip_contentID, Timestamp = 0 where accountID = ip_listenerID;
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
		select 'At least one of the listenerIDs are null.';
        leave sp_main;
	-- check if the listenerIDs are the same
	elseif (ip_listenerID1 = ip_listenerID2) then
		select 'A listener cannot friend themselves.';
        leave sp_main;
	-- check if listenerID1 is within the listener table
	elseif not (exists(select accountID from listener where accountID = ip_listenerID1)) then
		select concat('The listenerID ', ip_listenerID1, ' does not exist.');
        leave sp_main;
	-- check if listenerID2 is within the listener table
	elseif not (exists(select accountID from listener where accountID = ip_listenerID2)) then
		select concat('The listenerID ', ip_listenerID2, ' does not exist.');
        leave sp_main;
	-- check if the friendship between listenerID1 & listenerID2 exists already
	elseif (exists(select friender, friendee from friends where ((friender = ip_listenerID1 and friendee = ip_listenerID2) or 
		   (friender = ip_listenerID2 and friendee = ip_listenerID1)))) then
		select concat('A friendship between ', ip_listenerID1, ' and ', ip_listenerID2, ' already exists.');
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
		-- Ensure that the inputs are non-null and that the content and creator exists. 
        if ip_creatorID is null or ip_contentID is null then
        leave sp_main;
        end if;
        
        if not (exists(select contentID from content where contentID = ip_contentID)) then 
        leave sp_main;
        end if;

        if not (exists(select accountID from creator where accountID = ip_creatorID)) then 
        leave sp_main;
        end if;
        
    -- Ensure that the song belongs to the given creator
		if not exists (select * from creates where contentID = ip_contentID and creatorID = ip_creatorID) then
        leave sp_main;
        end if;
			
    -- updates the creator so that the given content becomes the content shown on their creator page.
		update creator set pinned = ip_contentID where accountID = ip_creatorID;
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
	-- variable declaration
    declare subscription_ID varchar(20);
    
    -- check if input is non-null
    if ip_subscription_id is null then
    leave sp_main;
    end if;
    
    -- check if subscription exists
    select subscriptionID into subscription_ID from subscription where subscriptionID = ip_subscription_id;
    if subscription_ID is null then
    leave sp_main;
    end if;
    
    -- delete friendship if either friend is participating in the subscription
    delete from friends where friender in (select accountID from listener where subscription = ip_subscription_id)
    or friendee in (select accountID from listener where subscription = ip_subscription_id);
    
    -- delete all playlists owned by listeners participating in the subscription
    delete from playlist where listenerID in (select accountID from listener where subscription = ip_subscription_id); 
    
    -- remove subscription record
    delete from subscription where subscriptionID = ip_subscription_id;
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
    -- check for null
	if (ip_username is null or ip_playlist_name is null or ip_playlistID is null or ip_contentID is null) then 
		select 'At least one of the inputs are null.';
        leave sp_main;
	-- check if the username is within the listener table
	elseif not (exists(select username from listener where username = ip_username)) then
		select concat('The listener username ', ip_username, ' does not exist.');
        leave sp_main;
	-- check if the song is within the songs table
	elseif not (exists(select contentID from song where contentID = ip_contentID)) then
		select concat('The songID ', contentID, ' does not exist.');
        leave sp_main;
	-- check if the playlist already exists 
	elseif (exists(select playlistID from playlist where playlistID = ip_playlistID)) then
		select concat('A playlist with ID ', ip_playlistID, ' already exists.');
        leave sp_main;
	-- check if the listener, if they don't have a subscription, doesn't make more than 5 playlists 
	elseif ((not (exists(select subscription from listener where username = ip_username))) and 
		   ((select count(*) from playlist where listenerID = userID) >= 5)) then
		select concat('The listener ', ip_username, ' does not have a subscription and cannot make more than 5 playlists.');
        leave sp_main;
	else
		-- grab userID value
        select accountID into userID from listener where username = ip_username; 
		-- create playlist
		insert into playlist(playlistID, name, listenerID) values
		(ip_playlistID, ip_playlist_name, userID);
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
	declare listener_ID varchar(20);
    
    -- ensure all inputs are non-null
    if ip_username is null or ip_playlistID is null or ip_contentID is null then
    leave sp_main;
    end if;
    
    -- check if playlist with given id exists and is owned by that listener
    select accountID into listener_ID from listener where username = ip_username;
    
    if not (exists(select * from playlist where playlistID = ip_playlistID and listenerID = listener_ID)) then
    leave sp_main;
    end if;
    
    -- check if content id exists in song
    if not (exists(select * from song where contentID = ip_contentID)) then
    leave sp_main;
    end if;
    
    -- check if song is already in playlist
    if (exists(select * from makes_up where songID = ip_contentID and playlistID = ip_playlistID)) then
    leave sp_main;
    end if;
    
    -- insert into (note: fix track order)
    insert into makes_up(songID, playlistID, track_order) values (ip_contentID, ip_playlistID, 1);
    
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
	-- variable declaration
    declare user_name varchar(100);
    declare playlist_ID varchar(20);
    declare listener_ID varchar(20);
    declare first_song varchar(20);
    
    -- check if inputs are non-null
    if ip_username is null or ip_playlistID is null then
	leave sp_main;
	end if;
    
    -- check if listener exists
    select username into user_name from listener where username = ip_username;
    if user_name is null then
    leave sp_main;
    end if;
    
    -- check if playlist exists
    select playlistID into playlist_ID from playlist where playlistID = ip_playlistID;
    if playlist_ID is null then
    leave sp_main;
    end if;
    
    -- check if playlist belongs to the listener
    select accountID into listener_ID from listener where username = ip_username;
    select playlistID into playlist_ID from playlist where listener_ID = listenerID and playlistID = ip_playlistID;
    if playlist_ID is null then
    leave sp_main;
    end if;
    
    -- check if playlist has songs
    select m.songID into first_song from makes_up m join content c on m.songID = c.contentID
    where m.playlistID = ip_playlistID
    order by c.title asc limit 1;
    if first_song is null then
    leave sp_main;
    end if;
    
    -- call stream_content to start streaming
    call stream_content(listener_ID, first_song); 
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
    -- check input is non-null
    if ip_accountID is null or ip_fullname is null or ip_birthdate is null or ip_email is null then
    leave sp_main;
    end if;
    
    -- check accountID is unique
    if ((select count(accountID) from user where accountID = ip_accountID) > 1) then 
    leave sp_main;
    end if;
    
    -- check if user is a MINOR
    if (timestampdiff(year, birthdate, currdate()) < 13) then
    leave sp_main;
    end if;
    
    -- If the user is a listener, ensure that the username is non-null, and if streams is non-null, it references an
    -- existing content and that time stamp is set to 0.
    
    if (exists(select * from listener where accountID = ip_accountID)) then
		if ip_username is null then
        leave sp_main;
        end if;
	end if;
        
        if (select streams from listener where accountID = ip_accountID) is not null then
			if not (exists(select * from content where currentlyStreaming = contentID)) then
            leave sp_main;
            end if;
			
			if (select timestamp from listener where currentlyStreaming = streams) != 0 then
            leave sp_main;
            end if;
		end if;
	
    insert into user (accountID, name, bdate, email) values (ip_accountID, ip_name, ip_bdate, ip_email);
    
    
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
drop procedure if exists upload_song; -- failed in autograder
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
	declare album_by_creator_exists varchar(100);
	declare song_count int default 0;
    declare creator_stage_name varchar(100);
	-- check for null
	if (ip_contentID is null or ip_contentLength is null or ip_title is null or ip_maturity is null or
		ip_contentLanguage is null or ip_releaseDate is null or ip_creatorID is null) then 
		select 'At least one of the inputs are null.';
        leave sp_main;
	-- check if the song is unique (doesn't exist in the songs table)
	elseif exists(select contentID from song where contentID = ip_contentID) then
		select concat('A song with ID ', ip_contentID, ' already exists.');
        leave sp_main;
	-- check if the creatorID exists in the creator table
	elseif not exists(select accountID from creator where accountID = ip_creatorID) then
		select concat('The creator ', ip_creatorID, ' does not exist.');
        leave sp_main;
	-- check if the content length is between 60 and 600 seconds
	elseif (ip_contentLength < 60 or ip_contentLength > 600) then
		select concat('The length of the song is not within 60 - 600 seconds.');
        leave sp_main;
	else
		-- extra case: album exists, check specific criteria and add song to album
		if ip_albumName is not null then
			-- check if the album is owned by the creator
            select album_name into album_by_creator_exists from album where (creatorID = ip_creatorID and album_name = ip_albumName);
			if album_by_creator_exists is null then
				select concat('The album ', ip_albumName, ' does not exist or is not created by ', ip_creatorID, '.');
				leave sp_main;
			end if;
            -- check if the album has fewer than 16 songs
            select count(*) into song_count from song where album_name = ip_albumName;
			if song_count >= 16 then
				select concat('The album ', ip_albumName, ' cannot have more than 16 songs.');
				leave sp_main;
			end if;
		end if;
        -- update a creator's stage name if it doesn't exist 
        select stage_name into creator_stage_name from creator where accountID = ip_creatorID;
        if (creator_stage_name is null) then
			update creator set stage_name = (select name from user where accountID = ip_creatorID) where accountID = ip_creatorID;
        end if;
		-- create song (place into content table)
        insert into content(contentID, title, content_length, maturity, content_language, release_date) values 
        (ip_contentID, ip_title, ip_contentLength, ip_maturity, ip_contentLanguage, ip_releaseDate);
        -- create song (place into song table)
        insert into song(contentID, creatorID, album_name) values
        (ip_contentID, ip_creatorID, ip_albumName);
        -- create song (place into creates table)
        insert into creates(contentID, creatorID) values
        (ip_contentID, ip_creatorID);
	end if;
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
drop procedure if exists delete_playlist_songs; -- failed in autograder
delimiter //
create procedure delete_playlist_songs (
    in ip_playlistID varchar(20),
    in ip_char_phrase varchar(20)
)
sp_main: begin
	-- variable declaration
	declare playlist_exists int;
    declare song_count int default 0;
    
    -- check if inputs are non-null
    if ip_playlistID is null or ip_char_phrase is null then
    leave sp_main;
    end if;
	
    -- check if playlist exists
    select count(*) into playlist_exists from playlist where playlistID = ip_playlistID;
    if playlist_exists = 0 then
    leave sp_main;
    end if;
    
    -- check if playlist contains 0 songs that matches char/phrase
    select count(*) into song_count from makes_up m join content c on m.songID = c.contentID
    where m.playlistID = ip_playlistID and c.title like concat('%', ip_char_phrase, '%');
    if song_count = 0 then
    leave sp_main;
    end if;
    
    -- delete songs that contain the input char/phrase from the playlist
    delete m from makes_up m where playlistID = ip_playlistID and songID in (select contentID from content
    where title like concat('%', ip_char_phrase, '%'));
    
    -- rearrange the track orders
    call resequence_track_order(ip_playlistID);
    
    -- delete entire playlist if playlist has no songs left
    if not exists (select 1 from makes_up where playlistID = ip_playlistID) then
    delete from playlist where playlistID = ip_playlistID;
    end if;

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

-- common_songs_view: displays songs in makes_up table shared by at least two playlists.
create or replace view common_songs_view as 
select m1.songID as shared_songID, m1.playlistID as playlistID1, m2.playlistID as playlistID2 from makes_up as m1 join makes_up as m2 on m1.songID = m2.songID;

drop procedure if exists merge_playlists;
delimiter //
create procedure merge_playlists (
    in ip_playlistID1 varchar(20), -- first playlist
    in ip_playlistID2 varchar(20) -- second playlist
)
sp_main: begin
	-- current_songID: local variable that stores the ID of the current song needing to be deleted from or added to a playlist.
	declare current_songID varchar(20);
    -- current_track_order: local variable that stores the current track order of the next song needing to be added. 
    declare current_track_order int;
	-- check for null
	if (ip_playlistID1 is null or ip_playlistID2 is null) then 
		select 'At least one of the playlistIDs are null.';
        leave sp_main;
    -- check if the playlists exist
	elseif ((select count(*) from playlist where (playlistID = ip_playlistID1 or playlistID = ip_playlistID2)) <> 2) then 
		select 'At least one of the playlistIDs do not exist.';
        leave sp_main;
	-- check if the playlists are not the same
	elseif (ip_playlistID1 = ip_playlistID2) then 
		select 'Both playlists inputted are the same.';
        leave sp_main;
	-- check if the playlists are owned by the same listener
	elseif not exists(select * from playlist as p1 join playlist as p2 on p1.listenerID = p2.listenerID where (p1.playlistID = 'P1111' and p2.playlistID = 'P2222')) then 
		select 'The playlists are not owned by the same listener.';
        leave sp_main;
	else 
		-- delete all duplicate songs from second playlist
		while (exists(select * from common_songs_view where playlistID1 = ip_playlistID1 and playlistID2 = ip_playlistID2)) do
			-- select first shared song between the two playlists
			select shared_songID into current_songID from common_songs_view where playlistID1 = ip_playlistID1 and playlistID2 = ip_playlistID2 limit 1;
            -- remove song from second playlist
            delete from makes_up where songID = current_songID and playlistID = ip_playlistID2;
        end while;
        -- grab current track order maximum from the first playlist and offset by one for the second playlist's songs
        select max(track_order) + 1 into current_track_order from makes_up where playlistID = ip_playlistID1;
        -- add all remaining songs from second playlist to first playlist
		while (exists(select * from makes_up where playlistID = ip_playlistID2)) do
			-- select first song from the second playlist
			select songID into current_songID from makes_up where playlistID = ip_playlistID2 limit 1;
            insert into makes_up (songID, playlistID, track_order) values 
            (current_songID, ip_playlistID1, current_track_order);
            set current_track_order = current_track_order + 1; -- update track order
            -- remove song from second playlist
            -- removing the song here allows for the second playlist to be deleted without any dependencies
            delete from makes_up where songID = current_songID and playlistID = ip_playlistID2;
        end while;
        -- resequence track orders
        call resequence_track_order(ip_playlistID1);
        -- delete second playlist
        delete from playlist where playlistID = ip_playlistID2;
	end if;
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
    -- check if accountID is null
    
    if ip_accountID is null then
    leave sp_main;
    end if;
    
    -- check if account is a listener
    
    if not (exists(select * from listener where accountID = ip_accountID)) then
    leave sp_main;
    end if;
    
    -- check if listener is streaming content
    if not (exists(select * from listener where streams is not null AND accountID = ip_accountID)) then
    leave sp_main;
    end if;
    
    update listener set streams = null, timestamp = null where accountID = ip_accountID;
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
	-- variable declaration
    declare content_ID varchar(20);
    declare creator_ID varchar(20);
    declare counter int;
    
    -- check if both inputs are non-null
    if ip_contentID is null or ip_creatorID is null then 
    leave sp_main;
    end if;
    
    -- check if creator exists
    select accountID into creator_ID from creator where accountID = ip_creatorID;
    if creator_ID is null then
    leave sp_main;
    end if;
    
    -- check if content exists
    select contentID into content_ID from content where contentID = ip_contentID;
    if content_ID is null then
    leave sp_main;
    end if;
    
    -- check if the feature is already recorded
    if exists (select 1 from creates where contentID = ip_contentID and creatorID = ip_creatorID) then
    leave sp_main;
    end if;
    
    -- check if content has no more than 5 creators associated with it
    select count(*) into counter from creates where contentID = ip_contentID;
    if counter >= 5 then
    leave sp_main;
    end if;
    
    -- insert
    insert into creates (creatorID, contentID) values (ip_creatorID, ip_contentID);
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
drop procedure if exists delete_episodes; -- failed in autograder
delimiter //
create procedure delete_episodes (
	in ip_podcastID varchar(20),
    in ip_num_episodes int
)
sp_main: begin
	declare num_episodes int default 0;
    declare num_deleted_episodes int default 0;
    declare curr_episodeID varchar(20);
    -- check for null
	if (ip_podcastID is null or ip_num_episodes is null or ip_num_episodes < 0) then 
		select 'At least one of the inputs is null or invalid.';
        leave sp_main;
        end if;
	-- check if the podcast exists
	if not (exists(select podcastID from podcast_series where podcastID = ip_podcastID)) then
		select concat('The podcast ', ip_podcastID, ' does not exist.');
        leave sp_main;
	end if;
    -- get total number of podcast episodes in the series
    select count(*) into num_episodes from podcast_episode where podcastID = ip_podcastID;
    -- if the requested amount to delete exceeds the total number of podcast episodes, don't delete
    if (num_episodes < ip_num_episodes) then
		select concat('The number of episodes requested to delete, ', ip_num_episodes, ', is greater than the total number of episodes.');
        leave sp_main;
    end if;
    -- delete the number of podcast episodes requested
    while num_deleted_episodes < ip_num_episodes do
		-- find the podcast episode to delete
		select contentID into curr_episodeID from podcast_episode where podcastID = ip_podcastID order by episode_number desc limit 1;
        -- delete the podcast episode
        delete from podcast_episode where contentID = curr_episodeID;
        -- increment number of deleted podcast episodes
        set num_deleted_episodes = num_deleted_episodes + 1;
    end while;
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
	declare first_alphabetically varchar(20);
    declare min_handle_platform varchar(20);
    
    -- check valid creator
    if not (exists(select * from creator where accountID = ip_creatorID)) then
    leave sp_main;
    end if;
    
    -- check if creator has made a podcast
    if (exists(select * from creates where creatorID = ip_creatorID and contentID in (select contentID from podcast_episode))) then
		delete from socials where platform != 'TikTok' and creatorID = ip_creatorID;
	end if;

	-- check if creator has made at least 2 albums
    if (select count(*) from album where creatorID = ip_creatorID) >= 2 then
		delete from socials where platform != 'SoundCloud' and creatorID = ip_creatorID;
    end if;
    
    -- check if creator is born after jan 1 2000
    if (exists(select * from user where accountID = ip_creatorID and bdate > '2000-01-01')) then
		delete from socials where platform != 'Snapchat' and creatorID = ip_creatorID;
	end if;
    
    -- delete all except alphabetically first
    
    select min(handle) into first_alphabetically from socials where (creatorID = ip_creatorID);
    select platform into min_handle_platform from socials where (creatorID = ip_creatorID) and (handle = first_alphabetically);
    delete from socials where creatorID = ip_creatorID and handle != first_alphabetically;
    
    if not (exists(select * from socials)) then
    insert into socials (creatorID, platform, handle) values (ip_creatorID, min_handle_platform, first_alphabetically);
	end if;
end //
delimiter ;