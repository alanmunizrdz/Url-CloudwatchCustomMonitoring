`WebSite Monitoring Script`

IMPORTANT:
To make this work you need to configure your AWS-CLI with the correct permissions.
By: Alan Muniz

```
This script consult all the URL for domains that are contained in the $route,
It extract the url from all the Sugarcrm instances in the $route.
Get the url without , and '  and check the HTTP code and if it is different from redirection or 200
Sends a metrics message to AWS Cloudwatch and metrics to AWS Cloudwatch
```


`Cron setup`

For the user that you are running the AWS-cli
```
> crontab -e 
```

Set the cron as:
This will run every 10 minutes
```
*/10 * * * *  cd /route/of/script && ./website-check.sh
```
