package com.example.fragments

import android.Manifest
import android.content.ContentValues.TAG
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.fragment.app.Fragment
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.ValueEventListener
import com.google.firebase.database.ktx.database

import com.google.firebase.ktx.Firebase
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanIntentResult
import com.journeyapps.barcodescanner.ScanOptions


class MainActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth;
    val database = Firebase.database
    val myRef = database.getReference("qr")

    private val barcodeLauncher = registerForActivityResult<ScanOptions, ScanIntentResult>(
        ScanContract()
    ) { result: ScanIntentResult ->
        if (result.contents == null) {
            Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show()
        } else {
            read = result.contents.toString()
            useQR(read)
        }
    }

    private var read = ""

    private val requestPermissionLauncher = registerForActivityResult(ActivityResultContracts.RequestPermission()){
            awarded ->
        if (awarded){
            Toast.makeText(this,"Permissions Awarded", Toast.LENGTH_LONG).show()
        }else{
            Toast.makeText(this, "Permissions Denied", Toast.LENGTH_LONG).show()
        }
    }

    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        auth = FirebaseAuth.getInstance()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
    }

    fun launchQR(view: View?) {
        val options = ScanOptions()
        options.setDesiredBarcodeFormats(ScanOptions.QR_CODE)
        options.setPrompt("Scan a QR")
        options.setCameraId(0)
        options.setBeepEnabled(true)
        options.setBarcodeImageEnabled(true)
        barcodeLauncher.launch(ScanOptions())
    }

    fun logOut(view: View?){
        auth.signOut()
        startActivity(Intent(this, LogInActivity:: class.java))
        finish()
    }
    private fun useQR(qrKey: String) {
        val qrRef = Firebase.database.getReference("Keys").child(qrKey)

        qrRef.get().addOnSuccessListener { snapshot ->
            if (snapshot.exists()) {
                val status = snapshot.child("status").getValue(String::class.java)

                when (status) {
                    "used" -> {
                        Toast.makeText(this, "QR already used", Toast.LENGTH_LONG).show()
                    }
                    "available", "generated" -> {
                        qrRef.child("status").setValue("used")
                            .addOnSuccessListener {
                                Toast.makeText(this, "Nice Trip!", Toast.LENGTH_LONG).show()
                            }
                            .addOnFailureListener {
                                Toast.makeText(this, "Failed to Update", Toast.LENGTH_LONG).show()
                            }
                    }
                    else -> {
                        Toast.makeText(this, "Unknown QR status", Toast.LENGTH_LONG).show()
                    }
                }
            } else {
                Toast.makeText(this, "Inexistent QR", Toast.LENGTH_LONG).show()
            }
        }.addOnFailureListener {
            Toast.makeText(this, "Failed to Read DB", Toast.LENGTH_LONG).show()
        }
    }


}