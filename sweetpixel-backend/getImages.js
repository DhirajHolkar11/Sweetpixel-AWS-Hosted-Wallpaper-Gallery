
const express = require("express");
const router = express.Router();

const { S3Client, ListObjectsV2Command } = require("@aws-sdk/client-s3");

const s3 = new S3Client({
    region: process.env.AWS_REGION
});

router.get("/images", async (req,res) => {

    try{

        const command = new ListObjectsV2Command({
            Bucket: process.env.AWS_BUCKET_NAME,
            // Prefix:"wallpapers/"
        });

        const data = await s3.send(command);

        // console.log("s3 response:", data);

        const images = (data.Contents || []).map(file =>
            `${process.env.CLOUDFRONT_URL}/${file.Key}`
        );

        res.json(images);

    }catch(error){
        console.log(error);
        res.status(500).send("Error fetching images");
    }

});

module.exports = router;