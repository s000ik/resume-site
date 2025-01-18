import json
import boto3
from decimal import Decimal

# Initialize DynamoDB resource and table
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('cloud-resume-table-but-terraformed')

def lambda_handler(event, context):
    # Enabling CORS by defining allowed origins
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
    }

    try:
        # Increment view count
        response = table.update_item(
            Key={'ID': '0'},
            UpdateExpression="SET view_count = if_not_exists(view_count, :start) + :val",
            ExpressionAttributeValues={':val': Decimal(1), ':start': Decimal(0)},
            ReturnValues="UPDATED_NEW"
        )

        # Fetch updated view count
        record_count = response['Attributes']['view_count']

        # Convert Decimal to float for JSON serialization
        record_count_float = float(record_count)
        
        # Return JSON response with updated view count
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({'views': record_count_float})
        }
    
    except Exception as e:
        # Return error response
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': str(e)})
        }
