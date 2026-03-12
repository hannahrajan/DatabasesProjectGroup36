-- CS4400: Introduction to Database Systems
-- Media Streaming Service Phase III Basic Autograder

set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set session SQL_MODE = 'ANSI,TRADITIONAL';
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
	('SHADOW', 'One Shadow', 233, 'Not Explicit', 'English', '2024-06-01'),
	('CHECKOUT', 'Late Checkout', 182, 'Explicit', 'English', '2022-07-18'),
	('SCALE', 'Scaling Chaos', 2212, 'Not Explicit', 'English', '2024-09-15'),
	('MIDNIGHT', 'Midnight Pool', 156, 'Not Explicit', 'English', '2023-03-10'),
	('TIDES', 'Neon Tides', 168, 'Explicit', 'Spanish', '2023-03-10'),
	('RESILIENCE', 'Everyday Resilience', 2535, 'Not Explicit', 'English', '2024-06-02'),
	('BRASS', 'Brass Wires', 179, 'Not Explicit', 'English', '2024-03-22'),
	('LOVE', 'Friendly Talks Ep 1: Love', 1800, 'Not Explicit', 'English', '2025-02-15');

	insert into creator (accountID, stage_name, biography, pinned) values
	('JS9083', 'Young Sean', 'I write songs for the greatest moments in life.', 'SKYBLUE'),
	('MD5481', 'Delga', 'LA-based indie-pop singer blending bilingual hooks with lo-fi beats', 'PAPER'),
	('AB8247', 'Dre Ben', 'Toronto producer-rapper crafting jazzy boom-bap with modern soul', 'POLAROID'),
	('PN7413', 'Priyaaa', null, null),
	('MC9055', null, 'Former startup PM interviewing operators about the messy middle of building products', null),
	('TS4389', null, 'Therapist hosting conversations on mental health, community, and science-backed practices', null),
	('AH1050', null, 'Trying to get into the music scene!', null);

	insert into album (creatorID, album_name) values
	('JS9083', 'Starlight Meadows'),
	('MD5481', 'Sunflower Motel'),
	('MD5481', 'Night Swim'),
	('AB8247', 'Copper Lines'),
	('PN7413', 'Velvet Hour');

	insert into song (contentID, creatorID, album_name) values
	('SKYBLUE', 'JS9083', 'Starlight Meadows'),
	('ECHOES', null, null),
	('PAPER', 'MD5481', 'Sunflower Motel'),
	('POLAROID', 'AB8247', 'Copper Lines'),
	('MEADOW', 'JS9083', 'Starlight Meadows'),
	('VELVET', 'PN7413', 'Velvet Hour'),
	('SHADOW', 'PN7413', 'Velvet Hour'),
	('CHECKOUT', 'MD5481', 'Sunflower Motel'),
	('MIDNIGHT', 'MD5481', 'Night Swim'),
	('TIDES', 'MD5481', 'Night Swim'),
	('BRASS', 'AB8247', 'Copper Lines');

	insert into subscription (subscriptionID, cost, start_date, end_date, tier, 
		max_family_size, subscription_type) values
	('S1234', 119.99, '2025-02-01', '2025-12-31', null, 3, 'Family'),
	('S2345', 205.55, '2024-05-13', '2025-04-30', 'Premium', null, 'Individual'),
	('S9876', 299.99, '2024-08-20', '2025-08-19', 'Deluxe', null, 'Individual'),
	('S5566', 111.45, '2025-03-10', '2026-05-01', 'Premium', null, 'Individual'),
	('S4738', 360.00, '2025-02-01', '2025-12-31', null, 5, 'Family');

	insert into listener (accountID, username, streams, timestamp, subscription) values
	('SM6701', 'ssarah', 'ECHOES', 19, 'S1234'),
	('LK7653', 'lklikessongs', 'POLAROID', 142, 'S2345'),
	('KI4328', 'kevbeats', 'SHIPPING', 231, 'S9876'),
	('DM1120', 'dmoore2000', 'SKYBLUE', 33, 'S1234'),
	('CM7782', 'chloemoore', 'POLAROID', 41, 'S1234'),
	('JM5520', 'markstunes', null, null, 'S5566'),
	('JS9083', 'superFanJS20', 'SKYBLUE', 64, 'S4738'),
	('TS4389', 'theos23', 'POLAROID', 178, 'S4738'),
	('AH1050', 'awesomeadam', 'TIDES', 89, null);

	insert into playlist (playlistID, name, listenerID) values
	('P1111', 'Car Songs', 'SM6701'),
	('P2222', 'Workout Songs', 'SM6701'),
	('P3333', 'Inspiration', 'LK7653'),
	('P2345', 'Favorites', 'KI4328'),
	('P7890', 'Road Trip', 'DM1120'),
	('P2323', 'Weekend Mix', 'JM5520'),
	('P2310', 'Car Songs', 'JS9083');

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
	('ECHOES', 'P1111', 4), ('ECHOES', 'P2222', 2), ('ECHOES', 'P7890', 1), ('ECHOES', 'P3333', 1),
	('POLAROID', 'P3333', 3), ('POLAROID', 'P2345', 3), ('POLAROID', 'P1111', 5),
	('MEADOW', 'P1111', 3), ('MEADOW', 'P2222', 1), ('MEADOW', 'P7890', 2),
	('VELVET', 'P2345', 1), ('VELVET', 'P1111', 1), ('VELVET', 'P2323', 1),
	('MIDNIGHT', 'P2345', 2), ('MIDNIGHT', 'P1111', 6),
	('TIDES', 'P2310', 1), ('TIDES', 'P2345', 5),
	('BRASS', 'P3333', 2), ('BRASS', 'P2345', 4),
	('SKYBLUE', 'P2310', 2);

	insert into creates (contentID, creatorID) values
	('SKYBLUE', 'JS9083'),
	('ECHOES', 'PN7413'),
	('LOVE', 'JS9083'),
	('ORBIT', 'JS9083'), 
	('ORBIT', 'MD5481'),
	('SUNSET', 'MD5481'), 
	('SUNSET', 'AB8247'),
	('PAPER', 'MD5481'),
	('POLAROID', 'AB8247'),
	('MEADOW', 'JS9083'),
	('VELVET', 'PN7413'),
	('CHECKOUT', 'MD5481'),
	('MIDNIGHT', 'MD5481'),
	('SHADOW', 'PN7413'),
	('TIDES', 'MD5481'),
	('BRASS', 'AB8247'),
	('SHIPPING', 'MC9055'),
	('METRICS', 'MC9055'),
	('SCALE', 'MC9055'),
	('BURNOUT', 'TS4389'),
	('BOUNDARY', 'TS4389'),
	('RESILIENCE', 'TS4389');

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
	('JS9083', 'Instagram', 'ysean'), ('JS9083', 'Snapchat', 'youngsean'), ('JS9083', 'TikTok', 'iamsean'),
	('MD5481', 'Instagram', 'delga'), ('MD5481', 'TikTok', 'delgatofficial'), ('MD5481', 'Youtube', 'delgaTV'),
	('AB8247', 'Instagram', 'dreben'), ('AB8247', 'Twitter', 'dreben_x'), ('AB8247', 'SoundCloud', 'drebenbeats'),
	('PN7413', 'Instagram', 'priyan'), ('PN7413', 'Twitter', 'priyan_x'), ('PN7413', 'Twitch', 'priyanstudio'),
	('MC9055', 'Twitter', 'buildmodepod'), ('MC9055', 'LinkedIn', 'malikcarter'), ('MC9055', 'TikTok', 'buildmode_tok'),
	('TS4389', 'Instagram', 'mindcast'), ('TS4389', 'TikTok', 'mindcastpod'), ('TS4389', 'Twitch', 'theolive'),
	('AH1050', 'Instagram', 'ahartofgold');

	insert into genres (songId, genre) values
	('SKYBLUE', 'Pop'), ('SKYBLUE', 'Rock'),
	('ECHOES', 'Alternative R&B'), ('ECHOES', 'Ambient'), ('ECHOES', 'Chillout'),
	('PAPER', 'Indie Pop'),
	('POLAROID', 'Alternative'), ('POLAROID', 'Dream Pop'),
	('MEADOW', 'Hip-Hop'), ('MEADOW', 'Alternative Rap'),
	('VELVET', 'Alternative R&B'),
	('CHECKOUT', 'Indie Pop'),
	('MIDNIGHT', 'Indie Pop'),
	('TIDES', 'Indie Pop'),
	('BRASS', 'Hip-Hop');
end //
delimiter ;

create or replace view practiceQuery10 as select * from album;
create or replace view practiceQuery11 as select * from content;
create or replace view practiceQuery12 as select * from creates;
create or replace view practiceQuery13 as select * from creator;
create or replace view practiceQuery15 as select * from friends;
create or replace view practiceQuery16 as select * from genres;
create or replace view practiceQuery17 as select * from listener;
create or replace view practiceQuery18 as select * from playlist;
create or replace view practiceQuery19 as select * from makes_up;
create or replace view practiceQuery20 as select * from podcast_episode;
create or replace view practiceQuery21 as select * from podcast_series;
create or replace view practiceQuery22 as select * from socials;
create or replace view practiceQuery23 as select * from song;
create or replace view practiceQuery24 as select * from subscription;
create or replace view practiceQuery25 as select * from user;

drop table if exists magic44_data_capture;
create table magic44_data_capture (
	stepID integer, queryID integer,
    columnDump0 varchar(1000), columnDump1 varchar(1000), columnDump2 varchar(1000), columnDump3 varchar(1000), columnDump4 varchar(1000),
    columnDump5 varchar(1000), columnDump6 varchar(1000), columnDump7 varchar(1000), columnDump8 varchar(1000), columnDump9 varchar(1000),
	columnDump10 varchar(1000), columnDump11 varchar(1000), columnDump12 varchar(1000), columnDump13 varchar(1000), columnDump14 varchar(1000)
);

