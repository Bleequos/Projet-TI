CREATE OR REPLACE FUNCTION update_cours_ressources(p_id integer, p_champ text, p_valeur text, p_table text, p_type text) RETURNS integer AS
$$
DECLARE
    sql text;
BEGIN
    IF p_table = 'cours' THEN
        sql := format('UPDATE %I SET %I = %L WHERE cours_id = %L', p_table, p_champ, p_valeur, p_id);
    ELSIF p_table = 'ressources' THEN
        sql := format('UPDATE %I SET %I = %L WHERE cours_id = %L AND type = %L', p_table, p_champ, p_valeur, p_id, p_type);
    ELSE
        RAISE EXCEPTION 'Invalid table name. Only "cours" and "ressources" are allowed.';
    END IF;
    EXECUTE sql;
    RETURN 1;
END;
$$ LANGUAGE plpgsql;