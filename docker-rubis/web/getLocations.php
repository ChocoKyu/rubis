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

$lieux = array();

$sql = "SELECT name FROM locations ORDER BY name;";
foreach($dbh->query($sql) as $row){
    array_push($lieux, $row["name"]);
}

echo(json_encode($lieux));

?>