drop table if exists magic44_column_listing;
create table magic44_column_listing (
	columnPosition integer,
    simpleColumnName varchar(50),
    nullColumnName varchar(50)
);

insert into magic44_column_listing (columnPosition, simpleColumnName) values
(0, 'columnDump0'), (1, 'columnDump1'), (2, 'columnDump2'), (3, 'columnDump3'), (4, 'columnDump4'),
(5, 'columnDump5'), (6, 'columnDump6'), (7, 'columnDump7'), (8, 'columnDump8'), (9, 'columnDump9'),
(10, 'columnDump10'), (11, 'columnDump11'), (12, 'columnDump12'), (13, 'columnDump13'), (14, 'columnDump14');

drop function if exists magic44_gen_simple_template;
delimiter //
create function magic44_gen_simple_template(numberOfColumns integer)
	returns varchar(1000) reads sql data
begin
	return (select group_concat(simpleColumnName separator ', ') from magic44_column_listing
	where columnPosition < numberOfColumns);
end //
delimiter ;

set @stepCounter = 0;
drop procedure if exists magic44_reset_database_state_and_increment_step_counter;
delimiter //
create procedure magic44_reset_database_state_and_increment_step_counter()
begin
	call magic44_reset_database_state();
	set @stepCounter = @stepCounter + 1;
end //
delimiter ;

drop procedure if exists magic44_reset_database_state_and_set_step_counter;
delimiter //
create procedure magic44_reset_database_state_and_set_step_counter(new_step_counter integer)
begin
	call magic44_reset_database_state();
	set @stepCounter = new_step_counter;
end //
delimiter ;

drop function if exists magic44_query_capture;
delimiter //
create function magic44_query_capture(thisQuery integer)
	returns varchar(2000) reads sql data
begin
	set @numberOfColumns = (select count(*) from information_schema.columns
		where table_schema = @thisDatabase
        and table_name = concat('practiceQuery', thisQuery));

	set @buildQuery = 'insert into magic44_data_capture (stepID, queryID, ';
    set @buildQuery = concat(@buildQuery, magic44_gen_simple_template(@numberOfColumns));
    set @buildQuery = concat(@buildQuery, ') select ');
    set @buildQuery = concat(@buildQuery, @stepCounter, ', ');
    set @buildQuery = concat(@buildQuery, thisQuery, ', practiceQuery');
    set @buildQuery = concat(@buildQuery, thisQuery, '.* from practiceQuery');
    set @buildQuery = concat(@buildQuery, thisQuery, ';');

return @buildQuery;
end //
delimiter ;

drop function if exists magic44_query_exists;
delimiter //
create function magic44_query_exists(thisQuery integer)
	returns integer deterministic
begin
	return (select exists (select * from information_schema.views
		where table_schema = @thisDatabase
        and table_name like concat('practiceQuery', thisQuery)));
end //
delimiter ;

drop table if exists magic44_log_query_errors;
create table magic44_log_query_errors (
	step_id integer,
    query_id integer,
    query_text varchar(2000),
    error_code char(5),
    error_message text
);

drop procedure if exists magic44_query_check_and_run;
delimiter //
create procedure magic44_query_check_and_run(in thisQuery integer)
begin
	declare err_code char(5) default '00000';
    declare err_msg text;

	declare continue handler for SQLEXCEPTION
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

    declare continue handler for SQLWARNING
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

	if magic44_query_exists(thisQuery) then
		set @sql_text = magic44_query_capture(thisQuery);
		prepare statement from @sql_text;
        execute statement;
        if err_code <> '00000'then
			insert into magic44_log_query_errors values (@stepCounter, thisQuery, @sql_text, err_code, err_msg);
		end if;
        deallocate prepare statement;
	end if;
end //
delimiter ;

drop table if exists magic44_test_case_directory;
create table if not exists magic44_test_case_directory (
	base_step_id integer,
	number_of_steps integer,
    query_label char(20),
    query_name varchar(100),
    scoring_weight integer
);

insert into magic44_test_case_directory (base_step_id, query_label, query_name, scoring_weight) values
(0, '[V_0]', 'initial_state_check', 0),
(20, '[U_1]', 'renew_subscription', 1),
(40, '[C_1]', 'duplicate_playlist', 1),
(60, '[C_2]', 'add_podcast_episode', 1),
(80, '[U_2]', 'stream_content', 1),
(100, '[C_3]', 'add_friend_connection', 1),
(120, '[U_3]', 'pin_content', 1),
(140, '[R_1]', 'cancel_subscription', 1),
(160, '[C_4]', 'create_playlist', 1),
(180, '[U_4]', 'add_song_to_playlist', 1),
(200, '[U_5]', 'start_playlist', 1),
(220, '[C_5]', 'create_user', 1),
(240, '[U_6]', 'upload_song', 1),
(260, '[R_2]', 'delete_playlist_songs', 1),
(280, '[C_6]', 'merge_playlists', 1),
(300, '[U_7]', 'stop_stream', 1),
(320, '[C_7]', 'add_feature', 1),
(340, '[R_3]', 'delete_episodes', 1),
(360, '[R_4]', 'remove_socials', 1);

drop table if exists magic44_scores_guide;
create table if not exists magic44_scores_guide (
    score_tag char(1),
    score_category varchar(100),
    display_order integer
);

insert into magic44_scores_guide values
('C', 'Create Transactions', 1), ('U', 'Use Case Transactions', 2),
('R', 'Remove Transactions', 3), ('V', 'Global Views/Queries', 4),
('E', 'Event Scenarios/Sequences', 5);

set @stepCounter = 0;
call magic44_query_check_and_run(10); -- album
call magic44_query_check_and_run(11); -- content
call magic44_query_check_and_run(12); -- creates
call magic44_query_check_and_run(13); -- creator
call magic44_query_check_and_run(14); -- enrolls_in
call magic44_query_check_and_run(15); -- friends
call magic44_query_check_and_run(16); -- genres
call magic44_query_check_and_run(17); -- listener
call magic44_query_check_and_run(18); -- playlist
call magic44_query_check_and_run(19); -- makes_up
call magic44_query_check_and_run(20); -- podcast_episode
call magic44_query_check_and_run(21); -- podcast_series
call magic44_query_check_and_run(22); -- socials
call magic44_query_check_and_run(23); -- song
call magic44_query_check_and_run(24); -- subscription
call magic44_query_check_and_run(25); -- user

call magic44_reset_database_state_and_set_step_counter(20);
call renew_subscription('LK7653', '2026-04-30');
call magic44_query_check_and_run(24);
call magic44_query_check_and_run(17);
call magic44_query_check_and_run(25);

call magic44_reset_database_state_and_set_step_counter(40);
call duplicate_playlist('P1111', 'P9999');
call magic44_query_check_and_run(18);
call magic44_query_check_and_run(19);

call magic44_reset_database_state_and_set_step_counter(60);
call add_podcast_episode(
    'JS9083','LOVE2',1800,'Not Explicit',
    'Friendly Talks Ep 2: Work','2026-01-01','English','Work',
    'POD4895','Friendly Talks',
    'Friendly Talks is a cozy, curiosity-driven show where thoughtful people unpack everyday topics.'
);
call magic44_query_check_and_run(11);
call magic44_query_check_and_run(12);
call magic44_query_check_and_run(20);
call magic44_query_check_and_run(21);

call magic44_reset_database_state_and_set_step_counter(80);
call stream_content('KI4328', 'ORBIT');
call magic44_query_check_and_run(17);

call magic44_reset_database_state_and_set_step_counter(100);
call add_friend_connection('JM5520', 'SM6701');
call magic44_query_check_and_run(15);

call magic44_reset_database_state_and_set_step_counter(120);
call pin_content('PN7413', 'VELVET');
call magic44_query_check_and_run(13);

call magic44_reset_database_state_and_set_step_counter(140);
call cancel_subscription('S1234');
call magic44_query_check_and_run(24);
call magic44_query_check_and_run(15);
call magic44_query_check_and_run(17);
call magic44_query_check_and_run(18);

call magic44_reset_database_state_and_set_step_counter(160);
call create_playlist('superFanJS20', 'Morning Mix', 'NEW_PL_1', 'SKYBLUE');
call magic44_query_check_and_run(18);
call magic44_query_check_and_run(19);

call magic44_reset_database_state_and_set_step_counter(180);
call add_song_to_playlist('markstunes', 'P2323', 'CHECKOUT');
call magic44_query_check_and_run(19);

call magic44_reset_database_state_and_set_step_counter(200);
call start_playlist('lklikessongs', 'P3333');
call magic44_query_check_and_run(17);

call magic44_reset_database_state_and_set_step_counter(220);
call create_user(
    'FW7890','Fiona Washington','2000-11-09',
    'fwashington@gmail.com','apples1109',
    null,null,'POLAROID','listener'
);
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(17);
call magic44_query_check_and_run(25);

call magic44_reset_database_state_and_set_step_counter(240);
call upload_song(
    'UPLOAD01',180,'Test Song 1',
    'Not Explicit','English','2025-01-01',
    'JS9083',null
);
call magic44_query_check_and_run(11);
call magic44_query_check_and_run(23);
call magic44_query_check_and_run(12);
call magic44_query_check_and_run(13);

call magic44_reset_database_state_and_set_step_counter(260);
call delete_playlist_songs('P1111', 'o');
call magic44_query_check_and_run(18);
call magic44_query_check_and_run(19);

call magic44_reset_database_state_and_set_step_counter(280);
call merge_playlists('P1111', 'P2222');
call magic44_query_check_and_run(18);
call magic44_query_check_and_run(19);

