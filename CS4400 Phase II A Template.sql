-- CS4400: Introduction to Database Systems (Spring 2026)
-- Phase II A: Create Table Statements [v0] [February 9th, 2026]

-- Team 36
-- Phil Abraham (pabraham9)
-- Claire Lee (clee931)
-- Hannah Rajan (hrajan30)

-- Directions:
-- Please follow all instructions for Phase II A as listed in the instructions document.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from a SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'media_streaming_service';
drop database if exists media_streaming_service;
create database if not exists media_streaming_service;
use media_streaming_service;

-- Define the database structures
/* You must enter your tables definitions (with primary, unique, and foreign key declarations,
data types, and check constraints) here.  You may sequence them in any order that 
works for you (and runs successfully). */

drop table if exists content;
create table content (
ContentID varchar(20) not null,
Title varchar(50) not null,
Language varchar(15),
Length int,
Maturity enum('Explicit', 'Not Explicit'),
Release_Date date,
primary key(ContentID)
);

drop table if exists podcast_series;
create table podcast_series (
PodcastID char(7),
Title varchar(50),
Description varchar(300),
primary key(PodcastID)
);

drop table if exists podcast_episode;
create table podcast_episode (
ContentID varchar(20) not null,
Topic varchar(20),
Episode_Number int,
PodcastID char(7),
primary key(ContentID),
foreign key(ContentID) references content(ContentID),
foreign key(PodcastID) references podcast_series(PodcastID)
);

drop table if exists subscription;
create table subscription (
SubscriptionID char(5),
Cost double(5, 2),
Start_Date date,
End_Date date,
primary key(SubscriptionID)
);

drop table if exists individual;
create table individual (
SubscriptionID char(5),
Tier enum('Premium', 'Deluxe'),
foreign key(SubscriptionID) references subscription(SubscriptionID)
);

drop table if exists family;
create table family (
SubscriptionID char(5),
Family_Size int,
foreign key(SubscriptionID) references subscription(SubscriptionID)
);

drop table if exists listener;
create table listener (
AccountID char(6) not null,
Name varchar(30) not null,
BDate date,
Email varchar(50),
Username varchar(30),
Enrolled_Subscription char(5),
Timestamp timestamp,
Stream_ContentID varchar(20),
primary key(AccountID),
foreign key(Enrolled_Subscription) references subscription(SubscriptionID),
foreign key(Stream_ContentID) references content(ContentID)
);

drop table if exists friends;
create table friends (
AccountID char(6) not null,
FriendID char(6) not null,
foreign key(AccountID) references listener(AccountID),
foreign key(FriendID) references listener(AccountID)
);

drop table if exists creator;
create table creator (
AccountID char(6) not null,
Name varchar(30) not null,
BDate date,
Email varchar(50),
Stage_Name varchar(30),
Biography varchar(100),
Pinned_ContentID varchar(20),
primary key(AccountID),
foreign key(Pinned_ContentID) references content(ContentID)
);

drop table if exists creates;
create table creates (
CreatorID char(6) not null,
ContentID varchar(20) not null,
foreign key(CreatorID) references creator(AccountID),
foreign key(ContentID) references content(ContentID)
);

drop table if exists album;
create table album (
Name varchar(30) not null,
CreatorID char(6) not null,
primary key(Name, CreatorID),
foreign key(CreatorID) references creator(AccountID)
);

drop table if exists socials;
create table socials (
CreatorID char(6) not null,
Handle varchar(30),
Platform varchar(20),
foreign key(CreatorID) references creator(AccountID)
);

drop table if exists song;
create table song (
ContentID varchar(20) not null,
Album_Name varchar(30) not null,
Album_CreatorID char(6) not null,
primary key(ContentID),
foreign key(Album_Name, Album_CreatorID) references album(Name, CreatorID)
);

drop table if exists playlist;
create table playlist (
PlaylistID char(5) not null,
Name varchar(30),
ListenerID char(6) not null,
primary key(PlaylistID),
foreign key(ListenerID) references listener(AccountID)
);

drop table if exists makes_up;
create table makes_up (
PlaylistID char(5) not null,
ContentID varchar(20) not null,
Track_Order int,
primary key(PlaylistID),
foreign key(ContentID) references content(ContentID)
);


