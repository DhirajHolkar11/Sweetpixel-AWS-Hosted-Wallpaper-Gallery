
const express = require("express");
const router = express.Router();

const {
  S3Client,
  ListObjectsV2Command
} = require("@aws-sdk/client-s3");

const s3 = new S3Client({
  region: process.env.AWS_REGION
});

const allowedExtensions = new Set([
  ".jpg",
  ".jpeg",
  ".png",
  ".webp",
  ".gif"
]);

router.get("/images", async (req, res) => {
  try {
    if (!process.env.AWS_BUCKET_NAME || !process.env.CLOUDFRONT_URL) {
      return res.status(500).json({
        error: "Image storage configuration is missing."
      });
    }

    const images = [];
    let continuationToken;

    // Read every page of S3 results, not just the first 1,000 objects.
    do {
      const response = await s3.send(
        new ListObjectsV2Command({
          Bucket: process.env.AWS_BUCKET_NAME,
          Prefix: "wallpapers/",
          ContinuationToken: continuationToken
        })
      );

      for (const file of response.Contents || []) {
        if (!file.Key || file.Key.endsWith("/")) {
          continue;
        }

        const extension = require("path")
          .extname(file.Key)
          .toLowerCase();

        if (allowedExtensions.has(extension)) {
          const key = file.Key
            .split("/")
            .map(encodeURIComponent)
            .join("/");

          images.push(
            `${process.env.CLOUDFRONT_URL.replace(/\/+$/, "")}/${key}`
          );
        }
      }

      continuationToken = response.IsTruncated
        ? response.NextContinuationToken
        : undefined;
    } while (continuationToken);

    res.json(images);
  } catch (error) {
    console.error("Error fetching images:", error);

    res.status(500).json({
      error: "Error fetching images."
    });
  }
});

module.exports = router;