call magic44_reset_database_state_and_set_step_counter(300);
call stop_stream('SM6701');
call magic44_query_check_and_run(17);

call magic44_reset_database_state_and_set_step_counter(320);
call add_feature('BRASS', 'JS9083');
call magic44_query_check_and_run(12);

call magic44_reset_database_state_and_set_step_counter(340);
call delete_episodes('POD2222', 2);
call magic44_query_check_and_run(20);
call magic44_query_check_and_run(11);
call magic44_query_check_and_run(12);

call magic44_reset_database_state_and_set_step_counter(360);
insert into album values ('AB8247', 'Album 2');
call remove_socials('AB8247');
call magic44_query_check_and_run(22);

call magic44_reset_database_state();

drop table if exists magic44_step_counts_temp;
create table magic44_step_counts_temp as
select d1.base_step_id, count(distinct stepID) as num_steps
from magic44_test_case_directory as d1
left join magic44_data_capture
    on stepID >= d1.base_step_id
    and stepID < ifnull(
        (select min(d2.base_step_id) 
         from magic44_test_case_directory as d2 
         where d2.base_step_id > d1.base_step_id),
        d1.base_step_id + 20
    )
group by d1.base_step_id;

update magic44_test_case_directory as d
join magic44_step_counts_temp as t
    on d.base_step_id = t.base_step_id
set d.number_of_steps = t.num_steps;

drop table if exists magic44_step_counts_temp;

drop table if exists magic44_test_results;
create table magic44_test_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

insert into magic44_test_results
select stepID, queryID, concat_ws('#', ifnull(columndump0, ''), ifnull(columndump1, ''), ifnull(columndump2, ''), ifnull(columndump3, ''),
ifnull(columndump4, ''), ifnull(columndump5, ''), ifnull(columndump6, ''), ifnull(columndump7, ''), ifnull(columndump8, ''), ifnull(columndump9, ''),
ifnull(columndump10, ''), ifnull(columndump11, ''), ifnull(columndump12, ''), ifnull(columndump13, ''), ifnull(columndump14, ''))
from magic44_data_capture;

drop table if exists magic44_expected_results;
create table magic44_expected_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null,
    index (step_id),
    index (query_id)
);

