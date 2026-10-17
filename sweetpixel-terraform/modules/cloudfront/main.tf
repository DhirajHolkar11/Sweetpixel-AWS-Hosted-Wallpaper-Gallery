resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "sweetpixel-s3-oac"
  description                       = "Secure access from CloudFront to the Sweetpixel S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "Sweetpixel Wallpaper CDN"

  origin {
    domain_name              = var.bucket_domain_name
    origin_id                = "sweetpixel-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  default_cache_behavior {
    target_origin_id       = "sweetpixel-s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

    viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = {
    Project = "Sweetpixel"
  }
}
