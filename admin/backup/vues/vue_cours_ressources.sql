CREATE OR REPLACE VIEW public.vue_cours_ressources AS
SELECT 
    Cours.cours_id,
    Cours.titre,
    Cours.description,
    Ressources.ressource_id,
    Ressources.type,
    Ressources.url
FROM 
    Cours
JOIN 
    Ressources ON Ressources.cours_id = Cours.cours_id;
