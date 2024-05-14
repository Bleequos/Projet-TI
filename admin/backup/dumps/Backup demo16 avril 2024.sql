--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2024-04-16 11:04:38

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 240 (class 1255 OID 16553)
-- Name: ajout_admin(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ajout_admin(text, text) RETURNS integer
    LANGUAGE plpgsql
    AS '
	-- déclarations
	DECLARE p_login ALIAS FOR $1; -- premier paramètre reçu
	DECLARE p_password ALIAS FOR $2;
	DECLARE id INTEGER;
	DECLARE retour INTEGER;
BEGIN	
	-- select de l''admin portant ce login et password
	SELECT INTO id id_admin FROM admin WHERE login = p_login and password = p_password;
	IF NOT FOUND
	THEN
	  INSERT INTO admin (login, password) VALUES (p_login,p_password);
	  SELECT INTO id id_admin FROM admin WHERE login = p_login and password = p_password;
	  IF NOT FOUND
	  THEN
	    retour = -1; -- échec insertion
	  ELSE
	    retour = 1; -- réussie réussie
	  END IF;
	ELSE
	  retour = 0;
	END IF;
return retour;	
END;	
';


--
-- TOC entry 244 (class 1255 OID 16571)
-- Name: ajout_client(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ajout_client(text, text, text, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS '
  declare p_nom alias for $1;
  declare p_prenom alias for $2;
  declare p_email alias for $3;
  declare p_adresse alias for $4;
  declare p_numero alias for $5;
  declare id integer;
  declare retour integer;
  
begin
	select into id id_client from client where email = p_email;
	if not found
	then
	  insert into client (nom_client,prenom_client,email,adresse,numero) values
	    (p_nom,p_prenom,p_email,p_adresse,p_numero);
	  select into id id_client from client where email = p_email;
	  if not found
	  then	
	    retour = -1;  --échec de la requête
	  else
	    retour = 1;   -- insertion ok
	  end if;
	else
	  retour = 0;      -- déjà en BD
	end if;
 return retour;
 end;
';


--
-- TOC entry 243 (class 1255 OID 24764)
-- Name: delete_client(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_client(integer) RETURNS integer
    LANGUAGE plpgsql
    AS '
	declare p_id alias for $1;
	declare retour integer;
	-- declare id integer;

BEGIN
    delete from client where id_client = p_id;
	-- vérifier le delete
    RETURN 1;
END;
';


--
-- TOC entry 242 (class 1255 OID 24763)
-- Name: update_client(integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_client(integer, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS '
	declare p_id alias for $1;
	declare p_champ alias for $2;
	declare p_valeur alias for $3;
BEGIN
    EXECUTE format(''UPDATE client SET %I = %L WHERE id_client = %L'', p_champ, p_valeur, p_id);
    -- execute format : utilisé lorsque les champs sont dynamiques
    -- %I : remplace le champ colonne, de manière sécurisée (échappement pour éviter les injections sql)
    -- %I : remplace la valeur, de manière sécurisée
    RETURN 1;
END;
';


--
-- TOC entry 241 (class 1255 OID 16570)
-- Name: verifier_admin(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.verifier_admin(text, text) RETURNS integer
    LANGUAGE plpgsql
    AS '
	declare p_login alias for $1;
	declare p_password alias for $2;
	declare id integer;
	declare retour integer;
	
begin
	select into id id_admin from admin where login=p_login and password = p_password;
	if not found 
	then
	  retour = 0;
	else
	  retour =1;
	end if;  
	return retour;
end;
';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 236 (class 1259 OID 16545)
-- Name: admin; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin (
    id_admin integer NOT NULL,
    login text NOT NULL,
    password text NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 16544)
-- Name: admin_id_admin_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_id_admin_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 235
-- Name: admin_id_admin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_id_admin_seq OWNED BY public.admin.id_admin;


--
-- TOC entry 216 (class 1259 OID 16401)
-- Name: categorie; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorie (
    id_categorie integer NOT NULL,
    nom_categorie text NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 16400)
-- Name: categorie_id_categorie_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorie_id_categorie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 215
-- Name: categorie_id_categorie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorie_id_categorie_seq OWNED BY public.categorie.id_categorie;


--
-- TOC entry 226 (class 1259 OID 16461)
-- Name: client; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client (
    id_client integer NOT NULL,
    nom_client text NOT NULL,
    email text NOT NULL,
    adresse text NOT NULL,
    numero text NOT NULL,
    id_ville integer,
    prenom_client text
);


--
-- TOC entry 225 (class 1259 OID 16460)
-- Name: client_id_client_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.client_id_client_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 225
-- Name: client_id_client_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.client_id_client_seq OWNED BY public.client.id_client;


--
-- TOC entry 232 (class 1259 OID 16511)
-- Name: facture; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facture (
    id_facture integer NOT NULL,
    date_facture date NOT NULL,
    paye boolean NOT NULL,
    id_produit integer NOT NULL,
    id_client integer NOT NULL,
    prix real NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 16510)
-- Name: facture_id_facture_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facture_id_facture_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 231
-- Name: facture_id_facture_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facture_id_facture_seq OWNED BY public.facture.id_facture;


--
-- TOC entry 234 (class 1259 OID 16528)
-- Name: livraison; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.livraison (
    id_livraison integer NOT NULL,
    id_magasin integer,
    id_facture integer
);


--
-- TOC entry 233 (class 1259 OID 16527)
-- Name: livraison_id_livraison_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.livraison_id_livraison_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 233
-- Name: livraison_id_livraison_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.livraison_id_livraison_seq OWNED BY public.livraison.id_livraison;


--
-- TOC entry 224 (class 1259 OID 16447)
-- Name: magasin; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.magasin (
    id_magasin integer NOT NULL,
    nom_magasin text NOT NULL,
    adresse text NOT NULL,
    numero text NOT NULL,
    id_ville integer NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16446)
-- Name: magasin_id_magasin_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.magasin_id_magasin_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 223
-- Name: magasin_id_magasin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.magasin_id_magasin_seq OWNED BY public.magasin.id_magasin;


--
-- TOC entry 230 (class 1259 OID 16494)
-- Name: panier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.panier (
    id_panier integer NOT NULL,
    quantite integer NOT NULL,
    id_client integer NOT NULL,
    id_produit integer NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 16493)
-- Name: panier_id_panier_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.panier_id_panier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 229
-- Name: panier_id_panier_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.panier_id_panier_seq OWNED BY public.panier.id_panier;


--
-- TOC entry 220 (class 1259 OID 16424)
-- Name: pays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pays (
    id_pays integer NOT NULL,
    nom_pays text NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 16423)
-- Name: pays_id_pays_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pays_id_pays_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 219
-- Name: pays_id_pays_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pays_id_pays_seq OWNED BY public.pays.id_pays;


--
-- TOC entry 228 (class 1259 OID 16475)
-- Name: produit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produit (
    id_produit integer NOT NULL,
    nom_produit text NOT NULL,
    prix double precision,
    stock integer,
    relais boolean,
    id_magasin integer NOT NULL,
    id_sous_categorie integer NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 16474)
-- Name: produit_id_produit_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.produit_id_produit_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 227
-- Name: produit_id_produit_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.produit_id_produit_seq OWNED BY public.produit.id_produit;


--
-- TOC entry 218 (class 1259 OID 16410)
-- Name: sous_categorie; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sous_categorie (
    id_sous_categorie integer NOT NULL,
    nom_sous_categorie text NOT NULL,
    id_categorie integer NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 16409)
-- Name: sous_categorie_id_sous_categorie_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sous_categorie_id_sous_categorie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 217
-- Name: sous_categorie_id_sous_categorie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sous_categorie_id_sous_categorie_seq OWNED BY public.sous_categorie.id_sous_categorie;


--
-- TOC entry 222 (class 1259 OID 16433)
-- Name: ville; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ville (
    id_ville integer NOT NULL,
    nom_ville text NOT NULL,
    code_postal text NOT NULL,
    id_pays integer NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16432)
-- Name: ville_id_ville_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ville_id_ville_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 221
-- Name: ville_id_ville_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ville_id_ville_seq OWNED BY public.ville.id_ville;


--
-- TOC entry 238 (class 1259 OID 16558)
-- Name: vue_categorie_sous_categorie; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vue_categorie_sous_categorie AS
 SELECT categorie.id_categorie,
    categorie.nom_categorie,
    sous_categorie.id_sous_categorie,
    sous_categorie.nom_sous_categorie
   FROM public.categorie,
    public.sous_categorie
  WHERE (sous_categorie.id_categorie = categorie.id_categorie);


--
-- TOC entry 237 (class 1259 OID 16554)
-- Name: vue_pays_villes; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vue_pays_villes AS
 SELECT pays.id_pays,
    pays.nom_pays,
    ville.id_ville,
    ville.nom_ville,
    ville.code_postal
   FROM public.ville,
    public.pays
  WHERE (ville.id_pays = pays.id_pays);


--
-- TOC entry 239 (class 1259 OID 16566)
-- Name: vue_produits_cat_sous_cat_mag; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vue_produits_cat_sous_cat_mag AS
 SELECT vue_categorie_sous_categorie.id_categorie,
    vue_categorie_sous_categorie.nom_categorie,
    vue_categorie_sous_categorie.nom_sous_categorie,
    produit.id_produit,
    produit.nom_produit,
    produit.prix,
    produit.stock,
    produit.relais,
    magasin.id_magasin,
    magasin.nom_magasin
   FROM public.vue_categorie_sous_categorie,
    public.produit,
    public.magasin
  WHERE ((produit.id_sous_categorie = vue_categorie_sous_categorie.id_sous_categorie) AND (produit.id_magasin = magasin.id_magasin));


--
-- TOC entry 4711 (class 2604 OID 16548)
-- Name: admin id_admin; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin ALTER COLUMN id_admin SET DEFAULT nextval('public.admin_id_admin_seq'::regclass);


--
-- TOC entry 4701 (class 2604 OID 16404)
-- Name: categorie id_categorie; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorie ALTER COLUMN id_categorie SET DEFAULT nextval('public.categorie_id_categorie_seq'::regclass);


--
-- TOC entry 4706 (class 2604 OID 16464)
-- Name: client id_client; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client ALTER COLUMN id_client SET DEFAULT nextval('public.client_id_client_seq'::regclass);


--
-- TOC entry 4709 (class 2604 OID 16514)
-- Name: facture id_facture; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facture ALTER COLUMN id_facture SET DEFAULT nextval('public.facture_id_facture_seq'::regclass);


--
-- TOC entry 4710 (class 2604 OID 16531)
-- Name: livraison id_livraison; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livraison ALTER COLUMN id_livraison SET DEFAULT nextval('public.livraison_id_livraison_seq'::regclass);


--
-- TOC entry 4705 (class 2604 OID 16450)
-- Name: magasin id_magasin; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magasin ALTER COLUMN id_magasin SET DEFAULT nextval('public.magasin_id_magasin_seq'::regclass);


--
-- TOC entry 4708 (class 2604 OID 16497)
-- Name: panier id_panier; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panier ALTER COLUMN id_panier SET DEFAULT nextval('public.panier_id_panier_seq'::regclass);


--
-- TOC entry 4703 (class 2604 OID 16427)
-- Name: pays id_pays; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pays ALTER COLUMN id_pays SET DEFAULT nextval('public.pays_id_pays_seq'::regclass);


--
-- TOC entry 4707 (class 2604 OID 16478)
-- Name: produit id_produit; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produit ALTER COLUMN id_produit SET DEFAULT nextval('public.produit_id_produit_seq'::regclass);


--
-- TOC entry 4702 (class 2604 OID 16413)
-- Name: sous_categorie id_sous_categorie; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sous_categorie ALTER COLUMN id_sous_categorie SET DEFAULT nextval('public.sous_categorie_id_sous_categorie_seq'::regclass);


--
-- TOC entry 4704 (class 2604 OID 16436)
-- Name: ville id_ville; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville ALTER COLUMN id_ville SET DEFAULT nextval('public.ville_id_ville_seq'::regclass);


--
-- TOC entry 4913 (class 0 OID 16545)
-- Dependencies: 236
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.admin (id_admin, login, password) VALUES (4, 'Louis', 'Louis');
INSERT INTO public.admin (id_admin, login, password) VALUES (2, 'Pierre', 'Pierre');
INSERT INTO public.admin (id_admin, login, password) VALUES (3, 'Emma', 'Emma');
INSERT INTO public.admin (id_admin, login, password) VALUES (5, 'Bob', 'Bob');
INSERT INTO public.admin (id_admin, login, password) VALUES (9, 'Fred', 'Fred');
INSERT INTO public.admin (id_admin, login, password) VALUES (10, 'Marie', 'Marie');


--
-- TOC entry 4893 (class 0 OID 16401)
-- Dependencies: 216
-- Data for Name: categorie; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categorie (id_categorie, nom_categorie) VALUES (1, 'Boucherie');
INSERT INTO public.categorie (id_categorie, nom_categorie) VALUES (2, 'Boulangerie');
INSERT INTO public.categorie (id_categorie, nom_categorie) VALUES (3, 'Epicerie');
INSERT INTO public.categorie (id_categorie, nom_categorie) VALUES (4, 'Ménage');
INSERT INTO public.categorie (id_categorie, nom_categorie) VALUES (5, 'Papeterie');
INSERT INTO public.categorie (id_categorie, nom_categorie) VALUES (6, 'Animaux');
INSERT INTO public.categorie (id_categorie, nom_categorie) VALUES (7, 'Fruits et légumes');
INSERT INTO public.categorie (id_categorie, nom_categorie) VALUES (8, 'Produits laitiers');


--
-- TOC entry 4903 (class 0 OID 16461)
-- Dependencies: 226
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.client (id_client, nom_client, email, adresse, numero, id_ville, prenom_client) VALUES (2, 'Bob', 'bobby@bob.be', 'Rue du champ de mars', '17', NULL, 'Bobby');
INSERT INTO public.client (id_client, nom_client, email, adresse, numero, id_ville, prenom_client) VALUES (3, 'azerty', 'cc@cc.be', 'Rue de la poste', '2', NULL, 'Jules');
INSERT INTO public.client (id_client, nom_client, email, adresse, numero, id_ville, prenom_client) VALUES (1, 'Bb', 'aa@aa.be', 'Rue de l''école', '15', NULL, 'BbbAAA');


--
-- TOC entry 4909 (class 0 OID 16511)
-- Dependencies: 232
-- Data for Name: facture; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4911 (class 0 OID 16528)
-- Dependencies: 234
-- Data for Name: livraison; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4901 (class 0 OID 16447)
-- Dependencies: 224
-- Data for Name: magasin; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.magasin (id_magasin, nom_magasin, adresse, numero, id_ville) VALUES (2, 'Chez Jacques', 'Rue des écoles', '154', 3);
INSERT INTO public.magasin (id_magasin, nom_magasin, adresse, numero, id_ville) VALUES (3, 'Chez Ignace', 'Rue de la ferme', '19', 4);
INSERT INTO public.magasin (id_magasin, nom_magasin, adresse, numero, id_ville) VALUES (4, 'Chez Arthur', 'Rue des bois', '29', 3);
INSERT INTO public.magasin (id_magasin, nom_magasin, adresse, numero, id_ville) VALUES (5, 'Chez Margot', 'Rue de la poste', '84', 4);


--
-- TOC entry 4907 (class 0 OID 16494)
-- Dependencies: 230
-- Data for Name: panier; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4897 (class 0 OID 16424)
-- Dependencies: 220
-- Data for Name: pays; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pays (id_pays, nom_pays) VALUES (1, 'Belgique');
INSERT INTO public.pays (id_pays, nom_pays) VALUES (2, 'France');


--
-- TOC entry 4905 (class 0 OID 16475)
-- Dependencies: 228
-- Data for Name: produit; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (1, 'Glacé', 3.5, 8, NULL, 2, 7);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (2, 'Riz', 5.7, 8, NULL, 3, 5);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (3, 'Ebly', 4.5, 16, NULL, 3, 5);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (4, 'Semoule moyen', 4.19, 11, NULL, 3, 5);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (5, 'Félix Duo', 5.75, 18, NULL, 3, 3);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (6, 'Whiskas Poisson', 6.51, 21, NULL, 3, 3);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (7, 'Croquettes Gourmet', 7.24, 10, NULL, 3, 3);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (8, 'Pommes Grany Smith', 3.15, 20, NULL, 3, 9);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (9, 'Poires Williams', 2.51, 12, NULL, 3, 9);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (10, 'Oranges de table', 4.24, 12, NULL, 3, 9);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (11, 'Clémentines', 4.11, 19, NULL, 3, 9);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (12, 'Bananes', 1.2, 19, NULL, 3, 9);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (13, 'Laitues', 0.85, 20, NULL, 3, 11);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (14, 'Carottes', 3, 12, NULL, 3, 11);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (15, 'Poireaux', 2.24, 15, NULL, 3, 11);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (16, 'Navets', 2.4, 19, NULL, 3, 11);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (17, 'Céleri', 1.26, 4, NULL, 3, 11);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (19, 'Poulet', 8.75, 11, NULL, 2, 6);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (20, 'Dinde', 6.51, 21, NULL, 2, 6);
INSERT INTO public.produit (id_produit, nom_produit, prix, stock, relais, id_magasin, id_sous_categorie) VALUES (21, 'Caille', 17.24, 5, NULL, 2, 6);


--
-- TOC entry 4895 (class 0 OID 16410)
-- Dependencies: 218
-- Data for Name: sous_categorie; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (6, 'Volaille', 1);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (7, 'Pains', 2);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (5, 'Féculents', 3);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (4, 'Pâtisserie', 2);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (10, 'Vaisselle', 4);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (2, 'Entretien', 4);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (9, 'Fruits', 7);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (11, 'Légumes', 7);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (1, 'Traiteur', 1);
INSERT INTO public.sous_categorie (id_sous_categorie, nom_sous_categorie, id_categorie) VALUES (3, 'Animaux', 4);


--
-- TOC entry 4899 (class 0 OID 16433)
-- Dependencies: 222
-- Data for Name: ville; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.ville (id_ville, nom_ville, code_postal, id_pays) VALUES (1, 'Peruwelz', '7060', 1);
INSERT INTO public.ville (id_ville, nom_ville, code_postal, id_pays) VALUES (2, 'Quiévrechain', '59920', 2);
INSERT INTO public.ville (id_ville, nom_ville, code_postal, id_pays) VALUES (3, 'Quiévrain', '7380', 1);
INSERT INTO public.ville (id_ville, nom_ville, code_postal, id_pays) VALUES (4, 'Crespin', '59154', 2);
INSERT INTO public.ville (id_ville, nom_ville, code_postal, id_pays) VALUES (5, 'Quarouble', '59243', 2);
INSERT INTO public.ville (id_ville, nom_ville, code_postal, id_pays) VALUES (6, 'Hensies', '7350', 1);


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 235
-- Name: admin_id_admin_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.admin_id_admin_seq', 10, true);


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 215
-- Name: categorie_id_categorie_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorie_id_categorie_seq', 8, true);


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 225
-- Name: client_id_client_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.client_id_client_seq', 4, true);


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 231
-- Name: facture_id_facture_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.facture_id_facture_seq', 1, false);


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 233
-- Name: livraison_id_livraison_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.livraison_id_livraison_seq', 1, false);


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 223
-- Name: magasin_id_magasin_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.magasin_id_magasin_seq', 5, true);


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 229
-- Name: panier_id_panier_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.panier_id_panier_seq', 1, false);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 219
-- Name: pays_id_pays_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pays_id_pays_seq', 2, true);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 227
-- Name: produit_id_produit_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.produit_id_produit_seq', 1, false);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 217
-- Name: sous_categorie_id_sous_categorie_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sous_categorie_id_sous_categorie_seq', 11, true);


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 221
-- Name: ville_id_ville_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ville_id_ville_seq', 6, true);


--
-- TOC entry 4733 (class 2606 OID 16552)
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id_admin);


--
-- TOC entry 4713 (class 2606 OID 16408)
-- Name: categorie categorie_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorie
    ADD CONSTRAINT categorie_pkey PRIMARY KEY (id_categorie);


--
-- TOC entry 4723 (class 2606 OID 16468)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id_client);


--
-- TOC entry 4729 (class 2606 OID 16516)
-- Name: facture facture_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facture
    ADD CONSTRAINT facture_pkey PRIMARY KEY (id_facture);


--
-- TOC entry 4731 (class 2606 OID 16533)
-- Name: livraison livraison_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livraison
    ADD CONSTRAINT livraison_pkey PRIMARY KEY (id_livraison);


--
-- TOC entry 4721 (class 2606 OID 16454)
-- Name: magasin magasin_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magasin
    ADD CONSTRAINT magasin_pkey PRIMARY KEY (id_magasin);


--
-- TOC entry 4727 (class 2606 OID 16499)
-- Name: panier panier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panier
    ADD CONSTRAINT panier_pkey PRIMARY KEY (id_panier);


--
-- TOC entry 4717 (class 2606 OID 16431)
-- Name: pays pays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pays
    ADD CONSTRAINT pays_pkey PRIMARY KEY (id_pays);


--
-- TOC entry 4725 (class 2606 OID 16482)
-- Name: produit produit_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT produit_pkey PRIMARY KEY (id_produit);


--
-- TOC entry 4715 (class 2606 OID 16417)
-- Name: sous_categorie sous_categorie_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sous_categorie
    ADD CONSTRAINT sous_categorie_pkey PRIMARY KEY (id_sous_categorie);


--
-- TOC entry 4719 (class 2606 OID 16440)
-- Name: ville ville_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville
    ADD CONSTRAINT ville_pkey PRIMARY KEY (id_ville);


--
-- TOC entry 4737 (class 2606 OID 16469)
-- Name: client client_id_ville_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_id_ville_fkey FOREIGN KEY (id_ville) REFERENCES public.ville(id_ville);


--
-- TOC entry 4742 (class 2606 OID 16522)
-- Name: facture facture_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facture
    ADD CONSTRAINT facture_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.client(id_client);


--
-- TOC entry 4743 (class 2606 OID 16517)
-- Name: facture facture_id_produit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facture
    ADD CONSTRAINT facture_id_produit_fkey FOREIGN KEY (id_produit) REFERENCES public.produit(id_produit);


--
-- TOC entry 4744 (class 2606 OID 16539)
-- Name: livraison livraison_id_facture_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livraison
    ADD CONSTRAINT livraison_id_facture_fkey FOREIGN KEY (id_facture) REFERENCES public.facture(id_facture);


--
-- TOC entry 4745 (class 2606 OID 16534)
-- Name: livraison livraison_id_magasin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livraison
    ADD CONSTRAINT livraison_id_magasin_fkey FOREIGN KEY (id_magasin) REFERENCES public.magasin(id_magasin);


--
-- TOC entry 4736 (class 2606 OID 16455)
-- Name: magasin magasin_id_ville_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magasin
    ADD CONSTRAINT magasin_id_ville_fkey FOREIGN KEY (id_ville) REFERENCES public.ville(id_ville);


--
-- TOC entry 4740 (class 2606 OID 16500)
-- Name: panier panier_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panier
    ADD CONSTRAINT panier_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.client(id_client);


--
-- TOC entry 4741 (class 2606 OID 16505)
-- Name: panier panier_id_produit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panier
    ADD CONSTRAINT panier_id_produit_fkey FOREIGN KEY (id_produit) REFERENCES public.produit(id_produit);


--
-- TOC entry 4738 (class 2606 OID 16483)
-- Name: produit produit_id_magasin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT produit_id_magasin_fkey FOREIGN KEY (id_magasin) REFERENCES public.magasin(id_magasin);


--
-- TOC entry 4739 (class 2606 OID 16488)
-- Name: produit produit_id_sous_categorie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT produit_id_sous_categorie_fkey FOREIGN KEY (id_sous_categorie) REFERENCES public.sous_categorie(id_sous_categorie);


--
-- TOC entry 4734 (class 2606 OID 16418)
-- Name: sous_categorie sous_categorie_id_categorie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sous_categorie
    ADD CONSTRAINT sous_categorie_id_categorie_fkey FOREIGN KEY (id_categorie) REFERENCES public.categorie(id_categorie);


--
-- TOC entry 4735 (class 2606 OID 16441)
-- Name: ville ville_id_pays_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville
    ADD CONSTRAINT ville_id_pays_fkey FOREIGN KEY (id_pays) REFERENCES public.pays(id_pays);


-- Completed on 2024-04-16 11:04:38

--
-- PostgreSQL database dump complete
--

