import boto3
TABLE_NAME = 'cloud_resume_challenge_db'
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    table = dynamodb.Table(TABLE_NAME)

    response = table.put_item(
        Item={
            'id': 1,
            'ts': 'time_stamp_placeholder'
        }
    )
    
    status_code = response['ResponseMetadata']['HTTPStatusCode']
    print(status_code)