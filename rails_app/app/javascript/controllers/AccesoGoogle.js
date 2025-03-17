import { auth } from "./firebase.js";
import {
  GoogleAuthProvider,
  signInWithPopup,
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
//Google Login
const googleButton = document.querySelector("#btn-Google");
googleButton.addEventListener("click", async (e) => {
  e.preventDefault();
  try {
    const provider = new GoogleAuthProvider();
    const result = await signInWithPopup(auth, provider);
    console.log("Iniciado con Google:", result.user);
  } catch (error) {
    console.error("Error al autenticar con Google:", error.message);
  }
});
