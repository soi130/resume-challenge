import json
import boto3
from datetime import datetime
from decimal import Decimal

#class to convert decimal to string
class DecimalEncoder(json.JSONEncoder):
  def default(self, obj):
    if isinstance(obj, Decimal):
      return str(obj)
    return json.JSONEncoder.default(self, obj)

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
            'before_update':json.dumps(exist),
            'after_update': json.dumps(current_table)
    }

    result = json.dumps(return_pack,cls=DecimalEncoder)
            
    return return_pack
