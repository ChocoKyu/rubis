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

$where = $data->where;
// $where = "http://association-replay.fr/hardware/2";

$type_items = array();

$sql = "SELECT items.id, items.qrcode, locations.name, type_items.name, brands.name, conditions.name, items.collection, items.comment FROM items INNER JOIN locations ON items.lieu = locations.id INNER JOIN type_items ON items.type = type_items.id INNER JOIN brands ON items.brand = brands.id INNER JOIN conditions ON items.condition = conditions.id $where;";

foreach($dbh->query($sql) as $row){
    $type_items[$row[0]] = array(
        "qrcode" => $row[1],
        "lieu" => $row[2],
        "type" => $row[3],
        "marque" => $row[4],
        "etat" => $row[5],
        "collection" => $row[6],
        "commentaire" => $row[7]);
}

foreach ($type_items as $key => $value){
    $sql = "SELECT type_settings.name, settings.value FROM settings INNER JOIN type_settings ON settings.id_type_setting = type_settings.id WHERE settings.id_item = '$key';";
    foreach($dbh->query($sql) as $row){
        $type_items[$key][$row["name"]] = $row["value"];
    }
}
echo(json_encode($type_items));
?>