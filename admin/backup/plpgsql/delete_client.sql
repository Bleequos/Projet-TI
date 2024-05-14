CREATE OR REPLACE FUNCTION delete_client(int) RETURNS integer AS
'
	declare p_id alias for $1;
	declare retour integer;
BEGIN
   Delete from client where id_client=p_id;
    RETURN 1;
END;
' LANGUAGE 'plpgsql';
