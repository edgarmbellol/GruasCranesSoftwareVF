--
-- PostgreSQL database dump
--

\restrict DOsy3vwZ0ydk5YgemUC2jhSK7KogskLWU01NYdzGnEs8rfEvvWikFjPf8F2K1Ib

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cargos; Type: TABLE; Schema: public; Owner: gruas_user
--

CREATE TABLE public.cargos (
    "IdCargo" integer NOT NULL,
    "descripcionCargo" character varying(100) NOT NULL,
    "Estado" character varying(20)
);


ALTER TABLE public.cargos OWNER TO gruas_user;

--
-- Name: cargos_IdCargo_seq; Type: SEQUENCE; Schema: public; Owner: gruas_user
--

CREATE SEQUENCE public."cargos_IdCargo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."cargos_IdCargo_seq" OWNER TO gruas_user;

--
-- Name: cargos_IdCargo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gruas_user
--

ALTER SEQUENCE public."cargos_IdCargo_seq" OWNED BY public.cargos."IdCargo";


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: gruas_user
--

CREATE TABLE public.clientes (
    "IdCliente" integer NOT NULL,
    "NombreCliente" character varying(200) NOT NULL,
    "Nit" character varying(20) NOT NULL,
    "FechaCreacion" timestamp without time zone,
    "UsuarioCrea" integer NOT NULL,
    "Estado" character varying(20),
    "UsuarioInactiva" integer,
    "FechaInactiva" timestamp without time zone
);


ALTER TABLE public.clientes OWNER TO gruas_user;

--
-- Name: clientes_IdCliente_seq; Type: SEQUENCE; Schema: public; Owner: gruas_user
--

CREATE SEQUENCE public."clientes_IdCliente_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."clientes_IdCliente_seq" OWNER TO gruas_user;

--
-- Name: clientes_IdCliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gruas_user
--

ALTER SEQUENCE public."clientes_IdCliente_seq" OWNED BY public.clientes."IdCliente";


--
-- Name: equipos; Type: TABLE; Schema: public; Owner: gruas_user
--

CREATE TABLE public.equipos (
    "IdEquipo" integer NOT NULL,
    "IdTipoEquipo" integer NOT NULL,
    "Placa" character varying(20) NOT NULL,
    "Capacidad" double precision NOT NULL,
    "IdMarca" integer NOT NULL,
    "Referencia" character varying(100),
    "Color" character varying(50),
    "Modelo" character varying(100),
    "CentroCostos" character varying(100),
    "Estado" character varying(20),
    "IdEstadoEquipo" integer NOT NULL,
    "FechaCreacion" timestamp without time zone,
    "UsuarioCreacion" integer NOT NULL,
    "FechaInactivacion" timestamp without time zone,
    "UsuarioInactivacion" integer
);


ALTER TABLE public.equipos OWNER TO gruas_user;

--
-- Name: equipos_IdEquipo_seq; Type: SEQUENCE; Schema: public; Owner: gruas_user
--

CREATE SEQUENCE public."equipos_IdEquipo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."equipos_IdEquipo_seq" OWNER TO gruas_user;

--
-- Name: equipos_IdEquipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gruas_user
--

ALTER SEQUENCE public."equipos_IdEquipo_seq" OWNED BY public.equipos."IdEquipo";


--
-- Name: estado_equipos; Type: TABLE; Schema: public; Owner: gruas_user
--

CREATE TABLE public.estado_equipos (
    "IdEstadoEquipo" integer NOT NULL,
    "Descripcion" character varying(100) NOT NULL,
    "Estado" character varying(20)
);


ALTER TABLE public.estado_equipos OWNER TO gruas_user;

--
-- Name: estado_equipos_IdEstadoEquipo_seq; Type: SEQUENCE; Schema: public; Owner: gruas_user
--

CREATE SEQUENCE public."estado_equipos_IdEstadoEquipo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."estado_equipos_IdEstadoEquipo_seq" OWNER TO gruas_user;

--
-- Name: estado_equipos_IdEstadoEquipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gruas_user
--

ALTER SEQUENCE public."estado_equipos_IdEstadoEquipo_seq" OWNED BY public.estado_equipos."IdEstadoEquipo";


--
-- Name: marcas; Type: TABLE; Schema: public; Owner: gruas_user
--

CREATE TABLE public.marcas (
    "IdMarca" integer NOT NULL,
    "DescripcionMarca" character varying(100) NOT NULL,
    estado character varying(20)
);


ALTER TABLE public.marcas OWNER TO gruas_user;

--
-- Name: marcas_IdMarca_seq; Type: SEQUENCE; Schema: public; Owner: gruas_user
--

CREATE SEQUENCE public."marcas_IdMarca_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."marcas_IdMarca_seq" OWNER TO gruas_user;

--
-- Name: marcas_IdMarca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gruas_user
--

ALTER SEQUENCE public."marcas_IdMarca_seq" OWNED BY public.marcas."IdMarca";


--
-- Name: registro_horas; Type: TABLE; Schema: public; Owner: gruas_user
--

CREATE TABLE public.registro_horas (
    "IdRegistro" integer NOT NULL,
    "IdEquipo" integer NOT NULL,
    "IdEmpleado" integer NOT NULL,
    "IdCargo" integer NOT NULL,
    "IdCliente" integer,
    "IdEstadoEquipo" integer NOT NULL,
    "FechaAutomatica" timestamp without time zone,
    "FechaEmpleado" date NOT NULL,
    "HoraEmpleado" time without time zone NOT NULL,
    "Kilometraje" double precision,
    "Horometro" double precision,
    "FotoKilometraje" character varying(255),
    "FotoHorometro" character varying(255),
    "FotoGrua" character varying(255),
    "Observacion" text,
    "Ubicacion" character varying(255),
    "Latitud" double precision,
    "Longitud" double precision,
    "TipoRegistro" character varying(20) NOT NULL,
    "FechaCreacion" timestamp without time zone
);


ALTER TABLE public.registro_horas OWNER TO gruas_user;

--
-- Name: registro_horas_IdRegistro_seq; Type: SEQUENCE; Schema: public; Owner: gruas_user
--

CREATE SEQUENCE public."registro_horas_IdRegistro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."registro_horas_IdRegistro_seq" OWNER TO gruas_user;

--
-- Name: registro_horas_IdRegistro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gruas_user
--

ALTER SEQUENCE public."registro_horas_IdRegistro_seq" OWNED BY public.registro_horas."IdRegistro";


--
-- Name: tipo_equipos; Type: TABLE; Schema: public; Owner: gruas_user
--

CREATE TABLE public.tipo_equipos (
    "IdTipoEquipo" integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    estado character varying(20)
);


ALTER TABLE public.tipo_equipos OWNER TO gruas_user;

--
-- Name: tipo_equipos_IdTipoEquipo_seq; Type: SEQUENCE; Schema: public; Owner: gruas_user
--

CREATE SEQUENCE public."tipo_equipos_IdTipoEquipo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."tipo_equipos_IdTipoEquipo_seq" OWNER TO gruas_user;

--
-- Name: tipo_equipos_IdTipoEquipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gruas_user
--

ALTER SEQUENCE public."tipo_equipos_IdTipoEquipo_seq" OWNED BY public.tipo_equipos."IdTipoEquipo";


--
-- Name: users; Type: TABLE; Schema: public; Owner: gruas_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    tipo_documento character varying(20) NOT NULL,
    documento character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(120) NOT NULL,
    celular character varying(15) NOT NULL,
    contrasena_hash character varying(255) NOT NULL,
    fecha_creacion timestamp without time zone,
    ultimo_login timestamp without time zone,
    estado character varying(20),
    perfil_usuario character varying(20) NOT NULL,
    fecha_inactividad timestamp without time zone
);


