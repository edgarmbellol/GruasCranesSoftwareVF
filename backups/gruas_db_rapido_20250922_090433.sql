--
-- PostgreSQL database dump
--

\restrict MwKSbw2vIYdgUfGVnrVIPfhBmLo3Q67UQu7GdHZPkYGuxGrttBoLMfaW3UPJBgv

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

ALTER TABLE IF EXISTS ONLY public.registro_horas DROP CONSTRAINT IF EXISTS "registro_horas_IdEstadoEquipo_fkey";
ALTER TABLE IF EXISTS ONLY public.registro_horas DROP CONSTRAINT IF EXISTS "registro_horas_IdEquipo_fkey";
ALTER TABLE IF EXISTS ONLY public.registro_horas DROP CONSTRAINT IF EXISTS "registro_horas_IdEmpleado_fkey";
ALTER TABLE IF EXISTS ONLY public.registro_horas DROP CONSTRAINT IF EXISTS "registro_horas_IdCliente_fkey";
ALTER TABLE IF EXISTS ONLY public.registro_horas DROP CONSTRAINT IF EXISTS "registro_horas_IdCargo_fkey";
ALTER TABLE IF EXISTS ONLY public.equipos DROP CONSTRAINT IF EXISTS "equipos_UsuarioInactivacion_fkey";
ALTER TABLE IF EXISTS ONLY public.equipos DROP CONSTRAINT IF EXISTS "equipos_UsuarioCreacion_fkey";
ALTER TABLE IF EXISTS ONLY public.equipos DROP CONSTRAINT IF EXISTS "equipos_IdTipoEquipo_fkey";
ALTER TABLE IF EXISTS ONLY public.equipos DROP CONSTRAINT IF EXISTS "equipos_IdMarca_fkey";
ALTER TABLE IF EXISTS ONLY public.equipos DROP CONSTRAINT IF EXISTS "equipos_IdEstadoEquipo_fkey";
ALTER TABLE IF EXISTS ONLY public.clientes DROP CONSTRAINT IF EXISTS "clientes_UsuarioInactiva_fkey";
ALTER TABLE IF EXISTS ONLY public.clientes DROP CONSTRAINT IF EXISTS "clientes_UsuarioCrea_fkey";
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_documento_key;
ALTER TABLE IF EXISTS ONLY public.tipo_equipos DROP CONSTRAINT IF EXISTS tipo_equipos_pkey;
ALTER TABLE IF EXISTS ONLY public.registro_horas DROP CONSTRAINT IF EXISTS registro_horas_pkey;
ALTER TABLE IF EXISTS ONLY public.marcas DROP CONSTRAINT IF EXISTS marcas_pkey;
ALTER TABLE IF EXISTS ONLY public.estado_equipos DROP CONSTRAINT IF EXISTS estado_equipos_pkey;
ALTER TABLE IF EXISTS ONLY public.equipos DROP CONSTRAINT IF EXISTS equipos_pkey;
ALTER TABLE IF EXISTS ONLY public.equipos DROP CONSTRAINT IF EXISTS "equipos_Placa_key";
ALTER TABLE IF EXISTS ONLY public.clientes DROP CONSTRAINT IF EXISTS clientes_pkey;
ALTER TABLE IF EXISTS ONLY public.clientes DROP CONSTRAINT IF EXISTS "clientes_Nit_key";
ALTER TABLE IF EXISTS ONLY public.cargos DROP CONSTRAINT IF EXISTS cargos_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tipo_equipos ALTER COLUMN "IdTipoEquipo" DROP DEFAULT;
ALTER TABLE IF EXISTS public.registro_horas ALTER COLUMN "IdRegistro" DROP DEFAULT;
ALTER TABLE IF EXISTS public.marcas ALTER COLUMN "IdMarca" DROP DEFAULT;
ALTER TABLE IF EXISTS public.estado_equipos ALTER COLUMN "IdEstadoEquipo" DROP DEFAULT;
ALTER TABLE IF EXISTS public.equipos ALTER COLUMN "IdEquipo" DROP DEFAULT;
ALTER TABLE IF EXISTS public.clientes ALTER COLUMN "IdCliente" DROP DEFAULT;
ALTER TABLE IF EXISTS public.cargos ALTER COLUMN "IdCargo" DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public."tipo_equipos_IdTipoEquipo_seq";
DROP TABLE IF EXISTS public.tipo_equipos;
DROP SEQUENCE IF EXISTS public."registro_horas_IdRegistro_seq";
DROP TABLE IF EXISTS public.registro_horas;
DROP SEQUENCE IF EXISTS public."marcas_IdMarca_seq";
DROP TABLE IF EXISTS public.marcas;
DROP SEQUENCE IF EXISTS public."estado_equipos_IdEstadoEquipo_seq";
DROP TABLE IF EXISTS public.estado_equipos;
DROP SEQUENCE IF EXISTS public."equipos_IdEquipo_seq";
DROP TABLE IF EXISTS public.equipos;
DROP SEQUENCE IF EXISTS public."clientes_IdCliente_seq";
DROP TABLE IF EXISTS public.clientes;
DROP SEQUENCE IF EXISTS public."cargos_IdCargo_seq";
DROP TABLE IF EXISTS public.cargos;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cargos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cargos (
    "IdCargo" integer NOT NULL,
    "descripcionCargo" character varying(100) NOT NULL,
    "Estado" character varying(20)
);


--
-- Name: cargos_IdCargo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."cargos_IdCargo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cargos_IdCargo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."cargos_IdCargo_seq" OWNED BY public.cargos."IdCargo";


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: clientes_IdCliente_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."clientes_IdCliente_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clientes_IdCliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."clientes_IdCliente_seq" OWNED BY public.clientes."IdCliente";


--
-- Name: equipos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: equipos_IdEquipo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."equipos_IdEquipo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: equipos_IdEquipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."equipos_IdEquipo_seq" OWNED BY public.equipos."IdEquipo";


--
-- Name: estado_equipos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estado_equipos (
    "IdEstadoEquipo" integer NOT NULL,
    "Descripcion" character varying(100) NOT NULL,
    "Estado" character varying(20)
);


--
-- Name: estado_equipos_IdEstadoEquipo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."estado_equipos_IdEstadoEquipo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estado_equipos_IdEstadoEquipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."estado_equipos_IdEstadoEquipo_seq" OWNED BY public.estado_equipos."IdEstadoEquipo";


--
-- Name: marcas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.marcas (
    "IdMarca" integer NOT NULL,
    "DescripcionMarca" character varying(100) NOT NULL,
    estado character varying(20)
);


--
-- Name: marcas_IdMarca_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."marcas_IdMarca_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: marcas_IdMarca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."marcas_IdMarca_seq" OWNED BY public.marcas."IdMarca";


--
-- Name: registro_horas; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: registro_horas_IdRegistro_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."registro_horas_IdRegistro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registro_horas_IdRegistro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."registro_horas_IdRegistro_seq" OWNED BY public.registro_horas."IdRegistro";


--
-- Name: tipo_equipos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_equipos (
    "IdTipoEquipo" integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    estado character varying(20)
);


--
-- Name: tipo_equipos_IdTipoEquipo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."tipo_equipos_IdTipoEquipo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tipo_equipos_IdTipoEquipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."tipo_equipos_IdTipoEquipo_seq" OWNED BY public.tipo_equipos."IdTipoEquipo";


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cargos IdCargo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cargos ALTER COLUMN "IdCargo" SET DEFAULT nextval('public."cargos_IdCargo_seq"'::regclass);


--
-- Name: clientes IdCliente; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes ALTER COLUMN "IdCliente" SET DEFAULT nextval('public."clientes_IdCliente_seq"'::regclass);


--
-- Name: equipos IdEquipo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipos ALTER COLUMN "IdEquipo" SET DEFAULT nextval('public."equipos_IdEquipo_seq"'::regclass);


--
-- Name: estado_equipos IdEstadoEquipo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estado_equipos ALTER COLUMN "IdEstadoEquipo" SET DEFAULT nextval('public."estado_equipos_IdEstadoEquipo_seq"'::regclass);


--
-- Name: marcas IdMarca; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marcas ALTER COLUMN "IdMarca" SET DEFAULT nextval('public."marcas_IdMarca_seq"'::regclass);


--
-- Name: registro_horas IdRegistro; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registro_horas ALTER COLUMN "IdRegistro" SET DEFAULT nextval('public."registro_horas_IdRegistro_seq"'::regclass);