insert into magic44_expected_results values
(0, 10, 'ab8247#copperlines#############'),
(0, 10, 'js9083#starlightmeadows#############'),
(0, 10, 'md5481#nightswim#############'),
(0, 10, 'md5481#sunflowermotel#############'),
(0, 10, 'pn7413#velvethour#############'),
(0, 11, 'boundary#boundaries101#2741#notexplicit#english#2024-01-14#########'),
(0, 11, 'brass#brasswires#179#notexplicit#english#2024-03-22#########'),
(0, 11, 'burnout#burnoutreset#1914#notexplicit#english#2024-02-11#########'),
(0, 11, 'checkout#latecheckout#182#explicit#english#2022-07-18#########'),
(0, 11, 'echoes#cityofechoes#131#notexplicit#english#2024-05-04#########'),
(0, 11, 'love#friendlytalksep1:love#1800#notexplicit#english#2025-02-15#########'),
(0, 11, 'meadow#meadownight#144#explicit#english#2023-09-12#########'),
(0, 11, 'metrics#metricsthatmatter#3262#notexplicit#french#2023-05-20#########'),
(0, 11, 'midnight#midnightpool#156#notexplicit#english#2023-03-10#########'),
(0, 11, 'orbit#midnightorbit#688#explicit#german#2024-01-15#########'),
(0, 11, 'paper#paperskies#178#notexplicit#english#2022-07-18#########'),
(0, 11, 'polaroid#polaroidwalls#185#notexplicit#english#2024-03-22#########'),
(0, 11, 'resilience#everydayresilience#2535#notexplicit#english#2024-06-02#########'),
(0, 11, 'scale#scalingchaos#2212#notexplicit#english#2024-09-15#########'),
(0, 11, 'shadow#oneshadow#233#notexplicit#english#2024-06-01#########'),
(0, 11, 'shipping#shippingwithoutmaps#3551#notexplicit#english#2023-04-22#########'),
(0, 11, 'skyblue#skysoblue#95#notexplicit#english#2023-09-12#########'),
(0, 11, 'sunset#sunsetgrove#782#notexplicit#english#2023-11-03#########'),
(0, 11, 'tides#neontides#168#explicit#spanish#2023-03-10#########'),
(0, 11, 'velvet#velvetraag#201#notexplicit#english#2024-05-04#########'),
(0, 12, 'brass#ab8247#############'),
(0, 12, 'polaroid#ab8247#############'),
(0, 12, 'sunset#ab8247#############'),
(0, 12, 'love#js9083#############'),
(0, 12, 'meadow#js9083#############'),
(0, 12, 'orbit#js9083#############'),
(0, 12, 'skyblue#js9083#############'),
(0, 12, 'metrics#mc9055#############'),
(0, 12, 'scale#mc9055#############'),
(0, 12, 'shipping#mc9055#############'),
(0, 12, 'checkout#md5481#############'),
(0, 12, 'midnight#md5481#############'),
(0, 12, 'orbit#md5481#############'),
(0, 12, 'paper#md5481#############'),
(0, 12, 'sunset#md5481#############'),
(0, 12, 'tides#md5481#############'),
(0, 12, 'echoes#pn7413#############'),
(0, 12, 'shadow#pn7413#############'),
(0, 12, 'velvet#pn7413#############'),
(0, 12, 'boundary#ts4389#############'),
(0, 12, 'burnout#ts4389#############'),
(0, 12, 'resilience#ts4389#############'),
(0, 13, 'ab8247#dreben#torontoproducer-rappercraftingjazzyboom-bapwithmodernsoul#polaroid###########'),
(0, 13, 'ah1050##tryingtogetintothemusicscene!############'),
(0, 13, 'js9083#youngsean#iwritesongsforthegreatestmomentsinlife.#skyblue###########'),
(0, 13, 'mc9055##formerstartuppminterviewingoperatorsaboutthemessymiddleofbuildingproducts############'),
(0, 13, 'md5481#delga#la-basedindie-popsingerblendingbilingualhookswithlo-fibeats#paper###########'),
(0, 13, 'pn7413#priyaaa#############'),
(0, 13, 'ts4389##therapisthostingconversationsonmentalhealth,community,andscience-backedpractices############'),
(0, 15, 'dm1120#cm7782#############'),
(0, 15, 'jm5520#ki4328#############'),
(0, 15, 'sm6701#ki4328#############'),
(0, 15, 'js9083#lk7653#############'),
(0, 15, 'ki4328#lk7653#############'),
(0, 15, 'sm6701#lk7653#############'),
(0, 15, 'cm7782#sm6701#############'),
(0, 15, 'dm1120#sm6701#############'),
(0, 16, 'brass#hip-hop#############'),
(0, 16, 'checkout#indiepop#############'),
(0, 16, 'echoes#alternativer&b#############'),
(0, 16, 'echoes#ambient#############'),
(0, 16, 'echoes#chillout#############'),
(0, 16, 'meadow#alternativerap#############'),
(0, 16, 'meadow#hip-hop#############'),
(0, 16, 'midnight#indiepop#############'),
(0, 16, 'paper#indiepop#############'),
(0, 16, 'polaroid#alternative#############'),
(0, 16, 'polaroid#dreampop#############'),
(0, 16, 'skyblue#pop#############'),
(0, 16, 'skyblue#rock#############'),
(0, 16, 'tides#indiepop#############'),
(0, 16, 'velvet#alternativer&b#############'),
(0, 17, 'ah1050#awesomeadam#tides#89###########'),
(0, 17, 'cm7782#chloemoore#polaroid#41#s1234##########'),
(0, 17, 'dm1120#dmoore2000#skyblue#33#s1234##########'),
(0, 17, 'jm5520#markstunes###s5566##########'),
(0, 17, 'js9083#superfanjs20#skyblue#64#s4738##########'),
(0, 17, 'ki4328#kevbeats#shipping#231#s9876##########'),
(0, 17, 'lk7653#lklikessongs#polaroid#142#s2345##########'),
(0, 17, 'sm6701#ssarah#echoes#19#s1234##########'),
(0, 17, 'ts4389#theos23#polaroid#178#s4738##########'),
(0, 18, 'p1111#carsongs#sm6701############'),
(0, 18, 'p2222#workoutsongs#sm6701############'),
(0, 18, 'p2310#carsongs#js9083############'),
(0, 18, 'p2323#weekendmix#jm5520############'),
(0, 18, 'p2345#favorites#ki4328############'),
(0, 18, 'p3333#inspiration#lk7653############'),
(0, 18, 'p7890#roadtrip#dm1120############'),
(0, 19, 'brass#p2345#4############'),
(0, 19, 'brass#p3333#2############'),
(0, 19, 'echoes#p1111#4############'),
(0, 19, 'echoes#p2222#2############'),
(0, 19, 'echoes#p3333#1############'),
(0, 19, 'echoes#p7890#1############'),
(0, 19, 'meadow#p1111#3############'),
(0, 19, 'meadow#p2222#1############'),
(0, 19, 'meadow#p7890#2############'),
(0, 19, 'midnight#p1111#6############'),
(0, 19, 'midnight#p2345#2############'),
(0, 19, 'polaroid#p1111#5############'),
(0, 19, 'polaroid#p2345#3############'),
(0, 19, 'polaroid#p3333#3############'),
(0, 19, 'skyblue#p1111#2############'),
(0, 19, 'skyblue#p2310#2############'),
(0, 19, 'tides#p2310#1############'),
(0, 19, 'tides#p2345#5############'),
(0, 19, 'velvet#p1111#1############'),
(0, 19, 'velvet#p2323#1############'),
(0, 19, 'velvet#p2345#1############'),
(0, 20, 'boundary#pod2222#boundaries#1###########'),
(0, 20, 'burnout#pod2222#burnout#2###########'),
(0, 20, 'love#pod4895#love#1###########'),
(0, 20, 'metrics#pod1111#metrics#2###########'),
(0, 20, 'resilience#pod2323#resilience#1###########'),
(0, 20, 'scale#pod1112#scaling#1###########'),
(0, 20, 'shipping#pod1111#efficiency#1###########'),
(0, 21, 'pod1111#buildmodes1#buildmodeisanoperator-drivenconversationaboutbuildingproducts—tactics,experiments,metrics,andshippingatspeed.############'),
(0, 21, 'pod1112#buildmodes2#buildmodeisanoperator-drivenconversationaboutbuildingproducts—tactics,experiments,metrics,andshippingatspeed.############'),
(0, 21, 'pod2222#mindcasts1#mindcastisatherapy-informedpodcastonmentalhealth,blendingevidence-basedtoolswithcommunitycareandrealstories.############'),
(0, 21, 'pod2323#mindcasts2#mindcastisatherapy-informedpodcastonmentalhealth,blendingevidence-basedtoolswithcommunitycareandrealstories.############'),
(0, 21, 'pod4895#friendlytalks#friendlytalksisacozy,curiosity-drivenshowwherethoughtfulpeopleunpackeverydaytopics.############'),
(0, 22, 'ab8247#instagram#dreben############'),
(0, 22, 'ab8247#soundcloud#drebenbeats############'),
(0, 22, 'ab8247#twitter#dreben_x############'),
(0, 22, 'ah1050#instagram#ahartofgold############'),
(0, 22, 'js9083#instagram#ysean############'),
(0, 22, 'js9083#snapchat#youngsean############'),
(0, 22, 'js9083#tiktok#iamsean############'),
(0, 22, 'mc9055#linkedin#malikcarter############'),
(0, 22, 'mc9055#tiktok#buildmode_tok############'),
(0, 22, 'mc9055#twitter#buildmodepod############'),
(0, 22, 'md5481#instagram#delga############'),
(0, 22, 'md5481#tiktok#delgatofficial############'),
(0, 22, 'md5481#youtube#delgatv############'),
(0, 22, 'pn7413#instagram#priyan############'),
(0, 22, 'pn7413#twitch#priyanstudio############'),
(0, 22, 'pn7413#twitter#priyan_x############'),
(0, 22, 'ts4389#instagram#mindcast############'),
(0, 22, 'ts4389#tiktok#mindcastpod############'),
(0, 22, 'ts4389#twitch#theolive############'),
(0, 23, 'echoes##############'),
(0, 23, 'brass#ab8247#copperlines############'),
(0, 23, 'polaroid#ab8247#copperlines############'),
(0, 23, 'meadow#js9083#starlightmeadows############'),
(0, 23, 'skyblue#js9083#starlightmeadows############'),
(0, 23, 'midnight#md5481#nightswim############'),
(0, 23, 'tides#md5481#nightswim############'),
(0, 23, 'checkout#md5481#sunflowermotel############'),
(0, 23, 'paper#md5481#sunflowermotel############'),
(0, 23, 'shadow#pn7413#velvethour############'),
(0, 23, 'velvet#pn7413#velvethour############'),
(0, 24, 's1234#119.99#2025-02-01#2025-12-31##3#family########'),
(0, 24, 's2345#205.55#2024-05-13#2025-04-30#premium##individual########'),
(0, 24, 's4738#360.00#2025-02-01#2025-12-31##5#family########'),
(0, 24, 's5566#111.45#2025-03-10#2026-05-01#premium##individual########'),
(0, 24, 's9876#299.99#2024-08-20#2025-08-19#deluxe##individual########'),
(0, 25, 'ab8247#andrebennett#1992-07-11#andrebennett@music.io###########'),
(0, 25, 'ah1050#adamhart#1990-07-29#ahart@mail.com###########'),
(0, 25, 'cm7782#chloemoore#2009-09-21#chloe.moore@mail.com###########'),
(0, 25, 'dm1120#danielmoore#2000-05-09#dan.moore@mail.com###########'),
(0, 25, 'jm5520#jonahmarks#1994-11-02#jonah.marks@mail.com###########'),
(0, 25, 'js9083#joesmith#1990-12-01#joesmith90@mail.com###########'),
(0, 25, 'ki4328#keviningram#1989-03-14#kevin.ingram@mail.com###########'),
(0, 25, 'lk7653#lisakeller#1998-01-30#lenakhan@mail.com###########'),
(0, 25, 'mc9055#malikcarter#1991-10-19#malik.carter@studio.fm###########'),
(0, 25, 'md5481#mayadelgado#1995-03-22#maya.delgado@mail.com###########'),
(0, 25, 'pn7413#priyanair#1996-12-17#priya.nair@mail.com###########'),
(0, 25, 'sm6701#sarahmoore#1992-06-22#sarahmoore@mail.com###########'),
(0, 25, 'ts4389#theoschmidt#1993-02-14#tchmidt@mindcast.app###########'),
(20, 24, 's1234#119.99#2025-02-01#2025-12-31##3#family########'),
(20, 24, 's2345#205.55#2024-05-13#2026-04-30#premium##individual########'),
(20, 24, 's4738#360.00#2025-02-01#2025-12-31##5#family########'),
(20, 24, 's5566#111.45#2025-03-10#2026-05-01#premium##individual########'),
(20, 24, 's9876#299.99#2024-08-20#2025-08-19#deluxe##individual########'),
(20, 17, 'ah1050#awesomeadam#tides#89###########'),
(20, 17, 'cm7782#chloemoore#polaroid#41#s1234##########'),
(20, 17, 'dm1120#dmoore2000#skyblue#33#s1234##########'),
(20, 17, 'jm5520#markstunes###s5566##########'),
(20, 17, 'js9083#superfanjs20#skyblue#64#s4738##########'),
(20, 17, 'ki4328#kevbeats#shipping#231#s9876##########'),
(20, 17, 'lk7653#lklikessongs#polaroid#142#s2345##########'),
(20, 17, 'sm6701#ssarah#echoes#19#s1234##########'),
(20, 17, 'ts4389#theos23#polaroid#178#s4738##########'),
(20, 25, 'ab8247#andrebennett#1992-07-11#andrebennett@music.io###########'),
(20, 25, 'ah1050#adamhart#1990-07-29#ahart@mail.com###########'),
(20, 25, 'cm7782#chloemoore#2009-09-21#chloe.moore@mail.com###########'),
(20, 25, 'dm1120#danielmoore#2000-05-09#dan.moore@mail.com###########'),
(20, 25, 'jm5520#jonahmarks#1994-11-02#jonah.marks@mail.com###########'),
(20, 25, 'js9083#joesmith#1990-12-01#joesmith90@mail.com###########'),
(20, 25, 'ki4328#keviningram#1989-03-14#kevin.ingram@mail.com###########'),
(20, 25, 'lk7653#lisakeller#1998-01-30#lenakhan@mail.com###########'),
(20, 25, 'mc9055#malikcarter#1991-10-19#malik.carter@studio.fm###########'),
(20, 25, 'md5481#mayadelgado#1995-03-22#maya.delgado@mail.com###########'),
(20, 25, 'pn7413#priyanair#1996-12-17#priya.nair@mail.com###########'),
(20, 25, 'sm6701#sarahmoore#1992-06-22#sarahmoore@mail.com###########'),
(20, 25, 'ts4389#theoschmidt#1993-02-14#tchmidt@mindcast.app###########'),
(40, 18, 'p1111#carsongs#sm6701############'),
(40, 18, 'p2222#workoutsongs#sm6701############'),
(40, 18, 'p2310#carsongs#js9083############'),
(40, 18, 'p2323#weekendmix#jm5520############'),
(40, 18, 'p2345#favorites#ki4328############'),
(40, 18, 'p3333#inspiration#lk7653############'),
(40, 18, 'p7890#roadtrip#dm1120############'),
(40, 18, 'p9999#copyofcarsongs#sm6701############'),
(40, 19, 'brass#p2345#4############'),
(40, 19, 'brass#p3333#2############'),
(40, 19, 'echoes#p1111#4############'),
(40, 19, 'echoes#p2222#2############'),
(40, 19, 'echoes#p3333#1############'),
(40, 19, 'echoes#p7890#1############'),
(40, 19, 'echoes#p9999#4############'),
(40, 19, 'meadow#p1111#3############'),
(40, 19, 'meadow#p2222#1############'),
(40, 19, 'meadow#p7890#2############'),
(40, 19, 'meadow#p9999#3############'),
(40, 19, 'midnight#p1111#6############'),
(40, 19, 'midnight#p2345#2############'),
(40, 19, 'midnight#p9999#6############'),
(40, 19, 'polaroid#p1111#5############'),
(40, 19, 'polaroid#p2345#3############'),
(40, 19, 'polaroid#p3333#3############'),
(40, 19, 'polaroid#p9999#5############'),
(40, 19, 'skyblue#p1111#2############'),
(40, 19, 'skyblue#p2310#2############'),
(40, 19, 'skyblue#p9999#2############'),
(40, 19, 'tides#p2310#1############'),
(40, 19, 'tides#p2345#5############'),
(40, 19, 'velvet#p1111#1############'),
(40, 19, 'velvet#p2323#1############'),
(40, 19, 'velvet#p2345#1############'),
(40, 19, 'velvet#p9999#1############'),
(60, 11, 'boundary#boundaries101#2741#notexplicit#english#2024-01-14#########'),
(60, 11, 'brass#brasswires#179#notexplicit#english#2024-03-22#########'),
(60, 11, 'burnout#burnoutreset#1914#notexplicit#english#2024-02-11#########'),
(60, 11, 'checkout#latecheckout#182#explicit#english#2022-07-18#########'),
(60, 11, 'echoes#cityofechoes#131#notexplicit#english#2024-05-04#########'),
(60, 11, 'love#friendlytalksep1:love#1800#notexplicit#english#2025-02-15#########'),
(60, 11, 'love2#friendlytalksep2:work#1800#notexplicit#english#2026-01-01#########'),
(60, 11, 'meadow#meadownight#144#explicit#english#2023-09-12#########'),
(60, 11, 'metrics#metricsthatmatter#3262#notexplicit#french#2023-05-20#########'),
(60, 11, 'midnight#midnightpool#156#notexplicit#english#2023-03-10#########'),
(60, 11, 'orbit#midnightorbit#688#explicit#german#2024-01-15#########'),
(60, 11, 'paper#paperskies#178#notexplicit#english#2022-07-18#########'),
(60, 11, 'polaroid#polaroidwalls#185#notexplicit#english#2024-03-22#########'),
(60, 11, 'resilience#everydayresilience#2535#notexplicit#english#2024-06-02#########'),
(60, 11, 'scale#scalingchaos#2212#notexplicit#english#2024-09-15#########'),
(60, 11, 'shadow#oneshadow#233#notexplicit#english#2024-06-01#########'),
(60, 11, 'shipping#shippingwithoutmaps#3551#notexplicit#english#2023-04-22#########'),
(60, 11, 'skyblue#skysoblue#95#notexplicit#english#2023-09-12#########'),
(60, 11, 'sunset#sunsetgrove#782#notexplicit#english#2023-11-03#########'),
(60, 11, 'tides#neontides#168#explicit#spanish#2023-03-10#########'),
(60, 11, 'velvet#velvetraag#201#notexplicit#english#2024-05-04#########'),
(60, 12, 'brass#ab8247#############'),
(60, 12, 'polaroid#ab8247#############'),
(60, 12, 'sunset#ab8247#############'),
(60, 12, 'love#js9083#############'),
(60, 12, 'love2#js9083#############'),
(60, 12, 'meadow#js9083#############'),
(60, 12, 'orbit#js9083#############'),
(60, 12, 'skyblue#js9083#############'),
(60, 12, 'metrics#mc9055#############'),
(60, 12, 'scale#mc9055#############'),
(60, 12, 'shipping#mc9055#############'),
(60, 12, 'checkout#md5481#############'),
(60, 12, 'midnight#md5481#############'),
(60, 12, 'orbit#md5481#############'),
(60, 12, 'paper#md5481#############'),
(60, 12, 'sunset#md5481#############'),
(60, 12, 'tides#md5481#############'),
(60, 12, 'echoes#pn7413#############'),
(60, 12, 'shadow#pn7413#############'),
(60, 12, 'velvet#pn7413#############'),
(60, 12, 'boundary#ts4389#############'),
(60, 12, 'burnout#ts4389#############'),
(60, 12, 'resilience#ts4389#############'),
(60, 20, 'boundary#pod2222#boundaries#1###########'),
(60, 20, 'burnout#pod2222#burnout#2###########'),
(60, 20, 'love#pod4895#love#1###########'),
(60, 20, 'love2#pod4895#work#2###########'),
(60, 20, 'metrics#pod1111#metrics#2###########'),
(60, 20, 'resilience#pod2323#resilience#1###########'),
(60, 20, 'scale#pod1112#scaling#1###########'),
(60, 20, 'shipping#pod1111#efficiency#1###########'),
(60, 21, 'pod1111#buildmodes1#buildmodeisanoperator-drivenconversationaboutbuildingproducts—tactics,experiments,metrics,andshippingatspeed.############'),
(60, 21, 'pod1112#buildmodes2#buildmodeisanoperator-drivenconversationaboutbuildingproducts—tactics,experiments,metrics,andshippingatspeed.############'),
(60, 21, 'pod2222#mindcasts1#mindcastisatherapy-informedpodcastonmentalhealth,blendingevidence-basedtoolswithcommunitycareandrealstories.############'),
(60, 21, 'pod2323#mindcasts2#mindcastisatherapy-informedpodcastonmentalhealth,blendingevidence-basedtoolswithcommunitycareandrealstories.############'),
(60, 21, 'pod4895#friendlytalks#friendlytalksisacozy,curiosity-drivenshowwherethoughtfulpeopleunpackeverydaytopics.############'),
(80, 17, 'ah1050#awesomeadam#tides#89###########'),
(80, 17, 'cm7782#chloemoore#polaroid#41#s1234##########'),
(80, 17, 'dm1120#dmoore2000#skyblue#33#s1234##########'),
(80, 17, 'jm5520#markstunes###s5566##########'),
(80, 17, 'js9083#superfanjs20#skyblue#64#s4738##########'),
(80, 17, 'ki4328#kevbeats#orbit#0#s9876##########'),
(80, 17, 'lk7653#lklikessongs#polaroid#142#s2345##########'),
(80, 17, 'sm6701#ssarah#echoes#19#s1234##########'),
(80, 17, 'ts4389#theos23#polaroid#178#s4738##########'),
(100, 15, 'dm1120#cm7782#############'),
(100, 15, 'jm5520#ki4328#############'),
(100, 15, 'sm6701#ki4328#############'),
(100, 15, 'js9083#lk7653#############'),
(100, 15, 'ki4328#lk7653#############'),
(100, 15, 'sm6701#lk7653#############'),
(100, 15, 'cm7782#sm6701#############'),
(100, 15, 'dm1120#sm6701#############'),
(100, 15, 'jm5520#sm6701#############'),
(120, 13, 'ab8247#dreben#torontoproducer-rappercraftingjazzyboom-bapwithmodernsoul#polaroid###########'),
(120, 13, 'ah1050##tryingtogetintothemusicscene!############'),
(120, 13, 'js9083#youngsean#iwritesongsforthegreatestmomentsinlife.#skyblue###########'),
(120, 13, 'mc9055##formerstartuppminterviewingoperatorsaboutthemessymiddleofbuildingproducts############'),
(120, 13, 'md5481#delga#la-basedindie-popsingerblendingbilingualhookswithlo-fibeats#paper###########'),
(120, 13, 'pn7413#priyaaa##velvet###########'),
(120, 13, 'ts4389##therapisthostingconversationsonmentalhealth,community,andscience-backedpractices############'),
(140, 24, 's2345#205.55#2024-05-13#2025-04-30#premium##individual########'),
(140, 24, 's4738#360.00#2025-02-01#2025-12-31##5#family########'),
(140, 24, 's5566#111.45#2025-03-10#2026-05-01#premium##individual########'),
(140, 24, 's9876#299.99#2024-08-20#2025-08-19#deluxe##individual########'),
(140, 15, 'jm5520#ki4328#############'),
(140, 15, 'js9083#lk7653#############'),
(140, 15, 'ki4328#lk7653#############'),
(140, 17, 'ah1050#awesomeadam#tides#89###########'),
(140, 17, 'cm7782#chloemoore#polaroid#41###########'),
(140, 17, 'dm1120#dmoore2000#skyblue#33###########'),
(140, 17, 'jm5520#markstunes###s5566##########'),
(140, 17, 'js9083#superfanjs20#skyblue#64#s4738##########'),
(140, 17, 'ki4328#kevbeats#shipping#231#s9876##########'),
(140, 17, 'lk7653#lklikessongs#polaroid#142#s2345##########'),
(140, 17, 'sm6701#ssarah#echoes#19###########'),
(140, 17, 'ts4389#theos23#polaroid#178#s4738##########'),
(140, 18, 'p2310#carsongs#js9083############'),
(140, 18, 'p2323#weekendmix#jm5520############'),
(140, 18, 'p2345#favorites#ki4328############'),
(140, 18, 'p3333#inspiration#lk7653############'),
(160, 18, 'new_pl_1#morningmix#js9083############'),
(160, 18, 'p1111#carsongs#sm6701############'),
(160, 18, 'p2222#workoutsongs#sm6701############'),
(160, 18, 'p2310#carsongs#js9083############'),
(160, 18, 'p2323#weekendmix#jm5520############'),
(160, 18, 'p2345#favorites#ki4328############'),
(160, 18, 'p3333#inspiration#lk7653############'),
(160, 18, 'p7890#roadtrip#dm1120############'),
(160, 19, 'brass#p2345#4############'),
(160, 19, 'brass#p3333#2############'),
(160, 19, 'echoes#p1111#4############'),
(160, 19, 'echoes#p2222#2############'),
(160, 19, 'echoes#p3333#1############'),
(160, 19, 'echoes#p7890#1############'),
(160, 19, 'meadow#p1111#3############'),
(160, 19, 'meadow#p2222#1############'),
(160, 19, 'meadow#p7890#2############'),
(160, 19, 'midnight#p1111#6############'),
(160, 19, 'midnight#p2345#2############'),
(160, 19, 'polaroid#p1111#5############'),
(160, 19, 'polaroid#p2345#3############'),
(160, 19, 'polaroid#p3333#3############'),
(160, 19, 'skyblue#new_pl_1#1############'),
(160, 19, 'skyblue#p1111#2############'),
(160, 19, 'skyblue#p2310#2############'),
(160, 19, 'tides#p2310#1############'),
(160, 19, 'tides#p2345#5############'),
(160, 19, 'velvet#p1111#1############'),
(160, 19, 'velvet#p2323#1############'),
(160, 19, 'velvet#p2345#1############'),
(180, 19, 'brass#p2345#4############'),
(180, 19, 'brass#p3333#2############'),
(180, 19, 'checkout#p2323#2############'),
(180, 19, 'echoes#p1111#4############'),
(180, 19, 'echoes#p2222#2############'),
(180, 19, 'echoes#p3333#1############'),
(180, 19, 'echoes#p7890#1############'),
(180, 19, 'meadow#p1111#3############'),
(180, 19, 'meadow#p2222#1############'),
(180, 19, 'meadow#p7890#2############'),
(180, 19, 'midnight#p1111#6############'),
(180, 19, 'midnight#p2345#2############'),
(180, 19, 'polaroid#p1111#5############'),
(180, 19, 'polaroid#p2345#3############'),
(180, 19, 'polaroid#p3333#3############'),
(180, 19, 'skyblue#p1111#2############'),
(180, 19, 'skyblue#p2310#2############'),
(180, 19, 'tides#p2310#1############'),
(180, 19, 'tides#p2345#5############'),
(180, 19, 'velvet#p1111#1############'),
(180, 19, 'velvet#p2323#1############'),
(180, 19, 'velvet#p2345#1############'),
(200, 17, 'ah1050#awesomeadam#tides#89###########'),
(200, 17, 'cm7782#chloemoore#polaroid#41#s1234##########'),
(200, 17, 'dm1120#dmoore2000#skyblue#33#s1234##########'),
(200, 17, 'jm5520#markstunes###s5566##########'),
(200, 17, 'js9083#superfanjs20#skyblue#64#s4738##########'),
(200, 17, 'ki4328#kevbeats#shipping#231#s9876##########'),
(200, 17, 'lk7653#lklikessongs#brass#0#s2345##########'),
(200, 17, 'sm6701#ssarah#echoes#19#s1234##########'),
(200, 17, 'ts4389#theos23#polaroid#178#s4738##########'),
(220, 13, 'ab8247#dreben#torontoproducer-rappercraftingjazzyboom-bapwithmodernsoul#polaroid###########'),
(220, 13, 'ah1050##tryingtogetintothemusicscene!############'),
(220, 13, 'js9083#youngsean#iwritesongsforthegreatestmomentsinlife.#skyblue###########'),
(220, 13, 'mc9055##formerstartuppminterviewingoperatorsaboutthemessymiddleofbuildingproducts############'),
(220, 13, 'md5481#delga#la-basedindie-popsingerblendingbilingualhookswithlo-fibeats#paper###########'),
(220, 13, 'pn7413#priyaaa#############'),
(220, 13, 'ts4389##therapisthostingconversationsonmentalhealth,community,andscience-backedpractices############'),
(220, 17, 'ah1050#awesomeadam#tides#89###########'),
(220, 17, 'cm7782#chloemoore#polaroid#41#s1234##########'),
(220, 17, 'dm1120#dmoore2000#skyblue#33#s1234##########'),
(220, 17, 'fw7890#apples1109#polaroid#0###########'),
(220, 17, 'jm5520#markstunes###s5566##########'),
(220, 17, 'js9083#superfanjs20#skyblue#64#s4738##########'),
(220, 17, 'ki4328#kevbeats#shipping#231#s9876##########'),
(220, 17, 'lk7653#lklikessongs#polaroid#142#s2345##########'),
(220, 17, 'sm6701#ssarah#echoes#19#s1234##########'),
(220, 17, 'ts4389#theos23#polaroid#178#s4738##########'),
(220, 25, 'ab8247#andrebennett#1992-07-11#andrebennett@music.io###########'),
(220, 25, 'ah1050#adamhart#1990-07-29#ahart@mail.com###########'),
(220, 25, 'cm7782#chloemoore#2009-09-21#chloe.moore@mail.com###########'),
(220, 25, 'dm1120#danielmoore#2000-05-09#dan.moore@mail.com###########'),
(220, 25, 'fw7890#fionawashington#2000-11-09#fwashington@gmail.com###########'),
(220, 25, 'jm5520#jonahmarks#1994-11-02#jonah.marks@mail.com###########'),
(220, 25, 'js9083#joesmith#1990-12-01#joesmith90@mail.com###########'),
(220, 25, 'ki4328#keviningram#1989-03-14#kevin.ingram@mail.com###########'),
(220, 25, 'lk7653#lisakeller#1998-01-30#lenakhan@mail.com###########'),
(220, 25, 'mc9055#malikcarter#1991-10-19#malik.carter@studio.fm###########'),
(220, 25, 'md5481#mayadelgado#1995-03-22#maya.delgado@mail.com###########'),
(220, 25, 'pn7413#priyanair#1996-12-17#priya.nair@mail.com###########'),
(220, 25, 'sm6701#sarahmoore#1992-06-22#sarahmoore@mail.com###########'),
(220, 25, 'ts4389#theoschmidt#1993-02-14#tchmidt@mindcast.app###########'),
(240, 11, 'boundary#boundaries101#2741#notexplicit#english#2024-01-14#########'),
(240, 11, 'brass#brasswires#179#notexplicit#english#2024-03-22#########'),
(240, 11, 'burnout#burnoutreset#1914#notexplicit#english#2024-02-11#########'),
(240, 11, 'checkout#latecheckout#182#explicit#english#2022-07-18#########'),
(240, 11, 'echoes#cityofechoes#131#notexplicit#english#2024-05-04#########'),
(240, 11, 'love#friendlytalksep1:love#1800#notexplicit#english#2025-02-15#########'),
(240, 11, 'meadow#meadownight#144#explicit#english#2023-09-12#########'),
(240, 11, 'metrics#metricsthatmatter#3262#notexplicit#french#2023-05-20#########'),
(240, 11, 'midnight#midnightpool#156#notexplicit#english#2023-03-10#########'),
(240, 11, 'orbit#midnightorbit#688#explicit#german#2024-01-15#########'),
(240, 11, 'paper#paperskies#178#notexplicit#english#2022-07-18#########'),
(240, 11, 'polaroid#polaroidwalls#185#notexplicit#english#2024-03-22#########'),
(240, 11, 'resilience#everydayresilience#2535#notexplicit#english#2024-06-02#########'),
(240, 11, 'scale#scalingchaos#2212#notexplicit#english#2024-09-15#########'),
(240, 11, 'shadow#oneshadow#233#notexplicit#english#2024-06-01#########'),
(240, 11, 'shipping#shippingwithoutmaps#3551#notexplicit#english#2023-04-22#########'),
(240, 11, 'skyblue#skysoblue#95#notexplicit#english#2023-09-12#########'),
(240, 11, 'sunset#sunsetgrove#782#notexplicit#english#2023-11-03#########'),
(240, 11, 'tides#neontides#168#explicit#spanish#2023-03-10#########'),
(240, 11, 'upload01#testsong1#180#notexplicit#english#2025-01-01#########'),
(240, 11, 'velvet#velvetraag#201#notexplicit#english#2024-05-04#########'),
(240, 23, 'echoes##############'),
(240, 23, 'brass#ab8247#copperlines############'),
(240, 23, 'polaroid#ab8247#copperlines############'),
(240, 23, 'upload01#js9083#############'),
(240, 23, 'meadow#js9083#starlightmeadows############'),
(240, 23, 'skyblue#js9083#starlightmeadows############'),
(240, 23, 'midnight#md5481#nightswim############'),
(240, 23, 'tides#md5481#nightswim############'),
(240, 23, 'checkout#md5481#sunflowermotel############'),
(240, 23, 'paper#md5481#sunflowermotel############'),
(240, 23, 'shadow#pn7413#velvethour############'),
(240, 23, 'velvet#pn7413#velvethour############'),
(240, 12, 'brass#ab8247#############'),
(240, 12, 'polaroid#ab8247#############'),
(240, 12, 'sunset#ab8247#############'),
(240, 12, 'love#js9083#############'),
(240, 12, 'meadow#js9083#############'),
(240, 12, 'orbit#js9083#############'),
(240, 12, 'skyblue#js9083#############'),
(240, 12, 'upload01#js9083#############'),
(240, 12, 'metrics#mc9055#############'),
(240, 12, 'scale#mc9055#############'),
(240, 12, 'shipping#mc9055#############'),
(240, 12, 'checkout#md5481#############'),
(240, 12, 'midnight#md5481#############'),
(240, 12, 'orbit#md5481#############'),
(240, 12, 'paper#md5481#############'),
(240, 12, 'sunset#md5481#############'),
(240, 12, 'tides#md5481#############'),
(240, 12, 'echoes#pn7413#############'),
(240, 12, 'shadow#pn7413#############'),
(240, 12, 'velvet#pn7413#############'),
(240, 12, 'boundary#ts4389#############'),
(240, 12, 'burnout#ts4389#############'),
(240, 12, 'resilience#ts4389#############'),
(240, 13, 'ab8247#dreben#torontoproducer-rappercraftingjazzyboom-bapwithmodernsoul#polaroid###########'),
(240, 13, 'ah1050##tryingtogetintothemusicscene!############'),
(240, 13, 'js9083#youngsean#iwritesongsforthegreatestmomentsinlife.#skyblue###########'),
(240, 13, 'mc9055##formerstartuppminterviewingoperatorsaboutthemessymiddleofbuildingproducts############'),
(240, 13, 'md5481#delga#la-basedindie-popsingerblendingbilingualhookswithlo-fibeats#paper###########'),
(240, 13, 'pn7413#priyaaa#############'),
(240, 13, 'ts4389##therapisthostingconversationsonmentalhealth,community,andscience-backedpractices############'),
(260, 18, 'p1111#carsongs#sm6701############'),
(260, 18, 'p2222#workoutsongs#sm6701############'),
(260, 18, 'p2310#carsongs#js9083############'),
(260, 18, 'p2323#weekendmix#jm5520############'),
(260, 18, 'p2345#favorites#ki4328############'),
(260, 18, 'p3333#inspiration#lk7653############'),
(260, 18, 'p7890#roadtrip#dm1120############'),
(260, 19, 'brass#p2345#4############'),
(260, 19, 'brass#p3333#2############'),
(260, 19, 'echoes#p2222#2############'),
(260, 19, 'echoes#p3333#1############'),
(260, 19, 'echoes#p7890#1############'),
(260, 19, 'meadow#p2222#1############'),
(260, 19, 'meadow#p7890#2############'),
(260, 19, 'midnight#p1111#3############'),
(260, 19, 'midnight#p2345#2############'),
(260, 19, 'polaroid#p2345#3############'),
(260, 19, 'polaroid#p3333#3############'),
(260, 19, 'skyblue#p1111#2############'),
(260, 19, 'skyblue#p2310#2############'),
(260, 19, 'tides#p2310#1############'),
(260, 19, 'tides#p2345#5############'),
(260, 19, 'velvet#p1111#1############'),
(260, 19, 'velvet#p2323#1############'),
(260, 19, 'velvet#p2345#1############'),
(280, 18, 'p1111#carsongs#sm6701############'),
(280, 18, 'p2310#carsongs#js9083############'),
(280, 18, 'p2323#weekendmix#jm5520############'),
(280, 18, 'p2345#favorites#ki4328############'),
(280, 18, 'p3333#inspiration#lk7653############'),
(280, 18, 'p7890#roadtrip#dm1120############'),
(280, 19, 'brass#p2345#4############'),
(280, 19, 'brass#p3333#2############'),
(280, 19, 'echoes#p1111#4############'),
(280, 19, 'echoes#p3333#1############'),
(280, 19, 'echoes#p7890#1############'),
(280, 19, 'meadow#p1111#3############'),
(280, 19, 'meadow#p7890#2############'),
(280, 19, 'midnight#p1111#6############'),
(280, 19, 'midnight#p2345#2############'),
(280, 19, 'polaroid#p1111#5############'),
(280, 19, 'polaroid#p2345#3############'),
(280, 19, 'polaroid#p3333#3############'),
(280, 19, 'skyblue#p1111#2############'),
(280, 19, 'skyblue#p2310#2############'),
(280, 19, 'tides#p2310#1############'),
(280, 19, 'tides#p2345#5############'),
(280, 19, 'velvet#p1111#1############'),
(280, 19, 'velvet#p2323#1############'),
(280, 19, 'velvet#p2345#1############'),
(300, 17, 'ah1050#awesomeadam#tides#89###########'),
(300, 17, 'cm7782#chloemoore#polaroid#41#s1234##########'),
(300, 17, 'dm1120#dmoore2000#skyblue#33#s1234##########'),
(300, 17, 'jm5520#markstunes###s5566##########'),
(300, 17, 'js9083#superfanjs20#skyblue#64#s4738##########'),
(300, 17, 'ki4328#kevbeats#shipping#231#s9876##########'),
(300, 17, 'lk7653#lklikessongs#polaroid#142#s2345##########'),
(300, 17, 'sm6701#ssarah###s1234##########'),
(300, 17, 'ts4389#theos23#polaroid#178#s4738##########'),
(320, 12, 'brass#ab8247#############'),
(320, 12, 'polaroid#ab8247#############'),
(320, 12, 'sunset#ab8247#############'),
(320, 12, 'brass#js9083#############'),
(320, 12, 'love#js9083#############'),
(320, 12, 'meadow#js9083#############'),
(320, 12, 'orbit#js9083#############'),
(320, 12, 'skyblue#js9083#############'),
(320, 12, 'metrics#mc9055#############'),
(320, 12, 'scale#mc9055#############'),
(320, 12, 'shipping#mc9055#############'),
(320, 12, 'checkout#md5481#############'),
(320, 12, 'midnight#md5481#############'),
(320, 12, 'orbit#md5481#############'),
(320, 12, 'paper#md5481#############'),
(320, 12, 'sunset#md5481#############'),
(320, 12, 'tides#md5481#############'),
(320, 12, 'echoes#pn7413#############'),
(320, 12, 'shadow#pn7413#############'),
(320, 12, 'velvet#pn7413#############'),
(320, 12, 'boundary#ts4389#############'),
(320, 12, 'burnout#ts4389#############'),
(320, 12, 'resilience#ts4389#############'),
(340, 20, 'love#pod4895#love#1###########'),
(340, 20, 'metrics#pod1111#metrics#2###########'),
(340, 20, 'resilience#pod2323#resilience#1###########'),
(340, 20, 'scale#pod1112#scaling#1###########'),
(340, 20, 'shipping#pod1111#efficiency#1###########'),
(340, 11, 'brass#brasswires#179#notexplicit#english#2024-03-22#########'),
(340, 11, 'checkout#latecheckout#182#explicit#english#2022-07-18#########'),
(340, 11, 'echoes#cityofechoes#131#notexplicit#english#2024-05-04#########'),
(340, 11, 'love#friendlytalksep1:love#1800#notexplicit#english#2025-02-15#########'),
(340, 11, 'meadow#meadownight#144#explicit#english#2023-09-12#########'),
(340, 11, 'metrics#metricsthatmatter#3262#notexplicit#french#2023-05-20#########'),
(340, 11, 'midnight#midnightpool#156#notexplicit#english#2023-03-10#########'),
(340, 11, 'orbit#midnightorbit#688#explicit#german#2024-01-15#########'),
(340, 11, 'paper#paperskies#178#notexplicit#english#2022-07-18#########'),
(340, 11, 'polaroid#polaroidwalls#185#notexplicit#english#2024-03-22#########'),
(340, 11, 'resilience#everydayresilience#2535#notexplicit#english#2024-06-02#########'),
(340, 11, 'scale#scalingchaos#2212#notexplicit#english#2024-09-15#########'),
(340, 11, 'shadow#oneshadow#233#notexplicit#english#2024-06-01#########'),
(340, 11, 'shipping#shippingwithoutmaps#3551#notexplicit#english#2023-04-22#########'),
(340, 11, 'skyblue#skysoblue#95#notexplicit#english#2023-09-12#########'),
(340, 11, 'sunset#sunsetgrove#782#notexplicit#english#2023-11-03#########'),
(340, 11, 'tides#neontides#168#explicit#spanish#2023-03-10#########'),
(340, 11, 'velvet#velvetraag#201#notexplicit#english#2024-05-04#########'),
(340, 12, 'brass#ab8247#############'),
(340, 12, 'polaroid#ab8247#############'),
(340, 12, 'sunset#ab8247#############'),
(340, 12, 'love#js9083#############'),
(340, 12, 'meadow#js9083#############'),
(340, 12, 'orbit#js9083#############'),
(340, 12, 'skyblue#js9083#############'),
(340, 12, 'metrics#mc9055#############'),
(340, 12, 'scale#mc9055#############'),
(340, 12, 'shipping#mc9055#############'),
(340, 12, 'checkout#md5481#############'),
(340, 12, 'midnight#md5481#############'),
(340, 12, 'orbit#md5481#############'),
(340, 12, 'paper#md5481#############'),
(340, 12, 'sunset#md5481#############'),
(340, 12, 'tides#md5481#############'),
(340, 12, 'echoes#pn7413#############'),
(340, 12, 'shadow#pn7413#############'),
(340, 12, 'velvet#pn7413#############'),
(340, 12, 'resilience#ts4389#############'),
(360, 22, 'ab8247#soundcloud#drebenbeats############'),
(360, 22, 'ah1050#instagram#ahartofgold############'),
(360, 22, 'js9083#instagram#ysean############'),
(360, 22, 'js9083#snapchat#youngsean############'),
(360, 22, 'js9083#tiktok#iamsean############'),
(360, 22, 'mc9055#linkedin#malikcarter############'),
(360, 22, 'mc9055#tiktok#buildmode_tok############'),
(360, 22, 'mc9055#twitter#buildmodepod############'),
(360, 22, 'md5481#instagram#delga############'),
(360, 22, 'md5481#tiktok#delgatofficial############'),
(360, 22, 'md5481#youtube#delgatv############'),
(360, 22, 'pn7413#instagram#priyan############'),
(360, 22, 'pn7413#twitch#priyanstudio############'),
(360, 22, 'pn7413#twitter#priyan_x############'),
(360, 22, 'ts4389#instagram#mindcast############'),
(360, 22, 'ts4389#tiktok#mindcastpod############'),
(360, 22, 'ts4389#twitch#theolive############');

