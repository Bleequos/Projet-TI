CREATE OR REPLACE VIEW public.vue_details_cours AS
SELECT
    C.cours_id,
    C.titre,
    C.description,
    U.utilisateur_id AS enseignant_id,
    U.nom_utilisateur AS nom_enseignant,
    U.email AS email_enseignant
FROM
    Cours C
JOIN
    Utilisateurs U ON C.enseignant_id = U.utilisateur_id;
