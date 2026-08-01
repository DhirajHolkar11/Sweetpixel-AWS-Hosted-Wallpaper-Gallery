
if(localStorage.getItem("adminLoggedIn") !== "true"){
    window.location.href = "login.html";
}




document.getElementById("uploadForm").addEventListener("submit", async function(e){

  e.preventDefault();

  const formData = new FormData(this);

  const response = await fetch("http://localhost:3000/api/upload",{
    method:"POST",
    body:formData
  });

  const data = await response.json();

  alert("Uploaded: " + data.imageUrl);
});