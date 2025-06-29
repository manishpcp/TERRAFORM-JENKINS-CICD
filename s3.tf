# Reference the existing bucket
data "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# Enforce bucket owner control (disable ACLs)
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = data.aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Allow public access via policy instead of ACLs
resource "aws_s3_bucket_policy" "public_read" {
  bucket = data.aws_s3_bucket.mybucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${data.aws_s3_bucket.mybucket.bucket}/*"
      }
    ]
  })
}

# Allow public access settings (just in case)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = data.aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload static files (without ACLs)
resource "aws_s3_object" "index" {
  bucket       = data.aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = data.aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket       = data.aws_s3_bucket.mybucket.id
  key          = "style.css"
  source       = "style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "script" {
  bucket       = data.aws_s3_bucket.mybucket.id
  key          = "script.js"
  source       = "script.js"
  content_type = "application/javascript"
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = data.aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [
    aws_s3_bucket_public_access_block.example,
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_policy.public_read
  ]
}
