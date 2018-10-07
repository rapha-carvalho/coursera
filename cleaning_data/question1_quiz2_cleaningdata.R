library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make my own application, register at 
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("Coursera Aplication",
                   key = "988c39b6f529d11170df",
                   secret = "0babf419e99cfa6897977c936937c727c50550c1")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("Coursera Aplication"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)

# OR:
req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)