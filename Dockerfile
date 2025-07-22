2025-Jul-22 18:33:18.818994
To check the current progress, click on Show Debug Logs.
2025-Jul-22 18:33:19.500968
Oops something is not okay, are you okay? 😢
2025-Jul-22 18:33:19.504325
#0 building with "default" instance using docker driver
2025-Jul-22 18:33:19.504325
2025-Jul-22 18:33:19.504325
#1 [internal] load build definition from Dockerfile
2025-Jul-22 18:33:19.504325
#1 transferring dockerfile: 2.18kB done
2025-Jul-22 18:33:19.504325
#1 DONE 0.0s
2025-Jul-22 18:33:19.504325
Dockerfile:56
2025-Jul-22 18:33:19.504325
--------------------
2025-Jul-22 18:33:19.504325
54 |     ENV MCPO_API_KEY="your-secret-mcpo-api-key"
2025-Jul-22 18:33:19.504325
55 |     ENV MCPO_PORT=8000
2025-Jul-22 18:33:19.504325
56 | >>> ENV BRAVE_API_KEY="your-brave-search-api-key" # <--- YOU MUST SET THIS IN COOLIFY!
2025-Jul-22 18:33:19.504325
57 |
2025-Jul-22 18:33:19.504325
58 |     # Command to run mcpo, passing the Brave Search MCP's stdio command.
2025-Jul-22 18:33:19.504325
--------------------
2025-Jul-22 18:33:19.504325
ERROR: failed to solve: Syntax error - can't find = in "#". Must be of the form: name=value
2025-Jul-22 18:33:19.504325
exit status 1
2025-Jul-22 18:33:19.507291
Deployment failed. Removing the new version of your application.
2025-Jul-22 18:33:19.881594
Gracefully shutting down build container: twogw84k4gw48wwog40o4cow
