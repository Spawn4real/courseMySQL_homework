/*Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.*/
select count(*) total_messages, friend from
	(select body, to_user_id as friend from messages where from_user_id = 1
	 union
	 select body,from_user_id as friend from messages where to_user_id = 1) as history

group by friend
order by total_messages desc
limit 1


/*Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.*/
select sum(likes) 
from (select count(*) as likes
	  from likes, profiles
	  where photo_id = profiles.user_id
group by photo_id
order by profiles.birthday desc
limit 10) as countlikes
	  

/*Определить кто больше поставил лайков (всего): мужчины или женщины.*/	  
select count(*) as likes, gender from likes, profiles
	where likes.user_id = profiles.user_id
group by gender;