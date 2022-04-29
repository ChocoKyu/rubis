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

$type_items = array();

$sql = "SELECT name FROM type_items;";
foreach($dbh->query($sql) as $row){
    array_push($type_items, $row["name"]);
}

echo(json_encode($type_items));

?>