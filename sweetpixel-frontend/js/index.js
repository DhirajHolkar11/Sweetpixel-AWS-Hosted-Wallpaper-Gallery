


import { CONFIG } from "../config.js";
async function loadImages(){

const response = await fetch(`${CONFIG.API_BASE_URL}/api/images`)

const images = await response.json();

const container = document.getElementById("gallery");

container.innerHTML = "";

images.forEach(url => {


    const card= document.createElement("div");
    card.className = "image-card";

    const img = document.createElement("img");
    img.src = url;

    card.appendChild(img);
    container.appendChild(card);

});

}

loadImages();