--
-- Name: tipo_equipos IdTipoEquipo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_equipos ALTER COLUMN "IdTipoEquipo" SET DEFAULT nextval('public."tipo_equipos_IdTipoEquipo_seq"'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cargos; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clientes ("IdCliente", "NombreCliente", "Nit", "FechaCreacion", "UsuarioCrea", "Estado", "UsuarioInactiva", "FechaInactiva") FROM stdin;
12	CELIK CONSTRUCCIONES METÁLICAS	900444818-8	2025-09-11 14:29:54.905386	62	activo	\N	\N
7	BESSAC ANDINA 	900266941-2	2025-09-11 11:01:22.605668	62	activo	\N	\N
8	GRUAS LIMITADA	800202809-0	2025-09-11 11:02:26.995257	62	activo	\N	\N
9	METRO LÍNEA 1 	901339011-6	2025-09-11 14:22:57.005384	62	activo	\N	\N
11	TEC GRUAS	901305121-1	2025-09-11 14:26:06.237741	62	activo	\N	\N
10	UNIÓN TEMPORAL CABLE SAN CRISTÓBAL 	901702585-8	2025-09-11 14:24:53.814069	62	activo	\N	\N
13	MTS MONTAJES Y SERVICIOS TELESCÓPICOS 	900409892-5	2025-09-11 17:17:24.191724	62	activo	\N	\N
14	YDN MICROTUNNELING	901221375-3	2025-09-11 17:19:34.808918	62	activo	\N	\N
15	GRUAS INGER	900954348-6	2025-09-16 12:07:32.853496	62	activo	\N	\N
6	GRUAS CRANES SAS	900508612-4	2025-09-11 06:26:07.816985	62	activo	\N	\N
\.


--
-- Data for Name: equipos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.equipos ("IdEquipo", "IdTipoEquipo", "Placa", "Capacidad", "IdMarca", "Referencia", "Color", "Modelo", "CentroCostos", "Estado", "IdEstadoEquipo", "FechaCreacion", "UsuarioCreacion", "FechaInactivacion", "UsuarioInactivacion") FROM stdin;
24	72	PMR799	20	13	BRONCO	AZUL CLARO	2024	00213	activo	63	2025-09-11 10:57:33.162867	62	\N	\N
25	75	328	10	16					activo	63	2025-09-11 13:37:48.693248	62	\N	\N
26	74	POZ887	6.5	11	FUSO	BLANCO	2023	1014	activo	63	2025-09-11 13:59:18.025395	62	\N	\N
27	68	POZ873	20	9	ACTROS	BLANCO	2023	1021	activo	63	2025-09-11 14:00:25.478901	62	\N	\N
29	70	MI725248	60	8	DEMAG CHALLENGER 3160	AMARILLO AZUL	2015	1007	activo	63	2025-09-12 13:38:08.89871	62	\N	\N
30	70	MIC15635	70	2	LTM1070-4.2	AMARILLO	2013	1002	activo	63	2025-09-12 13:41:38.299278	62	\N	\N
31	70	MI045782	90	2	LTM1080/1	NEGRO	2004	1003	activo	63	2025-09-12 13:44:02.817841	62	\N	\N
32	70	MI112324	55	5	GMK3050	BLANCO	2003	1001	activo	63	2025-09-12 13:45:33.499968	62	\N	\N
33	73	NUU605	55	6	DAF- XCT55_E	ROJO	2025	1015	activo	63	2025-09-12 13:48:21.696781	62	\N	\N
34	73	NUV626	55	7	FOTÓN-XCT55_E	ROJO	2025	1017	activo	63	2025-09-12 13:51:09.703021	62	\N	\N
35	70	MI640780	120	2	LTM1100	BLANCO AZUL	2009	0	activo	63	2025-09-18 11:14:29.954191	62	\N	\N
36	70	MI698975	170	8	AC 170	BLANCA 	2011	0	activo	63	2025-09-18 11:15:33.409615	62	\N	\N
37	69	LUX103	24	3	DAF PM 24	BLANCO	2023	0	activo	63	2025-09-18 15:20:08.738755	62	\N	\N
38	69	LCT089	24	3	DAF-PM-24	BLANCO	2023	0	activo	63	2025-09-18 15:53:57.397826	62	\N	\N
39	70	MI581366	130	1	ATF-110-G5	BLANCO	2009	0	activo	63	2025-09-18 15:56:13.372797	62	\N	\N
40	72	BEU953	100	2					activo	63	2025-09-18 19:37:02.073498	62	\N	\N
28	70	MI753619	250	8	DEMAG EXPLORER 5800	AMARILLO	2015	1019	activo	63	2025-09-12 11:44:03.733011	62	\N	\N
\.


--
-- Data for Name: estado_equipos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.estado_equipos ("IdEstadoEquipo", "Descripcion", "Estado") FROM stdin;
63	Operativo	activo
64	Fuera de servicio	activo
65	Mantenimiento	activo
66	Averiado	activo
\.


--
-- Data for Name: marcas; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: registro_horas; Type: TABLE DATA; Schema: public; Owner: -
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
126	29	77	136	10	63	2025-09-17 20:00:08.193658	2025-09-17	14:59:00	\N	\N	\N	\N	grua_3f88ef93faa54799a9f8b49188565b6f.jpg			4.748117	-74.155421	salida	2025-09-17 20:00:08.193669
127	29	78	135	10	63	2025-09-17 20:02:59.142507	2025-09-17	14:58:00	130930	14072	kilometraje_36664fc97cc440f0bdec2bbb5100c842.jpg	horometro_a47c9f5362d8446599ac4b06398a8c45.jpg	grua_61aa3a3d851c4ab69e480b13e0fa300f.jpg			4.747567	-74.155726	salida	2025-09-17 20:02:59.142517
128	25	66	140	6	63	2025-09-17 22:22:59.546873	2025-09-17	17:22:00	\N	\N	\N	\N	grua_81b820349a7c44b1afe3f00f85846079.jpg			4.906207	-74.028081	salida	2025-09-17 22:22:59.546887
129	25	67	140	6	63	2025-09-17 22:28:17.035099	2025-09-17	17:27:00	\N	\N	\N	\N	grua_56a6ed308fe74fc981ca9136bdc387ee.jpg			4.906233	-74.028082	salida	2025-09-17 22:28:17.03511
130	25	65	140	6	63	2025-09-17 22:29:33.927715	2025-09-17	17:28:00	\N	\N	\N	\N	grua_3fa29b21c89b40bfa0857b0642537521.jpg			4.906253	-74.02807	salida	2025-09-17 22:29:33.927726
131	25	72	140	6	63	2025-09-17 22:30:49.254527	2025-09-17	17:30:00	\N	\N	\N	\N	grua_97bf1df7ab28456688df0123b60a0a01.jpg			\N	\N	salida	2025-09-17 22:30:49.254537
132	25	64	140	6	63	2025-09-17 22:46:15.916454	2025-09-17	17:45:00	\N	\N	\N	\N	grua_0ee419bd78234be696748e093ca824e4.jpg			\N	\N	salida	2025-09-17 22:46:15.916464
133	28	70	135	6	65	2025-09-18 02:13:11.206969	2025-09-17	18:00:00	23127	587	kilometraje_fc4c3dee68d34725a824289fc1151155.jpg	horometro_96a910162ed74924b26febceff823bbb.jpg	grua_834269e1626b41248e6026641dcdadbe.jpg	Equipo inoperativo pendiente agregar líquido refrigerante 		4.729554	-74.283265	salida	2025-09-18 02:13:11.206981
134	28	71	136	6	65	2025-09-18 02:39:03.343809	2025-09-17	21:38:00	\N	\N	\N	\N	grua_5c2532ec5353491dac6bc8d4398008e1.jpg			4.569937	-74.154991	salida	2025-09-18 02:39:03.343819
135	35	79	135	10	63	2025-09-18 12:39:07.188633	2025-09-18	07:37:00	71420	11968	kilometraje_7b6d335560af494a9db7eed1b30c4aac.jpg	horometro_4b2c66d3844148f59ec9f43c8f18c361.jpg	grua_7d3d7f3ee9a84a2187ab937d52c241af.jpg			\N	\N	entrada	2025-09-18 12:39:07.18865
136	35	79	135	10	63	2025-09-18 12:40:53.131287	2025-09-18	07:39:00	71420	11968	kilometraje_035b03dc42384a3f9c0ae2f5a6018576.jpg	horometro_8b557beff79a4adabc96e9dda6f2b6fa.jpg	grua_db2079bab70a4b23a47bba5a8cde55b8.jpg			4.565761	-74.095636	salida	2025-09-18 12:40:53.131301
137	25	72	140	6	63	2025-09-18 12:43:07.968724	2025-09-18	07:42:00	\N	\N	\N	\N	grua_71f8d02f82cc449db9b58f5f787e98e7.jpg			\N	\N	entrada	2025-09-18 12:43:07.968735
138	35	79	135	10	63	2025-09-18 12:43:12.999334	2025-09-18	07:41:00	71420	11968	kilometraje_5682cec45fcf477b9004259cfba44d48.jpg	horometro_f1038c03c21a4e24a949635df56c3a47.jpg	grua_2c94cf9b1f584be29ae99002f6886134.jpg			4.565893	-74.095545	entrada	2025-09-18 12:43:12.999348
139	35	80	136	10	63	2025-09-18 12:43:39.573721	2025-09-18	07:42:00	\N	\N	\N	\N	grua_d8f9f22cc34c45a2ad8821dacf6d16ba.jpg			4.570853	-74.091702	entrada	2025-09-18 12:43:39.573731
140	36	82	136	10	63	2025-09-18 12:46:18.725284	2025-09-18	07:45:00	\N	\N	\N	\N	grua_df596e5eb1b942b59c9b2501cf6439b1.jpg			4.5659	-74.096075	entrada	2025-09-18 12:46:18.725296
141	25	66	140	6	63	2025-09-18 12:53:13.602786	2025-09-18	07:52:00	\N	\N	\N	\N	grua_71eb692208274abbb76af6b03a222431.jpg			4.906196	-74.028071	entrada	2025-09-18 12:53:13.602797
142	25	67	140	6	63	2025-09-18 12:54:43.738908	2025-09-18	07:53:00	\N	\N	\N	\N	grua_a718aa311d564d239ba44a5489eeb317.jpg			4.906235	-74.028081	entrada	2025-09-18 12:54:43.738918
143	25	65	140	6	63	2025-09-18 12:54:59.769085	2025-09-18	07:54:00	\N	\N	\N	\N	grua_764e0d5273bc4f30901c681f9bcae638.jpg			4.906217	-74.028075	entrada	2025-09-18 12:54:59.769095
144	29	77	136	10	63	2025-09-18 13:08:08.921193	2025-09-18	08:06:00	\N	\N	\N	\N	grua_072be442588b4fbf86c317edb754a3d5.jpg			4.748171	-74.155425	entrada	2025-09-18 13:08:08.921205
145	29	78	135	10	63	2025-09-18 13:15:08.581228	2025-09-18	08:12:00	130930	14072	kilometraje_29dd2b156dd549bcb738a422916a95a6.jpg	horometro_5f8eede436c944d3a6eeed93fc0bbc97.jpg	grua_aaf8ba3bf29544c4aa6cc0561b65a309.jpg			4.748108	-74.155388	entrada	2025-09-18 13:15:08.581241
146	28	71	136	6	63	2025-09-18 13:19:35.168259	2025-09-18	08:19:00	\N	\N	\N	\N	grua_174ee13d40cd4a1da4f6b0eda088587b.jpg			4.765814	-74.16355	entrada	2025-09-18 13:19:35.16827
147	28	70	135	6	63	2025-09-18 13:22:22.778686	2025-09-18	07:55:00	23128	587	kilometraje_001e440963b643d98389e67f47b64e50.jpg	horometro_e5a6e7e75dcd491e8b5fe243cc5c7427.jpg	grua_40333587724f4387bc152bcf8d6d555d.jpg			4.765777	-74.163582	entrada	2025-09-18 13:22:22.778698
148	37	84	135	9	63	2025-09-18 15:28:38.098974	2025-09-18	10:23:00	23390	1981	kilometraje_c82b5347de9d4980ae7bc5913d079b9e.jpg	horometro_509f8608736448da8e488c45e6ebd67f.jpg	grua_b0068a337f6d4db0b5c1994d9beb08ac.png			4.611113	-74.132363	entrada	2025-09-18 15:28:38.09899
149	37	84	135	9	63	2025-09-18 15:30:42.616346	2025-09-18	10:29:00	23390	1981	kilometraje_1910d86092064c3eb0fbc55ba48db687.jpg	horometro_f1b77f483d1141a4a6b1490abdfde93e.jpg	grua_80a6013008ad4ecb8ac7ace3eccf3840.png			4.611114	-74.132359	salida	2025-09-18 15:30:42.616356
150	32	83	136	9	63	2025-09-18 15:34:26.258335	2025-09-18	10:32:00	\N	\N	\N	\N	grua_3576350dd61841099fccd70421bc1a50.jpg			4.611021	-74.132321	entrada	2025-09-18 15:34:26.258345
151	32	86	135	9	63	2025-09-18 15:38:54.443676	2025-09-18	10:36:00	90843	29383	kilometraje_ecbdb2c7ef9f4cc18f9864d7a80ce564.jpg	horometro_3e5cb86a315b439594cf694531e47a28.jpg	grua_ed5ffaa6bd52444382b19825bbe462b3.jpg	Prueba 		4.611088	-74.132471	entrada	2025-09-18 15:38:54.443688
152	32	86	135	9	63	2025-09-18 15:40:44.067121	2025-09-18	10:39:00	90843	29383	kilometraje_ffd9c12ea6f7475dbb2243ebdebfbc69.jpg	horometro_58959d01f6aa4b8b83194a1a041742f2.jpg	grua_81f8118cda524489aaedbd282b0470ec.jpg	Salida		4.611107	-74.132341	salida	2025-09-18 15:40:44.067132
153	37	85	136	9	63	2025-09-18 15:43:53.991572	2025-09-18	10:42:00	\N	\N	\N	\N	grua_8cde2cb74760459ea64b9d6519c77f5e.jpg			4.611101	-74.132372	entrada	2025-09-18 15:43:53.991586
154	37	85	136	9	63	2025-09-18 15:45:06.267013	2025-09-18	10:44:00	\N	\N	\N	\N	grua_1ebc722b199e4b298e21b9ab01c34478.jpg			4.611119	-74.132355	salida	2025-09-18 15:45:06.267022
155	25	69	140	6	63	2025-09-18 15:52:11.802954	2025-09-18	10:50:00	\N	\N	\N	\N	grua_c6fd099241654e0d91069f4db951a488.jpg			4.906253	-74.028063	entrada	2025-09-18 15:52:11.802966
156	37	84	135	9	63	2025-09-18 16:29:27.6925	2025-09-18	11:24:00	23421	1990	kilometraje_2dd81a9d7afe4f3da3ef796e78b6cbd6.jpg	horometro_e8f82b27f77e4c7ca655d67eb86cd856.jpg	grua_270b910e8fc045d7bf42813a872f97b8.jpg	Reparación de manguera de viga de anclaje trasera derecha 		4.60102	-74.118737	entrada	2025-09-18 16:29:27.692513
157	37	85	136	9	63	2025-09-18 16:29:57.184395	2025-09-18	11:28:00	\N	\N	\N	\N	grua_6364b4983c304d10ac3e14099a6db53b.jpg	Reparación de manguera viga trasera isquierda		4.601	-74.118865	entrada	2025-09-18 16:29:57.184406
158	32	86	135	9	63	2025-09-18 16:36:24.08667	2025-09-18	11:34:00	90869	29489	kilometraje_48c2811a085f4085be576e4dd3f01b94.jpg	horometro_f447f8ce01e14b99a94fe13d542d6591.jpg	grua_3925bd0724364085b77ce1b5573e1a04.jpg	Entrada		4.60342	-74.122439	entrada	2025-09-18 16:36:24.086686
159	33	87	136	9	63	2025-09-18 17:34:52.248886	2025-09-18	12:33:00	\N	\N	\N	\N	grua_44d3217df5bc4cd18479237b1b1ff63a.jpg			4.661738	-74.061222	entrada	2025-09-18 17:34:52.248899
160	33	87	136	9	63	2025-09-18 17:36:06.967757	2025-09-18	12:35:00	\N	\N	\N	\N	grua_738f8a654051466592c7d2049bf9a2db.jpg			4.66168	-74.061262	salida	2025-09-18 17:36:06.967779
161	33	88	135	9	63	2025-09-18 17:40:26.504106	2025-09-18	12:36:00	1933	2111	kilometraje_2817b0382b3d4cff8d3cced17999f6db.jpg	horometro_62393ddd05b14c97a6e3cd486491e876.jpg	grua_22cd0ddf5c6541c088fbab16cd1ab459.jpg			4.661734	-74.061191	entrada	2025-09-18 17:40:26.504121
162	33	88	135	9	63	2025-09-18 17:42:57.396079	2025-09-18	12:40:00	1933	2111	kilometraje_fa22df789da24a5080bd854fa14a1301.jpg	horometro_d4665b4f41c34132b4592519fdafbcb0.jpg	grua_385543f39c4841dd81260cd2d4416d63.jpg			4.661661	-74.061248	salida	2025-09-18 17:42:57.396092
163	33	90	136	9	63	2025-09-18 19:40:17.050959	2025-09-18	14:38:00	\N	\N	\N	\N	grua_1e0f08e7d63b4af58b90d1343fe0c34a.jpg			4.661738	-74.061178	entrada	2025-09-18 19:40:17.050972
164	33	90	136	9	63	2025-09-18 19:41:28.472937	2025-09-18	14:40:00	\N	\N	\N	\N	grua_4ef1f3069c024a668ccc5c9f8047293d.jpg			4.661758	-74.061231	salida	2025-09-18 19:41:28.472946
165	24	89	135	6	63	2025-09-18 19:42:36.454735	2025-09-18	14:40:00	100	100	kilometraje_0afe111a72f04ad4badf2c5ed4c56142.jpg	horometro_5393b90ae85f481c8772764a1b55796c.jpg	grua_7bcb88da515345f2a2bd91b4173821e4.jpg			4.911376	-73.941984	entrada	2025-09-18 19:42:36.45475
166	24	89	135	6	63	2025-09-18 19:43:00.967524	2025-09-18	14:42:00	100	100	kilometraje_ebb27faeaea74b468915318cb4ec132f.jpg	horometro_18c16a456ff44df79b56660319b9fc0f.jpg	grua_5d464482e17b427e8759173a5e18f580.jpg			4.911086	-73.942214	salida	2025-09-18 19:43:00.967535
167	33	91	135	9	63	2025-09-18 19:46:38.41955	2025-09-18	14:44:00	1933	2111	kilometraje_7231ad6328144365af4b714835cbcf98.jpg	horometro_1faba4f8e8b3448c9e5538620e041d27.jpg	grua_954d8965cc414d88bcd5c07e1295168b.jpg			4.661688	-74.061232	entrada	2025-09-18 19:46:38.419579
168	38	93	136	9	63	2025-09-18 20:58:57.322324	2025-09-18	15:56:00	\N	\N	\N	\N	grua_1ac3cc26abb4480194e7f8a988bdfbbe.jpg			4.649687	-74.065623	entrada	2025-09-18 20:58:57.322334
169	38	92	135	9	63	2025-09-18 21:06:01.475886	2025-09-18	16:02:00	2000	180	kilometraje_911627f637f0496eaf9615091a8d6a16.jpg	horometro_c76a15a410b545269b1dc40f0e0c177f.jpg	grua_a3a6a51bc63940bfb404ff09030ef693.jpg			4.64968	-74.065663	entrada	2025-09-18 21:06:01.475898
170	29	78	135	10	63	2025-09-18 21:13:34.882476	2025-09-18	16:10:00	130930	14075	kilometraje_d36ef84cbc404914930392cbe0810e17.jpg	horometro_28d38dd816644195bfcf4107f65b8cac.jpg	grua_e16c844ef10d4f3d9966990cefb61e7d.jpg			4.7482	-74.155434	salida	2025-09-18 21:13:34.882488
171	29	77	136	10	63	2025-09-18 21:17:28.662156	2025-09-18	16:13:00	\N	\N	\N	\N	grua_1900653ac275405493380774757cf065.jpg			4.748181	-74.155401	salida	2025-09-18 21:17:28.662168
172	28	70	135	6	63	2025-09-18 21:54:22.046419	2025-09-18	16:54:00	23128	587	kilometraje_86cc06eb8fa14bb097232771336cf1f3.jpg	horometro_52771f921f5b40d6b826120becccabe7.jpg	grua_a013d113eb864cfaa5d6b5817dfc94dc.jpg			4.765958	-74.163523	salida	2025-09-18 21:54:22.04643
173	38	93	136	9	63	2025-09-18 22:06:15.363401	2025-09-18	17:05:00	\N	\N	\N	\N	grua_d6467ec5b8ed4203894f7549c02532d1.jpg	Queda todo en orden 		4.649629	-74.064757	salida	2025-09-18 22:06:15.363412
174	25	67	140	6	63	2025-09-18 22:09:33.85601	2025-09-18	17:09:00	\N	\N	\N	\N	grua_96148257800d40a4843cf597458d0883.jpg			4.906264	-74.028081	salida	2025-09-18 22:09:33.85602
175	25	65	140	6	63	2025-09-18 22:10:37.898263	2025-09-18	17:09:00	\N	\N	\N	\N	grua_10afe6a8fbce44ac899b891d1adcc62a.jpg			4.906266	-74.028077	salida	2025-09-18 22:10:37.898274
176	25	66	140	6	63	2025-09-18 22:13:36.725312	2025-09-18	17:13:00	\N	\N	\N	\N	grua_8c697affc3114cb0b0bbb1033f181bfd.jpg			4.906264	-74.028096	salida	2025-09-18 22:13:36.725324
177	38	92	135	9	63	2025-09-18 22:14:23.666656	2025-09-18	17:13:00	5964.4	250	kilometraje_636f7b9bb3ee4a3a97b5a5c4f46f1a0f.jpg	horometro_9a0113ae28bd4466b522395cd2b17c53.jpg	grua_4ed692a365fc42e6b58650157882487d.jpg			4.649694	-74.064734	salida	2025-09-18 22:14:23.666666
178	25	69	140	6	63	2025-09-18 22:27:23.4429	2025-09-18	17:26:00	\N	\N	\N	\N	grua_a08377f9dded47e6adeb47bbd47f1b41.jpg			4.906255	-74.028081	salida	2025-09-18 22:27:23.442909
179	25	72	140	6	63	2025-09-18 22:44:14.85394	2025-09-18	17:44:00	\N	\N	\N	\N	grua_e793884447d54725b12fd1d64d2006b1.jpg			\N	\N	salida	2025-09-18 22:44:14.85395
180	32	83	136	9	63	2025-09-18 22:54:43.389362	2025-09-18	17:54:00	\N	\N	\N	\N	grua_d0dcf3ae27de426ba5b3c112c87ed2df.jpg			4.603399	-74.122375	salida	2025-09-18 22:54:43.389371
295	33	90	136	9	63	2025-09-22 10:58:40.266913	2025-09-22	05:57:00	\N	\N	\N	\N	grua_253e368594b348408827b0cc2b095cc5.jpg			4.661103	-74.061688	entrada	2025-09-22 10:58:40.266926
181	32	86	135	9	63	2025-09-18 22:55:43.856631	2025-09-18	17:52:00	90870	29493	kilometraje_15f0359cf954417dbaecceb2e3bbec83.jpg	horometro_96899aabb160425ab6ab0e15da1c0556.jpg	grua_acab13d10eec4c0398a350678fcf2853.jpg	Salida		4.603558	-74.122527	salida	2025-09-18 22:55:43.85664
182	37	84	135	9	63	2025-09-18 23:55:53.782683	2025-09-18	18:51:00	23439	1990	kilometraje_b930fe1c12504512b4dd4573ceaf11ff.jpg	horometro_ae5a3c3cb98b496f817c50d71e571c75.jpg	grua_99fb60d1b4f640aab77ffe22ff9ebb3f.jpg	La reparación de la manguera de la viga trasera izquierda que ok 		4.600668	-74.118776	salida	2025-09-18 23:55:53.782696
183	37	85	136	9	63	2025-09-19 00:03:22.902111	2025-09-18	18:53:00	\N	\N	\N	\N	grua_6ab83d7c79b94e42a60a43aa79abc8f1.jpg			4.600898	-74.118353	salida	2025-09-19 00:03:22.902121
184	33	91	135	9	63	2025-09-19 02:53:29.915419	2025-09-18	21:47:00	1934	2133	kilometraje_84e6d906528d49cd9de9e09296d9d324.jpg	horometro_9a10f0dcaaa744dfa96e895b48a02637.jpg	grua_f4cfc0f82293489da4c7ea25fa443748.jpg			4.661009	-74.061715	salida	2025-09-19 02:53:29.91543
185	33	87	136	9	63	2025-09-19 10:44:23.240402	2025-09-19	05:43:00	\N	\N	\N	\N	grua_3fd08ed01d3345d6ac1378b145c7285a.jpg			4.661176	-74.061776	entrada	2025-09-19 10:44:23.240416
186	33	88	135	9	63	2025-09-19 10:48:49.011974	2025-09-19	05:45:00	1934	2137	kilometraje_1039efae9ef148c89fc759e6880a9718.jpg	horometro_ee5ce5b172114b3d9689215829bd0248.jpg	grua_8366d28b879c47b9b1c4ec2cdc68bfdc.jpg			4.660938	-74.061619	entrada	2025-09-19 10:48:49.011986
187	31	76	135	11	63	2025-09-19 10:50:19.033696	2025-09-19	05:49:00	91690	30037	kilometraje_a2d469e608654ed8876a7e74dead56e3.jpg	horometro_e7fcfdf190f54a2bbbbbbceda9842500.jpg	grua_84b4de5729044e1fa71365dd6a812632.jpg			4.764954	-74.163794	entrada	2025-09-19 10:50:19.033709
188	32	86	135	9	63	2025-09-19 11:27:33.938391	2025-09-19	06:25:00	90870	29495	kilometraje_1bb1c01b2ef0427396832450c3c1554f.jpg	horometro_e3b1dee1583541f5b67f340033128d68.jpg	grua_788564f5ec87460ab5fb125a195c8487.jpg	Turno dia		4.603439	-74.122326	entrada	2025-09-19 11:27:33.938406
189	35	80	136	10	63	2025-09-19 11:50:02.93972	2025-09-19	06:48:00	\N	\N	\N	\N	grua_8a40445f46ed488a9da0f0133c5e699a.jpg			4.565247	-74.095	salida	2025-09-19 11:50:02.93973
190	36	82	136	10	63	2025-09-19 11:50:29.60063	2025-09-19	06:49:00	\N	\N	\N	\N	grua_5c3a05d8a7e84640a7df4fc1b005d2f7.jpg			4.565919	-74.095689	salida	2025-09-19 11:50:29.600643
191	35	80	136	10	63	2025-09-19 11:52:05.661046	2025-09-19	06:50:00	\N	\N	\N	\N	grua_438f3e4dd17f4668be42760d81084c98.jpg			4.565718	-74.095093	entrada	2025-09-19 11:52:05.661058
192	36	82	136	10	63	2025-09-19 11:52:10.235786	2025-09-19	06:51:00	\N	\N	\N	\N	grua_84e24bd4624a49afb6336cba0765e173.jpg			4.566083	-74.095465	entrada	2025-09-19 11:52:10.235798
193	35	79	135	10	63	2025-09-19 12:03:44.927487	2025-09-19	07:01:00	71420	11968	kilometraje_9d65af6992104216a5d779f46de73087.jpg	horometro_c71969f5a12b490c818e7f351ce11efe.jpg	grua_6c9904fdf9b24f78b7966355bbcf00cf.jpg			4.565497	-74.095291	salida	2025-09-19 12:03:44.927503
194	35	79	135	10	63	2025-09-19 12:06:08.720648	2025-09-19	07:04:00	71420	11968	kilometraje_b521b39cd372450e9bfefb7d56d4c2c2.jpg	horometro_5a9ba774c7ce47e0a3e04a554a798ffa.jpg	grua_0eb7e8d9319149b3a2437847db172389.jpg			4.565644	-74.095442	entrada	2025-09-19 12:06:08.720663
195	32	83	136	9	63	2025-09-19 12:06:54.901159	2025-09-19	07:06:00	\N	\N	\N	\N	grua_c6aa13857f474543a6b5375169d861a3.jpg			4.603062	-74.1222	entrada	2025-09-19 12:06:54.901171
196	36	81	135	10	63	2025-09-19 12:07:41.083896	2025-09-19	07:06:00	23601	8930	kilometraje_ec563b910f314289a6644e085b5327f9.jpg	horometro_ff0a0e87a2c14f2086e32e88e5389bf5.jpg	grua_a9e8c56f6930416b817eabc2b63174b6.jpg			4.565304	-74.095042	entrada	2025-09-19 12:07:41.083905
197	38	93	136	9	63	2025-09-19 12:30:23.014458	2025-09-19	07:29:00	\N	\N	\N	\N	grua_c2a4e7f887b44a82acfd88a40efe4c27.jpg	Me demore en llegar ya que el metro no nos está ayudando con el tema del parqueo de la moto y hasta que buscará lugar donde dejarla 		4.643701	-74.065859	entrada	2025-09-19 12:30:23.01447
198	38	92	135	9	63	2025-09-19 12:43:22.424962	2025-09-19	07:40:00	6009.7	6009.7	kilometraje_648bd59f55c9427c87488d92f371d482.jpg	horometro_744872a6b24e4097a797fc8875f81c82.jpg	grua_a02e9480e4254991bc03aab6d6f89587.jpg			4.643682	-74.065856	entrada	2025-09-19 12:43:22.424973
199	37	84	135	9	63	2025-09-19 12:43:51.055821	2025-09-19	07:41:00	23448	1996	kilometraje_50be98abfb2c456c895a1cc6bc38255b.jpg	horometro_5bdc4f976c9845d5a17a3fe7abbb60de.jpg	grua_0d91412aec01491b91f627aa70dae0f1.jpg			4.598085	-74.109523	entrada	2025-09-19 12:43:51.055834
200	25	65	140	6	63	2025-09-19 12:45:23.721453	2025-09-19	07:44:00	\N	\N	\N	\N	grua_e09eda3070bc43a38645a0e73419bd9e.jpg			4.906248	-74.028064	entrada	2025-09-19 12:45:23.721464
201	25	67	140	6	63	2025-09-19 12:55:39.607354	2025-09-19	07:55:00	\N	\N	\N	\N	grua_e7d639910b824a13a0385cf87e27924e.jpg			4.906254	-74.028088	entrada	2025-09-19 12:55:39.607366
202	25	66	140	6	63	2025-09-19 12:56:25.727618	2025-09-19	07:56:00	\N	\N	\N	\N	grua_4f9f26ba88be4f319daf3ec9cf0fe62b.jpg			4.906259	-74.02808	entrada	2025-09-19 12:56:25.72763
203	25	68	138	6	63	2025-09-19 13:01:10.689605	2025-09-19	08:00:00	\N	\N	\N	\N	grua_9e44c8e8afb24e70b67038fa802f1ac6.jpg			4.906227	-74.028102	entrada	2025-09-19 13:01:10.689616
204	25	72	140	6	63	2025-09-19 13:02:49.526373	2025-09-19	08:02:00	\N	\N	\N	\N	grua_75e011338dda4cf48b415db1708ae57f.jpg			\N	\N	entrada	2025-09-19 13:02:49.526383
205	29	77	136	10	63	2025-09-19 13:14:44.266691	2025-09-19	08:13:00	\N	\N	\N	\N	grua_7f9e7c0158744b3398a864d940e02c07.jpg			4.748176	-74.155458	entrada	2025-09-19 13:14:44.266701
206	29	78	135	10	63	2025-09-19 13:15:06.395188	2025-09-19	08:13:00	130930	14075	kilometraje_3cbc0f2bbef8440486ba1406be613a5d.jpg	horometro_8d70e085ccb54a8dbf49c441d5299c64.jpg	grua_b8249aa9153e4eae82e39c3cc5b04c10.jpg			4.747999	-74.163029	entrada	2025-09-19 13:15:06.3952
207	31	75	136	11	63	2025-09-19 13:18:48.618508	2025-09-19	08:18:00	\N	\N	\N	\N	grua_25f5e75809314c8093323353d9a2f99b.jpg			4.733334	-74.224426	entrada	2025-09-19 13:18:48.618519
208	28	70	135	6	63	2025-09-19 13:24:20.706003	2025-09-19	08:23:00	23128	587	kilometraje_3f09e1a272d04d66a5d3609eefb00a8a.jpg	horometro_5691366f7d094e10be96f13dd0d3d33d.jpg	grua_8b8d3640cee64cd8836abace241f1776.jpg			4.76588	-74.163483	entrada	2025-09-19 13:24:20.706016
209	28	71	136	6	63	2025-09-19 13:25:22.742757	2025-09-19	01:22:00	\N	\N	\N	\N	grua_7d919159d1544b52b947247436733a2b.jpg			4.765815	-74.163461	salida	2025-09-19 13:25:22.742779
210	28	71	136	6	63	2025-09-19 13:26:30.393235	2025-09-19	08:25:00	\N	\N	\N	\N	grua_e682634f80f14c569d9b351087cdb7c1.jpg			4.765815	-74.163449	entrada	2025-09-19 13:26:30.393246
211	25	64	140	15	63	2025-09-19 13:27:23.369187	2025-09-19	08:26:00	\N	\N	\N	\N	grua_b8d2e0a147af425095fca39499576029.jpg			\N	\N	entrada	2025-09-19 13:27:23.369198
212	37	85	136	9	63	2025-09-19 14:03:29.164709	2025-09-19	09:02:00	\N	\N	\N	\N	grua_96bb02c26a9d4ac4aba36aa55cbb3181.jpg			4.59827	-74.108204	entrada	2025-09-19 14:03:29.164719
213	39	95	136	6	63	2025-09-19 17:51:13.299831	2025-09-19	12:48:00	\N	\N	\N	\N	grua_0a9bfb4eb4554852b352e7d4bdefb443.jpg	Prueba 		4.765823	-74.163525	entrada	2025-09-19 17:51:13.299841
214	39	95	136	6	63	2025-09-19 17:52:31.248912	2025-09-19	12:51:00	\N	\N	\N	\N	grua_e497d8e59fd649db81e331f179f8ad75.jpg			4.765829	-74.1635	salida	2025-09-19 17:52:31.248921
215	39	95	136	6	63	2025-09-19 17:52:32.210055	2025-09-19	12:51:00	\N	\N	\N	\N	grua_96aaada0981f4a6b9f3d4539bc420fad.jpg			4.765829	-74.1635	salida	2025-09-19 17:52:32.210065
216	39	95	136	6	63	2025-09-19 17:54:14.432637	2025-09-19	12:53:00	\N	\N	\N	\N	grua_2e07e82d27354e15b4fc1df0e730689d.jpg	Prueba 		4.765817	-74.163524	entrada	2025-09-19 17:54:14.432647
217	39	94	135	6	63	2025-09-19 18:00:33.40323	2025-09-19	12:55:00	42903	3748	kilometraje_1810e6d32a8a4287a67b3643b7244de4.jpg	horometro_d7a26dfb21ec40daa5053dad4258c7f9.jpg	grua_1be9161398614a4a8071476644e78f80.jpg	Mantenimiento pastillas del boom		4.756757	-74.165355	entrada	2025-09-19 18:00:33.403242
218	39	94	135	6	63	2025-09-19 18:03:18.035704	2025-09-19	13:01:00	42903	3748	kilometraje_e486f13767ad4fd09a6618ff20e7acb1.jpg	horometro_44e661d493504ef2b7e398ddd8e69e87.jpg	grua_7b8e691ff6ce4076b986e4f46139197f.jpg			4.756757	-74.165355	salida	2025-09-19 18:03:18.035713
219	33	91	135	9	63	2025-09-19 19:01:24.23566	2025-09-19	13:57:00	1934	2139	kilometraje_8db73012b1e1412fa9681aa000051a0f.jpg	horometro_1ca64aad87c248e0961ad86fd8dfe7d0.jpg	grua_d0405ffb42414e46996b655388c7abbe.jpg			4.661034	-74.061668	entrada	2025-09-19 19:01:24.235674
220	33	90	136	9	63	2025-09-19 19:03:50.39294	2025-09-19	14:02:00	\N	\N	\N	\N	grua_161f916fdb874fd4999f54c5fcbf664d.jpg			4.661562	-74.061626	entrada	2025-09-19 19:03:50.392951
221	33	87	136	9	63	2025-09-19 19:13:22.451948	2025-09-19	14:12:00	\N	\N	\N	\N	grua_b6382b1cf6d34f778b7c9285f97e8d56.jpg			4.661098	-74.06169	salida	2025-09-19 19:13:22.451957
222	33	88	135	9	63	2025-09-19 19:16:23.702169	2025-09-19	14:12:00	1934	2139	kilometraje_bb014c2916c24c4e90b87d64c6352a40.jpg	horometro_fa2c866404104b7c99f48ac4e5296645.jpg	grua_60ffbe55ca5a4a70b903c9f5aa0a46c7.jpg	 Sin Novedad		4.660932	-74.061748	salida	2025-09-19 19:16:23.702179
223	29	78	135	10	63	2025-09-19 20:35:24.148376	2025-09-19	15:33:00	130930	14075	kilometraje_68527a4265604bde84ddafc1c2afb63b.jpg	horometro_b60d911cd10540c289b4b67de7ee0e7c.jpg	grua_d67c00c7c9d04a56ad102cd23a8131f8.jpg			4.748274	-74.155656	salida	2025-09-19 20:35:24.148387
224	29	77	136	10	63	2025-09-19 20:41:29.945658	2025-09-19	15:40:00	\N	\N	\N	\N	grua_f6c301e1b1c649d89d6e0941b79ba6cd.jpg			4.748142	-74.155436	salida	2025-09-19 20:41:29.945668
225	37	85	136	9	63	2025-09-19 21:35:08.719851	2025-09-19	16:34:00	\N	\N	\N	\N	grua_180db5c0b60249c1a0aa35aca34cb2ff.jpg			4.598278	-74.109194	salida	2025-09-19 21:35:08.719864
226	37	84	135	9	63	2025-09-19 21:38:02.304601	2025-09-19	16:32:00	23450	2004	kilometraje_2317569864d94aebb57bb2e08b8f2140.jpg	horometro_d1f91c9e0bea40bb9cd92ce22c5db991.jpg	grua_8aa11939504b4124a24a56ca4c0ea2eb.jpg			4.597912	-74.108826	salida	2025-09-19 21:38:02.304615
227	32	83	136	9	63	2025-09-19 21:49:59.664827	2025-09-19	16:49:00	\N	\N	\N	\N	grua_11108ae55e1548f4bd2e94c37e4436a2.jpg			4.603309	-74.122354	salida	2025-09-19 21:49:59.664838
228	32	86	135	9	63	2025-09-19 21:50:57.543921	2025-09-19	16:49:00	90870	29495	kilometraje_1d964eba322643a1837014381b3252c1.jpg	horometro_d857166bbc414857841a1cc7ea77582f.jpg	grua_5658bb8485424007b23c8d5206fd832e.jpg	Registro de salida		4.60351	-74.122333	salida	2025-09-19 21:50:57.543933
229	35	80	136	10	63	2025-09-19 22:00:55.582557	2025-09-19	17:00:00	\N	\N	\N	\N	grua_d4b24a9b06f34753b8ab21d1c215ac48.jpg			4.565548	-74.094979	salida	2025-09-19 22:00:55.582587
230	36	82	136	10	63	2025-09-19 22:01:15.613365	2025-09-19	17:00:00	\N	\N	\N	\N	grua_9be717056ca8462abc4e1a1329219063.jpg			\N	\N	salida	2025-09-19 22:01:15.613375
231	35	79	135	10	63	2025-09-19 22:01:53.322445	2025-09-19	17:00:00	71420	11968	kilometraje_7ab88cc56b924ce6bd2255460210b22b.jpg	horometro_c2ecc5a540f44fd5ab3d57ae298b09f2.jpg	grua_81c112fed6594e16a5738df7d2b5ea95.jpg			4.565672	-74.095333	salida	2025-09-19 22:01:53.322457
232	38	93	136	9	63	2025-09-19 22:06:10.128828	2025-09-19	17:05:00	\N	\N	\N	\N	grua_ae49afaca7d545ae9e5cfef5d65a68a7.jpg			4.609915	-74.075701	salida	2025-09-19 22:06:10.128837
233	38	92	135	9	63	2025-09-19 22:09:55.336394	2025-09-19	17:06:00	6063.2	6063.2	kilometraje_4f26c376315a435494459a16f107d007.jpg	horometro_b8b2f33e3f014a339f2dcda408134b92.jpg	grua_e2031f6c5a4a4bba8e39a17519af32e5.jpg			4.609956	-74.075756	salida	2025-09-19 22:09:55.336406
234	36	81	135	10	63	2025-09-19 22:10:28.789714	2025-09-19	17:08:00	23601	8931	kilometraje_4f1764886176499797c8406f58e335b3.jpg	horometro_9796b71044f54a7bb699320c3812315b.jpg	grua_8cec49c787084b56a9f1573d762c366c.jpg			4.566233	-74.095007	salida	2025-09-19 22:10:28.789723
235	25	66	140	6	63	2025-09-19 22:13:54.040445	2025-09-19	17:13:00	\N	\N	\N	\N	grua_c132f93cf80641a8bb442a196b6396bf.jpg			4.906253	-74.028081	salida	2025-09-19 22:13:54.040454
236	25	67	140	6	63	2025-09-19 22:14:22.70435	2025-09-19	17:13:00	\N	\N	\N	\N	grua_5bb134795050402cb2676da13b23880c.jpg			4.90622	-74.02807	salida	2025-09-19 22:14:22.70436
237	25	72	140	6	63	2025-09-19 22:14:50.889912	2025-09-19	17:14:00	\N	\N	\N	\N	grua_a36856c496ca49b2b5014c09f55167d2.jpg			\N	\N	salida	2025-09-19 22:14:50.889924
238	25	65	140	6	63	2025-09-19 22:15:15.520254	2025-09-19	17:14:00	\N	\N	\N	\N	grua_199aac6d64c94ed08a625ee61742f6c5.jpg			4.906226	-74.028066	salida	2025-09-19 22:15:15.520262
239	39	95	136	6	63	2025-09-19 22:58:19.939955	2025-09-19	17:57:00	\N	\N	\N	\N	grua_0704eee3779e4f11a2b0d085b7e8e9ce.jpg			4.765808	-74.16353	salida	2025-09-19 22:58:19.939964
240	28	70	135	6	63	2025-09-19 23:07:07.472468	2025-09-19	18:06:00	23128	592	kilometraje_6669673128a2458fb16b00d8cd592408.jpg	horometro_73dfe15edcfe407fb40ea1d677f92e70.jpg	grua_a6be098921f4490f982f6c44f237b85a.jpg			4.764908	-74.164322	salida	2025-09-19 23:07:07.472479
241	28	71	136	6	63	2025-09-19 23:07:35.379824	2025-09-19	18:07:00	\N	\N	\N	\N	grua_fc5f8a78197f480d85140519b56b8a09.jpg			4.765814	-74.163405	salida	2025-09-19 23:07:35.379833
242	31	76	135	11	63	2025-09-20 01:13:58.620591	2025-09-19	20:11:00	91690	30050	kilometraje_24afb59b6a904d8f9a88d15c3dd87f2f.jpg	horometro_2bee3b355d9e4e7dbedc287669dee925.jpg	grua_86f64dfb7a834be8996f3ab379143ac3.jpg			4.685951	-74.050912	salida	2025-09-20 01:13:58.620603
243	31	76	135	14	63	2025-09-20 01:17:00.891035	2025-09-19	20:15:00	91690	30050	kilometraje_f811b3963f7c462abe7484823e8bf6bb.jpg	horometro_420a04e9fc2d43a9bb16f00da059aecc.jpg	grua_8e7233131d59465798ebaa09ecb37030.jpg	Turno nocturno\r\nCon YDN		4.685924	-74.050949	entrada	2025-09-20 01:17:00.891049
244	33	91	135	9	63	2025-09-20 02:51:27.341957	2025-09-19	21:49:00	1934	2139	kilometraje_f2cf8269fe9841ae97678f27e79acb41.jpg	horometro_1b055fa1e4fd4b92bc2aa4bc004c8d5c.jpg	grua_9dfc5441c2d5462da94e3e86ea8484ef.jpg	Sin novedad		4.661214	-74.06177	salida	2025-09-20 02:51:27.341967
245	33	90	136	9	63	2025-09-20 02:53:20.490165	2025-09-19	21:52:00	\N	\N	\N	\N	grua_2b8c560afdf840b79881d82c9aeb90cd.jpg			4.660902	-74.061682	salida	2025-09-20 02:53:20.490174
246	31	76	135	14	63	2025-09-20 07:14:02.74791	2025-09-20	02:13:00	91690	30055	kilometraje_8b7a6e5d5dc84c4eb1e45956d46f444e.jpg	horometro_7d04771b87d34b4aadc04926475b0c73.jpg	grua_bec5e7bd94a4471a8df9434a2b966438.jpg			4.698771	-74.109791	salida	2025-09-20 07:14:02.747922
247	33	87	136	9	63	2025-09-20 10:57:34.697238	2025-09-20	05:56:00	\N	\N	\N	\N	grua_e66fd3f110ea43f1a99518a08a416eb9.jpg			4.661107	-74.061773	entrada	2025-09-20 10:57:34.697248
248	33	88	135	9	63	2025-09-20 10:59:51.38796	2025-09-20	05:58:00	1934	2147	kilometraje_6e15031215f443039faa57ae8ecb97b9.jpg	horometro_d50bcba03e374f2581144beeea4c899a.jpg	grua_abe1a6f283164868bf1983b170439ea6.jpg			4.660966	-74.061699	entrada	2025-09-20 10:59:51.387972
249	32	86	135	9	63	2025-09-20 11:36:49.040325	2025-09-20	06:34:00	90870	29499	kilometraje_ab739868bd36450bbeb9ec0a72bac692.jpg	horometro_7824995055934b9bb0aa64e9f5b52e9b.jpg	grua_5642b253a2ab47c19cfe55477f323cf8.jpg	Ingreso turno dia		4.60099	-74.081944	entrada	2025-09-20 11:36:49.040337
250	36	82	136	10	63	2025-09-20 11:52:02.339874	2025-09-20	06:51:00	\N	\N	\N	\N	grua_720a22237a7b44b0919b663b30e14bfc.jpg			4.565939	-74.095007	entrada	2025-09-20 11:52:02.339887
251	35	79	135	10	63	2025-09-20 11:53:56.011141	2025-09-20	06:48:00	71420	11968	kilometraje_dfa51fef1eac42129005312e9bfe0dd6.jpg	horometro_1d7bcd527ea34944b18dde7a8202645a.jpg	grua_b29365c5d390419bb21dd11f84cc0aec.jpg			4.56551	-74.095218	entrada	2025-09-20 11:53:56.011154
252	35	80	136	10	63	2025-09-20 11:58:53.042925	2025-09-20	06:58:00	\N	\N	\N	\N	grua_03bd4e30de9948bf965a5e0ded403680.jpg			4.565362	-74.095512	entrada	2025-09-20 11:58:53.042936
253	32	83	136	9	63	2025-09-20 12:04:44.619371	2025-09-20	07:04:00	\N	\N	\N	\N	grua_dba51fe563dc4f018855bf55c7ba78c9.jpg			4.600699	-74.081666	entrada	2025-09-20 12:04:44.619381
254	37	84	135	9	63	2025-09-20 12:07:48.160803	2025-09-20	07:04:00	23453	2014	kilometraje_7864af696e794d6784d5beb908da9bbe.jpg	horometro_146796c93f614fc294ca8e4073a48eca.jpg	grua_6cb9078bbd4244d694a4b185bf4d63e9.jpg			4.596787	-74.113715	entrada	2025-09-20 12:07:48.160815
255	37	85	136	9	63	2025-09-20 12:10:11.792129	2025-09-20	07:09:00	\N	\N	\N	\N	grua_45930ecea5f641acaccb2bf724f0daa9.jpg			4.596878	-74.114214	entrada	2025-09-20 12:10:11.792138
256	36	81	135	10	63	2025-09-20 12:41:45.305351	2025-09-20	07:40:00	23601	8931	kilometraje_9193b7c6600b49be9de6ac9bdcf8d2d4.jpg	horometro_89f82df195a74ea197fca1cad6c5315b.jpg	grua_b9e7275975b242e8a1a979c7199bbb3d.jpg			4.565895	-74.096269	entrada	2025-09-20 12:41:45.305361
257	38	93	136	9	63	2025-09-20 12:45:31.457078	2025-09-20	07:44:00	\N	\N	\N	\N	grua_1850e11ff4eb4f32a6afe75d99ecc62a.jpg	El tema de parqueo nos demoró la llegada 		4.610431	-74.075418	entrada	2025-09-20 12:45:31.457096
258	38	92	135	9	63	2025-09-20 12:50:45.571094	2025-09-20	07:48:00	6064.8	6064.8	kilometraje_2aae7563ca194f52bf5b9d0609897b1e.jpg	horometro_72b2291905754a7e813f60b7bc35f27d.jpg	grua_d270495b6dfb4218972e7d84a56ea869.jpg			4.61019	-74.075427	entrada	2025-09-20 12:50:45.571107
259	28	70	135	6	63	2025-09-20 13:02:16.563535	2025-09-20	08:00:00	23128	592	kilometraje_81d32b40c7704d4585f7b17a24b0b7eb.jpg	horometro_e3257b27937d4225badf616649f29c32.jpg	grua_a92135efe6444af9924e969207a970d5.jpg			4.765873	-74.163463	entrada	2025-09-20 13:02:16.563547
260	39	95	136	6	63	2025-09-20 13:05:53.098946	2025-09-20	08:04:00	\N	\N	\N	\N	grua_5a0c198dcbda4430b2bb64f6f82d5d27.jpg			4.765762	-74.163647	entrada	2025-09-20 13:05:53.098956
261	39	94	135	6	63	2025-09-20 13:06:21.73921	2025-09-20	08:04:00	42903	3748	kilometraje_e33311bf28d94b589289ec956e5f5dc3.jpg	horometro_2c666df6dae94efd9aa5171d3445895b.jpg	grua_375bebc1653d4490856816a60029d8e7.jpg			4.756757	-74.147275	entrada	2025-09-20 13:06:21.739221
262	39	94	135	6	63	2025-09-20 13:06:25.585075	2025-09-20	08:04:00	42903	3748	kilometraje_cf29a13efe784a54b8481b6d75f8925c.jpg	horometro_c01afb37584f46c882241fb00943b114.jpg	grua_9ee3576c091d4a6c9490e2c4dde9641a.jpg			4.756757	-74.147275	entrada	2025-09-20 13:06:25.585088
263	28	70	135	6	63	2025-09-20 17:00:17.251743	2025-09-20	12:00:00	23128	592	kilometraje_dfeb6021a9e241df80955f89d404a77d.jpg	horometro_0c48abee874542839188480d01d387c7.jpg	grua_c91bd137b27346d5b593f7334f52b03a.jpg			4.765764	-74.163444	salida	2025-09-20 17:00:17.251754
264	39	95	136	6	63	2025-09-20 17:02:45.898251	2025-09-20	12:01:00	\N	\N	\N	\N	grua_a3b1b19361444ef1ab4f365169ab2f8a.jpg	Prueba 		4.764903	-74.164322	salida	2025-09-20 17:02:45.898259
265	39	94	135	6	63	2025-09-20 17:04:12.542337	2025-09-20	12:02:00	42903	3748	kilometraje_a891467507474d02a0ea0f8584615ab1.jpg	horometro_75ba85ffe2144f99b0bb1af2134949a1.jpg	grua_c827b8242dcb41f1ba303807e1dd4be5.jpg			4.756757	-74.165355	salida	2025-09-20 17:04:12.542346
266	35	80	136	10	63	2025-09-20 17:31:44.633695	2025-09-20	12:31:00	\N	\N	\N	\N	grua_9bb857c071cf49e09044a529229d4e22.jpg			4.565534	-74.094977	salida	2025-09-20 17:31:44.633704
267	35	79	135	10	63	2025-09-20 17:31:57.014817	2025-09-20	12:30:00	71420	11968	kilometraje_4f8c948c574c4314986df3d31e536f84.jpg	horometro_7423b0aa97cc43458bd98728c8001767.jpg	grua_0d645d86842147e3a64d5652882ac846.jpg			4.565396	-74.095038	salida	2025-09-20 17:31:57.014831
268	36	82	136	10	63	2025-09-20 17:32:03.693814	2025-09-20	12:31:00	\N	\N	\N	\N	grua_ed67ee5532374a88bdf8d1209b7ee41b.jpg			4.56537	-74.094978	salida	2025-09-20 17:32:03.693824
269	36	81	135	10	63	2025-09-20 17:32:43.636936	2025-09-20	12:31:00	23601	8932	kilometraje_b760e261ceff4d96ace33a209df718c1.jpg	horometro_344ea7949fc3468db557871acad9a8d7.jpg	grua_0a3922a73fd6442b9160283e91bad97b.jpg			4.565364	-74.094876	salida	2025-09-20 17:32:43.636945
270	37	85	136	9	63	2025-09-20 17:39:19.760199	2025-09-20	12:38:00	\N	\N	\N	\N	grua_45c88e0449184e4dbe71952405a19e1f.jpg			4.598134	-74.084087	salida	2025-09-20 17:39:19.760208
271	37	84	135	9	63	2025-09-20 17:41:33.687427	2025-09-20	12:36:00	23475	2018	kilometraje_825fe575025e4e38967bd26565563291.jpg	horometro_f5f7887ba5e346fb9e3020e4e87e35a1.jpg	grua_06e515619808425bae9b180ddcd9f793.jpg			4.597735	-74.08415	salida	2025-09-20 17:41:33.68744
272	33	90	136	9	63	2025-09-20 18:58:50.913371	2025-09-20	13:58:00	\N	\N	\N	\N	grua_7959d14a520546359441f75f7e24af6b.jpg			4.661087	-74.061721	entrada	2025-09-20 18:58:50.913384
273	33	91	135	9	63	2025-09-20 19:04:41.722408	2025-09-20	14:02:00	1934	2149	kilometraje_711785bf7518460fa4e9da80c88e1901.jpg	horometro_52314017d28e404abd94dbc617d49a69.jpg	grua_50b3a8620e3240dfa8d7286f49fd8f83.jpg	Sin novedad		4.661075	-74.061819	entrada	2025-09-20 19:04:41.722422
274	33	87	136	9	63	2025-09-20 19:14:23.30559	2025-09-20	14:13:00	\N	\N	\N	\N	grua_0913e5e50d2d434da81072879567ccce.jpg			4.660975	-74.061673	salida	2025-09-20 19:14:23.305599
275	33	88	135	9	63	2025-09-20 19:14:56.229438	2025-09-20	14:13:00	1934	2149	kilometraje_96e8334ce0fe44ea990933bf50cadfc2.jpg	horometro_8fde55440cd44a1eb293940030034842.jpg	grua_f92d3e8210654812a40a0b48a0f7e305.jpg	Equipo operativo 		4.661438	-74.061857	salida	2025-09-20 19:14:56.229447
276	32	83	136	9	63	2025-09-20 21:57:32.130723	2025-09-20	16:57:00	\N	\N	\N	\N	grua_36e2ec4cab1e477ab6ee9bc5e36441e5.jpg			4.601091	-74.081658	salida	2025-09-20 21:57:32.130734
277	32	86	135	9	63	2025-09-20 21:59:09.393884	2025-09-20	16:57:00	90871	29500	kilometraje_dd8663f58abb42fb825d429c269efb42.jpg	horometro_f102b47e47664c78ba383718695353dd.jpg	grua_897059d499cd4e588785e8241fad6798.jpg	Registro salida		4.60091	-74.081758	salida	2025-09-20 21:59:09.393895
278	38	93	136	9	63	2025-09-20 23:27:57.952318	2025-09-20	18:27:00	\N	\N	\N	\N	grua_fea08ff40aa64e28afdcd0b5cc76e11e.jpg			4.650619	-74.064503	salida	2025-09-20 23:27:57.952328
279	38	92	135	9	63	2025-09-20 23:29:10.278449	2025-09-20	18:26:00	6124.3	6124.3	kilometraje_8d4122df3bfa4d5fb66517f091341b64.jpg	horometro_2a3f3fdb07014b21b9d7225f7dfad3d6.jpg	grua_250ef988056e49fc992a4601e781527f.jpg			4.650488	-74.064573	salida	2025-09-20 23:29:10.27846
280	33	90	136	9	63	2025-09-21 02:45:28.298218	2025-09-20	21:44:00	\N	\N	\N	\N	grua_f1ba3ae516de4f7392736efb52e0b1cc.jpg			4.660893	-74.061785	salida	2025-09-21 02:45:28.298229
281	33	91	135	9	63	2025-09-21 02:53:29.096384	2025-09-20	21:48:00	1934	2151	kilometraje_6eccc9601d0f405da6c691a100506c6c.jpg	horometro_a9c9ae43e262479aa647362e3a0ea59c.jpg	grua_23622532a974450dbed2e01778ab35e3.jpg	Sin novedad 		4.661162	-74.061643	salida	2025-09-21 02:53:29.096394
282	33	87	136	9	63	2025-09-21 10:53:27.67749	2025-09-21	05:52:00	\N	\N	\N	\N	grua_7af9f5b80d594123867b50533974b420.jpg			4.66078	-74.061491	entrada	2025-09-21 10:53:27.677501
283	33	88	135	9	63	2025-09-21 10:55:38.295722	2025-09-21	05:53:00	1934	2154	kilometraje_0b6dbc7873754344a2162bfd3f7c254c.jpg	horometro_c04b51d9547d4a349fd581bbfcd945e1.jpg	grua_3a4119cdc16547b29ad58c7a587f80bd.jpg			4.661052	-74.061544	entrada	2025-09-21 10:55:38.295735
284	32	86	135	9	63	2025-09-21 11:35:32.744975	2025-09-21	06:33:00	90872	29505	kilometraje_3611366f120047c8aa3250817699f363.jpg	horometro_2f3619248e72463eb34ba650b9ac2ffd.jpg	grua_e2d32e7da156492782d3543eee50bde0.jpg	Registro de entrada		4.601068	-74.081775	entrada	2025-09-21 11:35:32.744988
285	32	83	136	9	63	2025-09-21 11:57:25.432871	2025-09-21	06:57:00	\N	\N	\N	\N	grua_ae8c3c6bded7445e856892887aaecab1.jpg			4.600502	-74.082079	entrada	2025-09-21 11:57:25.432882
286	28	71	136	6	63	2025-09-21 13:54:48.467849	2025-09-21	08:54:00	\N	\N	\N	\N	grua_d49e8eba5d60446b9bfbfaf3e796b18d.jpg			4.76584	-74.163443	entrada	2025-09-21 13:54:48.467861
287	33	88	135	9	63	2025-09-21 18:53:11.380298	2025-09-21	13:52:00	1934	2156	kilometraje_93edba20b3e048a18e47e9f665c7bc7c.jpg	horometro_33b28d60ca384304a5b3e9ee3fd917dd.jpg	grua_5c2bac58844644beadda0f5d7fb82ba7.jpg			4.661186	-74.06173	salida	2025-09-21 18:53:11.38031
288	33	90	136	9	63	2025-09-21 18:53:33.435901	2025-09-21	13:52:00	\N	\N	\N	\N	grua_ccba1741d4704fe58294bd913d123a41.jpg			4.502333	-74.112679	entrada	2025-09-21 18:53:33.435913
289	33	87	136	9	63	2025-09-21 18:54:00.262412	2025-09-21	13:53:00	\N	\N	\N	\N	grua_1d3050640fad4f5fb83945f6827c4573.jpg			4.661029	-74.061739	salida	2025-09-21 18:54:00.262421
290	33	91	135	9	63	2025-09-21 18:54:43.042029	2025-09-21	13:53:00	1934	2156	kilometraje_763e88bd28cc425487c28568fc9cca7a.jpg	horometro_3acbf2574409409ab62b34faa0e4e661.jpg	grua_d8e19bd6dead484c85df449490507366.jpg			4.661257	-74.061729	entrada	2025-09-21 18:54:43.042042
291	32	83	136	9	63	2025-09-21 19:33:06.60644	2025-09-21	14:32:00	\N	\N	\N	\N	grua_a5f74a31f55548b888131807495ef677.jpg			4.599886	-74.082656	salida	2025-09-21 19:33:06.60645
292	28	71	136	6	63	2025-09-21 20:52:52.671387	2025-09-21	15:52:00	\N	\N	\N	\N	grua_dc749aea4a4c4508badcf036651f0716.jpg			4.569771	-74.15976	salida	2025-09-21 20:52:52.671397
293	33	91	135	9	63	2025-09-22 02:44:45.23474	2025-09-21	21:43:00	1934	2160	kilometraje_153ace8aeba040a5b8ef25ef4d977eeb.jpg	horometro_5cb05766e6c647309c16a7968a4c9db7.jpg	grua_c514611613c14c4089e4f5804a239965.jpg			4.66101	-74.061629	salida	2025-09-22 02:44:45.234757
294	33	90	136	9	63	2025-09-22 02:46:28.793035	2025-09-21	21:45:00	\N	\N	\N	\N	grua_6022d76e7fdc41a38d8e1aa8b7deeff8.jpg			4.6611	-74.06103	salida	2025-09-22 02:46:28.793048
296	33	91	135	9	63	2025-09-22 11:00:58.769884	2025-09-22	06:00:00	1934	2166	kilometraje_5cb13e2e69344808a80b067f0e033f9e.jpg	horometro_d515dfefad3d4e8da1b880aeaa6c19cd.jpg	grua_93b58b4475e94b158734a63e043d3ce5.jpg			4.661068	-74.061797	entrada	2025-09-22 11:00:58.769897
297	35	79	135	10	63	2025-09-22 11:48:47.685407	2025-09-22	06:47:00	71420	11968	kilometraje_d5f769573f8c431c8378e96a7df50e03.jpg	horometro_a961578e487f4876a5b1a704724e7342.jpg	grua_9fe1792d5baa4d1db27f73878c6f956d.jpg			4.565552	-74.095103	entrada	2025-09-22 11:48:47.685422
298	36	82	136	10	63	2025-09-22 11:53:34.830629	2025-09-22	06:52:00	\N	\N	\N	\N	grua_5a110266ee9649279a0643c2f0a6ca40.jpg			4.566048	-74.09514	entrada	2025-09-22 11:53:34.830641
299	35	80	136	10	63	2025-09-22 12:00:30.413203	2025-09-22	06:59:00	\N	\N	\N	\N	grua_183b969876234cd8bd2b13bd70fd0358.jpg			4.565558	-74.095006	entrada	2025-09-22 12:00:30.413217
300	36	81	135	10	63	2025-09-22 12:12:03.402338	2025-09-22	07:10:00	23601	8932	kilometraje_694b398d24b04578ae3de7293a6402e3.jpg	horometro_bc6faef0fdac48829dd204b41d0dd441.jpg	grua_8e2bb2c185bc497a8d72926247345ecb.jpg			4.565767	-74.095662	entrada	2025-09-22 12:12:03.402349
301	25	72	140	6	63	2025-09-22 12:40:17.978342	2025-09-22	07:39:00	\N	\N	\N	\N	grua_efb0db6aca7946d6acd573b41f37c193.jpg			\N	\N	entrada	2025-09-22 12:40:17.978355
302	25	67	140	9	63	2025-09-22 12:45:00.477249	2025-09-22	07:44:00	\N	\N	\N	\N	grua_339e4c53dc284c868a13ac5ab692dbd9.jpg			4.906237	-74.028072	entrada	2025-09-22 12:45:00.477261
303	25	65	140	6	63	2025-09-22 12:45:30.627208	2025-09-22	07:44:00	\N	\N	\N	\N	grua_4301fbfdfac14b32ac1c1f092c3ad44f.jpg			4.906231	-74.028065	entrada	2025-09-22 12:45:30.627219
304	25	66	140	6	63	2025-09-22 12:53:22.893753	2025-09-22	07:52:00	\N	\N	\N	\N	grua_61bccc0b5dea42d2b3c2a23c3f674815.jpg			4.906225	-74.028088	entrada	2025-09-22 12:53:22.893763
305	39	95	136	6	63	2025-09-22 13:05:12.083997	2025-09-22	08:04:00	\N	\N	\N	\N	grua_470b3ceec5fa44e2ac73bd0c749dfe4e.jpg	Prueba 		4.76579	-74.163611	entrada	2025-09-22 13:05:12.084005
306	28	70	135	6	63	2025-09-22 13:06:20.834722	2025-09-22	08:05:00	23128	592	kilometraje_17a54effd1a94a628e28a4f0ce7a097b.jpg	horometro_4cf9980406644721b775540bd1c83721.jpg	grua_761b4f1c79254d29aa40ea4b9d8fd249.jpg			4.765905	-74.163487	entrada	2025-09-22 13:06:20.834735
307	39	94	135	6	63	2025-09-22 13:11:38.779549	2025-09-22	08:10:00	42903	3748	kilometraje_0d82ad4cdac242d4b5d944aadbcfb634.jpg	horometro_65c9c2a7e01e4f3f99a04abdc5058801.jpg	grua_514b12c3fc0043d287fc77cae6e1cc2c.jpg			\N	\N	entrada	2025-09-22 13:11:38.779579
308	25	68	138	6	63	2025-09-22 13:26:49.509712	2025-09-19	08:06:00	\N	\N	\N	\N	grua_e915a8a89d474c7f9a43d8d0b6d03a15.jpg			4.906261	-74.028167	salida	2025-09-22 13:26:49.509721
309	25	68	138	6	63	2025-09-22 13:28:28.762339	2025-09-22	08:27:00	\N	\N	\N	\N	grua_93078fd87e654c63ae8595a94b38fd6c.jpg			4.906337	-74.028192	entrada	2025-09-22 13:28:28.76235
310	29	77	136	10	63	2025-09-22 13:45:48.142031	2025-09-22	08:44:00	\N	\N	\N	\N	grua_422567d96b8d42fe84a967d2ee69c1c2.jpg			4.748175	-74.15544	entrada	2025-09-22 13:45:48.142042
311	29	78	135	10	63	2025-09-22 13:48:33.430701	2025-09-22	08:46:00	130930	14076	kilometraje_51b77aa3271942a3aaea13e79dd986ee.jpg	horometro_b49cac208a364675b5af33c0384b9352.jpg	grua_4b30730141c44d7cb3fd9654e752559b.jpg			4.747219	-74.156402	entrada	2025-09-22 13:48:33.430713
\.


--
-- Data for Name: tipo_equipos; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, tipo_documento, documento, nombre, email, celular, contrasena_hash, fecha_creacion, ultimo_login, estado, perfil_usuario, fecha_inactividad) FROM stdin;
74	CC	2976439	MOISES LEONARDO CONTRERAS TORRES	codytor566@gmail.com	3206405810	pbkdf2:sha256:600000$9ZF3Vb7wfLDjLNUv$1a4b05b2297d2e15d042cfc977bc05ef857d8a2846e2160af514a7ab1ca93414	2025-09-12 20:24:34.747192	\N	activo	empleado	\N
77	CC	19752558	JOHANDRIS CRISTO CUADRADO 	johandris0780@gmail.com	3012465970	pbkdf2:sha256:600000$3twnCFTxTaKOJTvO$9c570339375ad0512bd008a862f1b49d7f8d1f86d84e151b6717f1ca141cc976	2025-09-12 22:29:43.501304	2025-09-22 13:44:51.670303	activo	empleado	\N
78	CC	80183667	GILBERTO HERNANDO RAMÍREZ CHAPARRO	gilbertoramirez1302@gmail.conm	3122566514	pbkdf2:sha256:600000$HMH5wuVfG4CdTHrB$a56858f73dec7e71bd87fa1cbf0e71ec56b27346950c83d60d9a5aa6e025ada4	2025-09-12 23:08:52.441337	2025-09-22 13:45:52.147537	activo	empleado	\N
71	CC	1001057822	CRISTIAN FERNÁNDEZ PERERZ	CRISPINACIO@GMAIL.COM	3059337083	pbkdf2:sha256:600000$deqkZuImpEL3ZBYi$ae6bc74f5fb40bc76cf5687a9751d9598e5d3a9fc35a21b1c6731eb96deeec64	2025-09-12 11:55:06.894931	2025-09-21 20:47:51.711816	activo	empleado	\N
83	CC	1003474785	ilvar stiven pinilla	pinilla.2994@gmail.com	3183175135	pbkdf2:sha256:600000$SMiLv0l6s9asaytt$f5109415c5b8d956d5670239e8bd82788b3904b04a5d1195e255dfa37cc24aef	2025-09-18 15:05:16.663617	2025-09-21 19:32:11.342993	activo	empleado	\N
72	CC	1070021502	JUAN DANIEL VENEGAS SARMIENTO	VENEGASJ1003@GMAIL.COM	3123176921	pbkdf2:sha256:600000$9WWd3QTu6f7y3XQv$a6cb9ef7f7e70b75a117beec0369409f8aff54e3dba77bf440dcab28c9f85bce	2025-09-12 13:17:42.514289	2025-09-22 12:39:48.258602	activo	empleado	\N
75	CC	1030552450	BILSE RICARDO PÉREZ NIÑO	Ricardo-Pérez-88@hotmail.com	3118257216	pbkdf2:sha256:600000$9zVxfRVyCTdPTOYa$80c832796815398676a32df7584e798e2340164412c3b27c5512f37db34c5e07	2025-09-12 21:59:49.198812	2025-09-19 21:14:20.473182	activo	empleado	\N
63	CC	1070005410	Felipe Andrés Camargo Lamprea	Felo123@me.com	3112151529	pbkdf2:sha256:600000$I0PRckP3nsbumNIt$add86400f163c3f76cf8b6c1cebb7080cf0eef6793bf6351ac30042185b04652	2025-09-11 10:59:32.554116	2025-09-11 11:17:18.025837	activo	empleado	\N
81	CC	1030571173	Deyber Rafael franco peña	deiberrfp@hotmail.com	3208037856	pbkdf2:sha256:600000$E4WYhcQOMIQl4tl2$a1916e56967f403647fec29078fffd2d5afb4bb680e03ffadca6f0a46e6ee03b	2025-09-18 12:11:54.332903	2025-09-22 12:10:47.625765	activo	empleado	\N
69	CC	11187990	JHONS FREDDY ARIZA ARIZA 	arizajhons1234@gmail.com	3212409354	pbkdf2:sha256:600000$7SvWk9CgHXsa9MWN$a961d1dcd9596fd12427adc8da6819c902f8a0f25e16190d791fbb2bd2e5646d	2025-09-11 21:28:31.50485	2025-09-18 15:50:43.409602	activo	empleado	\N
76	CC	1020732045	ANDRES FELIPE LOPEZ MENDOZA 	Andresfelipelopezmendoza70@gmail.com	3104813420	pbkdf2:sha256:600000$B9f9SUoSfKuBMtWW$f67b5f68738fe8081c596b55ea6b17edadff5915bbc8654ab01843656443d613	2025-09-12 22:01:28.877205	2025-09-15 14:53:37.19452	activo	empleado	\N
66	CC	1007405949	micheell Alexandra espinosa contreras	Michelespinosa087@gmail.com	3162359968	pbkdf2:sha256:600000$eTkxKD3PaUu7gxhw$83282f72139fc8e8e26a2fd4bf994a6361825756bb82b27d7d3e6ad0ad9e83f0	2025-09-11 13:47:28.731898	2025-09-22 12:52:55.984538	activo	empleado	\N
65	CC	1072710640	JENNY CAROLINA CASTILLO PIRAZAN	jecaro2016@gmail.com	3143975420	pbkdf2:sha256:600000$bXE8UPtKrEvffcoV$232ea1d015495206645cd1fd055bd78fb728dfdf9eb59b11501308f447f625bd	2025-09-11 13:40:42.057182	2025-09-22 12:44:35.288849	activo	empleado	\N
67	CC	1076646092	Deisy Alejandra Garnica Castillo	alejagarnica000@gmail.com	3024012856	pbkdf2:sha256:600000$MvTxF4sRnH3rdHln$4ecf2dfcc9c1b098a3e671a6191514b4ed9ee9ccb16b1ec019a692440126d7a2	2025-09-11 13:49:40.826566	2025-09-22 12:43:34.589265	activo	empleado	\N
79	CC	1070325406	LUIS ALBERTO HERNÁNDEZ LOPEZ	LUCHO.1109@hotmail.com	3132434463	pbkdf2:sha256:600000$3CWe37wbOdhoug7C$83bd86dabf10f82554da2d87e355cd958e18d87a2c444b04eb84154ea4f95b07	2025-09-18 12:06:00.394826	2025-09-22 11:47:15.791563	activo	empleado	\N
68	CC	1070017822	Paula Bautista Gutierrez	pjbautista96@gmail.com	3185529635	pbkdf2:sha256:600000$Vk6L8mDm8aCEcxO2$4ac617cef500f731ae40051068d019200b21a0b4288be2d9c41cd7f1ad05df21	2025-09-11 13:51:13.347684	2025-09-22 13:27:11.813634	activo	empleado	\N
70	CC	80730825	EDWIN LARA	EDWIN.LARA1892@GMAIL.COM	3108758409	pbkdf2:sha256:600000$d7SxVnEZVVPm7ko6$5c02eb2e36d3bbd65cd27b106a36b028f08b2de92216c6ef0e68faa00210c2a1	2025-09-12 11:45:52.272117	2025-09-22 13:04:36.382046	activo	empleado	\N
73	CC	79493269	JOHN FREDY ABRIL SANDOVAL	JOHNABRIL1969@gmail.com	3103107393	pbkdf2:sha256:600000$AQ1nwbCl1wBkORkw$45d6b1d7138639d8496219dff7a1fcc3271476ca6706da7ddebac39efc1ce78f	2025-09-12 20:22:28.461141	2025-09-12 23:58:14.748916	activo	empleado	\N
82	CC	1016013294	Víctor Alfonso Rodríguez durante 	victoria.0907@gmail.com	3114718063	pbkdf2:sha256:600000$Q3pZFOJaBHhNGQgK$31bfe5d111fad219d82f7f6316575011c2aa8eea8746a2550db7c458cf35903d	2025-09-18 12:13:55.468069	2025-09-22 11:52:50.180751	activo	empleado	\N
62	CC	admin	Administrador	admin@gruascranes.com	3001234567	pbkdf2:sha256:600000$bRvUQwL60sYkfQb9$251051de5536a9b6d960ce3d81ee6b12954118427b0e1db5d2c8160d54543b36	2025-09-11 06:26:07.814893	2025-09-22 13:58:09.849604	activo	administrador	\N
84	CC	1032491945	juan Daniel García Guzmán 	juandanielgarcia320@gmail.com	3004193365	pbkdf2:sha256:600000$bRZBx76EYAh9j80i$7f6172cbd4e38a7ee3ca4f31aadc5618b71363bb2954fc9d61c136636553ddae	2025-09-18 15:07:24.264877	2025-09-18 15:23:34.551251	activo	empleado	\N
87	CC	80165186	GILBER ORLANDO RAMÍREZ WEAVER	fliaramirezlatorre@gmail.com	3118048413	pbkdf2:sha256:600000$eWkoowmKNt7FLkav$e3cfa0540551042a2c3c709f9e7c1e2b0d3a99bfef0d7c8ae8c0385b5b8f255c	2025-09-18 17:23:23.516125	2025-09-18 17:33:04.840041	activo	empleado	\N
85	CC	80114982	nestor David peña rodriguez	David2013059@gmail.com	3122245431	pbkdf2:sha256:600000$xyGkOw2Yu1s9kcTh$dc26acf6c93d2516ccfad339a1329a3664637600326c814929217b7b49834bde	2025-09-18 15:11:46.86388	2025-09-18 15:42:42.717459	activo	empleado	\N
88	CC	1060266509	jhon alexander González restrepo	gonzalezrestrepoj785@gimail.com	3005279469	pbkdf2:sha256:600000$CPRmqyrbZfBNH6Ol$62a524888f4e961cb85baaa4bb5282f4b8cb8aa85ce1835b96a18f16075f5d69	2025-09-18 17:29:26.956476	2025-09-18 17:36:40.228496	activo	empleado	\N
89	CC	1070012680	Mauricio Bello	edgarmbellol@gmail.com	3057499964	pbkdf2:sha256:600000$cb9pzQUYy8DJlF5p$53ffb08472e809ea6afdd08887ec3836465e6d8591317d8e51f1a192641aaa69	2025-09-18 17:53:41.289415	2025-09-18 19:35:40.6953	activo	empleado	\N
80	CC	1002153318	Darwin Jesús Cervantes de la hoz	darwin.j19@hotmail.com	3232844361	pbkdf2:sha256:600000$ooEWJiHFhu9QNxnm$cdc37f0ba155b753118c146cac643feef50c1cc634ced9aa97ec38dbea904eea	2025-09-18 12:09:24.865033	2025-09-22 11:59:39.407322	activo	empleado	\N
64	CC	2968990	HECTOR EDUARDO QUINTERO LAMPREA	e.quintero.lamprea@gmail.com	3004143931	pbkdf2:sha256:600000$6CjkABT3qaMQIWWQ$662251903fc107755fa04ee4409fa1620a2837f200ab78582df897fe00897e67	2025-09-11 11:37:36.032711	2025-09-20 01:22:42.791474	activo	empleado	\N
90	CC	1024503839	Weymar Alexander Marín Peña	alexandermarin1627@gmail.com	3208229849	pbkdf2:sha256:600000$UnGkUhJldBjEeYd0$60dbd9befd5416f49f1b387b71bb0cdcf42561971eddf44045ecbc0f30ee7863	2025-09-18 19:24:53.507462	2025-09-18 19:38:50.418499	activo	empleado	\N
91	CC	1110523976	Jhonny Javier Bonilla Angel	jhonnyangel.28@hotmail.com	3132319241	pbkdf2:sha256:600000$V307XAvcUObbMZIZ$f003b5607616b3f0a8ad3392ca8bc1124a5e913942033f3a6665610fdcb095f3	2025-09-18 19:40:35.328131	2025-09-18 19:43:52.515134	activo	empleado	\N
86	CC	1079033813	Leonel irrevocable urrego	Leonelu1992@gmail.com	3165767163	pbkdf2:sha256:600000$XymrsyQimL9vumfT$570af0bd919226cb8094d761673a2cc6cab3bf96ea94ad3058637a2bb14921a4	2025-09-18 15:13:52.023453	2025-09-21 19:44:38.970184	activo	empleado	\N
93	CC	1003824189	Heder Stiven Villamil Sanchez	stivenvillamil55@gmail.com	3227686783	pbkdf2:sha256:600000$8pwQDLdHD2kVPHqv$02d73a6d2734e552eaffdfc370fab0804ea7b37b51734f703164a55affc0df67	2025-09-18 20:55:28.777183	2025-09-18 20:56:05.358302	activo	empleado	\N
92	CC	80204166	Francisco Jesús Peña	fjpellargo@gmail.com	3044508958	pbkdf2:sha256:600000$Jz47DgpNNAYS7Jpz$fbe9458ac78e60cf1fb0e40d0e8523cfcea0f1eb692a70125e2f91df044d989c	2025-09-18 20:53:51.801852	2025-09-18 21:02:08.822081	activo	empleado	\N
95	CC	13521038	Luis Gabriel Buitrago Rincon	luisgabrielbuitragorincon@gmail.com	3214279485	pbkdf2:sha256:600000$Ji2mLs0806d4PS3W$582c1cff5e457c7586848bf8660749df6c88378200bdcaa19319d0ac95867113	2025-09-19 17:45:31.84741	2025-09-22 13:01:51.250657	activo	empleado	\N
94	CC	1122128417	Rafael Olaya Linares 	rafaelolaya112@gmail.com	3245187849	pbkdf2:sha256:600000$senfVKymbTu6amkK$6e959e199d8b4ca9d66da09121982d5274fd2f5892a5941de8b29d89b0732fa7	2025-09-19 17:43:16.567229	2025-09-22 13:09:48.392281	activo	empleado	\N
\.


