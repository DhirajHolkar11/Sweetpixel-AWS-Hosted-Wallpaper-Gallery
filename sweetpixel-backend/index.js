const express = require("express");
const app = express();
const port = 3000;
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