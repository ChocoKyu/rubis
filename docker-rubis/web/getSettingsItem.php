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
$type = $data->type;
// $type = "télécommande";
$settings_items = array();

$sql = "SELECT type_settings.name, type_settings.type, settings.value FROM type_settings LEFT JOIN settings ON type_settings.id = settings.id_type_setting WHERE type_settings.id_type_item = (SELECT id FROM type_items WHERE name = '".$type."' ORDER BY settings.value );";

foreach($dbh->query($sql) as $row){
    if(isset($settings_items[$row["name"]])){
        array_push($settings_items[$row["name"]], $row["value"]);
    }
    else{
        $settings_items[$row["name"]] = array($row["type"], $row["value"]);
    }
}

echo(json_encode($settings_items));
?>