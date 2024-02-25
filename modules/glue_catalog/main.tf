resource "aws_glue_catalog_database" "database" {
  name        = var.catalog_database_name
  description = "Database for glue catalog containing youtube comments"
  tags        = var.tags
}

resource "aws_glue_catalog_table" "table" {
  name          = var.catalog_table_name
  database_name = aws_glue_catalog_database.database.name
  table_type    = "MANAGED_TABLE"

  partition_keys {
    name    = "videoid"
    type    = "string"
    comment = "Video ID"
  }

  storage_descriptor {
    location      = "s3://${var.bucket_name}/processed/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    columns {
      name    = "textdisplay"
      type    = "string"
      comment = "Text displayed"
    }

    columns {
      name    = "authorprofileimageurl"
      type    = "string"
      comment = "URL of author's profile image"
    }

    columns {
      name    = "sentimentscorenegative"
      type    = "double"
      comment = "Negative sentiment score"
    }

    columns {
      name    = "publishedat"
      type    = "string"
      comment = "Date of publication"
    }

    columns {
      name    = "authorchannelid"
      type    = "string"
      comment = "Author's channel ID"
    }

    columns {
      name    = "likecount"
      type    = "int"
      comment = "Count of likes"
    }

    columns {
      name    = "textoriginal"
      type    = "string"
      comment = "Original text"
    }

    columns {
      name    = "authordisplayname"
      type    = "string"
      comment = "Author's display name"
    }

    columns {
      name    = "sentiment"
      type    = "string"
      comment = "Sentiment"
    }

    columns {
      name    = "canrate"
      type    = "boolean"
      comment = "Whether rating is possible"
    }

    columns {
      name    = "sentimentscorepositive"
      type    = "double"
      comment = "Positive sentiment score"
    }

    columns {
      name    = "sentimentscoremixed"
      type    = "double"
      comment = "Mixed sentiment score"
    }

    columns {
      name    = "authorchannelurl"
      type    = "string"
      comment = "URL of author's channel"
    }

    columns {
      name    = "sentimentscoreneutral"
      type    = "double"
      comment = "Neutral sentiment score"
    }

    columns {
      name    = "id"
      type    = "string"
      comment = "ID"
    }

    columns {
      name    = "channelid"
      type    = "string"
      comment = "Channel ID"
    }

    columns {
      name    = "viewerrating"
      type    = "string"
      comment = "Viewer's rating"
    }

    columns {
      name    = "updatedat"
      type    = "string"
      comment = "Date of update"
    }

    columns {
      name    = "parentid"
      type    = "string"
      comment = "Parent ID"
    }
  }
}
