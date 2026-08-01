function login() {
    const password = document.getElementById("password").value;

    if(password === "admin123") {
        localStorage.setItem("adminLoggedIn", "true");
        window.location.href = "upload.html";
    } else {
        alert("Wrong password");
    }
}