--
-- Name: cargos_IdCargo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."cargos_IdCargo_seq"', 140, true);


--
-- Name: clientes_IdCliente_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."clientes_IdCliente_seq"', 15, true);


--
-- Name: equipos_IdEquipo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."equipos_IdEquipo_seq"', 40, true);


--
-- Name: estado_equipos_IdEstadoEquipo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."estado_equipos_IdEstadoEquipo_seq"', 66, true);


--
-- Name: marcas_IdMarca_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."marcas_IdMarca_seq"', 16, true);


--
-- Name: registro_horas_IdRegistro_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."registro_horas_IdRegistro_seq"', 311, true);


--
-- Name: tipo_equipos_IdTipoEquipo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."tipo_equipos_IdTipoEquipo_seq"', 76, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 95, true);


--
-- Name: cargos cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY ("IdCargo");


--
-- Name: clientes clientes_Nit_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_Nit_key" UNIQUE ("Nit");


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY ("IdCliente");


--
-- Name: equipos equipos_Placa_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_Placa_key" UNIQUE ("Placa");


--
-- Name: equipos equipos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT equipos_pkey PRIMARY KEY ("IdEquipo");


--
-- Name: estado_equipos estado_equipos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estado_equipos
    ADD CONSTRAINT estado_equipos_pkey PRIMARY KEY ("IdEstadoEquipo");


