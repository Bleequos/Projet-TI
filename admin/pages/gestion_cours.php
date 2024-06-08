<h2>Gestion des cours</h2>
<a href="index_.php?page=ajout_cours.php">Nouveau cours</a><br>

<?php
//récupération des cours et affichage dans table bootstrap
$cours = new CoursDB($cnx);
$liste = $cours->getAllCours();
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
            <th scope="col">lien de image</th>
            <th scope="col">lien de video</th>
        </tr>
        </thead>
        <tbody>
        <?php
        for($i=0; $i < $nbr; $i++){
            $liste_images = $cours->getImagesById_cours($liste[$i]->cours_id);
            $liste_images = array_filter($liste_images, function($element) {
                return $element->type === 'image';
            });





            // Get videos for the current course
            $liste_videos = $cours->getVideosById_cours($liste[$i]->cours_id);
            // Filter only videos
            $liste_videos = array_filter($liste_videos, function($element) {
                return $element->type === 'video';
            });
            ?>
            <tr>
                <th><?= $liste[$i]->cours_id;?></th>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="titre"><?= $liste[$i]->titre;?></td>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="description"><?= $liste[$i]->description;?></td>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="enseignant_id"><?= $liste[$i]->enseignant_id;?></td>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="lien_image">
                    <?php foreach ($liste_images as $image): ?>
                        <p>
                             <a href="<?= htmlspecialchars($image->url); ?>"><?= htmlspecialchars($image->url); ?></a>
                        </p>
                    <?php endforeach; ?>
                </td>
                <td contenteditable="true" id="<?= $liste[$i]->cours_id;?>" name="lien_video">
                    <?php foreach ($liste_videos as $video): ?>
                        <p>
                             <a href="<?= htmlspecialchars($video->url); ?>"><?= htmlspecialchars($video->url); ?></a>
                        </p>
                    <?php endforeach; ?>
                </td>
                <td contenteditable="true"> <img src="public_/images/delete.jpg" alt="Effacer" id="delete<?= $i ?>" value="<?= $liste[$i]->cours_id;?>"></td>
            </tr>
            <?php
        }
        ?>
        </tbody>
    </table>
    <!-- Place your modal code here -->
    <<div class="modal fade" id="myModal" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-bs-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Suppression cours</h4>
                </div>
                <div class="modal-body">
                    <p>cours bien supprimé.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-bs-dismiss="modal">fermer</button>
                </div>
            </div>

        </div>
    </div>
    <?php

}



