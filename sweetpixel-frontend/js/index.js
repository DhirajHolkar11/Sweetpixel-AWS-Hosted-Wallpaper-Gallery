
async function loadImages(){

const response = await fetch("http://localhost:3000/api/images");

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
