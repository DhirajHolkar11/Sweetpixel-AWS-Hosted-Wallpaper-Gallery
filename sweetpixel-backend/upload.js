
const express = require("express");
const multer = require("multer");
const crypto = require("crypto");
const path = require("path");
const {
  S3Client,
  PutObjectCommand
} = require("@aws-sdk/client-s3");

const router = express.Router();

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024 // 5 MB
  },
  fileFilter: (req, file, callback) => {
    const allowedTypes = [
      "image/jpeg",
      "image/png",
      "image/webp",
      "image/gif"
    ];

    if (!allowedTypes.includes(file.mimetype)) {
      return callback(
        new Error("Only JPEG, PNG, WebP, and GIF images are allowed.")
      );
    }

    callback(null, true);
  }
});

const s3 = new S3Client({
  region: process.env.AWS_REGION
});

router.post(
  "/upload",
  upload.single("image"),
  async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({
          error: "Please select an image to upload."
        });
      }

      if (!process.env.AWS_BUCKET_NAME) {
        return res.status(500).json({
          error: "S3 bucket configuration is missing."
        });
      }

      if (!process.env.CLOUDFRONT_URL) {
        return res.status(500).json({
          error: "CloudFront configuration is missing."
        });
      }

      const extension = path.extname(req.file.originalname)
        .toLowerCase();

      const allowedExtensions = [
        ".jpg",
        ".jpeg",
        ".png",
        ".webp",
        ".gif"
      ];

      const safeExtension = allowedExtensions.includes(extension)
        ? extension
        : "";

      const key = `wallpapers/${crypto.randomUUID()}${safeExtension}`;

      await s3.send(
        new PutObjectCommand({
          Bucket: process.env.AWS_BUCKET_NAME,
          Key: key,
          Body: req.file.buffer,
          ContentType: req.file.mimetype
        })
      );

      const cloudFrontUrl =
        `${process.env.CLOUDFRONT_URL.replace(/\/+$/, "")}/${key}`;

      return res.status(201).json({
        message: "Upload successful",
        imageUrl: cloudFrontUrl
      });
    } catch (error) {
      console.error("Image upload failed:", error);

      return res.status(500).json({
        error: "Image upload failed."
      });
    }
  }
);

module.exports = router;