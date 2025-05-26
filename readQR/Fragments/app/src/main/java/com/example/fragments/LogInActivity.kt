package com.example.fragments

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.firebase.auth.FirebaseAuth

class LogInActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth;
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_log_in)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        auth = FirebaseAuth.getInstance()

        var email : String = ""
        var pass : String = ""

        val editTxtUsername = findViewById<EditText>(R.id.editTxt_Email)
        val editTxtPass = findViewById<EditText>(R.id.editTxt_Pass)

        val btnLogin = findViewById<Button>(R.id.butGoMain_Login)
        btnLogin.setOnClickListener {
            val email = editTxtUsername.text.toString().trim()
            val pass = editTxtPass.text.toString().trim()

            if(email.isEmpty() || pass.isEmpty()) {
                Toast.makeText(this, "Empty Fields", Toast.LENGTH_LONG).show() // ✅ Show error and stop execution
                return@setOnClickListener
            }

            auth.signInWithEmailAndPassword(email, pass).addOnCompleteListener { result ->
                if (result.isSuccessful) {
                    Toast.makeText(this, "User Authenticated", Toast.LENGTH_LONG).show()
                    goMain()
                } else {
                    Toast.makeText(
                        this,
                        "Error: ${result.exception?.message ?: "Unknown"}",
                        Toast.LENGTH_LONG
                    ).show()
                }
            }
        }
    }

    public override fun onStart() {
        super.onStart()
        // Check if user is signed in (non-null) and update UI accordingly.
        val currentUser = auth.currentUser
        //updateUI(currentUser)
        if(currentUser != null){
            Toast.makeText(this, "Hi " + currentUser.email.toString() + " !", Toast.LENGTH_LONG).show()
            goMain()
        }
    }

    private fun goMain(){
        if(auth.currentUser != null){
            startActivity(Intent(this, MainActivity:: class.java).putExtra("userId", auth.currentUser!!.uid.toString()))
            finish()
        }
    }
}