create or replace view magic44_test_case_frequencies as
select test_case_category, count(distinct step_id) as num_test_cases
from (select step_id, query_id, row_hash, 20 * truncate(step_id / 20, 0) as test_case_category
from magic44_expected_results where step_id < 600) as combine_tests
group by test_case_category
union
select test_case_category, count(distinct step_id) as num_test_cases
from (select step_id, query_id, row_hash, 50 * truncate(step_id / 50, 0) as test_case_category
from magic44_expected_results where step_id >= 600) as combine_tests
group by test_case_category;

update magic44_test_results set row_hash = lower(replace(row_hash, ' ', ''));

drop view if exists magic44_count_answers;
create view magic44_count_answers as
select step_id, query_id, count(*) as answer_total
from magic44_expected_results group by step_id, query_id;

drop view if exists magic44_count_test_results;
create view magic44_count_test_results as
select step_id, query_id, count(*) as result_total
from magic44_test_results group by step_id, query_id;

drop view if exists magic44_count_differences;
create view magic44_count_differences as
select magic44_count_answers.query_id, magic44_count_answers.step_id, answer_total, result_total
from magic44_count_answers left outer join magic44_count_test_results
	on magic44_count_answers.step_id = magic44_count_test_results.step_id
	and magic44_count_answers.query_id = magic44_count_test_results.query_id
