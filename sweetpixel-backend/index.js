const dotenv = require("dotenv");
dotenv.config();

const express = require("express");
const cors = require("cors");

const app = express();
const port = process.env.PORT || 3000;

const uploadRoutes = require("./upload");
const imageRoutes = require("./getImages");

app.use(cors());
app.use(express.json());

// Lightweight health check for the ALB.
// This checks the application process, not S3 availability.
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

app.use("/api", uploadRoutes);
app.use("/api", imageRoutes);

app.listen(port, "0.0.0.0", () => {
  console.log(`Server is running on port ${port}`);
});
