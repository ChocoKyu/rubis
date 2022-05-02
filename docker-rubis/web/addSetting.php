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

$table = $data->table;
$value = $data->value;
$condition = $data->condition;
// $table = "conditions";
// $value = "mediocre";
// $condition = "";

$query = "INSERT INTO $table (name) VALUES ('$value') $condition";

$dbh->exec($query);
?>