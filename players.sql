SET SQL_SAFE_UPDATES = 0;
SET optimizer_switch = 'derived_merge=off';

Drop database if exists players;
create database players;
use players;

# Table for PS players
CREATE TABLE users_ps( id smallint unsigned not null auto_increment, name varchar(20) not null, password varchar(20) not null, console varchar(5) not null, constraint pk_example primary key (id) );
INSERT INTO  users_ps( id, name, password, console) VALUES ( null, 'simona', 'pass1', 'PS');
INSERT INTO  users_ps( id, name, password, console) VALUES ( null, 'PS_user2' 'pass2', 'PS');
INSERT INTO  users_ps( id, name, password, console) VALUES ( null, 'PS_user3', 'pass3', 'PS');
INSERT INTO  users_ps( id, name, password, console) VALUES ( null, 'PS_user4', 'pass4', 'PS');
select * from users_ps;

# Table for PC players
CREATE TABLE users_pc( id smallint unsigned not null auto_increment, name varchar(20) not null, password varchar(20) not null, console varchar(5) not null, constraint pk_example primary key (id) );
INSERT INTO  users_pc( id, name, password, console) VALUES ( null, 'simona', 'pass1', 'PC');
INSERT INTO  users_pc( id, name, password, console) VALUES ( null, 'PC_user2', 'pass2', 'PC');
INSERT INTO  users_pc( id, name, password, console) VALUES ( null, 'PC_user3', 'pass3', 'PC');
INSERT INTO  users_pc( id, name, password, console) VALUES ( null, 'PC_user4', 'pass4', 'PC');
select * from users_pc;

# Table after Merge (PS + PC players+Items)
drop table if exists users;
CREATE TABLE users( id smallint unsigned not null auto_increment, name varchar(20) not null, password varchar(20) not null, console varchar(5) not null, constraint pk_example primary key (id) );
insert into users(select null, name, password, console from users_pc);
insert into users(select null, name, password, console from users_ps);
select * from users;

# if a username exists >1 times, replace the name with a new unique name
UPDATE users n 
  JOIN (SELECT name, MIN(id) min_id FROM users GROUP BY name HAVING COUNT(*) > 1) d
    ON n.name = d.name AND n.id <> d.min_id
SET n.name = CONCAT(n.name, n.ID);

# items table
drop table if exists items;
CREATE TABLE items( id smallint unsigned not null auto_increment, name varchar(25) not null, stats varchar(25) not null, image text not null, constraint pk_example primary key (id) );
INSERT INTO  items( id, name, stats) VALUES ( null, 'Common Sword', '+1 Strength');
INSERT INTO  items( id, name, stats) VALUES ( null, 'Epic Sword', '+2 Strength');
INSERT INTO  items( id, name, stats) VALUES ( null, 'Common Staff', '+1 Magic');
INSERT INTO  items( id, name, stats) VALUES ( null, 'Legendary Armor', '+3 Armor');
INSERT INTO  items( id, name, stats) VALUES ( null, 'Common Armor', '+1 Armor');

# Give some items to the users
CREATE TABLE usersitems(id smallint unsigned not null auto_increment, userID int(11) not null, itemID int(11) not null, constraint pk_example primary key (id));
INSERT INTO usersitems(id, userID, itemID) VALUES
(null, 1, 1),
(null, 1, 2),
(null, 2, 1),
(null, 2, 4),
(null, 3, 5),
(null, 4, 1),
(null, 4, 5);