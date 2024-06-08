<?php
header('Content-Type: application/json');
//chemin d'accès depuis le fichier ajax php
require '../db/dbPgConnect.php';
require '../classes/Connexion.class.php';
require '../classes/Cours.class.php';
require '../classes/CoursDB.class.php';
$cnx = Connexion::getInstance($dsn,$user,$password);

$cl = new CoursDB($cnx);
$data[] = $cl->InfosEnseignant($_GET['enseignant_id']);
print json_encode($data);