ALTER TABLE public.users OWNER TO gruas_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: gruas_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO gruas_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gruas_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cargos IdCargo; Type: DEFAULT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.cargos ALTER COLUMN "IdCargo" SET DEFAULT nextval('public."cargos_IdCargo_seq"'::regclass);


--
-- Name: clientes IdCliente; Type: DEFAULT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.clientes ALTER COLUMN "IdCliente" SET DEFAULT nextval('public."clientes_IdCliente_seq"'::regclass);


--
-- Name: equipos IdEquipo; Type: DEFAULT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.equipos ALTER COLUMN "IdEquipo" SET DEFAULT nextval('public."equipos_IdEquipo_seq"'::regclass);


--
-- Name: estado_equipos IdEstadoEquipo; Type: DEFAULT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.estado_equipos ALTER COLUMN "IdEstadoEquipo" SET DEFAULT nextval('public."estado_equipos_IdEstadoEquipo_seq"'::regclass);


--
-- Name: marcas IdMarca; Type: DEFAULT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.marcas ALTER COLUMN "IdMarca" SET DEFAULT nextval('public."marcas_IdMarca_seq"'::regclass);


--
-- Name: registro_horas IdRegistro; Type: DEFAULT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.registro_horas ALTER COLUMN "IdRegistro" SET DEFAULT nextval('public."registro_horas_IdRegistro_seq"'::regclass);


