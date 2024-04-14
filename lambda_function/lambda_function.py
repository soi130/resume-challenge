import json
import boto3
from datetime import datetime

TABLE_NAME = 'cloud_resume_challenge_db'
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(TABLE_NAME)

now = str(datetime.now())
print(f'Current Server Time = {now}')

def lambda_handler(event, context):
    
    exist = table.get_item(Key={
                    'id':1
                })
    last_view = exist['Item']['views']
    current_view_count = last_view+1
    
    response = table.put_item(Item={
            'id':1,
            'ts': now,
            'views': current_view_count
        })
        
    current_table = table.get_item(Key={
                    'id':1
                })    
    
    return_pack = {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": { "Ts": now},
        "body": {
            'before_update':exist,
            'after_update': current_table
        }
    }
            
    return return_pack
