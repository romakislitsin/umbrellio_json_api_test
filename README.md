# Umbrellio Test Json Api 

[Test task](https://docs.google.com/document/d/1W1it49ltCFzmF4We5cIYEXopN62scJ3OI7WBgnhXdsQ/edit)

### Create new post:

 - Request: 
 ```bash
curl -d '{"title": "Post Title", "content": "Post content", "user_ip": "127.0.0.1", "login": "username"}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/v1/new_post.json
```

- Success response:
```json
{
  "id": 1,
  "title": "Post Title",
  "content": "Post content",
  "average_rating": 0.0,
  "user_id": 1,
  "user_ip": {
    "family": 2,
    "addr": 2130706433,
    "mask_addr":4294967295
    }
  }
```

- Fail response:
```json
[["title", "Can't be blank"], ["content", "Can't be blank"], ["login", "Can't be blank"]]
```

### Evaluate the post:

 - Request: 
 ```bash
curl -d '{"post_id": "1", "rate": 5}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/v1/estimate.json
```

- If successful, returns the average rating of the post

- If failed, returns the array with errors:
```json
["Can't find post with id 343'"]
```

### Get N posts ordered by rating:

- Request: 
 ```bash
curl -d '{"count": 5}' -H "Content-Type: application/json" -X GET http://localhost:3000/api/v1/index.json
```

- Returns an array of N posts in descending order (all posts if N not specified)

### Get a list of IP addresses from which several different authors post:

- Request: 
 ```bash
curl -H "Content-Type: application/json" -X GET http://localhost:3000/api/v1/by_ip.json
```

- Returns an array of authors logins grouped by IP address
