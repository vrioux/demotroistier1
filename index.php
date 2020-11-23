<?php

$dbname = 'exemple';
$dbuser = 'root';
$dbpass = '<password>';
$dbhost = '<dbhost>';

$conn = new mysqli($dbhost,$dbuser,$dbpass);

if ($conn -> connect_errno) {
  die("Failed to connect to MySQL: " . $conn -> connect_error);
}

$conn->select_db($dbname) or {
    // Create database
    $sql = "CREATE DATABASE exemple";
    if ($conn->query($sql) !== TRUE) {
        die("Error creating database: " . $conn->error);
    }
    $sql = "CREATE TABLE exemple(id INT NOT NULL PRIMARY KEY AUTO_INCREMENT)";    
    if ($conn->query($sql) !== TRUE) {
        die("Error creating table: " . $conn->error);
    }
    $conn->select_db($dbname) or die("Could not open the database '$dbname'");
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Add entry to BD
} else {
    // Assume get, send number of entries in BD
    $result = $conn->query("SELECT count(*) FROM exemple");
    while ($row = $result->fetch_assoc()) {
        printf("%s", $row[0]);
    }
}