# ------------- AWS S3 Bucket ------------- #

data "aws_s3_bucket" "s3_existing_bucket" {
    bucket =  "${var.project_name}"
}


resource "aws_s3_bucket_versioning" "s3_versioning" {
    bucket = data.aws_s3_bucket.s3_existing_bucket.bucket
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_public_access_block" "aws_s3_public_block" {
    bucket = data.aws_s3_bucket.s3_existing_bucket.bucket
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false  
}


#Iam S3 bucket policy

data "aws_iam_policy_document" "aws_s3_iam_policy" {
    statement {
      principals {
        type = "AWS"
        identifiers = [ "arn:aws:iam::354918403356:root" ]
      }
      actions = [ 
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
       ]
       resources = [ 
        data.aws_s3_bucket.s3_existing_bucket.arn,
       "${data.aws_s3_bucket.s3_existing_bucket.arn}/*",
        ]

    }
}

resource "aws_s3_bucket_policy" "aws_s3_policy" {
    bucket = data.aws_s3_bucket.s3_existing_bucket.id
    policy = data.aws_iam_policy_document.aws_s3_iam_policy.json
}


# ------------- AWS Glue ------------- #

resource "aws_glue_catalog_database" "glue_project_db" {
    name = "${var.project_name}-db"
}


# ------------- AWS Glue Crawler ------------- #

data "aws_iam_policy_document" "assume_role_policy"{
    statement {
      effect = "Allow"
      actions = ["sts:AssumeRole" ]
      principals {
        type = "Service"
        identifiers = [ "glue.amazonaws.com" ]
      }
    }
}

resource "aws_iam_role" "aws_glue_service_role" {
    name = "glue_crawler_${var.project_name}-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
    tags = {
      Application = var.project_name
    }
}

resource "aws_iam_role_policy_attachment" "glue_s3_access" {
    role = aws_iam_role.aws_glue_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_execution_role" {
  role = aws_iam_role.aws_glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}


#Crawler 
resource "aws_glue_crawler" "glue_crawler" {
    database_name = aws_glue_catalog_database.glue_project_db.name
    name = "${var.project_name}-crawler"
    role = aws_iam_role.aws_glue_service_role.arn

    s3_target {
      path = "s3://${data.aws_s3_bucket.s3_existing_bucket.id}/data"
    }

    table_prefix = "csv_"

    depends_on = [ 
        aws_iam_role_policy_attachment.glue_s3_access,
        aws_iam_role_policy_attachment.glue_execution_role
     ]
}