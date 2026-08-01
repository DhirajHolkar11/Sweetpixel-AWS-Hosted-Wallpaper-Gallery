const express = require("express");
const multer = require("multer");
const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

const s3 = new S3Client({
  region: "ap-south-1"
});

router.post("/upload", upload.single("image"), async (req, res) => {
  try {

    const file = req.file;

    const params = {
      Bucket: "wallpaper-cloud-project-bucket-1",
      Key: "wallpapers/" + Date.now() + "-" + file.originalname,
      Body: file.buffer,
      ContentType: file.mimetype
    };

    const command = new PutObjectCommand(params);
    await s3.send(command);

    res.json({
      message: "Upload successful",
      imageUrl: `https://wallpaper-cloud-project-bucket-1.s3.amazonaws.com/${params.Key}`
    });

  } catch (error) {
    console.error(error);
    res.status(500).send("Upload failed");
  }
});

module.exports = router;