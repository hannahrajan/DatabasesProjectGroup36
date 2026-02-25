-- CS4400: Introduction to Database Systems (Spring 2026)
-- Phase II B Create Table Statements
-- Do not modify this file!

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
    content_length int not null check (content_length >= 60 and content_length <= 3600),
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