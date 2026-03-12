-- CS4400: Introduction to Database Systems (Spring 2026)
-- Phase III Init File
-- Do not modify this file!!!

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set session SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'media_streaming_service';
drop database if exists media_streaming_service;
create database if not exists media_streaming_service;
use media_streaming_service;


-- User Table
drop table if exists user;
create table user ( 
	accountID varchar(20) not null,
    name varchar(100) not null, 
    bdate date not null, 
    email varchar(200) not null, 
    primary key (accountID)
);

-- Content Table
drop table if exists content;
create table content ( 
	contentID varchar(20) not null,
    title varchar(100) not null,
    content_length int not null check (content_length >= 60),
    maturity enum('Not Explicit', 'Explicit') not null,
    content_language varchar(50) not null,
    release_date date not null,
    primary key (contentID)
);

-- Creator Table
drop table if exists creator;
create table creator ( 
	accountID varchar(20) not null,
    stage_name varchar(100),
    biography varchar(200),
    pinned varchar(20),
    primary key (accountID),
    foreign key (accountID) references user (accountID) on update cascade on delete cascade,
    foreign key (pinned) references content (contentID) on update cascade on delete set null
);

-- Album Table
drop table if exists album;
create table album ( 
    creatorID varchar(20) not null,
    album_name varchar(100) not null,
    primary key (creatorID, album_name),
    foreign key (creatorID) references creator (accountID) on update cascade on delete cascade
);

-- Song Table
drop table if exists song;
create table song ( 
	contentID varchar(20) not null,
    creatorID varchar(20),
    album_name varchar(100),
    primary key (contentID),
    foreign key (contentID) references content (contentID) on update cascade on delete cascade,
    foreign key (creatorID, album_name) references album (creatorID, album_name) on update cascade on delete set null
);

-- Subscription Table
drop table if exists subscription;
create table subscription ( 
	subscriptionID varchar(20) not null,
    cost decimal(5,2) not null check(cost > 0),
    start_date date not null,
    end_date date not null,
    tier varchar(50),
    max_family_size integer check(max_family_size > 1),
    subscription_type enum('Individual', 'Family') not null,
    primary key(subscriptionID)
);

-- Listener Table
drop table if exists listener;
create table listener ( 
	accountID varchar(20) not null, 
    username varchar(100) not null,
    streams varchar(20),
    timestamp int check(timestamp >= 0 and timestamp <= 600),
    subscription varchar(20),
    primary key(accountID),
    unique key (username),
    foreign key (accountID) references user (accountID) on update cascade on delete cascade,
    foreign key (streams) references content (contentID) on update cascade on delete set null,
    foreign key (subscription) references subscription (subscriptionID) on update cascade on delete set null
);

-- Playlist Table
drop table if exists playlist;
create table playlist ( 
	playlistID varchar(20) not null,
    name varchar(100) not null,
    listenerID varchar(20),
    primary key(playlistID),
    foreign key (listenerID) references listener (accountID) on update cascade on delete cascade
);

-- Podcast Series Table
drop table if exists podcast_series;
create table podcast_series ( 
	podcastID varchar(20) not null,
    title varchar(100) not null,
    description varchar(200),
    primary key(podcastID)
);

-- Podcast Episode Table
drop table if exists podcast_episode;
create table podcast_episode ( 
	contentID varchar(20) not null,
	podcastID varchar(20) not null,
    topic varchar(50) not null,
    episode_number integer not null check (episode_number > 0),
    primary key(contentID),
    foreign key (contentID) references content (contentID) on update cascade on delete cascade,
    foreign key (podcastID) references podcast_series (podcastID) on update cascade on delete cascade
);

-- Songs Make Up Playlist Table
drop table if exists makes_up;
create table makes_up ( 
	songID varchar(20) not null,
    playlistID varchar(20) not null,
    track_order int not null check (track_order > 0),
    primary key (songID, playlistID),
    foreign key (songID) references song (contentID) on update cascade on delete cascade,
    foreign key (playlistID) references playlist (playlistID) on update cascade on delete cascade
);

-- Creator Creates Content Table
drop table if exists creates;
create table creates ( 
	contentID varchar(20) not null,
    creatorID varchar(20) not null,
    primary key (contentID, creatorID),
    foreign key (contentID) references content (contentID) on update cascade on delete cascade,
    foreign key (creatorID) references creator (accountID) on update cascade on delete restrict
);

-- Listener Friends Listener Table
drop table if exists friends;
create table friends ( 
	friender varchar(20) not null,
    friendee varchar(20) not null,
    primary key (friender, friendee),
    foreign key (friender) references listener (accountID) on update cascade on delete cascade,
    foreign key (friendee) references listener (accountID) on update cascade on delete cascade
);

-- Social Media Table
drop table if exists socials;
create table socials (
    creatorID varchar(20) not null,
    platform varchar(50) not null,
	handle varchar(50) not null,
    primary key (creatorID, platform, handle),
    foreign key (creatorID) references creator (accountID) on update cascade on delete cascade
);

-- Genres Table
drop table if exists genres;
create table genres ( 
	songID varchar(20) not null,
    genre varchar(50) not null,
    primary key (songID, genre),
    foreign key (songID) references song (contentID) on update cascade on delete cascade
);

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