--
-- Name: marcas marcas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY ("IdMarca");


--
-- Name: registro_horas registro_horas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT registro_horas_pkey PRIMARY KEY ("IdRegistro");


--
-- Name: tipo_equipos tipo_equipos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_equipos
    ADD CONSTRAINT tipo_equipos_pkey PRIMARY KEY ("IdTipoEquipo");


--
-- Name: users users_documento_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_documento_key UNIQUE (documento);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: clientes clientes_UsuarioCrea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_UsuarioCrea_fkey" FOREIGN KEY ("UsuarioCrea") REFERENCES public.users(id);


--
-- Name: clientes clientes_UsuarioInactiva_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT "clientes_UsuarioInactiva_fkey" FOREIGN KEY ("UsuarioInactiva") REFERENCES public.users(id);


--
-- Name: equipos equipos_IdEstadoEquipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_IdEstadoEquipo_fkey" FOREIGN KEY ("IdEstadoEquipo") REFERENCES public.estado_equipos("IdEstadoEquipo");


--
-- Name: equipos equipos_IdMarca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_IdMarca_fkey" FOREIGN KEY ("IdMarca") REFERENCES public.marcas("IdMarca");


--
-- Name: equipos equipos_IdTipoEquipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_IdTipoEquipo_fkey" FOREIGN KEY ("IdTipoEquipo") REFERENCES public.tipo_equipos("IdTipoEquipo");


