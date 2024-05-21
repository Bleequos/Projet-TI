--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2024-05-21 16:17:45

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
-- TOC entry 4916 (class 0 OID 49314)
-- Dependencies: 216
-- Data for Name: utilisateurs; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.utilisateurs (utilisateur_id, nom_utilisateur, mot_de_passe, email, role) FROM stdin;
2	mdurand	motdepasse123	mdurand@example.com	enseignant
1	jdupont	motdepasse123	jdupont@example.com	enseignant
3	lsmith	motdepasse123	lsmith@example.com	enseignant
\.


--
-- TOC entry 4918 (class 0 OID 49328)
-- Dependencies: 218
-- Data for Name: cours; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.cours (cours_id, titre, description, enseignant_id) FROM stdin;
2	Physique Quantique	Introduction à la physique quantique	3
1	Mathématiques Fondamentales	Cours complet sur les mathématiques	2
3	Philo	Intro sur la philo	2
9	azaze	Commerce en ligne	2
\.


--
-- TOC entry 4926 (class 0 OID 49398)
-- Dependencies: 226
-- Data for Name: inscriptions; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.inscriptions (inscription_id, cours_id, utilisateur_id, date_inscription) FROM stdin;
1	1	1	2024-01-15
2	2	1	2024-01-15
\.


--
-- TOC entry 4920 (class 0 OID 49355)
-- Dependencies: 220
-- Data for Name: quiz; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.quiz (quiz_id, cours_id, titre) FROM stdin;
1	1	Quiz sur les mathématiques
2	2	Quiz sur la physique
3	3	Quiz sur la philosophie
\.


--
-- TOC entry 4922 (class 0 OID 49367)
-- Dependencies: 222
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.questions (question_id, quiz_id, texte_question, reponse_correcte) FROM stdin;
1	1	Combien font 2+2 ?	4
2	1	Quel est le résultat de 3*4 ?	12
3	2	Quelle est la formule de la force ?	F = ma
4	2	Quelle est l'unité de mesure de la charge électrique ?	Coulomb
5	3	Qui a écrit "L'Être et le Néant" ?	Jean-Paul Sartre
6	3	Quel philosophe a dit "Je pense, donc je suis" ?	René Descartes
\.


--
-- TOC entry 4928 (class 0 OID 49428)
-- Dependencies: 228
-- Data for Name: ressources; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public.ressources (ressource_id, cours_id, type, url, description) FROM stdin;
15	1	video	puuHhlf0jAQ	\N
16	2	video	59VTz_aH_uo	\N
20	2	image	https://www.alamyimages.fr/aggregator-api/download?url=https://c8.alamy.com/compfr/2jp18e5/affiche-ronde-de-la-science-de-la-physique-dans-un-style-de-ligne-coloree-banniere-avec-symboles-physiques-illustration-vectorielle-2jp18e5.jpg	\N
19	1	image	https://image.freepik.com/free-vector/maths-realistic-chalkboard-background_23-2148159844.jpg	\N
29	3	video	9oHqMEaLlPo	Intro sur la philo
30	3	image	https://apprendrelaphilosophie.com/wp-content/uploads/2021/11/Cours-de-philosophie-1024x1024.jpg	Intro sur la philo
\.


--
-- TOC entry 4924 (class 0 OID 49381)
-- Dependencies: 224
-- Data for Name: réponses; Type: TABLE DATA; Schema: public; Owner: anonyme
--

COPY public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) FROM stdin;
1	1	\N	3	f
2	1	\N	4	t
3	1	\N	5	f
4	2	\N	10	f
5	2	\N	12	t
6	2	\N	15	f
7	3	\N	F = mv	f
8	3	\N	F = ma	t
9	3	\N	F = mc²	f
10	4	\N	Volt	f
11	4	\N	Ampère	f
12	4	\N	Coulomb	t
13	5	\N	Jean-Paul Sartre	t
14	5	\N	Albert Camus	f
15	5	\N	Friedrich Nietzsche	f
16	6	\N	Socrate	f
17	6	\N	René Descartes	t
18	6	\N	Platon	f
\.


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 217
-- Name: cours_cours_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.cours_cours_id_seq', 10, true);


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 225
-- Name: inscriptions_inscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.inscriptions_inscription_id_seq', 2, true);


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 221
-- Name: questions_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.questions_question_id_seq', 6, true);


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 219
-- Name: quiz_quiz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.quiz_quiz_id_seq', 3, true);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 227
-- Name: ressources_ressource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.ressources_ressource_id_seq', 30, true);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 223
-- Name: réponses_reponse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public."réponses_reponse_id_seq"', 18, true);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 215
-- Name: utilisateurs_utilisateur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anonyme
--

SELECT pg_catalog.setval('public.utilisateurs_utilisateur_id_seq', 3, true);


-- Completed on 2024-05-21 16:17:45

--
-- PostgreSQL database dump complete
--

