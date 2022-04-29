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

$pseudo = $data->pseudo;
$role = $data->role;
$role = intval($role);


$query = "UPDATE users SET role='$role' WHERE pseudo='$pseudo'";

$dbh->exec($query);
?>