const express = require("express");
const router = express.Router();

const { S3Client, ListObjectsV2Command } = require("@aws-sdk/client-s3");

const s3 = new S3Client({ region: "ap-south-1" });

router.get("/images", async (req,res) => {

    try{

        const command = new ListObjectsV2Command({
            Bucket:"wallpaper-cloud-project-bucket-1",
            Prefix:"wallpapers/"
        });

        const data = await s3.send(command);

        const images = data.Contents.map(file => 
            // `https://wallpaper-cloud-project-bucket-1.s3.amazonaws.com/${file.Key}`
            `https://d89etm64z8ho5.cloudfront.net/${file.Key}`
        );

        res.json(images);

    }catch(error){
        console.log(error);
        res.status(500).send("Error fetching images");
    }

});

module.exports = router;