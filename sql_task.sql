CREATE TEMP TABLE users(id bigserial, group_id bigint);
INSERT INTO users(group_id) VALUES (1), (1), (1), (2), (1), (3);

WITH ranges AS
    (
    SELECT id, group_id,
           ROW_NUMBER() OVER(ORDER BY id)
             - ROW_NUMBER() OVER(ORDER BY group_id, id) AS grp
    FROM users
)
select min(id) as min_id, group_id, count(group_id)
from ranges
GROUP BY group_id, grp
ORDER BY min_id