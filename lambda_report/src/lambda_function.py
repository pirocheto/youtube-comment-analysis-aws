import json
import os
from datetime import datetime
from pathlib import Path

import boto3
import matplotlib.pyplot as plt
import pandas as pd
from charts import plot_sent_percent, plot_sent_timeline
from report import create_pdf

plt.rcParams["font.family"] = "Helvetica"

BUCKET_NAME = os.environ["BUCKET_NAME"]
ENV = os.environ.get("env", "local")

if ENV == "local":
    root = Path(__file__).parent
    output_dir = root / "output"
elif ENV == "aws":
    output_dir = Path("/tmp")


def get_data(s3, video_id):
    data = []
    bucket = BUCKET_NAME
    result = s3.list_objects_v2(
        Bucket=bucket,
        Prefix=f"processed/videoid={video_id}",
        MaxKeys=30,
    )
    for ele in result.get("Contents"):
        object = s3.get_object(Bucket=bucket, Key=ele.get("Key"))
        contents = object["Body"].read()
        data.append(json.loads(contents))

    df = pd.DataFrame(data)
    return df


def create_charts(df):
    paths = {
        "chart_sent_percent": output_dir / "chart_sent_percent.png",
        "chart_sent_timeline": output_dir / "chart_sent_timeline.png",
    }

    plt.figure(figsize=(10, 2))
    plot_sent_percent(df)
    plt.tight_layout()
    plt.savefig(paths["chart_sent_percent"], transparent=True)

    plt.figure(figsize=(10, 5))
    plot_sent_timeline(df)
    plt.tight_layout()
    plt.savefig(paths["chart_sent_timeline"], transparent=True)

    return paths


def push_report(s3, report_path):
    s3.upload_file(report_path, BUCKET_NAME, "reports/hello_world.pdf")


def get_video_id(event):
    try:
        video_id = event["video_id"]
        return video_id
    except KeyError:
        raise KeyError(f"The key 'video_id' is missing from the event.")


def lambda_handler(event, context):
    video_id = get_video_id(event)
    s3 = boto3.client("s3")

    df = get_data(s3, video_id=video_id)
    date_first_comment = df["publishedAt"].sort_values()[0]

    chart_paths = create_charts(df)

    report_path = create_pdf(
        output_dir / "hellow_world.pdf",
        video_id=video_id,
        total_comments=df.shape[0],
        date_first_comment=date_first_comment,
        **chart_paths,
    )

    s3.upload_file(report_path, BUCKET_NAME, "reports/hello_world.pdf")


if __name__ == "__main__":
    lambda_handler({"video_id": "Ps5kScYvQQk"}, None)
