--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2024-06-09 20:32:34

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
-- TOC entry 234 (class 1255 OID 57659)
-- Name: ajout_cours(text, text, integer, text, text); Type: FUNCTION; Schema: public; Owner: anonyme
--

CREATE FUNCTION public.ajout_cours(p_titre_cours text, p_description text, p_enseignant_id integer, p_image_link text, p_video_link text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cours_id integer;
BEGIN
    -- Insert the course
    INSERT INTO cours (titre, description, enseignant_id)
    VALUES (p_titre_cours, p_description, p_enseignant_id)
    RETURNING cours_id INTO v_cours_id;

    -- Insert the image link
    INSERT INTO ressources (cours_id, type, url)
    VALUES (v_cours_id, 'image', p_image_link);

    -- Insert the video link
    INSERT INTO ressources (cours_id, type, url)
    VALUES (v_cours_id, 'video', p_video_link);

    RETURN v_cours_id;
END;
$$;


ALTER FUNCTION public.ajout_cours(p_titre_cours text, p_description text, p_enseignant_id integer, p_image_link text, p_video_link text) OWNER TO anonyme;

--
-- TOC entry 233 (class 1255 OID 57662)
-- Name: delete_cours(integer); Type: FUNCTION; Schema: public; Owner: anonyme
--

CREATE FUNCTION public.delete_cours(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Delete quizzes associated with the course
    DELETE FROM quiz WHERE cours_id = p_id;

    -- Delete resources associated with the course
    DELETE FROM ressources WHERE cours_id = p_id;

    -- Delete the course
    DELETE FROM cours WHERE cours_id = p_id;
END;
$$;


ALTER FUNCTION public.delete_cours(p_id integer) OWNER TO anonyme;

--
-- TOC entry 235 (class 1255 OID 57660)
-- Name: update_cours_ressources(integer, text, text, text); Type: FUNCTION; Schema: public; Owner: anonyme
--

CREATE FUNCTION public.update_cours_ressources(p_id integer, p_champ text, p_valeur text, p_table text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    sql text;
BEGIN
    IF p_table = 'cours' OR p_table = 'ressources' THEN
        sql := format('UPDATE %I SET %I = %L WHERE cours_id = %L', p_table, p_champ, p_valeur, p_id);
        EXECUTE sql;
        RETURN 1;
    ELSE
        RAISE EXCEPTION 'Invalid table name. Only "cours" and "ressources" are allowed.';
    END IF;
END;
$$;


ALTER FUNCTION public.update_cours_ressources(p_id integer, p_champ text, p_valeur text, p_table text) OWNER TO anonyme;

--
-- TOC entry 247 (class 1255 OID 57661)
-- Name: update_cours_ressources(integer, text, text, text, text); Type: FUNCTION; Schema: public; Owner: anonyme
--

CREATE FUNCTION public.update_cours_ressources(p_id integer, p_champ text, p_valeur text, p_table text, p_type text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_cours_ressources(p_id integer, p_champ text, p_valeur text, p_table text, p_type text) OWNER TO anonyme;

--
-- TOC entry 232 (class 1255 OID 49415)
-- Name: verifier_admin(text, text); Type: FUNCTION; Schema: public; Owner: anonyme
--

CREATE FUNCTION public.verifier_admin(p_login text, p_password text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.verifier_admin(p_login text, p_password text) OWNER TO anonyme;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 49328)
-- Name: cours; Type: TABLE; Schema: public; Owner: anonyme
--

CREATE TABLE public.cours (
    cours_id integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text,
    enseignant_id integer
);


ALTER TABLE public.cours OWNER TO anonyme;

--
-- TOC entry 217 (class 1259 OID 49327)
-- Name: cours_cours_id_seq; Type: SEQUENCE; Schema: public; Owner: anonyme
--

CREATE SEQUENCE public.cours_cours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cours_cours_id_seq OWNER TO anonyme;

--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 217
-- Name: cours_cours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anonyme
--

ALTER SEQUENCE public.cours_cours_id_seq OWNED BY public.cours.cours_id;


--
-- TOC entry 222 (class 1259 OID 49367)
-- Name: questions; Type: TABLE; Schema: public; Owner: anonyme
--

CREATE TABLE public.questions (
    question_id integer NOT NULL,
    quiz_id integer,
    texte_question text NOT NULL,
    reponse_correcte character varying(255) NOT NULL
);


ALTER TABLE public.questions OWNER TO anonyme;

--
-- TOC entry 221 (class 1259 OID 49366)
-- Name: questions_question_id_seq; Type: SEQUENCE; Schema: public; Owner: anonyme
--

CREATE SEQUENCE public.questions_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questions_question_id_seq OWNER TO anonyme;

--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 221
-- Name: questions_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anonyme
--

ALTER SEQUENCE public.questions_question_id_seq OWNED BY public.questions.question_id;


--
-- TOC entry 220 (class 1259 OID 49355)
-- Name: quiz; Type: TABLE; Schema: public; Owner: anonyme
--

CREATE TABLE public.quiz (
    quiz_id integer NOT NULL,
    cours_id integer,
    titre character varying(255) NOT NULL
);


ALTER TABLE public.quiz OWNER TO anonyme;

--
-- TOC entry 219 (class 1259 OID 49354)
-- Name: quiz_quiz_id_seq; Type: SEQUENCE; Schema: public; Owner: anonyme
--

CREATE SEQUENCE public.quiz_quiz_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quiz_quiz_id_seq OWNER TO anonyme;

--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 219
-- Name: quiz_quiz_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anonyme
--

ALTER SEQUENCE public.quiz_quiz_id_seq OWNED BY public.quiz.quiz_id;


--
-- TOC entry 226 (class 1259 OID 49428)
-- Name: ressources; Type: TABLE; Schema: public; Owner: anonyme
--

CREATE TABLE public.ressources (
    ressource_id integer NOT NULL,
    cours_id integer NOT NULL,
    type character varying(50) NOT NULL,
    url character varying(255) NOT NULL,
    description text,
    CONSTRAINT ressources_type_check CHECK (((type)::text = ANY ((ARRAY['video'::character varying, 'document'::character varying, 'image'::character varying, 'other'::character varying])::text[])))
);


ALTER TABLE public.ressources OWNER TO anonyme;

--
-- TOC entry 225 (class 1259 OID 49427)
-- Name: ressources_ressource_id_seq; Type: SEQUENCE; Schema: public; Owner: anonyme
--

CREATE SEQUENCE public.ressources_ressource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ressources_ressource_id_seq OWNER TO anonyme;

--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 225
-- Name: ressources_ressource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anonyme
--

ALTER SEQUENCE public.ressources_ressource_id_seq OWNED BY public.ressources.ressource_id;


--
-- TOC entry 224 (class 1259 OID 49381)
-- Name: réponses; Type: TABLE; Schema: public; Owner: anonyme
--

CREATE TABLE public."réponses" (
    reponse_id integer NOT NULL,
    question_id integer,
    utilisateur_id integer,
    texte_reponse character varying(255) NOT NULL,
    est_correcte boolean NOT NULL
);


ALTER TABLE public."réponses" OWNER TO anonyme;

--
-- TOC entry 223 (class 1259 OID 49380)
-- Name: réponses_reponse_id_seq; Type: SEQUENCE; Schema: public; Owner: anonyme
--

CREATE SEQUENCE public."réponses_reponse_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."réponses_reponse_id_seq" OWNER TO anonyme;

--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 223
-- Name: réponses_reponse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anonyme
--

ALTER SEQUENCE public."réponses_reponse_id_seq" OWNED BY public."réponses".reponse_id;


--
-- TOC entry 216 (class 1259 OID 49314)
-- Name: utilisateurs; Type: TABLE; Schema: public; Owner: anonyme
--

CREATE TABLE public.utilisateurs (
    utilisateur_id integer NOT NULL,
    nom_utilisateur character varying(255) NOT NULL,
    mot_de_passe character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    CONSTRAINT role_enseignant CHECK (((role)::text = 'enseignant'::text)),
    CONSTRAINT utilisateurs_role_check CHECK (((role)::text = ANY ((ARRAY['étudiant'::character varying, 'enseignant'::character varying, 'administrateur'::character varying])::text[])))
);


ALTER TABLE public.utilisateurs OWNER TO anonyme;

--
-- TOC entry 215 (class 1259 OID 49313)
-- Name: utilisateurs_utilisateur_id_seq; Type: SEQUENCE; Schema: public; Owner: anonyme
--

CREATE SEQUENCE public.utilisateurs_utilisateur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.utilisateurs_utilisateur_id_seq OWNER TO anonyme;

--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 215
-- Name: utilisateurs_utilisateur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anonyme
--

ALTER SEQUENCE public.utilisateurs_utilisateur_id_seq OWNED BY public.utilisateurs.utilisateur_id;


--
-- TOC entry 228 (class 1259 OID 49446)
-- Name: vue_cours_ressources; Type: VIEW; Schema: public; Owner: anonyme
--

CREATE VIEW public.vue_cours_ressources AS
 SELECT cours.cours_id,
    cours.titre,
    cours.description,
    ressources.ressource_id,
    ressources.type,
    ressources.url
   FROM (public.cours
     JOIN public.ressources ON ((ressources.cours_id = cours.cours_id)));


ALTER VIEW public.vue_cours_ressources OWNER TO anonyme;

--
-- TOC entry 227 (class 1259 OID 49442)
-- Name: vue_details_cours; Type: VIEW; Schema: public; Owner: anonyme
--

CREATE VIEW public.vue_details_cours AS
 SELECT c.cours_id,
    c.titre,
    c.description,
    u.utilisateur_id AS enseignant_id,
    u.nom_utilisateur AS nom_enseignant,
    u.email AS email_enseignant
   FROM (public.cours c
     JOIN public.utilisateurs u ON ((c.enseignant_id = u.utilisateur_id)));


ALTER VIEW public.vue_details_cours OWNER TO anonyme;

--
-- TOC entry 229 (class 1259 OID 49453)
-- Name: vue_details_quiz; Type: VIEW; Schema: public; Owner: anonyme
--

CREATE VIEW public.vue_details_quiz AS
 SELECT quiz.quiz_id,
    quiz.titre AS quiz_titre,
    cours.titre AS cours_titre
   FROM (public.quiz
     JOIN public.cours ON ((quiz.cours_id = cours.cours_id)));


ALTER VIEW public.vue_details_quiz OWNER TO anonyme;

--
-- TOC entry 231 (class 1259 OID 49465)
-- Name: vue_questions_reponses; Type: VIEW; Schema: public; Owner: anonyme
--

CREATE VIEW public.vue_questions_reponses AS
 SELECT q.question_id,
    q.texte_question,
    r.reponse_id,
    r.texte_reponse,
    r.est_correcte
   FROM (public.questions q
     JOIN public."réponses" r ON ((q.question_id = r.question_id)));


ALTER VIEW public.vue_questions_reponses OWNER TO anonyme;

--
-- TOC entry 230 (class 1259 OID 49461)
-- Name: vue_quizz_questions; Type: VIEW; Schema: public; Owner: anonyme
--

CREATE VIEW public.vue_quizz_questions AS
 SELECT q.quiz_id,
    q.titre AS titre_quiz,
    qu.question_id,
    qu.texte_question
   FROM (public.quiz q
     JOIN public.questions qu ON ((q.quiz_id = qu.quiz_id)));


ALTER VIEW public.vue_quizz_questions OWNER TO anonyme;

--
-- TOC entry 4739 (class 2604 OID 49331)
-- Name: cours cours_id; Type: DEFAULT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.cours ALTER COLUMN cours_id SET DEFAULT nextval('public.cours_cours_id_seq'::regclass);


--
-- TOC entry 4741 (class 2604 OID 49370)
-- Name: questions question_id; Type: DEFAULT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.questions ALTER COLUMN question_id SET DEFAULT nextval('public.questions_question_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 49358)
-- Name: quiz quiz_id; Type: DEFAULT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.quiz ALTER COLUMN quiz_id SET DEFAULT nextval('public.quiz_quiz_id_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 49431)
-- Name: ressources ressource_id; Type: DEFAULT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.ressources ALTER COLUMN ressource_id SET DEFAULT nextval('public.ressources_ressource_id_seq'::regclass);


--
-- TOC entry 4742 (class 2604 OID 49384)
-- Name: réponses reponse_id; Type: DEFAULT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public."réponses" ALTER COLUMN reponse_id SET DEFAULT nextval('public."réponses_reponse_id_seq"'::regclass);


--
-- TOC entry 4738 (class 2604 OID 49317)
-- Name: utilisateurs utilisateur_id; Type: DEFAULT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.utilisateurs ALTER COLUMN utilisateur_id SET DEFAULT nextval('public.utilisateurs_utilisateur_id_seq'::regclass);


--
-- TOC entry 4919 (class 0 OID 49328)
-- Dependencies: 218
-- Data for Name: cours; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.cours (cours_id, titre, description, enseignant_id) FROM stdin;
1	Cours de Mathématiques	Introduction aux mathématiques	1
2	Cours de Physique	Introduction à la physique	2
3	Cours de Chimie	Introduction à la chimie	3
\.


--
-- TOC entry 4923 (class 0 OID 49367)
-- Dependencies: 222
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.questions (question_id, quiz_id, texte_question, reponse_correcte) FROM stdin;
1	1	Quelle est la valeur de pi ?	3.14
2	1	Combien font 2 + 2 ?	4
3	1	Quelle est la racine carrée de 16 ?	4
4	2	Quelle est la vitesse de la lumière ?	299792458 m/s
5	2	Quel est lunité de force ?	Newton
6	2	Quelle est la formule de la relativité restreinte ?	E=mc^2
7	3	Quelle est la formule chimique de leau ?	H2O
8	3	Quel est le numéro atomique de loxygène ?	8
9	3	Quelle est la formule de lacide sulfurique ?	H2SO4
\.


--
-- TOC entry 4921 (class 0 OID 49355)
-- Dependencies: 220
-- Data for Name: quiz; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.quiz (quiz_id, cours_id, titre) FROM stdin;
1	1	Quiz de Mathématiques
2	2	Quiz de Physique
3	3	Quiz de Chimie
\.


--
-- TOC entry 4927 (class 0 OID 49428)
-- Dependencies: 226
-- Data for Name: ressources; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.ressources (ressource_id, cours_id, type, url, description) FROM stdin;
1	1	image	https://th.bing.com/th/id/R.060fdcd749da109e5c8c83c065db9245?rik=QSxLofKkrkofHA&pid=ImgRaw&r=0	Image pour le cours de mathématiques
2	1	video	_13bBkWK7Is	Vidéo pour le cours de mathématiques
4	2	video	A8Ym7S5UXEc	Vidéo pour le cours de physique
6	3	video	EU3TqRY8Hc8	Vidéo pour le cours de chimie
3	2	image	https://storage.letudiant.fr/mediatheque/letudiant/4/9/2232849-spe-physique-chimie-766x438.jpg	Image pour le cours de physique
5	3	image	https://img.freepik.com/vecteurs-libre/gribouillis-scientifiques_23-2147501583.jpg?size=338	Image pour le cours de chimie
\.


--
-- TOC entry 4925 (class 0 OID 49381)
-- Dependencies: 224
-- Data for Name: réponses; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) FROM stdin;
1	1	1	3.14	t
2	1	1	3	f
3	1	1	2	f
4	2	1	4	t
5	2	1	5	f
6	2	1	3	f
7	3	1	4	t
8	3	1	5	f
9	3	1	6	f
10	4	2	299792458 m/s	t
11	4	2	150000000 m/s	f
12	4	2	300000000 m/s	f
13	5	2	Newton	t
14	5	2	Joule	f
15	5	2	Watt	f
16	6	2	E=mc^2	t
17	6	2	F=ma	f
18	6	2	a^2 + b^2 = c^2	f
19	7	3	H2O	t
20	7	3	HO2	f
21	7	3	H2O2	f
22	8	3	8	t
23	8	3	6	f
24	8	3	7	f
25	9	3	H2SO4	t
26	9	3	HSO4	f
27	9	3	H2SO3	f
\.


--
-- TOC entry 4917 (class 0 OID 49314)
-- Dependencies: 216
-- Data for Name: utilisateurs; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.utilisateurs (utilisateur_id, nom_utilisateur, mot_de_passe, email, role) FROM stdin;
1	prof1	mdp1	prof1@example.com	enseignant
2	prof2	mdp2	prof2@example.com	enseignant
3	prof3	mdp3	prof3@example.com	enseignant
\.


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 217
-- Name: cours_cours_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.cours_cours_id_seq', 3, true);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 221
-- Name: questions_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.questions_question_id_seq', 9, true);


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 219
-- Name: quiz_quiz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.quiz_quiz_id_seq', 3, true);


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 225
-- Name: ressources_ressource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.ressources_ressource_id_seq', 6, true);


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 223
-- Name: réponses_reponse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public."réponses_reponse_id_seq"', 27, true);


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 215
-- Name: utilisateurs_utilisateur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.utilisateurs_utilisateur_id_seq', 3, true);


--
-- TOC entry 4754 (class 2606 OID 49335)
-- Name: cours cours_pkey; Type: CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_pkey PRIMARY KEY (cours_id);


--
-- TOC entry 4758 (class 2606 OID 49374)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- TOC entry 4756 (class 2606 OID 49360)
-- Name: quiz quiz_pkey; Type: CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_pkey PRIMARY KEY (quiz_id);


--
-- TOC entry 4762 (class 2606 OID 49436)
-- Name: ressources ressources_pkey; Type: CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.ressources
    ADD CONSTRAINT ressources_pkey PRIMARY KEY (ressource_id);


--
-- TOC entry 4760 (class 2606 OID 49386)
-- Name: réponses réponses_pkey; Type: CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_pkey" PRIMARY KEY (reponse_id);


--
-- TOC entry 4748 (class 2606 OID 49326)
-- Name: utilisateurs utilisateurs_email_key; Type: CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_email_key UNIQUE (email);


--
-- TOC entry 4750 (class 2606 OID 49324)
-- Name: utilisateurs utilisateurs_nom_utilisateur_key; Type: CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_nom_utilisateur_key UNIQUE (nom_utilisateur);


--
-- TOC entry 4752 (class 2606 OID 49322)
-- Name: utilisateurs utilisateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pkey PRIMARY KEY (utilisateur_id);


--
-- TOC entry 4763 (class 2606 OID 49336)
-- Name: cours cours_enseignant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_enseignant_id_fkey FOREIGN KEY (enseignant_id) REFERENCES public.utilisateurs(utilisateur_id);


--
-- TOC entry 4764 (class 2606 OID 49375)
-- Name: questions questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(quiz_id);


--
-- TOC entry 4767 (class 2606 OID 49437)
-- Name: ressources ressources_cours_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public.ressources
    ADD CONSTRAINT ressources_cours_id_fkey FOREIGN KEY (cours_id) REFERENCES public.cours(cours_id) ON DELETE CASCADE;


--
-- TOC entry 4765 (class 2606 OID 49387)
-- Name: réponses réponses_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_question_id_fkey" FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 4766 (class 2606 OID 49392)
-- Name: réponses réponses_utilisateur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anonyme
--

ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_utilisateur_id_fkey" FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateurs(utilisateur_id);


-- Completed on 2024-06-09 20:32:34

--
-- PostgreSQL database dump complete
--

