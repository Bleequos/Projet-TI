CREATE OR REPLACE FUNCTION verifier_admin(p_login TEXT, p_password TEXT)
RETURNS INTEGER AS $$
DECLARE
    retour INTEGER;
BEGIN
    -- Utilisez 'utilisateur_id' directement dans SELECT INTO pour éviter les conflits
    SELECT utilisateur_id FROM public.utilisateurs
    WHERE nom_utilisateur = p_login AND mot_de_passe = p_password
    AND role IN ('administrateur', 'enseignant') INTO retour;

    -- Vérifiez si un utilisateur correspondant a été trouvé
    IF retour IS NULL THEN
        RETURN 0; -- Aucun utilisateur correspondant trouvé
    ELSE
        RETURN 1; -- Utilisateur correspondant trouvé
    END IF;
END;
$$ LANGUAGE plpgsql;
