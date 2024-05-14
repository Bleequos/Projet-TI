PGDMP          	            |           PlateformeEducative    16.1    16.1 E    K           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            L           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            M           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            N           1262    49211    PlateformeEducative    DATABASE     �   CREATE DATABASE "PlateformeEducative" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'French_France.1252';
 %   DROP DATABASE "PlateformeEducative";
                anonyme    false            �            1255    49415    verifier_admin(text, text)    FUNCTION     �  CREATE FUNCTION public.verifier_admin(p_login text, p_password text) RETURNS integer
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
 D   DROP FUNCTION public.verifier_admin(p_login text, p_password text);
       public          anonyme    false            �            1259    49328    cours    TABLE     �   CREATE TABLE public.cours (
    cours_id integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text,
    enseignant_id integer
);
    DROP TABLE public.cours;
       public         heap    anonyme    false            �            1259    49327    cours_cours_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cours_cours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.cours_cours_id_seq;
       public          anonyme    false    218            O           0    0    cours_cours_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.cours_cours_id_seq OWNED BY public.cours.cours_id;
          public          anonyme    false    217            �            1259    49398    inscriptions    TABLE     �   CREATE TABLE public.inscriptions (
    inscription_id integer NOT NULL,
    cours_id integer,
    utilisateur_id integer,
    date_inscription date NOT NULL
);
     DROP TABLE public.inscriptions;
       public         heap    anonyme    false            �            1259    49397    inscriptions_inscription_id_seq    SEQUENCE     �   CREATE SEQUENCE public.inscriptions_inscription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.inscriptions_inscription_id_seq;
       public          anonyme    false    226            P           0    0    inscriptions_inscription_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.inscriptions_inscription_id_seq OWNED BY public.inscriptions.inscription_id;
          public          anonyme    false    225            �            1259    49367 	   questions    TABLE     �   CREATE TABLE public.questions (
    question_id integer NOT NULL,
    quiz_id integer,
    texte_question text NOT NULL,
    reponse_correcte character varying(255) NOT NULL
);
    DROP TABLE public.questions;
       public         heap    anonyme    false            �            1259    49366    questions_question_id_seq    SEQUENCE     �   CREATE SEQUENCE public.questions_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.questions_question_id_seq;
       public          anonyme    false    222            Q           0    0    questions_question_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.questions_question_id_seq OWNED BY public.questions.question_id;
          public          anonyme    false    221            �            1259    49355    quiz    TABLE     |   CREATE TABLE public.quiz (
    quiz_id integer NOT NULL,
    cours_id integer,
    titre character varying(255) NOT NULL
);
    DROP TABLE public.quiz;
       public         heap    anonyme    false            �            1259    49354    quiz_quiz_id_seq    SEQUENCE     �   CREATE SEQUENCE public.quiz_quiz_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.quiz_quiz_id_seq;
       public          anonyme    false    220            R           0    0    quiz_quiz_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.quiz_quiz_id_seq OWNED BY public.quiz.quiz_id;
          public          anonyme    false    219            �            1259    49428 
   ressources    TABLE     �  CREATE TABLE public.ressources (
    ressource_id integer NOT NULL,
    cours_id integer NOT NULL,
    type character varying(50) NOT NULL,
    url character varying(255) NOT NULL,
    description text,
    CONSTRAINT ressources_type_check CHECK (((type)::text = ANY ((ARRAY['video'::character varying, 'document'::character varying, 'image'::character varying, 'other'::character varying])::text[])))
);
    DROP TABLE public.ressources;
       public         heap    anonyme    false            �            1259    49427    ressources_ressource_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ressources_ressource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.ressources_ressource_id_seq;
       public          anonyme    false    228            S           0    0    ressources_ressource_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.ressources_ressource_id_seq OWNED BY public.ressources.ressource_id;
          public          anonyme    false    227            �            1259    49381 	   réponses    TABLE     �   CREATE TABLE public."réponses" (
    reponse_id integer NOT NULL,
    question_id integer,
    utilisateur_id integer,
    texte_reponse character varying(255) NOT NULL,
    est_correcte boolean NOT NULL
);
    DROP TABLE public."réponses";
       public         heap    anonyme    false            �            1259    49380    réponses_reponse_id_seq    SEQUENCE     �   CREATE SEQUENCE public."réponses_reponse_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."réponses_reponse_id_seq";
       public          anonyme    false    224            T           0    0    réponses_reponse_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."réponses_reponse_id_seq" OWNED BY public."réponses".reponse_id;
          public          anonyme    false    223            �            1259    49314    utilisateurs    TABLE       CREATE TABLE public.utilisateurs (
    utilisateur_id integer NOT NULL,
    nom_utilisateur character varying(255) NOT NULL,
    mot_de_passe character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    CONSTRAINT role_enseignant CHECK (((role)::text = 'enseignant'::text)),
    CONSTRAINT utilisateurs_role_check CHECK (((role)::text = ANY ((ARRAY['étudiant'::character varying, 'enseignant'::character varying, 'administrateur'::character varying])::text[])))
);
     DROP TABLE public.utilisateurs;
       public         heap    anonyme    false            �            1259    49313    utilisateurs_utilisateur_id_seq    SEQUENCE     �   CREATE SEQUENCE public.utilisateurs_utilisateur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.utilisateurs_utilisateur_id_seq;
       public          anonyme    false    216            U           0    0    utilisateurs_utilisateur_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.utilisateurs_utilisateur_id_seq OWNED BY public.utilisateurs.utilisateur_id;
          public          anonyme    false    215            �            1259    49446    vue_cours_ressources    VIEW       CREATE VIEW public.vue_cours_ressources AS
 SELECT cours.cours_id,
    cours.titre,
    cours.description,
    ressources.ressource_id,
    ressources.type,
    ressources.url
   FROM (public.cours
     JOIN public.ressources ON ((ressources.cours_id = cours.cours_id)));
 '   DROP VIEW public.vue_cours_ressources;
       public          anonyme    false    228    228    228    228    218    218    218            �            1259    49442    vue_details_cours    VIEW     0  CREATE VIEW public.vue_details_cours AS
 SELECT c.cours_id,
    c.titre,
    c.description,
    u.utilisateur_id AS enseignant_id,
    u.nom_utilisateur AS nom_enseignant,
    u.email AS email_enseignant
   FROM (public.cours c
     JOIN public.utilisateurs u ON ((c.enseignant_id = u.utilisateur_id)));
 $   DROP VIEW public.vue_details_cours;
       public          anonyme    false    218    218    218    218    216    216    216            �            1259    49453    vue_details_quiz    VIEW     �   CREATE VIEW public.vue_details_quiz AS
 SELECT quiz.quiz_id,
    quiz.titre AS quiz_titre,
    cours.titre AS cours_titre
   FROM (public.quiz
     JOIN public.cours ON ((quiz.cours_id = cours.cours_id)));
 #   DROP VIEW public.vue_details_quiz;
       public          anonyme    false    220    218    218    220    220            �            1259    49465    vue_questions_reponses    VIEW     �   CREATE VIEW public.vue_questions_reponses AS
 SELECT q.question_id,
    q.texte_question,
    r.reponse_id,
    r.texte_reponse,
    r.est_correcte
   FROM (public.questions q
     JOIN public."réponses" r ON ((q.question_id = r.question_id)));
 )   DROP VIEW public.vue_questions_reponses;
       public          anonyme    false    222    222    224    224    224    224            �            1259    49461    vue_quizz_questions    VIEW     �   CREATE VIEW public.vue_quizz_questions AS
 SELECT q.quiz_id,
    q.titre AS titre_quiz,
    qu.question_id,
    qu.texte_question
   FROM (public.quiz q
     JOIN public.questions qu ON ((q.quiz_id = qu.quiz_id)));
 &   DROP VIEW public.vue_quizz_questions;
       public          anonyme    false    220    222    222    220    222            �           2604    49331    cours cours_id    DEFAULT     p   ALTER TABLE ONLY public.cours ALTER COLUMN cours_id SET DEFAULT nextval('public.cours_cours_id_seq'::regclass);
 =   ALTER TABLE public.cours ALTER COLUMN cours_id DROP DEFAULT;
       public          anonyme    false    218    217    218            �           2604    49401    inscriptions inscription_id    DEFAULT     �   ALTER TABLE ONLY public.inscriptions ALTER COLUMN inscription_id SET DEFAULT nextval('public.inscriptions_inscription_id_seq'::regclass);
 J   ALTER TABLE public.inscriptions ALTER COLUMN inscription_id DROP DEFAULT;
       public          anonyme    false    225    226    226            �           2604    49370    questions question_id    DEFAULT     ~   ALTER TABLE ONLY public.questions ALTER COLUMN question_id SET DEFAULT nextval('public.questions_question_id_seq'::regclass);
 D   ALTER TABLE public.questions ALTER COLUMN question_id DROP DEFAULT;
       public          anonyme    false    222    221    222            �           2604    49358    quiz quiz_id    DEFAULT     l   ALTER TABLE ONLY public.quiz ALTER COLUMN quiz_id SET DEFAULT nextval('public.quiz_quiz_id_seq'::regclass);
 ;   ALTER TABLE public.quiz ALTER COLUMN quiz_id DROP DEFAULT;
       public          anonyme    false    219    220    220            �           2604    49431    ressources ressource_id    DEFAULT     �   ALTER TABLE ONLY public.ressources ALTER COLUMN ressource_id SET DEFAULT nextval('public.ressources_ressource_id_seq'::regclass);
 F   ALTER TABLE public.ressources ALTER COLUMN ressource_id DROP DEFAULT;
       public          anonyme    false    228    227    228            �           2604    49384    réponses reponse_id    DEFAULT     �   ALTER TABLE ONLY public."réponses" ALTER COLUMN reponse_id SET DEFAULT nextval('public."réponses_reponse_id_seq"'::regclass);
 E   ALTER TABLE public."réponses" ALTER COLUMN reponse_id DROP DEFAULT;
       public          anonyme    false    223    224    224            �           2604    49317    utilisateurs utilisateur_id    DEFAULT     �   ALTER TABLE ONLY public.utilisateurs ALTER COLUMN utilisateur_id SET DEFAULT nextval('public.utilisateurs_utilisateur_id_seq'::regclass);
 J   ALTER TABLE public.utilisateurs ALTER COLUMN utilisateur_id DROP DEFAULT;
       public          anonyme    false    215    216    216            >          0    49328    cours 
   TABLE DATA           L   COPY public.cours (cours_id, titre, description, enseignant_id) FROM stdin;
    public          anonyme    false    218   UZ       F          0    49398    inscriptions 
   TABLE DATA           b   COPY public.inscriptions (inscription_id, cours_id, utilisateur_id, date_inscription) FROM stdin;
    public          anonyme    false    226   �Z       B          0    49367 	   questions 
   TABLE DATA           [   COPY public.questions (question_id, quiz_id, texte_question, reponse_correcte) FROM stdin;
    public          anonyme    false    222   [       @          0    49355    quiz 
   TABLE DATA           8   COPY public.quiz (quiz_id, cours_id, titre) FROM stdin;
    public          anonyme    false    220   \       H          0    49428 
   ressources 
   TABLE DATA           T   COPY public.ressources (ressource_id, cours_id, type, url, description) FROM stdin;
    public          anonyme    false    228   f\       D          0    49381 	   réponses 
   TABLE DATA           k   COPY public."réponses" (reponse_id, question_id, utilisateur_id, texte_reponse, est_correcte) FROM stdin;
    public          anonyme    false    224   �]       <          0    49314    utilisateurs 
   TABLE DATA           b   COPY public.utilisateurs (utilisateur_id, nom_utilisateur, mot_de_passe, email, role) FROM stdin;
    public          anonyme    false    216   �^       V           0    0    cours_cours_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.cours_cours_id_seq', 8, true);
          public          anonyme    false    217            W           0    0    inscriptions_inscription_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.inscriptions_inscription_id_seq', 2, true);
          public          anonyme    false    225            X           0    0    questions_question_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.questions_question_id_seq', 6, true);
          public          anonyme    false    221            Y           0    0    quiz_quiz_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.quiz_quiz_id_seq', 3, true);
          public          anonyme    false    219            Z           0    0    ressources_ressource_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.ressources_ressource_id_seq', 30, true);
          public          anonyme    false    227            [           0    0    réponses_reponse_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."réponses_reponse_id_seq"', 18, true);
          public          anonyme    false    223            \           0    0    utilisateurs_utilisateur_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.utilisateurs_utilisateur_id_seq', 3, true);
          public          anonyme    false    215            �           2606    49335    cours cours_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_pkey PRIMARY KEY (cours_id);
 :   ALTER TABLE ONLY public.cours DROP CONSTRAINT cours_pkey;
       public            anonyme    false    218            �           2606    49403    inscriptions inscriptions_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.inscriptions
    ADD CONSTRAINT inscriptions_pkey PRIMARY KEY (inscription_id);
 H   ALTER TABLE ONLY public.inscriptions DROP CONSTRAINT inscriptions_pkey;
       public            anonyme    false    226            �           2606    49374    questions questions_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);
 B   ALTER TABLE ONLY public.questions DROP CONSTRAINT questions_pkey;
       public            anonyme    false    222            �           2606    49360    quiz quiz_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_pkey PRIMARY KEY (quiz_id);
 8   ALTER TABLE ONLY public.quiz DROP CONSTRAINT quiz_pkey;
       public            anonyme    false    220            �           2606    49436    ressources ressources_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.ressources
    ADD CONSTRAINT ressources_pkey PRIMARY KEY (ressource_id);
 D   ALTER TABLE ONLY public.ressources DROP CONSTRAINT ressources_pkey;
       public            anonyme    false    228            �           2606    49386    réponses réponses_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_pkey" PRIMARY KEY (reponse_id);
 F   ALTER TABLE ONLY public."réponses" DROP CONSTRAINT "réponses_pkey";
       public            anonyme    false    224            �           2606    49326 #   utilisateurs utilisateurs_email_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_email_key UNIQUE (email);
 M   ALTER TABLE ONLY public.utilisateurs DROP CONSTRAINT utilisateurs_email_key;
       public            anonyme    false    216            �           2606    49324 -   utilisateurs utilisateurs_nom_utilisateur_key 
   CONSTRAINT     s   ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_nom_utilisateur_key UNIQUE (nom_utilisateur);
 W   ALTER TABLE ONLY public.utilisateurs DROP CONSTRAINT utilisateurs_nom_utilisateur_key;
       public            anonyme    false    216            �           2606    49322    utilisateurs utilisateurs_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pkey PRIMARY KEY (utilisateur_id);
 H   ALTER TABLE ONLY public.utilisateurs DROP CONSTRAINT utilisateurs_pkey;
       public            anonyme    false    216            �           2606    49336    cours cours_enseignant_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_enseignant_id_fkey FOREIGN KEY (enseignant_id) REFERENCES public.utilisateurs(utilisateur_id);
 H   ALTER TABLE ONLY public.cours DROP CONSTRAINT cours_enseignant_id_fkey;
       public          anonyme    false    218    216    4754            �           2606    49404 '   inscriptions inscriptions_cours_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inscriptions
    ADD CONSTRAINT inscriptions_cours_id_fkey FOREIGN KEY (cours_id) REFERENCES public.cours(cours_id);
 Q   ALTER TABLE ONLY public.inscriptions DROP CONSTRAINT inscriptions_cours_id_fkey;
       public          anonyme    false    4756    226    218            �           2606    49409 -   inscriptions inscriptions_utilisateur_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inscriptions
    ADD CONSTRAINT inscriptions_utilisateur_id_fkey FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateurs(utilisateur_id);
 W   ALTER TABLE ONLY public.inscriptions DROP CONSTRAINT inscriptions_utilisateur_id_fkey;
       public          anonyme    false    216    226    4754            �           2606    49375     questions questions_quiz_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(quiz_id);
 J   ALTER TABLE ONLY public.questions DROP CONSTRAINT questions_quiz_id_fkey;
       public          anonyme    false    222    4758    220            �           2606    49361    quiz quiz_cours_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_cours_id_fkey FOREIGN KEY (cours_id) REFERENCES public.cours(cours_id);
 A   ALTER TABLE ONLY public.quiz DROP CONSTRAINT quiz_cours_id_fkey;
       public          anonyme    false    4756    218    220            �           2606    49437 #   ressources ressources_cours_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ressources
    ADD CONSTRAINT ressources_cours_id_fkey FOREIGN KEY (cours_id) REFERENCES public.cours(cours_id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.ressources DROP CONSTRAINT ressources_cours_id_fkey;
       public          anonyme    false    218    4756    228            �           2606    49387 $   réponses réponses_question_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_question_id_fkey" FOREIGN KEY (question_id) REFERENCES public.questions(question_id);
 R   ALTER TABLE ONLY public."réponses" DROP CONSTRAINT "réponses_question_id_fkey";
       public          anonyme    false    4760    224    222            �           2606    49392 '   réponses réponses_utilisateur_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."réponses"
    ADD CONSTRAINT "réponses_utilisateur_id_fkey" FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateurs(utilisateur_id);
 U   ALTER TABLE ONLY public."réponses" DROP CONSTRAINT "réponses_utilisateur_id_fkey";
       public          anonyme    false    4754    216    224            >   �   x�3�Ȩ,�,,MU,M�+�8=�J��SJ�K2��/P�IT(��*��2�2��M,�8�27,R���������W���Z��_ZT����[��Z�P\Z� U�E��i�etBfN>�V�2�} !#�=... >;�      F   !   x�3�4B##]C]CS.#N#T�=... w �      B   �   x�]�;N�0Ek{Oӌ�g�8�Q��F|Z�\��cg��;�:�1^�h(��G�5��0�[x�>��Tt/:�8x.p��Ɂb�SqYg�A�E�P�d+�J1�r�%q,|2�{0�Hw4j��÷��\��J���A�OP�L��\�>�K�hYbIsn�ʹ9n�w�2֥�:k�7�8@��']��Ȁ�]���4XR���_��pE}���@�شX^�y��a	�|�I) �d�      @   G   x�3�4�,ͬR(.-R�I-V�M,�8�Hf��sq!�'*dT�d��9��$2s��T*W� m��      H   w  x�mQ�j�0�m?E^@��$#�1� ���P��n�[����n����d�0��չ���#�.D�[�¥��͡>��+oJ�d�<ܿ�`�K4!�Έ�â�х����X���<_���9t��"yN�Fk��ɛoW�ڼ�*E��e�<:��5��A��'�"�� J�U���砟R��,�l�A�Yd�yD�k5zd�����'��=0mL
�C�dY�ɚ5�\ꢥ:�n���f}n|�r��N��6�� ��y�CԊ��iO��,J�:Oɶ;�dR�6b�lV��[�)���>���-�m���/,\���:g~V�y��GsN���,ot��F���!��Z
.�Iɇɾ&j�z��Y���ʲ|���j      D   �   x�M�?�0�������W�ap D'�Rk )Ԕ���t�r1�R��~��{���*G>�c�� �;�g%݁�A%Z����tF��{�߯<��a���8XtU�XK�M�����ϑT�Ru5�>��Y�~S�Q��ie�%�ڐ�u�`o�g�7���0��7�B�"���kff;r��!'1p�ػ��̨��c�X�Mh      <   Y   x�u�A
�  ���c�=���K�*���;T���8�WPɍ��Z�:���w���lY��r�5hC'�����Y��v��YZ">�;y     