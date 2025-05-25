import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDwDuhrYpE8RX55xoT2XZKJK8ApAN23dIs",
  authDomain: "basiclogin-99ae8.firebaseapp.com",
  databaseURL: "https://basiclogin-99ae8-default-rtdb.firebaseio.com",
  projectId: "basiclogin-99ae8",
  storageBucket: "basiclogin-99ae8.firebasestorage.app",
  messagingSenderId: "786277527597",
  appId: "1:786277527597:web:d13cfbeb00316b426408a4"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
////////////////////////////////////////////////////////

const container = document.getElementById('root');
const root = createRoot(container!);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);