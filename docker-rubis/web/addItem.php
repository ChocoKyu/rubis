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
// $json = '{"qrcode":"htest","collection":"false","etat":"bon","marque":"samsung","lieu":"armoire 1","type":"console","modèle":"test","commentaire":""}';
$data = json_decode($json);

$qrcode = $data->qrcode;
$collection = $data->collection;
$etat = $data->etat;
$select_etat = "(SELECT id FROM conditions WHERE name = '$etat')";
$lieu = $data->lieu;
$select_lieu = "(SELECT id FROM locations WHERE name = '$lieu')";
$type = $data->type;
$select_type = "(SELECT id FROM type_items WHERE name = '$type')";
$marque = $data->marque;
$select_marque = "(SELECT id FROM brands WHERE name = '$marque')";
$commentaire = $data->commentaire;

$query = "INSERT INTO items (qrcode, lieu, type, brand, `condition`, collection, `comment`) VALUES ('$qrcode', $select_lieu, $select_type, $select_marque, $select_etat, $collection, '$commentaire')";
echo($query);
$dbh->exec($query);

$data = json_decode($json, true);

unset($data["qrcode"]);
unset($data["collection"]);
unset($data["etat"]);
unset($data["lieu"]);
unset($data["type"]);
unset($data["marque"]);
unset($data["commentaire"]);

$query = "SELECT MAX(id) FROM items";
foreach($dbh->query($query) as $row){
    $id = $row[0];
}

foreach ($data as $key => $value){
    $type_setting = "(SELECT id FROM type_settings WHERE name = '$key' and id_type_item = (SELECT id FROM type_items WHERE name = '$type'))";
    $query = "INSERT INTO settings (id_type_setting, id_item, value) VALUES ($type_setting, '$id', '$value');";
    $dbh->exec($query);
}
?>