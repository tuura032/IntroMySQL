CREATE database if not exists forum;

use forum;

drop table if exists comments;
drop table if exists posts;
drop table if exists users;

CREATE TABLE users (
	id int(11) not null auto_increment,
	username varchar(20) not null,
	email varchar(30) not null,
	password varchar(30) not null,
	first_name varchar(20),
	last_name varchar(20),
	primary key (id)
);

CREATE TABLE posts (
	id int(11) not null auto_increment,
	user_id int(11) not null,
	post text not null,
	post_date datetime default current_timestamp,
	primary key (id),
	foreign key (user_id) references users(id)
);

CREATE TABLE comments (
	id int(11) not null auto_increment,
	user_id int(11) not null,
	post_id int(11) not null,
	comment text not null,
	comment_date datetime default current_timestamp,
	primary key (id),
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
);