where answer_total <> result_total or result_total is null
union
select magic44_count_test_results.query_id, magic44_count_test_results.step_id, answer_total, result_total
from magic44_count_test_results left outer join magic44_count_answers
	on magic44_count_test_results.step_id = magic44_count_answers.step_id
	and magic44_count_test_results.query_id = magic44_count_answers.query_id
where result_total <> answer_total or answer_total is null
order by query_id, step_id;

drop view if exists magic44_content_differences;
create view magic44_content_differences as
select query_id, step_id, 'missing' as category, row_hash
from magic44_expected_results where row(step_id, query_id, row_hash) not in
	(select step_id, query_id, row_hash from magic44_test_results)
union
select query_id, step_id, 'extra' as category, row_hash
from magic44_test_results where row(step_id, query_id, row_hash) not in
	(select step_id, query_id, row_hash from magic44_expected_results)
order by query_id, step_id, row_hash;

drop view if exists magic44_result_set_size_errors;
create view magic44_result_set_size_errors as
select step_id, query_id, 'result_set_size' as err_category from magic44_count_differences
group by step_id, query_id;

drop view if exists magic44_attribute_value_errors;
create view magic44_attribute_value_errors as
select step_id, query_id, 'attribute_values' as err_category from magic44_content_differences
where row(step_id, query_id) not in (select step_id, query_id from magic44_count_differences)
group by step_id, query_id;

