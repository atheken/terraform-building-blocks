#!/usr/bin/env python3.8
import json

def job(event, context):
    # this script can do something interesting, by writing a json object to STDOUT, 
    # if logs are ingested by Cloudwatch, we get structured logging that can be used to
    # monitor job success.

    print(json.dumps({"status": 0,
                      "message": "The cronjob completed!"
                      }))
