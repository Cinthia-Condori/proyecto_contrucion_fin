import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

const firebaseConfig = {
  apiKey: "AIzaSyBR_RYRF129JCS8x-T8wvy7gq1f2W1xZTE",
  authDomain: "pruebas-oauth-5f660.firebaseapp.com",
  projectId: "pruebas-oauth-5f660",
  storageBucket: "pruebas-oauth-5f660.appspot.com",
  messagingSenderId: "8178333640",
  appId: "1:8178333640:web:9b420ada58da73134072fd",
};
// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

export { app, auth };
