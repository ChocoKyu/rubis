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
$password = $data->password;

// $pseudo = 'choco';
// $password = 'Poney.141';

$query = "SELECT users.password, roles.name FROM users INNER JOIN roles ON users.role = roles.id  WHERE users.pseudo= :pseudo";

$sth = $dbh->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
$sth->execute(array(':pseudo' => $pseudo));
$response = $sth->fetchAll();

if (password_verify($password, $response[0]["password"]) == false) {
    $response = '';
}

echo(json_encode($response));
?>