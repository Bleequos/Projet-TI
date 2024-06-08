<?php
$cl = new CoursDB($cnx);
$enseignants = $cl->getAllEnseignants();
?>
<h2>Gestion des cours</h2>
<div class="container">
    <form id="form_ajout" method="get" action="">
        <div class="mb-3">
            <label for="Titre" class="form-label">Titre du cours</label>
            <input type="text" class="form-control" id="Titre" name="Titre">
        </div>
        <div class="mb-3">
            <label for="Description" class="form-label">Description</label>
            <input type="text" class="form-control" id="Description" name="Description">
        </div>
        <div class="mb-3">
            <label for="enseignant_id" class="form-label">Enseignant</label>
            <select class="form-control" id="enseignant_id" name="enseignant_id">
                <?php foreach ($enseignants as $enseignant): ?>
                    <option value="<?= $enseignant['utilisateur_id'] ?>"><?= $enseignant['nom_utilisateur'] ?></option>
                <?php endforeach; ?>
            </select>
        </div>
        <div class="mb-3">
            <label for="image_link" class="form-label">Lien de l'image</label>
            <input type="text" class="form-control" id="image_link" name="image_link">
        </div>
        <div class="mb-3">
            <label for="video_link" class="form-label">Lien de la vidéo</label>
            <input type="text" class="form-control" id="video_link" name="video_link">
        </div>
        <button type="submit" id="texte_bouton_submit" value="Ajouter" class="btn btn-primary">
            Ajouter ou Modifier
        </button>
        <button class="btn btn-primary" type="reset" id="reset">Annuler</button>
    </form>
</div>