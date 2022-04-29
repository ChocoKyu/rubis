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

$newMembers = array();
$inactiveMembers = array();
$activeMembers = array();
$boardMembers = array();

$sql = "SELECT users.pseudo, users.firstname, users.lastname, users.email, users.phone, roles.name FROM users INNER JOIN roles ON users.role = roles.id WHERE roles.name='nouveau';";
foreach($dbh->query($sql) as $row){
    $newMembers[$row[0]] = array();
    array_push($newMembers[$row[0]], $row[1], $row[2], $row[3], $row[4], $row[5]);
}

$sql = "SELECT users.pseudo, users.firstname, users.lastname, users.email, users.phone, roles.name FROM users INNER JOIN roles ON users.role = roles.id WHERE roles.name='inactif';";
foreach($dbh->query($sql) as $row){
    $inactiveMembers[$row[0]] = array();
    array_push($inactiveMembers[$row[0]], $row[1], $row[2], $row[3], $row[4], $row[5]);
}

$sql = "SELECT users.pseudo, users.firstname, users.lastname, users.email, users.phone, roles.name FROM users INNER JOIN roles ON users.role = roles.id WHERE roles.name='actif';";
foreach($dbh->query($sql) as $row){
    $activeMembers[$row[0]] = array();
    array_push($activeMembers[$row[0]], $row[1], $row[2], $row[3], $row[4], $row[5]);
}

$sql = "SELECT users.pseudo, users.firstname, users.lastname, users.email, users.phone, roles.name FROM users INNER JOIN roles ON users.role = roles.id WHERE roles.name='bureau';";
foreach($dbh->query($sql) as $row){
    $boardMembers[$row[0]] = array();
    array_push($boardMembers[$row[0]], $row[1], $row[2], $row[3], $row[4], $row[5]);
}

$allMember = array();
$allMember['new'] = array();
array_push($allMember['new'], $newMembers);
$allMember['inactive'] = array();
array_push($allMember['inactive'], $inactiveMembers);
$allMember['active'] = array();
array_push($allMember['active'], $activeMembers);
$allMember['board'] = array();
array_push($allMember['board'], $boardMembers);

echo(json_encode($allMember));

?>