--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2024-05-14 11:19:20

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
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 234 (class 1255 OID 49415)
-- Name: verifier_admin(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.verifier_admin(p_login text, p_password text) RETURNS integer
    LANGUAGE plpgsql
    AS '
DECLARE
    retour INTEGER;
BEGIN
    -- Utilisez ''utilisateur_id'' directement dans SELECT INTO pour éviter les conflits
    SELECT utilisateur_id FROM public.utilisateurs
    WHERE nom_utilisateur = p_login AND mot_de_passe = p_password
    AND role IN (''administrateur'', ''enseignant'') INTO retour;

    -- Vérifiez si un utilisateur correspondant a été trouvé
    IF retour IS NULL THEN
        RETURN 0; -- Aucun utilisateur correspondant trouvé
    ELSE
        RETURN 1; -- Utilisateur correspondant trouvé
    END IF;
END;
';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 49328)
-- Name: cours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cours (
    cours_id integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text,
    enseignant_id integer
);


--
-- TOC entry 217 (class 1259 OID 49327)
-- Name: cours_cours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cours_cours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 217
-- Name: cours_cours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cours_cours_id_seq OWNED BY public.cours.cours_id;


--
-- TOC entry 226 (class 1259 OID 49398)
-- Name: inscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inscriptions (
    inscription_id integer NOT NULL,
    cours_id integer,
    utilisateur_id integer,
    date_inscription date NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 49397)
-- Name: inscriptions_inscription_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inscriptions_inscription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 225
-- Name: inscriptions_inscription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inscriptions_inscription_id_seq OWNED BY public.inscriptions.inscription_id;


--
-- TOC entry 222 (class 1259 OID 49367)
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    question_id integer NOT NULL,
    quiz_id integer,
    texte_question text NOT NULL,
    reponse_correcte character varying(255) NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 49366)
-- Name: questions_question_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 221
-- Name: questions_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_question_id_seq OWNED BY public.questions.question_id;


--
-- TOC entry 220 (class 1259 OID 49355)
-- Name: quiz; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quiz (
    quiz_id integer NOT NULL,
    cours_id integer,
    titre character varying(255) NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 49354)
-- Name: quiz_quiz_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quiz_quiz_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 219
-- Name: quiz_quiz_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quiz_quiz_id_seq OWNED BY public.quiz.quiz_id;


--
-- TOC entry 228 (class 1259 OID 49428)
-- Name: ressources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ressources (
    ressource_id integer NOT NULL,
    cours_id integer NOT NULL,
    type character varying(50) NOT NULL,
    url character varying(255) NOT NULL,
    description text,
    CONSTRAINT ressources_type_check CHECK (((type)::text = ANY ((ARRAY['video'::character varying, 'document'::character varying, 'image'::character varying, 'other'::character varying])::text[])))
);


--
-- TOC entry 227 (class 1259 OID 49427)
-- Name: ressources_ressource_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ressources_ressource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 227
-- Name: ressources_ressource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ressources_ressource_id_seq OWNED BY public.ressources.ressource_id;


--
-- TOC entry 224 (class 1259 OID 49381)
-- Name: réponses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."réponses" (
    reponse_id integer NOT NULL,
    question_id integer,
    utilisateur_id integer,
    texte_reponse character varying(255) NOT NULL,
    est_correcte boolean NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 49380)
-- Name: réponses_reponse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."réponses_reponse_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 223
-- Name: réponses_reponse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."réponses_reponse_id_seq" OWNED BY public."réponses".reponse_id;


--
-- TOC entry 216 (class 1259 OID 49314)
-- Name: utilisateurs; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 215 (class 1259 OID 49313)
-- Name: utilisateurs_utilisateur_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.utilisateurs_utilisateur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 215
-- Name: utilisateurs_utilisateur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.utilisateurs_utilisateur_id_seq OWNED BY public.utilisateurs.utilisateur_id;


--
-- TOC entry 230 (class 1259 OID 49446)
-- Name: vue_cours_ressources; Type: VIEW; Schema: public; Owner: -
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


