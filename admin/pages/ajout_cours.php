<h2>Gestion des cours</h2>
<div class="container">
    <form id="form_ajout" method="get" action="">
        <div class="mb-3">
            <label for="Titre" class="form-label">Titre</label>
            <input type="Titre" class="form-control" id="Titre" name="Titre">
        </div>
        <div class="mb-3">
            <label for="Description" class="form-label">Description</label>
            <input type="text" class="form-control" id="Description" name="Description">
        </div>
        <div class="mb-3">
            <label for="enseignant_id" class="form-label">Enseignant</label>
            <input type="text" class="form-control" id="enseignant_id" name="enseignant_id">
        </div>
        <button type="submit" id="texte_bouton_submit" value="Ajouter" class="btn btn-primary">
            Ajouter ou Modifier
        </button>
        <button class="btn btn-primary" type="reset" id="reset">Annuler</button>
    </form>
</div>