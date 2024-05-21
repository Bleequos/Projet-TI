CREATE OR REPLACE FUNCTION update_cours(p_id INT, p_champ TEXT, p_valeur TEXT)
RETURNS INTEGER AS $$
DECLARE
    p_id_alias ALIAS FOR $1;
    p_champ_alias ALIAS FOR $2;
    p_valeur_alias ALIAS FOR $3;
BEGIN
    EXECUTE format('UPDATE cours SET %I = %L WHERE cours_id = %L', p_champ_alias, p_valeur_alias, p_id_alias);
    -- execute format : utilisé lorsque les champs sont dynamiques
    -- %I : remplace le champ colonne, de manière sécurisée (échappement pour éviter les injections SQL)
    -- %L : remplace la valeur, de manière sécurisée
    RETURN 1;
END;
$$ LANGUAGE plpgsql;

