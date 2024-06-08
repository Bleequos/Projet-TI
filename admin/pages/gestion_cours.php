<h2>Gestion des cours</h2>
<a href="index_.php?page=ajout_cours.php">Nouveau cours</a><br>

<?php
//récupération des cours et affichage dans table bootstrap
$clients = new CoursDB($cnx);
$liste = $clients->getAllCours2();
//var_dump($liste);
$nbr = count($liste);

if($nbr == 0){
    print "<br>Aucun cours encodé<br>";
}
else{
    ?>
    <table class="table table-striped">
        <thead>

        <tr>
            <th scope="col">Id</th>
            <th scope="col">Titre</th>
            <th scope="col">Description</th>
            <th scope="col">Enseignant</th>
            <th scope="col">Lien de l'image</th>
            <th scope="col">Lien de la vidéo</th>
        </tr>

        </thead>
        <tbody>
        <?php
        for($i=0; $i < $nbr; $i++){
            ?>
            <tr>
                <th><?= $liste[$i]->cours_id;?></th>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="Titre"><?= $liste[$i]->titre;?></td>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="Description"><?= $liste[$i]->description;?></td>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="enseignant_id"><?= $liste[$i]->enseignant_id;?></td>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="image_link"><?= $liste[$i]->url;?></td>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="video_link"><?= $liste[$i]->url;?></td>
                <td contenteditable="true"><img src="public_/images/delete.jpg" alt="Effacer" id="delete" value="<?= $liste[$i]->cours_id;?>"></td>
            </tr>
            <?php
        }
        ?>

        </tbody>
    </table>
    <?php
}
