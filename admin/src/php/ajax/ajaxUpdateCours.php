<?php
header('Content-Type: application/json');
//chemin d'accès depuis le fichier ajax php
require '../db/dbPgConnect.php';
require '../classes/Connexion.class.php';
require '../classes/Cours.class.php';
require '../classes/CoursDB.class.php';
$cnx = Connexion::getInstance($dsn,$user,$password);

$cl = new CoursDB($cnx);
$data[] = $cl->updateCours($_GET['cours_id'],$_GET['name'],$_GET['valeur'],$_GET['table'], $_GET['type']);
print json_encode($data);
