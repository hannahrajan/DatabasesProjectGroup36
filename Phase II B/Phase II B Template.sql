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
    insert into user (accountID, name, bdate, email) values
	('JS9083', 'Joe Smith', '1990-12-01', 'joesmith90@mail.com'),
	('SM6701', 'Sarah Moore', '1992-06-22', 'sarahmoore@mail.com'),
	('MD5481', 'Maya Delgado', '1995-03-22', 'maya.delgado@mail.com'),
	('AB8247', 'Andre Bennett', '1992-07-11', 'andrebennett@music.io'),
	('LK7653', 'Lisa Keller', '1998-01-30', 'lenakhan@mail.com'),
	('KI4328', 'Kevin Ingram', '1989-03-14', 'kevin.ingram@mail.com'),
	('PN7413', 'Priya Nair', '1996-12-17', 'priya.nair@mail.com'),
	('DM1120', 'Daniel Moore', '2000-05-09', 'dan.moore@mail.com'),
	('MC9055', 'Malik Carter', '1991-10-19', 'malik.carter@studio.fm'),
	('CM7782', 'Chloe Moore', '2009-09-21', 'chloe.moore@mail.com'),
	('JM5520', 'Jonah Marks', '1994-11-02', 'jonah.marks@mail.com'),
	('TS4389', 'Theo Schmidt', '1993-02-14', 'tchmidt@mindcast.app'),
	('AH1050', 'Adam Hart', '1990-07-29', 'ahart@mail.com');

	insert into content (contentID, title, content_length, maturity, content_language, release_date) values
	('SKYBLUE', 'Sky So Blue', 95, 'Not Explicit', 'English', '2023-09-12'),
	('SHIPPING', 'Shipping Without Maps', 3551, 'Not Explicit', 'English', '2023-04-22'),
	('ECHOES', 'City of Echoes', 131, 'Not Explicit', 'English', '2024-05-04'),
	('ORBIT', 'Midnight Orbit', 688, 'Explicit', 'German', '2024-01-15'),
	('BURNOUT', 'Burnout Reset', 1914, 'Not Explicit', 'English', '2024-02-11'),
	('SUNSET', 'Sunset Grove', 782, 'Not Explicit', 'English', '2023-11-03'),
	('PAPER', 'Paper Skies', 178, 'Not Explicit', 'English', '2022-07-18'),
	('POLAROID', 'Polaroid Walls', 185, 'Not Explicit', 'English', '2024-03-22'),
	('METRICS', 'Metrics That Matter', 3262, 'Not Explicit', 'French', '2023-05-20'),
	('MEADOW', 'Meadow Night', 144, 'Explicit', 'English', '2023-09-12'),
	('BOUNDARY', 'Boundaries 101', 2741, 'Not Explicit', 'English', '2024-01-14'),
	('VELVET', 'Velvet Raag', 201, 'Not Explicit', 'English', '2024-05-04'),
	('CHECKOUT', 'Late Checkout', 182, 'Explicit', 'English', '2022-07-18'),
	('SCALE', 'Scaling Chaos', 2212, 'Not Explicit', 'English', '2024-09-15'),
	('MIDNIGHT', 'Midnight Pool', 156, 'Not Explicit', 'English', '2023-03-10'),
	('TIDES', 'Neon Tides', 168, 'Explicit', 'Spanish', '2023-03-10'),
	('RESILIENCE', 'Everyday Resilience', 2535, 'Not Explicit', 'English', '2024-06-02'),
	('BRASS', 'Brass Wires', 179	, 'Not Explicit', 'English', '2024-03-22'),
	('LOVE', 'Friendly Talks Ep 1: Love', 1800, 'Not Explicit', 'English', '2025-02-15');

	insert into creator (accountID, stage_name, biography, pinned) values
	('JS9083', 'Young Sean', 'I write songs for the greatest moments in life.', 'SKYBLUE'), ('MD5481', 'Delga', 'LA-based indie-pop singer blending bilingual hooks with lo-fi beats', 'PAPER'),
	('AB8247', 'Dre Ben', 'Toronto producer-rapper crafting jazzy boom-bap with modern soul', 'POLAROID'),
	('PN7413', 'Priyaaa', NULL, NULL),
	('MC9055', NULL, 'Former startup PM interviewing operators about the messy middle of building products', NULL),
	('TS4389', NULL, 'Therapist hosting conversations on mental health, community, and science-backed practices', NULL),     
	('AH1050', NULL, 'Trying to get into the music scene!', NULL);    

	insert into album (creatorID, album_name) values
	('JS9083', 'Starlight Meadows'),
	('MD5481', 'Sunflower Motel'),
	('MD5481', 'Night Swim'),
	('AB8247', 'Copper Lines'),
	('PN7413', 'Velvet Hour');

	insert into song (contentID, creatorID, album_name) values
	('SKYBLUE', 'JS9083', 'Starlight Meadows'),
	('ECHOES', NULL, NULL),
	('ORBIT', NULL, NULL),
	('SUNSET', NULL, NULL),
	('PAPER', 'MD5481', 'Sunflower Motel'),
	('POLAROID', 'AB8247', 'Copper Lines'),
	('MEADOW', 'JS9083', 'Starlight Meadows'),
	('VELVET', 'PN7413', 'Velvet Hour'),
	('CHECKOUT', 'MD5481', 'Sunflower Motel'),
	('MIDNIGHT', 'MD5481', 'Night Swim'), 
	('TIDES', 'MD5481', 'Night Swim'), 
	('BRASS', 'AB8247', 'Copper Lines');
	  
	insert into subscription (subscriptionID, cost, start_date, end_date, tier, max_family_size, subscription_type) values
	('S4738', 360.00, '2025-02-01', '2025-12-31', NULL, 5, 'Family'),
	('S1234', 119.99,  '2025-02-01', '2025-12-31', NULL, 3, 'Family'),
	('S2345', 205.55, '2024-05-13', '2025-04-30', 'Premium', NULL, 'Individual'),
	('S9876', 299.99, '2024-08-20', '2025-08-19', 'Deluxe', NULL, 'Individual'),
	('S5566', 111.45, '2025-03-10', '2026-05-01', 'Premium', NULL, 'Individual');

	insert into listener (accountID, username, streams, timestamp, subscription) values 
	('JS9083', 'superFanJS20', 'SKYBLUE', 64, 'S4738'),
	('SM6701', 'ssarah', 'ECHOES', 19, 'S1234'),
	('LK7653', 'lklikessongs', 'POLAROID', 142, 'S2345'),
	('KI4328', 'kevbeats', 'SHIPPING', 231, 'S9876'),
	('DM1120', 'dmoore2000', 'SKYBLUE', 33, 'S1234'),
	('CM7782', 'chloemoore', 'POLAROID', 41, 'S1234'),
	('JM5520', 'markstunes', NULL, NULL, 'S5566'),
	('TS4389', 'theos23',	'POLAROID', 178, NULL),	
	('AH1050', 'awesomeadam', 'TIDES', 89, NULL);

	insert into playlist (playlistID, name, listenerID) values
	('P2310', 'Car Songs', 'JS9083'),
	('P1111', 'Car Songs', 'SM6701'),
	('P2222', 'Workout Songs', 'SM6701'),
	('P3333', 'Inspiration', 'LK7653'),
	('P2345', 'Favorites', 'KI4328'), 
	('P7890', 'Road Trip', 'DM1120'),
	('P2323', 'Weekend Mix', 'JM5520');

	insert into podcast_series (podcastID, title, description) values
	('POD1111', 'Build Mode S1', 'Build Mode is an operator-driven conversation about building products—tactics, experiments, metrics, and shipping at speed.'),
	('POD2222', 'Mindcast S1', 'Mindcast is a therapy-informed podcast on mental health, blending evidence-based tools with community care and real stories.'),
	('POD1112', 'Build Mode S2', 'Build Mode is an operator-driven conversation about building products—tactics, experiments, metrics, and shipping at speed.'),
	('POD2323', 'Mindcast S2', 'Mindcast is a therapy-informed podcast on mental health, blending evidence-based tools with community care and real stories.'),
	('POD4895', 'Friendly Talks', 'Friendly Talks is a cozy, curiosity-driven show where thoughtful people unpack everyday topics.');

	insert into podcast_episode (contentID, podcastID, topic, episode_number) values
	('SHIPPING', 'POD1111', 'Efficiency', 1),
	('BURNOUT', 'POD2222', 'Burnout', 2),
	('METRICS', 'POD1111', 'Metrics', 2),
	('BOUNDARY', 'POD2222', 'Boundaries', 1),
	('SCALE', 'POD1112', 'Scaling', 1),
	('RESILIENCE', 'POD2323', 'Resilience', 1),
	('LOVE', 'POD4895', 'Love', 1);

	insert into makes_up (songID, playlistID, track_order) values 
	('SKYBLUE', 'P1111', 2),
	('SKYBLUE', 'P2310', 2), 
	('ECHOES', 'P1111', 4), 
	('ECHOES', 'P2222', 2), 
	('ECHOES', 'P3333', 1), 
	('ECHOES', 'P7890', 1), 
	('POLAROID', 'P3333', 3), 
	('POLAROID',	'P2345', 3), 
	('POLAROID', 'P1111', 5), 
	('MEADOW', 'P1111', 3), 
	('MEADOW', 'P2222', 1), 
	('MEADOW', 'P7890',	 2), 
	('VELVET', 'P2345', 1), 
	('VELVET', 'P1111', 1), 
	('VELVET', 'P2323', 1), 
	('MIDNIGHT', 'P2345', 2), 
	('MIDNIGHT', 'P1111', 6), 
	('TIDES', 'P2310', 1), 
	('TIDES', 'P2345', 5), 
	('BRASS', 'P3333', 2), 
	('BRASS', 'P2345', 4);

	insert into creates (contentID, creatorID) values 
	('SKYBLUE', 'JS9083'), 
	('SHIPPING', 'MC9055'), 
	('ECHOES', 'PN7413'), 
	('ORBIT', 'JS9083'), 
	('ORBIT', 'MD5481'), 
	('BURNOUT', 'TS4389'), 
	('SUNSET', 'MD5481'), 
	('SUNSET', 'AB8247'), 
	('PAPER', 'MD5481'), 
	('POLAROID', 'AB8247'), 
	('METRICS', 'MC9055'), 
	('MEADOW', 'JS9083'), 
	('BOUNDARY', 'TS4389'), 
	('VELVET', 'PN7413'), 
	('CHECKOUT', 'MD5481'), 
	('SCALE', 'MC9055'), 
	('MIDNIGHT', 'MD5481'), 
	('TIDES', 'MD5481'), 
	('RESILIENCE', 'TS4389'), 
	('BRASS', 'AB8247'), 
	('LOVE', 'JS9083');

	insert into friends (friender, friendee) values
    ('SM6701', 'LK7653'), 
	('SM6701', 'KI4328'),
	('KI4328', 'LK7653'),
	('DM1120', 'SM6701'), 
	('DM1120', 'CM7782'),
	('CM7782', 'SM6701'),
	('JM5520', 'KI4328'),
	('JS9083', 'LK7653');

	insert into socials (creatorID, platform, handle) values 
	('JS9083', 'Instagram', 'ysean'), 
	('JS9083', 'Snapchat', 'youngsean'), 
	('JS9083', 'TikTok', 'iamsean'), 
	('MD5481', 'Instagram', 'delga'), 
	('MD5481', 'TikTok', 'delgatofficial'), 
	('MD5481', 'Youtube', 'delgaTV'), 
	('AB8247', 'Instagram', 'dreben'), 
	('AB8247', 'Twitter', 'dreben_x'), 
	('AB8247', 'SoundCloud', 'drebenbeats'), 
	('PN7413', 'Instagram', 'priyan'), 
	('PN7413', 'Twitter', 'priyan_x'), 
	('PN7413', 'Twitch', 'priyanstudio'), 
	('MC9055', 'Twitter', 'buildmodepod'), 
	('MC9055', 'LinkedIn', 'malikcarter'), 
	('MC9055', 'TikTok', 'buildmode_tok'), 
	('TS4389', 'Instagram', 'mindcast'), 
	('TS4389', 'TikTok', 'mindcastpod'), 
	('TS4389', 'Twitch', 'theolive'), 
	('AH1050', 'Instagram', 'ahartofgold');

	insert into genres (songID, genre) values 
	('SKYBLUE', 'Pop'),
    ('SKYBLUE', 'Rock'),
	('ECHOES', 'Alternative R&B'),
	('ECHOES', 'Ambient'),
	('ECHOES', 'Chillout'),
	('PAPER', 'Indie Pop'),
	('POLAROID', 'Alternative'),
	('POLAROID', 'Dream Pop'), 
	('MEADOW', 'Hip-Hop'),
	('MEADOW', 'Alternative Rap'), 
	('VELVET', 'Alternative R&B'), 
	('CHECKOUT', 'Indie Pop'), 
	('MIDNIGHT', 'Indie Pop'),
	('TIDES', 'Indie Pop'), 
	('BRASS', 'Hip-Hop');

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
the total number of listeners currently streaming any of that creator's songs,
and a list of the creator's song titles in descending order of current streams, separated by a comma and a space.
HINT: the GROUP_CONCAT function can be useful here. */
-- -----------------------------------------------------------------------------
create or replace view creator_songs_view as
select stage_name 
from creator
where stage_name <> NULL;

select * from creator_songs_view;

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




