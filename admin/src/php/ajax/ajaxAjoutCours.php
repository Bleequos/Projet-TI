<?php
header('Content-Type: application/json');
//chemin d'accès depuis le fichier ajax php
require '../db/dbPgConnect.php';
require '../classes/Connexion.class.php';
require '../classes/Cours.class.php';
require '../classes/CoursDB.class.php';
$cnx = Connexion::getInstance($dsn,$user,$password);

$cl = new CoursDB($cnx);
$data[] = $cl->ajout_cours($_GET['Titre'],$_GET['Description'],$_GET['enseignant_id'],$_GET['image_link'],$_GET['video_link']);
print json_encode($data);