--
-- TOC entry 229 (class 1259 OID 49442)
-- Name: vue_details_cours; Type: VIEW; Schema: public; Owner: -
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


--
-- TOC entry 231 (class 1259 OID 49453)
-- Name: vue_details_quiz; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vue_details_quiz AS
 SELECT quiz.quiz_id,
    quiz.titre AS quiz_titre,
    cours.titre AS cours_titre
   FROM (public.quiz
     JOIN public.cours ON ((quiz.cours_id = cours.cours_id)));


--
-- TOC entry 233 (class 1259 OID 49465)
-- Name: vue_questions_reponses; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vue_questions_reponses AS
 SELECT q.question_id,
    q.texte_question,
    r.reponse_id,
    r.texte_reponse,
    r.est_correcte
   FROM (public.questions q
     JOIN public."réponses" r ON ((q.question_id = r.question_id)));


--
-- TOC entry 232 (class 1259 OID 49461)
-- Name: vue_quizz_questions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vue_quizz_questions AS
 SELECT q.quiz_id,
    q.titre AS titre_quiz,
    qu.question_id,
    qu.texte_question
   FROM (public.quiz q
     JOIN public.questions qu ON ((q.quiz_id = qu.quiz_id)));


--
-- TOC entry 4740 (class 2604 OID 49331)
-- Name: cours cours_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cours ALTER COLUMN cours_id SET DEFAULT nextval('public.cours_cours_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 49401)
-- Name: inscriptions inscription_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inscriptions ALTER COLUMN inscription_id SET DEFAULT nextval('public.inscriptions_inscription_id_seq'::regclass);


--
-- TOC entry 4742 (class 2604 OID 49370)
-- Name: questions question_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN question_id SET DEFAULT nextval('public.questions_question_id_seq'::regclass);


--
-- TOC entry 4741 (class 2604 OID 49358)
-- Name: quiz quiz_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz ALTER COLUMN quiz_id SET DEFAULT nextval('public.quiz_quiz_id_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 49431)
-- Name: ressources ressource_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ressources ALTER COLUMN ressource_id SET DEFAULT nextval('public.ressources_ressource_id_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 49384)
-- Name: réponses reponse_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."réponses" ALTER COLUMN reponse_id SET DEFAULT nextval('public."réponses_reponse_id_seq"'::regclass);


--
-- TOC entry 4739 (class 2604 OID 49317)
-- Name: utilisateurs utilisateur_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateurs ALTER COLUMN utilisateur_id SET DEFAULT nextval('public.utilisateurs_utilisateur_id_seq'::regclass);


--
-- TOC entry 4926 (class 0 OID 49328)
-- Dependencies: 218
-- Data for Name: cours; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cours (cours_id, titre, description, enseignant_id) VALUES (2, 'Physique Quantique', 'Introduction à la physique quantique', 3);
INSERT INTO public.cours (cours_id, titre, description, enseignant_id) VALUES (1, 'Mathématiques Fondamentales', 'Cours complet sur les mathématiques', 2);
INSERT INTO public.cours (cours_id, titre, description, enseignant_id) VALUES (3, 'Philo', 'Intro sur la philo', 2);


--
-- TOC entry 4934 (class 0 OID 49398)
-- Dependencies: 226
-- Data for Name: inscriptions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.inscriptions (inscription_id, cours_id, utilisateur_id, date_inscription) VALUES (1, 1, 1, '2024-01-15');
INSERT INTO public.inscriptions (inscription_id, cours_id, utilisateur_id, date_inscription) VALUES (2, 2, 1, '2024-01-15');


--
-- TOC entry 4930 (class 0 OID 49367)
-- Dependencies: 222
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.questions (question_id, quiz_id, texte_question, reponse_correcte) VALUES (1, 1, 'Combien font 2+2 ?', '4');
INSERT INTO public.questions (question_id, quiz_id, texte_question, reponse_correcte) VALUES (2, 1, 'Quel est le résultat de 3*4 ?', '12');
INSERT INTO public.questions (question_id, quiz_id, texte_question, reponse_correcte) VALUES (3, 2, 'Quelle est la formule de la force ?', 'F = ma');
INSERT INTO public.questions (question_id, quiz_id, texte_question, reponse_correcte) VALUES (4, 2, 'Quelle est l''unité de mesure de la charge électrique ?', 'Coulomb');
INSERT INTO public.questions (question_id, quiz_id, texte_question, reponse_correcte) VALUES (5, 3, 'Qui a écrit "L''Être et le Néant" ?', 'Jean-Paul Sartre');
INSERT INTO public.questions (question_id, quiz_id, texte_question, reponse_correcte) VALUES (6, 3, 'Quel philosophe a dit "Je pense, donc je suis" ?', 'René Descartes');


--
-- TOC entry 4928 (class 0 OID 49355)
-- Dependencies: 220
-- Data for Name: quiz; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.quiz (quiz_id, cours_id, titre) VALUES (1, 1, 'Quiz sur les mathématiques');
INSERT INTO public.quiz (quiz_id, cours_id, titre) VALUES (2, 2, 'Quiz sur la physique');
INSERT INTO public.quiz (quiz_id, cours_id, titre) VALUES (3, 3, 'Quiz sur la philosophie');


--
-- TOC entry 4936 (class 0 OID 49428)
-- Dependencies: 228
-- Data for Name: ressources; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.ressources (ressource_id, cours_id, type, url, description) VALUES (15, 1, 'video', 'puuHhlf0jAQ', NULL);
INSERT INTO public.ressources (ressource_id, cours_id, type, url, description) VALUES (16, 2, 'video', '59VTz_aH_uo', NULL);
INSERT INTO public.ressources (ressource_id, cours_id, type, url, description) VALUES (20, 2, 'image', 'https://www.alamyimages.fr/aggregator-api/download?url=https://c8.alamy.com/compfr/2jp18e5/affiche-ronde-de-la-science-de-la-physique-dans-un-style-de-ligne-coloree-banniere-avec-symboles-physiques-illustration-vectorielle-2jp18e5.jpg', NULL);
INSERT INTO public.ressources (ressource_id, cours_id, type, url, description) VALUES (19, 1, 'image', 'https://image.freepik.com/free-vector/maths-realistic-chalkboard-background_23-2148159844.jpg', NULL);
INSERT INTO public.ressources (ressource_id, cours_id, type, url, description) VALUES (29, 3, 'video', '9oHqMEaLlPo', 'Intro sur la philo');
INSERT INTO public.ressources (ressource_id, cours_id, type, url, description) VALUES (30, 3, 'image', 'https://apprendrelaphilosophie.com/wp-content/uploads/2021/11/Cours-de-philosophie-1024x1024.jpg', 'Intro sur la philo');


--
-- TOC entry 4932 (class 0 OID 49381)
-- Dependencies: 224
-- Data for Name: réponses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (1, 1, NULL, '3', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (2, 1, NULL, '4', true);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (3, 1, NULL, '5', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (4, 2, NULL, '10', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (5, 2, NULL, '12', true);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (6, 2, NULL, '15', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (7, 3, NULL, 'F = mv', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (8, 3, NULL, 'F = ma', true);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (9, 3, NULL, 'F = mc²', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (10, 4, NULL, 'Volt', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (11, 4, NULL, 'Ampère', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (12, 4, NULL, 'Coulomb', true);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (13, 5, NULL, 'Jean-Paul Sartre', true);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (14, 5, NULL, 'Albert Camus', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (15, 5, NULL, 'Friedrich Nietzsche', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (16, 6, NULL, 'Socrate', false);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (17, 6, NULL, 'René Descartes', true);
INSERT INTO public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) VALUES (18, 6, NULL, 'Platon', false);


--
-- TOC entry 4924 (class 0 OID 49314)
-- Dependencies: 216
-- Data for Name: utilisateurs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.utilisateurs (utilisateur_id, nom_utilisateur, mot_de_passe, email, role) VALUES (2, 'mdurand', 'motdepasse123', 'mdurand@example.com', 'enseignant');
INSERT INTO public.utilisateurs (utilisateur_id, nom_utilisateur, mot_de_passe, email, role) VALUES (1, 'jdupont', 'motdepasse123', 'jdupont@example.com', 'enseignant');
INSERT INTO public.utilisateurs (utilisateur_id, nom_utilisateur, mot_de_passe, email, role) VALUES (3, 'lsmith', 'motdepasse123', 'lsmith@example.com', 'enseignant');


--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 217
-- Name: cours_cours_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cours_cours_id_seq', 8, true);


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 225
-- Name: inscriptions_inscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inscriptions_inscription_id_seq', 2, true);


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 221
-- Name: questions_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.questions_question_id_seq', 6, true);


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 219
-- Name: quiz_quiz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quiz_quiz_id_seq', 3, true);


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 227
-- Name: ressources_ressource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ressources_ressource_id_seq', 30, true);


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 223
-- Name: réponses_reponse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."réponses_reponse_id_seq"', 18, true);


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 215
-- Name: utilisateurs_utilisateur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.utilisateurs_utilisateur_id_seq', 3, true);


--
-- TOC entry 4756 (class 2606 OID 49335)
-- Name: cours cours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_pkey PRIMARY KEY (cours_id);


--
-- TOC entry 4764 (class 2606 OID 49403)
-- Name: inscriptions inscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inscriptions
    ADD CONSTRAINT inscriptions_pkey PRIMARY KEY (inscription_id);


--
-- TOC entry 4760 (class 2606 OID 49374)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- TOC entry 4758 (class 2606 OID 49360)
-- Name: quiz quiz_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_pkey PRIMARY KEY (quiz_id);


--
-- TOC entry 4766 (class 2606 OID 49436)
-- Name: ressources ressources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ressources
    ADD CONSTRAINT ressources_pkey PRIMARY KEY (ressource_id);


--
-- TOC entry 4762 (class 2606 OID 49386)
-- Name: réponses réponses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_pkey" PRIMARY KEY (reponse_id);


--
-- TOC entry 4750 (class 2606 OID 49326)
-- Name: utilisateurs utilisateurs_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_email_key UNIQUE (email);


--
-- TOC entry 4752 (class 2606 OID 49324)
-- Name: utilisateurs utilisateurs_nom_utilisateur_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_nom_utilisateur_key UNIQUE (nom_utilisateur);


--
-- TOC entry 4754 (class 2606 OID 49322)
-- Name: utilisateurs utilisateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pkey PRIMARY KEY (utilisateur_id);


--
-- TOC entry 4767 (class 2606 OID 49336)
-- Name: cours cours_enseignant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_enseignant_id_fkey FOREIGN KEY (enseignant_id) REFERENCES public.utilisateurs(utilisateur_id);


--
-- TOC entry 4772 (class 2606 OID 49404)
-- Name: inscriptions inscriptions_cours_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inscriptions
    ADD CONSTRAINT inscriptions_cours_id_fkey FOREIGN KEY (cours_id) REFERENCES public.cours(cours_id);


--
-- TOC entry 4773 (class 2606 OID 49409)
-- Name: inscriptions inscriptions_utilisateur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inscriptions
    ADD CONSTRAINT inscriptions_utilisateur_id_fkey FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateurs(utilisateur_id);


--
-- TOC entry 4769 (class 2606 OID 49375)
-- Name: questions questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(quiz_id);


--
-- TOC entry 4768 (class 2606 OID 49361)
-- Name: quiz quiz_cours_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_cours_id_fkey FOREIGN KEY (cours_id) REFERENCES public.cours(cours_id);


--
-- TOC entry 4774 (class 2606 OID 49437)
-- Name: ressources ressources_cours_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ressources
    ADD CONSTRAINT ressources_cours_id_fkey FOREIGN KEY (cours_id) REFERENCES public.cours(cours_id) ON DELETE CASCADE;


--
-- TOC entry 4770 (class 2606 OID 49387)
-- Name: réponses réponses_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_question_id_fkey" FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 4771 (class 2606 OID 49392)
-- Name: réponses réponses_utilisateur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_utilisateur_id_fkey" FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateurs(utilisateur_id);


-- Completed on 2024-05-14 11:19:21

--
-- PostgreSQL database dump complete
--

