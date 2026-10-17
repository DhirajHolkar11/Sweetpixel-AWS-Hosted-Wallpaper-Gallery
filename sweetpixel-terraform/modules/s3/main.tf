resource "aws_s3_bucket" "wallpaper_bucket" {
  bucket = var.bucket_name

  tags = {
    Name    = "Sweetpixel-Wallpaper-Bucket"
    Project = "Sweetpixel"
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.wallpaper_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "wallpaper" {
  bucket = aws_s3_bucket.wallpaper_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