drop view if exists magic44_errors_assembled;
create view magic44_errors_assembled as
select * from magic44_result_set_size_errors
union
select * from magic44_attribute_value_errors;

drop table if exists magic44_row_count_errors;
create table magic44_row_count_errors
select * from magic44_count_differences
order by query_id, step_id;

drop table if exists magic44_column_errors;
create table magic44_column_errors
select * from magic44_content_differences
order by query_id, step_id, row_hash;

------

create or replace view magic44_correct_steps as
select distinct step_id
from magic44_expected_results
where step_id not in (
	select step_id from magic44_row_count_errors
	union
	select step_id from magic44_column_errors
);

create or replace view magic44_main_success_cases_passed as
select d.query_label
from magic44_test_case_directory as d
join magic44_correct_steps as s
on d.base_step_id = s.step_id;

drop table if exists magic44_autograding_low_level;
create table magic44_autograding_low_level as
select 
	d.query_label,
	d.query_name, 
	d.number_of_steps as total_cases, 
	count(s.step_id) as passed_cases
from magic44_test_case_directory as d
left join magic44_correct_steps as s
on s.step_id >= d.base_step_id
and s.step_id < (d.base_step_id + d.number_of_steps)
where d.scoring_weight > 0 and (
	s.step_id = d.base_step_id
	or d.query_label in (select query_label from magic44_main_success_cases_passed)
	or s.step_id is null
)
group by d.query_label, d.query_name, d.number_of_steps;

