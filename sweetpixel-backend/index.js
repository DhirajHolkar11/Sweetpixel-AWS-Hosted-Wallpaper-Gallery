
const dotenv = require("dotenv");
dotenv.config();

const express = require("express");
const app = express();
const port = process.env.PORT;
const cors = require("cors");
const uploadRoutes = require("./upload");
const imageRoutes = require("./getImages");

app.use(cors());
app.use(express.json());
app.use("/api", uploadRoutes);
app.use("/api",imageRoutes);

app.listen(port,()=>{
    console.log("server is running on port " + port);
})