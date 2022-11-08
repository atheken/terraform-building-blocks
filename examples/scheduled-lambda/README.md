This example shows how to use these modules to create a scheduled lambda.

The "cron-job-container" is the most basic lamdba runtime container that we can make, and simply uses a bash script to implement the Runtime Interface for Lamdba. But any docker container that conforms to this interface can be used.