-----

drop table if exists magic44_autograding_score_summary;
create table magic44_autograding_score_summary
select query_label, query_name,
	round(scoring_weight * passed_cases / total_cases, 2) as final_score, scoring_weight
from magic44_autograding_low_level natural join magic44_test_case_directory
where passed_cases < total_cases
union
select null, 'REMAINING CORRECT CASES', sum(round(scoring_weight * passed_cases / total_cases, 2)), null
from magic44_autograding_low_level natural join magic44_test_case_directory
where passed_cases = total_cases
union
select null, 'TOTAL SCORE', sum(round(scoring_weight * passed_cases / total_cases, 2)), null
from magic44_autograding_low_level natural join magic44_test_case_directory;

drop table if exists magic44_autograding_high_level;
create table magic44_autograding_high_level
select score_tag, score_category, sum(total_cases) as total_possible,
	sum(passed_cases) as total_passed
from magic44_scores_guide natural join
(select *, mid(query_label, 2, 1) as score_tag from magic44_autograding_low_level) as temp
group by score_tag, score_category; -- order by display_order;

-- Evaluate potential query errors against the original state and the modified state
drop view if exists magic44_result_errs_original;
create view magic44_result_errs_original as
select distinct 'row_count_errors_initial_state' as title, query_id
from magic44_row_count_errors where step_id = 0;

drop view if exists magic44_result_errs_modified;
create view magic44_result_errs_modified as
select distinct 'row_count_errors_test_cases' as title, query_id
from magic44_row_count_errors
where query_id not in (select query_id from magic44_result_errs_original)
union
select * from magic44_result_errs_original;

drop view if exists magic44_attribute_errs_original;
create view magic44_attribute_errs_original as
select distinct 'column_errors_initial_state' as title, query_id
from magic44_column_errors where step_id = 0
and query_id not in (select query_id from magic44_result_errs_modified)
union
select * from magic44_result_errs_modified;

drop view if exists magic44_attribute_errs_modified;
create view magic44_attribute_errs_modified as
select distinct 'column_errors_test_cases' as title, query_id
from magic44_column_errors
where query_id not in (select query_id from magic44_attribute_errs_original)
union
select * from magic44_attribute_errs_original;

drop view if exists magic44_correct_remainders;
create view magic44_correct_remainders as
select distinct 'fully_correct' as title, query_id
from magic44_test_results
where query_id not in (select query_id from magic44_attribute_errs_modified)
union
select * from magic44_attribute_errs_modified;

drop view if exists magic44_grading_rollups;
create view magic44_grading_rollups as
select title, count(*) as number_affected, group_concat(query_id order by query_id asc) as queries_affected
from magic44_correct_remainders
group by title;

drop table if exists magic44_autograding_directory;
create table magic44_autograding_directory (query_status_category varchar(1000));
insert into magic44_autograding_directory values ('fully_correct'),
('column_errors_initial_state'), ('row_count_errors_initial_state'),
('column_errors_test_cases'), ('row_count_errors_test_cases');

drop table if exists magic44_autograding_query_level;
create table magic44_autograding_query_level
select query_status_category, number_affected, queries_affected
from magic44_autograding_directory left outer join magic44_grading_rollups
on query_status_category = title;

drop procedure if exists magic44_check_test_case;
delimiter //
create procedure magic44_check_test_case(in ip_test_case_number integer)
begin
	select * from (select query_id, 'added' as category, row_hash
	from magic44_test_results where step_id = ip_test_case_number and row(query_id, row_hash) not in
		(select query_id, row_hash from magic44_expected_results where step_id = 0)
	union
	select temp.query_id, 'removed' as category, temp.row_hash
	from (select query_id, row_hash from magic44_expected_results where step_id = 0) as temp
	where row(temp.query_id, temp.row_hash) not in
		(select query_id, row_hash from magic44_test_results where step_id = ip_test_case_number)
	and temp.query_id in
		(select query_id from magic44_test_results where step_id = ip_test_case_number)) as unified
	order by query_id, row_hash;
end //
delimiter ;

drop table if exists magic44_table_name_lookup;
create table magic44_table_name_lookup (
	query_id integer,
	table_or_view_name varchar(2000),
    primary key (query_id)
);

insert into magic44_table_name_lookup values
(10, 'album'), (11, 'content'), (12, 'creates'), (13, 'creator'), (15, 'friends'),
(16, 'genres'), (17, 'listener'), (18, 'playlist'), (19, 'makes_up'), (20, 'podcast_episode'),
(21, 'podcast_series'), (22, 'socials'), (23, 'song'), (24, 'subscription'),
(25, 'user');

drop table if exists magic44_autograding_directory;

drop view if exists magic44_grading_rollups;
drop view if exists magic44_correct_remainders;
drop view if exists magic44_attribute_errs_modified;
drop view if exists magic44_attribute_errs_original;
drop view if exists magic44_result_errs_modified;
drop view if exists magic44_result_errs_original;
drop view if exists magic44_errors_assembled;
drop view if exists magic44_attribute_value_errors;
drop view if exists magic44_result_set_size_errors;
drop view if exists magic44_content_differences;
drop view if exists magic44_count_differences;
drop view if exists magic44_count_test_results;
drop view if exists magic44_count_answers;

drop procedure if exists magic44_query_check_and_run;

drop function if exists magic44_query_exists;
drop function if exists magic44_query_capture;
drop function if exists magic44_gen_simple_template;

drop table if exists magic44_column_listing;

drop view if exists practiceQuery10;
drop view if exists practiceQuery11;
drop view if exists practiceQuery12;
drop view if exists practiceQuery13;
drop view if exists practiceQuery14;
drop view if exists practiceQuery15;
drop view if exists practiceQuery16;
drop view if exists practiceQuery17;
drop view if exists practiceQuery18;
drop view if exists practiceQuery19;
drop view if exists practiceQuery20;
drop view if exists practiceQuery21;
drop view if exists practiceQuery22;
drop view if exists practiceQuery23;
drop view if exists practiceQuery24;
drop view if exists practiceQuery25;

drop view if exists magic44_fast_correct_test_cases;
drop view if exists magic44_fast_total_test_cases;
drop view if exists magic44_fast_column_based_errors;
drop view if exists magic44_fast_row_based_errors;
drop view if exists magic44_fast_expected_results;

drop table if exists magic44_scores_guide;

drop table if exists magic44_test_results;
drop view if exists magic44_main_success_cases_passed;
drop view if exists magic44_correct_steps;
drop view if exists magic44_test_case_frequencies;
drop table if exists magic44_test_case_directory;
drop table if exists magic44_table_name_lookup;
drop table if exists magic44_row_count_errors;
drop table if exists magic44_log_query_errors;
drop table if exists magic44_autograding_query_level;
drop table if exists magic44_autograding_low_level;
drop table if exists magic44_autograding_high_level;
drop table if exists magic44_data_capture;
drop table if exists magic44_expected_results;

select * from magic44_autograding_score_summary;