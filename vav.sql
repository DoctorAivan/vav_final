--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.24
-- Dumped by pg_dump version 15rc2

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: imagen_eliminar(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.imagen_eliminar(in_imagen_id bigint, in_imagen_objeto bigint) RETURNS TABLE(imagen_id bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

        	imagen.imagen_id,

        	imagen.imagen_objeto,

        	imagen.imagen_tipo,

        	imagen.imagen_extension

	    FROM

	        imagen

	    WHERE

	        imagen.imagen_id = in_imagen_id AND

	        imagen.imagen_objeto = in_imagen_objeto

	    LIMIT 1

	    ;

	--	Eliminar Imagen

        DELETE FROM

        	imagen

        WHERE

        	imagen.imagen_id = in_imagen_id AND

        	imagen.imagen_objeto = in_imagen_objeto

        ;

	END $$;


ALTER FUNCTION public.imagen_eliminar(in_imagen_id bigint, in_imagen_objeto bigint) OWNER TO postgres;

--
-- Name: imagen_listado(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.imagen_listado(in_imagen_objeto bigint, in_imagen_tipo character varying) RETURNS TABLE(imagen_id bigint, imagen_orden bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying, imagen_cambio bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

        	imagen.imagen_id,

        	imagen.imagen_orden,

        	imagen.imagen_objeto,

        	imagen.imagen_tipo,

        	imagen.imagen_extension,

        	imagen.imagen_cambio

	    FROM

	        imagen

	    WHERE

	        imagen.imagen_objeto = in_imagen_objeto AND

	        imagen.imagen_tipo = in_imagen_tipo

		ORDER BY

			imagen_orden ASC

	    LIMIT 50

	    ;

	END $$;


ALTER FUNCTION public.imagen_listado(in_imagen_objeto bigint, in_imagen_tipo character varying) OWNER TO postgres;

--
-- Name: imagen_nueva(bigint, bigint, character varying, character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.imagen_nueva(in_imagen_id bigint, in_imagen_objeto bigint, in_imagen_tipo character varying, in_imagen_extension character varying, in_imagen_cambio bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_imagen_id bigint;

			v_orden bigint;

		BEGIN

		-- verificar si email ya esta registrado

		select count(*) from imagen where imagen_objeto = in_imagen_objeto INTO v_orden;

        INSERT INTO imagen

        (

        	imagen_id,

        	imagen_orden,

        	imagen_objeto,

        	imagen_tipo,

        	imagen_extension,

        	imagen_cambio

        )

		VALUES

		(

        	in_imagen_id,

        	v_orden,

        	in_imagen_objeto,

        	in_imagen_tipo,

        	in_imagen_extension,

        	in_imagen_cambio

		);

        RETURN v_imagen_id;

	END $$;


ALTER FUNCTION public.imagen_nueva(in_imagen_id bigint, in_imagen_objeto bigint, in_imagen_tipo character varying, in_imagen_extension character varying, in_imagen_cambio bigint) OWNER TO postgres;

--
-- Name: mesa_activar(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mesa_activar(in_mesa_id bigint, in_mesa_numero character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

		UPDATE

			mesa

		SET

			mesa_estado = 1,

			mesa_numero = in_mesa_numero,

			mesa_cambio = now()

		WHERE mesa_id = in_mesa_id;

		return 1;

	END $$;


ALTER FUNCTION public.mesa_activar(in_mesa_id bigint, in_mesa_numero character varying) OWNER TO postgres;

--
-- Name: mesa_candidato_guardar(bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_candidato_guardar(in_candidato_id bigint, in_candidato_nombres character varying, in_candidato_apellidos character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
	    
		DECLARE
		BEGIN

	--  Actualizar Candidato
		UPDATE
			candidato
			
		SET
			candidato_nombres = in_candidato_nombres,
			candidato_apellidos = in_candidato_apellidos
		
		WHERE
			candidato_id = in_candidato_id
		;
		
		RETURN 1;
		
	END $$;


ALTER FUNCTION public.mesa_candidato_guardar(in_candidato_id bigint, in_candidato_nombres character varying, in_candidato_apellidos character varying) OWNER TO app_vav;

--
-- Name: mesa_candidatos(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_candidatos(in_mesa_id bigint) RETURNS TABLE(voto_id bigint, voto_total smallint, candidato_id bigint, candidato_nombre character varying, candidato_nombres character varying, candidato_apellidos character varying, candidato_lista character varying)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
            voto.voto_id,
            voto.voto_total,
            voto.candidato_id,
            candidato.candidato_nombre,
			candidato.candidato_nombres,
			candidato.candidato_apellidos,
			candidato.candidato_lista
	
	    FROM
            candidato,
            voto
	
	    WHERE
	        candidato.candidato_id  =   voto.candidato_id AND
	        voto.mesa_id = in_mesa_id

		ORDER BY candidato.candidato_orden ASC
	    ;
	
	END $$;


ALTER FUNCTION public.mesa_candidatos(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_candidatos_swich(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_candidatos_swich(in_mesa_id bigint) RETURNS TABLE(voto_id bigint, voto_total smallint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, candidato_genero character varying, candidato_independiente boolean, candidato_lista character varying, partido_codigo character varying, pacto_codigo character varying)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
            voto.voto_id,
            voto.voto_total,
            voto.candidato_id,
			candidato.candidato_nombres,
			candidato.candidato_apellidos,
			candidato.candidato_genero,
			candidato.candidato_independiente,
			candidato.candidato_lista,
			partido.partido_codigo,
			pacto.pacto_nombre
	
	    FROM
			pacto,
			partido,
            candidato,
            voto
	
	    WHERE
			pacto.pacto_id = candidato.pacto_id AND
			partido.partido_id = candidato.partido_id AND
	        candidato.candidato_id = voto.candidato_id AND
	        voto.mesa_id = in_mesa_id

		ORDER BY candidato.candidato_orden ASC
	    ;
	
	END $$;


ALTER FUNCTION public.mesa_candidatos_swich(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_contar_total(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mesa_contar_total() RETURNS TABLE(objetos bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT

			count(mesa_id) AS objetos 

		FROM

			mesa

	    ;

	END $$;


ALTER FUNCTION public.mesa_contar_total() OWNER TO postgres;

--
-- Name: mesa_destacada(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mesa_destacada(in_mesa_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_id bigint;

			v_estado bigint;

		BEGIN

	--	Obtener Estado Actual

		SELECT mesa_destacada FROM mesa WHERE mesa_id = in_mesa_id INTO v_estado;

		IF v_estado = 1 THEN

			UPDATE

				mesa

			SET

				mesa_destacada = 0,

				mesa_cambio = now()

			WHERE mesa_id = in_mesa_id;

			return 0;

		ELSE

			UPDATE

				mesa

			SET

				mesa_destacada = 1,

				mesa_cambio = now()

			WHERE mesa_id = in_mesa_id;

			return 1;

		END IF;

	END $$;


ALTER FUNCTION public.mesa_destacada(in_mesa_id bigint) OWNER TO postgres;

--
-- Name: mesa_detalles(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_detalles(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_orden smallint, mesa_estado smallint, mesa_destacada smallint, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            mesa.mesa_id,

            mesa.usuario_id,

            mesa.mesa_tipo,

            mesa.mesa_zona,

            mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

            mesa.mesa_local,

            mesa.mesa_numero,

            mesa.mesa_orden,

            mesa.mesa_estado,

            mesa.mesa_destacada,

            mesa.mesa_votos_blancos,

            mesa.mesa_votos_nulos,

            mesa.mesa_cambio,

            mesa.mesa_creado,

			usuario.usuario_nombre

	    FROM

			usuario,

	        mesa

	    WHERE

			usuario.usuario_id = mesa.usuario_id AND

	        mesa.mesa_id = in_mesa_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.mesa_detalles(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_detalles_swich(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_detalles_swich(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            mesa.mesa_id,

            mesa.mesa_tipo,

            mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

            mesa.mesa_local,

            mesa.mesa_numero

	    FROM

	        mesa

	    WHERE

	        mesa.mesa_id = in_mesa_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.mesa_detalles_swich(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_editar(bigint, bigint, bigint, character varying, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mesa_editar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_nombre character varying, in_mesa_numero character varying, in_mesa_region character varying, in_mesa_ciudad character varying, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_ar_blanco bigint, in_mesa_voto_ar_nulo bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint, in_mesa_voto_cmcc_blanco bigint, in_mesa_voto_cmcc_nulo bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--	Editar mesa

		UPDATE

			mesa

		SET

			usuario_id	= in_usuario_id,

			mesa_estado = in_mesa_estado,

			mesa_nombre = in_mesa_nombre,

			mesa_numero = in_mesa_numero,

			mesa_region = in_mesa_region,

			mesa_ciudad = in_mesa_ciudad,

			mesa_voto_a = in_mesa_voto_a,

			mesa_voto_r = in_mesa_voto_r,

			mesa_voto_ar_blanco = in_mesa_voto_ar_blanco,

			mesa_voto_ar_nulo = in_mesa_voto_ar_nulo,

			mesa_voto_cm = in_mesa_voto_cm,

			mesa_voto_cc = in_mesa_voto_cc,

			mesa_voto_cmcc_blanco = in_mesa_voto_cmcc_blanco,

			mesa_voto_cmcc_nulo = in_mesa_voto_cmcc_nulo,

			mesa_cambio = now()

		WHERE

			mesa_id = in_mesa_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_editar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_nombre character varying, in_mesa_numero character varying, in_mesa_region character varying, in_mesa_ciudad character varying, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_ar_blanco bigint, in_mesa_voto_ar_nulo bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint, in_mesa_voto_cmcc_blanco bigint, in_mesa_voto_cmcc_nulo bigint) OWNER TO postgres;

--
-- Name: mesa_eliminar(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_eliminar(in_mesa_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--	Eliminar votos

        DELETE FROM voto WHERE voto.mesa_id = in_mesa_id;

	--	Eliminar mesa

        DELETE FROM mesa WHERE mesa.mesa_id = in_mesa_id;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_eliminar(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_guardar(bigint, bigint, bigint, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_guardar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_comuna character varying, in_mesa_local character varying, in_mesa_numero character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--	Editar mesa

		UPDATE

			mesa

		SET

			usuario_id	= in_usuario_id,

			mesa_estado = in_mesa_estado,

			mesa_comuna = in_mesa_comuna,

			mesa_local = in_mesa_local,

			mesa_numero = in_mesa_numero,

			mesa_cambio = now()

		WHERE

			mesa_id = in_mesa_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_guardar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_comuna character varying, in_mesa_local character varying, in_mesa_numero character varying) OWNER TO app_vav;

--
-- Name: mesa_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_listado(in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
		    mesa.mesa_id,
		    mesa.usuario_id,
			mesa.mesa_tipo,
			mesa.mesa_orden,
		    mesa.mesa_destacada,
		    mesa.mesa_estado,
			mesa.mesa_zona,
			mesa.mesa_zona_titulo,
			mesa.mesa_comuna,
		    mesa.mesa_local,
		    mesa.mesa_numero,
		    mesa.mesa_votos_blancos,
		    mesa.mesa_votos_nulos,
			mesa.mesa_cambio,
			mesa.mesa_creado,
			usuario.usuario_nombre
	
	    FROM
	        mesa,
	        usuario
	        
		WHERE
			mesa.usuario_id = usuario.usuario_id
	
	    ORDER BY
			mesa.mesa_estado DESC,
	        mesa.mesa_cambio DESC
	
	    LIMIT in_limit OFFSET in_offset
	    ;
	
	END $$;


ALTER FUNCTION public.mesa_listado(in_limit integer, in_offset integer) OWNER TO app_vav;

--
-- Name: mesa_nuevo(bigint, character varying, bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			in_mesa_id bigint;

		BEGIN

        SELECT nextval('mesa_id_seq') INTO in_mesa_id;

        INSERT INTO mesa

        (

        	mesa_id,

        	usuario_id,

            mesa_tipo,

            mesa_zona,

            mesa_zona_titulo,

			mesa_comuna

        )

		VALUES

		(

			in_mesa_id,

			in_usuario_id,

            in_mesa_tipo,

            in_mesa_zona,

            in_mesa_zona_titulo,

			in_mesa_comuna

		);

    --  AGREGAR CANDIDATOS A LA MESA

        INSERT INTO voto (candidato_id, mesa_id, voto_total) SELECT candidato_id, in_mesa_id, 0 FROM candidato WHERE candidato_tipo = in_mesa_tipo AND candidato_zona = in_mesa_zona;

        RETURN in_mesa_id;

	END $$;


ALTER FUNCTION public.mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) OWNER TO app_vav;

--
-- Name: mesa_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mesa_obtener_datos(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_destacada smallint, mesa_estado smallint, mesa_nombre character varying, mesa_numero character varying, mesa_region character varying, mesa_ciudad character varying, mesa_voto_a smallint, mesa_voto_r smallint, mesa_voto_ar_blanco smallint, mesa_voto_ar_nulo smallint, mesa_voto_cm smallint, mesa_voto_cc smallint, mesa_voto_cmcc_blanco smallint, mesa_voto_cmcc_nulo smallint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    mesa.mesa_id,

		    mesa.usuario_id,

		    mesa.mesa_destacada,

		    mesa.mesa_estado,

		    mesa.mesa_nombre,

		    mesa.mesa_numero,

		    mesa.mesa_region,

		    mesa.mesa_ciudad,

		    mesa.mesa_voto_a,

		    mesa.mesa_voto_r,

		    mesa.mesa_voto_ar_blanco,

		    mesa.mesa_voto_ar_nulo,

		    mesa.mesa_voto_cm,

		    mesa.mesa_voto_cc,

		    mesa.mesa_voto_cmcc_blanco,

		    mesa.mesa_voto_cmcc_nulo

	    FROM

	        mesa

	    WHERE

	        mesa.mesa_id = in_mesa_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.mesa_obtener_datos(in_mesa_id bigint) OWNER TO postgres;

--
-- Name: mesa_usuario_contar_total(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_usuario_contar_total(in_usuario_id bigint) RETURNS TABLE(objetos bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT

			count(mesa_id) AS objetos

		FROM

			mesa

		WHERE

			usuario_id = in_usuario_id

	    ;

	END $$;


ALTER FUNCTION public.mesa_usuario_contar_total(in_usuario_id bigint) OWNER TO app_vav;

--
-- Name: mesa_usuario_listado(bigint, integer, integer); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    mesa.mesa_id,

		    mesa.usuario_id,

			mesa.mesa_tipo,

			mesa.mesa_orden,

		    mesa.mesa_destacada,

		    mesa.mesa_estado,

			mesa.mesa_zona,

			mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

		    mesa.mesa_local,

		    mesa.mesa_numero,

		    mesa.mesa_votos_blancos,

		    mesa.mesa_votos_nulos,

			mesa.mesa_cambio,

			mesa.mesa_creado,

			usuario.usuario_nombre

	    FROM

	        mesa,

	        usuario

		WHERE

			mesa.usuario_id = usuario.usuario_id AND

            mesa.usuario_id = in_usuario_id

	    ORDER BY

	        mesa.mesa_destacada DESC,

			mesa.mesa_estado DESC,

	        mesa.mesa_cambio DESC

	    LIMIT in_limit OFFSET in_offset

	    ;

	END $$;


ALTER FUNCTION public.mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) OWNER TO app_vav;

--
-- Name: mesa_voto(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.mesa_voto(in_mesa_id bigint, in_voto_id bigint, in_voto_total bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

	--  Actualizar Votos

		UPDATE

			voto

		SET

			voto_total = in_voto_total

		WHERE

		    voto.voto_id = in_voto_id

		;

	--  Actualizar Mesa

		UPDATE

			mesa

		SET

			mesa_cambio = now()

		WHERE

			mesa.mesa_id = in_mesa_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_voto(in_mesa_id bigint, in_voto_id bigint, in_voto_total bigint) OWNER TO app_vav;

--
-- Name: objeto_estado(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.objeto_estado(in_objeto_id bigint, in_objeto_tipo character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_id bigint;

			v_estado bigint;

		BEGIN

	--	Validar Tipo de Objeto 

		CASE 

		--	Usuarios

			WHEN in_objeto_tipo = 'USU' THEN

			--	Obtener Estado Actual

				SELECT usuario_estado FROM usuario WHERE usuario_id = in_objeto_id INTO v_estado;

				IF v_estado = 1 THEN

					UPDATE usuario SET usuario_estado = 0 WHERE usuario_id = in_objeto_id;

					return 0;

			    ELSE

					UPDATE usuario SET usuario_estado = 1 WHERE usuario_id = in_objeto_id;

					return 1;

			    END IF;

		--	Mesas

			WHEN in_objeto_tipo = 'MES' THEN

			--	Obtener Estado Actual

				SELECT mesa_estado FROM mesa WHERE mesa_id = in_objeto_id INTO v_estado;

				IF v_estado = 1 THEN

					UPDATE

						mesa

					SET

						mesa_estado = 0,

						mesa_cambio = now()

					WHERE mesa_id = in_objeto_id;

					return 0;

			    ELSE

					UPDATE

						mesa

					SET

						mesa_estado = 1,

						mesa_cambio = now()

					WHERE mesa_id = in_objeto_id;

					return 1;

			    END IF;

			ELSE

		END CASE;

	END $$;


ALTER FUNCTION public.objeto_estado(in_objeto_id bigint, in_objeto_tipo character varying) OWNER TO postgres;

--
-- Name: swich_actual(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.swich_actual() RETURNS TABLE(swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    swich.swich_mesa_1,

		    swich.swich_mesa_2,

		    swich.swich_mesa_3

	    FROM

	        swich

		WHERE

			swich.swich_id = 1

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.swich_actual() OWNER TO postgres;

--
-- Name: swich_editar(bigint, bigint, bigint, bigint, bigint, bigint, bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.swich_editar(in_swich_id bigint, in_swich_modo bigint, in_swich_mesas bigint, in_swich_mesa_1 bigint, in_swich_mesa_2 bigint, in_swich_mesa_3 bigint, in_swich_mesa_4 bigint, in_swich_votos character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

		BEGIN

		UPDATE

			swich

		SET

			swich_mesas = in_swich_mesas,

			swich_modo = in_swich_modo,

			swich_mesa_1 = in_swich_mesa_1,

			swich_mesa_2 = in_swich_mesa_2,

			swich_mesa_3 = in_swich_mesa_3,

			swich_mesa_4 = in_swich_mesa_4,

			swich_votos = in_swich_votos,

			swich_cambio = now()

		WHERE

			swich_id = in_swich_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.swich_editar(in_swich_id bigint, in_swich_modo bigint, in_swich_mesas bigint, in_swich_mesa_1 bigint, in_swich_mesa_2 bigint, in_swich_mesa_3 bigint, in_swich_mesa_4 bigint, in_swich_votos character varying) OWNER TO postgres;

--
-- Name: swich_mesas(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
            mesa.mesa_id,
            mesa.mesa_tipo,
			mesa.mesa_zona,
            mesa.mesa_zona_titulo,
			mesa.mesa_comuna,
            mesa.mesa_local,
            mesa.mesa_numero
	
	    FROM
	        mesa
	        
		WHERE
			mesa.mesa_id IN ( in_mesa_1 , in_mesa_2 , in_mesa_3 )
	
	    LIMIT 3
	    ;
	
	END $$;


ALTER FUNCTION public.swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) OWNER TO app_vav;

--
-- Name: swich_mesas_total(character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.swich_mesas_total(in_mesa_tipo character varying) RETURNS TABLE(votos_total bigint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, partido_codigo character varying)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
		SELECT
            sum(t2.voto_total) as votos_total,
            t3.candidato_id,
            t3.candidato_nombres,
            t3.candidato_apellidos,
            t4.partido_codigo
        from
            mesa t1,
            voto t2,
            candidato t3,
            partido t4
        WHERE
            t1.mesa_tipo = 'P' AND
            t1.mesa_estado = 1 AND
            t2.mesa_id = t1.mesa_id AND
            t3.candidato_id = t2.candidato_id AND
            t4.partido_id = t3.partido_id
        group by
            t3.candidato_id,
            t3.candidato_apellidos,
            t4.partido_codigo;

	END $$;


ALTER FUNCTION public.swich_mesas_total(in_mesa_tipo character varying) OWNER TO app_vav;

--
-- Name: swich_mesas_total_actuales(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.swich_mesas_total_actuales() RETURNS TABLE(mesa bigint)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
		select t0.mesa_id AS mesa from (
		select t1.mesa_id, row_number() over (ORDER BY t1.mesa_id) as rownum
		from mesa t1 
		where t1.mesa_tipo = 'P' 
		and t1.mesa_estado = 1 
		order by t1.mesa_id ) as t0
		where t0.rownum <= 20;

	END $$;


ALTER FUNCTION public.swich_mesas_total_actuales() OWNER TO app_vav;

--
-- Name: swich_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.swich_obtener_datos(in_swich_id bigint) RETURNS TABLE(swich_mesas smallint, swich_modo smallint, swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint, swich_mesa_4 smallint, swich_votos character varying, swich_cambio timestamp without time zone)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

	        swich.swich_mesas,

			swich.swich_modo,

	        swich.swich_mesa_1,

	        swich.swich_mesa_2,

	        swich.swich_mesa_3,

	        swich.swich_mesa_4,

			swich.swich_votos,

			swich.swich_cambio

	    FROM

	        swich

		WHERE

			swich.swich_id = in_swich_id

	    ;

	END $$;


ALTER FUNCTION public.swich_obtener_datos(in_swich_id bigint) OWNER TO postgres;

--
-- Name: usuario_contar_total(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.usuario_contar_total() RETURNS TABLE(objetos bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT

			count(usuario_id) AS objetos 

		FROM

			usuario

	    ;

	END $$;


ALTER FUNCTION public.usuario_contar_total() OWNER TO app_vav;

--
-- Name: usuario_editar(bigint, character varying, character varying, character varying, character varying, character varying, bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_editar(in_usuario_id bigint, in_usuario_rol character varying, in_usuario_nombre character varying, in_usuario_email character varying, in_usuario_password character varying, in_usuario_genero character varying, in_usuario_etiqueta bigint, in_imagenes character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_orden int;

			v_imagenes bigint;

			v_imagenes_array varchar[];

		BEGIN

	--	Comienzo del Orden

		v_orden = 0;

	--	Separar los ID de las Imagenes

        SELECT string_to_array(in_imagenes, ',') INTO v_imagenes_array;

	--	Actualizar Posicion de las imagenes

        FOREACH v_imagenes IN ARRAY v_imagenes_array LOOP

	        UPDATE

	        	imagen

	        SET

	        	imagen_orden = v_orden

	        WHERE

	        	imagen_id = v_imagenes AND

	        	imagen_objeto = in_usuario_id

	        ;

			v_orden = v_orden + 1;

        END LOOP;

	--	Editar Usuario

		UPDATE

			usuario

		SET

			usuario_rol = in_usuario_rol,

			usuario_nombre = in_usuario_nombre,

			usuario_email = in_usuario_email,

			usuario_genero = in_usuario_genero,

			usuario_etiqueta = in_usuario_etiqueta

		WHERE

			usuario_id = in_usuario_id

		;

	--	Validar Cambio de Password

		CASE 

		--	Sin Cambio de Password

			WHEN in_usuario_password = 'NULL' THEN

		--	Cambio de Password

			ELSE

				UPDATE

					usuario

				SET

					usuario_password = in_usuario_password

				WHERE

					usuario_id = in_usuario_id

				;

		END CASE;

		RETURN 1;

	END $$;


ALTER FUNCTION public.usuario_editar(in_usuario_id bigint, in_usuario_rol character varying, in_usuario_nombre character varying, in_usuario_email character varying, in_usuario_password character varying, in_usuario_genero character varying, in_usuario_etiqueta bigint, in_imagenes character varying) OWNER TO postgres;

--
-- Name: usuario_eliminar(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_eliminar(in_usuario_id bigint, in_imagen_tipo character varying) RETURNS TABLE(imagen_id bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

        	imagen.imagen_id,

        	imagen.imagen_objeto,

        	imagen.imagen_tipo,

        	imagen.imagen_extension

	    FROM

	        imagen

	    WHERE

	        imagen.imagen_objeto = in_usuario_id AND

	        imagen.imagen_tipo = in_imagen_tipo

	    ;

	--	Eliminar Imagenes

        DELETE FROM

        	imagen

        WHERE

	        imagen.imagen_objeto = in_usuario_id AND

	        imagen.imagen_tipo = in_imagen_tipo

        ;

	--	Eliminar Usuario

        DELETE FROM

        	usuario

        WHERE

	        usuario.usuario_id = in_usuario_id

        ;

	END $$;


ALTER FUNCTION public.usuario_eliminar(in_usuario_id bigint, in_imagen_tipo character varying) OWNER TO postgres;

--
-- Name: usuario_iniciar_sesion(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_iniciar_sesion(in_usuario_email character varying, in_usuario_password character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_usuario bigint;

		BEGIN

	--	VALIDAR CREDENCIALES

		SELECT usuario_id FROM usuario WHERE usuario_email = in_usuario_email AND usuario_password = in_usuario_password INTO v_usuario;

	--	RESPUESTA DE LA QUERY

		IF v_usuario <1 THEN

	        RETURN 0;

	    ELSE

			RETURN v_usuario;

        END IF;

	END $$;


ALTER FUNCTION public.usuario_iniciar_sesion(in_usuario_email character varying, in_usuario_password character varying) OWNER TO postgres;

--
-- Name: usuario_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_listado(in_limit integer, in_offset integer) RETURNS TABLE(usuario_id bigint, usuario_rol character varying, usuario_estado smallint, usuario_nombre character varying, usuario_login timestamp without time zone, usuario_creado timestamp without time zone, usuario_poster text)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

	        usuario.usuario_id,

	        usuario.usuario_rol,

	        usuario.usuario_estado,

	        usuario.usuario_nombre,

	        usuario.usuario_login,

	        usuario.usuario_creado,

			(

				SELECT

					CONCAT( usuario.usuario_id , '|' , imagen.imagen_id , '|' , imagen.imagen_extension ) AS usuario_poster

				FROM

					imagen

				WHERE

					imagen_objeto = usuario.usuario_id AND

					imagen_tipo = 'USU'

				ORDER BY imagen.imagen_orden ASC

				LIMIT 1

			)

	    FROM

	        usuario

	    ORDER BY

	        usuario.usuario_id DESC,

	        usuario.usuario_nombre ASC

	    LIMIT in_limit OFFSET in_offset

	    ;

	END $$;


ALTER FUNCTION public.usuario_listado(in_limit integer, in_offset integer) OWNER TO postgres;

--
-- Name: usuario_listado_movil(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_listado_movil() RETURNS TABLE(usuario_id bigint, usuario_estado smallint, usuario_genero character varying, usuario_nombre character varying, usuario_password character varying, usuario_etiqueta bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

	        usuario.usuario_id,

			usuario.usuario_estado,

			usuario.usuario_genero,

	        usuario.usuario_nombre,

	        usuario.usuario_password,

	        usuario.usuario_etiqueta

	    FROM

	        usuario

	    ORDER BY

	        usuario.usuario_id DESC,

	        usuario.usuario_nombre ASC

		;

	END $$;


ALTER FUNCTION public.usuario_listado_movil() OWNER TO postgres;

--
-- Name: usuario_nuevo(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION public.usuario_nuevo() RETURNS bigint
    LANGUAGE plpgsql
    AS $$

		DECLARE

			v_id bigint;

		BEGIN

        SELECT nextval('usuario_id_seq') INTO v_id;

        INSERT INTO usuario

        (

        	usuario_id

        )

		VALUES

		(

			v_id

		);

        RETURN v_id;

	END $$;


ALTER FUNCTION public.usuario_nuevo() OWNER TO app_vav;

--
-- Name: usuario_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usuario_obtener_datos(in_usuario_id bigint) RETURNS TABLE(usuario_id bigint, usuario_rol character varying, usuario_estado smallint, usuario_genero character varying, usuario_nombre character varying, usuario_email character varying, usuario_etiqueta bigint, usuario_login timestamp without time zone, usuario_creado timestamp without time zone, usuario_poster text)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

	        usuario.usuario_id,

	        usuario.usuario_rol,

	        usuario.usuario_estado,

	        usuario.usuario_genero,

	        usuario.usuario_nombre,

	        usuario.usuario_email,

	        usuario.usuario_etiqueta,

	        usuario.usuario_login,

	        usuario.usuario_creado,

			(

				SELECT

					CONCAT( usuario.usuario_id , '|' , imagen.imagen_id , '|' , imagen.imagen_extension ) AS usuario_poster

				FROM

					imagen

				WHERE

					imagen_objeto = usuario.usuario_id AND

					imagen_tipo = 'USU'

				ORDER BY imagen.imagen_orden ASC

				LIMIT 1

			)

	    FROM

	        usuario

	    WHERE

	        usuario.usuario_id = in_usuario_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.usuario_obtener_datos(in_usuario_id bigint) OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: candidato; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.candidato (
    candidato_id bigint NOT NULL,
    candidato_tipo character varying(3) DEFAULT 'ALC'::character varying,
    candidato_orden smallint DEFAULT 1 NOT NULL,
    candidato_zona bigint DEFAULT 0 NOT NULL,
    pacto_id bigint DEFAULT 1 NOT NULL,
    partido_id bigint DEFAULT 1 NOT NULL,
    candidato_nombre character varying(128),
    candidato_nombre_corto character varying(128),
    candidato_genero character varying(1) DEFAULT 'n'::character varying,
    candidato_independiente boolean DEFAULT false,
    candidato_lista character varying(12),
    candidato_nombres character varying(64),
    candidato_apellidos character varying(64)
);


ALTER TABLE public.candidato OWNER TO app_vav;

--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.candidato_candidato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidato_candidato_id_seq OWNER TO app_vav;

--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.candidato_candidato_id_seq OWNED BY public.candidato.candidato_id;


--
-- Name: candidato_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.candidato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidato_id_seq OWNER TO app_vav;

--
-- Name: candidato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.candidato_id_seq OWNED BY public.candidato.candidato_id;


--
-- Name: comuna; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.comuna (
    comuna_id bigint NOT NULL,
    region_id bigint DEFAULT 1 NOT NULL,
    distrito_id smallint NOT NULL,
    comuna_nombre character varying(64)
);


ALTER TABLE public.comuna OWNER TO app_vav;

--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.comuna_comuna_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comuna_comuna_id_seq OWNER TO app_vav;

--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.comuna_comuna_id_seq OWNED BY public.comuna.comuna_id;


--
-- Name: comuna_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.comuna_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comuna_id_seq OWNER TO app_vav;

--
-- Name: comuna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.comuna_id_seq OWNED BY public.comuna.comuna_id;


--
-- Name: imagen; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.imagen (
    imagen_id bigint NOT NULL,
    imagen_orden bigint NOT NULL,
    imagen_objeto bigint NOT NULL,
    imagen_tipo character varying(3) NOT NULL,
    imagen_estado smallint DEFAULT 1,
    imagen_titulo character varying(32),
    imagen_bajada character varying(64),
    imagen_tags character varying(128),
    imagen_extension character varying(4) NOT NULL,
    imagen_cambio bigint,
    imagen_creado timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT imagen_imagen_extension_check CHECK (((imagen_extension)::text = ANY (ARRAY[('.jpg'::character varying)::text, ('.gif'::character varying)::text, ('.png'::character varying)::text]))),
    CONSTRAINT imagen_imagen_tipo_check CHECK (((imagen_tipo)::text = 'USU'::text))
);


ALTER TABLE public.imagen OWNER TO app_vav;

--
-- Name: imagen_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.imagen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagen_id_seq OWNER TO app_vav;

--
-- Name: imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.imagen_id_seq OWNED BY public.imagen.imagen_id;


--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.imagen_imagen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagen_imagen_id_seq OWNER TO app_vav;

--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.imagen_imagen_id_seq OWNED BY public.imagen.imagen_id;


--
-- Name: mesa; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.mesa (
    mesa_id bigint NOT NULL,
    usuario_id bigint DEFAULT 1 NOT NULL,
    mesa_tipo character varying(3) DEFAULT 'ALC'::character varying,
    mesa_zona bigint DEFAULT 0 NOT NULL,
    mesa_zona_titulo character varying(64),
    mesa_comuna character varying(64),
    mesa_local character varying(64),
    mesa_numero character varying(64) DEFAULT 'MESA  '::character varying,
    mesa_orden smallint DEFAULT 1 NOT NULL,
    mesa_estado smallint DEFAULT 0 NOT NULL,
    mesa_destacada smallint DEFAULT 0 NOT NULL,
    mesa_votos_blancos smallint DEFAULT 0 NOT NULL,
    mesa_votos_nulos smallint DEFAULT 0 NOT NULL,
    mesa_cambio timestamp without time zone DEFAULT now() NOT NULL,
    mesa_creado timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.mesa OWNER TO app_vav;

--
-- Name: mesa_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.mesa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mesa_id_seq OWNER TO app_vav;

--
-- Name: mesa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.mesa_id_seq OWNED BY public.mesa.mesa_id;


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.mesa_mesa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mesa_mesa_id_seq OWNER TO app_vav;

--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.mesa_mesa_id_seq OWNED BY public.mesa.mesa_id;


--
-- Name: pacto; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.pacto (
    pacto_id bigint NOT NULL,
    pacto_codigo character varying(24),
    pacto_nombre character varying(64)
);


ALTER TABLE public.pacto OWNER TO app_vav;

--
-- Name: pacto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.pacto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacto_id_seq OWNER TO app_vav;

--
-- Name: pacto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.pacto_id_seq OWNED BY public.pacto.pacto_id;


--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.pacto_pacto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacto_pacto_id_seq OWNER TO app_vav;

--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.pacto_pacto_id_seq OWNED BY public.pacto.pacto_id;


--
-- Name: partido; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.partido (
    partido_id bigint NOT NULL,
    partido_nombre character varying(64),
    partido_codigo character varying(16)
);


ALTER TABLE public.partido OWNER TO app_vav;

--
-- Name: partido_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.partido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partido_id_seq OWNER TO app_vav;

--
-- Name: partido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.partido_id_seq OWNED BY public.partido.partido_id;


--
-- Name: partido_partido_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.partido_partido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partido_partido_id_seq OWNER TO app_vav;

--
-- Name: partido_partido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.partido_partido_id_seq OWNED BY public.partido.partido_id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.region (
    region_id bigint NOT NULL,
    region_nombre character varying(32),
    region_codigo character varying(5)
);


ALTER TABLE public.region OWNER TO app_vav;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_id_seq OWNER TO app_vav;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.region_id_seq OWNED BY public.region.region_id;


--
-- Name: region_region_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.region_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_region_id_seq OWNER TO app_vav;

--
-- Name: region_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.region_region_id_seq OWNED BY public.region.region_id;


--
-- Name: swich; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.swich (
    swich_id bigint NOT NULL,
    swich_mesas smallint DEFAULT 0,
    swich_mesa_1 smallint DEFAULT 0,
    swich_mesa_2 smallint DEFAULT 0,
    swich_mesa_3 smallint DEFAULT 0,
    swich_mesa_4 smallint DEFAULT 0,
    swich_votos character varying(1) DEFAULT 'p'::character varying,
    swich_cambio timestamp without time zone DEFAULT now() NOT NULL,
    swich_modo smallint
);


ALTER TABLE public.swich OWNER TO app_vav;

--
-- Name: swich_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.swich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.swich_id_seq OWNER TO app_vav;

--
-- Name: swich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.swich_id_seq OWNED BY public.swich.swich_id;


--
-- Name: swich_swich_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.swich_swich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.swich_swich_id_seq OWNER TO app_vav;

--
-- Name: swich_swich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.swich_swich_id_seq OWNED BY public.swich.swich_id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.usuario (
    usuario_id bigint NOT NULL,
    usuario_rol character varying(2) DEFAULT 'OP'::character varying,
    usuario_estado smallint DEFAULT 1,
    usuario_genero character varying(1) DEFAULT 'n'::character varying,
    usuario_nombre character varying(32),
    usuario_email character varying(64),
    usuario_password character varying(32),
    usuario_etiqueta bigint DEFAULT 1,
    usuario_login timestamp without time zone DEFAULT now(),
    usuario_creado timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT usuario_usuario_genero_check CHECK (((usuario_genero)::text = ANY (ARRAY[('n'::character varying)::text, ('f'::character varying)::text, ('m'::character varying)::text]))),
    CONSTRAINT usuario_usuario_rol_check CHECK (((usuario_rol)::text = ANY (ARRAY[('AD'::character varying)::text, ('AM'::character varying)::text, ('OP'::character varying)::text, ('VZ'::character varying)::text])))
);


ALTER TABLE public.usuario OWNER TO app_vav;

--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_seq OWNER TO app_vav;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.usuario_id;


--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.usuario_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_usuario_id_seq OWNER TO app_vav;

--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.usuario_usuario_id_seq OWNED BY public.usuario.usuario_id;


--
-- Name: voto; Type: TABLE; Schema: public; Owner: app_vav
--

CREATE TABLE public.voto (
    voto_id bigint NOT NULL,
    candidato_id bigint DEFAULT 1 NOT NULL,
    mesa_id bigint DEFAULT 1 NOT NULL,
    voto_total smallint NOT NULL
);


ALTER TABLE public.voto OWNER TO app_vav;

--
-- Name: voto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.voto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voto_id_seq OWNER TO app_vav;

--
-- Name: voto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.voto_id_seq OWNED BY public.voto.voto_id;


--
-- Name: voto_voto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE public.voto_voto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voto_voto_id_seq OWNER TO app_vav;

--
-- Name: voto_voto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE public.voto_voto_id_seq OWNED BY public.voto.voto_id;


--
-- Name: candidato candidato_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.candidato ALTER COLUMN candidato_id SET DEFAULT nextval('public.candidato_id_seq'::regclass);


--
-- Name: comuna comuna_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.comuna ALTER COLUMN comuna_id SET DEFAULT nextval('public.comuna_id_seq'::regclass);


--
-- Name: imagen imagen_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.imagen ALTER COLUMN imagen_id SET DEFAULT nextval('public.imagen_id_seq'::regclass);


--
-- Name: mesa mesa_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.mesa ALTER COLUMN mesa_id SET DEFAULT nextval('public.mesa_id_seq'::regclass);


--
-- Name: pacto pacto_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.pacto ALTER COLUMN pacto_id SET DEFAULT nextval('public.pacto_id_seq'::regclass);


--
-- Name: partido partido_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.partido ALTER COLUMN partido_id SET DEFAULT nextval('public.partido_id_seq'::regclass);


--
-- Name: region region_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.region ALTER COLUMN region_id SET DEFAULT nextval('public.region_id_seq'::regclass);


--
-- Name: swich swich_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.swich ALTER COLUMN swich_id SET DEFAULT nextval('public.swich_id_seq'::regclass);


--
-- Name: usuario usuario_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.usuario ALTER COLUMN usuario_id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- Name: voto voto_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.voto ALTER COLUMN voto_id SET DEFAULT nextval('public.voto_id_seq'::regclass);


--
-- Data for Name: candidato; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.candidato VALUES
	(3244592, 'P', 6, 3011, 378, 2, 'ANDRES ZALDIVAR LARRAIN', NULL, 'M', false, NULL, 'ANDRES', 'ZALDIVAR'),
	(3929106, 'P', 18, 3016, 379, 1, 'MARIO RIOS SANTANDER', NULL, 'M', true, NULL, 'MARIO', 'RIOS'),
	(4102104, 'P', 14, 3003, 377, 5, 'RICARDO NUÑEZ MUÑOZ', NULL, 'M', false, NULL, 'RICARDO', 'NUÑEZ'),
	(4107128, 'P', 9, 3013, 378, 2, 'CARMEN VICTORIA FREI RUIZ-TAGLE', NULL, 'F', false, NULL, 'CARMEN', 'FREI'),
	(4227646, 'P', 6, 3001, 378, 4, 'SERGIO BITAR CHACRA', NULL, 'M', false, NULL, 'SERGIO', 'BITAR'),
	(4384763, 'P', 14, 3006, 377, 5, 'MIGUEL  LITTIN CUCUMIDES', NULL, 'M', false, NULL, 'MIGUEL', 'LITTIN'),
	(4386100, 'P', 20, 3005, 379, 1, 'GONZALO IBAÑEZ SANTA MARIA', NULL, 'M', true, NULL, 'GONZALO', 'IBAÑEZ'),
	(4388742, 'P', 10, 3007, 378, 4, 'GUILLERMO CERONI FUENTES', NULL, 'M', false, NULL, 'GUILLERMO', 'CERONI'),
	(4665925, 'P', 26, 3013, 379, 37, 'JAIME RAVINET DE LA FUENTE', NULL, 'M', true, NULL, 'JAIME', 'RAVINET'),
	(4678791, 'P', 6, 3004, 378, 7, 'TOMAS ENRIQUE ALVARADO ZEPEDA', NULL, 'M', true, NULL, 'TOMAS', 'ALVARADO'),
	(4721073, 'P', 24, 3005, 379, 3, 'EDMUNDO ELUCHANS URENDA', NULL, 'M', false, NULL, 'EDMUNDO', 'ELUCHANS'),
	(4738039, 'P', 6, 3015, 378, 4, 'SALVADOR URRUTIA CARDENAS', NULL, 'M', true, NULL, 'SALVADOR', 'URRUTIA'),
	(4814138, 'P', 16, 3012, 379, 1, 'ALFONSO CAMPOS GONZALEZ', NULL, 'M', true, NULL, 'ALFONSO', 'CAMPOS'),
	(4831889, 'P', 15, 3007, 381, 150, 'HILDA CECILIA TOLEDO FUENTES', NULL, 'F', false, NULL, 'HILDA', 'TOLEDO'),
	(4847637, 'P', 8, 3015, 378, 2, 'RAUL RAMON CASTRO LETELIER', NULL, 'M', false, NULL, 'RAUL', 'CASTRO'),
	(5093082, 'P', 28, 3007, 379, 1, 'LUIS VALENTIN FERRADA VALENZUELA', NULL, 'M', true, NULL, 'LUIS', 'FERRADA'),
	(5106131, 'P', 6, 3016, 378, 7, 'ALDO DINO JOSE BERNUCCI DIAZ', NULL, 'M', true, NULL, 'ALDO', 'BERNUCCI'),
	(5175640, 'P', 17, 3003, 379, 1, 'YORIS ROJAS VLASTELICA', NULL, 'F', false, NULL, 'YORIS', 'ROJAS'),
	(5280504, 'P', 8, 3014, 378, 4, 'MIGUEL DAVID RAMIREZ CARVAJAL', NULL, 'M', true, NULL, 'MIGUEL', 'RAMIREZ'),
	(5344795, 'P', 16, 3005, 377, 5, 'MARCELO SCHILLING RODRIGUEZ', NULL, 'M', false, NULL, 'MARCELO', 'SCHILLING'),
	(5348422, 'P', 20, 3001, 379, 1, 'NESTOR JOFRE NUÑEZ', NULL, 'M', false, NULL, 'NESTOR', 'JOFRE'),
	(5501238, 'P', 13, 3015, 377, 137, 'MIRIAM ARENAS SANDOVAL', NULL, 'F', true, NULL, 'MIRIAM', 'ARENAS'),
	(5537755, 'P', 9, 3016, 381, 150, 'MARIA ELENA ACUÑA OLIVERA', NULL, 'F', false, NULL, 'MARIA', 'ACUÑA'),
	(5595090, 'P', 14, 3001, 377, 6, 'ROBERTO FLAVIO CORTEZ ROJAS', NULL, 'M', false, NULL, 'ROBERTO', 'CORTEZ'),
	(5756427, 'P', 17, 3008, 379, 1, 'MONICA TRONCOSO SALINAS', NULL, 'F', false, NULL, 'MONICA', 'TRONCOSO'),
	(5797138, 'P', 3, 3016, 378, 7, 'OLGA MARIA ARZOLA SOTO', NULL, 'F', false, NULL, 'OLGA', 'ARZOLA'),
	(5842527, 'P', 10, 3012, 381, 150, 'ROBERT KURT WEISSOHN HECK', NULL, 'M', false, NULL, 'ROBERT', 'WEISSOHN'),
	(6069264, 'P', 25, 3013, 379, 37, 'GLORIA HUTT HESSE', NULL, 'F', false, NULL, 'GLORIA', 'HUTT'),
	(6101810, 'P', 8, 3006, 378, 7, 'PEDRO ANDRES MARCHANT VILLANUEVA', NULL, 'M', false, NULL, 'PEDRO', 'MARCHANT'),
	(6163989, 'P', 12, 3007, 381, 150, 'RICARDO ORTEGA PERRIER', NULL, 'M', false, NULL, 'RICARDO', 'ORTEGA'),
	(6273728, 'P', 20, 3002, 379, 3, 'NALTO  ESPINOZA HURTADO', NULL, 'M', false, NULL, 'NALTO', 'ESPINOZA'),
	(6317119, 'P', 4, 3016, 378, 2, 'RICARDO IVAN ORELLANA ROJAS', NULL, 'M', false, NULL, 'RICARDO', 'ORELLANA'),
	(6530889, 'P', 14, 3014, 377, 5, 'ALEJANDRO KOHLER VARGAS', NULL, 'M', true, NULL, 'ALEJANDRO', 'KOHLER'),
	(6622672, 'P', 12, 3003, 381, 150, 'PAUL ALEXANDER SFEIR RUBIO', NULL, 'M', false, NULL, 'PAUL', 'SFEIR'),
	(6642777, 'P', 14, 3005, 377, 5, 'ALDO  VALLE ACEVEDO', NULL, 'M', true, NULL, 'ALDO', 'VALLE'),
	(6651899, 'P', 6, 3006, 378, 2, 'BERNARDO FRANCISCO ZAPATA ABARCA', NULL, 'M', false, NULL, 'BERNARDO', 'ZAPATA'),
	(6687951, 'P', 4, 3005, 378, 2, 'MANUEL ARMANDO TOBAR LEIVA', NULL, 'M', false, NULL, 'MANUEL', 'TOBAR'),
	(6720037, 'P', 4, 3001, 380, 157, 'CARLOS ALBERTO MELLA LATORRE', NULL, 'M', false, NULL, 'CARLOS', 'MELLA'),
	(6928545, 'P', 17, 3010, 379, 1, 'EVELYN  ZOTTELE GARCIA', NULL, 'F', false, NULL, 'EVELYN', 'ZOTTELE'),
	(7008999, 'P', 5, 3005, 378, 2, 'DARMA ODETTE LOPEZ TORRES', NULL, 'F', false, NULL, 'DARMA', 'LOPEZ'),
	(7011719, 'P', 18, 3014, 379, 1, 'JOSE ANTONIO URRUTIA RIESCO', NULL, 'M', true, NULL, 'JOSE', 'URRUTIA'),
	(7024697, 'P', 18, 3015, 379, 3, 'RAUL  GIL GONZALEZ', NULL, 'M', false, NULL, 'RAUL', 'GIL'),
	(7040289, 'P', 8, 3013, 378, 2, 'ANDRES PALMA IRARRAZAVAL', NULL, 'M', false, NULL, 'ANDRES', 'PALMA'),
	(7077432, 'P', 22, 3013, 377, 5, 'SADI MELO MOYA', NULL, 'M', false, NULL, 'SADI', 'MELO'),
	(7134978, 'P', 11, 3003, 381, 150, 'FRESIA MARIA SEPULVEDA HANCKES', NULL, 'F', false, NULL, 'FRESIA', 'SEPULVEDA'),
	(7143674, 'P', 13, 3014, 377, 5, 'NANCY  SILVA GUERRERO', NULL, 'F', false, NULL, 'NANCY', 'SILVA'),
	(7166120, 'P', 10, 3002, 381, 150, 'CARLOS SOLAR BARRIOS', NULL, 'M', false, NULL, 'CARLOS', 'SOLAR'),
	(7212608, 'P', 2, 3006, 380, 157, 'LUIS FELIPE LORENZINI CLAVEL', NULL, 'M', false, NULL, 'LUIS', 'LORENZINI'),
	(7214480, 'P', 12, 3015, 381, 150, 'CARLOS MIGUEL ALVARADO AGUIRRE', NULL, 'M', false, NULL, 'CARLOS', 'ALVARADO'),
	(7221693, 'P', 8, 3003, 378, 7, 'NELSON DEL TRANSITO LOPEZ LOPEZ', NULL, 'M', true, NULL, 'NELSON', 'LOPEZ'),
	(7337534, 'P', 14, 3002, 377, 45, 'JOSE ANTONIO GONZALEZ PIZARRO', NULL, 'M', true, NULL, 'JOSE', 'GONZALEZ'),
	(7406584, 'P', 12, 3012, 377, 149, 'JULIO GASTON CONTRERAS MUÑOZ', NULL, 'M', true, NULL, 'JULIO', 'CONTRERAS'),
	(7460922, 'P', 2, 3016, 380, 157, 'MIGUEL ANGEL SEGUNDO CHAVEZ MENDOZA', NULL, 'M', false, NULL, 'MIGUEL', 'CHAVEZ'),
	(7563445, 'P', 28, 3013, 379, 1, 'BRUNO  BARANDA FERRAN', NULL, 'M', false, NULL, 'BRUNO', 'BARANDA'),
	(7689686, 'P', 1, 3012, 380, 157, 'VERONICA DEL CARMEN ROJAS ARENAS', NULL, 'F', false, NULL, 'VERONICA', 'ROJAS'),
	(7701180, 'P', 30, 3009, 379, 1, 'GERMAN BECKER ALVEAR', NULL, 'M', false, NULL, 'GERMAN', 'BECKER'),
	(7724817, 'P', 25, 3009, 379, 1, 'SOLANGE CARMINE ROJAS', NULL, 'F', true, NULL, 'SOLANGE', 'CARMINE'),
	(7832398, 'P', 20, 3010, 379, 3, 'CARLOS  RECONDO LAVANDEROS', NULL, 'M', false, NULL, 'CARLOS', 'RECONDO'),
	(7907269, 'P', 14, 3010, 377, 5, 'EDUARDO CASTRO RIOS', NULL, 'M', true, NULL, 'EDUARDO', 'CASTRO'),
	(7921245, 'P', 5, 3003, 378, 7, 'NORA LUISA VIÑAS GODOY', NULL, 'F', true, NULL, 'NORA', 'VIÑAS'),
	(8005140, 'P', 4, 3004, 380, 157, 'HECTOR RODOLFO ROSAS BUSTOS', NULL, 'M', false, NULL, 'HECTOR', 'ROSAS'),
	(8077485, 'P', 20, 3013, 377, 149, 'YERKO ANTONIO LJUBETIC GODOY', NULL, 'M', false, NULL, 'YERKO', 'LJUBETIC'),
	(8087560, 'P', 16, 3007, 381, 150, 'SEGUNDO ANDRES HOJAS DEL VALLE', NULL, 'M', false, NULL, 'SEGUNDO', 'HOJAS'),
	(8094886, 'P', 16, 3014, 377, 6, 'OSCAR EDUARDO MENDOZA URIARTE', NULL, 'M', true, NULL, 'OSCAR', 'MENDOZA'),
	(8143228, 'P', 8, 3010, 378, 4, 'JUAN CARLOS DUHALDE ROMERO', NULL, 'M', false, NULL, 'JUAN', 'DUHALDE'),
	(8158868, 'P', 22, 3007, 377, 5, 'CHRISTIAN  SUAREZ CROTHERS', NULL, 'M', true, NULL, 'CHRISTIAN', 'SUAREZ'),
	(8196077, 'P', 20, 3009, 377, 5, 'RAUL ALLARD SOTO', NULL, 'M', false, NULL, 'RAUL', 'ALLARD'),
	(8226720, 'P', 20, 3008, 379, 3, 'JORGE  ULLOA AGUILLON', NULL, 'M', false, NULL, 'JORGE', 'ULLOA'),
	(8233596, 'P', 6, 3012, 378, 7, 'VICTOR MAURICIO HERNANDEZ GODOY', NULL, 'M', false, NULL, 'VICTOR', 'HERNANDEZ'),
	(8363183, 'P', 24, 3007, 379, 3, 'MARIO  UNDURRAGA CASTELBLANCO', NULL, 'M', false, NULL, 'MARIO', 'UNDURRAGA'),
	(8418777, 'P', 5, 3010, 378, 2, 'GLORIA MARITZA HURTADO GARAY', NULL, 'F', false, NULL, 'GLORIA', 'HURTADO'),
	(8500066, 'P', 2, 3005, 378, 4, 'MARCO ANTONIO NUÑEZ LOZANO', NULL, 'M', false, NULL, 'MARCO', 'NUÑEZ'),
	(8512604, 'P', 16, 3001, 377, 5, 'KURT HENER PEREZ', NULL, 'M', false, NULL, 'KURT', 'HENER'),
	(8525872, 'P', 20, 3006, 379, 1, 'JUAN SUTIL SERVOIN', NULL, 'M', true, NULL, 'JUAN', 'SUTIL'),
	(8576244, 'P', 11, 3005, 381, 150, 'CHANTAL ROBERT DE LA MAHOTIERE FLOTTES', NULL, 'F', false, NULL, 'CHANTAL', 'ROBERT DE LA MAHOTIERE'),
	(8577508, 'P', 7, 3002, 378, 7, 'DORIS NERTA NAVARRO FIGUEROA', NULL, 'F', false, NULL, 'DORIS', 'NAVARRO'),
	(8680065, 'P', 6, 3013, 380, 157, 'GONZALO GERMAN INOJOSA HERNANDEZ', NULL, 'M', false, NULL, 'GONZALO', 'INOJOSA'),
	(8680695, 'P', 17, 3016, 379, 1, 'SANDRA LAMA LARENAS', NULL, 'F', true, NULL, 'SANDRA', 'LAMA'),
	(8687334, 'P', 13, 3011, 377, 6, 'VALENTINA GABRIELA MILLALONCO VARGAS', NULL, 'F', false, NULL, 'VALENTINA', 'MILLALONCO'),
	(8692707, 'P', 19, 3010, 379, 3, 'PATRICIA SANZANA CARDENAS', NULL, 'F', true, NULL, 'PATRICIA', 'SANZANA'),
	(8722148, 'P', 10, 3010, 381, 150, 'MAXIMILIANO ARTURO URRUTIA QUEZADA', NULL, 'M', false, NULL, 'MAXIMILIANO', 'URRUTIA'),
	(8766295, 'P', 40, 3017, 999, 99, 'ALIHUEN ANTILEO NAVARRETE', NULL, 'M', false, NULL, 'ALIHUEN', 'ANTILEO'),
	(8771203, 'P', 30, 3013, 379, 3, 'RODRIGO  DELGADO MOCARQUER', NULL, 'M', false, NULL, 'RODRIGO', 'DELGADO'),
	(8879813, 'P', 19, 3004, 379, 3, 'IVON  GUERRA AGUILERA', NULL, 'F', false, NULL, 'IVON', 'GUERRA'),
	(8897628, 'P', 6, 3014, 378, 4, 'MIGUEL BARRIGA PARRA', NULL, 'M', true, NULL, 'MIGUEL', 'BARRIGA'),
	(9012679, 'P', 22, 3005, 379, 37, 'GONZALO YUSEFF QUIROS', NULL, 'M', true, NULL, 'GONZALO', 'YUSEFF'),
	(9021531, 'P', 10, 3009, 378, 7, 'VICTOR HUGO HIRAM PACHECO SCHMIDT', NULL, 'M', true, NULL, 'VICTOR', 'PACHECO'),
	(9024616, 'P', 14, 3013, 381, 150, 'LUIS SILVA IRARRAZAVAL', NULL, 'M', false, NULL, 'LUIS', 'SILVA'),
	(9043304, 'P', 8, 3016, 381, 150, 'ABRAHAM MANUEL GONZALEZ OLAVE', NULL, 'M', false, NULL, 'ABRAHAM', 'GONZALEZ'),
	(9054033, 'P', 2, 3011, 380, 157, 'LUIS ALBERTO SOTO SOTO', NULL, 'M', false, NULL, 'LUIS', 'SOTO'),
	(9065357, 'P', 17, 3011, 379, 1, 'PILAR CUEVAS MARDONES', NULL, 'F', false, NULL, 'PILAR', 'CUEVAS'),
	(9072069, 'P', 14, 3015, 377, 137, 'RODRIGO LEONARDO MUÑOZ PONCE', NULL, 'M', true, NULL, 'RODRIGO', 'MUÑOZ'),
	(9225586, 'P', 17, 3001, 379, 3, 'PILAR BARRIENTOS HERNANDEZ', NULL, 'F', false, NULL, 'PILAR', 'BARRIENTOS'),
	(9243488, 'P', 2, 3008, 380, 157, 'HUGO ANTONIO SOTO BECERRA', NULL, 'M', false, NULL, 'HUGO', 'SOTO'),
	(9282652, 'P', 12, 3009, 378, 4, 'ALFREDO VALLEJOS PROVOSTE', NULL, 'M', true, NULL, 'ALFREDO', 'VALLEJOS'),
	(9313223, 'P', 11, 3012, 377, 149, 'JESSICA MILENA BENGOA MAYORGA', NULL, 'F', false, NULL, 'JESSICA', 'BENGOA'),
	(9330515, 'P', 12, 3004, 381, 150, 'SERGIO HERNAN PINO VERGARA', NULL, 'M', false, NULL, 'SERGIO', 'PINO'),
	(9433193, 'P', 18, 3007, 377, 130, 'MANUEL ARNOLDO AMESTICA GAETE', NULL, 'M', false, NULL, 'MANUEL', 'AMESTICA'),
	(9480453, 'P', 11, 3007, 381, 150, 'MARIA GATICA GAJARDO', NULL, 'F', false, NULL, 'MARIA', 'GATICA'),
	(9542426, 'P', 1, 3002, 380, 157, 'SINDY TESSA GONZALEZ SALINI', NULL, 'F', false, NULL, 'SINDY', 'GONZALEZ'),
	(9727794, 'P', 9, 3004, 381, 150, 'GLORIA YOLANDA PAREDES DIAZ', NULL, 'F', false, NULL, 'GLORIA', 'PAREDES'),
	(9754223, 'P', 6, 3007, 380, 157, 'BORIS HUMBERTO CHAVEZ ZAMBRANO', NULL, 'M', false, NULL, 'BORIS', 'CHAVEZ'),
	(9813500, 'P', 11, 3016, 377, 5, 'BRIGIDA ELIZABETH ESCALONA GONZALEZ', NULL, 'F', false, NULL, 'BRIGIDA', 'ESCALONA'),
	(9853314, 'P', 11, 3011, 381, 150, 'NIEVES ANTONIA CUEVAS TORRES', NULL, 'F', false, NULL, 'NIEVES', 'CUEVAS'),
	(9884617, 'P', 11, 3004, 381, 150, 'MARIA TERESITA PROUVAY CORNEJO', NULL, 'F', false, NULL, 'MARIA', 'PROUVAY'),
	(9893634, 'P', 15, 3011, 377, 5, 'LORENA  SOZA HERNANDEZ', NULL, 'F', false, NULL, 'LORENA', 'SOZA'),
	(9980104, 'P', 8, 3004, 378, 4, 'JORGE INSUNZA GREGORIO DE LAS HERAS', NULL, 'M', false, NULL, 'JORGE', 'INSUNZA'),
	(10050616, 'P', 18, 3012, 379, 37, 'ARIEL MIHOVILOVIC BONARDI', NULL, 'M', true, NULL, 'ARIEL', 'MIHOVILOVIC'),
	(10055396, 'P', 7, 3013, 378, 4, 'NATALIA PIERGENTILI DOMENECH', NULL, 'F', false, NULL, 'NATALIA', 'PIERGENTILI'),
	(10219549, 'P', 3, 3014, 380, 157, 'MARIA SONIA AGUILEF GALLEGOS', NULL, 'F', false, NULL, 'MARIA', 'AGUILEF'),
	(10254641, 'P', 18, 3008, 379, 1, 'ROBERT CONTRERAS REYES', NULL, 'M', false, NULL, 'ROBERT', 'CONTRERAS'),
	(10298243, 'P', 9, 3002, 381, 150, 'CARMEN  MONTOYA MAYORGA', NULL, 'F', false, NULL, 'CARMEN', 'MONTOYA'),
	(10335642, 'P', 19, 3011, 379, 3, 'ANDREA  PONCE OLIVARES', NULL, 'F', false, NULL, 'ANDREA', 'PONCE'),
	(10426670, 'P', 7, 3016, 381, 150, 'CECILIA VIOLETA MEDINA MENESES', NULL, 'F', false, NULL, 'CECILIA', 'MEDINA'),
	(10457308, 'P', 18, 3009, 381, 150, 'HECTOR  URBAN ASTETE', NULL, 'M', false, NULL, 'HECTOR', 'URBAN'),
	(10483956, 'P', 23, 3007, 379, 3, 'MARIA CLAUDIA JORQUERA CORIA', NULL, 'F', false, NULL, 'MARIA', 'JORQUERA'),
	(10486198, 'P', 1, 3014, 380, 157, 'EMMA PATRICIA CIFUENTES BARRIENTOS', NULL, 'F', false, NULL, 'EMMA', 'CIFUENTES'),
	(10488532, 'P', 12, 3014, 381, 150, 'JORGE  DE LA MAZA SCHLEYER', NULL, 'M', false, NULL, 'JORGE', 'DE LA MAZA'),
	(10586276, 'P', 18, 3001, 379, 3, 'MAURICIO SCHMIDT SILVA', NULL, 'M', false, NULL, 'MAURICIO', 'SCHMIDT'),
	(10609419, 'P', 7, 3003, 378, 2, 'VERONICA TERESA GARRIDO BRICEÑO', NULL, 'F', false, NULL, 'VERONICA', 'GARRIDO'),
	(10673960, 'P', 5, 3004, 378, 2, 'ALEJANDRA ELENA VIVANCO REYES', NULL, 'F', false, NULL, 'ALEJANDRA', 'VIVANCO'),
	(10676684, 'P', 3, 3012, 378, 4, 'ANDREA PIVCEVIC CORTESE', NULL, 'F', true, NULL, 'ANDREA', 'PIVCEVIC'),
	(10728965, 'P', 4, 3015, 380, 157, 'ERNESTO RODRIGO PLASENCIA ROJAS', NULL, 'M', false, NULL, 'ERNESTO', 'PLASENCIA'),
	(10773416, 'P', 9, 3006, 381, 150, 'ELISA AMELIA SALAS LOPEZ', NULL, 'F', false, NULL, 'ELISA', 'SALAS'),
	(10800928, 'P', 12, 3013, 378, 7, 'RODRIGO JOSE CHANDIA SOTO', NULL, 'M', false, NULL, 'RODRIGO', 'CHANDIA'),
	(10836331, 'P', 4, 3014, 380, 157, 'GUSTAVO EDUARDO DAVILA SEPULVEDA', NULL, 'M', false, NULL, 'GUSTAVO', 'DAVILA'),
	(10899219, 'P', 7, 3008, 378, 4, 'ROSSANA ENRIQUEZ CASTILLO', NULL, 'F', false, NULL, 'ROSSANA', 'ENRIQUEZ'),
	(10915395, 'P', 1, 3009, 380, 157, 'FLOR ROSSANY CONTRERAS VIVALLO', NULL, 'F', false, NULL, 'FLOR', 'CONTRERAS'),
	(10933275, 'P', 4, 3011, 380, 157, 'JUAN MARIO REYES URIBE', NULL, 'M', false, NULL, 'JUAN', 'REYES'),
	(10952965, 'P', 16, 3002, 377, 6, 'JOSE CRISTIAN MARDONES GALLARDO', NULL, 'M', false, NULL, 'JOSE', 'MARDONES'),
	(10980343, 'P', 9, 3008, 381, 150, 'PATRICIA SPOERER PRICE', NULL, 'F', false, NULL, 'PATRICIA', 'SPOERER'),
	(10982517, 'P', 11, 3014, 381, 150, 'PATRICIA LILIANA AYORA CAVOUR', NULL, 'F', false, NULL, 'PATRICIA', 'AYORA'),
	(11276885, 'P', 7, 3006, 378, 7, 'MONICA LATORRE ROLDAN', NULL, 'F', true, NULL, 'MONICA', 'LATORRE'),
	(11278401, 'P', 17, 3006, 379, 3, 'MARIA IGNACIA CASTRO ROJAS', NULL, 'F', false, NULL, 'MARIA', 'CASTRO'),
	(11333630, 'P', 9, 3003, 381, 150, 'PATRICIA DEL CARMEN HURTADO LOYOLA', NULL, 'F', false, NULL, 'PATRICIA', 'HURTADO'),
	(11401637, 'P', 2, 3012, 380, 157, 'MARCELO ANDRES TOLEDO TOLEDO', NULL, 'M', false, NULL, 'MARCELO', 'TOLEDO'),
	(11483597, 'P', 3, 3013, 380, 157, 'CARMEN GLORIA GONZALEZ BURNS', NULL, 'F', false, NULL, 'CARMEN', 'GONZALEZ'),
	(11505821, 'P', 11, 3015, 381, 150, 'JACQUELINE CAROLINA BOERO CARVAJAL', NULL, 'F', false, NULL, 'JACQUELINE', 'BOERO'),
	(11533584, 'P', 12, 3016, 377, 6, 'JOSE OSVALDO ZUÑIGA PINO', NULL, 'M', false, NULL, 'JOSE', 'ZUÑIGA'),
	(11591149, 'P', 22, 3009, 377, 5, 'JOSE ANTONIO JEREZ BURGOS', NULL, 'M', false, NULL, 'JOSE', 'JEREZ'),
	(11686898, 'P', 24, 3009, 377, 149, 'CHRISTIAN ROMAN DULANSKY ARAYA', NULL, 'M', false, NULL, 'CHRISTIAN', 'DULANSKY'),
	(11721751, 'P', 5, 3002, 378, 4, 'MARIA CANGANA LOYOLA', NULL, 'F', true, NULL, 'MARIA', 'CANGANA'),
	(11724787, 'P', 10, 3003, 381, 150, 'SEBASTIAN SIMON VEGA', NULL, 'M', false, NULL, 'SEBASTIAN', 'SIMON'),
	(11841040, 'P', 5, 3001, 378, 4, 'MARCELA ORTEGA SAEZ', NULL, 'F', false, NULL, 'MARCELA', 'ORTEGA'),
	(11862663, 'P', 20, 3003, 379, 3, 'GIOVANNI  CALDERON BASSI', NULL, 'M', false, NULL, 'GIOVANNI', 'CALDERON'),
	(11863307, 'P', 10, 3016, 381, 150, 'JUAN LUIS ENRIQUEZ FUENTES', NULL, 'M', false, NULL, 'JUAN', 'ENRIQUEZ'),
	(11888643, 'P', 7, 3015, 378, 2, 'GLORIA LILLO REBOLLEDO', NULL, 'F', true, NULL, 'GLORIA', 'LILLO'),
	(11890533, 'P', 20, 3011, 379, 3, 'CRISTIAN SUAZO CHACON', NULL, 'M', false, NULL, 'CRISTIAN', 'SUAZO'),
	(11926917, 'P', 15, 3010, 377, 45, 'YANINA BEATRIZ DIAZ MAYORGA', NULL, 'F', true, NULL, 'YANINA', 'DIAZ'),
	(12001523, 'P', 8, 3011, 378, 4, 'ELVIS GODOY FURNIER', NULL, 'M', true, NULL, 'ELVIS', 'GODOY'),
	(12030611, 'P', 21, 3009, 377, 130, 'GEMITA ALVAREZ SEPULVEDA', NULL, 'F', false, NULL, 'GEMITA', 'ALVAREZ'),
	(12068971, 'P', 17, 3013, 381, 150, 'SYLVIA DEL CARMEN BUSTOS AGUIRRE', NULL, 'F', false, NULL, 'SYLVIA', 'BUSTOS'),
	(12086253, 'P', 6, 3008, 378, 2, 'CRISTIAN DANIEL SAN MARTIN CARRASCO', NULL, 'M', false, NULL, 'CRISTIAN', 'SAN MARTIN'),
	(12096351, 'P', 18, 3004, 379, 1, 'JORGE VILLAR GUTIERREZ', NULL, 'M', false, NULL, 'JORGE', 'VILLAR'),
	(12192925, 'P', 19, 3009, 377, 6, 'ERNA ANDREA QUIJON GODOY', NULL, 'F', true, NULL, 'ERNA', 'QUIJON'),
	(12219704, 'P', 7, 3004, 378, 4, 'SUSANA COLLAO NUÑEZ', NULL, 'F', false, NULL, 'SUSANA', 'COLLAO'),
	(12232600, 'P', 11, 3006, 381, 150, 'PATRICIA BESA TAGLE', NULL, 'F', false, NULL, 'PATRICIA', 'BESA'),
	(12253804, 'P', 14, 3012, 377, 5, 'PABLO BUSSENIUS CORNEJO', NULL, 'M', false, NULL, 'PABLO', 'BUSSENIUS'),
	(12331341, 'P', 7, 3009, 378, 2, 'KIRIA GLADYS ANTILEO MELLA', NULL, 'F', false, NULL, 'KIRIA', 'ANTILEO'),
	(12382102, 'P', 8, 3012, 381, 150, 'VICTOR HERNAN ARAVENA GUTIERREZ', NULL, 'M', false, NULL, 'VICTOR', 'ARAVENA'),
	(12447501, 'P', 2, 3001, 380, 157, 'LUIS DIXON VERGARA PIZARRO', NULL, 'M', false, NULL, 'LUIS', 'VERGARA'),
	(12522490, 'P', 21, 3007, 377, 6, 'ERNA MARJORIE MALDONADO CASANOVA', NULL, 'F', false, NULL, 'ERNA', 'MALDONADO'),
	(12527957, 'P', 9, 3009, 378, 2, 'MIRIAM PAOLA VALDES ZUÑIGA', NULL, 'F', false, NULL, 'MIRIAM', 'VALDES'),
	(12608155, 'P', 17, 3015, 379, 3, 'BRUNELLA  VINET MATTASOGLIO', NULL, 'F', true, NULL, 'BRUNELLA', 'VINET'),
	(12628019, 'P', 29, 3009, 379, 3, 'CAROLINA LAGOS JOFRE', NULL, 'F', false, NULL, 'CAROLINA', 'LAGOS'),
	(12713168, 'P', 4, 3010, 380, 157, 'GUILLERMO ENRIQUE PALACIOS CONTRERAS', NULL, 'M', false, NULL, 'GUILLERMO', 'PALACIOS'),
	(12722201, 'P', 15, 3012, 379, 37, 'FRANCISCA ROJAS PHILIPPI', NULL, 'F', true, NULL, 'FRANCISCA', 'ROJAS'),
	(12743015, 'P', 2, 3009, 380, 157, 'PEDRO MARCELO BERMEDO LILLO', NULL, 'M', false, NULL, 'PEDRO', 'BERMEDO'),
	(12892091, 'P', 2, 3013, 380, 157, 'MAURICIO ANDRES PAVEZ GALAZ', NULL, 'M', false, NULL, 'MAURICIO', 'PAVEZ'),
	(12911092, 'P', 5, 3006, 378, 2, 'MARCIA ISABEL BARRERA CISTERNAS', NULL, 'F', false, NULL, 'MARCIA', 'BARRERA'),
	(12913235, 'P', 19, 3006, 379, 1, 'IVONNE MANGELSDORFF GALEB', NULL, 'F', false, NULL, 'IVONNE', 'MANGELSDORFF'),
	(12940592, 'P', 15, 3003, 377, 5, 'MARCELA ALEXANDRA ARAYA SEPULVEDA', NULL, 'F', false, NULL, 'MARCELA', 'ARAYA'),
	(12974034, 'P', 14, 3008, 377, 130, 'CRISTIAN EDUARDO CARTES RUZ', NULL, 'M', false, NULL, 'CRISTIAN', 'CARTES'),
	(13014404, 'P', 2, 3002, 380, 157, 'JUAN ENRIQUE MORAGA MENA', NULL, 'M', false, NULL, 'JUAN', 'MORAGA'),
	(13033031, 'P', 3, 3006, 380, 157, 'SUSAN EVELYN GOMEZ PARDO', NULL, 'F', false, NULL, 'SUSAN', 'GOMEZ'),
	(13068925, 'P', 18, 3005, 377, 143, 'GONZALO ANDRES VEGA MORENO', NULL, 'M', false, NULL, 'GONZALO', 'VEGA'),
	(13143472, 'P', 12, 3008, 381, 150, 'CARLOS FRANCISCO ORDENES GATICA', NULL, 'M', false, NULL, 'CARLOS', 'ORDENES'),
	(13177657, 'P', 16, 3004, 377, 5, 'CARLOS GALLEGUILLOS CARVAJAL', NULL, 'M', true, NULL, 'CARLOS', 'GALLEGUILLOS'),
	(13205274, 'P', 13, 3007, 381, 150, 'GREIS MARISEL PARADA ROJAS', NULL, 'F', false, NULL, 'GREIS', 'PARADA'),
	(13231889, 'P', 25, 3007, 379, 37, 'FERNANDA PINOCHET OLAVE', NULL, 'F', false, NULL, 'FERNANDA', 'PINOCHET'),
	(13237807, 'P', 41, 3017, 999, 99, 'JULIO NELSON MARILEO CALFUQUEO', NULL, 'M', false, NULL, 'JULIO', 'MARILEO'),
	(13244595, 'P', 16, 3011, 377, 45, 'JULIO FRANCISCO ÑANCO ANTILEF', NULL, 'M', false, NULL, 'JULIO', 'ÑANCO'),
	(13252861, 'P', 27, 3013, 379, 1, 'ELEONORA ESPINOZA HERNANDEZ', NULL, 'F', false, NULL, 'ELEONORA', 'ESPINOZA'),
	(13289217, 'P', 3, 3002, 380, 157, 'TAMMY SOLEDAD VERDUGO REYES', NULL, 'F', false, NULL, 'TAMMY', 'VERDUGO'),
	(13319116, 'P', 17, 3009, 381, 150, 'LORETO ESTER CAMPANA MORALES', NULL, 'F', false, NULL, 'LORETO', 'CAMPANA'),
	(13330025, 'P', 2, 3004, 380, 157, 'MANUEL ALEJANDRO CONTRERAS OLIVARES', NULL, 'M', false, NULL, 'MANUEL', 'CONTRERAS'),
	(13330031, 'P', 10, 3004, 381, 150, 'ANDRES EDUARDO GUERRA VEGA', NULL, 'M', false, NULL, 'ANDRES', 'GUERRA'),
	(13409217, 'P', 19, 3012, 382, 99, 'CLAUDIO ANDRES BARRIENTOS MOL', NULL, 'M', true, NULL, 'CLAUDIO', 'BARRIENTOS'),
	(13412628, 'P', 1, 3015, 380, 157, 'NORA DEL CARMEN BUGUEÑO AGUILERA', NULL, 'F', false, NULL, 'NORA', 'BUGUEÑO'),
	(13415976, 'P', 15, 3015, 377, 5, 'JOCELYN  ORMEÑO LEE', NULL, 'F', true, NULL, 'JOCELYN', 'ORMEÑO'),
	(13416397, 'P', 11, 3001, 381, 150, 'ANDREA ELIZABETH DUEÑAS CHAVEZ', NULL, 'F', false, NULL, 'ANDREA', 'DUEÑAS'),
	(13533486, 'P', 17, 3004, 379, 1, 'ANA MARIA AHUMADA GALLARDO', NULL, 'F', false, NULL, 'ANA', 'AHUMADA'),
	(13544441, 'P', 21, 3005, 379, 37, 'LUIGINA PRUZZO GUERRA', NULL, 'F', true, NULL, 'LUIGINA', 'PRUZZO'),
	(13561003, 'P', 13, 3006, 377, 130, 'DOMINICA LEONOR GUZMAN ARCE', NULL, 'F', false, NULL, 'DOMINICA', 'GUZMAN'),
	(13600685, 'P', 27, 3007, 379, 1, 'MARLENNE DURAN SEGUEL', NULL, 'F', false, NULL, 'MARLENNE', 'DURAN'),
	(13645497, 'P', 13, 3002, 377, 130, 'JOHANA CRISTINA RIVERA TEJERINA', NULL, 'F', false, NULL, 'JOHANA', 'RIVERA'),
	(13684095, 'P', 19, 3013, 377, 6, 'KAREN VIVIANA ARAYA ROJAS', NULL, 'F', false, NULL, 'KAREN', 'ARAYA'),
	(13817897, 'P', 5, 3014, 378, 4, 'MARILA LORETO BARRIENTOS TRIVIÑOS', NULL, 'F', false, NULL, 'MARILA', 'BARRIENTOS'),
	(13850107, 'P', 13, 3010, 377, 149, 'NANCY CAROLA MARQUEZ GONZALEZ', NULL, 'F', false, NULL, 'NANCY', 'MARQUEZ'),
	(13863895, 'P', 5, 3015, 378, 4, 'MACARENA RIVEROS OYARZO', NULL, 'F', true, NULL, 'MACARENA', 'RIVEROS'),
	(13873240, 'P', 19, 3003, 379, 3, 'MARIAPAZ MIRANDA CATALANO', NULL, 'F', true, NULL, 'MARIAPAZ', 'MIRANDA'),
	(13901251, 'P', 11, 3010, 381, 150, 'LORENA ESTER PEREZ TORO', NULL, 'F', false, NULL, 'LORENA', 'PEREZ'),
	(13991861, 'P', 15, 3001, 377, 190, 'ROSA MARIA OJEDA MENARES', NULL, 'F', false, NULL, 'ROSA', 'OJEDA'),
	(13997900, 'P', 17, 3005, 377, 6, 'CAROLINA PATRICIA FERNANDEZ QUEZADA', NULL, 'F', false, NULL, 'CAROLINA', 'FERNANDEZ'),
	(13999294, 'P', 20, 3015, 379, 1, 'JUAN MANUEL CARRASCO BARRA', NULL, 'M', false, NULL, 'JUAN', 'CARRASCO'),
	(14005883, 'P', 1, 3004, 380, 157, 'JACQUELINE ANDREA MILLA ORTIZ', NULL, 'F', false, NULL, 'JACQUELINE', 'MILLA'),
	(14036888, 'P', 19, 3014, 379, 3, 'CAROLA CABEZA FUENTES', NULL, 'F', true, NULL, 'CAROLA', 'CABEZA'),
	(14062522, 'P', 14, 3004, 377, 6, 'FERNANDO ANTONIO VIVEROS REYES', NULL, 'M', false, NULL, 'FERNANDO', 'VIVEROS'),
	(14102768, 'P', 3, 3015, 380, 157, 'KARLA ANGELICA AÑES GAJARDO', NULL, 'F', false, NULL, 'KARLA', 'AÑES'),
	(14109173, 'P', 19, 3002, 379, 3, 'KATHERINE LOPEZ RIVERA', NULL, 'F', false, NULL, 'KATHERINE', 'LOPEZ'),
	(14138006, 'P', 19, 3005, 379, 1, 'LESLIE BRIONES ROJO', NULL, 'F', false, NULL, 'LESLIE', 'BRIONES'),
	(14166738, 'P', 27, 3009, 379, 37, 'MAGDALENA TRAUB ETCHEGOYEN', NULL, 'F', true, NULL, 'MAGDALENA', 'TRAUB'),
	(14188439, 'P', 11, 3013, 378, 4, 'PAZ SUAREZ BRIONES', NULL, 'F', false, NULL, 'PAZ', 'SUAREZ'),
	(14200292, 'P', 5, 3007, 380, 157, 'DINA CATHERINE CASTILLO CASTILLO', NULL, 'F', false, NULL, 'DINA', 'CASTILLO'),
	(14271718, 'P', 8, 3001, 378, 7, 'PEDRO ANDRES VASQUEZ NEIRA', NULL, 'M', false, NULL, 'PEDRO', 'VASQUEZ'),
	(14288560, 'P', 2, 3007, 380, 157, 'JORGE ENRIQUE ROJAS CARVAJAL', NULL, 'M', false, NULL, 'JORGE', 'ROJAS'),
	(14348730, 'P', 3, 3007, 380, 157, 'SUSANA VERONICA PACHECO MARCOS', NULL, 'F', false, NULL, 'SUSANA', 'PACHECO'),
	(14397114, 'P', 13, 3003, 377, 45, 'YORKA ELISABETH QUINTEROS PEREZ', NULL, 'F', false, NULL, 'YORKA', 'QUINTEROS'),
	(14447560, 'P', 9, 3005, 381, 150, 'TATIANA PAOLA BERNAL PARRA', NULL, 'F', false, NULL, 'TATIANA', 'BERNAL'),
	(14476262, 'P', 17, 3012, 379, 1, 'CECILIA CARDENAS REYES', NULL, 'F', false, NULL, 'CECILIA', 'CARDENAS'),
	(14499183, 'P', 12, 3002, 381, 150, 'PATRICIO MALDONADO LAVADO', NULL, 'M', false, NULL, 'PATRICIO', 'MALDONADO'),
	(14744752, 'P', 9, 3012, 381, 150, 'LUZ HELENA GUZMAN GARCIA', NULL, 'F', false, NULL, 'LUZ', 'GUZMAN'),
	(15002239, 'P', 7, 3001, 378, 2, 'NORMA CRISTINA CORDOVA CORREA', NULL, 'F', false, NULL, 'NORMA', 'CORDOVA'),
	(15017736, 'P', 1, 3001, 380, 157, 'CLAUDIA EVELYN VILLEGAS CARVAJAL', NULL, 'F', false, NULL, 'CLAUDIA', 'VILLEGAS'),
	(15028221, 'P', 1, 3003, 380, 157, 'CAROLINA DE LOS ANGELES CISTERNAS CEPEDA', NULL, 'F', false, NULL, 'CAROLINA', 'CISTERNAS'),
	(15085033, 'P', 8, 3002, 378, 7, 'MARCELO ENCINA MUÑOZ', NULL, 'M', false, NULL, 'MARCELO', 'ENCINA'),
	(15126874, 'P', 1, 3007, 380, 157, 'VIVIANA DE LAS MERCEDES RODRIGUEZ SAAVEDRA', NULL, 'F', false, NULL, 'VIVIANA', 'RODRIGUEZ'),
	(15214271, 'P', 4, 3009, 380, 157, 'ROBERTO ANDRES BASCUÑAN SALDIAS', NULL, 'M', false, NULL, 'ROBERTO', 'BASCUÑAN'),
	(15298375, 'P', 1, 3010, 380, 157, 'LORENA DENISSE LEICHTLE BERTIN', NULL, 'F', false, NULL, 'LORENA', 'LEICHTLE'),
	(15304860, 'P', 9, 3011, 381, 150, 'LUZ VALERIA VILLEGAS OJEDA', NULL, 'F', false, NULL, 'LUZ', 'VILLEGAS'),
	(15342974, 'P', 10, 3013, 378, 7, 'ANDRES EMILIO SEPULVEDA JIMENEZ', NULL, 'M', false, NULL, 'ANDRES', 'SEPULVEDA'),
	(15354219, 'P', 2, 3014, 380, 157, 'FRANCISCO ISIDORO HENRIQUEZ MUÑOZ', NULL, 'M', false, NULL, 'FRANCISCO', 'HENRIQUEZ'),
	(15382418, 'P', 18, 3010, 379, 1, 'JUAN LUIS OSSA SANTA CRUZ', NULL, 'M', true, NULL, 'JUAN', 'OSSA'),
	(15382950, 'P', 24, 3013, 377, 137, 'RODRIGO ALFONSO RETTIG VARGAS', NULL, 'M', false, NULL, 'RODRIGO', 'RETTIG'),
	(15385619, 'P', 10, 3006, 381, 150, 'SEBASTIAN ALBERTO FIGUEROA MELO', NULL, 'M', false, NULL, 'SEBASTIAN', 'FIGUEROA'),
	(15388153, 'P', 11, 3009, 378, 7, 'PAMELA ALEJANDRA TOLOZA BURGOS', NULL, 'F', true, NULL, 'PAMELA', 'TOLOZA'),
	(15541513, 'P', 12, 3005, 381, 150, 'PEDRO RODOLFO SCHWEDELBACH PUGA', NULL, 'M', false, NULL, 'PEDRO', 'SCHWEDELBACH'),
	(15550237, 'P', 14, 3009, 381, 150, 'MARIO GARCIA WESTERMEYER', NULL, 'M', false, NULL, 'MARIO', 'GARCIA'),
	(15593050, 'P', 15, 3008, 377, 137, 'CAROLINA BEATRIZ MARTINEZ EBNER', NULL, 'F', false, NULL, 'CAROLINA', 'MARTINEZ'),
	(15610993, 'P', 16, 3003, 377, 6, 'KENSSEL MIGUEL ROJAS CASTRO', NULL, 'M', false, NULL, 'KENSSEL', 'ROJAS'),
	(15616382, 'P', 8, 3008, 378, 7, 'GABRIEL ALEJANDRO BENELLI PAREDES', NULL, 'M', false, NULL, 'GABRIEL', 'BENELLI'),
	(15627805, 'P', 4, 3008, 380, 157, 'NELSON ALEXANDER CARES ORMEÑO', NULL, 'M', false, NULL, 'NELSON', 'CARES'),
	(15645102, 'P', 3, 3010, 380, 157, 'ROSA ALEJANDRA ANDRADE MANQUEMILLA', NULL, 'F', false, NULL, 'ROSA', 'ANDRADE'),
	(15652835, 'P', 13, 3009, 381, 150, 'MARIELA ANDREA FINCHEIRA MASSARDO', NULL, 'F', false, NULL, 'MARIELA', 'FINCHEIRA'),
	(15657601, 'P', 1, 3008, 380, 157, 'ASTRID STEPHANIE ABARZUA BRAVO', NULL, 'F', false, NULL, 'ASTRID', 'ABARZUA'),
	(15661905, 'P', 3, 3009, 380, 157, 'DANIELA PAZ MEDEL SANHUEZA', NULL, 'F', false, NULL, 'DANIELA', 'MEDEL'),
	(15734731, 'P', 20, 3014, 379, 3, 'PEDRO LAMAS GUTIERREZ', NULL, 'M', false, NULL, 'PEDRO', 'LAMAS'),
	(15754384, 'P', 7, 3007, 378, 2, 'CAROLINA ALEJANDRA CONTRERAS RETAMAL', NULL, 'F', false, NULL, 'CAROLINA', 'CONTRERAS'),
	(15787782, 'P', 1, 3006, 380, 157, 'CAROL AROS SEGUEL', NULL, 'F', false, NULL, 'CAROL', 'AROS'),
	(15797290, 'P', 10, 3014, 381, 150, 'DANIEL ANDRES ARZOLA GARRIDO', NULL, 'M', false, NULL, 'DANIEL', 'ARZOLA');
INSERT INTO public.candidato VALUES
	(15965291, 'P', 7, 3011, 378, 7, 'TAMARA YOSELINE VILLEGAS REDLICH', NULL, 'F', true, NULL, 'TAMARA', 'VILLEGAS'),
	(15965296, 'P', 1, 3011, 380, 157, 'PAULINA ALEJANDRA PEREZ RUBILAR', NULL, 'F', false, NULL, 'PAULINA', 'PEREZ'),
	(15968809, 'P', 3, 3011, 380, 157, 'SANDRA ANGELICA MANSILLA ARRIAGADA', NULL, 'F', false, NULL, 'SANDRA', 'MANSILLA'),
	(15989734, 'P', 9, 3007, 378, 4, 'JACQUELINE JARA AVALOS', NULL, 'F', false, NULL, 'JACQUELINE', 'JARA'),
	(16001930, 'P', 26, 3007, 379, 37, 'CARLOS GONZALEZ HERRERA', NULL, 'M', true, NULL, 'CARLOS', 'GONZALEZ'),
	(16008078, 'P', 8, 3007, 378, 2, 'PABLO IGNACIO VERDUGO VERGARA', NULL, 'M', true, NULL, 'PABLO', 'VERDUGO'),
	(16071849, 'P', 29, 3013, 379, 3, 'MARIA JOSE PUIGRREDON FIGUEROA', NULL, 'F', false, NULL, 'MARIA', 'PUIGRREDON'),
	(16095244, 'P', 18, 3013, 381, 150, 'JORGE JOSE OSSANDON SPOERER', NULL, 'M', false, NULL, 'JORGE', 'OSSANDON'),
	(16096392, 'P', 9, 3014, 381, 150, 'PAOLA FRANCESCA CLAVEROL MARTINEZ', NULL, 'F', false, NULL, 'PAOLA', 'CLAVEROL'),
	(16105082, 'P', 1, 3005, 378, 7, 'CARLA NATALIA ALLENDES SOZA', NULL, 'F', true, NULL, 'CARLA', 'ALLENDES'),
	(16163658, 'P', 7, 3012, 381, 150, 'CLAUDIA ALEJANDRA MAC-LEAN BRAVO', NULL, 'F', false, NULL, 'CLAUDIA', 'MAC-LEAN'),
	(16203260, 'P', 17, 3002, 379, 1, 'DANIELA CASTRO ARAYA', NULL, 'F', false, NULL, 'DANIELA', 'CASTRO'),
	(16215470, 'P', 16, 3008, 377, 6, 'PABLO IGNACIO CUEVAS MUÑOZ', NULL, 'M', false, NULL, 'PABLO', 'CUEVAS'),
	(16244695, 'P', 1, 3013, 380, 157, 'ELIZABETH RODRIGUEZ SIERRA', NULL, 'F', false, NULL, 'ELIZABETH', 'RODRIGUEZ'),
	(16245075, 'P', 18, 3002, 379, 1, 'PABLO POMAREDA ECHEVERRIA', NULL, 'M', true, NULL, 'PABLO', 'POMAREDA'),
	(16317068, 'P', 28, 3009, 379, 37, 'JOSE LUIS HIDALGO PINO', NULL, 'M', true, NULL, 'JOSE', 'HIDALGO'),
	(16332679, 'P', 6, 3005, 378, 7, 'CHRISTIAN ANDRES INOSTROZA CABRERA', NULL, 'M', false, NULL, 'CHRISTIAN', 'INOSTROZA'),
	(16349659, 'P', 16, 3010, 377, 137, 'SAMUEL ANDRES GALVEZ DERPICH', NULL, 'M', false, NULL, 'SAMUEL', 'GALVEZ'),
	(16361211, 'P', 10, 3005, 381, 150, 'RAIMUNDO JESUS PALAMARA STEWART', NULL, 'M', false, NULL, 'RAIMUNDO', 'PALAMARA'),
	(16367320, 'P', 16, 3009, 381, 150, 'MARTIN ANDRES KUSCHKE BELANDRINO', NULL, 'M', false, NULL, 'MARTIN', 'KUSCHKE'),
	(16445608, 'P', 14, 3016, 377, 45, 'CLAUDIO ANDRES FERRADA ALARCON', NULL, 'M', false, NULL, 'CLAUDIO', 'FERRADA'),
	(16470244, 'P', 23, 3013, 377, 45, 'ROCIO FERNANDA DONOSO PINEDA', NULL, 'F', false, NULL, 'ROCIO', 'DONOSO'),
	(16486080, 'P', 13, 3001, 377, 143, 'ROMINA CAROLINA RAMOS RODRIGUEZ', NULL, 'F', false, NULL, 'ROMINA', 'RAMOS'),
	(16534062, 'P', 5, 3011, 378, 2, 'PAOLA VELASQUEZ MANSILLA', NULL, 'F', true, NULL, 'PAOLA', 'VELASQUEZ'),
	(16556679, 'P', 10, 3001, 381, 150, 'SEBASTIAN ESTEBAN PARRAGUEZ GONZALEZ', NULL, 'M', false, NULL, 'SEBASTIAN', 'PARRAGUEZ'),
	(16556928, 'P', 2, 3015, 380, 157, 'SERGIO HUMBERTO RIOS GAMBOA', NULL, 'M', false, NULL, 'SERGIO', 'RIOS'),
	(16559282, 'P', 18, 3003, 379, 1, 'VITTORIO GHIGLINO BIANCHI', NULL, 'M', false, NULL, 'VITTORIO', 'GHIGLINO'),
	(16592912, 'P', 19, 3001, 379, 1, 'ROMINA  TERRAZAS BARRAZA', NULL, 'F', false, NULL, 'ROMINA', 'TERRAZAS'),
	(16595075, 'P', 15, 3009, 381, 150, 'STEFANI DEL PILAR ALARCON HERRERA', NULL, 'F', false, NULL, 'STEFANI', 'ALARCON'),
	(16678544, 'P', 23, 3005, 379, 3, 'VIVIANA  NUÑEZ CARRASCO', NULL, 'F', true, NULL, 'VIVIANA', 'NUÑEZ'),
	(16684435, 'P', 14, 3011, 377, 130, 'ERWIN SANDOVAL GALLARDO', NULL, 'M', true, NULL, 'ERWIN', 'SANDOVAL'),
	(16686002, 'P', 7, 3005, 381, 150, 'MARIA DE LOS ANGELES LOPEZ PORFIRI', NULL, 'F', false, NULL, 'MARIA', 'LOPEZ'),
	(16805216, 'P', 15, 3014, 377, 149, 'VALERIA AMANDA OCHOA HINRICHSEN', NULL, 'F', false, NULL, 'VALERIA', 'OCHOA'),
	(16805952, 'P', 7, 3014, 378, 7, 'MADELIN YOSETTE JAU JARAMILLO', NULL, 'F', false, NULL, 'MADELIN', 'JAU'),
	(16837359, 'P', 4, 3007, 380, 157, 'FABIAN ANDRES RIOS LARA', NULL, 'M', false, NULL, 'FABIAN', 'RIOS'),
	(16843356, 'P', 4, 3006, 380, 157, 'CARLOS SEBASTIAN GUERRA MORALES', NULL, 'M', false, NULL, 'CARLOS', 'GUERRA'),
	(16887738, 'P', 13, 3005, 377, 149, 'MARIA SOLEDAD PARDO VERGARA', NULL, 'F', false, NULL, 'MARIA', 'PARDO'),
	(16924700, 'P', 6, 3002, 378, 4, 'FREDDY VIÑALES VIÑALES', NULL, 'M', true, NULL, 'FREDDY', 'VIÑALES'),
	(16937042, 'P', 16, 3015, 377, 190, 'DANIEL ALEXANDRO BUNSTER RUIZ', NULL, 'M', true, NULL, 'DANIEL', 'BUNSTER'),
	(16944809, 'P', 15, 3004, 377, 149, 'CAMILA NIDIA SABANDO VEGA', NULL, 'F', false, NULL, 'CAMILA', 'SABANDO'),
	(16964848, 'P', 4, 3012, 378, 4, 'IGNACIO ANDRES QUIJADA LONCHARIC', NULL, 'M', true, NULL, 'IGNACIO', 'QUIJADA'),
	(16983698, 'P', 19, 3008, 379, 3, 'VICTORIA PINCHEIRA POBLETE', NULL, 'F', false, NULL, 'VICTORIA', 'PINCHEIRA'),
	(17007833, 'P', 3, 3008, 380, 157, 'MIRTHA VICTORIA ENCINA OVALLE', NULL, 'F', false, NULL, 'MIRTHA', 'ENCINA'),
	(17033397, 'P', 21, 3013, 377, 143, 'CAMILA FERNANDA MIRANDA MEDINA', NULL, 'F', false, NULL, 'CAMILA', 'MIRANDA'),
	(17094561, 'P', 9, 3001, 381, 150, 'NINOSKA ESTHER PAYAUNA VILCA', NULL, 'F', false, NULL, 'NINOSKA', 'PAYAUNA'),
	(17139066, 'P', 15, 3006, 377, 6, 'RAISA TAMARA MARTINEZ MUÑOZ', NULL, 'F', false, NULL, 'RAISA', 'MARTINEZ'),
	(17195164, 'P', 3, 3003, 380, 157, 'JESSICA ALEJANDRA LIQUITAY MARTINEZ', NULL, 'F', false, NULL, 'JESSICA', 'LIQUITAY'),
	(17248502, 'P', 5, 3016, 378, 4, 'CAMILA TORRES UMANZOR', NULL, 'F', true, NULL, 'CAMILA', 'TORRES'),
	(17263186, 'P', 8, 3009, 378, 2, 'FELIPE ESTEBAN CALFUNAO VARAS', NULL, 'M', false, NULL, 'FELIPE', 'CALFUNAO'),
	(17281207, 'P', 6, 3009, 380, 157, 'CESAR CAMILO QUIJADA CONTRERAS', NULL, 'M', false, NULL, 'CESAR', 'QUIJADA'),
	(17302195, 'P', 2, 3003, 380, 157, 'JAIR ARIEL JOFRE HENRIQUEZ', NULL, 'M', false, NULL, 'JAIR', 'JOFRE'),
	(17335724, 'P', 16, 3006, 377, 149, 'DANIEL ALFONSO OLIVARES VIDAL', NULL, 'M', true, NULL, 'DANIEL', 'OLIVARES'),
	(17336793, 'P', 20, 3007, 377, 45, 'SEBASTIAN HENRIQUEZ MUÑOZ', NULL, 'M', true, NULL, 'SEBASTIAN', 'HENRIQUEZ'),
	(17355645, 'P', 8, 3005, 381, 150, 'ANTONIO BARCHIESI CHAVEZ', NULL, 'M', false, NULL, 'ANTONIO', 'BARCHIESI'),
	(17366053, 'P', 31, 3009, 382, 99, 'JORGE ALEJANDRO SEPULVEDA ROSALES', NULL, 'M', true, NULL, 'JORGE', 'SEPULVEDA'),
	(17408591, 'P', 12, 3006, 381, 150, 'GABRIEL DOMINGUEZ VALDES', NULL, 'M', false, NULL, 'GABRIEL', 'DOMINGUEZ'),
	(17459257, 'P', 15, 3016, 379, 3, 'CAROLINA  NAVARRETE RUBIO', NULL, 'F', false, NULL, 'CAROLINA', 'NAVARRETE'),
	(17459786, 'P', 13, 3016, 377, 149, 'JOSEFA JAVIERA DEL PILAR BALMACEDA VASQUEZ', NULL, 'F', false, NULL, 'JOSEFA', 'BALMACEDA'),
	(17469709, 'P', 19, 3007, 377, 149, 'CONSTANZA ANDREA PAVEZ ANDAUR', NULL, 'F', false, NULL, 'CONSTANZA', 'PAVEZ'),
	(17492607, 'P', 4, 3003, 380, 157, 'DANIEL FRANCO PATRICIO FLORES SALINAS', NULL, 'M', false, NULL, 'DANIEL', 'FLORES'),
	(17495971, 'P', 17, 3007, 377, 45, 'ROCIO MARGARITA MOYA ROMERO', NULL, 'F', true, NULL, 'ROCIO', 'MOYA'),
	(17516540, 'P', 13, 3008, 377, 45, 'PALOMA IGNACIA ZUÑIGA CERDA', NULL, 'F', false, NULL, 'PALOMA', 'ZUÑIGA'),
	(17590387, 'P', 15, 3013, 381, 150, 'TABITA SARAI SILVA LEIVA', NULL, 'F', false, NULL, 'TABITA', 'SILVA'),
	(17592810, 'P', 11, 3008, 381, 150, 'CLAUDIA POLETTE ORTEGA SAEZ', NULL, 'F', false, NULL, 'CLAUDIA', 'ORTEGA'),
	(17602172, 'P', 10, 3011, 381, 150, 'FERNANDO EDUARDO AUGUSTO SAN CRISTOBAL BRAHM', NULL, 'M', false, NULL, 'FERNANDO', 'SAN CRISTOBAL'),
	(17639434, 'P', 7, 3010, 378, 4, 'CAROLINA  GARCIA VERA', NULL, 'F', false, NULL, 'CAROLINA', 'GARCIA'),
	(17655691, 'P', 3, 3004, 380, 157, 'LILIBETH YUVIXI HUERTA CORTES', NULL, 'F', false, NULL, 'LILIBETH', 'HUERTA'),
	(17742839, 'P', 6, 3010, 378, 2, 'EDUARDO RAUL ALVAREZ VIDAL', NULL, 'M', true, NULL, 'EDUARDO', 'ALVAREZ'),
	(17913563, 'P', 5, 3008, 378, 2, 'NATALY YANIRA NEIRA MONTOYA', NULL, 'F', false, NULL, 'NATALY', 'NEIRA'),
	(17952087, 'P', 5, 3013, 380, 157, 'TAMARA ALEJANDRA RAMIREZ RAMIREZ', NULL, 'F', false, NULL, 'TAMARA', 'RAMIREZ'),
	(18004190, 'P', 3, 3001, 380, 157, 'FRANCISCA ESTER VARGAS PALLERO', NULL, 'F', false, NULL, 'FRANCISCA', 'VARGAS'),
	(18137981, 'P', 10, 3008, 381, 150, 'ALDO SANHUEZA CARRERA', NULL, 'M', false, NULL, 'ALDO', 'SANHUEZA'),
	(18173007, 'P', 16, 3013, 381, 150, 'IGNACIO ANDRES DULGER CASTILLO', NULL, 'M', false, NULL, 'IGNACIO', 'DULGER'),
	(18183011, 'P', 15, 3002, 377, 45, 'LILIANA IVANIA GONZALEZ CORTES', NULL, 'F', false, NULL, 'LILIANA', 'GONZALEZ'),
	(18239161, 'P', 9, 3010, 381, 150, 'BEATRIZ ISABEL HEVIA WILLER', NULL, 'F', false, NULL, 'BEATRIZ', 'HEVIA'),
	(18264399, 'P', 12, 3001, 381, 150, 'LEONARDO ANDRES RAMOS IRIARTE', NULL, 'M', false, NULL, 'LEONARDO', 'RAMOS'),
	(18272557, 'P', 3, 3005, 378, 4, 'JAZMIN MURILLO JORQUERA', NULL, 'F', true, NULL, 'JAZMIN', 'MURILLO'),
	(18282101, 'P', 18, 3011, 379, 1, 'DIEGO SILVA BARRERA', NULL, 'M', false, NULL, 'DIEGO', 'SILVA'),
	(18282601, 'P', 15, 3005, 377, 45, 'VALERIA ANGELICA CARCAMO VIDAL', NULL, 'F', false, NULL, 'VALERIA', 'CARCAMO'),
	(18390168, 'P', 16, 3016, 379, 3, 'JORGE  CARRILLO VILLALOBOS', NULL, 'M', false, NULL, 'JORGE', 'CARRILLO'),
	(18411946, 'P', 1, 3016, 380, 157, 'ETTY SCARLETTE SOLIS CANDIA', NULL, 'F', false, NULL, 'ETTY', 'SOLIS'),
	(18437189, 'P', 21, 3011, 382, 99, 'LISET NOELIA QUILODRAN QUIÑINAO', NULL, 'F', true, NULL, 'LISET', 'QUILODRAN'),
	(18445058, 'P', 6, 3003, 378, 4, 'RAUL ARAYA ZEPEDA', NULL, 'M', false, NULL, 'RAUL', 'ARAYA'),
	(18493072, 'P', 2, 3010, 380, 157, 'ALVARO FABIAN OJEDA ALVARADO', NULL, 'M', false, NULL, 'ALVARO', 'OJEDA'),
	(18531341, 'P', 13, 3013, 381, 150, 'MACARENA DEL CARMEN BRAVO ROJAS', NULL, 'F', false, NULL, 'MACARENA', 'BRAVO'),
	(18720009, 'P', 23, 3009, 377, 45, 'KINTURAY CARLINA MELIN RAPIMAN', NULL, 'F', false, NULL, 'KINTURAY', 'MELIN'),
	(18913745, 'P', 17, 3014, 379, 1, 'LORENA GALLARDO CARDENAS', NULL, 'F', true, NULL, 'LORENA', 'GALLARDO'),
	(19039122, 'P', 4, 3013, 380, 157, 'RAMON ANTONIO LEONARDO HUIDOBRO LEIVA', NULL, 'M', false, NULL, 'RAMON', 'HUIDOBRO'),
	(19077132, 'P', 20, 3004, 379, 3, 'GONZALO  PINOCHET ABARCA', NULL, 'M', false, NULL, 'GONZALO', 'PINOCHET'),
	(19081767, 'P', 19, 3015, 379, 1, 'JOSEFINA LETELIER LARRAIN', NULL, 'F', true, NULL, 'JOSEFINA', 'LETELIER'),
	(19244835, 'P', 26, 3009, 379, 3, 'ARTURO PHILLIPS DORR', NULL, 'M', true, NULL, 'ARTURO', 'PHILLIPS'),
	(19379658, 'P', 5, 3009, 380, 157, 'CONSTANZA ANAIS CARVACHO ESCALONA', NULL, 'F', false, NULL, 'CONSTANZA', 'CARVACHO'),
	(19702708, 'P', 14, 3007, 381, 150, 'MIGUEL ROJAS SOTO', NULL, 'M', false, NULL, 'MIGUEL', 'ROJAS'),
	(19772148, 'P', 13, 3004, 377, 6, 'VALERIA PATRICIA CHACANA ALARCON', NULL, 'F', false, NULL, 'VALERIA', 'CHACANA'),
	(19861939, 'P', 5, 3012, 378, 2, 'VICTORIA TRAPP MOREIRA', NULL, 'F', false, NULL, 'VICTORIA', 'TRAPP'),
	(19952161, 'P', 11, 3002, 381, 150, 'SIOMARA VANESSA MOLINA FLORES', NULL, 'F', false, NULL, 'SIOMARA', 'MOLINA'),
	(20038517, 'P', 18, 3006, 379, 3, 'VALENTIN  MATUS MARTINEZ', NULL, 'M', false, NULL, 'VALENTIN', 'MATUS'),
	(20217726, 'P', 9, 3015, 381, 150, 'FRANCISCA MARINA CAVIERES DIAZ', NULL, 'F', false, NULL, 'FRANCISCA', 'CAVIERES'),
	(20218020, 'P', 10, 3015, 381, 150, 'DIEGO ALBERTO VARGAS CASTILLO', NULL, 'M', false, NULL, 'DIEGO', 'VARGAS'),
	(20318005, 'P', 12, 3011, 381, 150, 'JOSUE NATANAEL MILLANAO PEZO', NULL, 'M', false, NULL, 'JOSUE', 'MILLANAO'),
	(20817869, 'P', 4, 3002, 380, 157, 'JORGE ANDRES ALVAREZ TAPIA', NULL, 'M', false, NULL, 'JORGE', 'ALVAREZ'),
	(21104846, 'P', 12, 3010, 381, 150, 'FERNANDO SEBASTIAN BARRIA OYARZO', NULL, 'M', false, NULL, 'FERNANDO', 'BARRIA'),
	(21139205, 'P', 13, 3012, 377, 6, 'CONSTANZA MONSERRAT AGUILAR HERRERA', NULL, 'F', false, NULL, 'CONSTANZA', 'AGUILAR');


--
-- Data for Name: comuna; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.comuna VALUES
	(2739, 3011, 27, 'Aysén'),
	(2740, 3011, 27, 'Cisnes'),
	(2741, 3011, 27, 'Guaitecas'),
	(2751, 3012, 28, 'Cabo De Hornos'),
	(2752, 3012, 28, 'Antártica'),
	(2508, 3002, 3, 'Antofagasta'),
	(2509, 3002, 3, 'Mejillones'),
	(2510, 3002, 3, 'Sierra Gorda'),
	(2511, 3002, 3, 'Taltal'),
	(2654, 3008, 21, 'Lebu'),
	(2655, 3008, 21, 'Arauco'),
	(2656, 3008, 21, 'Cañete'),
	(2657, 3008, 21, 'Contulmo'),
	(2658, 3008, 21, 'Curanilahue'),
	(2659, 3008, 21, 'Los Alamos'),
	(2660, 3008, 21, 'Tirúa'),
	(2822, 3015, 1, 'Arica'),
	(2823, 3015, 1, 'Camarones'),
	(2661, 3008, 21, 'Los ángeles'),
	(2662, 3008, 21, 'Antuco'),
	(2663, 3008, 21, 'Cabrero'),
	(2664, 3008, 21, 'Laja'),
	(2665, 3008, 21, 'Mulchén'),
	(2666, 3008, 21, 'Nacimiento'),
	(2667, 3008, 21, 'Negrete'),
	(2668, 3008, 21, 'Quilaco'),
	(2669, 3008, 21, 'Quilleco'),
	(2670, 3008, 21, 'San Rosendo'),
	(2671, 3008, 21, 'Santa Bárbara'),
	(2672, 3008, 21, 'Tucapel'),
	(2673, 3008, 21, 'Yumbel'),
	(2674, 3008, 21, 'Alto Biobío'),
	(2579, 3006, 15, 'Rancagua'),
	(2580, 3006, 15, 'Codegua'),
	(2581, 3006, 15, 'Coinco'),
	(2582, 3006, 15, 'Coltauco'),
	(2583, 3006, 15, 'Doñihue'),
	(2584, 3006, 15, 'Graneros'),
	(2585, 3006, 16, 'Las Cabras'),
	(2586, 3006, 15, 'Machalí'),
	(2587, 3006, 15, 'Malloa'),
	(2588, 3006, 15, 'Mostazal'),
	(2589, 3006, 15, 'Olivar'),
	(2590, 3006, 16, 'Peumo'),
	(2591, 3006, 16, 'Pichidegua'),
	(2592, 3006, 15, 'Quinta De Tilcoco'),
	(2593, 3006, 15, 'Rengo'),
	(2594, 3006, 15, 'Requínoa'),
	(2595, 3006, 16, 'San Vicente'),
	(2742, 3011, 27, 'Cochrane'),
	(2743, 3011, 27, 'Ohiggins'),
	(2744, 3011, 27, 'Tortel'),
	(2596, 3006, 16, 'Pichilemu'),
	(2597, 3006, 16, 'La Estrella'),
	(2598, 3006, 16, 'Litueche'),
	(2599, 3006, 16, 'Marchigue'),
	(2600, 3006, 16, 'Navidad'),
	(2601, 3006, 16, 'Paredones'),
	(2622, 3007, 18, 'Cauquenes'),
	(2623, 3007, 18, 'Chanco'),
	(2624, 3007, 18, 'Pelluhue'),
	(2675, 3009, 23, 'Temuco'),
	(2686, 3009, 23, 'Padre Las Casas'),
	(2676, 3009, 23, 'Carahue'),
	(2677, 3009, 23, 'Cunco'),
	(2678, 3009, 23, 'Curarrehue'),
	(2679, 3009, 23, 'Freire'),
	(2680, 3009, 22, 'Galvarino'),
	(2681, 3009, 23, 'Gorbea'),
	(2682, 3009, 22, 'Lautaro'),
	(2683, 3009, 23, 'Loncoche'),
	(2684, 3009, 22, 'Melipeuco'),
	(2685, 3009, 23, 'Nueva Imperial'),
	(2687, 3009, 22, 'Perquenco'),
	(2688, 3009, 23, 'Pitrufquén'),
	(2689, 3009, 23, 'Pucón'),
	(2690, 3009, 23, 'Saavedra'),
	(2691, 3009, 23, 'Teodoro Schmidt'),
	(2692, 3009, 23, 'Toltén'),
	(2693, 3009, 22, 'Vilcún'),
	(2694, 3009, 23, 'Villarrica'),
	(2695, 3009, 23, 'Cholchol'),
	(2793, 3013, 8, 'Colina'),
	(2794, 3013, 8, 'Lampa'),
	(2795, 3013, 8, 'Tiltil'),
	(2520, 3003, 4, 'Chañaral'),
	(2521, 3003, 4, 'Diego De Almagro'),
	(2716, 3010, 26, 'Castro'),
	(2717, 3010, 26, 'Ancud'),
	(2718, 3010, 26, 'Chonchi'),
	(2719, 3010, 26, 'Curaco De Vélez'),
	(2720, 3010, 26, 'Dalcahue'),
	(2721, 3010, 26, 'Puqueldón'),
	(2722, 3010, 26, 'Queilén'),
	(2723, 3010, 26, 'Quellón'),
	(2724, 3010, 26, 'Quemchi'),
	(2725, 3010, 26, 'Quinchao'),
	(2532, 3004, 5, 'Illapel'),
	(2533, 3004, 5, 'Canela'),
	(2534, 3004, 5, 'Los Vilos'),
	(2535, 3004, 5, 'Salamanca'),
	(2602, 3006, 16, 'San Fernando'),
	(2603, 3006, 16, 'Chépica'),
	(2604, 3006, 16, 'Chimbarongo'),
	(2605, 3006, 16, 'Lolol'),
	(2606, 3006, 16, 'Nancagua'),
	(2607, 3006, 16, 'Palmilla'),
	(2608, 3006, 16, 'Peralillo'),
	(2609, 3006, 16, 'Placilla'),
	(2610, 3006, 16, 'Pumanque'),
	(2611, 3006, 16, 'Santa Cruz'),
	(2648, 3008, 20, 'Penco'),
	(2651, 3008, 20, 'Talcahuano'),
	(2652, 3008, 20, 'Tomé'),
	(2653, 3008, 20, 'Hualpén'),
	(2642, 3008, 20, 'Concepción'),
	(2644, 3008, 20, 'Chiguayante'),
	(2645, 3008, 20, 'Florida'),
	(2643, 3008, 20, 'Coronel'),
	(2646, 3008, 20, 'Hualqui'),
	(2647, 3008, 21, 'Lota'),
	(2649, 3008, 20, 'San Pedro De La Paz'),
	(2650, 3008, 20, 'Santa Juana'),
	(2517, 3003, 4, 'Copiapó'),
	(2518, 3003, 4, 'Caldera'),
	(2519, 3003, 4, 'Tierra Amarilla'),
	(2790, 3013, 12, 'Puente Alto'),
	(2791, 3013, 12, 'Pirque'),
	(2792, 3013, 12, 'San José De Maipo'),
	(2737, 3011, 27, 'Coyhaique'),
	(2738, 3011, 27, 'Lago Verde'),
	(2625, 3007, 17, 'Curicó'),
	(2626, 3007, 17, 'Hualañé'),
	(2627, 3007, 17, 'Licantén'),
	(2628, 3007, 17, 'Molina'),
	(2629, 3007, 17, 'Rauco'),
	(2630, 3007, 17, 'Romeral'),
	(2631, 3007, 17, 'Sagrada Familia'),
	(2632, 3007, 17, 'Teno'),
	(2633, 3007, 17, 'Vichuquén'),
	(2826, 3016, 19, 'Chillán'),
	(2827, 3016, 19, 'Bulnes'),
	(2828, 3016, 19, 'Chillán Viejo'),
	(2829, 3016, 19, 'El Carmen'),
	(2830, 3016, 19, 'Pemuco'),
	(2831, 3016, 19, 'Pinto'),
	(2832, 3016, 19, 'Quillón'),
	(2833, 3016, 19, 'San Ignacio'),
	(2834, 3016, 19, 'Yungay'),
	(2512, 3002, 3, 'Calama'),
	(2513, 3002, 3, 'Ollagüe'),
	(2514, 3002, 3, 'San Pedro De Atacama'),
	(2526, 3004, 5, 'La Serena'),
	(2527, 3004, 5, 'Coquimbo'),
	(2528, 3004, 5, 'Andacollo'),
	(2529, 3004, 5, 'La Higuera'),
	(2530, 3004, 5, 'Paihuano'),
	(2531, 3004, 5, 'Vicuña'),
	(2745, 3011, 27, 'Chile Chico'),
	(2746, 3011, 27, 'Río Ibañez'),
	(2522, 3003, 4, 'Vallenar'),
	(2523, 3003, 4, 'Alto Del Carmen'),
	(2524, 3003, 4, 'Freirina'),
	(2525, 3003, 4, 'Huasco'),
	(2501, 3001, 2, 'Iquique'),
	(2502, 3001, 2, 'Alto Hospicio'),
	(2548, 3005, 7, 'Isla De Pascua'),
	(2835, 3016, 19, 'Quirihue'),
	(2836, 3016, 19, 'Cobquecura'),
	(2837, 3016, 19, 'Coelemu'),
	(2838, 3016, 19, 'Ninhue'),
	(2839, 3016, 19, 'Portezuelo'),
	(2840, 3016, 19, 'Ránquil'),
	(2841, 3016, 19, 'Trehuaco'),
	(2536, 3004, 5, 'Ovalle'),
	(2537, 3004, 5, 'Combarbalá'),
	(2538, 3004, 5, 'Monte Patria'),
	(2539, 3004, 5, 'Punitaqui'),
	(2540, 3004, 5, 'Río Hurtado'),
	(2634, 3007, 18, 'Linares'),
	(2635, 3007, 18, 'Colbún'),
	(2636, 3007, 18, 'Longaví'),
	(2637, 3007, 18, 'Parral'),
	(2638, 3007, 18, 'Retiro'),
	(2639, 3007, 18, 'San Javier'),
	(2640, 3007, 18, 'Villa Alegre'),
	(2641, 3007, 18, 'Yerbas Buenas'),
	(2707, 3010, 26, 'Puerto Montt'),
	(2708, 3010, 26, 'Calbuco'),
	(2709, 3010, 26, 'Cochamó'),
	(2710, 3010, 25, 'Fresia'),
	(2711, 3010, 25, 'Frutillar'),
	(2712, 3010, 25, 'Los Muermos'),
	(2713, 3010, 25, 'Llanquihue'),
	(2714, 3010, 26, 'Maullín'),
	(2715, 3010, 25, 'Puerto Varas'),
	(2549, 3005, 6, 'Los Andes'),
	(2550, 3005, 6, 'Calle Larga'),
	(2551, 3005, 6, 'Rinconada'),
	(2552, 3005, 6, 'San Esteban'),
	(2747, 3012, 28, 'Punta Arenas'),
	(2748, 3012, 28, 'Laguna Blanca'),
	(2749, 3012, 28, 'Río Verde'),
	(2750, 3012, 28, 'San Gregorio'),
	(2796, 3013, 14, 'San Bernardo'),
	(2797, 3013, 14, 'Buin'),
	(2798, 3013, 14, 'Calera De Tango'),
	(2799, 3013, 14, 'Paine'),
	(2696, 3009, 22, 'Angol'),
	(2697, 3009, 22, 'Collipulli'),
	(2698, 3009, 22, 'Curacautín'),
	(2699, 3009, 22, 'Ercilla'),
	(2700, 3009, 22, 'Lonquimay'),
	(2701, 3009, 22, 'Los Sauces'),
	(2702, 3009, 22, 'Lumaco'),
	(2703, 3009, 22, 'Purén'),
	(2704, 3009, 22, 'Renaico'),
	(2705, 3009, 22, 'Traiguén'),
	(2706, 3009, 22, 'Victoria'),
	(2575, 3005, 6, 'Quilpué'),
	(2576, 3005, 6, 'Limache'),
	(2577, 3005, 6, 'Olmué'),
	(2578, 3005, 6, 'Villa Alemana'),
	(2800, 3013, 14, 'Melipilla'),
	(2801, 3013, 14, 'Alhué'),
	(2802, 3013, 14, 'Curacaví'),
	(2803, 3013, 14, 'María Pinto'),
	(2804, 3013, 14, 'San Pedro'),
	(2726, 3010, 25, 'Osorno'),
	(2727, 3010, 25, 'Puerto Octay'),
	(2728, 3010, 25, 'Purranque'),
	(2729, 3010, 25, 'Puyehue'),
	(2730, 3010, 25, 'Río Negro'),
	(2731, 3010, 25, 'San Juan De La Costa'),
	(2732, 3010, 25, 'San Pablo'),
	(2733, 3010, 26, 'Chaitén'),
	(2734, 3010, 26, 'Futaleufú'),
	(2735, 3010, 26, 'Hualaihué'),
	(2736, 3010, 26, 'Palena'),
	(2824, 3015, 1, 'Putre'),
	(2825, 3015, 1, 'General Lagos'),
	(2553, 3005, 6, 'La Ligua'),
	(2554, 3005, 6, 'Cabildo'),
	(2555, 3005, 6, 'Papudo'),
	(2556, 3005, 6, 'Petorca'),
	(2557, 3005, 6, 'Zapallar'),
	(2842, 3016, 19, 'San Carlos'),
	(2843, 3016, 19, 'Coihueco'),
	(2844, 3016, 19, 'ñiquén'),
	(2845, 3016, 19, 'San Fabián');
INSERT INTO public.comuna VALUES
	(2846, 3016, 19, 'San Nicolás'),
	(2558, 3005, 6, 'Quillota'),
	(2559, 3005, 6, 'Calera'),
	(2560, 3005, 6, 'Hijuelas'),
	(2561, 3005, 6, 'La Cruz'),
	(2562, 3005, 6, 'Nogales'),
	(2818, 3014, 24, 'La Unión'),
	(2819, 3014, 24, 'Futrono'),
	(2820, 3014, 24, 'Lago Ranco'),
	(2821, 3014, 24, 'Río Bueno'),
	(2563, 3005, 7, 'San Antonio'),
	(2564, 3005, 7, 'Algarrobo'),
	(2565, 3005, 7, 'Cartagena'),
	(2566, 3005, 7, 'El Quisco'),
	(2567, 3005, 7, 'El Tabo'),
	(2568, 3005, 7, 'Santo Domingo'),
	(2569, 3005, 6, 'San Felipe'),
	(2570, 3005, 6, 'Catemu'),
	(2571, 3005, 6, 'Llaillay'),
	(2572, 3005, 6, 'Panquehue'),
	(2573, 3005, 6, 'Putaendo'),
	(2574, 3005, 6, 'Santa María'),
	(2761, 3013, 9, 'Conchalí'),
	(2764, 3013, 9, 'Huechuraba'),
	(2781, 3013, 8, 'Pudahuel'),
	(2782, 3013, 8, 'Quilicura'),
	(2785, 3013, 9, 'Renca'),
	(2758, 3013, 10, 'Santiago'),
	(2760, 3013, 9, 'Cerro Navia'),
	(2765, 3013, 9, 'Independencia'),
	(2774, 3013, 9, 'Lo Prado'),
	(2783, 3013, 9, 'Quinta Normal'),
	(2784, 3013, 9, 'Recoleta'),
	(2759, 3013, 8, 'Cerrillos'),
	(2763, 3013, 8, 'Estación Central'),
	(2776, 3013, 8, 'Maipú'),
	(2770, 3013, 11, 'La Reina'),
	(2771, 3013, 11, 'Las Condes'),
	(2772, 3013, 11, 'Lo Barnechea'),
	(2777, 3013, 10, 'ñuñoa'),
	(2780, 3013, 10, 'Providencia'),
	(2789, 3013, 11, 'Vitacura'),
	(2767, 3013, 12, 'La Florida'),
	(2768, 3013, 10, 'La Granja'),
	(2775, 3013, 10, 'Macul'),
	(2779, 3013, 11, 'Peñalolén'),
	(2786, 3013, 10, 'San Joaquín'),
	(2762, 3013, 13, 'El Bosque'),
	(2766, 3013, 13, 'La Cisterna'),
	(2769, 3013, 12, 'La Pintana'),
	(2773, 3013, 13, 'Lo Espejo'),
	(2778, 3013, 13, 'Pedro Aguirre Cerda'),
	(2787, 3013, 13, 'San Miguel'),
	(2788, 3013, 13, 'San Ramón'),
	(2805, 3013, 14, 'Talagante'),
	(2806, 3013, 14, 'El Monte'),
	(2807, 3013, 14, 'Isla De Maipo'),
	(2808, 3013, 14, 'Padre Hurtado'),
	(2809, 3013, 14, 'Peñaflor'),
	(2612, 3007, 17, 'Talca'),
	(2613, 3007, 17, 'Constitución'),
	(2614, 3007, 17, 'Curepto'),
	(2615, 3007, 17, 'Empedrado'),
	(2616, 3007, 17, 'Maule'),
	(2617, 3007, 17, 'Pelarco'),
	(2618, 3007, 17, 'Pencahue'),
	(2619, 3007, 17, 'Río Claro'),
	(2620, 3007, 17, 'San Clemente'),
	(2621, 3007, 17, 'San Rafael'),
	(2503, 3001, 2, 'Pozo Almonte'),
	(2504, 3001, 2, 'Camiña'),
	(2505, 3001, 2, 'Colchane'),
	(2506, 3001, 2, 'Huara'),
	(2507, 3001, 2, 'Pica'),
	(2753, 3012, 28, 'Porvenir'),
	(2754, 3012, 28, 'Primavera'),
	(2755, 3012, 28, 'Timaukel'),
	(2515, 3002, 3, 'Tocopilla'),
	(2516, 3002, 3, 'María Elena'),
	(2756, 3012, 28, 'Natales'),
	(2757, 3012, 28, 'Torres Del Paine'),
	(2810, 3014, 24, 'Valdivia'),
	(2811, 3014, 24, 'Corral'),
	(2812, 3014, 24, 'Lanco'),
	(2813, 3014, 24, 'Los Lagos'),
	(2814, 3014, 24, 'Mafil'),
	(2815, 3014, 24, 'Mariquina'),
	(2816, 3014, 24, 'Paillaco'),
	(2817, 3014, 24, 'Panguipulli'),
	(2543, 3005, 7, 'Concón'),
	(2545, 3005, 6, 'Puchuncaví'),
	(2546, 3005, 6, 'Quintero'),
	(2547, 3005, 7, 'Viña Del Mar'),
	(2541, 3005, 7, 'Valparaíso'),
	(2542, 3005, 7, 'Casablanca'),
	(2544, 3005, 7, 'Juan Fernández');


--
-- Data for Name: imagen; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.imagen VALUES
	(7, 0, 4, 'USU', 1, NULL, NULL, NULL, '.png', 1600980043, '2020-09-24 17:40:43.731684'),
	(8, 1, 4, 'USU', 1, NULL, NULL, NULL, '.jpg', 1602265410, '2020-10-09 14:43:31.094739'),
	(4, 2, 4, 'USU', 1, NULL, NULL, NULL, '.jpg', 1583847203, '2020-03-10 10:33:24.036709');


--
-- Data for Name: mesa; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.mesa VALUES
	(16, 4, 'P', 3012, 'R. de Magallanes', 'Punta Arenas', 'Magallanes', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:11:31.804446', '2023-04-12 23:11:25.144732'),
	(7, 4, 'P', 3013, 'R. Metropolitana', 'Providencia', 'liceo carmela carvajal 12', 'mesa 25V', 1, 1, 0, 0, 0, '2023-04-18 10:39:28.064644', '2023-04-12 22:59:09.61162'),
	(1, 4, 'P', 3015, 'R. de Arica y Parinacota', 'Arica', 'Arica', 'M ', 1, 1, 0, 0, 0, '2023-04-12 22:53:05.240674', '2023-04-12 22:52:58.700108'),
	(2, 4, 'P', 3001, 'R. de Tarapacá', 'Iquique', 'Iquique', 'M ', 1, 1, 0, 0, 0, '2023-04-12 22:53:21.837329', '2023-04-12 22:53:15.50663'),
	(3, 4, 'P', 3002, 'R. de Antofagasta', 'Tocopilla', 'ANTOFAGASTA', 'M ', 1, 1, 0, 0, 0, '2023-04-12 22:54:02.950268', '2023-04-12 22:53:48.961243'),
	(6, 4, 'P', 3005, 'R. Valparaíso', 'Viña Del Mar', 'VALPARAÍSO', 'M ', 1, 1, 0, 0, 0, '2023-04-14 17:01:08.842908', '2023-04-12 22:58:08.578083'),
	(4, 4, 'P', 3003, 'R. de Atacama', 'Copiapó', 'ATACAMA', 'M ', 1, 1, 0, 0, 0, '2023-04-12 22:56:32.23383', '2023-04-12 22:56:10.428095'),
	(5, 4, 'P', 3004, 'R. de Coquimbo', 'La Serena', 'COQUIMBO', 'M ', 1, 1, 0, 0, 0, '2023-04-12 22:57:53.942009', '2023-04-12 22:57:19.896937'),
	(8, 4, 'P', 3006, 'R. de O’higgins', 'Rancagua', 'OHIGGINS', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:00:30.611463', '2023-04-12 23:00:19.043458'),
	(9, 4, 'P', 3007, 'R. del Maule', 'Cauquenes', 'MAULE', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:01:58.427623', '2023-04-12 23:01:52.666488'),
	(10, 4, 'P', 3016, 'R. del Ñuble', 'Chillán', 'ÑUBLE', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:03:15.538964', '2023-04-12 23:03:09.033085'),
	(11, 4, 'P', 3008, 'R. del Biobío', 'Concepción', 'BIOBIO', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:04:12.538708', '2023-04-12 23:04:05.610992'),
	(12, 4, 'P', 3009, 'R. de la Araucania', 'Pucón', 'ARAUCANIA', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:05:19.674964', '2023-04-12 23:05:12.723188'),
	(13, 4, 'P', 3014, 'R. de Los Rios', 'Futrono', 'los rios', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:07:11.363941', '2023-04-12 23:07:05.565436'),
	(14, 4, 'P', 3010, 'R. de Los Lagos', 'Puerto Montt', 'los lagos', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:09:54.425936', '2023-04-12 23:09:48.898445'),
	(15, 4, 'P', 3011, 'R. de Aysén', 'Coyhaique', 'aysen', 'M ', 1, 1, 0, 0, 0, '2023-04-12 23:10:43.183099', '2023-04-12 23:10:38.90267');


--
-- Data for Name: pacto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.pacto VALUES
	(377, 'UPC', 'UNIDAD PARA CHILE'),
	(378, 'TPC', 'TODO POR CHILE'),
	(379, 'CS', 'CHILE SEGURO'),
	(382, 'SP', 'SIN PACTO'),
	(999, 'IND', 'INDEPENDIENTE'),
	(380, 'PDG', 'P. DE LA GENTE'),
	(381, 'PR', 'P. REPUBLICANO');


--
-- Data for Name: partido; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.partido VALUES
	(1, 'RENOVACION NACIONAL', 'RN'),
	(2, 'PARTIDO DEMOCRATA CRISTIANO', 'PDC'),
	(3, 'UNION DEMOCRATA INDEPENDIENTE', 'UDI'),
	(4, 'PARTIDO POR LA DEMOCRACIA', 'PPD'),
	(5, 'PARTIDO SOCIALISTA DE CHILE', 'PS'),
	(6, 'PARTIDO COMUNISTA DE CHILE', 'PCCH'),
	(7, 'PARTIDO RADICAL DE CHILE', 'PR'),
	(45, 'REVOLUCION DEMOCRATICA', 'RD'),
	(99, 'INDEPENDIENTES', 'IND'),
	(130, 'FEDERACION REGIONALISTA VERDE SOCIAL', 'FREVS'),
	(137, 'PARTIDO LIBERAL DE CHILE', 'PL'),
	(149, 'CONVERGENCIA SOCIAL', 'CS'),
	(157, 'PARTIDO DE LA GENTE', 'PDG'),
	(190, 'ACCIÓN HUMANISTA', 'AH'),
	(150, 'PARTIDO REPUBLICANO DE CHILE', 'REP'),
	(37, 'EVOLUCION POLITICA', 'EVOP'),
	(143, 'COMUNES', 'COM');


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.region VALUES
	(3015, 'Región de Arica y Parinacota', 'XV'),
	(3001, 'Región de Tarapacá', 'I'),
	(3002, 'Región de Antofagasta', 'II'),
	(3003, 'Región de Atacama', 'III'),
	(3004, 'Región de Coquimbo', 'IV'),
	(3005, 'Región de Valparaíso', 'V'),
	(3013, 'Región Metropolitana', 'RM'),
	(3006, 'Región de O’higgins', 'VI'),
	(3007, 'Región del Maule', 'VII'),
	(3016, 'Región de Ñuble', 'XVI'),
	(3008, 'Región del Biobio', 'VIII'),
	(3009, 'Región de la Araucania', 'IX'),
	(3014, 'Región de Los Rios', 'XIV'),
	(3010, 'Región de Los Lagos', 'X'),
	(3011, 'Región de Aysén', 'XI'),
	(3012, 'Región de Magallanes', 'XII');


--
-- Data for Name: swich; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.swich VALUES
	(1, 2, 0, 0, 0, 0, '0', '2023-04-18 11:11:46.733707', 1);


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.usuario VALUES
	(57, 'OP', 1, 'n', 'Prensa 15', 'prensa15', 'cnn', 1, '2022-09-01 14:30:14.271053', '2022-09-01 14:30:14.271053'),
	(58, 'AD', 1, 'n', 'Gabriela Peña', 'gpena', 'cnn2022', 1, '2022-09-01 14:30:37.992148', '2022-09-01 14:30:37.992148'),
	(60, 'VZ', 1, 'n', 'Tv', 'tv', 'tv', 1, '2022-09-02 08:25:13.05714', '2022-09-02 08:25:13.05714'),
	(59, 'AD', 1, 'n', 'Paula Fariña', 'pfarina', 'cnn2022', 1, '2022-09-01 14:32:09.868521', '2022-09-01 14:32:09.868521'),
	(61, 'AD', 1, 'n', 'Camila Quintanilla', 'cquintanilla', 'cnn2022', 1, '2022-09-02 09:19:07.923959', '2022-09-02 09:19:07.923959'),
	(29, 'OP', 1, 'n', 'Prensa 1', 'prensa1', 'cnn', 1, '2021-05-15 19:06:10.580988', '2021-05-15 19:06:10.580988'),
	(30, 'OP', 1, 'n', 'Prensa 2', 'prensa2', 'cnn', 1, '2021-05-16 12:02:19.180109', '2021-05-16 12:02:19.180109'),
	(4, 'AD', 1, 'm', 'Ivan Villarroel', 'ivan.villarroel@warnermedia.com', 'leon', 3, '2020-03-10 10:33:05.700099', '2020-03-10 10:33:05.700099'),
	(31, 'OP', 1, 'n', 'Prensa 3', 'prensa3', 'cnn', 1, '2021-05-16 12:09:04.143502', '2021-05-16 12:09:04.143502'),
	(32, 'OP', 1, 'n', 'Prensa 4', 'prensa4', 'cnn', 1, '2021-05-16 12:30:59.800617', '2021-05-16 12:30:59.800617'),
	(33, 'OP', 1, 'n', 'Prensa 5', 'prensa5', 'cnn', 1, '2021-05-16 12:32:27.107286', '2021-05-16 12:32:27.107286'),
	(34, 'OP', 1, 'n', 'Prensa 6', 'prensa6', 'cnn', 1, '2021-05-16 12:32:44.65376', '2021-05-16 12:32:44.65376'),
	(35, 'OP', 1, 'n', 'Prensa 7', 'prensa7', 'cnn', 1, '2021-05-16 12:33:04.883941', '2021-05-16 12:33:04.883941'),
	(36, 'OP', 1, 'n', 'Prensa 8', 'prensa8', 'cnn', 1, '2021-05-16 12:33:26.60897', '2021-05-16 12:33:26.60897'),
	(37, 'OP', 1, 'n', 'Prensa 9', 'prensa9', 'cnn', 1, '2021-05-16 12:33:42.400539', '2021-05-16 12:33:42.400539'),
	(38, 'OP', 1, 'n', 'Prensa 10', 'prensa10', 'cnn', 1, '2021-05-16 12:34:02.97873', '2021-05-16 12:34:02.97873'),
	(53, 'OP', 1, 'n', 'Prensa 11', 'prensa11', 'cnn', 1, '2022-09-01 14:28:40.919892', '2022-09-01 14:28:40.919892'),
	(54, 'OP', 1, 'n', 'Prensa 12', 'prensa12', 'cnn', 1, '2022-09-01 14:29:08.372841', '2022-09-01 14:29:08.372841'),
	(55, 'OP', 1, 'n', 'Prensa 13', 'prensa13', 'cnn', 1, '2022-09-01 14:29:25.917857', '2022-09-01 14:29:25.917857'),
	(56, 'OP', 1, 'n', 'Prensa 14', 'prensa14', 'cnn', 1, '2022-09-01 14:29:49.173472', '2022-09-01 14:29:49.173472');


--
-- Data for Name: voto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO public.voto VALUES
	(140, 6273728, 3, 0),
	(141, 7166120, 3, 0),
	(142, 7337534, 3, 0),
	(143, 8577508, 3, 0),
	(144, 9542426, 3, 0),
	(145, 10298243, 3, 0),
	(146, 10952965, 3, 0),
	(147, 11721751, 3, 0),
	(148, 13014404, 3, 0),
	(149, 13289217, 3, 0),
	(150, 13645497, 3, 0),
	(151, 14109173, 3, 0),
	(152, 14499183, 3, 0),
	(153, 15085033, 3, 0),
	(154, 16203260, 3, 0),
	(155, 16245075, 3, 0),
	(156, 16924700, 3, 0),
	(157, 18183011, 3, 0),
	(158, 19952161, 3, 0),
	(159, 20817869, 3, 0),
	(160, 4102104, 4, 0),
	(161, 5175640, 4, 0),
	(162, 6622672, 4, 0),
	(163, 7134978, 4, 0),
	(164, 7221693, 4, 0),
	(165, 7921245, 4, 0),
	(166, 10609419, 4, 0),
	(167, 11333630, 4, 0),
	(168, 11724787, 4, 0),
	(169, 11862663, 4, 0),
	(170, 12940592, 4, 0),
	(171, 13873240, 4, 0),
	(172, 14397114, 4, 0),
	(173, 15028221, 4, 0),
	(174, 15610993, 4, 0),
	(175, 16559282, 4, 0),
	(176, 17195164, 4, 0),
	(177, 17302195, 4, 0),
	(178, 17492607, 4, 0),
	(179, 18445058, 4, 0),
	(180, 4678791, 5, 0),
	(181, 8005140, 5, 0),
	(182, 8879813, 5, 0),
	(183, 9330515, 5, 0),
	(184, 9727794, 5, 0),
	(185, 9884617, 5, 0),
	(186, 9980104, 5, 0),
	(187, 10673960, 5, 0),
	(188, 12096351, 5, 0),
	(189, 12219704, 5, 0),
	(190, 13177657, 5, 0),
	(191, 13330025, 5, 0),
	(192, 13330031, 5, 0),
	(193, 13533486, 5, 0),
	(194, 14005883, 5, 0),
	(195, 14062522, 5, 0),
	(196, 16944809, 5, 0),
	(197, 17655691, 5, 0),
	(198, 19077132, 5, 0),
	(199, 19772148, 5, 0),
	(100, 4738039, 1, 0),
	(101, 4847637, 1, 0),
	(102, 5501238, 1, 0),
	(103, 7024697, 1, 0),
	(104, 7214480, 1, 0),
	(105, 9072069, 1, 0),
	(106, 10728965, 1, 0),
	(107, 11505821, 1, 0),
	(108, 11888643, 1, 0),
	(109, 12608155, 1, 0),
	(110, 13412628, 1, 0),
	(111, 13415976, 1, 0),
	(112, 13863895, 1, 0),
	(113, 13999294, 1, 0),
	(114, 14102768, 1, 0),
	(115, 16556928, 1, 0),
	(116, 16937042, 1, 0),
	(117, 19081767, 1, 0),
	(118, 20217726, 1, 0),
	(119, 20218020, 1, 0),
	(120, 4227646, 2, 0),
	(121, 5348422, 2, 0),
	(122, 5595090, 2, 0),
	(123, 6720037, 2, 0),
	(124, 8512604, 2, 0),
	(125, 9225586, 2, 0),
	(126, 10586276, 2, 0),
	(127, 11841040, 2, 0),
	(128, 12447501, 2, 0),
	(129, 13416397, 2, 0),
	(130, 13991861, 2, 0),
	(131, 14271718, 2, 0),
	(132, 15002239, 2, 0),
	(133, 15017736, 2, 0),
	(134, 16486080, 2, 0),
	(135, 16556679, 2, 0),
	(136, 16592912, 2, 0),
	(137, 17094561, 2, 0),
	(138, 18004190, 2, 0),
	(139, 18264399, 2, 0),
	(200, 4386100, 6, 0),
	(201, 4721073, 6, 0),
	(202, 5344795, 6, 0),
	(203, 6642777, 6, 0),
	(204, 6687951, 6, 0),
	(205, 7008999, 6, 0),
	(206, 8500066, 6, 0),
	(208, 9012679, 6, 0),
	(209, 13068925, 6, 0),
	(210, 13544441, 6, 0),
	(211, 13997900, 6, 0),
	(212, 14138006, 6, 0),
	(213, 14447560, 6, 0),
	(214, 15541513, 6, 0),
	(216, 16332679, 6, 0),
	(217, 16361211, 6, 0),
	(218, 16678544, 6, 0),
	(219, 16686002, 6, 0),
	(220, 16887738, 6, 0),
	(222, 18272557, 6, 0),
	(223, 18282601, 6, 0),
	(225, 4665925, 7, 0),
	(227, 7040289, 7, 0),
	(229, 7563445, 7, 0),
	(232, 8771203, 7, 0),
	(233, 9024616, 7, 0),
	(230, 8077485, 7, 0),
	(215, 16105082, 6, 1),
	(221, 17355645, 6, 1),
	(231, 8680065, 7, 0),
	(226, 6069264, 7, 2),
	(207, 8576244, 6, 2),
	(235, 10800928, 7, 154),
	(234, 10055396, 7, 190),
	(239, 13252861, 7, 0),
	(240, 13684095, 7, 0),
	(241, 14188439, 7, 0),
	(242, 15342974, 7, 0),
	(243, 15382950, 7, 0),
	(245, 16095244, 7, 0),
	(247, 16470244, 7, 0),
	(248, 17033397, 7, 0),
	(249, 17590387, 7, 0),
	(251, 18173007, 7, 0),
	(254, 4384763, 8, 0),
	(255, 6101810, 8, 0),
	(256, 6651899, 8, 0),
	(257, 7212608, 8, 0),
	(258, 8525872, 8, 0),
	(259, 10773416, 8, 0),
	(260, 11276885, 8, 0),
	(261, 11278401, 8, 0),
	(262, 12232600, 8, 0),
	(263, 12911092, 8, 0),
	(264, 12913235, 8, 0),
	(265, 13033031, 8, 0),
	(266, 13561003, 8, 0),
	(267, 15385619, 8, 0),
	(268, 15787782, 8, 0),
	(269, 16843356, 8, 0),
	(270, 17139066, 8, 0),
	(271, 17335724, 8, 0),
	(272, 17408591, 8, 0),
	(273, 20038517, 8, 0),
	(274, 4388742, 9, 0),
	(275, 4831889, 9, 0),
	(276, 5093082, 9, 0),
	(277, 6163989, 9, 0),
	(278, 8087560, 9, 0),
	(279, 8158868, 9, 0),
	(280, 8363183, 9, 0),
	(281, 9433193, 9, 0),
	(282, 9480453, 9, 0),
	(283, 9754223, 9, 0),
	(284, 10483956, 9, 0),
	(285, 12522490, 9, 0),
	(286, 13205274, 9, 0),
	(287, 13231889, 9, 0),
	(288, 13600685, 9, 0),
	(289, 14200292, 9, 0),
	(290, 14288560, 9, 0),
	(291, 14348730, 9, 0),
	(292, 15126874, 9, 0),
	(293, 15754384, 9, 0),
	(294, 15989734, 9, 0),
	(295, 16001930, 9, 0),
	(296, 16008078, 9, 0),
	(297, 16837359, 9, 0),
	(298, 17336793, 9, 0),
	(299, 17469709, 9, 0),
	(300, 17495971, 9, 0),
	(301, 19702708, 9, 0),
	(302, 3929106, 10, 0),
	(303, 5106131, 10, 0),
	(304, 5537755, 10, 0),
	(305, 5797138, 10, 0),
	(306, 6317119, 10, 0),
	(307, 7460922, 10, 0),
	(308, 8680695, 10, 0),
	(309, 9043304, 10, 0),
	(310, 9813500, 10, 0),
	(311, 10426670, 10, 0),
	(312, 11533584, 10, 0),
	(313, 11863307, 10, 0),
	(314, 16445608, 10, 0),
	(315, 17248502, 10, 0),
	(316, 17459257, 10, 0),
	(317, 17459786, 10, 0),
	(318, 18390168, 10, 0),
	(319, 18411946, 10, 0),
	(320, 5756427, 11, 0),
	(321, 8226720, 11, 0),
	(322, 9243488, 11, 0),
	(323, 10254641, 11, 0),
	(324, 10899219, 11, 0),
	(325, 10980343, 11, 0),
	(326, 12086253, 11, 0),
	(327, 12974034, 11, 0),
	(328, 13143472, 11, 0),
	(329, 15593050, 11, 0),
	(330, 15616382, 11, 0),
	(331, 15627805, 11, 0),
	(332, 15657601, 11, 0),
	(333, 16215470, 11, 0),
	(334, 16983698, 11, 0),
	(335, 17007833, 11, 0),
	(336, 17516540, 11, 0),
	(337, 17592810, 11, 0),
	(338, 17913563, 11, 0),
	(339, 18137981, 11, 0),
	(340, 7701180, 12, 0),
	(341, 7724817, 12, 0),
	(342, 8196077, 12, 0),
	(343, 9021531, 12, 0),
	(344, 9282652, 12, 0),
	(345, 10457308, 12, 0),
	(346, 10915395, 12, 0),
	(347, 11591149, 12, 0),
	(348, 11686898, 12, 0),
	(349, 12030611, 12, 0),
	(350, 12192925, 12, 0),
	(351, 12331341, 12, 0),
	(352, 12527957, 12, 0),
	(353, 12628019, 12, 0),
	(354, 12743015, 12, 0),
	(355, 13319116, 12, 0),
	(356, 14166738, 12, 0),
	(357, 15214271, 12, 0),
	(358, 15388153, 12, 0),
	(359, 15550237, 12, 0);
INSERT INTO public.voto VALUES
	(360, 15652835, 12, 0),
	(361, 15661905, 12, 0),
	(362, 16317068, 12, 0),
	(363, 16367320, 12, 0),
	(364, 16595075, 12, 0),
	(365, 17263186, 12, 0),
	(366, 17281207, 12, 0),
	(367, 17366053, 12, 0),
	(368, 18720009, 12, 0),
	(369, 19244835, 12, 0),
	(370, 19379658, 12, 0),
	(371, 5280504, 13, 0),
	(252, 18531341, 7, 0),
	(238, 12892091, 7, 0),
	(253, 19039122, 7, 0),
	(250, 17952087, 7, 0),
	(237, 12068971, 7, 105),
	(236, 11483597, 7, 0),
	(372, 6530889, 13, 0),
	(373, 7011719, 13, 0),
	(374, 7143674, 13, 0),
	(375, 8094886, 13, 0),
	(376, 8897628, 13, 0),
	(377, 10219549, 13, 0),
	(378, 10486198, 13, 0),
	(379, 10488532, 13, 0),
	(380, 10836331, 13, 0),
	(381, 10982517, 13, 0),
	(382, 13817897, 13, 0),
	(383, 14036888, 13, 0),
	(384, 15354219, 13, 0),
	(385, 15734731, 13, 0),
	(386, 15797290, 13, 0),
	(387, 16096392, 13, 0),
	(388, 16805216, 13, 0),
	(389, 16805952, 13, 0),
	(390, 18913745, 13, 0),
	(391, 6928545, 14, 0),
	(392, 7832398, 14, 0),
	(393, 7907269, 14, 0),
	(394, 8143228, 14, 0),
	(395, 8418777, 14, 0),
	(396, 8692707, 14, 0),
	(397, 8722148, 14, 0),
	(398, 11926917, 14, 0),
	(399, 12713168, 14, 0),
	(400, 13850107, 14, 0),
	(401, 13901251, 14, 0),
	(402, 15298375, 14, 0),
	(403, 15382418, 14, 0),
	(404, 15645102, 14, 0),
	(405, 16349659, 14, 0),
	(406, 17639434, 14, 0),
	(407, 17742839, 14, 0),
	(408, 18239161, 14, 0),
	(409, 18493072, 14, 0),
	(410, 21104846, 14, 0),
	(411, 3244592, 15, 0),
	(412, 8687334, 15, 0),
	(413, 9054033, 15, 0),
	(414, 9065357, 15, 0),
	(415, 9853314, 15, 0),
	(416, 9893634, 15, 0),
	(417, 10335642, 15, 0),
	(418, 10933275, 15, 0),
	(419, 11890533, 15, 0),
	(420, 12001523, 15, 0),
	(421, 13244595, 15, 0),
	(422, 15304860, 15, 0),
	(423, 15965291, 15, 0),
	(424, 15965296, 15, 0),
	(425, 15968809, 15, 0),
	(426, 16534062, 15, 0),
	(427, 16684435, 15, 0),
	(428, 17602172, 15, 0),
	(429, 18282101, 15, 0),
	(430, 18437189, 15, 0),
	(431, 20318005, 15, 0),
	(432, 4814138, 16, 0),
	(433, 5842527, 16, 0),
	(434, 7406584, 16, 0),
	(435, 7689686, 16, 0),
	(436, 8233596, 16, 0),
	(437, 9313223, 16, 0),
	(438, 10050616, 16, 0),
	(439, 10676684, 16, 0),
	(440, 11401637, 16, 0),
	(441, 12253804, 16, 0),
	(442, 12382102, 16, 0),
	(443, 12722201, 16, 0),
	(444, 13409217, 16, 0),
	(445, 14476262, 16, 0),
	(446, 14744752, 16, 0),
	(447, 16163658, 16, 0),
	(448, 16964848, 16, 0),
	(449, 19861939, 16, 0),
	(450, 21139205, 16, 0),
	(228, 7077432, 7, 89),
	(246, 16244695, 7, 236),
	(224, 4107128, 7, 0),
	(244, 16071849, 7, 0);


--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.candidato_candidato_id_seq', 1, false);


--
-- Name: candidato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.candidato_id_seq', 1, true);


--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.comuna_comuna_id_seq', 1, false);


--
-- Name: comuna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.comuna_id_seq', 1, false);


--
-- Name: imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.imagen_id_seq', 9, true);


--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.imagen_imagen_id_seq', 1, false);


--
-- Name: mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.mesa_id_seq', 18, true);


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.mesa_mesa_id_seq', 1, false);


--
-- Name: pacto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.pacto_id_seq', 1, false);


--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.pacto_pacto_id_seq', 1, false);


--
-- Name: partido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.partido_id_seq', 1, true);


--
-- Name: partido_partido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.partido_partido_id_seq', 1, false);


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.region_id_seq', 1, false);


--
-- Name: region_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.region_region_id_seq', 1, false);


--
-- Name: swich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.swich_id_seq', 1, true);


--
-- Name: swich_swich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.swich_swich_id_seq', 1, false);


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.usuario_id_seq', 61, true);


--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.usuario_usuario_id_seq', 1, false);


--
-- Name: voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.voto_id_seq', 500, true);


--
-- Name: voto_voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('public.voto_voto_id_seq', 1, false);


--
-- Name: candidato candidato_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.candidato
    ADD CONSTRAINT candidato_pkey PRIMARY KEY (candidato_id);


--
-- Name: comuna comuna_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.comuna
    ADD CONSTRAINT comuna_pkey PRIMARY KEY (comuna_id);


--
-- Name: imagen imagen_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.imagen
    ADD CONSTRAINT imagen_pkey PRIMARY KEY (imagen_id);


--
-- Name: mesa mesa_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.mesa
    ADD CONSTRAINT mesa_pkey PRIMARY KEY (mesa_id);


--
-- Name: pacto pacto_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.pacto
    ADD CONSTRAINT pacto_pkey PRIMARY KEY (pacto_id);


--
-- Name: partido partido_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.partido
    ADD CONSTRAINT partido_pkey PRIMARY KEY (partido_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);


--
-- Name: swich swich_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.swich
    ADD CONSTRAINT swich_pkey PRIMARY KEY (swich_id);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (usuario_id);


--
-- Name: voto voto_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.voto
    ADD CONSTRAINT voto_pkey PRIMARY KEY (voto_id);


--
-- Name: voto candidato_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.voto
    ADD CONSTRAINT candidato_id_fk FOREIGN KEY (candidato_id) REFERENCES public.candidato(candidato_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: candidato candidato_pacto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.candidato
    ADD CONSTRAINT candidato_pacto_id_fkey FOREIGN KEY (pacto_id) REFERENCES public.pacto(pacto_id) ON DELETE CASCADE;


--
-- Name: candidato candidato_partido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.candidato
    ADD CONSTRAINT candidato_partido_id_fkey FOREIGN KEY (partido_id) REFERENCES public.partido(partido_id) ON DELETE CASCADE;


--
-- Name: comuna comuna_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.comuna
    ADD CONSTRAINT comuna_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.region(region_id) ON DELETE RESTRICT;


--
-- Name: voto mesa_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.voto
    ADD CONSTRAINT mesa_id_fk FOREIGN KEY (mesa_id) REFERENCES public.mesa(mesa_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mesa mesa_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY public.mesa
    ADD CONSTRAINT mesa_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(usuario_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO app_vav;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

