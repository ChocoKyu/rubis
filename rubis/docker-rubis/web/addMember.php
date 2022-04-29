<?php

$dsn = 'mysql:host=database;dbname=dbRubis';
$user = 'replay';
$password = 'level9high5';

try {
    $dbh = new PDO($dsn, $user, $password);
}
catch (PDOException $e) {
    die('Erreur de connexion à la base : ' . $e->getMessage());
}


$json = file_get_contents('php://input');
$data = json_decode($json);

$firstname = $data->firstname;
$lastname = $data->lastname;
$pseudo = $data->pseudo;
$password = $data->password;
$password = password_hash($password, PASSWORD_DEFAULT);
$email = $data->email;
$phone = $data->phone;
$role = '1';

$token = bin2hex(random_bytes(5));
date_default_timezone_set('Europe/Paris');
$date = date("Y-m-d H:i:s", time());


$query = "INSERT INTO users (firstname, lastname, pseudo, password,  email, phone, role, token, creation) VALUES ('$firstname', '$lastname', '$pseudo', '$password', '$email', '$phone', '$role', '$token', '$date')";

$dbh->exec($query);
?>