import {CONFIG} from "../config.js";


if(localStorage.getItem("adminLoggedIn") !== "true"){
    window.location.href = "./login.html";
}




document.getElementById("uploadForm").addEventListener("submit", async function(e){

  e.preventDefault();

  const formData = new FormData(this);

  const response = await fetch(`${CONFIG.API_BASE_URL}/api/upload`, {
  method: "POST",
  body: formData
});

  const data = await response.json();

  alert("Uploaded: " + data.imageUrl);
});