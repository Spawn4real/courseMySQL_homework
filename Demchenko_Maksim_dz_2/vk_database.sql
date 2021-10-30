drop database if exists vk;
create database vk;
use vk;

drop table if exists users;
create table users (
	id serial primary key, -- bigint unsigned not null auto_increment 
	firstname varchar(100),
	lastname varchar(100) comment 'Фамилия',
	email varchar(120) unique,
	password_hash varchar(100),
	phone bigint unsigned,
	index users_lastname_firstname_idx(lastname, firstname)
);


drop table if exists `profiles`;
create table `profiles`(
	user_id serial primary key,
	gender char(1),
	birthday date,
	photo_id bigint unsigned null,
	created_at datetime default now()
);

alter table profiles add constraint fk_user_id 
foreign key (user_id) references users(id) on update cascade on delete cascade;

drop table if exists messages;
create table messages (
	id serial primary key,
	from_user_id bigint unsigned not null,
	to_user_id bigint unsigned not null,
	body text,
	created_at datetime default now(),
	foreign key (from_user_id) references users(id) on update cascade on delete cascade,
	foreign key (to_user_id) references users(id) on update cascade on delete cascade
);

drop table if exists friend_requests;
create table friend_requests (
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	`status` enum ('requseted', 'approved', 'declined', 'unfriended'),
	requested_at datetime default now(),
	updated_at datetime on update now(),
	primary key (initiator_user_id, target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
);

drop table if exists communities;
create table communities (
	id serial primary key,
	name varchar(150),
	admin_user_id bigint unsigned,
	
	index communities_name_idx(name),
	foreign key (admin_user_id) references users(id) on update cascade on delete set null
);

drop table if exists users_communities;
create table users_communities (
	user_id bigint unsigned not null,
	community_id bigint unsigned not null,
	
	primary key (user_id, community_id),
	foreign key(user_id) references users(id) on update cascade on delete cascade,
	foreign key(community_id) references communities(id) on update cascade on delete cascade
);

drop table if exists media_types;
create table media_types (
	id serial primary key,
	name varchar(255)
);

drop table if exists media;
create table media (
	id serial primary key,
	user_id bigint unsigned not null,
	body text,
	-- filename blob,
	filename varchar(255),
	`size` int,
	-- metadata json,
	media_type_id bigint unsigned,
	created_at datetime default now(),
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key(user_id) references users(id) on update cascade on delete cascade,
	foreign key(media_type_id) references media_types(id) on update cascade on delete set null
	
);

drop table if exists likes;
create table likes(
	id serial primary key,
    user_id bigint unsigned not null,
    media_id bigint unsigned not null,
    created_at datetime default now(),
    foreign key(user_id) references users(id) on update cascade on delete cascade,
    foreign key(media_id) references media(id) on update cascade on delete cascade
);

drop table if exists `photo_albums`;
create table `photo_albums` (
	`id` serial,
	`name` varchar(255) default null,
    `user_id` BIGINT unsigned default null,

    foreign key (user_id) references users(id) on update cascade on delete set null,
  	primary key (`id`)
);

drop table if exists `photos`;
create table `photos` (
	id serial primary key,
	`album_id` bigint unsigned not null,
	`media_id` bigint unsigned not null,

	foreign key (album_id) references photo_albums(id) on update cascade on delete cascade,
    foreign key (media_id) references media(id) on update cascade on delete cascade
);

alter table `profiles` add constraint fk_photo_id
    foreign key (photo_id) references photos(id)
    on update cascade on delete set null;


/* Написать cкрипт, добавляющий в БД vk, которую создали на 3 вебинаре, 3-4 новые таблицы (с перечнем полей, указанием индексов и внешних ключей).
(по желанию: организовать все связи 1-1, 1-М, М-М) */

drop table if exists repost;
create table repost(
	id serial primary key,
    from_user_id bigint unsigned not null,
    to_user_id bigint unsigned not null,
    media_id bigint unsigned not null,
    created_at datetime default now(),
    foreign key (from_user_id) references users(id) on update cascade on delete cascade,
	foreign key (to_user_id) references users(id) on update cascade on delete cascade,
    foreign key(media_id) references media(id) on update cascade on delete cascade
);


drop table if exists comment;
create table comment(
	id serial primary key,
	from_user_id bigint unsigned not null,
    to_user_id bigint unsigned not null,
	body text,
	media_id bigint unsigned not null,
	created_at datetime default now(),
	foreign key (from_user_id) references users(id) on update cascade on delete cascade,
	foreign key (to_user_id) references users(id) on update cascade on delete cascade,
	foreign key(media_id) references media(id) on update cascade on delete cascade
);


drop table if exists gift;
create table gift(
	id serial primary key,
	from_user_id bigint unsigned not null,
    to_user_id bigint unsigned not null,
	body text,
	created_at datetime default now(),
	foreign key (from_user_id) references users(id) on update cascade on delete cascade,
	foreign key (to_user_id) references users(id) on update cascade on delete cascade
);