--
-- Name: equipos equipos_UsuarioCreacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_UsuarioCreacion_fkey" FOREIGN KEY ("UsuarioCreacion") REFERENCES public.users(id);


--
-- Name: equipos equipos_UsuarioInactivacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT "equipos_UsuarioInactivacion_fkey" FOREIGN KEY ("UsuarioInactivacion") REFERENCES public.users(id);


--
-- Name: registro_horas registro_horas_IdCargo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdCargo_fkey" FOREIGN KEY ("IdCargo") REFERENCES public.cargos("IdCargo");


--
-- Name: registro_horas registro_horas_IdCliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdCliente_fkey" FOREIGN KEY ("IdCliente") REFERENCES public.clientes("IdCliente");


--
-- Name: registro_horas registro_horas_IdEmpleado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdEmpleado_fkey" FOREIGN KEY ("IdEmpleado") REFERENCES public.users(id);


--
-- Name: registro_horas registro_horas_IdEquipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdEquipo_fkey" FOREIGN KEY ("IdEquipo") REFERENCES public.equipos("IdEquipo");


--
-- Name: registro_horas registro_horas_IdEstadoEquipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registro_horas
    ADD CONSTRAINT "registro_horas_IdEstadoEquipo_fkey" FOREIGN KEY ("IdEstadoEquipo") REFERENCES public.estado_equipos("IdEstadoEquipo");


--
-- PostgreSQL database dump complete
--

\unrestrict MwKSbw2vIYdgUfGVnrVIPfhBmLo3Q67UQu7GdHZPkYGuxGrttBoLMfaW3UPJBgv

