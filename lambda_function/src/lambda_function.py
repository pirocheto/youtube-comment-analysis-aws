import json
import os

import boto3
import requests

API_URL = f"https://youtube.googleapis.com/youtube/v3/commentThreads"
BUCKET_NAME = os.environ["BUCKET_NAME"]
API_KEY_SECRET_NAME = os.environ["YOUTUBE_API_KEY_SECRET_NAME"]


def get_video_id(event):
    try:
        video_id = event["video_id"]
        return video_id
    except KeyError:
        raise KeyError(f"The key 'video_id' is missing from the event.")


def get_api_key(secret_name):
    session = boto3.session.Session()
    client = session.client(service_name="secretsmanager")
    response = client.get_secret_value(SecretId=secret_name)
    return response["SecretString"]


def get_page(video_id, page_token=None):

    api_key = get_api_key(
        API_KEY_SECRET_NAME,
    )

    params = {
        "part": "snippet,replies",
        "key": api_key,
        "order": "time",
        "maxResults": 100,
        "videoId": video_id,
        "pageToken": page_token,
    }

    headers = {"Accept": "application/json"}

    response = requests.get(
        API_URL,
        params=params,
        headers=headers,
    )

    if response.status_code != 200:
        raise ValueError(response.json())

    return response.json()


def format_comment(comment):
    comment = {"id": comment["id"], **comment["snippet"]}

    if "authorChannelId" in comment:
        comment["authorChannelId"] = comment["authorChannelId"]["value"]

    return comment


def push_comment(comment, s3):
    comment = format_comment(comment)

    comment_id = comment["id"]
    video_id = comment["videoId"]

    key = f"landing/videoid={video_id}/{comment_id}.json"

    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=key,
        Body=json.dumps(comment),
        ContentType="application/json",
        ContentEncoding="utf8",
    )


def lambda_handler(event, context):
    video_id = get_video_id(event)

    s3 = boto3.client("s3")

    retrieved_comments = 0
    next_page_token = None

    while next_page_token is not False:
        data = get_page(
            video_id=video_id,
            page_token=next_page_token,
        )

        for item in data["items"]:
            comment = item["snippet"]["topLevelComment"]
            push_comment(comment, s3)
            retrieved_comments += 1

            if "replies" in item:
                for comment in item["replies"]["comments"]:
                    push_comment(comment, s3)
                    retrieved_comments += 1

        next_page_token = data.get("nextPageToken", False)

    return {
        "video_id": video_id,
        "bucket": {
            "name": BUCKET_NAME,
            "prefix": f"landing/videoid={video_id}",
        },
        "retrieved_comments": retrieved_comments,
    }