--
-- Name: tipo_equipos IdTipoEquipo; Type: DEFAULT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.tipo_equipos ALTER COLUMN "IdTipoEquipo" SET DEFAULT nextval('public."tipo_equipos_IdTipoEquipo_seq"'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cargos; Type: TABLE DATA; Schema: public; Owner: gruas_user
--

COPY public.cargos ("IdCargo", "descripcionCargo", "Estado") FROM stdin;
135	Operador	activo
136	Aparejador	activo
137	Supervisor	activo
138	HSEQ	activo
139	Mantenimiento	activo
140	Oficina	activo
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: gruas_user
--

COPY public.clientes ("IdCliente", "NombreCliente", "Nit", "FechaCreacion", "UsuarioCrea", "Estado", "UsuarioInactiva", "FechaInactiva") FROM stdin;
12	CELIK CONSTRUCCIONES METÁLICAS	900444818-8	2025-09-11 14:29:54.905386	62	activo	\N	\N
7	BESSAC ANDINA 	900266941-2	2025-09-11 11:01:22.605668	62	activo	\N	\N
8	GRUAS LIMITADA	800202809-0	2025-09-11 11:02:26.995257	62	activo	\N	\N
6	GRUAS CRANES	900508612-4	2025-09-11 06:26:07.816985	62	activo	\N	\N
9	METRO LÍNEA 1 	901339011-6	2025-09-11 14:22:57.005384	62	activo	\N	\N
11	TEC GRUAS	901305121-1	2025-09-11 14:26:06.237741	62	activo	\N	\N
10	UNIÓN TEMPORAL CABLE SAN CRISTÓBAL 	901702585-8	2025-09-11 14:24:53.814069	62	activo	\N	\N
13	MTS MONTAJES Y SERVICIOS TELESCÓPICOS 	900409892-5	2025-09-11 17:17:24.191724	62	activo	\N	\N
14	YDN MICROTUNNELING	901221375-3	2025-09-11 17:19:34.808918	62	activo	\N	\N
15	GRUAS INGER	900954348-6	2025-09-16 12:07:32.853496	62	activo	\N	\N
\.


--
-- Data for Name: equipos; Type: TABLE DATA; Schema: public; Owner: gruas_user
--

COPY public.equipos ("IdEquipo", "IdTipoEquipo", "Placa", "Capacidad", "IdMarca", "Referencia", "Color", "Modelo", "CentroCostos", "Estado", "IdEstadoEquipo", "FechaCreacion", "UsuarioCreacion", "FechaInactivacion", "UsuarioInactivacion") FROM stdin;
24	72	PMR799	20	13	BRONCO	AZUL CLARO	2024	00213	activo	63	2025-09-11 10:57:33.162867	62	\N	\N
25	75	328	10	16					activo	63	2025-09-11 13:37:48.693248	62	\N	\N
26	74	POZ887	6.5	11	FUSO	BLANCO	2023	1014	activo	63	2025-09-11 13:59:18.025395	62	\N	\N
27	68	POZ873	20	9	ACTROS	BLANCO	2023	1021	activo	63	2025-09-11 14:00:25.478901	62	\N	\N
29	70	MI725248	60	8	DEMAG CHALLENGER 3160	AMARILLO AZUL	2015	1007	activo	63	2025-09-12 13:38:08.89871	62	\N	\N
28	70	MI753619	250	8	DEMAG EXPLORER	AMARILLO	2015	1019	activo	63	2025-09-12 11:44:03.733011	62	\N	\N
30	70	MIC15635	70	2	LTM1070-4.2	AMARILLO	2013	1002	activo	63	2025-09-12 13:41:38.299278	62	\N	\N
31	70	MI045782	90	2	LTM1080/1	NEGRO	2004	1003	activo	63	2025-09-12 13:44:02.817841	62	\N	\N
32	70	MI112324	55	5	GMK3050	BLANCO	2003	1001	activo	63	2025-09-12 13:45:33.499968	62	\N	\N
33	73	NUU605	55	6	DAF- XCT55_E	ROJO	2025	1015	activo	63	2025-09-12 13:48:21.696781	62	\N	\N
34	73	NUV626	55	7	FOTÓN-XCT55_E	ROJO	2025	1017	activo	63	2025-09-12 13:51:09.703021	62	\N	\N
\.


--
-- Data for Name: estado_equipos; Type: TABLE DATA; Schema: public; Owner: gruas_user
--

COPY public.estado_equipos ("IdEstadoEquipo", "Descripcion", "Estado") FROM stdin;
63	Operativo	activo
64	Fuera de servicio	activo
65	Mantenimiento	activo
66	Averiado	activo
\.


--
-- Data for Name: marcas; Type: TABLE DATA; Schema: public; Owner: gruas_user
--

COPY public.marcas ("IdMarca", "DescripcionMarca", estado) FROM stdin;
2	Liebherr	activo
5	Grove	activo
12	RENAULT	activo
13	FORD	activo
1	Tadano	activo
8	Demag 	activo
9	Mercedes	activo
4	Internacional	activo
11	Mitsubishi	activo
10	Volkswagen	activo
3	Daf - PM	activo
6	Daf - Xcmg 	activo
7	Fotón - Xcmg	activo
14	RAM 	activo
15	Nissan	activo
16	Nou	activo
\.


--
-- Data for Name: registro_horas; Type: TABLE DATA; Schema: public; Owner: gruas_user
--

COPY public.registro_horas ("IdRegistro", "IdEquipo", "IdEmpleado", "IdCargo", "IdCliente", "IdEstadoEquipo", "FechaAutomatica", "FechaEmpleado", "HoraEmpleado", "Kilometraje", "Horometro", "FotoKilometraje", "FotoHorometro", "FotoGrua", "Observacion", "Ubicacion", "Latitud", "Longitud", "TipoRegistro", "FechaCreacion") FROM stdin;
15	24	63	135	7	63	2025-09-11 11:21:13.750466	2025-09-11	06:17:00	19800	100	kilometraje_2c550d60c3e34609b2c0f285364fb4d5.jpeg	horometro_7980f166d3664846983028db407d850c.jpeg	grua_744984a77a894030916dc0263b606607.jpeg	Trabajando 		\N	\N	entrada	2025-09-11 11:21:13.750478
16	24	64	136	7	63	2025-09-11 11:40:14.811729	2025-09-11	06:38:00	\N	\N	\N	\N	grua_a7971e03d92a4500988b8a50a7aff2a8.png	Llego tarde por qué se me pinchó la moto 		4.888758	-74.03063	entrada	2025-09-11 11:40:14.811745
17	24	64	136	7	63	2025-09-11 11:48:06.487788	2025-09-11	06:47:00	\N	\N	\N	\N	grua_5b9cef0f4e754ea1adeaca3b1979ec68.png			4.888828	-74.030607	salida	2025-09-11 11:48:06.487798
18	24	63	135	7	64	2025-09-11 13:32:24.51086	2025-09-11	08:30:00	19800	100	kilometraje_0c67faa7e3f3473fab140fcc834997fd.jpeg	horometro_252c51966c3c46f5b9db7e9cee4c49e0.png	grua_522dd04d8bdf4281b645880717e47ac4.jpeg			\N	\N	salida	2025-09-11 13:32:24.510872
19	25	65	140	6	63	2025-09-11 13:44:34.852478	2025-09-11	08:43:00	\N	\N	\N	\N	grua_447fcfd360b546058ada5639eec93164.jpg			\N	\N	entrada	2025-09-11 13:44:34.852487
20	25	66	140	6	63	2025-09-11 13:49:05.893217	2025-09-11	08:48:00	\N	\N	\N	\N	grua_c3835784570346fa97223f927294a375.jpg			4.90625	-74.028089	entrada	2025-09-11 13:49:05.893225
21	25	64	136	\N	66	2025-09-11 13:51:51.759635	2025-09-11	08:51:00	\N	\N	\N	\N	grua_cd6e4b58ddc64550bb5ac98e0948e09e.jpg			\N	\N	entrada	2025-09-11 13:51:51.759648
22	25	67	140	6	63	2025-09-11 13:52:12.013137	2025-09-11	08:51:00	\N	\N	\N	\N	grua_2b98809629e84224a2d6b7abfa1ea047.jpg			4.906244	-74.028082	entrada	2025-09-11 13:52:12.013149
23	25	68	138	6	63	2025-09-11 13:54:11.067524	2025-09-11	08:53:00	\N	\N	\N	\N	grua_b53392f28bc2436f9afb31bb89344f87.jpg			4.905799	-74.02825	entrada	2025-09-11 13:54:11.067536
24	25	63	140	6	63	2025-09-11 13:57:33.686396	2025-09-11	08:56:00	\N	\N	\N	\N	grua_8eea03c0dca04bde9f0a45b1153d9ea6.jpg	Prueba 		\N	\N	entrada	2025-09-11 13:57:33.686421
25	25	63	140	6	63	2025-09-11 14:43:04.763113	2025-09-11	09:42:00	\N	\N	\N	\N	grua_1641b48a7ba54affb8768e8a119e6624.jpeg			\N	\N	salida	2025-09-11 14:43:04.763122
26	26	63	137	6	63	2025-09-11 14:56:02.591879	2025-09-11	09:55:00	\N	\N	\N	\N	grua_862fabfadaab4550b7a6904bee8f5ff6.jpg			\N	\N	entrada	2025-09-11 14:56:02.591892
27	26	63	137	6	63	2025-09-11 15:10:51.625926	2025-09-11	10:09:00	\N	\N	\N	\N	grua_1c26798c394c4f65971e7b95f46bfbe8.jpg			\N	\N	salida	2025-09-11 15:10:51.625937
28	25	62	136	\N	66	2025-09-11 16:16:00.54177	2025-09-11	11:15:00	\N	\N	\N	\N	grua_73f762ca949a4833be1e38157ba6bb9f.jpeg			5.362457	-74.388689	entrada	2025-09-11 16:16:00.541781
29	25	62	136	\N	63	2025-09-11 18:59:26.126912	2025-09-11	13:59:00	\N	\N	\N	\N	grua_53c511289f354441855cdc8df6d30282.png			4.733905	-73.967564	salida	2025-09-11 18:59:26.126921
30	25	69	140	6	63	2025-09-11 21:31:01.231363	2025-09-11	16:29:00	\N	\N	\N	\N	grua_701f6d101c034c97801ea63110429963.jpg			4.906238	-74.028077	entrada	2025-09-11 21:31:01.231372
31	25	67	140	6	63	2025-09-11 22:11:08.365303	2025-09-11	17:10:00	\N	\N	\N	\N	grua_e08e639315f441bda6de49da728c9c40.jpg			4.90625	-74.028093	salida	2025-09-11 22:11:08.365313
32	25	68	138	6	63	2025-09-11 22:11:24.330066	2025-09-11	17:10:00	\N	\N	\N	\N	grua_903542f48ce248d192c4a381527782ca.jpg			4.905799	-74.02825	salida	2025-09-11 22:11:24.330076
33	25	69	140	6	63	2025-09-11 22:12:30.243509	2025-09-11	17:12:00	\N	\N	\N	\N	grua_4fc30a94974b4ecdb0bd896b2e26bbe1.jpg			4.906256	-74.02808	salida	2025-09-11 22:12:30.243522
34	25	66	140	6	63	2025-09-11 22:18:27.092986	2025-09-11	17:17:00	\N	\N	\N	\N	grua_cfe53079b9d246dfba821679de22188c.jpg			4.906239	-74.028081	salida	2025-09-11 22:18:27.092996
35	25	65	140	6	63	2025-09-11 22:38:58.483837	2025-09-11	17:38:00	\N	\N	\N	\N	grua_95a9520c0a114df4b60d5968ec6d5f0c.jpg			\N	\N	salida	2025-09-11 22:38:58.483848
36	28	70	135	7	63	2025-09-12 11:51:57.554261	2025-09-12	06:47:00	23036	558	kilometraje_68023c623c1c482dbb879177d10716e7.jpg	horometro_8e53bc588748499c9fc6e77789031001.jpg	grua_0db5e59a47e343419849bc9490d5556e.jpg			4.93746	-73.977515	entrada	2025-09-12 11:51:57.554272
37	28	71	136	7	63	2025-09-12 11:57:36.571581	2025-09-12	06:55:00	\N	\N	\N	\N	grua_0b169cf955374c17bf5b2f89721bcbf1.jpg			4.937605	-73.977513	entrada	2025-09-12 11:57:36.571596
38	25	66	140	6	63	2025-09-12 12:47:03.673043	2025-09-12	07:46:00	\N	\N	\N	\N	grua_f3fd95d0c78f4ab29f1ed04eb02e73ca.jpg			4.906259	-74.028085	entrada	2025-09-12 12:47:03.673057
39	25	67	140	6	63	2025-09-12 12:59:17.900995	2025-09-12	07:58:00	\N	\N	\N	\N	grua_272d32b2a4f84a859f3961dea596c9f1.jpg			4.906241	-74.02808	entrada	2025-09-12 12:59:17.901007
40	25	65	140	6	63	2025-09-12 13:10:10.216125	2025-09-12	08:08:00	\N	\N	\N	\N	grua_b50783c976354b57ad99ab20d6819d10.jpg			4.906249	-74.028079	entrada	2025-09-12 13:10:10.216138
41	25	64	136	\N	63	2025-09-12 13:18:29.575786	2025-09-12	08:17:00	\N	\N	\N	\N	grua_6cc1e2d17b264f14a7698584e98266f0.jpg			\N	\N	salida	2025-09-12 13:18:29.575795
42	25	72	140	6	63	2025-09-12 13:18:56.854197	2025-09-12	08:18:00	\N	\N	\N	\N	grua_2d6f09d842844c81950d2a70a42fce85.jpg			\N	\N	entrada	2025-09-12 13:18:56.85421
43	25	64	140	6	63	2025-09-12 13:19:54.121956	2025-09-12	08:19:00	\N	\N	\N	\N	grua_50c6bf1479a441fdb856695353c04a65.jpg			\N	\N	entrada	2025-09-12 13:19:54.121966
44	27	73	135	6	63	2025-09-12 20:32:33.928874	2025-09-12	15:26:00	2016	44	kilometraje_afee4b1e83af4e1ba14eea83fb76d986.jpg	horometro_93a7db41002c4d419907bdf6dbd7c1c2.jpg	grua_2a5b8b06a28342c9832286889aa10e27.jpg			\N	\N	entrada	2025-09-12 20:32:33.928889
45	31	76	135	6	63	2025-09-12 22:07:39.311999	2025-09-12	17:03:00	91690	30014	kilometraje_ff72ac5754c1402fbc480a8f7daf6e47.jpg	horometro_80b69a16225e499cac89f5382c44e634.jpg	grua_e955af9acfa642dcaab0eef16b5dcd8b.jpg			4.76495	-74.164285	entrada	2025-09-12 22:07:39.312013
46	31	75	136	6	63	2025-09-12 22:15:42.935224	2025-09-12	17:14:00	\N	\N	\N	\N	grua_686552e65a42401f9b70f8bff0168d43.jpg			4.765973	-74.163402	entrada	2025-09-12 22:15:42.935235
47	31	75	136	6	63	2025-09-12 22:16:36.619738	2025-09-12	17:16:00	\N	\N	\N	\N	grua_2d901074ffd74e1d8f641afd187aa91b.jpg			4.765805	-74.163343	salida	2025-09-12 22:16:36.619751
48	31	76	135	6	63	2025-09-12 22:20:33.87985	2025-09-12	17:17:00	91690	30014	kilometraje_04885c85754d4e329209652d5cd81149.jpg	horometro_14041e3f21a443b5922108a31377f17d.jpg	grua_1bfa6eb4aa3d449e9106b9c3924e1662.jpg			4.765879	-74.163525	salida	2025-09-12 22:20:33.879864
49	25	67	140	6	63	2025-09-12 22:23:25.488791	2025-09-12	17:22:00	\N	\N	\N	\N	grua_bf9a2fd04bf44da0985acce58ed1114b.jpg			4.906236	-74.02808	salida	2025-09-12 22:23:25.4888
50	25	66	140	6	63	2025-09-12 22:25:01.055693	2025-09-12	17:24:00	\N	\N	\N	\N	grua_0fd1d063c5614facafa057139a9f9a3d.jpg			4.906229	-74.028084	salida	2025-09-12 22:25:01.055703
51	25	65	140	6	63	2025-09-12 22:30:54.729074	2025-09-12	17:30:00	\N	\N	\N	\N	grua_5f067d3b976c4469b3847aacf5f290db.jpg			4.906223	-74.028075	salida	2025-09-12 22:30:54.729083
52	29	77	136	6	63	2025-09-12 22:35:20.468493	2025-09-12	17:34:00	\N	\N	\N	\N	grua_495d93d24100476e8316614d81357ded.jpg			4.765819	-74.163468	entrada	2025-09-12 22:35:20.468505
53	25	72	140	6	64	2025-09-12 22:44:12.176055	2025-09-12	17:43:00	\N	\N	\N	\N	grua_f6bde2c6ce3e4dad8302220bf45fa2c9.jpg			\N	\N	salida	2025-09-12 22:44:12.176065
54	25	64	140	6	64	2025-09-12 23:00:16.90481	2025-09-12	17:59:00	\N	\N	\N	\N	grua_41f0060967504bfca2f8707f1c7d9ad7.jpg			\N	\N	salida	2025-09-12 23:00:16.904823
55	29	77	136	6	63	2025-09-12 23:12:58.257626	2025-09-12	17:37:00	\N	\N	\N	\N	grua_98b696ea673648de95f2bcb3e93f5f07.jpg			4.764057	-74.164242	salida	2025-09-12 23:12:58.257634
56	29	78	135	6	63	2025-09-12 23:16:05.6682	2025-09-12	18:11:00	130920	14061	kilometraje_c5cba7f9da3d494bbe56e1ac328286e4.jpg	horometro_e3bb80ada5354e40be1d57be1b82d67a.jpg	grua_cfc18080d7c4476fa48d9d15bfc698c8.jpg			4.765798	-74.163528	entrada	2025-09-12 23:16:05.668218
57	29	78	135	6	63	2025-09-12 23:20:20.179268	2025-09-12	18:16:00	130920	14061	kilometraje_e436212c0c7444faa9dfa63c7c7ca80d.jpg	horometro_a3937dcc3056489abf5cf0e80295c3c2.jpg	grua_e05a2ad5b5c94e92b195f2d118250506.jpg			4.765626	-74.163547	salida	2025-09-12 23:20:20.179278
58	27	73	135	6	63	2025-09-13 00:02:23.200275	2025-09-12	18:58:00	2016	44	kilometraje_b955472c6eac4f48809f552272756893.jpg	horometro_24d0dfb2443d4a7db20358b1ae9ac5b8.jpg	grua_b57bef0fb15e427a845b2e02c8e7a40d.jpg			4.610118	-74.122136	salida	2025-09-13 00:02:23.200288
59	28	70	135	7	63	2025-09-13 11:19:20.049171	2025-09-13	06:15:00	23085	564	kilometraje_ea91cbbfb1344c38a3afec15e224d696.jpg	horometro_ee1386d1560745f38be4d2097de95da6.jpg	grua_0a549a9f22fa43b1a4d7865fa70bb244.jpg			4.666083	-74.146687	salida	2025-09-13 11:19:20.049183
60	28	70	135	8	63	2025-09-15 10:35:25.035169	2025-09-15	05:33:00	23085	565	kilometraje_2a4006a0db234deeaf1a4786e7618312.jpg	horometro_fb2eb3c3224a44819f0a3535f01153f1.jpg	grua_2857d697e5d947799243f485eb4560ac.jpg			4.764929	-74.163825	entrada	2025-09-15 10:35:25.035181
61	28	71	136	7	63	2025-09-15 12:34:11.543335	2025-09-12	18:27:00	\N	\N	\N	\N	grua_789ea2733b7646ec8d9bfc0aa2e30dc8.jpg			4.665606	-74.092007	salida	2025-09-15 12:34:11.543352
62	28	71	136	8	63	2025-09-15 12:35:21.331632	2025-09-15	07:34:00	\N	\N	\N	\N	grua_8a910a1efaa34491b5e96f3173a5d122.jpg			4.66601	-74.091875	entrada	2025-09-15 12:35:21.331642
63	25	72	140	6	63	2025-09-15 12:50:31.322419	2025-09-15	07:50:00	\N	\N	\N	\N	grua_633933e13ad54ae79db90641a5e3b55b.jpg			\N	\N	entrada	2025-09-15 12:50:31.32243
64	25	65	140	6	63	2025-09-15 12:55:18.180493	2025-09-15	07:53:00	\N	\N	\N	\N	grua_e91c3100eab74a1d9940192e884c22dd.jpg			4.906207	-74.028071	entrada	2025-09-15 12:55:18.180506
65	25	67	140	6	63	2025-09-15 12:55:36.149028	2025-09-15	07:53:00	\N	\N	\N	\N	grua_b0b739aee92a482b8085294624be4acc.jpg			4.906234	-74.028075	entrada	2025-09-15 12:55:36.14904
66	25	68	138	6	63	2025-09-15 13:04:12.650679	2025-09-15	08:03:00	\N	\N	\N	\N	grua_d3bca7e43feb40a885984c15755df4b9.jpg			4.906153	-74.028116	entrada	2025-09-15 13:04:12.650689
67	25	66	140	6	63	2025-09-15 13:16:55.321059	2025-09-15	08:16:00	\N	\N	\N	\N	grua_f9607222bf594f75b9900367ddf00928.jpg			4.906234	-74.028087	entrada	2025-09-15 13:16:55.32107
68	25	64	140	6	63	2025-09-15 13:23:14.121034	2025-09-15	08:22:00	\N	\N	\N	\N	grua_53dc389053994f238f83caff2938499d.jpeg			\N	\N	entrada	2025-09-15 13:23:14.121044
69	29	77	136	6	63	2025-09-15 13:33:07.934526	2025-09-15	08:30:00	\N	\N	\N	\N	grua_f2f9675886b34b2bb2f11d9b3e954bf7.jpg			4.747153	-74.163048	entrada	2025-09-15 13:33:07.934537
70	29	78	135	10	63	2025-09-15 15:40:00.574385	2025-09-15	10:34:00	130930	14065	kilometraje_9017a33c39ba4b74b791204cd9fd55e1.jpg	horometro_f44e9390541d4491ab9b0f530b341089.jpg	grua_0dcb95ef9bcb4ce59daed15b02edfd57.jpg			4.747954	-74.155445	entrada	2025-09-15 15:40:00.574402
71	29	77	136	6	63	2025-09-15 20:53:34.766419	2025-09-15	15:51:00	\N	\N	\N	\N	grua_c1cb34409e2b4bce997e5fb344356bec.jpg			4.748141	-74.15545	salida	2025-09-15 20:53:34.76643
72	29	78	135	10	63	2025-09-15 20:59:01.538595	2025-09-15	15:55:00	130930	14069	kilometraje_9fb22aabefcd4d74b5d9d960bae38158.jpg	horometro_414d2759d7654730b8ef515c82c20acc.jpg	grua_bda35405e55b4798ac6c574123d70ed7.jpg			4.748097	-74.155394	salida	2025-09-15 20:59:01.538608
73	28	71	136	8	63	2025-09-15 22:06:46.304167	2025-09-15	17:06:00	\N	\N	\N	\N	grua_263b7512ba4348a8a422aeac49228cd8.jpg			4.666037	-74.091842	salida	2025-09-15 22:06:46.304176
74	28	70	135	8	63	2025-09-15 22:07:35.458576	2025-09-15	17:05:00	23111	576	kilometraje_594833bbf8ca4f01bb09c731af96f528.jpg	horometro_2a9913fe29e34206b7b49f284aa3a0be.jpg	grua_27217a467e6f431ca38f165dc587752b.jpg			4.665994	-74.091941	salida	2025-09-15 22:07:35.458588
75	25	68	138	6	63	2025-09-15 22:10:27.958038	2025-09-15	17:10:00	\N	\N	\N	\N	grua_62c7d1afe87c46579ba46deaa97a55b1.jpg			4.905839	-74.028215	salida	2025-09-15 22:10:27.95805
76	30	67	140	9	63	2025-09-15 22:10:57.428334	2025-09-15	17:10:00	\N	\N	\N	\N	grua_ed630f51e29d40ba82c5b8f904e2b727.jpg			4.906209	-74.028072	entrada	2025-09-15 22:10:57.428345
77	30	67	140	9	63	2025-09-15 22:11:29.149914	2025-09-15	17:11:00	\N	\N	\N	\N	grua_1dd6511e72e9488cbdd5ceba460df6ae.jpg			4.906246	-74.028088	salida	2025-09-15 22:11:29.149924
78	25	65	140	6	63	2025-09-15 22:11:44.156338	2025-09-15	17:11:00	\N	\N	\N	\N	grua_89281ebc536945f98751c83c1df9430a.jpg			4.906219	-74.028072	salida	2025-09-15 22:11:44.156348
79	25	66	140	6	63	2025-09-15 22:16:32.260178	2025-09-15	17:16:00	\N	\N	\N	\N	grua_a293c9d596644426ad0beb4dab43d2b7.jpg			4.906266	-74.028082	salida	2025-09-15 22:16:32.260186
80	25	64	140	6	63	2025-09-15 22:29:17.89124	2025-09-15	17:29:00	\N	\N	\N	\N	grua_a93e5810044c43578ef64df1fe3b365d.jpg			\N	\N	salida	2025-09-15 22:29:17.891249
81	31	76	135	11	63	2025-09-16 10:28:34.598741	2025-09-16	05:25:00	9169	30022	kilometraje_306767f3ee8b431aa72b69dc159573a7.jpg	horometro_7b43a6ce54cf4ea1b84b59d18c26cc43.jpg	grua_d7a0e4c9c24f48729fe0338f45560073.jpg			4.765114	-74.165338	entrada	2025-09-16 10:28:34.598753
82	28	70	135	8	63	2025-09-16 11:17:32.791106	2025-09-16	06:16:00	23111	576	kilometraje_90b70cf2c746461682ecbe04c2ebc99a.jpg	horometro_394cb0c7a0f84815942f063d4f2a18a0.jpg	grua_c6dfba192ee3472d93be9409f08c7651.jpg			4.665962	-74.091908	entrada	2025-09-16 11:17:32.791123
83	28	71	136	8	63	2025-09-16 11:24:25.177166	2025-09-16	06:23:00	\N	\N	\N	\N	grua_aed7981c9d1c4fdb9132bc1ea17042e9.jpg			4.665839	-74.091953	entrada	2025-09-16 11:24:25.177176
84	31	75	136	11	63	2025-09-16 11:54:13.816962	2025-09-16	06:47:00	\N	\N	\N	\N	grua_24cfb444ab974810a1d32c23224d2da7.jpg			4.724496	-74.136664	entrada	2025-09-16 11:54:13.816973
85	31	76	135	11	63	2025-09-16 12:15:51.05963	2025-09-16	07:13:00	91690	30023	kilometraje_c5749704fcff446ba6826c2c3f183a4e.jpg	horometro_3ffc3fb68a1b4c18b61ce56caf96f8a0.jpg	grua_684fd13e670047debd305aba78deb7d9.jpg			4.724549	-74.137034	salida	2025-09-16 12:15:51.05964
86	31	75	136	11	63	2025-09-16 12:17:18.775215	2025-09-16	07:16:00	\N	\N	\N	\N	grua_747b0b59cb364be684e62c761a2abb7a.jpg			4.724562	-74.136871	salida	2025-09-16 12:17:18.775225
87	31	76	135	15	63	2025-09-16 12:18:28.914427	2025-09-16	07:16:00	91690	30023	kilometraje_12d9a98e9d41441bb200407a4f24a209.jpg	horometro_fa301d7a3365492d94cd51892e64b6fc.jpg	grua_dfbd2a7135f94284ac05905d263522a3.jpg			4.72409	-74.137195	entrada	2025-09-16 12:18:28.914439
88	31	75	136	15	63	2025-09-16 12:18:36.01283	2025-09-16	07:18:00	\N	\N	\N	\N	grua_9fbadb8a66c24c4e9e4ea1b148938ab0.jpg			4.724579	-74.137075	entrada	2025-09-16 12:18:36.01284
89	25	65	140	6	63	2025-09-16 12:43:39.279465	2025-09-16	07:42:00	\N	\N	\N	\N	grua_f96ef5e2f338403a8735e8cf075075b1.jpg			4.906146	-74.028071	entrada	2025-09-16 12:43:39.279475
90	25	72	140	6	63	2025-09-16 12:47:44.785035	2025-09-15	17:30:00	\N	\N	\N	\N	grua_672fb5876ae147c885c969ca018eb739.jpg			\N	\N	salida	2025-09-16 12:47:44.785046
91	25	67	140	6	63	2025-09-16 12:48:17.76021	2025-09-16	07:47:00	\N	\N	\N	\N	grua_4de3f917a27948b0ae0d8dccf14b1970.jpg			4.906243	-74.028081	salida	2025-09-16 12:48:17.760219
92	25	72	140	6	63	2025-09-16 12:48:34.872803	2025-09-16	07:48:00	\N	\N	\N	\N	grua_3c3489a23c034d0886c83726170026f9.jpg			\N	\N	entrada	2025-09-16 12:48:34.872813
93	25	66	140	6	63	2025-09-16 12:50:15.504204	2025-09-16	07:49:00	\N	\N	\N	\N	grua_bcf2ed55dc0941cfad085f3235a2bceb.jpg			4.906248	-74.02808	entrada	2025-09-16 12:50:15.504217
94	25	67	140	6	63	2025-09-16 12:59:48.642342	2025-09-16	07:48:00	\N	\N	\N	\N	grua_33614198210f4b5b9fa7ba972720ab3e.jpg			4.906261	-74.028088	entrada	2025-09-16 12:59:48.642351
95	29	77	136	10	63	2025-09-16 13:04:51.266274	2025-09-16	08:03:00	\N	\N	\N	\N	grua_e0b8543327324e9da3591a2124e049e8.jpg			4.748111	-74.155416	entrada	2025-09-16 13:04:51.266286
96	25	68	138	6	63	2025-09-16 13:06:30.42179	2025-09-16	08:05:00	\N	\N	\N	\N	grua_94f4d28aec834d9aa492cee132087a33.jpg			4.906209	-74.028125	entrada	2025-09-16 13:06:30.421799
97	29	78	135	10	63	2025-09-16 13:10:05.762788	2025-09-16	08:07:00	130930	14069	kilometraje_030473d3de734f2d81ab95395a880e4f.jpg	horometro_757d94be67cb4799906c195fb225aa8e.jpg	grua_9aaa9961653f483ea1e78f9999b4756f.jpg			4.748122	-74.155435	entrada	2025-09-16 13:10:05.762801
98	25	69	140	6	63	2025-09-16 14:25:48.486681	2025-09-16	09:24:00	\N	\N	\N	\N	grua_2113466f8bf7426ea4ddf7fe3de2f20d.jpg			4.906247	-74.028076	entrada	2025-09-16 14:25:48.486692
99	25	64	140	6	63	2025-09-16 15:16:19.901881	2025-09-16	10:15:00	\N	\N	\N	\N	grua_084ade33a44048e2aeea49e1bec9e251.jpg			\N	\N	entrada	2025-09-16 15:16:19.901893
100	29	77	136	10	63	2025-09-16 20:07:04.259191	2025-09-16	15:04:00	\N	\N	\N	\N	grua_a94aee27676446b4858048bea58e4053.jpg			4.748112	-74.155417	salida	2025-09-16 20:07:04.259203
101	29	78	135	10	63	2025-09-16 20:10:24.604964	2025-09-16	15:07:00	130930	14070	kilometraje_e32df69ecec044bbbe51e3ca6ae66c1f.jpg	horometro_906452584a6d4e92867ef361ebfee1f7.jpg	grua_0c7fb74c5b6a42cbb1777031917f516c.jpg			4.748094	-74.155401	salida	2025-09-16 20:10:24.604974
102	28	71	136	8	63	2025-09-16 20:13:13.032223	2025-09-16	15:12:00	\N	\N	\N	\N	grua_f9ccf7aa86bb4d568ba639e95e8cdf0d.jpg			4.664696	-74.091684	salida	2025-09-16 20:13:13.032233
103	28	70	135	8	63	2025-09-16 22:03:12.966839	2025-09-16	17:01:00	23127	586	kilometraje_e36f072c6494484fbaa92f5fa9132c25.jpg	horometro_5d985b6d36fd4d5cbb187b58357049db.jpg	grua_e969aa98b8fb417ebd340e23eda57ff4.jpg			4.764968	-74.16362	salida	2025-09-16 22:03:12.966852
104	25	68	138	6	63	2025-09-16 22:07:25.037424	2025-09-16	17:06:00	\N	\N	\N	\N	grua_2b7ed284f6eb43d08c553d3d801193bf.jpg			4.905714	-74.028366	salida	2025-09-16 22:07:25.037434
105	25	66	140	6	63	2025-09-16 22:18:17.179809	2025-09-16	17:17:00	\N	\N	\N	\N	grua_9fa5f02c7a3743f6b13e7300d69a21e8.jpg			4.906255	-74.028073	salida	2025-09-16 22:18:17.179819
106	25	72	140	6	63	2025-09-16 22:18:34.674439	2025-09-16	17:17:00	\N	\N	\N	\N	grua_48712cd805a64b44b6cac1c5819979d1.jpg			\N	\N	salida	2025-09-16 22:18:34.674448
107	25	67	140	6	63	2025-09-16 22:19:30.782373	2025-09-16	17:19:00	\N	\N	\N	\N	grua_8488e9975cc14ec692e5193dae6fe9ae.jpg			4.906254	-74.028083	salida	2025-09-16 22:19:30.782382
108	25	69	140	6	63	2025-09-16 22:22:36.15513	2025-09-16	17:22:00	\N	\N	\N	\N	grua_1e72fb3133d0455bbe19a4cf1a68647b.jpg			4.90625	-74.02807	salida	2025-09-16 22:22:36.15514
109	25	65	140	6	63	2025-09-16 22:24:00.457321	2025-09-16	17:23:00	\N	\N	\N	\N	grua_b8dc9ba00963410eb79da4b0445ffd6d.jpg			4.906227	-74.028058	salida	2025-09-16 22:24:00.457334
110	25	64	140	6	63	2025-09-16 23:09:34.393181	2025-09-16	18:08:00	\N	\N	\N	\N	grua_e42458f682a64928829261cea15c5132.jpg			\N	\N	salida	2025-09-16 23:09:34.39319
111	31	75	136	15	63	2025-09-17 00:51:40.996238	2025-09-16	19:50:00	\N	\N	\N	\N	grua_8f411a9e62e146b188fa3df3ba54b9ee.jpg			4.725664	-74.138241	salida	2025-09-17 00:51:40.996246
112	31	76	135	15	63	2025-09-17 00:52:01.642848	2025-09-16	19:50:00	91690	30032	kilometraje_ab605f929eb34bc4a604d4e47ad30372.jpg	horometro_582864ebd4964ea5b79d9f63ba355934.jpg	grua_aad5bb5068c047a5b023c2a613a6d4df.jpg			4.725453	-74.138074	salida	2025-09-17 00:52:01.642857
113	31	75	136	15	63	2025-09-17 11:18:14.473607	2025-09-17	06:17:00	\N	\N	\N	\N	grua_518ff45d7e9d4f7b98ebddba4122e4d4.jpg			4.725629	-74.138381	entrada	2025-09-17 11:18:14.473617
114	31	76	135	15	63	2025-09-17 11:22:00.65357	2025-09-17	06:17:00	91690	30032	kilometraje_a789a9e53fce4453bcdbec448c638bbf.jpg	horometro_8abf486ae3de4f078857f367b744a415.jpg	grua_b84def939d5245d2a1377ebeb1021fe0.jpg			4.725754	-74.138179	entrada	2025-09-17 11:22:00.653582
115	25	65	140	6	63	2025-09-17 12:47:48.980218	2025-09-17	07:47:00	\N	\N	\N	\N	grua_e1df95319a044b49a34c4df5a351d9f2.jpg			4.906237	-74.028071	entrada	2025-09-17 12:47:48.98023
116	25	72	140	6	63	2025-09-17 12:47:51.396884	2025-09-17	07:47:00	\N	\N	\N	\N	grua_aad02329002c4c8d9265ef8f3e3294a6.jpg			\N	\N	entrada	2025-09-17 12:47:51.396894
117	25	67	140	6	63	2025-09-17 13:00:05.587732	2025-09-17	07:59:00	\N	\N	\N	\N	grua_d4a1d333b28e4bbbbf3ea10eba06607b.jpg			4.906212	-74.028073	entrada	2025-09-17 13:00:05.587742
118	29	77	136	10	63	2025-09-17 13:09:26.692316	2025-09-17	08:08:00	\N	\N	\N	\N	grua_3a39d4e198d747bf81ba55186bee105e.jpg			4.748114	-74.15544	entrada	2025-09-17 13:09:26.692329
119	29	78	135	10	63	2025-09-17 13:13:17.831217	2025-09-17	08:10:00	130930	14070	kilometraje_f89b5c108c264359a15955154e46098e.jpg	horometro_d9f5fe414d304960abb65c50d71603a4.jpg	grua_3736a92a04a44967b4b9133379c00876.jpg			4.748107	-74.155414	entrada	2025-09-17 13:13:17.83123
120	25	66	140	6	63	2025-09-17 13:15:38.925081	2025-09-17	08:15:00	\N	\N	\N	\N	grua_402dd6d836fa447c8bf4c2babbec6059.jpg			4.906144	-74.028075	entrada	2025-09-17 13:15:38.925092
121	25	64	140	6	63	2025-09-17 13:18:55.509587	2025-09-17	08:18:00	\N	\N	\N	\N	grua_cbdafb3dca1a4969b4037e9e0e5e0e5e.jpg			\N	\N	entrada	2025-09-17 13:18:55.509597
122	28	70	135	6	63	2025-09-17 13:30:17.100245	2025-09-17	08:28:00	23127	586	kilometraje_07f56f865d8f4c188abd92eefd5c64de.jpg	horometro_eb3528bf95e94299adb3647e7826c7da.jpg	grua_614571537bf04ccab7867186d5ebeedc.jpg	Equipo en mantenimiento por cambio de mangueras del sistema de refrigeración.		4.764195	-74.164539	entrada	2025-09-17 13:30:17.100259
123	31	75	136	15	63	2025-09-17 15:17:37.544068	2025-09-17	10:17:00	\N	\N	\N	\N	grua_7de76a44811945df97efc3363472780f.jpg			4.724355	-74.136781	salida	2025-09-17 15:17:37.544078
124	31	76	135	15	63	2025-09-17 17:01:10.532675	2025-09-17	11:59:00	91690	30036	kilometraje_41052bab0b67425ea05c0a6a3e69f3e2.jpg	horometro_8265393b82be441fb973270573e9738e.jpg	grua_900663d65270427e807247c204f27276.jpg			4.765147	-74.165396	salida	2025-09-17 17:01:10.532686
125	28	71	136	6	63	2025-09-17 17:18:37.198325	2025-09-17	12:18:00	\N	\N	\N	\N	grua_e4afa04416184d23a75727d6cea7a614.jpg			4.765807	-74.16354	entrada	2025-09-17 17:18:37.198339
\.


--
-- Data for Name: tipo_equipos; Type: TABLE DATA; Schema: public; Owner: gruas_user
--

COPY public.tipo_equipos ("IdTipoEquipo", descripcion, estado) FROM stdin;
72	CAMIONETA	activo
68	TRACTOCAMION	activo
70	GRUA TELESCÓPICA AT	activo
69	TRACTOCAMION CON BRAZO HIDRAULICO	activo
73	GRUA SOBRECAMION 	activo
71	CAMIONETA CON PLATON	activo
74	CAMIÓN CON BRAZO HIDRÁULICOS 	activo
75	Oficina	activo
76	prueba 1	inactivo
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gruas_user
--

COPY public.users (id, tipo_documento, documento, nombre, email, celular, contrasena_hash, fecha_creacion, ultimo_login, estado, perfil_usuario, fecha_inactividad) FROM stdin;
74	CC	2976439	MOISES LEONARDO CONTRERAS TORRES	codytor566@gmail.com	3206405810	pbkdf2:sha256:600000$9ZF3Vb7wfLDjLNUv$1a4b05b2297d2e15d042cfc977bc05ef857d8a2846e2160af514a7ab1ca93414	2025-09-12 20:24:34.747192	\N	activo	empleado	\N
70	CC	80730825	EDWIN LARA	EDWIN.LARA1892@GMAIL.COM	3108758409	pbkdf2:sha256:600000$d7SxVnEZVVPm7ko6$5c02eb2e36d3bbd65cd27b106a36b028f08b2de92216c6ef0e68faa00210c2a1	2025-09-12 11:45:52.272117	2025-09-15 10:33:04.109879	activo	empleado	\N
69	CC	11187990	JHONS FREDDY ARIZA ARIZA 	arizajhons1234@gmail.com	3212409354	pbkdf2:sha256:600000$7SvWk9CgHXsa9MWN$a961d1dcd9596fd12427adc8da6819c902f8a0f25e16190d791fbb2bd2e5646d	2025-09-11 21:28:31.50485	2025-09-16 14:24:48.916786	activo	empleado	\N
75	CC	1030552450	BILSE RICARDO PÉREZ NIÑO	Ricardo-Pérez-88@hotmail.com	3118257216	pbkdf2:sha256:600000$9zVxfRVyCTdPTOYa$80c832796815398676a32df7584e798e2340164412c3b27c5512f37db34c5e07	2025-09-12 21:59:49.198812	2025-09-17 11:17:45.30195	activo	empleado	\N
65	CC	1072710640	JENNY CAROLINA CASTILLO PIRAZAN	jecaro2016@gmail.com	3143975420	pbkdf2:sha256:600000$bXE8UPtKrEvffcoV$232ea1d015495206645cd1fd055bd78fb728dfdf9eb59b11501308f447f625bd	2025-09-11 13:40:42.057182	2025-09-17 12:46:53.986819	activo	empleado	\N
72	CC	1070021502	JUAN DANIEL VENEGAS SARMIENTO	VENEGASJ1003@GMAIL.COM	3123176921	pbkdf2:sha256:600000$9WWd3QTu6f7y3XQv$a6cb9ef7f7e70b75a117beec0369409f8aff54e3dba77bf440dcab28c9f85bce	2025-09-12 13:17:42.514289	2025-09-17 12:47:26.953244	activo	empleado	\N
63	CC	1070005410	Felipe Andrés Camargo Lamprea	Felo123@me.com	3112151529	pbkdf2:sha256:600000$I0PRckP3nsbumNIt$add86400f163c3f76cf8b6c1cebb7080cf0eef6793bf6351ac30042185b04652	2025-09-11 10:59:32.554116	2025-09-11 11:17:18.025837	activo	empleado	\N
67	CC	1076646092	Deisy Alejandra Garnica Castillo	alejagarnica000@gmail.com	3024012856	pbkdf2:sha256:600000$MvTxF4sRnH3rdHln$4ecf2dfcc9c1b098a3e671a6191514b4ed9ee9ccb16b1ec019a692440126d7a2	2025-09-11 13:49:40.826566	2025-09-17 12:58:54.37526	activo	empleado	\N
62	CC	admin	Administrador	admin@gruascranes.com	3001234567	pbkdf2:sha256:600000$bRvUQwL60sYkfQb9$251051de5536a9b6d960ce3d81ee6b12954118427b0e1db5d2c8160d54543b36	2025-09-11 06:26:07.814893	2025-09-16 16:12:29.436837	activo	administrador	\N
76	CC	1020732045	ANDRES FELIPE LOPEZ MENDOZA 	Andresfelipelopezmendoza70@gmail.com	3104813420	pbkdf2:sha256:600000$B9f9SUoSfKuBMtWW$f67b5f68738fe8081c596b55ea6b17edadff5915bbc8654ab01843656443d613	2025-09-12 22:01:28.877205	2025-09-15 14:53:37.19452	activo	empleado	\N
68	CC	1070017822	Paula Bautista Gutierrez	pjbautista96@gmail.com	3185529635	pbkdf2:sha256:600000$Vk6L8mDm8aCEcxO2$4ac617cef500f731ae40051068d019200b21a0b4288be2d9c41cd7f1ad05df21	2025-09-11 13:51:13.347684	2025-09-16 22:06:47.641118	activo	empleado	\N
77	CC	19752558	JOHANDRIS CRISTO CUADRADO 	johandris0780@gmail.com	3012465970	pbkdf2:sha256:600000$3twnCFTxTaKOJTvO$9c570339375ad0512bd008a862f1b49d7f8d1f86d84e151b6717f1ca141cc976	2025-09-12 22:29:43.501304	2025-09-17 13:06:17.126788	activo	empleado	\N
64	CC	2968990	HECTOR EDUARDO QUINTERO LAMPREA	e.quintero.lamprea@gmail.com	3004143931	pbkdf2:sha256:600000$6CjkABT3qaMQIWWQ$662251903fc107755fa04ee4409fa1620a2837f200ab78582df897fe00897e67	2025-09-11 11:37:36.032711	2025-09-17 13:18:27.208147	activo	empleado	\N
71	CC	1001057822	CRISTIAN FERNÁNDEZ PERERZ	CRISPINACIO@GMAIL.COM	3059337083	pbkdf2:sha256:600000$deqkZuImpEL3ZBYi$ae6bc74f5fb40bc76cf5687a9751d9598e5d3a9fc35a21b1c6731eb96deeec64	2025-09-12 11:55:06.894931	2025-09-17 17:15:09.376291	activo	empleado	\N
66	CC	1007405949	micheell Alexandra espinosa contreras	Michelespinosa087@gmail.com	3162359968	pbkdf2:sha256:600000$eTkxKD3PaUu7gxhw$83282f72139fc8e8e26a2fd4bf994a6361825756bb82b27d7d3e6ad0ad9e83f0	2025-09-11 13:47:28.731898	2025-09-15 22:16:11.341742	activo	empleado	\N
73	CC	79493269	JOHN FREDY ABRIL SANDOVAL	JOHNABRIL1969@gmail.com	3103107393	pbkdf2:sha256:600000$AQ1nwbCl1wBkORkw$45d6b1d7138639d8496219dff7a1fcc3271476ca6706da7ddebac39efc1ce78f	2025-09-12 20:22:28.461141	2025-09-12 23:58:14.748916	activo	empleado	\N
78	CC	80183667	GILBERTO HERNANDO RAMÍREZ CHAPARRO	gilbertoramirez1302@gmail.conm	3122566514	pbkdf2:sha256:600000$HMH5wuVfG4CdTHrB$a56858f73dec7e71bd87fa1cbf0e71ec56b27346950c83d60d9a5aa6e025ada4	2025-09-12 23:08:52.441337	2025-09-16 13:06:33.880973	activo	empleado	\N
\.


--
-- Name: cargos_IdCargo_seq; Type: SEQUENCE SET; Schema: public; Owner: gruas_user
--

SELECT pg_catalog.setval('public."cargos_IdCargo_seq"', 140, true);


--
-- Name: clientes_IdCliente_seq; Type: SEQUENCE SET; Schema: public; Owner: gruas_user
--

SELECT pg_catalog.setval('public."clientes_IdCliente_seq"', 15, true);


--
-- Name: equipos_IdEquipo_seq; Type: SEQUENCE SET; Schema: public; Owner: gruas_user
--

SELECT pg_catalog.setval('public."equipos_IdEquipo_seq"', 34, true);


--
-- Name: estado_equipos_IdEstadoEquipo_seq; Type: SEQUENCE SET; Schema: public; Owner: gruas_user
--

SELECT pg_catalog.setval('public."estado_equipos_IdEstadoEquipo_seq"', 66, true);


--
-- Name: marcas_IdMarca_seq; Type: SEQUENCE SET; Schema: public; Owner: gruas_user
--

SELECT pg_catalog.setval('public."marcas_IdMarca_seq"', 16, true);


--
-- Name: registro_horas_IdRegistro_seq; Type: SEQUENCE SET; Schema: public; Owner: gruas_user
--

SELECT pg_catalog.setval('public."registro_horas_IdRegistro_seq"', 125, true);


--
-- Name: tipo_equipos_IdTipoEquipo_seq; Type: SEQUENCE SET; Schema: public; Owner: gruas_user
--

SELECT pg_catalog.setval('public."tipo_equipos_IdTipoEquipo_seq"', 76, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gruas_user
--

SELECT pg_catalog.setval('public.users_id_seq', 78, true);


--
-- Name: cargos cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY ("IdCargo");


--
-- Name: clientes clientes_Nit_key; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_Nit_key" UNIQUE ("Nit");


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY ("IdCliente");


--
-- Name: equipos equipos_Placa_key; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_Placa_key" UNIQUE ("Placa");


--
-- Name: equipos equipos_pkey; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT equipos_pkey PRIMARY KEY ("IdEquipo");


--
-- Name: estado_equipos estado_equipos_pkey; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.estado_equipos
    ADD CONSTRAINT estado_equipos_pkey PRIMARY KEY ("IdEstadoEquipo");


--
-- Name: marcas marcas_pkey; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY ("IdMarca");


--
-- Name: registro_horas registro_horas_pkey; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT registro_horas_pkey PRIMARY KEY ("IdRegistro");


--
-- Name: tipo_equipos tipo_equipos_pkey; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.tipo_equipos
    ADD CONSTRAINT tipo_equipos_pkey PRIMARY KEY ("IdTipoEquipo");


--
-- Name: users users_documento_key; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_documento_key UNIQUE (documento);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: clientes clientes_UsuarioCrea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_UsuarioCrea_fkey" FOREIGN KEY ("UsuarioCrea") REFERENCES public.users(id);


--
-- Name: clientes clientes_UsuarioInactiva_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_UsuarioInactiva_fkey" FOREIGN KEY ("UsuarioInactiva") REFERENCES public.users(id);


--
-- Name: equipos equipos_IdEstadoEquipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_IdEstadoEquipo_fkey" FOREIGN KEY ("IdEstadoEquipo") REFERENCES public.estado_equipos("IdEstadoEquipo");


--
-- Name: equipos equipos_IdMarca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_IdMarca_fkey" FOREIGN KEY ("IdMarca") REFERENCES public.marcas("IdMarca");


--
-- Name: equipos equipos_IdTipoEquipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_IdTipoEquipo_fkey" FOREIGN KEY ("IdTipoEquipo") REFERENCES public.tipo_equipos("IdTipoEquipo");


--
-- Name: equipos equipos_UsuarioCreacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_UsuarioCreacion_fkey" FOREIGN KEY ("UsuarioCreacion") REFERENCES public.users(id);


--
-- Name: equipos equipos_UsuarioInactivacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_UsuarioInactivacion_fkey" FOREIGN KEY ("UsuarioInactivacion") REFERENCES public.users(id);


--
-- Name: registro_horas registro_horas_IdCargo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdCargo_fkey" FOREIGN KEY ("IdCargo") REFERENCES public.cargos("IdCargo");


--
-- Name: registro_horas registro_horas_IdCliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdCliente_fkey" FOREIGN KEY ("IdCliente") REFERENCES public.clientes("IdCliente");


--
-- Name: registro_horas registro_horas_IdEmpleado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdEmpleado_fkey" FOREIGN KEY ("IdEmpleado") REFERENCES public.users(id);


--
-- Name: registro_horas registro_horas_IdEquipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdEquipo_fkey" FOREIGN KEY ("IdEquipo") REFERENCES public.equipos("IdEquipo");


--
-- Name: registro_horas registro_horas_IdEstadoEquipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gruas_user
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdEstadoEquipo_fkey" FOREIGN KEY ("IdEstadoEquipo") REFERENCES public.estado_equipos("IdEstadoEquipo");


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO gruas_user;


--
-- PostgreSQL database dump complete
--

\unrestrict DOsy3vwZ0ydk5YgemUC2jhSK7KogskLWU01NYdzGnEs8rfEvvWikFjPf8F2K1Ib

