
import { CONFIG } from "../config.js";

const uploadForm = document.getElementById("uploadForm");
const status = document.getElementById("status");

uploadForm.addEventListener("submit", async (event) => {
  event.preventDefault();

  const fileInput = uploadForm.querySelector('input[name="image"]');

  if (!fileInput.files.length) {
    status.textContent = "Please select an image.";
    return;
  }

  const formData = new FormData(uploadForm);

  status.textContent = "Uploading image...";

  try {
    const response = await fetch(
      `${CONFIG.API_BASE_URL}/api/upload`,
      {
        method: "POST",
        body: formData
      }
    );

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || "Upload failed.");
    }

    status.textContent = "Upload successful!";

    uploadForm.reset();

    alert(`Uploaded successfully: ${data.imageUrl}`);
  } catch (error) {
    console.error("Upload error:", error);
    status.textContent = error.message || "Upload failed. Please try again.";
  }
});