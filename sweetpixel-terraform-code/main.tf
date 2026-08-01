provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "wallpaper_bucket" {
  bucket = "wallpaper-cloud-project-bucket-1"

  tags = {
    Name        = "WallpaperWebsiteBucket"
    project     = "CloudWallpaperProject"
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.wallpaper_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {

  depends_on = [aws_s3_bucket_public_access_block.allow_public]
  bucket = aws_s3_bucket.wallpaper_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = "*"
      Action = ["s3:GetObject"]
      Resource = "${aws_s3_bucket.wallpaper_bucket.arn}/*"
    }]
  })
}