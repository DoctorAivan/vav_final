--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: imagen_eliminar(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION imagen_eliminar(in_imagen_id bigint, in_imagen_objeto bigint) RETURNS TABLE(imagen_id bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying)
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

CREATE FUNCTION imagen_listado(in_imagen_objeto bigint, in_imagen_tipo character varying) RETURNS TABLE(imagen_id bigint, imagen_orden bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying, imagen_cambio bigint)
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

CREATE FUNCTION imagen_nueva(in_imagen_id bigint, in_imagen_objeto bigint, in_imagen_tipo character varying, in_imagen_extension character varying, in_imagen_cambio bigint) RETURNS bigint
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

CREATE FUNCTION mesa_activar(in_mesa_id bigint, in_mesa_numero character varying) RETURNS bigint
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

CREATE FUNCTION mesa_candidato_guardar(in_candidato_id bigint, in_candidato_nombres character varying, in_candidato_apellidos character varying) RETURNS bigint
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

CREATE FUNCTION mesa_candidatos(in_mesa_id bigint) RETURNS TABLE(voto_id bigint, voto_total smallint, candidato_id bigint, candidato_nombre character varying, candidato_nombres character varying, candidato_apellidos character varying, candidato_lista character varying)
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

CREATE FUNCTION mesa_candidatos_swich(in_mesa_id bigint) RETURNS TABLE(voto_id bigint, voto_total smallint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, candidato_genero character varying, candidato_independiente boolean, candidato_lista character varying, partido_codigo character varying, partido_id bigint, pacto_codigo character varying, pacto_id bigint)
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
			partido.partido_id,
			pacto.pacto_nombre,
			pacto.pacto_id
	
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

		ORDER BY candidato.candidato_orden ASC;
	
	END $$;


ALTER FUNCTION public.mesa_candidatos_swich(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_contar_total(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_contar_total() RETURNS TABLE(objetos bigint)
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
-- Name: mesa_contar_total_switch(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_contar_total_switch() RETURNS TABLE(objetos bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

		SELECT
			count(mesa_id) AS objetos 

		FROM
			mesa
		
		WHERE
            mesa.mesa_estado = 1
	    ;

	END $$;


ALTER FUNCTION public.mesa_contar_total_switch() OWNER TO postgres;

--
-- Name: mesa_destacada(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_destacada(in_mesa_id bigint) RETURNS bigint
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

CREATE FUNCTION mesa_detalles(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_orden smallint, mesa_estado smallint, mesa_destacada smallint, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
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

CREATE FUNCTION mesa_detalles_swich(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
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

CREATE FUNCTION mesa_editar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_nombre character varying, in_mesa_numero character varying, in_mesa_region character varying, in_mesa_ciudad character varying, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_ar_blanco bigint, in_mesa_voto_ar_nulo bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint, in_mesa_voto_cmcc_blanco bigint, in_mesa_voto_cmcc_nulo bigint) RETURNS bigint
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

CREATE FUNCTION mesa_eliminar(in_mesa_id bigint) RETURNS bigint
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

DROP FUNCTION mesa_guardar;

CREATE FUNCTION mesa_guardar(
	in_mesa_id bigint,
	in_usuario_id bigint,
	in_mesa_estado bigint,
	in_mesa_comuna character varying,
	in_mesa_local character varying,
	in_mesa_numero character varying,
	in_mesa_publicado character varying,
	)
	RETURNS bigint
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
			mesa_cambio = now(),
			mesa_publicado = in_mesa_publicado

		WHERE

			mesa_id = in_mesa_id

		;

		RETURN 1;

	END $$;


ALTER FUNCTION public.mesa_guardar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_comuna character varying, in_mesa_local character varying, in_mesa_numero character varying) OWNER TO app_vav;

--
-- Name: mesa_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_listado(in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
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
	        mesa.mesa_cambio DESC
	
	    LIMIT in_limit OFFSET in_offset
	    ;
	
	END $$;


ALTER FUNCTION public.mesa_listado(in_limit integer, in_offset integer) OWNER TO app_vav;

--
-- Name: mesa_nuevo(bigint, character varying, bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) RETURNS bigint
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
    --	INSERT INTO voto (candidato_id, mesa_id, voto_total) SELECT candidato_id, in_mesa_id, 0 FROM candidato WHERE candidato_tipo = in_mesa_tipo;

        RETURN in_mesa_id;
	        
	END $$;


ALTER FUNCTION public.mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) OWNER TO app_vav;

--
-- Name: mesa_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_obtener_datos(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_destacada smallint, mesa_estado smallint, mesa_nombre character varying, mesa_numero character varying, mesa_region character varying, mesa_ciudad character varying, mesa_voto_a smallint, mesa_voto_r smallint, mesa_voto_ar_blanco smallint, mesa_voto_ar_nulo smallint, mesa_voto_cm smallint, mesa_voto_cc smallint, mesa_voto_cmcc_blanco smallint, mesa_voto_cmcc_nulo smallint)
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
-- Name: mesa_switch_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_switch_listado(in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_cambio timestamp without time zone, mesa_publicado character varying, usuario_nombre character varying)
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
			mesa.mesa_cambio,
			mesa.mesa_publicado,
			usuario.usuario_nombre
	
	    FROM
	        mesa,
	        usuario
	        
		WHERE
			mesa.usuario_id = usuario.usuario_id AND
            mesa.mesa_estado = 1
	
	    ORDER BY
	        mesa.mesa_publicado DESC
	
	    LIMIT in_limit OFFSET in_offset
	    ;
	
	END $$;


ALTER FUNCTION public.mesa_switch_listado(in_limit integer, in_offset integer) OWNER TO app_vav;

--
-- Name: mesa_usuario_contar_total(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_usuario_contar_total(in_usuario_id bigint) RETURNS TABLE(objetos bigint)
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

CREATE FUNCTION mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
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

CREATE FUNCTION mesa_voto(in_mesa_id bigint, in_voto_id bigint, in_voto_total bigint) RETURNS bigint
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

CREATE FUNCTION objeto_estado(in_objeto_id bigint, in_objeto_tipo character varying) RETURNS bigint
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

CREATE FUNCTION swich_actual() RETURNS TABLE(swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint)
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
-- Name: swich_consolidados_mesas(character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_consolidados_mesas(in_mesa_tipo character varying, in_mesa_zona bigint) RETURNS TABLE(votos_total bigint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, candidato_independiente boolean, partido_id bigint, pacto_id bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

			SELECT
				sum(voto.voto_total) as votos_total,
				candidato.candidato_id,
				candidato.candidato_nombres,
				candidato.candidato_apellidos,
				candidato.candidato_independiente,
				partido.partido_id,
				pacto.pacto_id

			FROM
				mesa,
				voto,
				candidato,
				partido,
				pacto

			WHERE
				mesa.mesa_tipo = in_mesa_tipo AND
				mesa.mesa_estado IN(1,2) AND
				mesa.mesa_zona = in_mesa_zona AND
				voto.mesa_id = mesa.mesa_id AND
				candidato.candidato_id = voto.candidato_id AND
				partido.partido_id = candidato.partido_id AND
				pacto.pacto_id = candidato.pacto_id

			group by
				candidato.candidato_id,
				partido.partido_id,
				pacto.pacto_id
			
			ORDER BY
				votos_total DESC
	    ;

	END $$;


ALTER FUNCTION public.swich_consolidados_mesas(in_mesa_tipo character varying, in_mesa_zona bigint) OWNER TO postgres;

--
-- Name: swich_consolidados_totales(character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_consolidados_totales(in_mesa_tipo character varying, in_mesa_zona bigint) RETURNS TABLE(total bigint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

				SELECT
					COUNT( mesa.mesa_id ) as total

				FROM
					mesa
				
				WHERE
					mesa.mesa_tipo = in_mesa_tipo AND
					mesa.mesa_estado IN(1,2) AND
					mesa.mesa_zona = in_mesa_zona
	    ;

	END $$;


ALTER FUNCTION public.swich_consolidados_totales(in_mesa_tipo character varying, in_mesa_zona bigint) OWNER TO postgres;

--
-- Name: swich_editar(bigint, bigint, bigint, bigint, bigint, bigint, bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_editar(in_swich_id bigint, in_swich_modo bigint, in_swich_mesas bigint, in_swich_mesa_1 bigint, in_swich_mesa_2 bigint, in_swich_mesa_3 bigint, in_swich_mesa_4 bigint, in_swich_votos character varying) RETURNS bigint
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

CREATE FUNCTION swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
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
-- Name: swich_mesas_total(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION swich_mesas_total() RETURNS TABLE(voto_total smallint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, candidato_independiente boolean, partido_codigo character varying, partido_id bigint, pacto_codigo character varying, pacto_id bigint)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
		SELECT
            sum(voto.voto_total) as votos_total,
            candidato.candidato_id,
            candidato.candidato_nombres,
            candidato.candidato_apellidos,
            candidato.candidato_independiente,
            partido.partido_codigo,
            partido.partido_id,
            pacto.pacto_codigo,
            pacto.pacto_id
        from
            mesa,
            voto,
            candidato,
            partido,
            pacto
        WHERE
            mesa.mesa_tipo = 'P' AND
            mesa.mesa_zona = 3013 AND
            mesa.mesa_estado = 1 AND
            voto.mesa_id = mesa.mesa_id AND
            candidato.candidato_id = voto.candidato_id AND
            partido.partido_id = candidato.partido_id AND
            pacto.pacto_id = candidato.pacto_id
                        
        group by
            candidato.candidato_id,
            candidato.candidato_apellidos,
            partido.partido_codigo,
            partido.partido_id,
            pacto.pacto_codigo,
            pacto.pacto_id
            
        ORDER BY
            votos_total DESC;

	END $$;


ALTER FUNCTION public.swich_mesas_total() OWNER TO app_vav;

--
-- Name: swich_mesas_total_actuales(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION swich_mesas_total_actuales() RETURNS TABLE(mesa bigint)
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

CREATE FUNCTION swich_obtener_datos(in_swich_id bigint) RETURNS TABLE(swich_mesas smallint, swich_modo smallint, swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint, swich_mesa_4 smallint, swich_votos character varying, swich_cambio timestamp without time zone)
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

		LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.swich_obtener_datos(in_swich_id bigint) OWNER TO postgres;

--
-- Name: swich_quad_actual(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_quad_actual() RETURNS TABLE(swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint, swich_mesa_4 smallint)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

		    swich.swich_mesa_1,

		    swich.swich_mesa_2,

		    swich.swich_mesa_3,

			swich.swich_mesa_4

	    FROM

	        swich

		WHERE

			swich.swich_id = 2

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.swich_quad_actual() OWNER TO postgres;

--
-- Name: swich_quad_mesas(bigint, bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_quad_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint, in_mesa_4 bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
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
			mesa.mesa_id IN ( in_mesa_1 , in_mesa_2 , in_mesa_3 , in_mesa_4 )
	
	    LIMIT 4
	    ;
	
	END $$;


ALTER FUNCTION public.swich_quad_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint, in_mesa_4 bigint) OWNER TO postgres;

--
-- Name: usuario_contar_total(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION usuario_contar_total() RETURNS TABLE(objetos bigint)
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

CREATE FUNCTION usuario_editar(in_usuario_id bigint, in_usuario_rol character varying, in_usuario_nombre character varying, in_usuario_email character varying, in_usuario_password character varying, in_usuario_genero character varying, in_usuario_etiqueta bigint, in_imagenes character varying) RETURNS bigint
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

CREATE FUNCTION usuario_eliminar(in_usuario_id bigint, in_imagen_tipo character varying) RETURNS TABLE(imagen_id bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying)
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

CREATE FUNCTION usuario_iniciar_sesion(in_usuario_email character varying, in_usuario_password character varying) RETURNS bigint
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

CREATE FUNCTION usuario_listado(in_limit integer, in_offset integer) RETURNS TABLE(usuario_id bigint, usuario_rol character varying, usuario_estado smallint, usuario_nombre character varying, usuario_login timestamp without time zone, usuario_creado timestamp without time zone, usuario_poster text)
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

CREATE FUNCTION usuario_listado_movil() RETURNS TABLE(usuario_id bigint, usuario_estado smallint, usuario_genero character varying, usuario_nombre character varying, usuario_password character varying, usuario_etiqueta bigint)
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

CREATE FUNCTION usuario_nuevo() RETURNS bigint
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

CREATE FUNCTION usuario_obtener_datos(in_usuario_id bigint) RETURNS TABLE(usuario_id bigint, usuario_rol character varying, usuario_estado smallint, usuario_genero character varying, usuario_nombre character varying, usuario_email character varying, usuario_etiqueta bigint, usuario_login timestamp without time zone, usuario_creado timestamp without time zone, usuario_poster text)
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

SET default_with_oids = false;

--
-- Name: candidato; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE candidato (
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

CREATE SEQUENCE candidato_candidato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidato_candidato_id_seq OWNER TO app_vav;

--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE candidato_candidato_id_seq OWNED BY candidato.candidato_id;


--
-- Name: candidato_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE candidato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidato_id_seq OWNER TO app_vav;

--
-- Name: candidato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE candidato_id_seq OWNED BY candidato.candidato_id;


--
-- Name: comuna; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE comuna (
    comuna_id bigint NOT NULL,
    region_id bigint DEFAULT 1 NOT NULL,
    distrito_id smallint NOT NULL,
    comuna_nombre character varying(64)
);


ALTER TABLE public.comuna OWNER TO app_vav;

--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE comuna_comuna_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comuna_comuna_id_seq OWNER TO app_vav;

--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE comuna_comuna_id_seq OWNED BY comuna.comuna_id;


--
-- Name: comuna_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE comuna_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comuna_id_seq OWNER TO app_vav;

--
-- Name: comuna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE comuna_id_seq OWNED BY comuna.comuna_id;


--
-- Name: imagen; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE imagen (
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

CREATE SEQUENCE imagen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagen_id_seq OWNER TO app_vav;

--
-- Name: imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE imagen_id_seq OWNED BY imagen.imagen_id;


--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE imagen_imagen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagen_imagen_id_seq OWNER TO app_vav;

--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE imagen_imagen_id_seq OWNED BY imagen.imagen_id;


--
-- Name: mesa; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE mesa (
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
    mesa_creado timestamp without time zone DEFAULT now() NOT NULL,
	mesa_publicado timestamp without time zone DEFAULT now() NOT NULL,
);


ALTER TABLE public.mesa OWNER TO app_vav;

--
-- Name: mesa_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE mesa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mesa_id_seq OWNER TO app_vav;

--
-- Name: mesa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE mesa_id_seq OWNED BY mesa.mesa_id;


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE mesa_mesa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mesa_mesa_id_seq OWNER TO app_vav;

--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE mesa_mesa_id_seq OWNED BY mesa.mesa_id;


--
-- Name: pacto; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE pacto (
    pacto_id bigint NOT NULL,
    pacto_codigo character varying(24),
    pacto_nombre character varying(64)
);


ALTER TABLE public.pacto OWNER TO app_vav;

--
-- Name: pacto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE pacto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacto_id_seq OWNER TO app_vav;

--
-- Name: pacto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE pacto_id_seq OWNED BY pacto.pacto_id;


--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE pacto_pacto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacto_pacto_id_seq OWNER TO app_vav;

--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE pacto_pacto_id_seq OWNED BY pacto.pacto_id;


--
-- Name: partido; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE partido (
    partido_id bigint NOT NULL,
    partido_nombre character varying(64),
    partido_codigo character varying(16)
);


ALTER TABLE public.partido OWNER TO app_vav;

--
-- Name: partido_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE partido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partido_id_seq OWNER TO app_vav;

--
-- Name: partido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE partido_id_seq OWNED BY partido.partido_id;


--
-- Name: partido_partido_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE partido_partido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partido_partido_id_seq OWNER TO app_vav;

--
-- Name: partido_partido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE partido_partido_id_seq OWNED BY partido.partido_id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE region (
    region_id bigint NOT NULL,
    region_nombre character varying(32),
    region_codigo character varying(5)
);


ALTER TABLE public.region OWNER TO app_vav;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_id_seq OWNER TO app_vav;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE region_id_seq OWNED BY region.region_id;


--
-- Name: region_region_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE region_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_region_id_seq OWNER TO app_vav;

--
-- Name: region_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE region_region_id_seq OWNED BY region.region_id;


--
-- Name: swich; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE swich (
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

CREATE SEQUENCE swich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.swich_id_seq OWNER TO app_vav;

--
-- Name: swich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE swich_id_seq OWNED BY swich.swich_id;


--
-- Name: swich_swich_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE swich_swich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.swich_swich_id_seq OWNER TO app_vav;

--
-- Name: swich_swich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE swich_swich_id_seq OWNED BY swich.swich_id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE usuario (
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

CREATE SEQUENCE usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_seq OWNER TO app_vav;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE usuario_id_seq OWNED BY usuario.usuario_id;


--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE usuario_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_usuario_id_seq OWNER TO app_vav;

--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE usuario_usuario_id_seq OWNED BY usuario.usuario_id;


--
-- Name: voto; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE voto (
    voto_id bigint NOT NULL,
    candidato_id bigint DEFAULT 1 NOT NULL,
    mesa_id bigint DEFAULT 1 NOT NULL,
    voto_total smallint NOT NULL
);


ALTER TABLE public.voto OWNER TO app_vav;

--
-- Name: voto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE voto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voto_id_seq OWNER TO app_vav;

--
-- Name: voto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE voto_id_seq OWNED BY voto.voto_id;


--
-- Name: voto_voto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE voto_voto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voto_voto_id_seq OWNER TO app_vav;

--
-- Name: voto_voto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE voto_voto_id_seq OWNED BY voto.voto_id;


--
-- Name: candidato_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato ALTER COLUMN candidato_id SET DEFAULT nextval('candidato_id_seq'::regclass);


--
-- Name: comuna_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY comuna ALTER COLUMN comuna_id SET DEFAULT nextval('comuna_id_seq'::regclass);


--
-- Name: imagen_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY imagen ALTER COLUMN imagen_id SET DEFAULT nextval('imagen_id_seq'::regclass);


--
-- Name: mesa_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY mesa ALTER COLUMN mesa_id SET DEFAULT nextval('mesa_id_seq'::regclass);


--
-- Name: pacto_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY pacto ALTER COLUMN pacto_id SET DEFAULT nextval('pacto_id_seq'::regclass);


--
-- Name: partido_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY partido ALTER COLUMN partido_id SET DEFAULT nextval('partido_id_seq'::regclass);


--
-- Name: region_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY region ALTER COLUMN region_id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: swich_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY swich ALTER COLUMN swich_id SET DEFAULT nextval('swich_id_seq'::regclass);


--
-- Name: usuario_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY usuario ALTER COLUMN usuario_id SET DEFAULT nextval('usuario_id_seq'::regclass);


--
-- Name: voto_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto ALTER COLUMN voto_id SET DEFAULT nextval('voto_id_seq'::regclass);


--
-- Data for Name: candidato; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO candidato VALUES (8640921, 'G', 2, 3005, 397, 99, 'MANUEL JESUS MILLONES CHIRINO', 'MANUEL JESUS MILLONES CHIRINO', '', false, 'None', 'MANUEL', 'MILLONES');
INSERT INTO candidato VALUES (12804003, 'G', 3, 3005, 462, 99, 'FELIPE RIOS CUEVAS', 'FELIPE RIOS CUEVAS', '', false, 'None', 'FELIPE', 'RIOS');
INSERT INTO candidato VALUES (8718045, 'G', 4, 3005, 466, 99, 'RODRIGO EDUARDO ALEXIS MUNDACA CABRERA', 'RODRIGO EDUARDO ALEXIS MUNDACA CABRERA', '', false, 'None', 'RODRIGO', 'MUNDACA');
INSERT INTO candidato VALUES (12221329, 'G', 5, 3005, 437, 99, 'FRANCESCO VENEZIAN URZUA', 'FRANCESCO VENEZIAN URZUA', '', false, 'None', 'FRANCESCO', 'VENEZIAN');
INSERT INTO candidato VALUES (13231848, 'G', 6, 3005, 398, 3, 'MARIA JOSE HOFFMANN OPAZO', 'MARIA JOSE HOFFMANN OPAZO', '', false, 'None', 'MARIA JOSE', 'HOFFMANN');
INSERT INTO candidato VALUES (12243972, 'G', 1, 3001, 430, 203, 'MARCO ANTONIO QUEVEDO VILLEGAS', 'MARCO ANTONIO QUEVEDO VILLEGAS', '', false, 'None', 'MARCO ANTONIO', 'QUEVEDO VILLEGAS');
INSERT INTO candidato VALUES (15338972, 'G', 2, 3001, 397, 197, 'CRISTIAN CABEZAS MUNDACA', 'CRISTIAN CABEZAS MUNDACA', '', false, 'None', 'CRISTIAN', 'CABEZAS MUNDACA');
INSERT INTO candidato VALUES (15925032, 'G', 3, 3001, 466, 99, 'JOSE MIGUEL CARVAJAL GALLARDO', 'JOSE MIGUEL CARVAJAL GALLARDO', '', false, 'None', 'JOSE MIGUEL', 'CARVAJAL GALLARDO');
INSERT INTO candidato VALUES (15769637, 'G', 4, 3001, 416, 157, 'PATRICIO ANDRES QUISBERT LAZO', 'PATRICIO ANDRES QUISBERT LAZO', '', false, 'None', 'PATRICIO ANDRES', 'QUISBERT LAZO');
INSERT INTO candidato VALUES (5776007, 'G', 5, 3001, 437, 150, 'JORGE OSVALDO MUÑOZ OYARCE', 'JORGE OSVALDO MUÑOZ OYARCE', '', false, 'None', 'JORGE OSVALDO', 'MUÑOZ OYARCE');
INSERT INTO candidato VALUES (12141923, 'G', 6, 3001, 398, 3, 'NATAN OLIVOS NUÑEZ', 'NATAN OLIVOS NUÑEZ', '', false, 'None', 'NATAN', 'OLIVOS NUÑEZ');
INSERT INTO candidato VALUES (13644370, 'G', 1, 3002, 397, 197, 'CAROLINA MOSCOSO CARRASCO', 'CAROLINA MOSCOSO CARRASCO', '', false, 'None', 'CAROLINA', 'MOSCOSO CARRASCO');
INSERT INTO candidato VALUES (8514830, 'G', 2, 3002, 456, 7, 'MARCELA XIMENA HERNANDO PEREZ', 'MARCELA XIMENA HERNANDO PEREZ', '', false, 'None', 'MARCELA XIMENA', 'HERNANDO PEREZ');
INSERT INTO candidato VALUES (10671964, 'G', 3, 3002, 466, 99, 'RICARDO HERIBERTO DIAZ CORTES', 'RICARDO HERIBERTO DIAZ CORTES', '', false, 'None', 'RICARDO HERIBERTO', 'DIAZ CORTES');
INSERT INTO candidato VALUES (12437024, 'G', 4, 3002, 416, 157, 'PAOLA AMANDA DEBIA GONZALEZ', 'PAOLA AMANDA DEBIA GONZALEZ', '', false, 'None', 'PAOLA AMANDA', 'DEBIA GONZALEZ');
INSERT INTO candidato VALUES (10175422, 'G', 5, 3002, 437, 150, 'CARLO ALEJANDRO ANTONIO ARQUEROS PIZARRO', 'CARLO ALEJANDRO ANTONIO ARQUEROS PIZARRO', '', false, 'None', 'CARLO ALEJANDRO ANTONIO', 'ARQUEROS PIZARRO');
INSERT INTO candidato VALUES (7035909, 'G', 6, 3002, 398, 99, 'CARLOS CANTERO OJEDA', 'CARLOS CANTERO OJEDA', '', false, 'None', 'CARLOS', 'CANTERO OJEDA');
INSERT INTO candidato VALUES (16874050, 'G', 7, 3002, 999, 99, 'FABIAN OSSANDON BRICEÑO', 'FABIAN OSSANDON BRICEÑO', '', true, 'None', 'FABIAN', 'OSSANDON BRICEÑO');
INSERT INTO candidato VALUES (14113626, 'G', 8, 3002, 999, 99, 'ALEJANDRO ALAMOS UBEDA', 'ALEJANDRO ALAMOS UBEDA', '', true, 'None', 'ALEJANDRO', 'ALAMOS UBEDA');
INSERT INTO candidato VALUES (15029251, 'G', 1, 3003, 430, 203, 'INTI ELEODORO SALAMANCA FERNANDEZ', 'INTI ELEODORO SALAMANCA FERNANDEZ', '', false, 'None', 'INTI ELEODORO', 'SALAMANCA FERNANDEZ');
INSERT INTO candidato VALUES (16012876, 'G', 2, 3003, 397, 197, 'GONZALO TAMBLAY TAPIA', 'GONZALO TAMBLAY TAPIA', '', false, 'None', 'GONZALO', 'TAMBLAY TAPIA');
INSERT INTO candidato VALUES (10638055, 'G', 3, 3003, 466, 99, 'MIGUEL VARGAS CORREA', 'MIGUEL VARGAS CORREA', '', false, 'None', 'MIGUEL', 'VARGAS CORREA');
INSERT INTO candidato VALUES (12171037, 'G', 4, 3003, 416, 157, 'ALEX ALEJANDRO FARIAS PEREZ', 'ALEX ALEJANDRO FARIAS PEREZ', '', false, 'None', 'ALEX ALEJANDRO', 'FARIAS PEREZ');
INSERT INTO candidato VALUES (10372112, 'G', 5, 3003, 437, 150, 'IGNACIO JOSE URCULLU CLEMENT-LUND', 'IGNACIO JOSE URCULLU CLEMENT-LUND', '', false, 'None', 'IGNACIO JOSE', 'URCULLU CLEMENT-LUND');
INSERT INTO candidato VALUES (14168814, 'G', 6, 3003, 398, 3, 'NICOLAS NOMAN GARRIDO', 'NICOLAS NOMAN GARRIDO', '', false, 'None', 'NICOLAS', 'NOMAN GARRIDO');
INSERT INTO candidato VALUES (15374518, 'G', 7, 3003, 999, 99, 'CARLO FELIPE PEZO CORREA', 'CARLO FELIPE PEZO CORREA', '', true, 'None', 'CARLO FELIPE', 'PEZO CORREA');
INSERT INTO candidato VALUES (16520932, 'G', 1, 3004, 442, 198, 'FRANCISCO JAVIER MARTINEZ RIVERA', 'FRANCISCO JAVIER MARTINEZ RIVERA', '', false, 'None', 'FRANCISCO JAVIER', 'MARTINEZ RIVERA');
INSERT INTO candidato VALUES (9759136, 'G', 2, 3004, 397, 197, 'TATIANA CASTILLO GONZALEZ', 'TATIANA CASTILLO GONZALEZ', '', false, 'None', 'TATIANA', 'CASTILLO GONZALEZ');
INSERT INTO candidato VALUES (9235654, 'G', 3, 3004, 443, 99, 'CARLOS EDUARDO RUIZ BENITEZ', 'CARLOS EDUARDO RUIZ BENITEZ', '', false, 'None', 'CARLOS EDUARDO', 'RUIZ BENITEZ');
INSERT INTO candidato VALUES (13425064, 'G', 4, 3004, 466, 6, 'JAVIER ANDRES VEGA ORTIZ', 'JAVIER ANDRES VEGA ORTIZ', '', false, 'None', 'JAVIER ANDRES', 'VEGA ORTIZ');
INSERT INTO candidato VALUES (10876150, 'G', 5, 3004, 416, 157, 'RODRIGO MANUEL ORREGO GALVEZ', 'RODRIGO MANUEL ORREGO GALVEZ', '', false, 'None', 'RODRIGO MANUEL', 'ORREGO GALVEZ');
INSERT INTO candidato VALUES (13977500, 'G', 6, 3004, 454, 2, 'WLADIMIR ALEXANDER PLETICOSIC ORELLANA', 'WLADIMIR ALEXANDER PLETICOSIC ORELLANA', '', false, 'None', 'WLADIMIR ALEXANDER', 'PLETICOSIC ORELLANA');
INSERT INTO candidato VALUES (13330031, 'G', 7, 3004, 437, 150, 'ANDRES EDUARDO GUERRA VEGA', 'ANDRES EDUARDO GUERRA VEGA', '', false, 'None', 'ANDRES EDUARDO', 'GUERRA VEGA');
INSERT INTO candidato VALUES (13829838, 'G', 8, 3004, 398, 99, 'CRISTOBAL JULIA DE LA VEGA', 'CRISTOBAL JULIA DE LA VEGA', '', false, 'None', 'CRISTOBAL', 'JULIA DE LA VEGA');
INSERT INTO candidato VALUES (15379584, 'G', 9, 3004, 999, 99, 'PABLO HERMAN HERRERA', 'PABLO HERMAN HERRERA', '', true, 'None', 'PABLO', 'HERMAN HERRERA');
INSERT INTO candidato VALUES (13778356, 'G', 1, 3006, 397, 197, 'PATRICIO ARENAS ROMAN', 'PATRICIO ARENAS ROMAN', '', false, 'None', 'PATRICIO', 'ARENAS ROMAN');
INSERT INTO candidato VALUES (10302769, 'G', 2, 3006, 456, 99, 'MARIO ALBERTO GALVEZ PALMA', 'MARIO ALBERTO GALVEZ PALMA', '', false, 'None', 'MARIO ALBERTO', 'GALVEZ PALMA');
INSERT INTO candidato VALUES (8910303, 'G', 3, 3006, 466, 5, 'PABLO SILVA AMAYA', 'PABLO SILVA AMAYA', '', false, 'None', 'PABLO', 'SILVA AMAYA');
INSERT INTO candidato VALUES (15787782, 'G', 4, 3006, 416, 157, 'CAROL AROS SEGUEL', 'CAROL AROS SEGUEL', '', false, 'None', 'CAROL', 'AROS SEGUEL');
INSERT INTO candidato VALUES (11635388, 'G', 5, 3006, 424, 200, 'CARLOS ZAMORA CANCINO', 'CARLOS ZAMORA CANCINO', '', false, 'None', 'CARLOS', 'ZAMORA CANCINO');
INSERT INTO candidato VALUES (13657157, 'G', 6, 3006, 437, 150, 'FERNANDO UGARTE TEJEDA', 'FERNANDO UGARTE TEJEDA', '', false, 'None', 'FERNANDO', 'UGARTE TEJEDA');
INSERT INTO candidato VALUES (9315641, 'G', 7, 3006, 398, 99, 'REBECA COFRE CALDERON', 'REBECA COFRE CALDERON', '', false, 'None', 'REBECA', 'COFRE CALDERON');
INSERT INTO candidato VALUES (15526085, 'G', 1, 3007, 397, 197, 'FERNANDA AGUIRRE TORRES', 'FERNANDA AGUIRRE TORRES', '', false, 'None', 'FERNANDA', 'AGUIRRE TORRES');
INSERT INTO candidato VALUES (14487223, 'G', 2, 3007, 454, 2, 'CRISTINA BRAVO CASTRO', 'CRISTINA BRAVO CASTRO', '', false, 'None', 'CRISTINA', 'BRAVO CASTRO');
INSERT INTO candidato VALUES (16090622, 'G', 3, 3007, 424, 99, 'GABRIEL ROJAS ROJAS', 'GABRIEL ROJAS ROJAS', '', false, 'None', 'GABRIEL', 'ROJAS ROJAS');
INSERT INTO candidato VALUES (15772661, 'G', 4, 3007, 437, 99, 'JUAN EDUARDO PRIETO CORREA', 'JUAN EDUARDO PRIETO CORREA', '', false, 'None', 'JUAN EDUARDO', 'PRIETO CORREA');
INSERT INTO candidato VALUES (13100846, 'G', 5, 3007, 398, 3, 'PEDRO PABLO ALVAREZ-SALAMANCA RAMIREZ', 'PEDRO PABLO ALVAREZ-SALAMANCA RAMIREZ', '', false, 'None', 'PEDRO PABLO', 'ALVAREZ-SALAMANCA RAMIREZ');
INSERT INTO candidato VALUES (8267276, 'G', 1, 3008, 430, 201, 'JAVIER SANDOVAL OJEDA', 'JAVIER SANDOVAL OJEDA', '', false, 'None', 'JAVIER', 'SANDOVAL OJEDA');
INSERT INTO candidato VALUES (15181612, 'G', 2, 3008, 442, 99, 'ANA ARANEDA GOMEZ', 'ANA ARANEDA GOMEZ', '', false, 'None', 'ANA', 'ARANEDA GOMEZ');
INSERT INTO candidato VALUES (11789420, 'G', 3, 3008, 397, 197, 'LUCIANO ERNESTO SILVA MORA', 'LUCIANO ERNESTO SILVA MORA', '', false, 'None', 'LUCIANO ERNESTO', 'SILVA MORA');
INSERT INTO candidato VALUES (8510034, 'G', 4, 3008, 462, 99, 'ALEJANDRO NAVARRO BRAIN', 'ALEJANDRO NAVARRO BRAIN', '', false, 'None', 'ALEJANDRO', 'NAVARRO BRAIN');
INSERT INTO candidato VALUES (17007833, 'G', 5, 3008, 416, 157, 'MIRTHA VICTORIA ENCINA OVALLE', 'MIRTHA VICTORIA ENCINA OVALLE', '', false, 'None', 'MIRTHA VICTORIA', 'ENCINA OVALLE');
INSERT INTO candidato VALUES (16190155, 'G', 6, 3008, 437, 150, 'FERNANDO PATRICIO PEÑA RIVERA', 'FERNANDO PATRICIO PEÑA RIVERA', '', false, 'None', 'FERNANDO PATRICIO', 'PEÑA RIVERA');
INSERT INTO candidato VALUES (14354950, 'G', 7, 3008, 398, 99, 'SERGIO GIACAMAN GARCIA', 'SERGIO GIACAMAN GARCIA', '', false, 'None', 'SERGIO', 'GIACAMAN GARCIA');
INSERT INTO candidato VALUES (9013913, 'G', 1, 3009, 397, 99, 'CESAR AUGUSTO VARGAS ZURITA', 'CESAR AUGUSTO VARGAS ZURITA', '', false, 'None', 'CESAR AUGUSTO', 'VARGAS ZURITA');
INSERT INTO candidato VALUES (11993445, 'A', 50, 2767, 432, 188, 'JUAN CARLOS ZURITA MEDINA', 'JUAN CARLOS ZURITA MEDINA', '', false, 'None', 'JUAN CARLOS', 'ZURITA');
INSERT INTO candidato VALUES (15502484, 'G', 2, 3009, 466, 232, 'LUIS ALBERTO PENCHULEO MORALES', 'LUIS ALBERTO PENCHULEO MORALES', '', false, 'None', 'LUIS ALBERTO', 'PENCHULEO MORALES');
INSERT INTO candidato VALUES (9970358, 'G', 3, 3009, 416, 157, 'PABLO DIAZ SALAZAR', 'PABLO DIAZ SALAZAR', '', false, 'None', 'PABLO', 'DIAZ SALAZAR');
INSERT INTO candidato VALUES (15248646, 'G', 4, 3009, 398, 99, 'LUCIANO RIVAS STEPKE', 'LUCIANO RIVAS STEPKE', '', false, 'None', 'LUCIANO', 'RIVAS STEPKE');
INSERT INTO candidato VALUES (6966327, 'G', 5, 3009, 999, 99, 'RENE SAFFIRIO ESPINOZA', 'RENE SAFFIRIO ESPINOZA', '', true, 'None', 'RENE', 'SAFFIRIO ESPINOZA');
INSERT INTO candidato VALUES (10941561, 'G', 6, 3009, 999, 99, 'JORGE CLAUDIO RETAMAL RUBIO', 'JORGE CLAUDIO RETAMAL RUBIO', '', true, 'None', 'JORGE CLAUDIO', 'RETAMAL RUBIO');
INSERT INTO candidato VALUES (9819228, 'G', 1, 3010, 397, 197, 'NATACHA ODETTE RIVAS MORALES', 'NATACHA ODETTE RIVAS MORALES', '', false, 'None', 'NATACHA ODETTE', 'RIVAS MORALES');
INSERT INTO candidato VALUES (13323030, 'G', 2, 3010, 462, 99, 'CLAUDIO ANDRES PEREZ BARROS', 'CLAUDIO ANDRES PEREZ BARROS', '', false, 'None', 'CLAUDIO ANDRES', 'PEREZ BARROS');
INSERT INTO candidato VALUES (19455598, 'G', 3, 3010, 466, 232, 'PATRICIA ELENA RADA SALAZAR', 'PATRICIA ELENA RADA SALAZAR', '', false, 'None', 'PATRICIA ELENA', 'RADA SALAZAR');
INSERT INTO candidato VALUES (13848213, 'G', 4, 3010, 437, 150, 'CLAUDIA ELENA REYES LARENAS', 'CLAUDIA ELENA REYES LARENAS', '', false, 'None', 'CLAUDIA ELENA', 'REYES LARENAS');
INSERT INTO candidato VALUES (10053111, 'G', 5, 3010, 398, 1, 'ALEJANDRO SANTANA TIRACHINI', 'ALEJANDRO SANTANA TIRACHINI', '', false, 'None', 'ALEJANDRO', 'SANTANA TIRACHINI');
INSERT INTO candidato VALUES (18437189, 'G', 1, 3011, 397, 197, 'LISET NOELIA QUILODRAN QUIÑINAO', 'LISET NOELIA QUILODRAN QUIÑINAO', '', false, 'None', 'LISET NOELIA', 'QUILODRAN QUIÑINAO');
INSERT INTO candidato VALUES (13740353, 'G', 2, 3011, 466, 5, 'ANDREA MACIAS PALMA', 'ANDREA MACIAS PALMA', '', false, 'None', 'ANDREA', 'MACIAS PALMA');
INSERT INTO candidato VALUES (13970059, 'G', 3, 3011, 398, 3, 'MARCELO SANTANA VARGAS', 'MARCELO SANTANA VARGAS', '', false, 'None', 'MARCELO', 'SANTANA VARGAS');
INSERT INTO candidato VALUES (11804863, 'G', 4, 3011, 999, 99, 'JORGE PATRICIO ABELLO MOLL', 'JORGE PATRICIO ABELLO MOLL', '', true, 'None', 'JORGE PATRICIO', 'ABELLO MOLL');
INSERT INTO candidato VALUES (8936586, 'G', 1, 3012, 397, 99, 'RAMON SEGUNDO VARGAS GUERRERO', 'RAMON SEGUNDO VARGAS GUERRERO', '', false, 'None', 'RAMON SEGUNDO', 'VARGAS GUERRERO');
INSERT INTO candidato VALUES (10818357, 'G', 2, 3012, 456, 99, 'JORGE MAURICIO FLIES AÑON', 'JORGE MAURICIO FLIES AÑON', '', false, 'None', 'JORGE MAURICIO', 'FLIES AÑON');
INSERT INTO candidato VALUES (10858905, 'G', 3, 3012, 437, 150, 'ALEJANDRO GABRIEL RIQUELME DUCCI', 'ALEJANDRO GABRIEL RIQUELME DUCCI', '', false, 'None', 'ALEJANDRO GABRIEL', 'RIQUELME DUCCI');
INSERT INTO candidato VALUES (16163172, 'G', 4, 3012, 398, 37, 'DANIELA ARECHETA BORQUEZ', 'DANIELA ARECHETA BORQUEZ', '', false, 'None', 'DANIELA', 'ARECHETA BORQUEZ');
INSERT INTO candidato VALUES (10351593, 'G', 5, 3012, 999, 99, 'JOSE RAUL BARRIA BUSTAMANTE', 'JOSE RAUL BARRIA BUSTAMANTE', '', true, 'None', 'JOSE RAUL', 'BARRIA BUSTAMANTE');
INSERT INTO candidato VALUES (13070449, 'G', 5, 3013, 424, 200, 'CARLOS PICHUANTE VERDUGO', 'CARLOS PICHUANTE VERDUGO', '', false, 'None', 'CARLOS', 'PICHUANTE');
INSERT INTO candidato VALUES (13260342, 'G', 1, 3013, 430, 188, 'CATALINA VALENZUELA MAUREIRA', 'CATALINA VALENZUELA MAUREIRA', '', false, 'None', 'CATALINA', 'VALENZUELA');
INSERT INTO candidato VALUES (14545944, 'G', 2, 3013, 397, 99, 'RODRIGO ALEJANDRO LOGAN SOTO', 'RODRIGO ALEJANDRO LOGAN SOTO', '', false, 'None', 'RODRIGO', 'LOGAN');
INSERT INTO candidato VALUES (11648078, 'G', 3, 3013, 462, 130, 'NATHALIE PAULETTE JOIGNANT PACHECO', 'NATHALIE PAULETTE JOIGNANT PACHECO', '', false, 'None', 'NATHALIe', 'JOIGNANT');
INSERT INTO candidato VALUES (13550070, 'G', 4, 3013, 416, 157, 'CLAUDIO RODRIGO ROJAS FISCHER', 'CLAUDIO RODRIGO ROJAS FISCHER', '', false, 'None', 'CLAUDIO', 'ROJAS');
INSERT INTO candidato VALUES (12107877, 'G', 6, 3013, 437, 99, 'MACARENA SANTELICES CAÑAS', 'MACARENA SANTELICES CAÑAS', '', false, 'None', 'MACARENA', 'SANTELICES');
INSERT INTO candidato VALUES (16302612, 'G', 7, 3013, 398, 1, 'FRANCISCO ORREGO GUTIERREZ', 'FRANCISCO ORREGO GUTIERREZ', '', false, 'None', 'FRANCISCO', 'ORREGO');
INSERT INTO candidato VALUES (9404352, 'G', 8, 3013, 999, 99, 'CLAUDIO ORREGO LARRAIN', 'CLAUDIO ORREGO LARRAIN', '', true, 'None', 'CLAUDIO', 'ORREGO');
INSERT INTO candidato VALUES (10966406, 'A', 53, 2780, 426, 200, 'CRISTIAN FRANCO ALDAY SAAVEDRA', 'CRISTIAN FRANCO ALDAY SAAVEDRA', '', false, 'None', 'CRISTIAN', 'ALDAY');
INSERT INTO candidato VALUES (16405932, 'G', 1, 3014, 397, 197, 'TAMAR ANGELICA MUÑOZ SEPULVEDA', 'TAMAR ANGELICA MUÑOZ SEPULVEDA', '', false, 'None', 'TAMAR ANGELICA', 'MUÑOZ SEPULVEDA');
INSERT INTO candidato VALUES (6414561, 'G', 2, 3014, 466, 5, 'LUIS CUVERTINO GOMEZ', 'LUIS CUVERTINO GOMEZ', '', false, 'None', 'LUIS', 'CUVERTINO GOMEZ');
INSERT INTO candidato VALUES (16053871, 'G', 3, 3014, 437, 150, 'CAROLINA ANDREA ZUÑIGA BRITO', 'CAROLINA ANDREA ZUÑIGA BRITO', '', false, 'None', 'CAROLINA ANDREA', 'ZUÑIGA BRITO');
INSERT INTO candidato VALUES (12994211, 'G', 4, 3014, 398, 99, 'OMAR SABAT GUZMAN', 'OMAR SABAT GUZMAN', '', false, 'None', 'OMAR', 'SABAT GUZMAN');
INSERT INTO candidato VALUES (10061982, 'G', 1, 3015, 430, 188, 'JUAN JACOBO TANCARA CHAMBE', 'JUAN JACOBO TANCARA CHAMBE', '', false, 'None', 'JUAN JACOBO', 'TANCARA CHAMBE');
INSERT INTO candidato VALUES (9296561, 'G', 2, 3015, 397, 99, 'FIDEL ARENAS PIZARRO', 'FIDEL ARENAS PIZARRO', '', false, 'None', 'FIDEL', 'ARENAS PIZARRO');
INSERT INTO candidato VALUES (15680832, 'G', 3, 3015, 466, 6, 'CARLOS ALBERTO YEVENES TORRES', 'CARLOS ALBERTO YEVENES TORRES', '', false, 'None', 'CARLOS ALBERTO', 'YEVENES TORRES');
INSERT INTO candidato VALUES (6960376, 'G', 4, 3015, 416, 157, 'BERNARDO ENRIQUE OLIVOS AZUA', 'BERNARDO ENRIQUE OLIVOS AZUA', '', false, 'None', 'BERNARDO ENRIQUE', 'OLIVOS AZUA');
INSERT INTO candidato VALUES (15313018, 'G', 5, 3015, 454, 2, 'JORGE DIAZ IBARRA', 'JORGE DIAZ IBARRA', '', false, 'None', 'JORGE', 'DIAZ IBARRA');
INSERT INTO candidato VALUES (12448356, 'G', 6, 3015, 437, 150, 'KARLA KEPEC ALVAREZ', 'KARLA KEPEC ALVAREZ', '', false, 'None', 'KARLA', 'KEPEC ALVAREZ');
INSERT INTO candidato VALUES (17557048, 'G', 7, 3015, 398, 1, 'DIEGO PACO MAMANI', 'DIEGO PACO MAMANI', '', false, 'None', 'DIEGO', 'PACO MAMANI');
INSERT INTO candidato VALUES (16736942, 'G', 1, 3016, 397, 197, 'ERICK JIMENEZ GARAY', 'ERICK JIMENEZ GARAY', '', false, 'None', 'ERICK', 'JIMENEZ GARAY');
INSERT INTO candidato VALUES (15186179, 'G', 2, 3016, 443, 99, 'CRISTIAN SALEM QUILODRAN PARRA', 'CRISTIAN SALEM QUILODRAN PARRA', '', false, 'None', 'CRISTIAN SALEM', 'QUILODRAN PARRA');
INSERT INTO candidato VALUES (14024673, 'G', 3, 3016, 466, 5, 'OSCAR CRISOSTOMO LLANOS', 'OSCAR CRISOSTOMO LLANOS', '', false, 'None', 'OSCAR', 'CRISOSTOMO LLANOS');
INSERT INTO candidato VALUES (11177626, 'G', 4, 3016, 424, 200, 'JUAN MANUEL RIVAS GARRIDO', 'JUAN MANUEL RIVAS GARRIDO', '', false, 'None', 'JUAN MANUEL', 'RIVAS GARRIDO');
INSERT INTO candidato VALUES (9899792, 'G', 5, 3016, 437, 150, 'JORGE LUIS SANCHEZ FUENTEALBA', 'JORGE LUIS SANCHEZ FUENTEALBA', '', false, 'None', 'JORGE LUIS', 'SANCHEZ FUENTEALBA');
INSERT INTO candidato VALUES (6891931, 'G', 6, 3016, 398, 3, 'BENJAMIN MAUREIRA ALVAREZ', 'BENJAMIN MAUREIRA ALVAREZ', '', false, 'None', 'BENJAMIN', 'MAUREIRA ALVAREZ');
INSERT INTO candidato VALUES (16496424, 'G', 7, 3016, 999, 99, 'IGNACIO MARIN ABUIN', 'IGNACIO MARIN ABUIN', '', true, 'None', 'IGNACIO', 'MARIN ABUIN');
INSERT INTO candidato VALUES (11640811, 'A', 50, 2501, 399, 99, 'FELIPE FRANCISCO ROJAS ANDRADE', 'FELIPE FRANCISCO ROJAS ANDRADE', '', false, 'None', 'FELIPE FRANCISCO', 'ROJAS ANDRADE');
INSERT INTO candidato VALUES (17070820, 'A', 50, 2795, 401, 232, 'LUIS ANDRES VALENZUELA CRUZAT', 'LUIS ANDRES VALENZUELA CRUZAT', '', false, 'None', 'LUIS', 'VALENZUELA');
INSERT INTO candidato VALUES (11815905, 'A', 51, 2501, 401, 99, 'MAURICIO ALEJANDRO SORIA MACCHIAVELLO', 'MAURICIO ALEJANDRO SORIA MACCHIAVELLO', '', false, 'None', 'MAURICIO ALEJANDRO', 'SORIA MACCHIAVELLO');
INSERT INTO candidato VALUES (13865027, 'A', 52, 2501, 444, 198, 'JORGE ZAVALA VALENZUELA', 'JORGE ZAVALA VALENZUELA', '', false, 'None', 'JORGE', 'ZAVALA VALENZUELA');
INSERT INTO candidato VALUES (12613970, 'A', 53, 2501, 400, 99, 'XIMENA NARANJO PINTO', 'XIMENA NARANJO PINTO', '', false, 'None', 'XIMENA', 'NARANJO PINTO');
INSERT INTO candidato VALUES (18207484, 'A', 50, 2502, 399, 197, 'FERNANDO ORTEGA ORTEGA', 'FERNANDO ORTEGA ORTEGA', '', false, 'None', 'FERNANDO', 'ORTEGA ORTEGA');
INSERT INTO candidato VALUES (10481059, 'A', 51, 2502, 401, 2, 'PATRICIO ELIAS FERREIRA RIVERA', 'PATRICIO ELIAS FERREIRA RIVERA', '', false, 'None', 'PATRICIO ELIAS', 'FERREIRA RIVERA');
INSERT INTO candidato VALUES (6621973, 'A', 52, 2502, 400, 1, 'RAMON GALLEGUILLOS CASTILLO', 'RAMON GALLEGUILLOS CASTILLO', '', false, 'None', 'RAMON', 'GALLEGUILLOS CASTILLO');
INSERT INTO candidato VALUES (14692169, 'A', 53, 2502, 999, 99, 'TANYA JACQUELINE PRECILLA CRUZ', 'TANYA JACQUELINE PRECILLA CRUZ', '', true, 'None', 'TANYA JACQUELINE', 'PRECILLA CRUZ');
INSERT INTO candidato VALUES (7219467, 'A', 50, 2503, 432, 99, 'CARLOS FRANCISCO SMITH PASCAL', 'CARLOS FRANCISCO SMITH PASCAL', '', false, 'None', 'CARLOS FRANCISCO', 'SMITH PASCAL');
INSERT INTO candidato VALUES (13425330, 'A', 51, 2503, 401, 2, 'RICHARD GODOY AGUIRRE', 'RICHARD GODOY AGUIRRE', '', false, 'None', 'RICHARD', 'GODOY AGUIRRE');
INSERT INTO candidato VALUES (15266063, 'A', 52, 2503, 400, 1, 'GIOVANA POVEDA PEMPELFORT', 'GIOVANA POVEDA PEMPELFORT', '', false, 'None', 'GIOVANA', 'POVEDA PEMPELFORT');
INSERT INTO candidato VALUES (12612598, 'A', 53, 2503, 999, 99, 'JOSE FERNANDO MUÑOZ CACERES', 'JOSE FERNANDO MUÑOZ CACERES', '', true, 'None', 'JOSE FERNANDO', 'MUÑOZ CACERES');
INSERT INTO candidato VALUES (13215635, 'A', 54, 2503, 999, 99, 'JUAN PABLO CORTES ROJAS', 'JUAN PABLO CORTES ROJAS', '', true, 'None', 'JUAN PABLO', 'CORTES ROJAS');
INSERT INTO candidato VALUES (15001740, 'A', 50, 2504, 399, 197, 'SANDRA CHALLAPA MAMANI', 'SANDRA CHALLAPA MAMANI', '', false, 'None', 'SANDRA', 'CHALLAPA MAMANI');
INSERT INTO candidato VALUES (13528279, 'A', 51, 2504, 400, 99, 'MONICA CHAMACA CASTRO', 'MONICA CHAMACA CASTRO', '', false, 'None', 'MONICA', 'CHAMACA CASTRO');
INSERT INTO candidato VALUES (13742175, 'A', 52, 2504, 999, 99, 'EVELYN MAMANI VIZA', 'EVELYN MAMANI VIZA', '', true, 'None', 'EVELYN', 'MAMANI VIZA');
INSERT INTO candidato VALUES (21647795, 'A', 50, 2505, 401, 5, 'KIARA ANTONIA ALIAGA CALDERON', 'KIARA ANTONIA ALIAGA CALDERON', '', false, 'None', 'KIARA ANTONIA', 'ALIAGA CALDERON');
INSERT INTO candidato VALUES (10571946, 'A', 51, 2505, 418, 99, 'JUAN SEGUNDO CHOQUE MAMANI', 'JUAN SEGUNDO CHOQUE MAMANI', '', false, 'None', 'JUAN SEGUNDO', 'CHOQUE MAMANI');
INSERT INTO candidato VALUES (12937511, 'A', 52, 2505, 444, 198, 'JAVIER IGNACIO GARCIA CHOQUE', 'JAVIER IGNACIO GARCIA CHOQUE', '', false, 'None', 'JAVIER IGNACIO', 'GARCIA CHOQUE');
INSERT INTO candidato VALUES (10201631, 'A', 53, 2505, 999, 99, 'TEOFILO PEDRO MAMANI GARCIA', 'TEOFILO PEDRO MAMANI GARCIA', '', true, 'None', 'TEOFILO PEDRO', 'MAMANI GARCIA');
INSERT INTO candidato VALUES (8449779, 'A', 54, 2505, 999, 99, 'ROSAURO DONATO GARCIA CHOQUE', 'ROSAURO DONATO GARCIA CHOQUE', '', true, 'None', 'ROSAURO DONATO', 'GARCIA CHOQUE');
INSERT INTO candidato VALUES (16866920, 'A', 50, 2506, 401, 99, 'SAMUEL ANTONIO CAYO FLORES', 'SAMUEL ANTONIO CAYO FLORES', '', false, 'None', 'SAMUEL ANTONIO', 'CAYO FLORES');
INSERT INTO candidato VALUES (10985470, 'A', 51, 2506, 400, 3, 'JOSE BARTOLO VINAYA', 'JOSE BARTOLO VINAYA', '', false, 'None', 'JOSE', 'BARTOLO VINAYA');
INSERT INTO candidato VALUES (15001580, 'A', 52, 2506, 999, 99, 'WILLIAMS CARLOS MAMANI TICUNA', 'WILLIAMS CARLOS MAMANI TICUNA', '', true, 'None', 'WILLIAMS CARLOS', 'MAMANI TICUNA');
INSERT INTO candidato VALUES (19178671, 'A', 50, 2507, 401, 99, 'JUAN CARLOS GODOY APALA', 'JUAN CARLOS GODOY APALA', '', false, 'None', 'JUAN CARLOS', 'GODOY APALA');
INSERT INTO candidato VALUES (12908869, 'G', 1, 3005, 430, 99, 'OCTAVIO ENRIQUE GONZALEZ OJEDA', 'OCTAVIO ENRIQUE GONZALEZ OJEDA', '', false, 'None', 'OCTAVIO', 'GONZALEZ');
INSERT INTO candidato VALUES (8597481, 'A', 51, 2507, 400, 99, 'IVAN INFANTE CHACON', 'IVAN INFANTE CHACON', '', false, 'None', 'IVAN', 'INFANTE CHACON');
INSERT INTO candidato VALUES (7240007, 'A', 50, 2508, 432, 188, 'ADELA MARIA PIZARRO GONCALVEZ', 'ADELA MARIA PIZARRO GONCALVEZ', '', false, 'None', 'ADELA MARIA', 'PIZARRO GONCALVEZ');
INSERT INTO candidato VALUES (12348325, 'A', 51, 2508, 399, 99, 'ESLAYNE PORTILLA BARRAZA', 'ESLAYNE PORTILLA BARRAZA', '', false, 'None', 'ESLAYNE', 'PORTILLA BARRAZA');
INSERT INTO candidato VALUES (17017995, 'A', 52, 2508, 401, 6, 'PABLO ANDRES IRIARTE RAMIREZ', 'PABLO ANDRES IRIARTE RAMIREZ', '', false, 'None', 'PABLO ANDRES', 'IRIARTE RAMIREZ');
INSERT INTO candidato VALUES (17514520, 'A', 53, 2508, 428, 99, 'DANIELA BEATRIZ AVILES HONORES', 'DANIELA BEATRIZ AVILES HONORES', '', false, 'None', 'DANIELA BEATRIZ', 'AVILES HONORES');
INSERT INTO candidato VALUES (15690372, 'A', 54, 2508, 418, 157, 'RICARDO VARGAS VALENZUELA', 'RICARDO VARGAS VALENZUELA', '', false, 'None', 'RICARDO', 'VARGAS VALENZUELA');
INSERT INTO candidato VALUES (15014866, 'A', 55, 2508, 439, 150, 'ROBERTO CARLOS SOTO ALBALLAY', 'ROBERTO CARLOS SOTO ALBALLAY', '', false, 'None', 'ROBERTO CARLOS', 'SOTO ALBALLAY');
INSERT INTO candidato VALUES (8328014, 'A', 56, 2508, 400, 37, 'SACHA RAZMILIC BURGOS', 'SACHA RAZMILIC BURGOS', '', false, 'None', 'SACHA', 'RAZMILIC BURGOS');
INSERT INTO candidato VALUES (16488657, 'A', 57, 2508, 999, 99, 'LUIS ANDRES AGUILERA VILLEGAS', 'LUIS ANDRES AGUILERA VILLEGAS', '', true, 'None', 'LUIS ANDRES', 'AGUILERA VILLEGAS');
INSERT INTO candidato VALUES (12837996, 'A', 58, 2508, 999, 99, 'JONATHAN VELASQUEZ RAMIREZ', 'JONATHAN VELASQUEZ RAMIREZ', '', true, 'None', 'JONATHAN', 'VELASQUEZ RAMIREZ');
INSERT INTO candidato VALUES (5997728, 'A', 50, 2509, 401, 4, 'MARCELINO SEGUNDO CARVAJAL FERREIRA', 'MARCELINO SEGUNDO CARVAJAL FERREIRA', '', false, 'None', 'MARCELINO SEGUNDO', 'CARVAJAL FERREIRA');
INSERT INTO candidato VALUES (8222057, 'A', 51, 2509, 400, 1, 'GRECIA BIAGGINI SANCHEZ', 'GRECIA BIAGGINI SANCHEZ', '', false, 'None', 'GRECIA', 'BIAGGINI SANCHEZ');
INSERT INTO candidato VALUES (16515719, 'A', 52, 2509, 999, 99, 'LUIS CONTRERAS PEREZ', 'LUIS CONTRERAS PEREZ', '', true, 'None', 'LUIS', 'CONTRERAS PEREZ');
INSERT INTO candidato VALUES (13940820, 'A', 50, 2510, 401, 99, 'DEBORAH PAREDES CUEVAS', 'DEBORAH PAREDES CUEVAS', '', false, 'None', 'DEBORAH', 'PAREDES CUEVAS');
INSERT INTO candidato VALUES (17438560, 'A', 51, 2510, 400, 99, 'DIEGO FERNANDEZ SOTO', 'DIEGO FERNANDEZ SOTO', '', false, 'None', 'DIEGO', 'FERNANDEZ SOTO');
INSERT INTO candidato VALUES (8074889, 'A', 52, 2510, 999, 99, 'JOSE GUERRERO VENEGAS', 'JOSE GUERRERO VENEGAS', '', true, 'None', 'JOSE', 'GUERRERO VENEGAS');
INSERT INTO candidato VALUES (13530598, 'A', 53, 2510, 999, 99, 'ADRIANA NATALI RIVERA VEGA', 'ADRIANA NATALI RIVERA VEGA', '', true, 'None', 'ADRIANA NATALI', 'RIVERA VEGA');
INSERT INTO candidato VALUES (6637103, 'A', 50, 2511, 401, 99, 'GUILLERMO HIDALGO OCAMPO', 'GUILLERMO HIDALGO OCAMPO', '', false, 'None', 'GUILLERMO', 'HIDALGO OCAMPO');
INSERT INTO candidato VALUES (13530309, 'A', 51, 2511, 999, 99, 'ROSAMERY ANDREA ORELLANA FIGUEROA', 'ROSAMERY ANDREA ORELLANA FIGUEROA', '', true, 'None', 'ROSAMERY ANDREA', 'ORELLANA FIGUEROA');
INSERT INTO candidato VALUES (5462819, 'A', 52, 2511, 999, 99, 'MARIO ACUÑA VILLALOBOS', 'MARIO ACUÑA VILLALOBOS', '', true, 'None', 'MARIO', 'ACUÑA VILLALOBOS');
INSERT INTO candidato VALUES (12938862, 'A', 53, 2511, 999, 99, 'JOSE EDUARDO GUTIERREZ UBEDA', 'JOSE EDUARDO GUTIERREZ UBEDA', '', true, 'None', 'JOSE EDUARDO', 'GUTIERREZ UBEDA');
INSERT INTO candidato VALUES (15680658, 'A', 50, 2512, 399, 197, 'LESLIE MOLL VERA', 'LESLIE MOLL VERA', '', false, 'None', 'LESLIE', 'MOLL VERA');
INSERT INTO candidato VALUES (12607560, 'A', 51, 2512, 401, 130, 'ELIECER DANIEL CHAMORRO VARGAS', 'ELIECER DANIEL CHAMORRO VARGAS', '', false, 'None', 'ELIECER DANIEL', 'CHAMORRO VARGAS');
INSERT INTO candidato VALUES (9400299, 'A', 52, 2512, 418, 157, 'SERGIO JORGE RODRIGO MARMIE IBARRONDO', 'SERGIO JORGE RODRIGO MARMIE IBARRONDO', '', false, 'None', 'SERGIO JORGE RODRIGO', 'MARMIE IBARRONDO');
INSERT INTO candidato VALUES (13912351, 'A', 53, 2512, 444, 198, 'CAROLINA PAZ LATORRE CRUZ', 'CAROLINA PAZ LATORRE CRUZ', '', false, 'None', 'CAROLINA PAZ', 'LATORRE CRUZ');
INSERT INTO candidato VALUES (12802140, 'A', 54, 2512, 999, 99, 'DANIEL AGUSTO PEREZ', 'DANIEL AGUSTO PEREZ', '', true, 'None', 'DANIEL', 'AGUSTO PEREZ');
INSERT INTO candidato VALUES (14309236, 'A', 55, 2512, 999, 99, 'ALEJANDRA OLIDEN VEGA', 'ALEJANDRA OLIDEN VEGA', '', true, 'None', 'ALEJANDRA', 'OLIDEN VEGA');
INSERT INTO candidato VALUES (10700739, 'A', 50, 2513, 400, 99, 'MARCOS GAETE FLORES', 'MARCOS GAETE FLORES', '', false, 'None', 'MARCOS', 'GAETE FLORES');
INSERT INTO candidato VALUES (18183211, 'A', 51, 2513, 999, 99, 'JHEAN CAMILO RAMIREZ DOMINGUEZ', 'JHEAN CAMILO RAMIREZ DOMINGUEZ', '', true, 'None', 'JHEAN CAMILO', 'RAMIREZ DOMINGUEZ');
INSERT INTO candidato VALUES (12581404, 'A', 52, 2513, 999, 99, 'PATRICIA CASTILLO SALVA', 'PATRICIA CASTILLO SALVA', '', true, 'None', 'PATRICIA', 'CASTILLO SALVA');
INSERT INTO candidato VALUES (8474223, 'A', 53, 2513, 999, 99, 'HUMBERTO FLORES GONZALEZ', 'HUMBERTO FLORES GONZALEZ', '', true, 'None', 'HUMBERTO', 'FLORES GONZALEZ');
INSERT INTO candidato VALUES (11720561, 'A', 54, 2513, 999, 99, 'MARISOL LUGO NINA', 'MARISOL LUGO NINA', '', true, 'None', 'MARISOL', 'LUGO NINA');
INSERT INTO candidato VALUES (10064820, 'A', 50, 2514, 401, 99, 'JUSTO ALEXIS ZULETA SANTANDER', 'JUSTO ALEXIS ZULETA SANTANDER', '', false, 'None', 'JUSTO ALEXIS', 'ZULETA SANTANDER');
INSERT INTO candidato VALUES (11333338, 'A', 51, 2514, 418, 157, 'RICARDO MARIO MALLORCA QUISPE', 'RICARDO MARIO MALLORCA QUISPE', '', false, 'None', 'RICARDO MARIO', 'MALLORCA QUISPE');
INSERT INTO candidato VALUES (7873557, 'A', 52, 2514, 400, 99, 'ALIRO CATUR ZULETA', 'ALIRO CATUR ZULETA', '', false, 'None', 'ALIRO', 'CATUR ZULETA');
INSERT INTO candidato VALUES (14564602, 'A', 53, 2514, 999, 99, 'DENIS ROBERTH CONDORI ANZA', 'DENIS ROBERTH CONDORI ANZA', '', true, 'None', 'DENIS ROBERTH', 'CONDORI ANZA');
INSERT INTO candidato VALUES (19496464, 'A', 50, 2515, 401, 130, 'PABLO GABRIEL ALBORNOZ CAMPUSANO', 'PABLO GABRIEL ALBORNOZ CAMPUSANO', '', false, 'None', 'PABLO GABRIEL', 'ALBORNOZ CAMPUSANO');
INSERT INTO candidato VALUES (13529311, 'A', 51, 2515, 400, 99, 'DANIELA VECCHIOLA RIQUELME', 'DANIELA VECCHIOLA RIQUELME', '', false, 'None', 'DANIELA', 'VECCHIOLA RIQUELME');
INSERT INTO candidato VALUES (5247988, 'A', 52, 2515, 999, 99, 'LUIS RAFAEL MOYANO CRUZ', 'LUIS RAFAEL MOYANO CRUZ', '', true, 'None', 'LUIS RAFAEL', 'MOYANO CRUZ');
INSERT INTO candidato VALUES (12038920, 'A', 53, 2515, 999, 99, 'LJUBICA ELENA KURTOVIC CORTES', 'LJUBICA ELENA KURTOVIC CORTES', '', true, 'None', 'LJUBICA ELENA', 'KURTOVIC CORTES');
INSERT INTO candidato VALUES (10603731, 'A', 50, 2516, 400, 99, 'OMAR NORAMBUENA RIVERA', 'OMAR NORAMBUENA RIVERA', '', false, 'None', 'OMAR', 'NORAMBUENA RIVERA');
INSERT INTO candidato VALUES (14605459, 'A', 51, 2516, 999, 99, 'VIVIANA CUELLO RIVERA', 'VIVIANA CUELLO RIVERA', '', true, 'None', 'VIVIANA', 'CUELLO RIVERA');
INSERT INTO candidato VALUES (13016425, 'A', 50, 2517, 432, 203, 'JOANA ANDREA BARRIOS PAEZ', 'JOANA ANDREA BARRIOS PAEZ', '', false, 'None', 'JOANA ANDREA', 'BARRIOS PAEZ');
INSERT INTO candidato VALUES (11239130, 'A', 51, 2517, 399, 197, 'SANDOR GUZMAN FUENTES', 'SANDOR GUZMAN FUENTES', '', false, 'None', 'SANDOR', 'GUZMAN FUENTES');
INSERT INTO candidato VALUES (7096673, 'A', 52, 2517, 401, 5, 'MARCOS LOPEZ RIVERA', 'MARCOS LOPEZ RIVERA', '', false, 'None', 'MARCOS', 'LOPEZ RIVERA');
INSERT INTO candidato VALUES (13873521, 'A', 53, 2517, 444, 99, 'LUIS MARCELINO NUÑEZ BARRIENTOS', 'LUIS MARCELINO NUÑEZ BARRIENTOS', '', false, 'None', 'LUIS MARCELINO', 'NUÑEZ BARRIENTOS');
INSERT INTO candidato VALUES (16559925, 'A', 54, 2517, 400, 1, 'MAXIMILIANO BARRIONUEVO GARCIA', 'MAXIMILIANO BARRIONUEVO GARCIA', '', false, 'None', 'MAXIMILIANO', 'BARRIONUEVO GARCIA');
INSERT INTO candidato VALUES (15029868, 'A', 55, 2517, 999, 99, 'ESTEBAN MAURICIO GARCIA QUEVEDO', 'ESTEBAN MAURICIO GARCIA QUEVEDO', '', true, 'None', 'ESTEBAN MAURICIO', 'GARCIA QUEVEDO');
INSERT INTO candidato VALUES (7263310, 'A', 56, 2517, 999, 99, 'MAGLIO HONORIO CICARDINI NEYRA', 'MAGLIO HONORIO CICARDINI NEYRA', '', true, 'None', 'MAGLIO HONORIO', 'CICARDINI NEYRA');
INSERT INTO candidato VALUES (15094271, 'A', 50, 2518, 432, 203, 'REBECA INES SALINAS BERNAL', 'REBECA INES SALINAS BERNAL', '', false, 'None', 'REBECA INES', 'SALINAS BERNAL');
INSERT INTO candidato VALUES (9198247, 'A', 51, 2518, 401, 4, 'BRUNILDA CLEMENTINA GONZALEZ ANJEL', 'BRUNILDA CLEMENTINA GONZALEZ ANJEL', '', false, 'None', 'BRUNILDA CLEMENTINA', 'GONZALEZ ANJEL');
INSERT INTO candidato VALUES (7650486, 'A', 52, 2518, 444, 191, 'JAIME DEL CARMEN HIDALGO CRUZ', 'JAIME DEL CARMEN HIDALGO CRUZ', '', false, 'None', 'JAIME DEL CARMEN', 'HIDALGO CRUZ');
INSERT INTO candidato VALUES (16334274, 'A', 53, 2518, 400, 99, 'MANUEL NANJARI CONTRERAS', 'MANUEL NANJARI CONTRERAS', '', false, 'None', 'MANUEL', 'NANJARI CONTRERAS');
INSERT INTO candidato VALUES (15032590, 'A', 50, 2519, 432, 99, 'CINDY ANTONELLA QUEVEDO MONARDEZ', 'CINDY ANTONELLA QUEVEDO MONARDEZ', '', false, 'None', 'CINDY ANTONELLA', 'QUEVEDO MONARDEZ');
INSERT INTO candidato VALUES (13727807, 'A', 51, 2519, 399, 197, 'CAROLINA BADILLA CASTRO', 'CAROLINA BADILLA CASTRO', '', false, 'None', 'CAROLINA', 'BADILLA CASTRO');
INSERT INTO candidato VALUES (19460050, 'A', 52, 2519, 401, 232, 'ENRIQUE ALEXANDER SOTO GUERRERO', 'ENRIQUE ALEXANDER SOTO GUERRERO', '', false, 'None', 'ENRIQUE ALEXANDER', 'SOTO GUERRERO');
INSERT INTO candidato VALUES (16833976, 'A', 53, 2519, 439, 150, 'DANIELA ISABEL MUNIZAGA VILLEGAS', 'DANIELA ISABEL MUNIZAGA VILLEGAS', '', false, 'None', 'DANIELA ISABEL', 'MUNIZAGA VILLEGAS');
INSERT INTO candidato VALUES (15032285, 'A', 54, 2519, 999, 99, 'JONATHAN ALFREDO CARMONA DIAZ', 'JONATHAN ALFREDO CARMONA DIAZ', '', true, 'None', 'JONATHAN ALFREDO', 'CARMONA DIAZ');
INSERT INTO candidato VALUES (10694263, 'A', 55, 2519, 999, 99, 'YHANSS GEORGE DELGADO QUEVEDO', 'YHANSS GEORGE DELGADO QUEVEDO', '', true, 'None', 'YHANSS GEORGE', 'DELGADO QUEVEDO');
INSERT INTO candidato VALUES (19352499, 'A', 56, 2519, 999, 99, 'CRISTOBAL ZUÑIGA ARANCIBIA', 'CRISTOBAL ZUÑIGA ARANCIBIA', '', true, 'None', 'CRISTOBAL', 'ZUÑIGA ARANCIBIA');
INSERT INTO candidato VALUES (8465054, 'A', 57, 2519, 999, 99, 'JOEL CARRIZO DIAZ', 'JOEL CARRIZO DIAZ', '', true, 'None', 'JOEL', 'CARRIZO DIAZ');
INSERT INTO candidato VALUES (8924286, 'A', 50, 2520, 401, 7, 'MARGARITA ALICIA FLORES SALAZAR', 'MARGARITA ALICIA FLORES SALAZAR', '', false, 'None', 'MARGARITA ALICIA', 'FLORES SALAZAR');
INSERT INTO candidato VALUES (13530599, 'A', 51, 2520, 400, 1, 'ALEX AHUMADA MONROY', 'ALEX AHUMADA MONROY', '', false, 'None', 'ALEX', 'AHUMADA MONROY');
INSERT INTO candidato VALUES (9415938, 'A', 52, 2520, 999, 99, 'ISAIAS FLORENCIO ZAVALA TORRES', 'ISAIAS FLORENCIO ZAVALA TORRES', '', true, 'None', 'ISAIAS FLORENCIO', 'ZAVALA TORRES');
INSERT INTO candidato VALUES (11748200, 'A', 53, 2520, 999, 99, 'CARMEN DE LAS MERCEDES GONZALEZ PIZARRO', 'CARMEN DE LAS MERCEDES GONZALEZ PIZARRO', '', true, 'None', 'CARMEN DE LAS MERCEDES', 'GONZALEZ PIZARRO');
INSERT INTO candidato VALUES (8830701, 'A', 54, 2520, 999, 99, 'NELSON EDUARDO OLAVE FARIAS', 'NELSON EDUARDO OLAVE FARIAS', '', true, 'None', 'NELSON EDUARDO', 'OLAVE FARIAS');
INSERT INTO candidato VALUES (13530655, 'A', 55, 2520, 999, 99, 'RUDY PATRICIO SALAS LUNA', 'RUDY PATRICIO SALAS LUNA', '', true, 'None', 'RUDY PATRICIO', 'SALAS LUNA');
INSERT INTO candidato VALUES (11932960, 'A', 56, 2520, 999, 99, 'MAURICIO ALEJANDRO RIVERA BLANCO', 'MAURICIO ALEJANDRO RIVERA BLANCO', '', true, 'None', 'MAURICIO ALEJANDRO', 'RIVERA BLANCO');
INSERT INTO candidato VALUES (11723252, 'A', 50, 2521, 401, 6, 'MARIA MIGUELINA TORREJON ROJAS', 'MARIA MIGUELINA TORREJON ROJAS', '', false, 'None', 'MARIA MIGUELINA', 'TORREJON ROJAS');
INSERT INTO candidato VALUES (10411396, 'A', 51, 2521, 400, 1, 'MARIO ARAYA ROJAS', 'MARIO ARAYA ROJAS', '', false, 'None', 'MARIO', 'ARAYA ROJAS');
INSERT INTO candidato VALUES (10345299, 'A', 52, 2521, 999, 99, 'DANIEL DRAGOMIR GALVEZ GOIC', 'DANIEL DRAGOMIR GALVEZ GOIC', '', true, 'None', 'DANIEL DRAGOMIR', 'GALVEZ GOIC');
INSERT INTO candidato VALUES (7298438, 'A', 53, 2521, 999, 99, 'JACQUELINE DE LOS ANGELES CACERES SALAS', 'JACQUELINE DE LOS ANGELES CACERES SALAS', '', true, 'None', 'JACQUELINE DE LOS ANGELES', 'CACERES SALAS');
INSERT INTO candidato VALUES (9074550, 'A', 54, 2521, 999, 99, 'YANET DEL CARMEN RUBINA CONTRERAS', 'YANET DEL CARMEN RUBINA CONTRERAS', '', true, 'None', 'YANET DEL CARMEN', 'RUBINA CONTRERAS');
INSERT INTO candidato VALUES (15745317, 'A', 50, 2522, 418, 157, 'LUIS ALBERTO TAPIA AVALOS', 'LUIS ALBERTO TAPIA AVALOS', '', false, 'None', 'LUIS ALBERTO', 'TAPIA AVALOS');
INSERT INTO candidato VALUES (11508765, 'A', 51, 2522, 400, 99, 'MARIA MARJORIE JOPIA HERRERA', 'MARIA MARJORIE JOPIA HERRERA', '', false, 'None', 'MARIA MARJORIE', 'JOPIA HERRERA');
INSERT INTO candidato VALUES (11724787, 'A', 52, 2522, 999, 99, 'SEBASTIAN SIMON VEGA', 'SEBASTIAN SIMON VEGA', '', true, 'None', 'SEBASTIAN', 'SIMON VEGA');
INSERT INTO candidato VALUES (13328039, 'A', 53, 2522, 999, 99, 'ALEXIS DEL CARMEN LEMUS CAMPILLAY', 'ALEXIS DEL CARMEN LEMUS CAMPILLAY', '', true, 'None', 'ALEXIS DEL CARMEN', 'LEMUS CAMPILLAY');
INSERT INTO candidato VALUES (8846672, 'A', 54, 2522, 999, 99, 'ROBERTO EUGENIO CALDERON GOMEZ', 'ROBERTO EUGENIO CALDERON GOMEZ', '', true, 'None', 'ROBERTO EUGENIO', 'CALDERON GOMEZ');
INSERT INTO candidato VALUES (15514283, 'A', 55, 2522, 999, 99, 'VICTOR MANUEL ISLA LUTZ', 'VICTOR MANUEL ISLA LUTZ', '', true, 'None', 'VICTOR MANUEL', 'ISLA LUTZ');
INSERT INTO candidato VALUES (10256445, 'A', 56, 2522, 999, 99, 'RODRIGO SEBASTIAN LOYOLA MORENILLA', 'RODRIGO SEBASTIAN LOYOLA MORENILLA', '', true, 'None', 'RODRIGO SEBASTIAN', 'LOYOLA MORENILLA');
INSERT INTO candidato VALUES (10035071, 'A', 57, 2522, 999, 99, 'ARMANDO PABLO FLORES JIMENEZ', 'ARMANDO PABLO FLORES JIMENEZ', '', true, 'None', 'ARMANDO PABLO', 'FLORES JIMENEZ');
INSERT INTO candidato VALUES (11724580, 'A', 50, 2523, 399, 99, 'RAUL ARDILES RAMIREZ', 'RAUL ARDILES RAMIREZ', '', false, 'None', 'RAUL', 'ARDILES RAMIREZ');
INSERT INTO candidato VALUES (12814325, 'A', 51, 2523, 401, 7, 'CRISTIAN DIDY OLIVARES IRIARTE', 'CRISTIAN DIDY OLIVARES IRIARTE', '', false, 'None', 'CRISTIAN DIDY', 'OLIVARES IRIARTE');
INSERT INTO candidato VALUES (19349812, 'A', 52, 2523, 418, 157, 'IVAN ALBERTO FLORES VILLALOBOS', 'IVAN ALBERTO FLORES VILLALOBOS', '', false, 'None', 'IVAN ALBERTO', 'FLORES VILLALOBOS');
INSERT INTO candidato VALUES (13532697, 'A', 53, 2523, 439, 99, 'JUAN EMILIO PALLAUTA ROJAS', 'JUAN EMILIO PALLAUTA ROJAS', '', false, 'None', 'JUAN EMILIO', 'PALLAUTA ROJAS');
INSERT INTO candidato VALUES (12095870, 'A', 54, 2523, 999, 99, 'CECILIA ANGELICA ANACONA GARATE', 'CECILIA ANGELICA ANACONA GARATE', '', true, 'None', 'CECILIA ANGELICA', 'ANACONA GARATE');
INSERT INTO candidato VALUES (10594947, 'A', 50, 2524, 401, 5, 'LIBBY OSORIO CALLEJAS', 'LIBBY OSORIO CALLEJAS', '', false, 'None', 'LIBBY', 'OSORIO CALLEJAS');
INSERT INTO candidato VALUES (15490530, 'A', 51, 2524, 400, 99, 'MARIA CECILIA SIMUNOVIC RAMIREZ', 'MARIA CECILIA SIMUNOVIC RAMIREZ', '', false, 'None', 'MARIA CECILIA', 'SIMUNOVIC RAMIREZ');
INSERT INTO candidato VALUES (8787296, 'A', 52, 2524, 999, 99, 'FERNANDO ALBERTO RUHL PEREZ', 'FERNANDO ALBERTO RUHL PEREZ', '', true, 'None', 'FERNANDO ALBERTO', 'RUHL PEREZ');
INSERT INTO candidato VALUES (16449790, 'A', 53, 2524, 999, 99, 'NICOLAS GALLARDO MARTINEZ', 'NICOLAS GALLARDO MARTINEZ', '', true, 'None', 'NICOLAS', 'GALLARDO MARTINEZ');
INSERT INTO candidato VALUES (7974722, 'A', 54, 2524, 999, 99, 'RAUL ALFONSO MEDINA FERNANDEZ', 'RAUL ALFONSO MEDINA FERNANDEZ', '', true, 'None', 'RAUL ALFONSO', 'MEDINA FERNANDEZ');
INSERT INTO candidato VALUES (12571729, 'A', 55, 2524, 999, 99, 'LUIS FLORES BARRAZA', 'LUIS FLORES BARRAZA', '', true, 'None', 'LUIS', 'FLORES BARRAZA');
INSERT INTO candidato VALUES (12171788, 'A', 56, 2524, 999, 99, 'PATRICIO MONARDES RODRIGUEZ', 'PATRICIO MONARDES RODRIGUEZ', '', true, 'None', 'PATRICIO', 'MONARDES RODRIGUEZ');
INSERT INTO candidato VALUES (12171878, 'A', 50, 2525, 401, 99, 'GENARO BRICEÑO TAPIA', 'GENARO BRICEÑO TAPIA', '', false, 'None', 'GENARO', 'BRICEÑO TAPIA');
INSERT INTO candidato VALUES (9790917, 'A', 51, 2525, 418, 157, 'SARA ZUNILDA GUTIERREZ SILVA', 'SARA ZUNILDA GUTIERREZ SILVA', '', false, 'None', 'SARA ZUNILDA', 'GUTIERREZ SILVA');
INSERT INTO candidato VALUES (12171769, 'A', 52, 2525, 400, 99, 'JUAN CARLOS MONTOYA OCARANZA', 'JUAN CARLOS MONTOYA OCARANZA', '', false, 'None', 'JUAN CARLOS', 'MONTOYA OCARANZA');
INSERT INTO candidato VALUES (13358219, 'A', 53, 2525, 999, 99, 'ALEJANDRA DE LOURDES BARRAZA GUERRA', 'ALEJANDRA DE LOURDES BARRAZA GUERRA', '', true, 'None', 'ALEJANDRA DE LOURDES', 'BARRAZA GUERRA');
INSERT INTO candidato VALUES (12576411, 'A', 54, 2525, 999, 99, 'DANIEL DESIDERIO DIAZ TIRADO', 'DANIEL DESIDERIO DIAZ TIRADO', '', true, 'None', 'DANIEL DESIDERIO', 'DIAZ TIRADO');
INSERT INTO candidato VALUES (6531497, 'A', 55, 2525, 999, 99, 'RAFAEL ERNESTO VEGA PERALTA', 'RAFAEL ERNESTO VEGA PERALTA', '', true, 'None', 'RAFAEL ERNESTO', 'VEGA PERALTA');
INSERT INTO candidato VALUES (12642587, 'A', 50, 2526, 432, 99, 'ANA MARIA ITURRALDE PEÑA', 'ANA MARIA ITURRALDE PEÑA', '', false, 'None', 'ANA MARIA', 'ITURRALDE PEÑA');
INSERT INTO candidato VALUES (12633495, 'A', 51, 2526, 399, 99, 'ANDREA GUZMAN HERRERA', 'ANDREA GUZMAN HERRERA', '', false, 'None', 'ANDREA', 'GUZMAN HERRERA');
INSERT INTO candidato VALUES (9896218, 'A', 52, 2526, 401, 7, 'ERNESTO VELASCO RODRIGUEZ', 'ERNESTO VELASCO RODRIGUEZ', '', false, 'None', 'ERNESTO', 'VELASCO RODRIGUEZ');
INSERT INTO candidato VALUES (9288943, 'A', 53, 2526, 418, 157, 'JUAN CARLOS THENOUX CIUDAD', 'JUAN CARLOS THENOUX CIUDAD', '', false, 'None', 'JUAN CARLOS', 'THENOUX CIUDAD');
INSERT INTO candidato VALUES (15636756, 'A', 54, 2526, 400, 1, 'DANIELA NORAMBUENA BORGHERESI', 'DANIELA NORAMBUENA BORGHERESI', '', false, 'None', 'DANIELA', 'NORAMBUENA BORGHERESI');
INSERT INTO candidato VALUES (13650123, 'A', 55, 2526, 999, 99, 'MARCELO TELIAS ORTIZ', 'MARCELO TELIAS ORTIZ', '', true, 'None', 'MARCELO', 'TELIAS ORTIZ');
INSERT INTO candidato VALUES (7751751, 'A', 56, 2526, 999, 99, 'MARIELA PARADA ENERO', 'MARIELA PARADA ENERO', '', true, 'None', 'MARIELA', 'PARADA ENERO');
INSERT INTO candidato VALUES (12239582, 'A', 57, 2526, 999, 99, 'ELIZABETH FREDES ROSALES', 'ELIZABETH FREDES ROSALES', '', true, 'None', 'ELIZABETH', 'FREDES ROSALES');
INSERT INTO candidato VALUES (12051655, 'A', 58, 2526, 999, 99, 'PAMELA SALOME CAIMANQUE ESPEJO', 'PAMELA SALOME CAIMANQUE ESPEJO', '', true, 'None', 'PAMELA SALOME', 'CAIMANQUE ESPEJO');
INSERT INTO candidato VALUES (14116678, 'A', 59, 2526, 999, 99, 'PABLO YAÑEZ PIZARRO', 'PABLO YAÑEZ PIZARRO', '', true, 'None', 'PABLO', 'YAÑEZ PIZARRO');
INSERT INTO candidato VALUES (15908989, 'A', 60, 2526, 999, 99, 'FELIX ALONSO VELASCO LADRON DE GUEVARA', 'FELIX ALONSO VELASCO LADRON DE GUEVARA', '', true, 'None', 'FELIX ALONSO', 'VELASCO LADRON DE GUEVARA');
INSERT INTO candidato VALUES (10237407, 'A', 50, 2527, 432, 99, 'OSCAR ALFONSO COLLAO GUTIERREZ', 'OSCAR ALFONSO COLLAO GUTIERREZ', '', false, 'None', 'OSCAR ALFONSO', 'COLLAO GUTIERREZ');
INSERT INTO candidato VALUES (18966387, 'A', 51, 2527, 399, 197, 'HILARIO VELASQUEZ OLAVE', 'HILARIO VELASQUEZ OLAVE', '', false, 'None', 'HILARIO', 'VELASQUEZ OLAVE');
INSERT INTO candidato VALUES (20340775, 'A', 52, 2527, 401, 99, 'ALI MANOUCHEHRI MOGHADAM KASHAN LOBOS', 'ALI MANOUCHEHRI MOGHADAM KASHAN LOBOS', '', false, 'None', 'ALI', 'MANOUCHEHRI MOGHADAM KASHAN LOBOS');
INSERT INTO candidato VALUES (17193819, 'A', 53, 2527, 418, 99, 'GUIDO ANDRE HERNANDEZ TRUJILLO', 'GUIDO ANDRE HERNANDEZ TRUJILLO', '', false, 'None', 'GUIDO ANDRE', 'HERNANDEZ TRUJILLO');
INSERT INTO candidato VALUES (8191887, 'A', 54, 2527, 400, 99, 'ROSETTA PARIS AVALOS', 'ROSETTA PARIS AVALOS', '', false, 'None', 'ROSETTA', 'PARIS AVALOS');
INSERT INTO candidato VALUES (15038665, 'A', 55, 2527, 999, 99, 'FELIPE VELASQUEZ NAVEA', 'FELIPE VELASQUEZ NAVEA', '', true, 'None', 'FELIPE', 'VELASQUEZ NAVEA');
INSERT INTO candidato VALUES (9207521, 'A', 56, 2527, 999, 99, 'SERGIO ARNOLDO ROJAS TAPIA', 'SERGIO ARNOLDO ROJAS TAPIA', '', true, 'None', 'SERGIO ARNOLDO', 'ROJAS TAPIA');
INSERT INTO candidato VALUES (8803191, 'A', 50, 2528, 401, 5, 'JUAN CARLOS ALFARO ARAVENA', 'JUAN CARLOS ALFARO ARAVENA', '', false, 'None', 'JUAN CARLOS', 'ALFARO ARAVENA');
INSERT INTO candidato VALUES (10040671, 'A', 51, 2528, 400, 99, 'ANGELA GUERRA ARAYA', 'ANGELA GUERRA ARAYA', '', false, 'None', 'ANGELA', 'GUERRA ARAYA');
INSERT INTO candidato VALUES (17111598, 'A', 52, 2528, 999, 99, 'GERALD ALBERT CERDA PIZARRO', 'GERALD ALBERT CERDA PIZARRO', '', true, 'None', 'GERALD ALBERT', 'CERDA PIZARRO');
INSERT INTO candidato VALUES (14116351, 'A', 53, 2528, 999, 99, 'MAGALY GONZALEZ LUCAY', 'MAGALY GONZALEZ LUCAY', '', true, 'None', 'MAGALY', 'GONZALEZ LUCAY');
INSERT INTO candidato VALUES (16053504, 'A', 54, 2528, 999, 99, 'MAURICIO CARMONA BRAVO', 'MAURICIO CARMONA BRAVO', '', true, 'None', 'MAURICIO', 'CARMONA BRAVO');
INSERT INTO candidato VALUES (17466300, 'A', 55, 2528, 999, 99, 'CARLOS PEREZ SUAREZ', 'CARLOS PEREZ SUAREZ', '', true, 'None', 'CARLOS', 'PEREZ SUAREZ');
INSERT INTO candidato VALUES (11726437, 'A', 56, 2528, 999, 99, 'DIXON PABLO PASTEN GUERRERO', 'DIXON PABLO PASTEN GUERRERO', '', true, 'None', 'DIXON PABLO', 'PASTEN GUERRERO');
INSERT INTO candidato VALUES (11509364, 'A', 50, 2529, 401, 5, 'UBERLINDA AQUEA BARRAZA', 'UBERLINDA AQUEA BARRAZA', '', false, 'None', 'UBERLINDA', 'AQUEA BARRAZA');
INSERT INTO candidato VALUES (13424280, 'A', 51, 2529, 400, 3, 'DINKA HERRERA SAAVEDRA', 'DINKA HERRERA SAAVEDRA', '', false, 'None', 'DINKA', 'HERRERA SAAVEDRA');
INSERT INTO candidato VALUES (12805203, 'A', 52, 2529, 999, 99, 'ROSITA GUZMAN SASMAYA', 'ROSITA GUZMAN SASMAYA', '', true, 'None', 'ROSITA', 'GUZMAN SASMAYA');
INSERT INTO candidato VALUES (7313423, 'A', 53, 2529, 999, 99, 'CARLOS FLORES GONZALEZ', 'CARLOS FLORES GONZALEZ', '', true, 'None', 'CARLOS', 'FLORES GONZALEZ');
INSERT INTO candidato VALUES (11510065, 'A', 50, 2530, 401, 130, 'ROSA LUZ PINTO ROJAS', 'ROSA LUZ PINTO ROJAS', '', false, 'None', 'ROSA LUZ', 'PINTO ROJAS');
INSERT INTO candidato VALUES (13255299, 'A', 51, 2530, 400, 1, 'HERNAN AHUMADA AHUMADA', 'HERNAN AHUMADA AHUMADA', '', false, 'None', 'HERNAN', 'AHUMADA AHUMADA');
INSERT INTO candidato VALUES (13826870, 'A', 52, 2530, 999, 99, 'JULIO ALBERTO RODRIGUEZ ALVAREZ', 'JULIO ALBERTO RODRIGUEZ ALVAREZ', '', true, 'None', 'JULIO ALBERTO', 'RODRIGUEZ ALVAREZ');
INSERT INTO candidato VALUES (13175180, 'A', 53, 2530, 999, 99, 'PATRICIA ARDILES ORDENES', 'PATRICIA ARDILES ORDENES', '', true, 'None', 'PATRICIA', 'ARDILES ORDENES');
INSERT INTO candidato VALUES (10184164, 'A', 50, 2531, 399, 197, 'SILVIO MATTOS ARAYA', 'SILVIO MATTOS ARAYA', '', false, 'None', 'SILVIO', 'MATTOS ARAYA');
INSERT INTO candidato VALUES (13745530, 'A', 51, 2531, 401, 99, 'KETHER BAUTISTA GOMEZ PASTEN', 'KETHER BAUTISTA GOMEZ PASTEN', '', false, 'None', 'KETHER BAUTISTA', 'GOMEZ PASTEN');
INSERT INTO candidato VALUES (11935161, 'A', 52, 2531, 400, 99, 'MARIO AROS CARVAJAL', 'MARIO AROS CARVAJAL', '', false, 'None', 'MARIO', 'AROS CARVAJAL');
INSERT INTO candidato VALUES (10247901, 'A', 53, 2531, 999, 99, 'MARTA CASTILLO CASTRO', 'MARTA CASTILLO CASTRO', '', true, 'None', 'MARTA', 'CASTILLO CASTRO');
INSERT INTO candidato VALUES (14100010, 'A', 54, 2531, 999, 99, 'YERMAN ROJAS CASTILLO', 'YERMAN ROJAS CASTILLO', '', true, 'None', 'YERMAN', 'ROJAS CASTILLO');
INSERT INTO candidato VALUES (14406437, 'A', 55, 2531, 999, 99, 'RODRIGO ALCAYAGA ROJAS', 'RODRIGO ALCAYAGA ROJAS', '', true, 'None', 'RODRIGO', 'ALCAYAGA ROJAS');
INSERT INTO candidato VALUES (14379207, 'A', 50, 2532, 401, 2, 'DENIS CORTES AGUILERA', 'DENIS CORTES AGUILERA', '', false, 'None', 'DENIS', 'CORTES AGUILERA');
INSERT INTO candidato VALUES (8095734, 'A', 51, 2532, 418, 157, 'HERMOSINA DE MERCEDES MANQUEZ OLIVARES', 'HERMOSINA DE MERCEDES MANQUEZ OLIVARES', '', false, 'None', 'HERMOSINA DE MERCEDES', 'MANQUEZ OLIVARES');
INSERT INTO candidato VALUES (13749106, 'A', 52, 2532, 999, 99, 'FABIAN OLIVARES HIDALGO', 'FABIAN OLIVARES HIDALGO', '', true, 'None', 'FABIAN', 'OLIVARES HIDALGO');
INSERT INTO candidato VALUES (9237901, 'A', 53, 2532, 999, 99, 'LUIS LEMUS ARACENA', 'LUIS LEMUS ARACENA', '', true, 'None', 'LUIS', 'LEMUS ARACENA');
INSERT INTO candidato VALUES (11514473, 'A', 50, 2533, 401, 6, 'MANUEL ANGEL NAVARRO VEGA', 'MANUEL ANGEL NAVARRO VEGA', '', false, 'None', 'MANUEL ANGEL', 'NAVARRO VEGA');
INSERT INTO candidato VALUES (10221178, 'A', 51, 2533, 999, 99, 'RUBEN ORLANDO CORTES CAMPUSANO', 'RUBEN ORLANDO CORTES CAMPUSANO', '', true, 'None', 'RUBEN ORLANDO', 'CORTES CAMPUSANO');
INSERT INTO candidato VALUES (9629855, 'A', 52, 2533, 999, 99, 'NESTOR VALLE TAPIA', 'NESTOR VALLE TAPIA', '', true, 'None', 'NESTOR', 'VALLE TAPIA');
INSERT INTO candidato VALUES (12946249, 'A', 53, 2533, 999, 99, 'WALDO ENRIQUE CONTRERAS CORTES', 'WALDO ENRIQUE CONTRERAS CORTES', '', true, 'None', 'WALDO ENRIQUE', 'CONTRERAS CORTES');
INSERT INTO candidato VALUES (12690463, 'A', 50, 2534, 432, 99, 'ISOLDA MERCEDES DIAZ MARTINEZ', 'ISOLDA MERCEDES DIAZ MARTINEZ', '', false, 'None', 'ISOLDA MERCEDES', 'DIAZ MARTINEZ');
INSERT INTO candidato VALUES (14401436, 'A', 51, 2534, 401, 5, 'CHRISTIAN FRANK GROSS HIDALGO', 'CHRISTIAN FRANK GROSS HIDALGO', '', false, 'None', 'CHRISTIAN FRANK', 'GROSS HIDALGO');
INSERT INTO candidato VALUES (8443328, 'A', 52, 2534, 400, 1, 'JAIME HERRERA FLORES', 'JAIME HERRERA FLORES', '', false, 'None', 'JAIME', 'HERRERA FLORES');
INSERT INTO candidato VALUES (10673519, 'A', 53, 2534, 999, 99, 'ALVARO SANHUEZA MARIPANGUE', 'ALVARO SANHUEZA MARIPANGUE', '', true, 'None', 'ALVARO', 'SANHUEZA MARIPANGUE');
INSERT INTO candidato VALUES (16820431, 'A', 54, 2534, 999, 99, 'HUGO VALDEBENITO HUERTA', 'HUGO VALDEBENITO HUERTA', '', true, 'None', 'HUGO', 'VALDEBENITO HUERTA');
INSERT INTO candidato VALUES (15785412, 'A', 55, 2534, 999, 99, 'HECTOR PATRICIO SAN MARTIN ROJAS', 'HECTOR PATRICIO SAN MARTIN ROJAS', '', true, 'None', 'HECTOR PATRICIO', 'SAN MARTIN ROJAS');
INSERT INTO candidato VALUES (8388562, 'A', 50, 2535, 401, 99, 'GERARDO ANDRES ROJAS ESCUDERO', 'GERARDO ANDRES ROJAS ESCUDERO', '', false, 'None', 'GERARDO ANDRES', 'ROJAS ESCUDERO');
INSERT INTO candidato VALUES (16560626, 'A', 51, 2535, 439, 150, 'AARON ELIU AGUILERA CORTES', 'AARON ELIU AGUILERA CORTES', '', false, 'None', 'AARON ELIU', 'AGUILERA CORTES');
INSERT INTO candidato VALUES (16134963, 'A', 52, 2535, 400, 1, 'VINKA PUSICH CAMACHO', 'VINKA PUSICH CAMACHO', '', false, 'None', 'VINKA', 'PUSICH CAMACHO');
INSERT INTO candidato VALUES (12262079, 'A', 53, 2535, 999, 99, 'ALEJANDRO TELLO ARATA', 'ALEJANDRO TELLO ARATA', '', true, 'None', 'ALEJANDRO', 'TELLO ARATA');
INSERT INTO candidato VALUES (16974428, 'A', 54, 2535, 999, 99, 'CARLOS LILLO ALAMOS', 'CARLOS LILLO ALAMOS', '', true, 'None', 'CARLOS', 'LILLO ALAMOS');
INSERT INTO candidato VALUES (10556577, 'A', 55, 2535, 999, 99, 'OMAR ALAMOS CALDERON', 'OMAR ALAMOS CALDERON', '', true, 'None', 'OMAR', 'ALAMOS CALDERON');
INSERT INTO candidato VALUES (13537690, 'A', 56, 2535, 999, 99, 'ALEJANDRA HENRIQUEZ CUEVAS', 'ALEJANDRA HENRIQUEZ CUEVAS', '', true, 'None', 'ALEJANDRA', 'HENRIQUEZ CUEVAS');
INSERT INTO candidato VALUES (8600752, 'A', 57, 2535, 999, 99, 'WILSON GONZALEZ RAMIREZ', 'WILSON GONZALEZ RAMIREZ', '', true, 'None', 'WILSON', 'GONZALEZ RAMIREZ');
INSERT INTO candidato VALUES (9223162, 'A', 50, 2536, 399, 99, 'MARIA GODOY MILLA', 'MARIA GODOY MILLA', '', false, 'None', 'MARIA', 'GODOY MILLA');
INSERT INTO candidato VALUES (17114048, 'A', 51, 2536, 401, 2, 'JONATHAN ACUÑA ROJAS', 'JONATHAN ACUÑA ROJAS', '', false, 'None', 'JONATHAN', 'ACUÑA ROJAS');
INSERT INTO candidato VALUES (12770028, 'A', 52, 2536, 418, 99, 'GERALD LUIS CASTILLO CASTILLO', 'GERALD LUIS CASTILLO CASTILLO', '', false, 'None', 'GERALD LUIS', 'CASTILLO CASTILLO');
INSERT INTO candidato VALUES (12072678, 'A', 53, 2536, 444, 198, 'CARLOS ANTONIO ARAYA BUGUEÑO', 'CARLOS ANTONIO ARAYA BUGUEÑO', '', false, 'None', 'CARLOS ANTONIO', 'ARAYA BUGUEÑO');
INSERT INTO candidato VALUES (16578974, 'A', 54, 2536, 999, 99, 'HECTOR VEGA CAMPUSANO', 'HECTOR VEGA CAMPUSANO', '', true, 'None', 'HECTOR', 'VEGA CAMPUSANO');
INSERT INTO candidato VALUES (9228714, 'A', 55, 2536, 999, 99, 'RICARDO GONZALEZ GONZALEZ', 'RICARDO GONZALEZ GONZALEZ', '', true, 'None', 'RICARDO', 'GONZALEZ GONZALEZ');
INSERT INTO candidato VALUES (10517840, 'A', 56, 2536, 999, 99, 'FRANCISCO MORGADO SALFATE', 'FRANCISCO MORGADO SALFATE', '', true, 'None', 'FRANCISCO', 'MORGADO SALFATE');
INSERT INTO candidato VALUES (16689301, 'A', 50, 2537, 401, 99, 'JUAN RODRIGO FUENTES FERNANDEZ', 'JUAN RODRIGO FUENTES FERNANDEZ', '', false, 'None', 'JUAN RODRIGO', 'FUENTES FERNANDEZ');
INSERT INTO candidato VALUES (15040934, 'A', 51, 2537, 444, 99, 'JUAN PABLO ADONIS ALVAREZ', 'JUAN PABLO ADONIS ALVAREZ', '', false, 'None', 'JUAN PABLO', 'ADONIS ALVAREZ');
INSERT INTO candidato VALUES (12144635, 'A', 52, 2537, 999, 99, 'JUAN CARLOS ARAYA ARAYA', 'JUAN CARLOS ARAYA ARAYA', '', true, 'None', 'JUAN CARLOS', 'ARAYA ARAYA');
INSERT INTO candidato VALUES (7609381, 'A', 53, 2537, 999, 99, 'JUANA SARMIENTO ACOSTA', 'JUANA SARMIENTO ACOSTA', '', true, 'None', 'JUANA', 'SARMIENTO ACOSTA');
INSERT INTO candidato VALUES (8996831, 'A', 54, 2537, 999, 99, 'MARTA ANGELICA CARVAJAL CORTES', 'MARTA ANGELICA CARVAJAL CORTES', '', true, 'None', 'MARTA ANGELICA', 'CARVAJAL CORTES');
INSERT INTO candidato VALUES (8094278, 'A', 55, 2537, 999, 99, 'SOLERCIO ROJAS AGUIRRE', 'SOLERCIO ROJAS AGUIRRE', '', true, 'None', 'SOLERCIO', 'ROJAS AGUIRRE');
INSERT INTO candidato VALUES (12945267, 'A', 56, 2537, 999, 99, 'ELIZABETH SALINAS VALLE', 'ELIZABETH SALINAS VALLE', '', true, 'None', 'ELIZABETH', 'SALINAS VALLE');
INSERT INTO candidato VALUES (8064668, 'A', 57, 2537, 999, 99, 'RENAN UGALDE MEZA', 'RENAN UGALDE MEZA', '', true, 'None', 'RENAN', 'UGALDE MEZA');
INSERT INTO candidato VALUES (13079904, 'A', 50, 2538, 401, 99, 'CRISTIAN HERRERA PEÑA', 'CRISTIAN HERRERA PEÑA', '', false, 'None', 'CRISTIAN', 'HERRERA PEÑA');
INSERT INTO candidato VALUES (16325061, 'A', 51, 2538, 400, 3, 'NICOLAS ARAYA ASTUDILLO', 'NICOLAS ARAYA ASTUDILLO', '', false, 'None', 'NICOLAS', 'ARAYA ASTUDILLO');
INSERT INTO candidato VALUES (13746866, 'A', 52, 2538, 999, 99, 'CAMILO OSSANDON ESPINOZA', 'CAMILO OSSANDON ESPINOZA', '', true, 'None', 'CAMILO', 'OSSANDON ESPINOZA');
INSERT INTO candidato VALUES (13976231, 'A', 53, 2538, 999, 99, 'PIA GALLEGUILLOS OGALDE', 'PIA GALLEGUILLOS OGALDE', '', true, 'None', 'PIA', 'GALLEGUILLOS OGALDE');
INSERT INTO candidato VALUES (19574222, 'A', 50, 2539, 401, 232, 'CAMILA ANDREA ROJAS HONORES', 'CAMILA ANDREA ROJAS HONORES', '', false, 'None', 'CAMILA ANDREA', 'ROJAS HONORES');
INSERT INTO candidato VALUES (12770012, 'A', 51, 2539, 418, 157, 'CARLOS NESTOR FAGGANI CARMONA', 'CARLOS NESTOR FAGGANI CARMONA', '', false, 'None', 'CARLOS NESTOR', 'FAGGANI CARMONA');
INSERT INTO candidato VALUES (15042094, 'A', 52, 2539, 400, 37, 'MARIO ORTIZ CABEZAS', 'MARIO ORTIZ CABEZAS', '', false, 'None', 'MARIO', 'ORTIZ CABEZAS');
INSERT INTO candidato VALUES (10105585, 'A', 53, 2539, 999, 99, 'ADOLFO JAVIER OYARCE TAPIA', 'ADOLFO JAVIER OYARCE TAPIA', '', true, 'None', 'ADOLFO JAVIER', 'OYARCE TAPIA');
INSERT INTO candidato VALUES (5119511, 'A', 54, 2539, 999, 99, 'PEDRO ALEJANDRO VALDIVIA RAMIREZ', 'PEDRO ALEJANDRO VALDIVIA RAMIREZ', '', true, 'None', 'PEDRO ALEJANDRO', 'VALDIVIA RAMIREZ');
INSERT INTO candidato VALUES (10966817, 'A', 55, 2539, 999, 99, 'CARLOS MARCELO PRADO DUBO', 'CARLOS MARCELO PRADO DUBO', '', true, 'None', 'CARLOS MARCELO', 'PRADO DUBO');
INSERT INTO candidato VALUES (8190330, 'A', 56, 2539, 999, 99, 'PEDRO HUMBERTO ARAYA ZEPEDA', 'PEDRO HUMBERTO ARAYA ZEPEDA', '', true, 'None', 'PEDRO HUMBERTO', 'ARAYA ZEPEDA');
INSERT INTO candidato VALUES (15027479, 'A', 57, 2539, 999, 99, 'JONATHAN DIAZ FIGUEROA', 'JONATHAN DIAZ FIGUEROA', '', true, 'None', 'JONATHAN', 'DIAZ FIGUEROA');
INSERT INTO candidato VALUES (17112215, 'A', 58, 2539, 999, 99, 'RODOLFO CAMPUSANO DONOZO', 'RODOLFO CAMPUSANO DONOZO', '', true, 'None', 'RODOLFO', 'CAMPUSANO DONOZO');
INSERT INTO candidato VALUES (5735328, 'A', 59, 2539, 999, 99, 'ALBERTO GALLARDO FLORES', 'ALBERTO GALLARDO FLORES', '', true, 'None', 'ALBERTO', 'GALLARDO FLORES');
INSERT INTO candidato VALUES (13535844, 'A', 50, 2540, 401, 99, 'CARMEN JUANA OLIVARES DE LA RIVERA', 'CARMEN JUANA OLIVARES DE LA RIVERA', '', false, 'None', 'CARMEN JUANA', 'OLIVARES DE LA RIVERA');
INSERT INTO candidato VALUES (9837735, 'A', 51, 2540, 439, 150, 'SALVADOR ANSELMO VEGA SEGOVIA', 'SALVADOR ANSELMO VEGA SEGOVIA', '', false, 'None', 'SALVADOR ANSELMO', 'VEGA SEGOVIA');
INSERT INTO candidato VALUES (12773688, 'A', 52, 2540, 400, 3, 'LUIS VEGA GONZALEZ', 'LUIS VEGA GONZALEZ', '', false, 'None', 'LUIS', 'VEGA GONZALEZ');
INSERT INTO candidato VALUES (16324741, 'A', 53, 2540, 999, 99, 'DIEGO MILLA YAÑEZ', 'DIEGO MILLA YAÑEZ', '', true, 'None', 'DIEGO', 'MILLA YAÑEZ');
INSERT INTO candidato VALUES (15582090, 'A', 50, 2541, 399, 99, 'ALEXIS OLIVEROS AGUILAR', 'ALEXIS OLIVEROS AGUILAR', '', false, 'None', 'ALEXIS', 'OLIVEROS AGUILAR');
INSERT INTO candidato VALUES (17805790, 'A', 51, 2541, 401, 232, 'CAMILA TATIANA NIETO HERNANDEZ', 'CAMILA TATIANA NIETO HERNANDEZ', '', false, 'None', 'CAMILA TATIANA', 'NIETO HERNANDEZ');
INSERT INTO candidato VALUES (16485167, 'A', 52, 2541, 418, 157, 'JUAN MARCELO VALENZUELA HENRIQUEZ', 'JUAN MARCELO VALENZUELA HENRIQUEZ', '', false, 'None', 'JUAN MARCELO', 'VALENZUELA HENRIQUEZ');
INSERT INTO candidato VALUES (6304072, 'A', 53, 2541, 444, 99, 'MARCELA PATRICIA FIGUEROA KUPFER', 'MARCELA PATRICIA FIGUEROA KUPFER', '', false, 'None', 'MARCELA PATRICIA', 'FIGUEROA KUPFER');
INSERT INTO candidato VALUES (15069023, 'A', 54, 2541, 439, 99, 'RAFAEL GONZALEZ CAMUS', 'RAFAEL GONZALEZ CAMUS', '', false, 'None', 'RAFAEL', 'GONZALEZ CAMUS');
INSERT INTO candidato VALUES (9718100, 'A', 55, 2541, 999, 99, 'CARLA ELENA MEYER ARANCIBIA', 'CARLA ELENA MEYER ARANCIBIA', '', true, 'None', 'CARLA ELENA', 'MEYER ARANCIBIA');
INSERT INTO candidato VALUES (10749451, 'A', 56, 2541, 999, 99, 'RODRIGO ALEJANDRO DIAZ YUBERO', 'RODRIGO ALEJANDRO DIAZ YUBERO', '', true, 'None', 'RODRIGO ALEJANDRO', 'DIAZ YUBERO');
INSERT INTO candidato VALUES (9344467, 'A', 57, 2541, 999, 99, 'ZULIANA ALEJANDRA ARAYA GUTIERREZ', 'ZULIANA ALEJANDRA ARAYA GUTIERREZ', '', true, 'None', 'ZULIANA ALEJANDRA', 'ARAYA GUTIERREZ');
INSERT INTO candidato VALUES (13191233, 'A', 50, 2542, 401, 232, 'FRANCISCO JAVIER RIQUELME LOPEZ', 'FRANCISCO JAVIER RIQUELME LOPEZ', '', false, 'None', 'FRANCISCO JAVIER', 'RIQUELME LOPEZ');
INSERT INTO candidato VALUES (17304468, 'A', 51, 2542, 444, 198, 'ALEXANDER GABRIEL ARANGUIZ MEZA', 'ALEXANDER GABRIEL ARANGUIZ MEZA', '', false, 'None', 'ALEXANDER GABRIEL', 'ARANGUIZ MEZA');
INSERT INTO candidato VALUES (9901641, 'A', 52, 2542, 400, 1, 'RODRIGO MARTINEZ ROCA', 'RODRIGO MARTINEZ ROCA', '', false, 'None', 'RODRIGO', 'MARTINEZ ROCA');
INSERT INTO candidato VALUES (12625652, 'A', 53, 2542, 999, 99, 'MARCELO ANDRES POZO CERDA', 'MARCELO ANDRES POZO CERDA', '', true, 'None', 'MARCELO ANDRES', 'POZO CERDA');
INSERT INTO candidato VALUES (12620891, 'A', 54, 2542, 999, 99, 'KAREN ANTONIETA ORDOÑEZ URZUA', 'KAREN ANTONIETA ORDOÑEZ URZUA', '', true, 'None', 'KAREN ANTONIETA', 'ORDOÑEZ URZUA');
INSERT INTO candidato VALUES (15560738, 'A', 50, 2543, 418, 157, 'LUIS FELIPE CAMPODONICO ESPINOZA', 'LUIS FELIPE CAMPODONICO ESPINOZA', '', false, 'None', 'LUIS FELIPE', 'CAMPODONICO ESPINOZA');
INSERT INTO candidato VALUES (12227577, 'A', 51, 2543, 400, 99, 'PABLO ESTEBAN ROJAS DAYDI', 'PABLO ESTEBAN ROJAS DAYDI', '', false, 'None', 'PABLO ESTEBAN', 'ROJAS DAYDI');
INSERT INTO candidato VALUES (8526167, 'A', 52, 2543, 999, 99, 'FREDDY ANTONIO RAMIREZ VILLALOBOS', 'FREDDY ANTONIO RAMIREZ VILLALOBOS', '', true, 'None', 'FREDDY ANTONIO', 'RAMIREZ VILLALOBOS');
INSERT INTO candidato VALUES (10985198, 'A', 53, 2543, 999, 99, 'ILEN CAROLINA SAEZ LARRAVIDE', 'ILEN CAROLINA SAEZ LARRAVIDE', '', true, 'None', 'ILEN CAROLINA', 'SAEZ LARRAVIDE');
INSERT INTO candidato VALUES (14005817, 'A', 54, 2543, 999, 99, 'ARIEL SOTO LUCERO', 'ARIEL SOTO LUCERO', '', true, 'None', 'ARIEL', 'SOTO LUCERO');
INSERT INTO candidato VALUES (15750340, 'A', 50, 2544, 401, 99, 'PABLO ANDRES MANRIQUEZ ANGULO', 'PABLO ANDRES MANRIQUEZ ANGULO', '', false, 'None', 'PABLO ANDRES', 'MANRIQUEZ ANGULO');
INSERT INTO candidato VALUES (7613309, 'A', 51, 2544, 400, 1, 'LEOPOLDO GONZALEZ CHARPENTIER', 'LEOPOLDO GONZALEZ CHARPENTIER', '', false, 'None', 'LEOPOLDO', 'GONZALEZ CHARPENTIER');
INSERT INTO candidato VALUES (11136466, 'A', 50, 2545, 401, 4, 'ERIKA JEANETTE GALARCE MELENDEZ', 'ERIKA JEANETTE GALARCE MELENDEZ', '', false, 'None', 'ERIKA JEANETTE', 'GALARCE MELENDEZ');
INSERT INTO candidato VALUES (12818184, 'A', 51, 2545, 400, 99, 'MARCOS MORALES URETA', 'MARCOS MORALES URETA', '', false, 'None', 'MARCOS', 'MORALES URETA');
INSERT INTO candidato VALUES (7142943, 'A', 52, 2545, 999, 99, 'JUAN CARLOS GONZALEZ ROMO', 'JUAN CARLOS GONZALEZ ROMO', '', true, 'None', 'JUAN CARLOS', 'GONZALEZ ROMO');
INSERT INTO candidato VALUES (5342163, 'A', 50, 2546, 432, 203, 'ELISEO FILOMENO MORALES HENRIQUEZ', 'ELISEO FILOMENO MORALES HENRIQUEZ', '', false, 'None', 'ELISEO FILOMENO', 'MORALES HENRIQUEZ');
INSERT INTO candidato VALUES (12447840, 'A', 51, 2546, 399, 99, 'JORGE SAN MARTIN GUTIERREZ', 'JORGE SAN MARTIN GUTIERREZ', '', false, 'None', 'JORGE', 'SAN MARTIN GUTIERREZ');
INSERT INTO candidato VALUES (10760909, 'A', 52, 2546, 400, 1, 'MARITZA VERDEJO ACUÑA', 'MARITZA VERDEJO ACUÑA', '', false, 'None', 'MARITZA', 'VERDEJO ACUÑA');
INSERT INTO candidato VALUES (18706176, 'A', 53, 2546, 999, 99, 'ALEJANDRO IGNACIO SEPULVEDA SANTANDER', 'ALEJANDRO IGNACIO SEPULVEDA SANTANDER', '', true, 'None', 'ALEJANDRO IGNACIO', 'SEPULVEDA SANTANDER');
INSERT INTO candidato VALUES (17064381, 'A', 54, 2546, 999, 99, 'JACQUELINE SOLEDAD PAILLALEF VEGA', 'JACQUELINE SOLEDAD PAILLALEF VEGA', '', true, 'None', 'JACQUELINE SOLEDAD', 'PAILLALEF VEGA');
INSERT INTO candidato VALUES (10030052, 'A', 55, 2546, 999, 99, 'ROLANDO HERNAN SILVA FUENTES', 'ROLANDO HERNAN SILVA FUENTES', '', true, 'None', 'ROLANDO HERNAN', 'SILVA FUENTES');
INSERT INTO candidato VALUES (15936487, 'A', 56, 2546, 999, 99, 'TAMARA TELLO GALLO', 'TAMARA TELLO GALLO', '', true, 'None', 'TAMARA', 'TELLO GALLO');
INSERT INTO candidato VALUES (18922005, 'A', 57, 2546, 999, 99, 'JORGE YEISSON COLLAO CANCINO', 'JORGE YEISSON COLLAO CANCINO', '', true, 'None', 'JORGE YEISSON', 'COLLAO CANCINO');
INSERT INTO candidato VALUES (12402000, 'A', 58, 2546, 999, 99, 'ANDRES MARCELO SAN MARTIN SAEZ', 'ANDRES MARCELO SAN MARTIN SAEZ', '', true, 'None', 'ANDRES MARCELO', 'SAN MARTIN SAEZ');
INSERT INTO candidato VALUES (7699355, 'A', 59, 2546, 999, 99, 'JOSE RICARDO VARAS ZUÑIGA', 'JOSE RICARDO VARAS ZUÑIGA', '', true, 'None', 'JOSE RICARDO', 'VARAS ZUÑIGA');
INSERT INTO candidato VALUES (14579469, 'A', 50, 2547, 432, 99, 'MANUEL ALEJANDRO DIAZ BARRAZA', 'MANUEL ALEJANDRO DIAZ BARRAZA', '', false, 'None', 'MANUEL', 'DIAZ');
INSERT INTO candidato VALUES (17993305, 'A', 51, 2547, 401, 232, 'MACARENA CAROLINA RIPAMONTI SERRANO', 'MACARENA CAROLINA RIPAMONTI SERRANO', '', false, 'None', 'MACARENA', 'RIPAMONTI');
INSERT INTO candidato VALUES (15486253, 'A', 50, 2548, 401, 99, 'JULIETTE HOTUS PAOA', 'JULIETTE HOTUS PAOA', '', false, 'None', 'JULIETTE', 'HOTUS PAOA');
INSERT INTO candidato VALUES (10532954, 'A', 52, 2547, 999, 99, 'IVAN PODUJE CAPDEVILLE', 'IVAN PODUJE CAPDEVILLE', '', true, 'None', 'IVAN', 'PODUJE');
INSERT INTO candidato VALUES (14157894, 'A', 51, 2548, 444, 99, 'CAMILO ALEJANDRO RAPU RIROROKO', 'CAMILO ALEJANDRO RAPU RIROROKO', '', false, 'None', 'CAMILO ALEJANDRO', 'RAPU RIROROKO');
INSERT INTO candidato VALUES (13754654, 'A', 52, 2548, 400, 1, 'MAI TEAO OSORIO', 'MAI TEAO OSORIO', '', false, 'None', 'MAI', 'TEAO OSORIO');
INSERT INTO candidato VALUES (12159003, 'A', 53, 2548, 999, 99, 'ELIZABETH JOANA AREVALO PAKARATI', 'ELIZABETH JOANA AREVALO PAKARATI', '', true, 'None', 'ELIZABETH JOANA', 'AREVALO PAKARATI');
INSERT INTO candidato VALUES (12864532, 'A', 50, 2549, 401, 130, 'BENIGNO ALEJANDRO RETAMAL RODRIGUEZ', 'BENIGNO ALEJANDRO RETAMAL RODRIGUEZ', '', false, 'None', 'BENIGNO ALEJANDRO', 'RETAMAL RODRIGUEZ');
INSERT INTO candidato VALUES (17468955, 'A', 51, 2549, 418, 157, 'BONNIE JHOAN ROMILDO SILVA VILLARROEL', 'BONNIE JHOAN ROMILDO SILVA VILLARROEL', '', false, 'None', 'BONNIE JHOAN ROMILDO', 'SILVA VILLARROEL');
INSERT INTO candidato VALUES (7657774, 'A', 52, 2549, 400, 3, 'MANUEL RIVERA MARTINEZ', 'MANUEL RIVERA MARTINEZ', '', false, 'None', 'MANUEL', 'RIVERA MARTINEZ');
INSERT INTO candidato VALUES (16100701, 'A', 53, 2549, 999, 99, 'NICOLAS ANTONIO PIRAZZOLI BORRAS', 'NICOLAS ANTONIO PIRAZZOLI BORRAS', '', true, 'None', 'NICOLAS ANTONIO', 'PIRAZZOLI BORRAS');
INSERT INTO candidato VALUES (8909747, 'A', 54, 2549, 999, 99, 'JUAN HERRERA DELGADO', 'JUAN HERRERA DELGADO', '', true, 'None', 'JUAN', 'HERRERA DELGADO');
INSERT INTO candidato VALUES (15061633, 'A', 50, 2550, 401, 5, 'DINA PATRICIA GONZALEZ ALFARO', 'DINA PATRICIA GONZALEZ ALFARO', '', false, 'None', 'DINA PATRICIA', 'GONZALEZ ALFARO');
INSERT INTO candidato VALUES (11943635, 'A', 51, 2550, 400, 99, 'MARCELO CASTILLO VARAS', 'MARCELO CASTILLO VARAS', '', false, 'None', 'MARCELO', 'CASTILLO VARAS');
INSERT INTO candidato VALUES (12931214, 'A', 52, 2550, 999, 99, 'FRESIA RUTH QUEZADA CONTRERAS', 'FRESIA RUTH QUEZADA CONTRERAS', '', true, 'None', 'FRESIA RUTH', 'QUEZADA CONTRERAS');
INSERT INTO candidato VALUES (8905584, 'A', 53, 2550, 999, 99, 'HECTOR RODRIGO SILVA TAPIA', 'HECTOR RODRIGO SILVA TAPIA', '', true, 'None', 'HECTOR RODRIGO', 'SILVA TAPIA');
INSERT INTO candidato VALUES (14101572, 'A', 50, 2551, 401, 99, 'JUAN CASTILLO VALLE', 'JUAN CASTILLO VALLE', '', false, 'None', 'JUAN', 'CASTILLO VALLE');
INSERT INTO candidato VALUES (13752839, 'A', 51, 2551, 418, 99, 'GABRIELA ALEJANDRA RUBILAR LOPEZ', 'GABRIELA ALEJANDRA RUBILAR LOPEZ', '', false, 'None', 'GABRIELA ALEJANDRA', 'RUBILAR LOPEZ');
INSERT INTO candidato VALUES (13827494, 'A', 52, 2551, 444, 198, 'MYRIAM ITURRIETA CRUZ', 'MYRIAM ITURRIETA CRUZ', '', false, 'None', 'MYRIAM', 'ITURRIETA CRUZ');
INSERT INTO candidato VALUES (17469656, 'A', 53, 2551, 439, 150, 'VALERIA ESPINOZA ASTORGA', 'VALERIA ESPINOZA ASTORGA', '', false, 'None', 'VALERIA', 'ESPINOZA ASTORGA');
INSERT INTO candidato VALUES (6261177, 'A', 54, 2551, 400, 99, 'JUAN GALDAMES CARMONA', 'JUAN GALDAMES CARMONA', '', false, 'None', 'JUAN', 'GALDAMES CARMONA');
INSERT INTO candidato VALUES (12167399, 'A', 55, 2551, 999, 99, 'CARLOS MONTENEGRO URBINA', 'CARLOS MONTENEGRO URBINA', '', true, 'None', 'CARLOS', 'MONTENEGRO URBINA');
INSERT INTO candidato VALUES (15555560, 'A', 56, 2551, 999, 99, 'JUAN ANTONIO LOBOS VIGUERA', 'JUAN ANTONIO LOBOS VIGUERA', '', true, 'None', 'JUAN ANTONIO', 'LOBOS VIGUERA');
INSERT INTO candidato VALUES (16851137, 'A', 57, 2551, 999, 99, 'CARLA STEFANNY CABELLO FIGUEROA', 'CARLA STEFANNY CABELLO FIGUEROA', '', true, 'None', 'CARLA STEFANNY', 'CABELLO FIGUEROA');
INSERT INTO candidato VALUES (17534867, 'A', 58, 2551, 999, 99, 'VIVIANA AVILA SILVA', 'VIVIANA AVILA SILVA', '', true, 'None', 'VIVIANA', 'AVILA SILVA');
INSERT INTO candidato VALUES (9611178, 'A', 50, 2552, 401, 5, 'PATRICIO LORENZO SUAREZ SUAREZ', 'PATRICIO LORENZO SUAREZ SUAREZ', '', false, 'None', 'PATRICIO LORENZO', 'SUAREZ SUAREZ');
INSERT INTO candidato VALUES (13981510, 'A', 51, 2552, 999, 99, 'CHRISTIAN MAURICIO ORTEGA VILLAGRAS', 'CHRISTIAN MAURICIO ORTEGA VILLAGRAS', '', true, 'None', 'CHRISTIAN MAURICIO', 'ORTEGA VILLAGRAS');
INSERT INTO candidato VALUES (9269971, 'A', 52, 2552, 999, 99, 'RENE ALEJANDRO MARDONES VALENCIA', 'RENE ALEJANDRO MARDONES VALENCIA', '', true, 'None', 'RENE ALEJANDRO', 'MARDONES VALENCIA');
INSERT INTO candidato VALUES (12498309, 'A', 50, 2553, 432, 99, 'ARMANDO ANTONIO CASTILLO RIQUELME', 'ARMANDO ANTONIO CASTILLO RIQUELME', '', false, 'None', 'ARMANDO ANTONIO', 'CASTILLO RIQUELME');
INSERT INTO candidato VALUES (11221664, 'A', 51, 2553, 399, 99, 'FELIPE HERRERA ROCO', 'FELIPE HERRERA ROCO', '', false, 'None', 'FELIPE', 'HERRERA ROCO');
INSERT INTO candidato VALUES (10940349, 'A', 52, 2553, 401, 232, 'LORENA CECILIA DONAIRE CATALDO', 'LORENA CECILIA DONAIRE CATALDO', '', false, 'None', 'LORENA CECILIA', 'DONAIRE CATALDO');
INSERT INTO candidato VALUES (17120316, 'A', 53, 2553, 400, 3, 'ANDRES SOZA REINOSO', 'ANDRES SOZA REINOSO', '', false, 'None', 'ANDRES', 'SOZA REINOSO');
INSERT INTO candidato VALUES (14529854, 'A', 54, 2553, 999, 99, 'SEVERINA DE GRACIA DE SANCHEZ', 'SEVERINA DE GRACIA DE SANCHEZ', '', true, 'None', 'SEVERINA', 'DE GRACIA DE SANCHEZ');
INSERT INTO candidato VALUES (12578274, 'A', 55, 2553, 999, 99, 'PAOLA JANET LAZO CHACANA', 'PAOLA JANET LAZO CHACANA', '', true, 'None', 'PAOLA JANET', 'LAZO CHACANA');
INSERT INTO candidato VALUES (11942337, 'A', 56, 2553, 999, 99, 'PATRICIO PALLARES VALENZUELA', 'PATRICIO PALLARES VALENZUELA', '', true, 'None', 'PATRICIO', 'PALLARES VALENZUELA');
INSERT INTO candidato VALUES (9590780, 'A', 57, 2553, 999, 99, 'ARMANDO AQUILES TORREALBA ABARCA', 'ARMANDO AQUILES TORREALBA ABARCA', '', true, 'None', 'ARMANDO AQUILES', 'TORREALBA ABARCA');
INSERT INTO candidato VALUES (12599094, 'A', 50, 2554, 401, 2, 'VICTOR DONOSO OYANEDEL', 'VICTOR DONOSO OYANEDEL', '', false, 'None', 'VICTOR', 'DONOSO OYANEDEL');
INSERT INTO candidato VALUES (6978416, 'A', 51, 2554, 439, 99, 'GONZALO MIQUEL WENKE', 'GONZALO MIQUEL WENKE', '', false, 'None', 'GONZALO', 'MIQUEL WENKE');
INSERT INTO candidato VALUES (5636617, 'A', 52, 2554, 999, 99, 'PATRICIO ALIAGA DIAZ', 'PATRICIO ALIAGA DIAZ', '', true, 'None', 'PATRICIO', 'ALIAGA DIAZ');
INSERT INTO candidato VALUES (18651329, 'A', 53, 2554, 999, 99, 'PIERA ROMINA COLLAO SEGURA', 'PIERA ROMINA COLLAO SEGURA', '', true, 'None', 'PIERA ROMINA', 'COLLAO SEGURA');
INSERT INTO candidato VALUES (8390849, 'A', 54, 2554, 999, 99, 'NELSON FERNANDO LAZCANO SILVA', 'NELSON FERNANDO LAZCANO SILVA', '', true, 'None', 'NELSON FERNANDO', 'LAZCANO SILVA');
INSERT INTO candidato VALUES (8460410, 'A', 50, 2555, 401, 2, 'JAIME AHUMADA ROBLES', 'JAIME AHUMADA ROBLES', '', false, 'None', 'JAIME', 'AHUMADA ROBLES');
INSERT INTO candidato VALUES (13979658, 'A', 51, 2555, 400, 1, 'CLAUDIA ADASME DONOSO', 'CLAUDIA ADASME DONOSO', '', false, 'None', 'CLAUDIA', 'ADASME DONOSO');
INSERT INTO candidato VALUES (8320872, 'A', 52, 2555, 999, 99, 'ROSA DE LOURDES PRIETO VALDES', 'ROSA DE LOURDES PRIETO VALDES', '', true, 'None', 'ROSA DE LOURDES', 'PRIETO VALDES');
INSERT INTO candidato VALUES (18516816, 'A', 53, 2555, 999, 99, 'MARGARITA JESUS SANDOVAL CARRASCO', 'MARGARITA JESUS SANDOVAL CARRASCO', '', true, 'None', 'MARGARITA JESUS', 'SANDOVAL CARRASCO');
INSERT INTO candidato VALUES (13361250, 'A', 50, 2556, 401, 99, 'IGNACIO GAMALIER VILLALOBOS HENRIQUEZ', 'IGNACIO GAMALIER VILLALOBOS HENRIQUEZ', '', false, 'None', 'IGNACIO GAMALIER', 'VILLALOBOS HENRIQUEZ');
INSERT INTO candidato VALUES (18449817, 'A', 51, 2556, 400, 99, 'GUSTAVO HENRIQUEZ TOLEDO', 'GUSTAVO HENRIQUEZ TOLEDO', '', false, 'None', 'GUSTAVO', 'HENRIQUEZ TOLEDO');
INSERT INTO candidato VALUES (8163741, 'A', 52, 2556, 999, 99, 'GUSTAVO FERNANDO VALDENEGRO RUBILLO', 'GUSTAVO FERNANDO VALDENEGRO RUBILLO', '', true, 'None', 'GUSTAVO FERNANDO', 'VALDENEGRO RUBILLO');
INSERT INTO candidato VALUES (15960626, 'A', 50, 2557, 400, 99, 'GUSTAVO ALESSANDRI BASCUÑAN', 'GUSTAVO ALESSANDRI BASCUÑAN', '', false, 'None', 'GUSTAVO', 'ALESSANDRI BASCUÑAN');
INSERT INTO candidato VALUES (13240642, 'A', 51, 2557, 999, 99, 'CAROLINA LETELIER RIUMALLO', 'CAROLINA LETELIER RIUMALLO', '', true, 'None', 'CAROLINA', 'LETELIER RIUMALLO');
INSERT INTO candidato VALUES (12164870, 'A', 52, 2557, 999, 99, 'JACQUELINE MOLINA VILLARROEL', 'JACQUELINE MOLINA VILLARROEL', '', true, 'None', 'JACQUELINE', 'MOLINA VILLARROEL');
INSERT INTO candidato VALUES (10523961, 'A', 50, 2558, 439, 99, 'GUSTAVO BERTELSEN MAYOL', 'GUSTAVO BERTELSEN MAYOL', '', false, 'None', 'GUSTAVO', 'BERTELSEN MAYOL');
INSERT INTO candidato VALUES (8477743, 'A', 51, 2558, 999, 99, 'OSCAR RODOLFO CALDERON SANCHEZ', 'OSCAR RODOLFO CALDERON SANCHEZ', '', true, 'None', 'OSCAR RODOLFO', 'CALDERON SANCHEZ');
INSERT INTO candidato VALUES (9004430, 'A', 52, 2558, 999, 99, 'LUIS ALBERTO MELLA GAJARDO', 'LUIS ALBERTO MELLA GAJARDO', '', true, 'None', 'LUIS ALBERTO', 'MELLA GAJARDO');
INSERT INTO candidato VALUES (13365455, 'A', 50, 2559, 401, 99, 'JOHNNY PIRAINO MENESES', 'JOHNNY PIRAINO MENESES', '', false, 'None', 'JOHNNY', 'PIRAINO MENESES');
INSERT INTO candidato VALUES (8583345, 'A', 51, 2559, 999, 99, 'EDUARDO IGNACIO MARTINEZ MACHUCA', 'EDUARDO IGNACIO MARTINEZ MACHUCA', '', true, 'None', 'EDUARDO IGNACIO', 'MARTINEZ MACHUCA');
INSERT INTO candidato VALUES (12819067, 'A', 50, 2560, 401, 99, 'JOSE RAFAEL SAAVEDRA IBACACHE', 'JOSE RAFAEL SAAVEDRA IBACACHE', '', false, 'None', 'JOSE RAFAEL', 'SAAVEDRA IBACACHE');
INSERT INTO candidato VALUES (14313316, 'A', 51, 2560, 400, 99, 'RAFAEL PACHECO SOLIS', 'RAFAEL PACHECO SOLIS', '', false, 'None', 'RAFAEL', 'PACHECO SOLIS');
INSERT INTO candidato VALUES (8158052, 'A', 52, 2560, 999, 99, 'VERONICA PAZ MARIA ROSSAT ARRIAGADA', 'VERONICA PAZ MARIA ROSSAT ARRIAGADA', '', true, 'None', 'VERONICA PAZ MARIA', 'ROSSAT ARRIAGADA');
INSERT INTO candidato VALUES (15683167, 'A', 50, 2561, 399, 99, 'PAOLO SANHUEZA BERETTA', 'PAOLO SANHUEZA BERETTA', '', false, 'None', 'PAOLO', 'SANHUEZA BERETTA');
INSERT INTO candidato VALUES (10711135, 'A', 51, 2561, 401, 5, 'FILOMENA AIDA NAVIA HEVIA', 'FILOMENA AIDA NAVIA HEVIA', '', false, 'None', 'FILOMENA AIDA', 'NAVIA HEVIA');
INSERT INTO candidato VALUES (15817446, 'A', 52, 2561, 444, 99, 'ROLANDO GONZALO ARCOS ARREDONDO', 'ROLANDO GONZALO ARCOS ARREDONDO', '', false, 'None', 'ROLANDO GONZALO', 'ARCOS ARREDONDO');
INSERT INTO candidato VALUES (7053370, 'A', 53, 2561, 400, 3, 'MAITE LARRONDO LABORDE', 'MAITE LARRONDO LABORDE', '', false, 'None', 'MAITE', 'LARRONDO LABORDE');
INSERT INTO candidato VALUES (16755870, 'A', 50, 2562, 401, 6, 'JONATHAN MOISES VASQUEZ LEON', 'JONATHAN MOISES VASQUEZ LEON', '', false, 'None', 'JONATHAN MOISES', 'VASQUEZ LEON');
INSERT INTO candidato VALUES (9049656, 'A', 51, 2562, 439, 99, 'BERNARDO BRITO VIDELA', 'BERNARDO BRITO VIDELA', '', false, 'None', 'BERNARDO', 'BRITO VIDELA');
INSERT INTO candidato VALUES (15062422, 'A', 52, 2562, 400, 99, 'LESLIE PACHECO RAMIREZ', 'LESLIE PACHECO RAMIREZ', '', false, 'None', 'LESLIE', 'PACHECO RAMIREZ');
INSERT INTO candidato VALUES (13364747, 'A', 53, 2562, 999, 99, 'RICARDO ALIAGA CRUZ', 'RICARDO ALIAGA CRUZ', '', true, 'None', 'RICARDO', 'ALIAGA CRUZ');
INSERT INTO candidato VALUES (10908053, 'A', 54, 2562, 999, 99, 'CARLOS ENRIQUE DIAZ LILLO', 'CARLOS ENRIQUE DIAZ LILLO', '', true, 'None', 'CARLOS ENRIQUE', 'DIAZ LILLO');
INSERT INTO candidato VALUES (10129787, 'A', 55, 2562, 999, 99, 'MARGARITA DE LAS MERCEDES OSORIO PIZARRO', 'MARGARITA DE LAS MERCEDES OSORIO PIZARRO', '', true, 'None', 'MARGARITA DE LAS MERCEDES', 'OSORIO PIZARRO');
INSERT INTO candidato VALUES (9431118, 'A', 56, 2562, 999, 99, 'EDWIN GRIFFITHS GUERRA', 'EDWIN GRIFFITHS GUERRA', '', true, 'None', 'EDWIN', 'GRIFFITHS GUERRA');
INSERT INTO candidato VALUES (7321029, 'A', 50, 2563, 399, 99, 'ALVARO JOSE IGNACIO CASANOVA MORA', 'ALVARO JOSE IGNACIO CASANOVA MORA', '', false, 'None', 'ALVARO JOSE IGNACIO', 'CASANOVA MORA');
INSERT INTO candidato VALUES (13068925, 'A', 51, 2563, 401, 99, 'GONZALO ANDRES VEGA MORENO', 'GONZALO ANDRES VEGA MORENO', '', false, 'None', 'GONZALO ANDRES', 'VEGA MORENO');
INSERT INTO candidato VALUES (8151833, 'A', 52, 2563, 439, 150, 'ENRIQUE JAIME BAHAMONDE LAGOS', 'ENRIQUE JAIME BAHAMONDE LAGOS', '', false, 'None', 'ENRIQUE JAIME', 'BAHAMONDE LAGOS');
INSERT INTO candidato VALUES (5720492, 'A', 53, 2563, 999, 99, 'OMAR VERA CASTRO', 'OMAR VERA CASTRO', '', true, 'None', 'OMAR', 'VERA CASTRO');
INSERT INTO candidato VALUES (15636409, 'A', 54, 2563, 999, 99, 'MARIA CONSTANZA LIZANA SIERRA', 'MARIA CONSTANZA LIZANA SIERRA', '', true, 'None', 'MARIA CONSTANZA', 'LIZANA SIERRA');
INSERT INTO candidato VALUES (8504440, 'A', 55, 2563, 999, 99, 'MARIO DEL CARMEN BOTRO MOYA', 'MARIO DEL CARMEN BOTRO MOYA', '', true, 'None', 'MARIO DEL CARMEN', 'BOTRO MOYA');
INSERT INTO candidato VALUES (6966881, 'A', 50, 2564, 399, 99, 'GASTON DUBOURNAIS RIVEROS', 'GASTON DUBOURNAIS RIVEROS', '', false, 'None', 'GASTON', 'DUBOURNAIS RIVEROS');
INSERT INTO candidato VALUES (10457165, 'A', 51, 2564, 400, 1, 'MARCO ANTONIO GONZALEZ CANDIA', 'MARCO ANTONIO GONZALEZ CANDIA', '', false, 'None', 'MARCO ANTONIO', 'GONZALEZ CANDIA');
INSERT INTO candidato VALUES (9833526, 'A', 52, 2564, 999, 99, 'MARCELA MARITZA MANSILLA POTOCNJAK', 'MARCELA MARITZA MANSILLA POTOCNJAK', '', true, 'None', 'MARCELA MARITZA', 'MANSILLA POTOCNJAK');
INSERT INTO candidato VALUES (12312693, 'A', 53, 2564, 999, 99, 'CARLOS ORLANDO TAPIA AVILES', 'CARLOS ORLANDO TAPIA AVILES', '', true, 'None', 'CARLOS ORLANDO', 'TAPIA AVILES');
INSERT INTO candidato VALUES (13545878, 'A', 54, 2564, 999, 99, 'VERONICA MARICEL CUETO CUETO', 'VERONICA MARICEL CUETO CUETO', '', true, 'None', 'VERONICA MARICEL', 'CUETO CUETO');
INSERT INTO candidato VALUES (18337145, 'A', 55, 2564, 999, 99, 'ALEJANDRO FELIPE RICOTTI SEPULVEDA', 'ALEJANDRO FELIPE RICOTTI SEPULVEDA', '', true, 'None', 'ALEJANDRO FELIPE', 'RICOTTI SEPULVEDA');
INSERT INTO candidato VALUES (7254677, 'A', 56, 2564, 999, 99, 'MARIA LUISA HAMILTON VELASCO', 'MARIA LUISA HAMILTON VELASCO', '', true, 'None', 'MARIA LUISA', 'HAMILTON VELASCO');
INSERT INTO candidato VALUES (16279870, 'A', 50, 2565, 399, 197, 'CYNTHIA ACUÑA SILVA', 'CYNTHIA ACUÑA SILVA', '', false, 'None', 'CYNTHIA', 'ACUÑA SILVA');
INSERT INTO candidato VALUES (14475555, 'A', 51, 2565, 401, 4, 'PATRICIA ALEJANDRA QUIROZ PEHUENCHE', 'PATRICIA ALEJANDRA QUIROZ PEHUENCHE', '', false, 'None', 'PATRICIA ALEJANDRA', 'QUIROZ PEHUENCHE');
INSERT INTO candidato VALUES (9963480, 'A', 52, 2565, 444, 198, 'RAUL EDUARDO LORCA MERINO', 'RAUL EDUARDO LORCA MERINO', '', false, 'None', 'RAUL EDUARDO', 'LORCA MERINO');
INSERT INTO candidato VALUES (15086847, 'A', 53, 2565, 400, 99, 'LIDIA SILVA GARCIA', 'LIDIA SILVA GARCIA', '', false, 'None', 'LIDIA', 'SILVA GARCIA');
INSERT INTO candidato VALUES (15335815, 'A', 54, 2565, 999, 99, 'FANY ALEJANDRA ZUÑIGA ZUÑIGA', 'FANY ALEJANDRA ZUÑIGA ZUÑIGA', '', true, 'None', 'FANY ALEJANDRA', 'ZUÑIGA ZUÑIGA');
INSERT INTO candidato VALUES (12135667, 'A', 55, 2565, 999, 99, 'OSVALDO CARTAGENA GARCIA', 'OSVALDO CARTAGENA GARCIA', '', true, 'None', 'OSVALDO', 'CARTAGENA GARCIA');
INSERT INTO candidato VALUES (14003687, 'A', 50, 2566, 401, 2, 'NATALIA CARRASCO PIZARRO', 'NATALIA CARRASCO PIZARRO', '', false, 'None', 'NATALIA', 'CARRASCO PIZARRO');
INSERT INTO candidato VALUES (13368689, 'A', 51, 2566, 400, 99, 'JOSE MORAGA LIRA', 'JOSE MORAGA LIRA', '', false, 'None', 'JOSE', 'MORAGA LIRA');
INSERT INTO candidato VALUES (12514325, 'A', 52, 2566, 999, 99, 'JOSE ANTONIO JOFRE BUSTOS', 'JOSE ANTONIO JOFRE BUSTOS', '', true, 'None', 'JOSE ANTONIO', 'JOFRE BUSTOS');
INSERT INTO candidato VALUES (13052475, 'A', 53, 2566, 999, 99, 'LEONARDO FRANCISCO GOMEZ VALDES', 'LEONARDO FRANCISCO GOMEZ VALDES', '', true, 'None', 'LEONARDO FRANCISCO', 'GOMEZ VALDES');
INSERT INTO candidato VALUES (9505477, 'A', 50, 2567, 401, 5, 'ALFONSO ADRIAN MUÑOZ ARAVENA', 'ALFONSO ADRIAN MUÑOZ ARAVENA', '', false, 'None', 'ALFONSO ADRIAN', 'MUÑOZ ARAVENA');
INSERT INTO candidato VALUES (8849396, 'A', 51, 2567, 999, 99, 'GLORIA CARRASCO NUÑEZ', 'GLORIA CARRASCO NUÑEZ', '', true, 'None', 'GLORIA', 'CARRASCO NUÑEZ');
INSERT INTO candidato VALUES (15836844, 'A', 52, 2567, 999, 99, 'JOSE ANTONIO VEAS BERRIOS', 'JOSE ANTONIO VEAS BERRIOS', '', true, 'None', 'JOSE ANTONIO', 'VEAS BERRIOS');
INSERT INTO candidato VALUES (9410062, 'A', 53, 2567, 999, 99, 'ALVARO SANTANA CONTRERAS', 'ALVARO SANTANA CONTRERAS', '', true, 'None', 'ALVARO', 'SANTANA CONTRERAS');
INSERT INTO candidato VALUES (13693016, 'A', 54, 2567, 999, 99, 'MAXIMILIANO ESTEBAN AVILES MARAMBIO', 'MAXIMILIANO ESTEBAN AVILES MARAMBIO', '', true, 'None', 'MAXIMILIANO ESTEBAN', 'AVILES MARAMBIO');
INSERT INTO candidato VALUES (13338373, 'A', 55, 2567, 999, 99, 'MARIBEL ANDREA LEIVA CABRERA', 'MARIBEL ANDREA LEIVA CABRERA', '', true, 'None', 'MARIBEL ANDREA', 'LEIVA CABRERA');
INSERT INTO candidato VALUES (9702497, 'A', 50, 2568, 399, 99, 'AUGUSTO PINOCHET MOLINA', 'AUGUSTO PINOCHET MOLINA', '', false, 'None', 'AUGUSTO', 'PINOCHET MOLINA');
INSERT INTO candidato VALUES (11738078, 'A', 51, 2568, 400, 1, 'DINO LOTITO FLORES', 'DINO LOTITO FLORES', '', false, 'None', 'DINO', 'LOTITO FLORES');
INSERT INTO candidato VALUES (10716743, 'A', 52, 2568, 999, 99, 'FERNANDO JOSE RODRIGUEZ LARRAIN', 'FERNANDO JOSE RODRIGUEZ LARRAIN', '', true, 'None', 'FERNANDO JOSE', 'RODRIGUEZ LARRAIN');
INSERT INTO candidato VALUES (14489296, 'A', 50, 2569, 399, 197, 'JEHIELLY JARUFE JOFRE', 'JEHIELLY JARUFE JOFRE', '', false, 'None', 'JEHIELLY', 'JARUFE JOFRE');
INSERT INTO candidato VALUES (5121675, 'A', 51, 2569, 401, 99, 'CARMEN CASTILLO TAUCHER', 'CARMEN CASTILLO TAUCHER', '', false, 'None', 'CARMEN', 'CASTILLO TAUCHER');
INSERT INTO candidato VALUES (7387563, 'A', 52, 2569, 439, 150, 'GUILLERMO DAMASO FLORES LEIVA', 'GUILLERMO DAMASO FLORES LEIVA', '', false, 'None', 'GUILLERMO DAMASO', 'FLORES LEIVA');
INSERT INTO candidato VALUES (6803357, 'A', 53, 2569, 400, 99, 'CHRISTIAN BEALS CAMPOS', 'CHRISTIAN BEALS CAMPOS', '', false, 'None', 'CHRISTIAN', 'BEALS CAMPOS');
INSERT INTO candidato VALUES (9315870, 'A', 54, 2569, 999, 99, 'PATRICIA IVONNE BOFFA CASAS', 'PATRICIA IVONNE BOFFA CASAS', '', true, 'None', 'PATRICIA IVONNE', 'BOFFA CASAS');
INSERT INTO candidato VALUES (12599701, 'A', 50, 2570, 401, 99, 'RODRIGO EDUARDO DIAZ BRITO', 'RODRIGO EDUARDO DIAZ BRITO', '', false, 'None', 'RODRIGO EDUARDO', 'DIAZ BRITO');
INSERT INTO candidato VALUES (7021540, 'A', 51, 2570, 400, 99, 'BORIS LUKSIC NIETO', 'BORIS LUKSIC NIETO', '', false, 'None', 'BORIS', 'LUKSIC NIETO');
INSERT INTO candidato VALUES (16701397, 'A', 50, 2571, 401, 2, 'EDGARDO GONZALEZ ARANCIBIA', 'EDGARDO GONZALEZ ARANCIBIA', '', false, 'None', 'EDGARDO', 'GONZALEZ ARANCIBIA');
INSERT INTO candidato VALUES (10492807, 'A', 51, 2571, 400, 99, 'MARIO MARCHANT SILVA', 'MARIO MARCHANT SILVA', '', false, 'None', 'MARIO', 'MARCHANT SILVA');
INSERT INTO candidato VALUES (12600639, 'A', 52, 2571, 999, 99, 'DANIEL ZAMORA HINOSTROZA', 'DANIEL ZAMORA HINOSTROZA', '', true, 'None', 'DANIEL', 'ZAMORA HINOSTROZA');
INSERT INTO candidato VALUES (12949256, 'A', 50, 2572, 401, 99, 'GONZALO VERGARA LIZANA', 'GONZALO VERGARA LIZANA', '', false, 'None', 'GONZALO', 'VERGARA LIZANA');
INSERT INTO candidato VALUES (7725016, 'A', 51, 2572, 999, 99, 'LUIS REINALDO PRADENAS MORAN', 'LUIS REINALDO PRADENAS MORAN', '', true, 'None', 'LUIS REINALDO', 'PRADENAS MORAN');
INSERT INTO candidato VALUES (10548016, 'A', 50, 2573, 401, 99, 'MAURICIO ANTONIO QUIROZ CHAMORRO', 'MAURICIO ANTONIO QUIROZ CHAMORRO', '', false, 'None', 'MAURICIO ANTONIO', 'QUIROZ CHAMORRO');
INSERT INTO candidato VALUES (16256971, 'A', 51, 2573, 400, 1, 'MIGUEL IGNACIO ORTIZ HENRIQUEZ', 'MIGUEL IGNACIO ORTIZ HENRIQUEZ', '', false, 'None', 'MIGUEL IGNACIO', 'ORTIZ HENRIQUEZ');
INSERT INTO candidato VALUES (12948631, 'A', 52, 2573, 999, 99, 'PATRICIO ERNESTO GONZALEZ NUÑEZ', 'PATRICIO ERNESTO GONZALEZ NUÑEZ', '', true, 'None', 'PATRICIO ERNESTO', 'GONZALEZ NUÑEZ');
INSERT INTO candidato VALUES (9716683, 'A', 50, 2574, 401, 99, 'CLAUDIO PATRICIO ZURITA IBARRA', 'CLAUDIO PATRICIO ZURITA IBARRA', '', false, 'None', 'CLAUDIO PATRICIO', 'ZURITA IBARRA');
INSERT INTO candidato VALUES (15517959, 'A', 50, 2575, 401, 232, 'VALERIA ANDREA MELIPILLAN FIGUEROA', 'VALERIA ANDREA MELIPILLAN FIGUEROA', '', false, 'None', 'VALERIA ANDREA', 'MELIPILLAN FIGUEROA');
INSERT INTO candidato VALUES (10968897, 'A', 51, 2575, 400, 1, 'CAROLINA CORTI BADIA', 'CAROLINA CORTI BADIA', '', false, 'None', 'CAROLINA', 'CORTI BADIA');
INSERT INTO candidato VALUES (15557178, 'A', 52, 2575, 999, 99, 'CHRISTIAN ARTURO CARDENAS SILVA', 'CHRISTIAN ARTURO CARDENAS SILVA', '', true, 'None', 'CHRISTIAN ARTURO', 'CARDENAS SILVA');
INSERT INTO candidato VALUES (12088379, 'A', 53, 2575, 999, 99, 'MIGUEL ANGEL BOTTO SALINAS', 'MIGUEL ANGEL BOTTO SALINAS', '', true, 'None', 'MIGUEL ANGEL', 'BOTTO SALINAS');
INSERT INTO candidato VALUES (16677605, 'A', 50, 2576, 399, 99, 'ORIANA PEREZ PUEBLA', 'ORIANA PEREZ PUEBLA', '', false, 'None', 'ORIANA', 'PEREZ PUEBLA');
INSERT INTO candidato VALUES (16302577, 'A', 51, 2576, 401, 232, 'SEBASTIAN ENRIQUE BALBONTIN BUSTAMANTE', 'SEBASTIAN ENRIQUE BALBONTIN BUSTAMANTE', '', false, 'None', 'SEBASTIAN ENRIQUE', 'BALBONTIN BUSTAMANTE');
INSERT INTO candidato VALUES (16819401, 'A', 52, 2576, 400, 99, 'LUCIANO VALENZUELA ROMERO', 'LUCIANO VALENZUELA ROMERO', '', false, 'None', 'LUCIANO', 'VALENZUELA ROMERO');
INSERT INTO candidato VALUES (8795379, 'A', 53, 2576, 999, 99, 'AMAL DEL CARMEN SALEM SOLIS', 'AMAL DEL CARMEN SALEM SOLIS', '', true, 'None', 'AMAL DEL CARMEN', 'SALEM SOLIS');
INSERT INTO candidato VALUES (13014655, 'A', 54, 2576, 999, 99, 'YERKO FABIAN CHAMORRO SIGDMAN', 'YERKO FABIAN CHAMORRO SIGDMAN', '', true, 'None', 'YERKO FABIAN', 'CHAMORRO SIGDMAN');
INSERT INTO candidato VALUES (10964480, 'A', 55, 2576, 999, 99, 'JOEL ANDRES GONZALEZ VEGA', 'JOEL ANDRES GONZALEZ VEGA', '', true, 'None', 'JOEL ANDRES', 'GONZALEZ VEGA');
INSERT INTO candidato VALUES (9452455, 'A', 50, 2577, 401, 99, 'WILLIAM ROBERTO RODRIGUEZ GUZMAN', 'WILLIAM ROBERTO RODRIGUEZ GUZMAN', '', false, 'None', 'WILLIAM ROBERTO', 'RODRIGUEZ GUZMAN');
INSERT INTO candidato VALUES (5579513, 'A', 51, 2577, 439, 150, 'VICENTE CASELLI RAMOS', 'VICENTE CASELLI RAMOS', '', false, 'None', 'VICENTE', 'CASELLI RAMOS');
INSERT INTO candidato VALUES (13190752, 'A', 52, 2577, 999, 99, 'JORGE ELIAS JIL HERRERA', 'JORGE ELIAS JIL HERRERA', '', true, 'None', 'JORGE ELIAS', 'JIL HERRERA');
INSERT INTO candidato VALUES (16812249, 'A', 53, 2577, 999, 99, 'CRISTIAN YAÑEZ VERGARA', 'CRISTIAN YAÑEZ VERGARA', '', true, 'None', 'CRISTIAN', 'YAÑEZ VERGARA');
INSERT INTO candidato VALUES (11311172, 'A', 54, 2577, 999, 99, 'NOEMI SUSANA CACERES ROJAS', 'NOEMI SUSANA CACERES ROJAS', '', true, 'None', 'NOEMI SUSANA', 'CACERES ROJAS');
INSERT INTO candidato VALUES (11601193, 'A', 50, 2578, 399, 99, 'MARLENE LAURA GONZALEZ AHUMADA', 'MARLENE LAURA GONZALEZ AHUMADA', '', false, 'None', 'MARLENE LAURA', 'GONZALEZ AHUMADA');
INSERT INTO candidato VALUES (12848438, 'A', 51, 2578, 401, 6, 'EDITH MARJORIE ALVEAR GUERRA', 'EDITH MARJORIE ALVEAR GUERRA', '', false, 'None', 'EDITH MARJORIE', 'ALVEAR GUERRA');
INSERT INTO candidato VALUES (9048246, 'A', 52, 2578, 400, 99, 'NELSON ESTAY MOLINA', 'NELSON ESTAY MOLINA', '', false, 'None', 'NELSON', 'ESTAY MOLINA');
INSERT INTO candidato VALUES (17274259, 'A', 53, 2578, 999, 99, 'JAVIERA ITALIA TOLEDO MUÑOZ', 'JAVIERA ITALIA TOLEDO MUÑOZ', '', true, 'None', 'JAVIERA ITALIA', 'TOLEDO MUÑOZ');
INSERT INTO candidato VALUES (13345657, 'A', 50, 2579, 399, 99, 'MARIA ALEJANDRA YAÑEZ MUÑOZ', 'MARIA ALEJANDRA YAÑEZ MUÑOZ', '', false, 'None', 'MARIA ALEJANDRA', 'YAÑEZ MUÑOZ');
INSERT INTO candidato VALUES (20210855, 'A', 51, 2579, 401, 99, 'VALENTINA BELEN CACERES MONSALVEZ', 'VALENTINA BELEN CACERES MONSALVEZ', '', false, 'None', 'VALENTINA BELEN', 'CACERES MONSALVEZ');
INSERT INTO candidato VALUES (11275479, 'A', 52, 2579, 426, 99, 'RAFAEL CORNEJO RIQUELME', 'RAFAEL CORNEJO RIQUELME', '', false, 'None', 'RAFAEL', 'CORNEJO RIQUELME');
INSERT INTO candidato VALUES (15363033, 'A', 53, 2579, 400, 99, 'RAIMUNDO AGLIATI MARCHANT', 'RAIMUNDO AGLIATI MARCHANT', '', false, 'None', 'RAIMUNDO', 'AGLIATI MARCHANT');
INSERT INTO candidato VALUES (16884025, 'A', 54, 2579, 999, 99, 'NICOLAS SALGADO AHUMADA', 'NICOLAS SALGADO AHUMADA', '', true, 'None', 'NICOLAS', 'SALGADO AHUMADA');
INSERT INTO candidato VALUES (11397682, 'A', 50, 2580, 401, 99, 'JUAN CARRASCO RODRIGUEZ', 'JUAN CARRASCO RODRIGUEZ', '', false, 'None', 'JUAN', 'CARRASCO RODRIGUEZ');
INSERT INTO candidato VALUES (9948032, 'A', 51, 2580, 444, 198, 'ANA MARIA SILVA GUTIERREZ', 'ANA MARIA SILVA GUTIERREZ', '', false, 'None', 'ANA MARIA', 'SILVA GUTIERREZ');
INSERT INTO candidato VALUES (7846792, 'A', 52, 2580, 426, 99, 'PATRICIO ADAN CASTRO CARRILLO', 'PATRICIO ADAN CASTRO CARRILLO', '', false, 'None', 'PATRICIO ADAN', 'CASTRO CARRILLO');
INSERT INTO candidato VALUES (13342769, 'A', 53, 2580, 999, 99, 'JOSE FLORES OSORIO', 'JOSE FLORES OSORIO', '', true, 'None', 'JOSE', 'FLORES OSORIO');
INSERT INTO candidato VALUES (16491095, 'A', 54, 2580, 999, 99, 'SEBASTIAN PADILLA ORTEGA', 'SEBASTIAN PADILLA ORTEGA', '', true, 'None', 'SEBASTIAN', 'PADILLA ORTEGA');
INSERT INTO candidato VALUES (10423154, 'A', 50, 2581, 401, 99, 'ANGEL RODRIGO GONZALEZ CARRASCO', 'ANGEL RODRIGO GONZALEZ CARRASCO', '', false, 'None', 'ANGEL RODRIGO', 'GONZALEZ CARRASCO');
INSERT INTO candidato VALUES (17133714, 'A', 51, 2581, 400, 37, 'CARLOS MUÑOZ RIVERA', 'CARLOS MUÑOZ RIVERA', '', false, 'None', 'CARLOS', 'MUÑOZ RIVERA');
INSERT INTO candidato VALUES (9740854, 'A', 52, 2581, 999, 99, 'JUAN ABARCA PADILLA', 'JUAN ABARCA PADILLA', '', true, 'None', 'JUAN', 'ABARCA PADILLA');
INSERT INTO candidato VALUES (7822781, 'A', 50, 2582, 401, 99, 'RUBEN ENRIQUE JORQUERA VIDAL', 'RUBEN ENRIQUE JORQUERA VIDAL', '', false, 'None', 'RUBEN ENRIQUE', 'JORQUERA VIDAL');
INSERT INTO candidato VALUES (15123947, 'A', 51, 2582, 400, 1, 'FELIX SANCHEZ VERGARA', 'FELIX SANCHEZ VERGARA', '', false, 'None', 'FELIX', 'SANCHEZ VERGARA');
INSERT INTO candidato VALUES (10504017, 'A', 52, 2582, 999, 99, 'MARCIAL ABARCA ORELLANA', 'MARCIAL ABARCA ORELLANA', '', true, 'None', 'MARCIAL', 'ABARCA ORELLANA');
INSERT INTO candidato VALUES (15108248, 'A', 50, 2583, 401, 99, 'PATRICIO ANDRES LABRA QUIROZ', 'PATRICIO ANDRES LABRA QUIROZ', '', false, 'None', 'PATRICIO ANDRES', 'LABRA QUIROZ');
INSERT INTO candidato VALUES (13569202, 'A', 51, 2583, 444, 99, 'MACARENA EVELYN FIERRO CONTRERAS', 'MACARENA EVELYN FIERRO CONTRERAS', '', false, 'None', 'MACARENA EVELYN', 'FIERRO CONTRERAS');
INSERT INTO candidato VALUES (12911876, 'A', 52, 2583, 426, 200, 'RODRIGO SOTO CESPEDES', 'RODRIGO SOTO CESPEDES', '', false, 'None', 'RODRIGO', 'SOTO CESPEDES');
INSERT INTO candidato VALUES (12265925, 'A', 53, 2583, 999, 99, 'ENA MARIA CATHERINE OLIVARES BONATICI', 'ENA MARIA CATHERINE OLIVARES BONATICI', '', true, 'None', 'ENA MARIA CATHERINE', 'OLIVARES BONATICI');
INSERT INTO candidato VALUES (10140619, 'A', 54, 2583, 999, 99, 'JOSE LUIS FERNANDEZ HENRIQUEZ', 'JOSE LUIS FERNANDEZ HENRIQUEZ', '', true, 'None', 'JOSE LUIS', 'FERNANDEZ HENRIQUEZ');
INSERT INTO candidato VALUES (11758276, 'A', 55, 2583, 999, 99, 'PABLA PONCE VALLE', 'PABLA PONCE VALLE', '', true, 'None', 'PABLA', 'PONCE VALLE');
INSERT INTO candidato VALUES (9222803, 'A', 56, 2583, 999, 99, 'BORIS ACUÑA GONZALEZ', 'BORIS ACUÑA GONZALEZ', '', true, 'None', 'BORIS', 'ACUÑA GONZALEZ');
INSERT INTO candidato VALUES (14019615, 'A', 50, 2584, 401, 99, 'JORGE MARTINEZ OYARCE', 'JORGE MARTINEZ OYARCE', '', false, 'None', 'JORGE', 'MARTINEZ OYARCE');
INSERT INTO candidato VALUES (5369317, 'A', 51, 2584, 400, 99, 'IÑAKI BUSTO BERASALUCE', 'IÑAKI BUSTO BERASALUCE', '', false, 'None', 'IÑAKI', 'BUSTO BERASALUCE');
INSERT INTO candidato VALUES (6936119, 'A', 52, 2584, 999, 99, 'CLAUDIO ARELLANO CORTES', 'CLAUDIO ARELLANO CORTES', '', true, 'None', 'CLAUDIO', 'ARELLANO CORTES');
INSERT INTO candidato VALUES (15246229, 'A', 53, 2584, 999, 99, 'MARCELO MIÑAÑIR MATUS', 'MARCELO MIÑAÑIR MATUS', '', true, 'None', 'MARCELO', 'MIÑAÑIR MATUS');
INSERT INTO candidato VALUES (15525597, 'A', 54, 2584, 999, 99, 'GONZALO SANDOVAL ALISTE', 'GONZALO SANDOVAL ALISTE', '', true, 'None', 'GONZALO', 'SANDOVAL ALISTE');
INSERT INTO candidato VALUES (15523880, 'A', 55, 2584, 999, 99, 'FERNANDO ANDRES PUENTES ARANEDA', 'FERNANDO ANDRES PUENTES ARANEDA', '', true, 'None', 'FERNANDO ANDRES', 'PUENTES ARANEDA');
INSERT INTO candidato VALUES (14328984, 'A', 50, 2585, 399, 99, 'GUIDO PEREZ MALDONADO', 'GUIDO PEREZ MALDONADO', '', false, 'None', 'GUIDO', 'PEREZ MALDONADO');
INSERT INTO candidato VALUES (13346075, 'A', 51, 2585, 401, 5, 'JUAN PABLO FLORES ASTORGA', 'JUAN PABLO FLORES ASTORGA', '', false, 'None', 'JUAN PABLO', 'FLORES ASTORGA');
INSERT INTO candidato VALUES (11171767, 'A', 52, 2585, 400, 3, 'CARLOS ROMERO MARTINEZ', 'CARLOS ROMERO MARTINEZ', '', false, 'None', 'CARLOS', 'ROMERO MARTINEZ');
INSERT INTO candidato VALUES (9496143, 'A', 53, 2585, 999, 99, 'RIGOBERTO LEIVA PARRA', 'RIGOBERTO LEIVA PARRA', '', true, 'None', 'RIGOBERTO', 'LEIVA PARRA');
INSERT INTO candidato VALUES (15227292, 'A', 54, 2585, 999, 99, 'ALEJANDRA BAEZA PEREIRA', 'ALEJANDRA BAEZA PEREIRA', '', true, 'None', 'ALEJANDRA', 'BAEZA PEREIRA');
INSERT INTO candidato VALUES (14473936, 'A', 55, 2585, 999, 99, 'GONZALO RUBIO FUENZALIDA', 'GONZALO RUBIO FUENZALIDA', '', true, 'None', 'GONZALO', 'RUBIO FUENZALIDA');
INSERT INTO candidato VALUES (10218790, 'A', 56, 2585, 999, 99, 'JAIME FABIA REYES', 'JAIME FABIA REYES', '', true, 'None', 'JAIME', 'FABIA REYES');
INSERT INTO candidato VALUES (8238451, 'A', 50, 2586, 400, 99, 'JOSE MIGUEL URRUTIA CELIS', 'JOSE MIGUEL URRUTIA CELIS', '', false, 'None', 'JOSE MIGUEL', 'URRUTIA CELIS');
INSERT INTO candidato VALUES (15126001, 'A', 51, 2586, 999, 99, 'JUAN CARLOS ABUD PARRA', 'JUAN CARLOS ABUD PARRA', '', true, 'None', 'JUAN CARLOS', 'ABUD PARRA');
INSERT INTO candidato VALUES (7956842, 'A', 50, 2587, 401, 99, 'LUIS MANUEL BARRA VILLANUEVA', 'LUIS MANUEL BARRA VILLANUEVA', '', false, 'None', 'LUIS MANUEL', 'BARRA VILLANUEVA');
INSERT INTO candidato VALUES (11527210, 'A', 51, 2587, 400, 99, 'JUAN MANUEL MAGAÑA RUBIO', 'JUAN MANUEL MAGAÑA RUBIO', '', false, 'None', 'JUAN MANUEL', 'MAGAÑA RUBIO');
INSERT INTO candidato VALUES (14241821, 'A', 52, 2587, 999, 99, 'RICARDO GONZALEZ TORRES', 'RICARDO GONZALEZ TORRES', '', true, 'None', 'RICARDO', 'GONZALEZ TORRES');
INSERT INTO candidato VALUES (6966766, 'A', 50, 2588, 401, 99, 'SANTIAGO AQUILES GARATE ESPINOZA', 'SANTIAGO AQUILES GARATE ESPINOZA', '', false, 'None', 'SANTIAGO AQUILES', 'GARATE ESPINOZA');
INSERT INTO candidato VALUES (17886860, 'A', 51, 2588, 426, 99, 'LAURA CORREA FUENTES', 'LAURA CORREA FUENTES', '', false, 'None', 'LAURA', 'CORREA FUENTES');
INSERT INTO candidato VALUES (9665032, 'A', 52, 2588, 400, 3, 'SERGIO MEDEL ACOSTA', 'SERGIO MEDEL ACOSTA', '', false, 'None', 'SERGIO', 'MEDEL ACOSTA');
INSERT INTO candidato VALUES (16207167, 'A', 53, 2588, 999, 99, 'VERONICA ARROYO ARANCIBIA', 'VERONICA ARROYO ARANCIBIA', '', true, 'None', 'VERONICA', 'ARROYO ARANCIBIA');
INSERT INTO candidato VALUES (16881194, 'A', 50, 2589, 401, 99, 'CARLA PAZ GUAJARDO POZO', 'CARLA PAZ GUAJARDO POZO', '', false, 'None', 'CARLA PAZ', 'GUAJARDO POZO');
INSERT INTO candidato VALUES (5658548, 'A', 51, 2589, 400, 99, 'MARIA ESTRELLA MONTERO CARRASCO', 'MARIA ESTRELLA MONTERO CARRASCO', '', false, 'None', 'MARIA ESTRELLA', 'MONTERO CARRASCO');
INSERT INTO candidato VALUES (11671985, 'A', 52, 2589, 999, 99, 'SERGIO ALEJANDRO ARAVENA FLORES', 'SERGIO ALEJANDRO ARAVENA FLORES', '', true, 'None', 'SERGIO ALEJANDRO', 'ARAVENA FLORES');
INSERT INTO candidato VALUES (10238592, 'A', 50, 2590, 401, 99, 'FERMIN ALEJANDRO CARREÑO CARREÑO', 'FERMIN ALEJANDRO CARREÑO CARREÑO', '', false, 'None', 'FERMIN ALEJANDRO', 'CARREÑO CARREÑO');
INSERT INTO candidato VALUES (16867640, 'A', 51, 2590, 999, 99, 'CARLOS ARIEL ALIAGA DONOSO', 'CARLOS ARIEL ALIAGA DONOSO', '', true, 'None', 'CARLOS ARIEL', 'ALIAGA DONOSO');
INSERT INTO candidato VALUES (10479566, 'A', 50, 2591, 401, 2, 'MARCOS FUENTES ULLOA', 'MARCOS FUENTES ULLOA', '', false, 'None', 'MARCOS', 'FUENTES ULLOA');
INSERT INTO candidato VALUES (10085334, 'A', 51, 2591, 444, 99, 'MARCELO ALBERTO ESPINOZA OVALLE', 'MARCELO ALBERTO ESPINOZA OVALLE', '', false, 'None', 'MARCELO ALBERTO', 'ESPINOZA OVALLE');
INSERT INTO candidato VALUES (8837598, 'A', 52, 2591, 999, 99, 'PEDRO PABLO SOLIS URRUTIA', 'PEDRO PABLO SOLIS URRUTIA', '', true, 'None', 'PEDRO PABLO', 'SOLIS URRUTIA');
INSERT INTO candidato VALUES (8927689, 'A', 53, 2591, 999, 99, 'ADOLFO CERON GONZALEZ', 'ADOLFO CERON GONZALEZ', '', true, 'None', 'ADOLFO', 'CERON GONZALEZ');
INSERT INTO candidato VALUES (17138941, 'A', 54, 2591, 999, 99, 'ALEXIS SANCHEZ CONTRERAS', 'ALEXIS SANCHEZ CONTRERAS', '', true, 'None', 'ALEXIS', 'SANCHEZ CONTRERAS');
INSERT INTO candidato VALUES (9776203, 'A', 50, 2592, 401, 99, 'NELSON PATRICIO BARRIOS OROSTEGUI', 'NELSON PATRICIO BARRIOS OROSTEGUI', '', false, 'None', 'NELSON PATRICIO', 'BARRIOS OROSTEGUI');
INSERT INTO candidato VALUES (8939951, 'A', 51, 2592, 426, 99, 'LUIS ENRIQUE JIMENEZ PIZARRO', 'LUIS ENRIQUE JIMENEZ PIZARRO', '', false, 'None', 'LUIS ENRIQUE', 'JIMENEZ PIZARRO');
INSERT INTO candidato VALUES (16223314, 'A', 52, 2592, 400, 99, 'SEBASTIAN RODRIGUEZ FUENZALIDA', 'SEBASTIAN RODRIGUEZ FUENZALIDA', '', false, 'None', 'SEBASTIAN', 'RODRIGUEZ FUENZALIDA');
INSERT INTO candidato VALUES (8491133, 'A', 53, 2592, 999, 99, 'ARTURO GERARDO URIBE AGUILERA', 'ARTURO GERARDO URIBE AGUILERA', '', true, 'None', 'ARTURO GERARDO', 'URIBE AGUILERA');
INSERT INTO candidato VALUES (11742995, 'A', 54, 2592, 999, 99, 'LUIS GALVEZ CASTILLO', 'LUIS GALVEZ CASTILLO', '', true, 'None', 'LUIS', 'GALVEZ CASTILLO');
INSERT INTO candidato VALUES (7877402, 'A', 55, 2592, 999, 99, 'MONICA MATUS RIVAS', 'MONICA MATUS RIVAS', '', true, 'None', 'MONICA', 'MATUS RIVAS');
INSERT INTO candidato VALUES (15113314, 'A', 50, 2593, 401, 99, 'KAREN LORCA SAAVEDRA', 'KAREN LORCA SAAVEDRA', '', false, 'None', 'KAREN', 'LORCA SAAVEDRA');
INSERT INTO candidato VALUES (15113241, 'A', 51, 2593, 439, 150, 'DENISSE TAMARA LEON ROJAS', 'DENISSE TAMARA LEON ROJAS', '', false, 'None', 'DENISSE TAMARA', 'LEON ROJAS');
INSERT INTO candidato VALUES (16645089, 'A', 52, 2593, 400, 99, 'ENRIQUE DEL BARRIO HERNANDEZ', 'ENRIQUE DEL BARRIO HERNANDEZ', '', false, 'None', 'ENRIQUE', 'DEL BARRIO HERNANDEZ');
INSERT INTO candidato VALUES (17327224, 'A', 53, 2593, 999, 99, 'SAMANTA JORQUERA JORQUERA', 'SAMANTA JORQUERA JORQUERA', '', true, 'None', 'SAMANTA', 'JORQUERA JORQUERA');
INSERT INTO candidato VALUES (8800710, 'A', 54, 2593, 999, 99, 'FRANCISCO GONZALEZ ALEGRIA', 'FRANCISCO GONZALEZ ALEGRIA', '', true, 'None', 'FRANCISCO', 'GONZALEZ ALEGRIA');
INSERT INTO candidato VALUES (16884826, 'A', 55, 2593, 999, 99, 'ALVARO VALENTIN LIZANA FUENTES', 'ALVARO VALENTIN LIZANA FUENTES', '', true, 'None', 'ALVARO VALENTIN', 'LIZANA FUENTES');
INSERT INTO candidato VALUES (8278834, 'A', 50, 2594, 401, 99, 'WALDO ANTONIO VALDIVIA MONTECINOS', 'WALDO ANTONIO VALDIVIA MONTECINOS', '', false, 'None', 'WALDO ANTONIO', 'VALDIVIA MONTECINOS');
INSERT INTO candidato VALUES (16817484, 'A', 51, 2594, 400, 3, 'ANTONIO HECHEM PEREZ', 'ANTONIO HECHEM PEREZ', '', false, 'None', 'ANTONIO', 'HECHEM PEREZ');
INSERT INTO candidato VALUES (8684243, 'A', 52, 2594, 999, 99, 'LUIS ANTONIO SILVA VARGAS', 'LUIS ANTONIO SILVA VARGAS', '', true, 'None', 'LUIS ANTONIO', 'SILVA VARGAS');
INSERT INTO candidato VALUES (10556606, 'A', 53, 2594, 999, 99, 'LEONARDO PEÑALOZA MEDINA', 'LEONARDO PEÑALOZA MEDINA', '', true, 'None', 'LEONARDO', 'PEÑALOZA MEDINA');
INSERT INTO candidato VALUES (16180020, 'A', 50, 2595, 401, 232, 'JORGE LUIS PAVEZ ROZAS', 'JORGE LUIS PAVEZ ROZAS', '', false, 'None', 'JORGE LUIS', 'PAVEZ ROZAS');
INSERT INTO candidato VALUES (4102661, 'A', 51, 2595, 439, 150, 'JOSE PABLO DONOSO URZUA', 'JOSE PABLO DONOSO URZUA', '', false, 'None', 'JOSE PABLO', 'DONOSO URZUA');
INSERT INTO candidato VALUES (16522749, 'A', 52, 2595, 400, 3, 'GUIDO CARREÑO REYES', 'GUIDO CARREÑO REYES', '', false, 'None', 'GUIDO', 'CARREÑO REYES');
INSERT INTO candidato VALUES (11454520, 'A', 53, 2595, 999, 99, 'EDINSON RAFAEL TORO ROJAS', 'EDINSON RAFAEL TORO ROJAS', '', true, 'None', 'EDINSON RAFAEL', 'TORO ROJAS');
INSERT INTO candidato VALUES (6383579, 'A', 54, 2595, 999, 99, 'VIRGINIA TRONCOSO HELLMAN', 'VIRGINIA TRONCOSO HELLMAN', '', true, 'None', 'VIRGINIA', 'TRONCOSO HELLMAN');
INSERT INTO candidato VALUES (7341292, 'A', 55, 2595, 999, 99, 'FRANCISCO CANALES CERON', 'FRANCISCO CANALES CERON', '', true, 'None', 'FRANCISCO', 'CANALES CERON');
INSERT INTO candidato VALUES (12884194, 'A', 56, 2595, 999, 99, 'GABRIELA SOTO CISTERNAS', 'GABRIELA SOTO CISTERNAS', '', true, 'None', 'GABRIELA', 'SOTO CISTERNAS');
INSERT INTO candidato VALUES (12801516, 'A', 50, 2596, 401, 5, 'CRISTIAN ANDRES POZO PARRAGUEZ', 'CRISTIAN ANDRES POZO PARRAGUEZ', '', false, 'None', 'CRISTIAN ANDRES', 'POZO PARRAGUEZ');
INSERT INTO candidato VALUES (17405205, 'A', 51, 2596, 400, 99, 'TOBIAS ACUÑA CSILLAG', 'TOBIAS ACUÑA CSILLAG', '', false, 'None', 'TOBIAS', 'ACUÑA CSILLAG');
INSERT INTO candidato VALUES (10102660, 'A', 52, 2596, 999, 99, 'ROBERTO CORDOVA CARREÑO', 'ROBERTO CORDOVA CARREÑO', '', true, 'None', 'ROBERTO', 'CORDOVA CARREÑO');
INSERT INTO candidato VALUES (13209722, 'A', 53, 2596, 999, 99, 'JORGE LUIS URZUA GARCIA', 'JORGE LUIS URZUA GARCIA', '', true, 'None', 'JORGE LUIS', 'URZUA GARCIA');
INSERT INTO candidato VALUES (10217844, 'A', 50, 2597, 401, 99, 'VALENTIN GERONIMO VIDAL RUBIO', 'VALENTIN GERONIMO VIDAL RUBIO', '', false, 'None', 'VALENTIN GERONIMO', 'VIDAL RUBIO');
INSERT INTO candidato VALUES (11995053, 'A', 51, 2597, 400, 99, 'CECILIA ACUÑA CACERES', 'CECILIA ACUÑA CACERES', '', false, 'None', 'CECILIA', 'ACUÑA CACERES');
INSERT INTO candidato VALUES (5949179, 'A', 52, 2597, 999, 99, 'GASTON FERNANDEZ MORI', 'GASTON FERNANDEZ MORI', '', true, 'None', 'GASTON', 'FERNANDEZ MORI');
INSERT INTO candidato VALUES (12687592, 'A', 50, 2598, 399, 99, 'ARACELLI FIGUEROA NAHUELCURA', 'ARACELLI FIGUEROA NAHUELCURA', '', false, 'None', 'ARACELLI', 'FIGUEROA NAHUELCURA');
INSERT INTO candidato VALUES (11275752, 'A', 51, 2598, 401, 99, 'BERNARDO CORNEJO CERON', 'BERNARDO CORNEJO CERON', '', false, 'None', 'BERNARDO', 'CORNEJO CERON');
INSERT INTO candidato VALUES (13344134, 'A', 52, 2598, 400, 99, 'RODRIGO PALOMINOS VIDAL', 'RODRIGO PALOMINOS VIDAL', '', false, 'None', 'RODRIGO', 'PALOMINOS VIDAL');
INSERT INTO candidato VALUES (14338206, 'A', 53, 2598, 999, 99, 'WILLIAMS FERNANDO DONOSO LISBOA', 'WILLIAMS FERNANDO DONOSO LISBOA', '', true, 'None', 'WILLIAMS FERNANDO', 'DONOSO LISBOA');
INSERT INTO candidato VALUES (9385039, 'A', 54, 2598, 999, 99, 'PATRICIO GERARDO FERNANDEZ TAPIA', 'PATRICIO GERARDO FERNANDEZ TAPIA', '', true, 'None', 'PATRICIO GERARDO', 'FERNANDEZ TAPIA');
INSERT INTO candidato VALUES (15497676, 'A', 50, 2599, 401, 99, 'CRISTIAN SALINAS HERRERA', 'CRISTIAN SALINAS HERRERA', '', false, 'None', 'CRISTIAN', 'SALINAS HERRERA');
INSERT INTO candidato VALUES (18445497, 'A', 51, 2599, 400, 99, 'SEBASTIAN FLORES LABARCA', 'SEBASTIAN FLORES LABARCA', '', false, 'None', 'SEBASTIAN', 'FLORES LABARCA');
INSERT INTO candidato VALUES (14013611, 'A', 52, 2599, 999, 99, 'CARLOS CERON MORENO', 'CARLOS CERON MORENO', '', true, 'None', 'CARLOS', 'CERON MORENO');
INSERT INTO candidato VALUES (17080535, 'A', 50, 2600, 401, 99, 'YANKO BLUMEN ANTIVILO', 'YANKO BLUMEN ANTIVILO', '', false, 'None', 'YANKO', 'BLUMEN ANTIVILO');
INSERT INTO candidato VALUES (6863349, 'A', 51, 2600, 400, 99, 'LAUTARO FARIAS ORTEGA', 'LAUTARO FARIAS ORTEGA', '', false, 'None', 'LAUTARO', 'FARIAS ORTEGA');
INSERT INTO candidato VALUES (16256359, 'A', 52, 2600, 999, 99, 'PRISSILA NATALY FARIAS MORALES', 'PRISSILA NATALY FARIAS MORALES', '', true, 'None', 'PRISSILA NATALY', 'FARIAS MORALES');
INSERT INTO candidato VALUES (14011956, 'A', 53, 2600, 999, 99, 'JUAN ESTEBAN GONZALEZ ROMAN', 'JUAN ESTEBAN GONZALEZ ROMAN', '', true, 'None', 'JUAN ESTEBAN', 'GONZALEZ ROMAN');
INSERT INTO candidato VALUES (15337249, 'A', 54, 2600, 999, 99, 'PAMELA MORALES ROLDAN', 'PAMELA MORALES ROLDAN', '', true, 'None', 'PAMELA', 'MORALES ROLDAN');
INSERT INTO candidato VALUES (9464401, 'A', 50, 2601, 399, 99, 'MARGARITA CATALAN PARADA', 'MARGARITA CATALAN PARADA', '', false, 'None', 'MARGARITA', 'CATALAN PARADA');
INSERT INTO candidato VALUES (12368603, 'A', 51, 2601, 401, 99, 'GABRIELA LEIVA LOPEZ', 'GABRIELA LEIVA LOPEZ', '', false, 'None', 'GABRIELA', 'LEIVA LOPEZ');
INSERT INTO candidato VALUES (8106760, 'A', 52, 2601, 400, 1, 'MOISES CARVACHO VARGAS', 'MOISES CARVACHO VARGAS', '', false, 'None', 'MOISES', 'CARVACHO VARGAS');
INSERT INTO candidato VALUES (10297402, 'A', 53, 2601, 999, 99, 'EMILIANO GUERRERO TORRES', 'EMILIANO GUERRERO TORRES', '', true, 'None', 'EMILIANO', 'GUERRERO TORRES');
INSERT INTO candidato VALUES (15520703, 'A', 54, 2601, 999, 99, 'HERNALDO ANDRES AHUMADA CHAVEZ', 'HERNALDO ANDRES AHUMADA CHAVEZ', '', true, 'None', 'HERNALDO ANDRES', 'AHUMADA CHAVEZ');
INSERT INTO candidato VALUES (12368543, 'A', 55, 2601, 999, 99, 'JOHNY CORNEJO ORDENES', 'JOHNY CORNEJO ORDENES', '', true, 'None', 'JOHNY', 'CORNEJO ORDENES');
INSERT INTO candidato VALUES (17595730, 'A', 56, 2601, 999, 99, 'ARIEL HERNAN VALENZUELA FUENZALIDA', 'ARIEL HERNAN VALENZUELA FUENZALIDA', '', true, 'None', 'ARIEL HERNAN', 'VALENZUELA FUENZALIDA');
INSERT INTO candidato VALUES (15915997, 'A', 50, 2602, 401, 4, 'MARIA JOSE DIAZ BECERRA', 'MARIA JOSE DIAZ BECERRA', '', false, 'None', 'MARIA JOSE', 'DIAZ BECERRA');
INSERT INTO candidato VALUES (16015711, 'A', 51, 2602, 444, 191, 'JUAN CARLOS MELENDEZ SANTELICES', 'JUAN CARLOS MELENDEZ SANTELICES', '', false, 'None', 'JUAN CARLOS', 'MELENDEZ SANTELICES');
INSERT INTO candidato VALUES (7659153, 'A', 52, 2602, 400, 99, 'PABLO SILVA PEREZ', 'PABLO SILVA PEREZ', '', false, 'None', 'PABLO', 'SILVA PEREZ');
INSERT INTO candidato VALUES (13201052, 'A', 53, 2602, 999, 99, 'ANDRES JORQUERA CIFUENTES', 'ANDRES JORQUERA CIFUENTES', '', true, 'None', 'ANDRES', 'JORQUERA CIFUENTES');
INSERT INTO candidato VALUES (15698459, 'A', 54, 2602, 999, 99, 'CRISTIAN DIAZ CORREA', 'CRISTIAN DIAZ CORREA', '', true, 'None', 'CRISTIAN', 'DIAZ CORREA');
INSERT INTO candidato VALUES (8978139, 'A', 55, 2602, 999, 99, 'XIMENA FLORES PEÑALOZA', 'XIMENA FLORES PEÑALOZA', '', true, 'None', 'XIMENA', 'FLORES PEÑALOZA');
INSERT INTO candidato VALUES (9337229, 'A', 56, 2602, 999, 99, 'JULIO PERALTA ESPINDOLA', 'JULIO PERALTA ESPINDOLA', '', true, 'None', 'JULIO', 'PERALTA ESPINDOLA');
INSERT INTO candidato VALUES (12414713, 'A', 50, 2603, 401, 5, 'FABIAN SOTO GONZALEZ', 'FABIAN SOTO GONZALEZ', '', false, 'None', 'FABIAN', 'SOTO GONZALEZ');
INSERT INTO candidato VALUES (16261840, 'A', 51, 2603, 418, 157, 'MAX CANALES CASTRO', 'MAX CANALES CASTRO', '', false, 'None', 'MAX', 'CANALES CASTRO');
INSERT INTO candidato VALUES (11556157, 'A', 52, 2603, 400, 99, 'IVAN VALENZUELA PALACIOS', 'IVAN VALENZUELA PALACIOS', '', false, 'None', 'IVAN', 'VALENZUELA PALACIOS');
INSERT INTO candidato VALUES (15527892, 'A', 50, 2604, 401, 99, 'DORIS EDITH RODRIGUEZ ZAVALLA', 'DORIS EDITH RODRIGUEZ ZAVALLA', '', false, 'None', 'DORIS EDITH', 'RODRIGUEZ ZAVALLA');
INSERT INTO candidato VALUES (14261851, 'A', 51, 2604, 400, 99, 'MARCO ANTONIO CONTRERAS JORQUERA', 'MARCO ANTONIO CONTRERAS JORQUERA', '', false, 'None', 'MARCO ANTONIO', 'CONTRERAS JORQUERA');
INSERT INTO candidato VALUES (7912712, 'A', 52, 2604, 999, 99, 'CARLOS GERMAN REYES FECCI', 'CARLOS GERMAN REYES FECCI', '', true, 'None', 'CARLOS GERMAN', 'REYES FECCI');
INSERT INTO candidato VALUES (15497453, 'A', 50, 2605, 400, 1, 'TITO CORREA VERDUGO', 'TITO CORREA VERDUGO', '', false, 'None', 'TITO', 'CORREA VERDUGO');
INSERT INTO candidato VALUES (13571088, 'A', 51, 2605, 999, 99, 'JOSE ROMAN CHAVEZ', 'JOSE ROMAN CHAVEZ', '', true, 'None', 'JOSE', 'ROMAN CHAVEZ');
INSERT INTO candidato VALUES (11348780, 'A', 52, 2605, 999, 99, 'CORINA DIAZ ARANCIBIA', 'CORINA DIAZ ARANCIBIA', '', true, 'None', 'CORINA', 'DIAZ ARANCIBIA');
INSERT INTO candidato VALUES (7831337, 'A', 50, 2606, 401, 5, 'LUIS EDUARDO ESCANILLA GAETE', 'LUIS EDUARDO ESCANILLA GAETE', '', false, 'None', 'LUIS EDUARDO', 'ESCANILLA GAETE');
INSERT INTO candidato VALUES (10865867, 'A', 51, 2606, 400, 99, 'RODRIGO SEPULVEDA TAGLE', 'RODRIGO SEPULVEDA TAGLE', '', false, 'None', 'RODRIGO', 'SEPULVEDA TAGLE');
INSERT INTO candidato VALUES (12368443, 'A', 52, 2606, 999, 99, 'MARINA RENCORET FUENZALIDA', 'MARINA RENCORET FUENZALIDA', '', true, 'None', 'MARINA', 'RENCORET FUENZALIDA');
INSERT INTO candidato VALUES (7126545, 'A', 53, 2606, 999, 99, 'ANIBAL VALENZUELA CARIZ', 'ANIBAL VALENZUELA CARIZ', '', true, 'None', 'ANIBAL', 'VALENZUELA CARIZ');
INSERT INTO candidato VALUES (9538176, 'A', 54, 2606, 999, 99, 'MARIO BUSTAMANTE SALINAS', 'MARIO BUSTAMANTE SALINAS', '', true, 'None', 'MARIO', 'BUSTAMANTE SALINAS');
INSERT INTO candidato VALUES (10504767, 'A', 55, 2606, 999, 99, 'MARCELO HORTA HORTA', 'MARCELO HORTA HORTA', '', true, 'None', 'MARCELO', 'HORTA HORTA');
INSERT INTO candidato VALUES (8479928, 'A', 56, 2606, 999, 99, 'FERNANDO GUERRERO SALINAS', 'FERNANDO GUERRERO SALINAS', '', true, 'None', 'FERNANDO', 'GUERRERO SALINAS');
INSERT INTO candidato VALUES (11399026, 'A', 50, 2607, 401, 2, 'HUGO VARGAS CORDOVA', 'HUGO VARGAS CORDOVA', '', false, 'None', 'HUGO', 'VARGAS CORDOVA');
INSERT INTO candidato VALUES (15497830, 'A', 51, 2607, 444, 99, 'MARIA ISABEL MORAGA CORDOVA', 'MARIA ISABEL MORAGA CORDOVA', '', false, 'None', 'MARIA ISABEL', 'MORAGA CORDOVA');
INSERT INTO candidato VALUES (13571632, 'A', 52, 2607, 999, 99, 'CARLOS CARRERO PEREZ', 'CARLOS CARRERO PEREZ', '', true, 'None', 'CARLOS', 'CARRERO PEREZ');
INSERT INTO candidato VALUES (10661315, 'A', 50, 2608, 401, 5, 'CLAUDIO ABRAHAM CUMSILLE CHOMALI', 'CLAUDIO ABRAHAM CUMSILLE CHOMALI', '', false, 'None', 'CLAUDIO ABRAHAM', 'CUMSILLE CHOMALI');
INSERT INTO candidato VALUES (9436752, 'A', 51, 2608, 444, 99, 'GERARDO JOSE CARLOS CORNEJO PEREZ', 'GERARDO JOSE CARLOS CORNEJO PEREZ', '', false, 'None', 'GERARDO JOSE CARLOS', 'CORNEJO PEREZ');
INSERT INTO candidato VALUES (9590393, 'A', 52, 2608, 400, 3, 'JOSE RIVERA SALDAÑA', 'JOSE RIVERA SALDAÑA', '', false, 'None', 'JOSE', 'RIVERA SALDAÑA');
INSERT INTO candidato VALUES (9104047, 'A', 53, 2608, 999, 99, 'FABIAN GUAJARDO LEON', 'FABIAN GUAJARDO LEON', '', true, 'None', 'FABIAN', 'GUAJARDO LEON');
INSERT INTO candidato VALUES (5727674, 'A', 54, 2608, 999, 99, 'ROBERTO MICHELINI PANDOLFI', 'ROBERTO MICHELINI PANDOLFI', '', true, 'None', 'ROBERTO', 'MICHELINI PANDOLFI');
INSERT INTO candidato VALUES (10579748, 'A', 50, 2609, 399, 99, 'ROSA TORRES ESCOBEDO', 'ROSA TORRES ESCOBEDO', '', false, 'None', 'ROSA', 'TORRES ESCOBEDO');
INSERT INTO candidato VALUES (16861037, 'A', 51, 2609, 401, 2, 'MARCELO GONZALEZ FARIAS', 'MARCELO GONZALEZ FARIAS', '', false, 'None', 'MARCELO', 'GONZALEZ FARIAS');
INSERT INTO candidato VALUES (11744268, 'A', 52, 2609, 400, 99, 'CAROLA GONZALEZ INOSTROZA', 'CAROLA GONZALEZ INOSTROZA', '', false, 'None', 'CAROLA', 'GONZALEZ INOSTROZA');
INSERT INTO candidato VALUES (11743388, 'A', 53, 2609, 999, 99, 'CHRISTIAN JOSE CONTRERAS ORELLANA', 'CHRISTIAN JOSE CONTRERAS ORELLANA', '', true, 'None', 'CHRISTIAN JOSE', 'CONTRERAS ORELLANA');
INSERT INTO candidato VALUES (17716029, 'A', 54, 2609, 999, 99, 'NICOLE ALEJANDRA GALAZ CABELLO', 'NICOLE ALEJANDRA GALAZ CABELLO', '', true, 'None', 'NICOLE ALEJANDRA', 'GALAZ CABELLO');
INSERT INTO candidato VALUES (11951701, 'A', 55, 2609, 999, 99, 'PAULA SILVA SANTIBAÑEZ', 'PAULA SILVA SANTIBAÑEZ', '', true, 'None', 'PAULA', 'SILVA SANTIBAÑEZ');
INSERT INTO candidato VALUES (12179957, 'A', 56, 2609, 999, 99, 'ARMANDO REBOLLEDO BECERRA', 'ARMANDO REBOLLEDO BECERRA', '', true, 'None', 'ARMANDO', 'REBOLLEDO BECERRA');
INSERT INTO candidato VALUES (12254990, 'A', 50, 2610, 401, 99, 'MARINA EUGENIA GUZMAN ARANEDA', 'MARINA EUGENIA GUZMAN ARANEDA', '', false, 'None', 'MARINA EUGENIA', 'GUZMAN ARANEDA');
INSERT INTO candidato VALUES (7054341, 'A', 51, 2610, 400, 99, 'GONZALO BARAONA BEZANILLA', 'GONZALO BARAONA BEZANILLA', '', false, 'None', 'GONZALO', 'BARAONA BEZANILLA');
INSERT INTO candidato VALUES (17910218, 'A', 52, 2610, 999, 99, 'CHRISTOPHER VIAL MANSILLA', 'CHRISTOPHER VIAL MANSILLA', '', true, 'None', 'CHRISTOPHER', 'VIAL MANSILLA');
INSERT INTO candidato VALUES (16434099, 'A', 50, 2611, 401, 5, 'CARLOS PATRICIO CISTERNA PAVEZ', 'CARLOS PATRICIO CISTERNA PAVEZ', '', false, 'None', 'CARLOS PATRICIO', 'CISTERNA PAVEZ');
INSERT INTO candidato VALUES (14050235, 'A', 51, 2611, 400, 99, 'YAMIL ETHIT ROMERO', 'YAMIL ETHIT ROMERO', '', false, 'None', 'YAMIL', 'ETHIT ROMERO');
INSERT INTO candidato VALUES (20392625, 'A', 52, 2611, 999, 99, 'BRYAN NICOLAS MORENO SILVA', 'BRYAN NICOLAS MORENO SILVA', '', true, 'None', 'BRYAN NICOLAS', 'MORENO SILVA');
INSERT INTO candidato VALUES (18464777, 'A', 53, 2611, 999, 99, 'DIEGO RAMIREZ DONOSO', 'DIEGO RAMIREZ DONOSO', '', true, 'None', 'DIEGO', 'RAMIREZ DONOSO');
INSERT INTO candidato VALUES (9531725, 'A', 50, 2612, 401, 6, 'SIXTO GONZALEZ SOTO', 'SIXTO GONZALEZ SOTO', '', false, 'None', 'SIXTO', 'GONZALEZ SOTO');
INSERT INTO candidato VALUES (12621188, 'A', 51, 2612, 426, 200, 'PATRICIA CAROLINA HIDALGO JELDES', 'PATRICIA CAROLINA HIDALGO JELDES', '', false, 'None', 'PATRICIA CAROLINA', 'HIDALGO JELDES');
INSERT INTO candidato VALUES (11675668, 'A', 52, 2612, 400, 1, 'JUAN CARLOS DIAZ AVENDAÑO', 'JUAN CARLOS DIAZ AVENDAÑO', '', false, 'None', 'JUAN CARLOS', 'DIAZ AVENDAÑO');
INSERT INTO candidato VALUES (11767662, 'A', 50, 2613, 401, 7, 'FABIAN PEREZ HERRERA', 'FABIAN PEREZ HERRERA', '', false, 'None', 'FABIAN', 'PEREZ HERRERA');
INSERT INTO candidato VALUES (10787004, 'A', 51, 2613, 400, 99, 'CARLOS VALENZUELA GAJARDO', 'CARLOS VALENZUELA GAJARDO', '', false, 'None', 'CARLOS', 'VALENZUELA GAJARDO');
INSERT INTO candidato VALUES (5322213, 'A', 52, 2613, 999, 99, 'CARLOS BENJAMIN SANTA MARIA SANTA MARIA', 'CARLOS BENJAMIN SANTA MARIA SANTA MARIA', '', true, 'None', 'CARLOS BENJAMIN', 'SANTA MARIA SANTA MARIA');
INSERT INTO candidato VALUES (12318180, 'A', 53, 2613, 999, 99, 'RODRIGO ALEXIS VELOSO URRUTIA', 'RODRIGO ALEXIS VELOSO URRUTIA', '', true, 'None', 'RODRIGO ALEXIS', 'VELOSO URRUTIA');
INSERT INTO candidato VALUES (5260090, 'A', 54, 2613, 999, 99, 'MARINA GUADALUPE MUÑOZ RIQUELME', 'MARINA GUADALUPE MUÑOZ RIQUELME', '', true, 'None', 'MARINA GUADALUPE', 'MUÑOZ RIQUELME');
INSERT INTO candidato VALUES (15144782, 'A', 55, 2613, 999, 99, 'CAROLINA MANRIQUEZ CACERES', 'CAROLINA MANRIQUEZ CACERES', '', true, 'None', 'CAROLINA', 'MANRIQUEZ CACERES');
INSERT INTO candidato VALUES (5156598, 'A', 50, 2614, 401, 99, 'OSVALDO ALFONSO BARRIOS CASTILLO', 'OSVALDO ALFONSO BARRIOS CASTILLO', '', false, 'None', 'OSVALDO ALFONSO', 'BARRIOS CASTILLO');
INSERT INTO candidato VALUES (12418674, 'A', 51, 2614, 444, 99, 'JOSE MANUEL VALENZUELA GAJARDO', 'JOSE MANUEL VALENZUELA GAJARDO', '', false, 'None', 'JOSE MANUEL', 'VALENZUELA GAJARDO');
INSERT INTO candidato VALUES (14516828, 'A', 52, 2614, 400, 99, 'FERNANDO ALCANTARA BARRIOS', 'FERNANDO ALCANTARA BARRIOS', '', false, 'None', 'FERNANDO', 'ALCANTARA BARRIOS');
INSERT INTO candidato VALUES (10944338, 'A', 53, 2614, 999, 99, 'EDWIN RENE ARANCIBIA ROJAS', 'EDWIN RENE ARANCIBIA ROJAS', '', true, 'None', 'EDWIN RENE', 'ARANCIBIA ROJAS');
INSERT INTO candidato VALUES (7923304, 'A', 50, 2615, 999, 99, 'GONZALO ANTONIO TEJOS PEREZ', 'GONZALO ANTONIO TEJOS PEREZ', '', true, 'None', 'GONZALO ANTONIO', 'TEJOS PEREZ');
INSERT INTO candidato VALUES (12052724, 'A', 51, 2615, 999, 99, 'FRANCO SCAPPATICCIO BORDON', 'FRANCO SCAPPATICCIO BORDON', '', true, 'None', 'FRANCO', 'SCAPPATICCIO BORDON');
INSERT INTO candidato VALUES (16196996, 'A', 52, 2615, 999, 99, 'CARLOS ALBERTO CORREA MIÑOS', 'CARLOS ALBERTO CORREA MIÑOS', '', true, 'None', 'CARLOS ALBERTO', 'CORREA MIÑOS');
INSERT INTO candidato VALUES (12325251, 'A', 50, 2616, 399, 197, 'SCARLETT CARRASCO QUIROZ', 'SCARLETT CARRASCO QUIROZ', '', false, 'None', 'SCARLETT', 'CARRASCO QUIROZ');
INSERT INTO candidato VALUES (13786757, 'A', 51, 2616, 401, 2, 'PABLO LUNA AMIGO', 'PABLO LUNA AMIGO', '', false, 'None', 'PABLO', 'LUNA AMIGO');
INSERT INTO candidato VALUES (16998951, 'A', 52, 2616, 439, 99, 'JUAN EDUARDO GUZMAN RAMIREZ', 'JUAN EDUARDO GUZMAN RAMIREZ', '', false, 'None', 'JUAN EDUARDO', 'GUZMAN RAMIREZ');
INSERT INTO candidato VALUES (11566519, 'A', 53, 2616, 400, 99, 'HERNANDO DURAN PALMA', 'HERNANDO DURAN PALMA', '', false, 'None', 'HERNANDO', 'DURAN PALMA');
INSERT INTO candidato VALUES (9178201, 'A', 54, 2616, 999, 99, 'JUAN JESUS HERRERA FUENTES', 'JUAN JESUS HERRERA FUENTES', '', true, 'None', 'JUAN JESUS', 'HERRERA FUENTES');
INSERT INTO candidato VALUES (13830284, 'A', 50, 2617, 401, 4, 'ROBERTO GERMAN SILVA ADI', 'ROBERTO GERMAN SILVA ADI', '', false, 'None', 'ROBERTO GERMAN', 'SILVA ADI');
INSERT INTO candidato VALUES (13097487, 'A', 51, 2617, 400, 99, 'JOHAN GUERRA AGUERO', 'JOHAN GUERRA AGUERO', '', false, 'None', 'JOHAN', 'GUERRA AGUERO');
INSERT INTO candidato VALUES (6539770, 'A', 52, 2617, 999, 99, 'ALFREDO DE JESUS PEREZ LEIVA', 'ALFREDO DE JESUS PEREZ LEIVA', '', true, 'None', 'ALFREDO DE JESUS', 'PEREZ LEIVA');
INSERT INTO candidato VALUES (11984166, 'A', 53, 2617, 999, 99, 'BORIS CABRERA LAZO', 'BORIS CABRERA LAZO', '', true, 'None', 'BORIS', 'CABRERA LAZO');
INSERT INTO candidato VALUES (14485345, 'A', 54, 2617, 999, 99, 'SHIRLEY PAOLA VASCONCELLOS POBLETE', 'SHIRLEY PAOLA VASCONCELLOS POBLETE', '', true, 'None', 'SHIRLEY PAOLA', 'VASCONCELLOS POBLETE');
INSERT INTO candidato VALUES (9070607, 'A', 50, 2618, 401, 99, 'JOSE MIGUEL TOBAR ARAVENA', 'JOSE MIGUEL TOBAR ARAVENA', '', false, 'None', 'JOSE MIGUEL', 'TOBAR ARAVENA');
INSERT INTO candidato VALUES (11456763, 'A', 51, 2618, 400, 99, 'OSVALDO HERRERA VALDES', 'OSVALDO HERRERA VALDES', '', false, 'None', 'OSVALDO', 'HERRERA VALDES');
INSERT INTO candidato VALUES (11983923, 'A', 52, 2618, 999, 99, 'RUBEN OSVALDO FAUNDEZ GOMEZ', 'RUBEN OSVALDO FAUNDEZ GOMEZ', '', true, 'None', 'RUBEN OSVALDO', 'FAUNDEZ GOMEZ');
INSERT INTO candidato VALUES (11698369, 'A', 53, 2618, 999, 99, 'MARCELO ALEJANDRO VIEDMA VILLAMAN', 'MARCELO ALEJANDRO VIEDMA VILLAMAN', '', true, 'None', 'MARCELO ALEJANDRO', 'VIEDMA VILLAMAN');
INSERT INTO candidato VALUES (15586980, 'A', 50, 2619, 401, 5, 'CAROLINA ANDREA TAPIA MONTALVAN', 'CAROLINA ANDREA TAPIA MONTALVAN', '', false, 'None', 'CAROLINA ANDREA', 'TAPIA MONTALVAN');
INSERT INTO candidato VALUES (15143251, 'A', 51, 2619, 400, 1, 'AMERICO GUAJARDO OYARCE', 'AMERICO GUAJARDO OYARCE', '', false, 'None', 'AMERICO', 'GUAJARDO OYARCE');
INSERT INTO candidato VALUES (11372190, 'A', 52, 2619, 999, 99, 'ROSA MARIA NAVARRO AMIGO', 'ROSA MARIA NAVARRO AMIGO', '', true, 'None', 'ROSA MARIA', 'NAVARRO AMIGO');
INSERT INTO candidato VALUES (12042668, 'A', 50, 2620, 399, 197, 'OCTAVIO LORENZO GUAJARDO VASQUEZ', 'OCTAVIO LORENZO GUAJARDO VASQUEZ', '', false, 'None', 'OCTAVIO LORENZO', 'GUAJARDO VASQUEZ');
INSERT INTO candidato VALUES (11457487, 'A', 51, 2620, 401, 99, 'MARIA INES SEPULVEDA FUENTES', 'MARIA INES SEPULVEDA FUENTES', '', false, 'None', 'MARIA INES', 'SEPULVEDA FUENTES');
INSERT INTO candidato VALUES (15907273, 'A', 52, 2620, 400, 99, 'PABLO AMARO VALENZUELA', 'PABLO AMARO VALENZUELA', '', false, 'None', 'PABLO', 'AMARO VALENZUELA');
INSERT INTO candidato VALUES (8392609, 'A', 53, 2620, 999, 99, 'JUAN RAUL ROJAS VERGARA', 'JUAN RAUL ROJAS VERGARA', '', true, 'None', 'JUAN RAUL', 'ROJAS VERGARA');
INSERT INTO candidato VALUES (17684520, 'A', 50, 2621, 401, 2, 'LUIS MORAGA DURAN', 'LUIS MORAGA DURAN', '', false, 'None', 'LUIS', 'MORAGA DURAN');
INSERT INTO candidato VALUES (17039395, 'A', 51, 2621, 418, 99, 'EMILIO JOSE YAÑEZ MORAGA', 'EMILIO JOSE YAÑEZ MORAGA', '', false, 'None', 'EMILIO JOSE', 'YAÑEZ MORAGA');
INSERT INTO candidato VALUES (16726745, 'A', 52, 2621, 444, 99, 'FRANCO ENRIQUE GARRIDO RAMIREZ', 'FRANCO ENRIQUE GARRIDO RAMIREZ', '', false, 'None', 'FRANCO ENRIQUE', 'GARRIDO RAMIREZ');
INSERT INTO candidato VALUES (15577427, 'A', 53, 2621, 999, 99, 'BASILIO OCTAVIO PEREZ DIAZ', 'BASILIO OCTAVIO PEREZ DIAZ', '', true, 'None', 'BASILIO OCTAVIO', 'PEREZ DIAZ');
INSERT INTO candidato VALUES (7158871, 'A', 54, 2621, 999, 99, 'CESAR GABRIEL CANTUARIAS CHAZARRO', 'CESAR GABRIEL CANTUARIAS CHAZARRO', '', true, 'None', 'CESAR GABRIEL', 'CANTUARIAS CHAZARRO');
INSERT INTO candidato VALUES (13206915, 'A', 50, 2622, 444, 198, 'ALEJANDRA CONCHA URRUTIA', 'ALEJANDRA CONCHA URRUTIA', '', false, 'None', 'ALEJANDRA', 'CONCHA URRUTIA');
INSERT INTO candidato VALUES (15148457, 'A', 51, 2622, 400, 99, 'JORGE MUÑOZ SAAVEDRA', 'JORGE MUÑOZ SAAVEDRA', '', false, 'None', 'JORGE', 'MUÑOZ SAAVEDRA');
INSERT INTO candidato VALUES (13206853, 'A', 52, 2622, 999, 99, 'NERY CRISTINA RODRIGUEZ DOMINGUEZ', 'NERY CRISTINA RODRIGUEZ DOMINGUEZ', '', true, 'None', 'NERY CRISTINA', 'RODRIGUEZ DOMINGUEZ');
INSERT INTO candidato VALUES (13373611, 'A', 53, 2622, 999, 99, 'RICARDO ANDRES VERDUGO SEPULVEDA', 'RICARDO ANDRES VERDUGO SEPULVEDA', '', true, 'None', 'RICARDO ANDRES', 'VERDUGO SEPULVEDA');
INSERT INTO candidato VALUES (10501726, 'A', 50, 2623, 401, 7, 'MARCELO OSVALDO WADDINGTON GUAJARDO', 'MARCELO OSVALDO WADDINGTON GUAJARDO', '', false, 'None', 'MARCELO OSVALDO', 'WADDINGTON GUAJARDO');
INSERT INTO candidato VALUES (11442914, 'A', 51, 2623, 400, 1, 'VIVIANA DIAZ MEZA', 'VIVIANA DIAZ MEZA', '', false, 'None', 'VIVIANA', 'DIAZ MEZA');
INSERT INTO candidato VALUES (13788672, 'A', 52, 2623, 999, 99, 'EUDALDO HERNAN GONZALEZ MANRIQUEZ', 'EUDALDO HERNAN GONZALEZ MANRIQUEZ', '', true, 'None', 'EUDALDO HERNAN', 'GONZALEZ MANRIQUEZ');
INSERT INTO candidato VALUES (9053724, 'A', 53, 2623, 999, 99, 'SERGIO OCTAVIO LARRAIN MUÑOZ', 'SERGIO OCTAVIO LARRAIN MUÑOZ', '', true, 'None', 'SERGIO OCTAVIO', 'LARRAIN MUÑOZ');
INSERT INTO candidato VALUES (7259347, 'A', 50, 2624, 401, 99, 'MARIA LUZ REYES ORELLANA', 'MARIA LUZ REYES ORELLANA', '', false, 'None', 'MARIA LUZ', 'REYES ORELLANA');
INSERT INTO candidato VALUES (17410447, 'A', 51, 2624, 400, 99, 'FABIAN MEZA HERNANDEZ', 'FABIAN MEZA HERNANDEZ', '', false, 'None', 'FABIAN', 'MEZA HERNANDEZ');
INSERT INTO candidato VALUES (14248377, 'A', 50, 2625, 401, 99, 'JAVIER AHUMADA RAMIREZ', 'JAVIER AHUMADA RAMIREZ', '', false, 'None', 'JAVIER', 'AHUMADA RAMIREZ');
INSERT INTO candidato VALUES (7029617, 'A', 51, 2625, 400, 3, 'CELSO MORALES MUÑOZ', 'CELSO MORALES MUÑOZ', '', false, 'None', 'CELSO', 'MORALES MUÑOZ');
INSERT INTO candidato VALUES (8051446, 'A', 52, 2625, 999, 99, 'GEORGE RAPHAEL BORDACHAR SOTOMAYOR', 'GEORGE RAPHAEL BORDACHAR SOTOMAYOR', '', true, 'None', 'GEORGE RAPHAEL', 'BORDACHAR SOTOMAYOR');
INSERT INTO candidato VALUES (12784750, 'A', 53, 2625, 999, 99, 'PAMELA ANDREA HENRIQUEZ ROJAS', 'PAMELA ANDREA HENRIQUEZ ROJAS', '', true, 'None', 'PAMELA ANDREA', 'HENRIQUEZ ROJAS');
INSERT INTO candidato VALUES (5492896, 'A', 54, 2625, 999, 99, 'INES ROSA MERCEDES NUÑEZ MENDEZ', 'INES ROSA MERCEDES NUÑEZ MENDEZ', '', true, 'None', 'INES ROSA MERCEDES', 'NUÑEZ MENDEZ');
INSERT INTO candidato VALUES (17156124, 'A', 55, 2625, 999, 99, 'CARLOS FELIPE DREWS RUBILAR', 'CARLOS FELIPE DREWS RUBILAR', '', true, 'None', 'CARLOS FELIPE', 'DREWS RUBILAR');
INSERT INTO candidato VALUES (13573819, 'A', 50, 2626, 401, 2, 'CAROLINA MUÑOZ NUÑEZ', 'CAROLINA MUÑOZ NUÑEZ', '', false, 'None', 'CAROLINA', 'MUÑOZ NUÑEZ');
INSERT INTO candidato VALUES (15646423, 'A', 51, 2626, 400, 99, 'ARIEL RETAMAL BENAVIDES', 'ARIEL RETAMAL BENAVIDES', '', false, 'None', 'ARIEL', 'RETAMAL BENAVIDES');
INSERT INTO candidato VALUES (13455462, 'A', 52, 2626, 999, 99, 'RAUL ANDRES DONOSO ARCE', 'RAUL ANDRES DONOSO ARCE', '', true, 'None', 'RAUL ANDRES', 'DONOSO ARCE');
INSERT INTO candidato VALUES (13371036, 'A', 50, 2627, 401, 7, 'VALERIE COFFIN FUENZALIDA', 'VALERIE COFFIN FUENZALIDA', '', false, 'None', 'VALERIE', 'COFFIN FUENZALIDA');
INSERT INTO candidato VALUES (16172179, 'A', 51, 2627, 400, 1, 'ARIEL ESPINOZA CERPA', 'ARIEL ESPINOZA CERPA', '', false, 'None', 'ARIEL', 'ESPINOZA CERPA');
INSERT INTO candidato VALUES (13352267, 'A', 52, 2627, 999, 99, 'CLAUDIO ALEJANDRO REYES FUENZALIDA', 'CLAUDIO ALEJANDRO REYES FUENZALIDA', '', true, 'None', 'CLAUDIO ALEJANDRO', 'REYES FUENZALIDA');
INSERT INTO candidato VALUES (8282203, 'A', 53, 2627, 999, 99, 'ALVARO CHRISTIAN DONOSO PAVEZ', 'ALVARO CHRISTIAN DONOSO PAVEZ', '', true, 'None', 'ALVARO CHRISTIAN', 'DONOSO PAVEZ');
INSERT INTO candidato VALUES (17442972, 'A', 50, 2628, 401, 232, 'SEBASTIAN DAVID VERGARA HERNANDEZ', 'SEBASTIAN DAVID VERGARA HERNANDEZ', '', false, 'None', 'SEBASTIAN DAVID', 'VERGARA HERNANDEZ');
INSERT INTO candidato VALUES (13784974, 'A', 51, 2628, 400, 99, 'GIOVANNA PAREDES CASTILLO', 'GIOVANNA PAREDES CASTILLO', '', false, 'None', 'GIOVANNA', 'PAREDES CASTILLO');
INSERT INTO candidato VALUES (12075482, 'A', 52, 2628, 999, 99, 'GABRIEL SILVA GONZALEZ', 'GABRIEL SILVA GONZALEZ', '', true, 'None', 'GABRIEL', 'SILVA GONZALEZ');
INSERT INTO candidato VALUES (15629706, 'A', 53, 2628, 999, 99, 'FELIPE MENDEZ GUZMAN', 'FELIPE MENDEZ GUZMAN', '', true, 'None', 'FELIPE', 'MENDEZ GUZMAN');
INSERT INTO candidato VALUES (10976240, 'A', 54, 2628, 999, 99, 'MARCELO ALEJANDRO LOBOS VERGARA', 'MARCELO ALEJANDRO LOBOS VERGARA', '', true, 'None', 'MARCELO ALEJANDRO', 'LOBOS VERGARA');
INSERT INTO candidato VALUES (15990019, 'A', 55, 2628, 999, 99, 'GONZALO EDUARDO URZUA ARRIAGADA', 'GONZALO EDUARDO URZUA ARRIAGADA', '', true, 'None', 'GONZALO EDUARDO', 'URZUA ARRIAGADA');
INSERT INTO candidato VALUES (12007502, 'A', 50, 2629, 401, 99, 'CLAUDIA MEDINA HERNANDEZ', 'CLAUDIA MEDINA HERNANDEZ', '', false, 'None', 'CLAUDIA', 'MEDINA HERNANDEZ');
INSERT INTO candidato VALUES (12415528, 'A', 51, 2629, 444, 99, 'ELIZABETH PAOLA CANALES IBARRA', 'ELIZABETH PAOLA CANALES IBARRA', '', false, 'None', 'ELIZABETH PAOLA', 'CANALES IBARRA');
INSERT INTO candidato VALUES (12782927, 'A', 52, 2629, 400, 99, 'PABLO ANDRES MUÑOZ MORALES', 'PABLO ANDRES MUÑOZ MORALES', '', false, 'None', 'PABLO ANDRES', 'MUÑOZ MORALES');
INSERT INTO candidato VALUES (12369877, 'A', 53, 2629, 999, 99, 'PABLO CHAVEZ VALDERRAMA', 'PABLO CHAVEZ VALDERRAMA', '', true, 'None', 'PABLO', 'CHAVEZ VALDERRAMA');
INSERT INTO candidato VALUES (7675684, 'A', 54, 2629, 999, 99, 'PATRICIO OSVALDO PONCE ALVAREZ', 'PATRICIO OSVALDO PONCE ALVAREZ', '', true, 'None', 'PATRICIO OSVALDO', 'PONCE ALVAREZ');
INSERT INTO candidato VALUES (12785136, 'A', 55, 2629, 999, 99, 'ANA PAOLA PONCE ROJAS', 'ANA PAOLA PONCE ROJAS', '', true, 'None', 'ANA PAOLA', 'PONCE ROJAS');
INSERT INTO candidato VALUES (12060841, 'A', 56, 2629, 999, 99, 'LUIS GABRIEL QUEZADA HERRERA', 'LUIS GABRIEL QUEZADA HERRERA', '', true, 'None', 'LUIS GABRIEL', 'QUEZADA HERRERA');
INSERT INTO candidato VALUES (14436302, 'A', 57, 2629, 999, 99, 'MANUEL JESUS POBLETE NAVARRO', 'MANUEL JESUS POBLETE NAVARRO', '', true, 'None', 'MANUEL JESUS', 'POBLETE NAVARRO');
INSERT INTO candidato VALUES (16481179, 'A', 58, 2629, 999, 99, 'ISMAEL ENRIQUE SAN MARTIN AGUILERA', 'ISMAEL ENRIQUE SAN MARTIN AGUILERA', '', true, 'None', 'ISMAEL ENRIQUE', 'SAN MARTIN AGUILERA');
INSERT INTO candidato VALUES (9341454, 'A', 59, 2629, 999, 99, 'MAURICIO HERNAN FARIAS MOLINA', 'MAURICIO HERNAN FARIAS MOLINA', '', true, 'None', 'MAURICIO HERNAN', 'FARIAS MOLINA');
INSERT INTO candidato VALUES (17796817, 'A', 50, 2630, 444, 99, 'LUIS MARIN DIAZ', 'LUIS MARIN DIAZ', '', false, 'None', 'LUIS', 'MARIN DIAZ');
INSERT INTO candidato VALUES (10606266, 'A', 51, 2630, 400, 1, 'JOSE ANTONIO ARELLANO LYNCH', 'JOSE ANTONIO ARELLANO LYNCH', '', false, 'None', 'JOSE ANTONIO', 'ARELLANO LYNCH');
INSERT INTO candidato VALUES (16335463, 'A', 52, 2630, 999, 99, 'MARIA JOSE HUERTA VALDERRAMA', 'MARIA JOSE HUERTA VALDERRAMA', '', true, 'None', 'MARIA JOSE', 'HUERTA VALDERRAMA');
INSERT INTO candidato VALUES (14557298, 'A', 53, 2630, 999, 99, 'FRANCISCA MARCELA ORELLANA CALIXTO', 'FRANCISCA MARCELA ORELLANA CALIXTO', '', true, 'None', 'FRANCISCA MARCELA', 'ORELLANA CALIXTO');
INSERT INTO candidato VALUES (5686421, 'A', 50, 2631, 401, 5, 'FRANCISCO JAVIER MELENDEZ ROJAS', 'FRANCISCO JAVIER MELENDEZ ROJAS', '', false, 'None', 'FRANCISCO JAVIER', 'MELENDEZ ROJAS');
INSERT INTO candidato VALUES (15630966, 'A', 51, 2631, 400, 3, 'OSVALDO JORQUERA PADILLA', 'OSVALDO JORQUERA PADILLA', '', false, 'None', 'OSVALDO', 'JORQUERA PADILLA');
INSERT INTO candidato VALUES (9573819, 'A', 52, 2631, 999, 99, 'CRISTIAN MANUEL PALMA HERRERA', 'CRISTIAN MANUEL PALMA HERRERA', '', true, 'None', 'CRISTIAN MANUEL', 'PALMA HERRERA');
INSERT INTO candidato VALUES (14542313, 'A', 53, 2631, 999, 99, 'PATRICIA ANDREA SERRANO VASQUEZ', 'PATRICIA ANDREA SERRANO VASQUEZ', '', true, 'None', 'PATRICIA ANDREA', 'SERRANO VASQUEZ');
INSERT INTO candidato VALUES (17980889, 'A', 54, 2631, 999, 99, 'JOSSELYN ALEJANDRA OYARZUN NARANJO', 'JOSSELYN ALEJANDRA OYARZUN NARANJO', '', true, 'None', 'JOSSELYN ALEJANDRA', 'OYARZUN NARANJO');
INSERT INTO candidato VALUES (13784126, 'A', 55, 2631, 999, 99, 'ROBERTO CARLOS DIAZ ROSALES', 'ROBERTO CARLOS DIAZ ROSALES', '', true, 'None', 'ROBERTO CARLOS', 'DIAZ ROSALES');
INSERT INTO candidato VALUES (12783999, 'A', 56, 2631, 999, 99, 'JULIO ALFREDO MATABENITEZ MUÑOZ', 'JULIO ALFREDO MATABENITEZ MUÑOZ', '', true, 'None', 'JULIO ALFREDO', 'MATABENITEZ MUÑOZ');
INSERT INTO candidato VALUES (8207882, 'A', 50, 2632, 401, 99, 'SANDRA CECILIA AMESTICA GAETE', 'SANDRA CECILIA AMESTICA GAETE', '', false, 'None', 'SANDRA CECILIA', 'AMESTICA GAETE');
INSERT INTO candidato VALUES (10379045, 'A', 51, 2632, 400, 3, 'SANDRA VALENZUELA PEREZ', 'SANDRA VALENZUELA PEREZ', '', false, 'None', 'SANDRA', 'VALENZUELA PEREZ');
INSERT INTO candidato VALUES (11186445, 'A', 52, 2632, 999, 99, 'WILDO RICHARD FARIAS GONZALEZ', 'WILDO RICHARD FARIAS GONZALEZ', '', true, 'None', 'WILDO RICHARD', 'FARIAS GONZALEZ');
INSERT INTO candidato VALUES (18396218, 'A', 53, 2632, 999, 99, 'MATIAS ROJAS MEDINA', 'MATIAS ROJAS MEDINA', '', true, 'None', 'MATIAS', 'ROJAS MEDINA');
INSERT INTO candidato VALUES (14192687, 'A', 54, 2632, 999, 99, 'JOSE LUIS CACERES NICOLAO', 'JOSE LUIS CACERES NICOLAO', '', true, 'None', 'JOSE LUIS', 'CACERES NICOLAO');
INSERT INTO candidato VALUES (16433021, 'A', 50, 2633, 401, 99, 'MATIAS MARCELO FUENZALIDA YAÑEZ', 'MATIAS MARCELO FUENZALIDA YAÑEZ', '', false, 'None', 'MATIAS MARCELO', 'FUENZALIDA YAÑEZ');
INSERT INTO candidato VALUES (17528993, 'A', 51, 2633, 400, 99, 'PATRICIO RIVERA BRAVO', 'PATRICIO RIVERA BRAVO', '', false, 'None', 'PATRICIO', 'RIVERA BRAVO');
INSERT INTO candidato VALUES (17853879, 'A', 52, 2633, 999, 99, 'MARIA TERESA BRAVO MATURANA', 'MARIA TERESA BRAVO MATURANA', '', true, 'None', 'MARIA TERESA', 'BRAVO MATURANA');
INSERT INTO candidato VALUES (12963497, 'A', 50, 2634, 401, 5, 'MICHAEL ERIC CESAR CONCHA SALVO', 'MICHAEL ERIC CESAR CONCHA SALVO', '', false, 'None', 'MICHAEL ERIC CESAR', 'CONCHA SALVO');
INSERT INTO candidato VALUES (14389148, 'A', 51, 2634, 400, 1, 'MARIO MEZA VASQUEZ', 'MARIO MEZA VASQUEZ', '', false, 'None', 'MARIO', 'MEZA VASQUEZ');
INSERT INTO candidato VALUES (6379329, 'A', 52, 2634, 999, 99, 'ROLANDO RENTERIA MOLLER', 'ROLANDO RENTERIA MOLLER', '', true, 'None', 'ROLANDO', 'RENTERIA MOLLER');
INSERT INTO candidato VALUES (15570172, 'A', 53, 2634, 999, 99, 'FELIPE SEGUNDO GONZALEZ LOPEZ', 'FELIPE SEGUNDO GONZALEZ LOPEZ', '', true, 'None', 'FELIPE SEGUNDO', 'GONZALEZ LOPEZ');
INSERT INTO candidato VALUES (10993393, 'A', 54, 2634, 999, 99, 'MYRIAM ALARCON CASTILLO', 'MYRIAM ALARCON CASTILLO', '', true, 'None', 'MYRIAM', 'ALARCON CASTILLO');
INSERT INTO candidato VALUES (16555752, 'A', 50, 2635, 444, 99, 'JUAN PABLO ARAYA VERGARA', 'JUAN PABLO ARAYA VERGARA', '', false, 'None', 'JUAN PABLO', 'ARAYA VERGARA');
INSERT INTO candidato VALUES (20306866, 'A', 51, 2635, 400, 37, 'JOSE HERNAN OLIVARES QUIROZ', 'JOSE HERNAN OLIVARES QUIROZ', '', false, 'None', 'JOSE HERNAN', 'OLIVARES QUIROZ');
INSERT INTO candidato VALUES (11441127, 'A', 52, 2635, 999, 99, 'PEDRO PABLO MUÑOZ OSES', 'PEDRO PABLO MUÑOZ OSES', '', true, 'None', 'PEDRO PABLO', 'MUÑOZ OSES');
INSERT INTO candidato VALUES (11441083, 'A', 53, 2635, 999, 99, 'GUSTAVO ROJAS ARAVENA', 'GUSTAVO ROJAS ARAVENA', '', true, 'None', 'GUSTAVO', 'ROJAS ARAVENA');
INSERT INTO candidato VALUES (9240974, 'A', 54, 2635, 999, 99, 'RENATO HERNANDEZ BRAVO', 'RENATO HERNANDEZ BRAVO', '', true, 'None', 'RENATO', 'HERNANDEZ BRAVO');
INSERT INTO candidato VALUES (15156187, 'A', 50, 2636, 401, 99, 'JAIME ANTONIO BRIONES JORQUERA', 'JAIME ANTONIO BRIONES JORQUERA', '', false, 'None', 'JAIME ANTONIO', 'BRIONES JORQUERA');
INSERT INTO candidato VALUES (9559345, 'A', 51, 2636, 418, 99, 'DANILO DEL CARMEN BARRA MENDEZ', 'DANILO DEL CARMEN BARRA MENDEZ', '', false, 'None', 'DANILO DEL CARMEN', 'BARRA MENDEZ');
INSERT INTO candidato VALUES (7911507, 'A', 52, 2636, 400, 99, 'CRISTIAN MENCHACA PINOCHET', 'CRISTIAN MENCHACA PINOCHET', '', false, 'None', 'CRISTIAN', 'MENCHACA PINOCHET');
INSERT INTO candidato VALUES (12964611, 'A', 53, 2636, 999, 99, 'ESTEBAN MENDEZ GUTIERREZ', 'ESTEBAN MENDEZ GUTIERREZ', '', true, 'None', 'ESTEBAN', 'MENDEZ GUTIERREZ');
INSERT INTO candidato VALUES (12076238, 'A', 54, 2636, 999, 99, 'JACQUELINE ALVAREZ GONZALEZ', 'JACQUELINE ALVAREZ GONZALEZ', '', true, 'None', 'JACQUELINE', 'ALVAREZ GONZALEZ');
INSERT INTO candidato VALUES (12793147, 'A', 50, 2637, 401, 99, 'RODRIGO ESTEBAN CASTRO SEPULVEDA', 'RODRIGO ESTEBAN CASTRO SEPULVEDA', '', false, 'None', 'RODRIGO ESTEBAN', 'CASTRO SEPULVEDA');
INSERT INTO candidato VALUES (15913688, 'A', 51, 2637, 439, 99, 'PATRICIO ALEJANDRO OJEDA ALARCON', 'PATRICIO ALEJANDRO OJEDA ALARCON', '', false, 'None', 'PATRICIO ALEJANDRO', 'OJEDA ALARCON');
INSERT INTO candidato VALUES (12735493, 'A', 52, 2637, 999, 99, 'FABIAN ABASOLO NARVAEZ', 'FABIAN ABASOLO NARVAEZ', '', true, 'None', 'FABIAN', 'ABASOLO NARVAEZ');
INSERT INTO candidato VALUES (13207666, 'A', 50, 2638, 401, 99, 'IGNACIO ARISTIDES LUNA VALLEJOS', 'IGNACIO ARISTIDES LUNA VALLEJOS', '', false, 'None', 'IGNACIO ARISTIDES', 'LUNA VALLEJOS');
INSERT INTO candidato VALUES (11788491, 'A', 51, 2638, 400, 1, 'RAFAEL RAMIREZ PARRA', 'RAFAEL RAMIREZ PARRA', '', false, 'None', 'RAFAEL', 'RAMIREZ PARRA');
INSERT INTO candidato VALUES (15149371, 'A', 50, 2639, 399, 99, 'MIGUEL ANGEL DE JESUS GONZALEZ PARRA', 'MIGUEL ANGEL DE JESUS GONZALEZ PARRA', '', false, 'None', 'MIGUEL ANGEL DE JESUS', 'GONZALEZ PARRA');
INSERT INTO candidato VALUES (7993074, 'A', 51, 2639, 401, 2, 'JORGE SILVA SEPULVEDA', 'JORGE SILVA SEPULVEDA', '', false, 'None', 'JORGE', 'SILVA SEPULVEDA');
INSERT INTO candidato VALUES (16212359, 'A', 52, 2639, 439, 99, 'DANIEL ALEJANDRO SMITH BENAVENTE', 'DANIEL ALEJANDRO SMITH BENAVENTE', '', false, 'None', 'DANIEL ALEJANDRO', 'SMITH BENAVENTE');
INSERT INTO candidato VALUES (14019021, 'A', 53, 2639, 400, 3, 'CRISTOBAL CANCINO ALBORNOZ', 'CRISTOBAL CANCINO ALBORNOZ', '', false, 'None', 'CRISTOBAL', 'CANCINO ALBORNOZ');
INSERT INTO candidato VALUES (13614221, 'A', 54, 2639, 999, 99, 'GERMAN ANDRES HERRERA DINAMARCA', 'GERMAN ANDRES HERRERA DINAMARCA', '', true, 'None', 'GERMAN ANDRES', 'HERRERA DINAMARCA');
INSERT INTO candidato VALUES (11744922, 'A', 55, 2639, 999, 99, 'MARCELO VALENZUELA URBINA', 'MARCELO VALENZUELA URBINA', '', true, 'None', 'MARCELO', 'VALENZUELA URBINA');
INSERT INTO candidato VALUES (9814943, 'A', 56, 2639, 999, 99, 'CARMEN LUZ SOTO CACERES', 'CARMEN LUZ SOTO CACERES', '', true, 'None', 'CARMEN LUZ', 'SOTO CACERES');
INSERT INTO candidato VALUES (11523478, 'A', 50, 2640, 400, 99, 'PABLO BENITO FUENTES VALLEJOS', 'PABLO BENITO FUENTES VALLEJOS', '', false, 'None', 'PABLO BENITO', 'FUENTES VALLEJOS');
INSERT INTO candidato VALUES (8090604, 'A', 51, 2640, 999, 99, 'ARTURO DEL CARMEN PALMA VILCHES', 'ARTURO DEL CARMEN PALMA VILCHES', '', true, 'None', 'ARTURO DEL CARMEN', 'PALMA VILCHES');
INSERT INTO candidato VALUES (17903876, 'A', 52, 2640, 999, 99, 'HORACIO ALEJANDRO LOBOS AZOCAR', 'HORACIO ALEJANDRO LOBOS AZOCAR', '', true, 'None', 'HORACIO ALEJANDRO', 'LOBOS AZOCAR');
INSERT INTO candidato VALUES (11373865, 'A', 50, 2641, 399, 99, 'RODEN FABRICIANO AREVALO PARADA', 'RODEN FABRICIANO AREVALO PARADA', '', false, 'None', 'RODEN FABRICIANO', 'AREVALO PARADA');
INSERT INTO candidato VALUES (12962809, 'A', 51, 2641, 401, 2, 'ALEJANDRA CADEGAN MALDONADO', 'ALEJANDRA CADEGAN MALDONADO', '', false, 'None', 'ALEJANDRA', 'CADEGAN MALDONADO');
INSERT INTO candidato VALUES (15153416, 'A', 52, 2641, 400, 99, 'JONATHAN NORAMBUENA BARROS', 'JONATHAN NORAMBUENA BARROS', '', false, 'None', 'JONATHAN', 'NORAMBUENA BARROS');
INSERT INTO candidato VALUES (11747454, 'A', 53, 2641, 999, 99, 'JOSE MOSQUEIRA MIRANDA', 'JOSE MOSQUEIRA MIRANDA', '', true, 'None', 'JOSE', 'MOSQUEIRA MIRANDA');
INSERT INTO candidato VALUES (7869806, 'A', 54, 2641, 999, 99, 'JAIME CLARET ARIAS', 'JAIME CLARET ARIAS', '', true, 'None', 'JAIME', 'CLARET ARIAS');
INSERT INTO candidato VALUES (13790588, 'A', 55, 2641, 999, 99, 'RAFAEL ENRIQUE VIGUERA GONZALEZ', 'RAFAEL ENRIQUE VIGUERA GONZALEZ', '', true, 'None', 'RAFAEL ENRIQUE', 'VIGUERA GONZALEZ');
INSERT INTO candidato VALUES (13789674, 'A', 56, 2641, 999, 99, 'ADRIAN RODRIGO SEPULVEDA JARA', 'ADRIAN RODRIGO SEPULVEDA JARA', '', true, 'None', 'ADRIAN RODRIGO', 'SEPULVEDA JARA');
INSERT INTO candidato VALUES (11745762, 'A', 57, 2641, 999, 99, 'FERNANDO ARTURO ASTETE MENDIBURO', 'FERNANDO ARTURO ASTETE MENDIBURO', '', true, 'None', 'FERNANDO ARTURO', 'ASTETE MENDIBURO');
INSERT INTO candidato VALUES (13620651, 'A', 50, 2642, 399, 197, 'HECTOR MUÑOZ URIBE', 'HECTOR MUÑOZ URIBE', '', false, 'None', 'HECTOR', 'MUÑOZ URIBE');
INSERT INTO candidato VALUES (13725305, 'A', 51, 2642, 401, 2, 'ALDO MARDONES ALARCON', 'ALDO MARDONES ALARCON', '', false, 'None', 'ALDO', 'MARDONES ALARCON');
INSERT INTO candidato VALUES (15224384, 'A', 52, 2642, 418, 157, 'VICTOR FERNANDO AVILA CAAMAÑO', 'VICTOR FERNANDO AVILA CAAMAÑO', '', false, 'None', 'VICTOR FERNANDO', 'AVILA CAAMAÑO');
INSERT INTO candidato VALUES (13309065, 'A', 53, 2642, 444, 99, 'ANDREA DE LA BARRA MANRIQUEZ', 'ANDREA DE LA BARRA MANRIQUEZ', '', false, 'None', 'ANDREA', 'DE LA BARRA MANRIQUEZ');
INSERT INTO candidato VALUES (16766411, 'A', 54, 2642, 439, 99, 'JAMES DANIEL ARGO CHAVEZ', 'JAMES DANIEL ARGO CHAVEZ', '', false, 'None', 'JAMES DANIEL', 'ARGO CHAVEZ');
INSERT INTO candidato VALUES (19091962, 'A', 55, 2642, 400, 3, 'VALENTINA PAVEZ VAN RYSSELBERGHE', 'VALENTINA PAVEZ VAN RYSSELBERGHE', '', false, 'None', 'VALENTINA', 'PAVEZ VAN RYSSELBERGHE');
INSERT INTO candidato VALUES (8264111, 'A', 56, 2642, 999, 99, 'JAIME MONJES FARIAS', 'JAIME MONJES FARIAS', '', true, 'None', 'JAIME', 'MONJES FARIAS');
INSERT INTO candidato VALUES (16426777, 'A', 57, 2642, 999, 99, 'CAMILO RIFFO QUINTANA', 'CAMILO RIFFO QUINTANA', '', true, 'None', 'CAMILO', 'RIFFO QUINTANA');
INSERT INTO candidato VALUES (9740549, 'A', 50, 2643, 399, 99, 'CARMEN MADINAGOITIA CHAMORRO', 'CARMEN MADINAGOITIA CHAMORRO', '', false, 'None', 'CARMEN', 'MADINAGOITIA CHAMORRO');
INSERT INTO candidato VALUES (15592276, 'A', 51, 2643, 401, 5, 'BORIS CHAMORRO REBOLLEDO', 'BORIS CHAMORRO REBOLLEDO', '', false, 'None', 'BORIS', 'CHAMORRO REBOLLEDO');
INSERT INTO candidato VALUES (16895750, 'A', 52, 2643, 418, 157, 'CRISTIAN ALEJANDRO AVENDAÑO ZARATE', 'CRISTIAN ALEJANDRO AVENDAÑO ZARATE', '', false, 'None', 'CRISTIAN ALEJANDRO', 'AVENDAÑO ZARATE');
INSERT INTO candidato VALUES (9150499, 'A', 53, 2643, 439, 150, 'RENATO HUMBERTO NAVARRO GENTA', 'RENATO HUMBERTO NAVARRO GENTA', '', false, 'None', 'RENATO HUMBERTO', 'NAVARRO GENTA');
INSERT INTO candidato VALUES (7834679, 'A', 54, 2643, 400, 99, 'BERNARDO ULLOA PEREIRA', 'BERNARDO ULLOA PEREIRA', '', false, 'None', 'BERNARDO', 'ULLOA PEREIRA');
INSERT INTO candidato VALUES (9794168, 'A', 50, 2644, 399, 99, 'JESSICA FLORES REYES', 'JESSICA FLORES REYES', '', false, 'None', 'JESSICA', 'FLORES REYES');
INSERT INTO candidato VALUES (11448156, 'A', 51, 2644, 401, 5, 'ANDRES PARRA SANDOVAL', 'ANDRES PARRA SANDOVAL', '', false, 'None', 'ANDRES', 'PARRA SANDOVAL');
INSERT INTO candidato VALUES (13585864, 'A', 52, 2644, 418, 157, 'JUAN FRANCISCO BRUNETH VERA', 'JUAN FRANCISCO BRUNETH VERA', '', false, 'None', 'JUAN FRANCISCO', 'BRUNETH VERA');
INSERT INTO candidato VALUES (8551165, 'A', 53, 2644, 400, 3, 'MARISSA BARRO QUEIROLO', 'MARISSA BARRO QUEIROLO', '', false, 'None', 'MARISSA', 'BARRO QUEIROLO');
INSERT INTO candidato VALUES (12526968, 'A', 54, 2644, 999, 99, 'XIMENA BRAVO URREA', 'XIMENA BRAVO URREA', '', true, 'None', 'XIMENA', 'BRAVO URREA');
INSERT INTO candidato VALUES (10233906, 'A', 55, 2644, 999, 99, 'JORGE LOZANO ZAPATA', 'JORGE LOZANO ZAPATA', '', true, 'None', 'JORGE', 'LOZANO ZAPATA');
INSERT INTO candidato VALUES (15696463, 'A', 50, 2645, 401, 5, 'RODRIGO MONTERO CUEVAS', 'RODRIGO MONTERO CUEVAS', '', false, 'None', 'RODRIGO', 'MONTERO CUEVAS');
INSERT INTO candidato VALUES (12704186, 'A', 51, 2645, 418, 157, 'OSCAR ENRIQUE RIVERA MARIN', 'OSCAR ENRIQUE RIVERA MARIN', '', false, 'None', 'OSCAR ENRIQUE', 'RIVERA MARIN');
INSERT INTO candidato VALUES (10711407, 'A', 52, 2645, 444, 99, 'PATRICIA SALDIAS CARREÑO', 'PATRICIA SALDIAS CARREÑO', '', false, 'None', 'PATRICIA', 'SALDIAS CARREÑO');
INSERT INTO candidato VALUES (10802462, 'A', 53, 2645, 400, 99, 'CLAUDIO PARRA HIDALGO', 'CLAUDIO PARRA HIDALGO', '', false, 'None', 'CLAUDIO', 'PARRA HIDALGO');
INSERT INTO candidato VALUES (9999431, 'A', 54, 2645, 999, 99, 'GEORGINA MARGARITA LAVIN SOTO', 'GEORGINA MARGARITA LAVIN SOTO', '', true, 'None', 'GEORGINA MARGARITA', 'LAVIN SOTO');
INSERT INTO candidato VALUES (10888108, 'A', 55, 2645, 999, 99, 'MAURICIO GALLARDO SANCHEZ', 'MAURICIO GALLARDO SANCHEZ', '', true, 'None', 'MAURICIO', 'GALLARDO SANCHEZ');
INSERT INTO candidato VALUES (14614712, 'A', 56, 2645, 999, 99, 'JORGE IRAAGORRI MORALES', 'JORGE IRAAGORRI MORALES', '', true, 'None', 'JORGE', 'IRAAGORRI MORALES');
INSERT INTO candidato VALUES (16035775, 'A', 57, 2645, 999, 99, 'CRISTIAN PEÑA PASTEN', 'CRISTIAN PEÑA PASTEN', '', true, 'None', 'CRISTIAN', 'PEÑA PASTEN');
INSERT INTO candidato VALUES (10467908, 'A', 58, 2645, 999, 99, 'JOSE MIGUEL PAZOLS MELGAREJO', 'JOSE MIGUEL PAZOLS MELGAREJO', '', true, 'None', 'JOSE MIGUEL', 'PAZOLS MELGAREJO');
INSERT INTO candidato VALUES (8836798, 'A', 50, 2646, 401, 99, 'JORGE CONTANZO BRAVO', 'JORGE CONTANZO BRAVO', '', false, 'None', 'JORGE', 'CONTANZO BRAVO');
INSERT INTO candidato VALUES (17044546, 'A', 51, 2646, 444, 99, 'PABLO FERNANDO MEDINA CABEZAS', 'PABLO FERNANDO MEDINA CABEZAS', '', false, 'None', 'PABLO FERNANDO', 'MEDINA CABEZAS');
INSERT INTO candidato VALUES (13380516, 'A', 52, 2646, 400, 99, 'SIGRID RAMIREZ ARIAS', 'SIGRID RAMIREZ ARIAS', '', false, 'None', 'SIGRID', 'RAMIREZ ARIAS');
INSERT INTO candidato VALUES (18816462, 'A', 53, 2646, 999, 99, 'BASTIAN LEONARDO STUARDO PEÑA', 'BASTIAN LEONARDO STUARDO PEÑA', '', true, 'None', 'BASTIAN LEONARDO', 'STUARDO PEÑA');
INSERT INTO candidato VALUES (8707600, 'A', 54, 2646, 999, 99, 'RICARDO FUENTES PALMA', 'RICARDO FUENTES PALMA', '', true, 'None', 'RICARDO', 'FUENTES PALMA');
INSERT INTO candidato VALUES (6720978, 'A', 55, 2646, 999, 99, 'RIGOBERTO FUENTES SANHUEZA', 'RIGOBERTO FUENTES SANHUEZA', '', true, 'None', 'RIGOBERTO', 'FUENTES SANHUEZA');
INSERT INTO candidato VALUES (11497368, 'A', 56, 2646, 999, 99, 'FABIAN MAQUEIRA SOLAR', 'FABIAN MAQUEIRA SOLAR', '', true, 'None', 'FABIAN', 'MAQUEIRA SOLAR');
INSERT INTO candidato VALUES (15615608, 'A', 57, 2646, 999, 99, 'DAVID FRANCISCO MUÑOZ MORALES', 'DAVID FRANCISCO MUÑOZ MORALES', '', true, 'None', 'DAVID FRANCISCO', 'MUÑOZ MORALES');
INSERT INTO candidato VALUES (11684529, 'A', 50, 2647, 401, 5, 'MAURICIO TORRES FERRADA', 'MAURICIO TORRES FERRADA', '', false, 'None', 'MAURICIO', 'TORRES FERRADA');
INSERT INTO candidato VALUES (8074219, 'A', 51, 2647, 444, 99, 'PATRICIO MARCHANT ULLOA', 'PATRICIO MARCHANT ULLOA', '', false, 'None', 'PATRICIO', 'MARCHANT ULLOA');
INSERT INTO candidato VALUES (14213080, 'A', 52, 2647, 400, 99, 'JAIME VASQUEZ CASTILLO', 'JAIME VASQUEZ CASTILLO', '', false, 'None', 'JAIME', 'VASQUEZ CASTILLO');
INSERT INTO candidato VALUES (8680916, 'A', 53, 2647, 999, 99, 'JUAN INOSTROZA QUIÑONES', 'JUAN INOSTROZA QUIÑONES', '', true, 'None', 'JUAN', 'INOSTROZA QUIÑONES');
INSERT INTO candidato VALUES (12304279, 'A', 54, 2647, 999, 99, 'NESTOR VIGUERAS TOLOZA', 'NESTOR VIGUERAS TOLOZA', '', true, 'None', 'NESTOR', 'VIGUERAS TOLOZA');
INSERT INTO candidato VALUES (16504598, 'A', 55, 2647, 999, 99, 'PAULINA VELOSO MUÑOZ', 'PAULINA VELOSO MUÑOZ', '', true, 'None', 'PAULINA', 'VELOSO MUÑOZ');
INSERT INTO candidato VALUES (13139374, 'A', 50, 2648, 401, 2, 'FREDDY NEIRA PAREDES', 'FREDDY NEIRA PAREDES', '', false, 'None', 'FREDDY', 'NEIRA PAREDES');
INSERT INTO candidato VALUES (13510449, 'A', 51, 2648, 999, 99, 'RODRIGO VERA RIQUELME', 'RODRIGO VERA RIQUELME', '', true, 'None', 'RODRIGO', 'VERA RIQUELME');
INSERT INTO candidato VALUES (15184198, 'A', 52, 2648, 999, 99, 'LUIS GUERRERO SOTO', 'LUIS GUERRERO SOTO', '', true, 'None', 'LUIS', 'GUERRERO SOTO');
INSERT INTO candidato VALUES (13952922, 'A', 50, 2649, 399, 99, 'YAZMIN JARPA MANRIQUEZ', 'YAZMIN JARPA MANRIQUEZ', '', false, 'None', 'YAZMIN', 'JARPA MANRIQUEZ');
INSERT INTO candidato VALUES (5957066, 'A', 51, 2649, 401, 4, 'AUDITO RETAMAL LAZO', 'AUDITO RETAMAL LAZO', '', false, 'None', 'AUDITO', 'RETAMAL LAZO');
INSERT INTO candidato VALUES (13380268, 'A', 52, 2649, 439, 150, 'GISELA PAULINA VERGARA HENRIQUEZ', 'GISELA PAULINA VERGARA HENRIQUEZ', '', false, 'None', 'GISELA PAULINA', 'VERGARA HENRIQUEZ');
INSERT INTO candidato VALUES (15185136, 'A', 53, 2649, 400, 37, 'JUAN PABLO SPOERER BRITO', 'JUAN PABLO SPOERER BRITO', '', false, 'None', 'JUAN PABLO', 'SPOERER BRITO');
INSERT INTO candidato VALUES (16286780, 'A', 54, 2649, 999, 99, 'RENE BETANZO GOMEZ', 'RENE BETANZO GOMEZ', '', true, 'None', 'RENE', 'BETANZO GOMEZ');
INSERT INTO candidato VALUES (10981104, 'A', 55, 2649, 999, 99, 'CRISTINA BURGOS BARRIA', 'CRISTINA BURGOS BARRIA', '', true, 'None', 'CRISTINA', 'BURGOS BARRIA');
INSERT INTO candidato VALUES (16283562, 'A', 56, 2649, 999, 99, 'PAULA OPAZO NOVA', 'PAULA OPAZO NOVA', '', true, 'None', 'PAULA', 'OPAZO NOVA');
INSERT INTO candidato VALUES (7335101, 'A', 57, 2649, 999, 99, 'JAVIER GUIÑEZ CASTRO', 'JAVIER GUIÑEZ CASTRO', '', true, 'None', 'JAVIER', 'GUIÑEZ CASTRO');
INSERT INTO candidato VALUES (14505271, 'A', 58, 2649, 999, 99, 'MARCELO PATRICIO BERSANO REYES', 'MARCELO PATRICIO BERSANO REYES', '', true, 'None', 'MARCELO PATRICIO', 'BERSANO REYES');
INSERT INTO candidato VALUES (8870328, 'A', 50, 2650, 999, 99, 'ANGEL CASTRO MEDINA', 'ANGEL CASTRO MEDINA', '', true, 'None', 'ANGEL', 'CASTRO MEDINA');
INSERT INTO candidato VALUES (15190172, 'A', 51, 2650, 999, 99, 'ANA ALBORNOZ CUEVAS', 'ANA ALBORNOZ CUEVAS', '', true, 'None', 'ANA', 'ALBORNOZ CUEVAS');
INSERT INTO candidato VALUES (10686102, 'A', 50, 2651, 401, 5, 'EDUARDO SAAVEDRA BUSTOS', 'EDUARDO SAAVEDRA BUSTOS', '', false, 'None', 'EDUARDO', 'SAAVEDRA BUSTOS');
INSERT INTO candidato VALUES (15173261, 'A', 51, 2651, 400, 3, 'HENRY CAMPOS COA', 'HENRY CAMPOS COA', '', false, 'None', 'HENRY', 'CAMPOS COA');
INSERT INTO candidato VALUES (10823805, 'A', 52, 2651, 999, 99, 'JOSE ESTEBAN ALARCON VARGAS', 'JOSE ESTEBAN ALARCON VARGAS', '', true, 'None', 'JOSE ESTEBAN', 'ALARCON VARGAS');
INSERT INTO candidato VALUES (10190076, 'A', 50, 2652, 401, 2, 'IVONNE RIVAS ORTIZ', 'IVONNE RIVAS ORTIZ', '', false, 'None', 'IVONNE', 'RIVAS ORTIZ');
INSERT INTO candidato VALUES (8232813, 'A', 51, 2652, 400, 37, 'BORIS CARIKEO AGUILERA', 'BORIS CARIKEO AGUILERA', '', false, 'None', 'BORIS', 'CARIKEO AGUILERA');
INSERT INTO candidato VALUES (11534205, 'A', 52, 2652, 999, 99, 'FERNANDO MUÑOZ CARRASCO', 'FERNANDO MUÑOZ CARRASCO', '', true, 'None', 'FERNANDO', 'MUÑOZ CARRASCO');
INSERT INTO candidato VALUES (10659907, 'A', 53, 2652, 999, 99, 'ITALO CACERES LIZANA', 'ITALO CACERES LIZANA', '', true, 'None', 'ITALO', 'CACERES LIZANA');
INSERT INTO candidato VALUES (16807353, 'A', 54, 2652, 999, 99, 'JONATHAN HIDALGO HIDALGO', 'JONATHAN HIDALGO HIDALGO', '', true, 'None', 'JONATHAN', 'HIDALGO HIDALGO');
INSERT INTO candidato VALUES (15910867, 'A', 55, 2652, 999, 99, 'JUAN MANUEL RIFFO ORTIZ', 'JUAN MANUEL RIFFO ORTIZ', '', true, 'None', 'JUAN MANUEL', 'RIFFO ORTIZ');
INSERT INTO candidato VALUES (16761392, 'A', 50, 2653, 399, 197, 'NINOSKA VILLEGAS LAMAS', 'NINOSKA VILLEGAS LAMAS', '', false, 'None', 'NINOSKA', 'VILLEGAS LAMAS');
INSERT INTO candidato VALUES (14060359, 'A', 51, 2653, 401, 4, 'MIGUEL ANGEL RIVERA MORALES', 'MIGUEL ANGEL RIVERA MORALES', '', false, 'None', 'MIGUEL ANGEL', 'RIVERA MORALES');
INSERT INTO candidato VALUES (18106548, 'A', 52, 2653, 999, 99, 'ISMAEL OLMOS ALARCON', 'ISMAEL OLMOS ALARCON', '', true, 'None', 'ISMAEL', 'OLMOS ALARCON');
INSERT INTO candidato VALUES (7945951, 'A', 50, 2654, 401, 6, 'FRANCISCO JAVIER YEVENES NUÑEZ', 'FRANCISCO JAVIER YEVENES NUÑEZ', '', false, 'None', 'FRANCISCO JAVIER', 'YEVENES NUÑEZ');
INSERT INTO candidato VALUES (14072609, 'A', 51, 2654, 400, 99, 'MARCELA TIZNADO FERNANDEZ', 'MARCELA TIZNADO FERNANDEZ', '', false, 'None', 'MARCELA', 'TIZNADO FERNANDEZ');
INSERT INTO candidato VALUES (9754309, 'A', 52, 2654, 999, 99, 'EDGARDO CERDA MONSALVE', 'EDGARDO CERDA MONSALVE', '', true, 'None', 'EDGARDO', 'CERDA MONSALVE');
INSERT INTO candidato VALUES (13384694, 'A', 50, 2655, 401, 5, 'GONZALO MAURICIO GAYOSO SAEZ', 'GONZALO MAURICIO GAYOSO SAEZ', '', false, 'None', 'GONZALO MAURICIO', 'GAYOSO SAEZ');
INSERT INTO candidato VALUES (10166673, 'A', 51, 2655, 400, 99, 'MAURICIO ALARCON GUZMAN', 'MAURICIO ALARCON GUZMAN', '', false, 'None', 'MAURICIO', 'ALARCON GUZMAN');
INSERT INTO candidato VALUES (16013163, 'A', 52, 2655, 999, 99, 'ELIZABETH MARICAN RIVAS', 'ELIZABETH MARICAN RIVAS', '', true, 'None', 'ELIZABETH', 'MARICAN RIVAS');
INSERT INTO candidato VALUES (13390474, 'A', 53, 2655, 999, 99, 'WALTER RODRIGUEZ LEAL', 'WALTER RODRIGUEZ LEAL', '', true, 'None', 'WALTER', 'RODRIGUEZ LEAL');
INSERT INTO candidato VALUES (14554037, 'A', 50, 2656, 401, 6, 'CARLOS LEONARDO CARVAJAL CASTRO', 'CARLOS LEONARDO CARVAJAL CASTRO', '', false, 'None', 'CARLOS LEONARDO', 'CARVAJAL CASTRO');
INSERT INTO candidato VALUES (5759131, 'A', 51, 2656, 400, 1, 'JORGE RADONICH BARRA', 'JORGE RADONICH BARRA', '', false, 'None', 'JORGE', 'RADONICH BARRA');
INSERT INTO candidato VALUES (10984703, 'A', 52, 2656, 999, 99, 'GUSTAVO JARA BERTIN', 'GUSTAVO JARA BERTIN', '', true, 'None', 'GUSTAVO', 'JARA BERTIN');
INSERT INTO candidato VALUES (13806158, 'A', 53, 2656, 999, 99, 'JUAN CARLOS ANDRADE OPAZO', 'JUAN CARLOS ANDRADE OPAZO', '', true, 'None', 'JUAN CARLOS', 'ANDRADE OPAZO');
INSERT INTO candidato VALUES (13380070, 'A', 50, 2657, 399, 99, 'MARCO ANTONIO MORALES MUÑOZ', 'MARCO ANTONIO MORALES MUÑOZ', '', false, 'None', 'MARCO ANTONIO', 'MORALES MUÑOZ');
INSERT INTO candidato VALUES (16163769, 'A', 51, 2657, 439, 150, 'EDUARDO ANTONIO CARRILLO NEIRA', 'EDUARDO ANTONIO CARRILLO NEIRA', '', false, 'None', 'EDUARDO ANTONIO', 'CARRILLO NEIRA');
INSERT INTO candidato VALUES (10932512, 'A', 52, 2657, 999, 99, 'CARLOS ARTURO LEAL NEIRA', 'CARLOS ARTURO LEAL NEIRA', '', true, 'None', 'CARLOS ARTURO', 'LEAL NEIRA');
INSERT INTO candidato VALUES (13802552, 'A', 50, 2658, 439, 99, 'JOSE ANDRES AGUILERA CRUCES', 'JOSE ANDRES AGUILERA CRUCES', '', false, 'None', 'JOSE ANDRES', 'AGUILERA CRUCES');
INSERT INTO candidato VALUES (6726380, 'A', 51, 2658, 400, 99, 'LUIS GENGNAGEL GUTIERREZ', 'LUIS GENGNAGEL GUTIERREZ', '', false, 'None', 'LUIS', 'GENGNAGEL GUTIERREZ');
INSERT INTO candidato VALUES (16707390, 'A', 52, 2658, 999, 99, 'NELSON EGAÑA OSSES', 'NELSON EGAÑA OSSES', '', true, 'None', 'NELSON', 'EGAÑA OSSES');
INSERT INTO candidato VALUES (18369649, 'A', 53, 2658, 999, 99, 'FELIPE SIERRA ALVARADO', 'FELIPE SIERRA ALVARADO', '', true, 'None', 'FELIPE', 'SIERRA ALVARADO');
INSERT INTO candidato VALUES (11699058, 'A', 54, 2658, 999, 99, 'ALVARO VALENTIN SANCHEZ ROJAS', 'ALVARO VALENTIN SANCHEZ ROJAS', '', true, 'None', 'ALVARO VALENTIN', 'SANCHEZ ROJAS');
INSERT INTO candidato VALUES (13389115, 'A', 55, 2658, 999, 99, 'ALEJANDRA BURGOS BIZAMA', 'ALEJANDRA BURGOS BIZAMA', '', true, 'None', 'ALEJANDRA', 'BURGOS BIZAMA');
INSERT INTO candidato VALUES (11418058, 'A', 50, 2659, 432, 99, 'PEDRO PABLO VALENZUELA CASTRO', 'PEDRO PABLO VALENZUELA CASTRO', '', false, 'None', 'PEDRO PABLO', 'VALENZUELA CASTRO');
INSERT INTO candidato VALUES (7116904, 'A', 51, 2659, 401, 99, 'LAUTARO MELITA VINETT', 'LAUTARO MELITA VINETT', '', false, 'None', 'LAUTARO', 'MELITA VINETT');
INSERT INTO candidato VALUES (13491086, 'A', 52, 2659, 400, 99, 'PABLO VEGAS VERDUGO', 'PABLO VEGAS VERDUGO', '', false, 'None', 'PABLO', 'VEGAS VERDUGO');
INSERT INTO candidato VALUES (15998936, 'A', 53, 2659, 999, 99, 'PABLO CEA AGUILERA', 'PABLO CEA AGUILERA', '', true, 'None', 'PABLO', 'CEA AGUILERA');
INSERT INTO candidato VALUES (13389857, 'A', 54, 2659, 999, 99, 'PABLO PAVEZ ARAVENA', 'PABLO PAVEZ ARAVENA', '', true, 'None', 'PABLO', 'PAVEZ ARAVENA');
INSERT INTO candidato VALUES (12976062, 'A', 50, 2660, 399, 99, 'PEDRO ROBERTO MARILEO LAVIN', 'PEDRO ROBERTO MARILEO LAVIN', '', false, 'None', 'PEDRO ROBERTO', 'MARILEO LAVIN');
INSERT INTO candidato VALUES (11796637, 'A', 51, 2660, 401, 99, 'JOSE LINCO GARRIDO', 'JOSE LINCO GARRIDO', '', false, 'None', 'JOSE', 'LINCO GARRIDO');
INSERT INTO candidato VALUES (16498573, 'A', 52, 2660, 439, 150, 'NEFTALI ALBERTO NAHUELQUEO LLANQUILEO', 'NEFTALI ALBERTO NAHUELQUEO LLANQUILEO', '', false, 'None', 'NEFTALI ALBERTO', 'NAHUELQUEO LLANQUILEO');
INSERT INTO candidato VALUES (8901892, 'A', 50, 2661, 432, 201, 'NIVIA DEL CARMEN RIQUELME GUTIERREZ', 'NIVIA DEL CARMEN RIQUELME GUTIERREZ', '', false, 'None', 'NIVIA DEL CARMEN', 'RIQUELME GUTIERREZ');
INSERT INTO candidato VALUES (10416099, 'A', 51, 2661, 399, 99, 'PATRICIO BADILLA COFRE', 'PATRICIO BADILLA COFRE', '', false, 'None', 'PATRICIO', 'BADILLA COFRE');
INSERT INTO candidato VALUES (4516100, 'A', 52, 2661, 401, 7, 'JOSE PEREZ ARRIAGADA', 'JOSE PEREZ ARRIAGADA', '', false, 'None', 'JOSE', 'PEREZ ARRIAGADA');
INSERT INTO candidato VALUES (10770046, 'A', 53, 2661, 418, 157, 'CARLOS ALBERTO PEÑA OPAZO', 'CARLOS ALBERTO PEÑA OPAZO', '', false, 'None', 'CARLOS ALBERTO', 'PEÑA OPAZO');
INSERT INTO candidato VALUES (7329851, 'A', 54, 2661, 400, 3, 'IVAN NORAMBUENA FARIAS', 'IVAN NORAMBUENA FARIAS', '', false, 'None', 'IVAN', 'NORAMBUENA FARIAS');
INSERT INTO candidato VALUES (7097629, 'A', 55, 2661, 999, 99, 'TERESA DE JESUS STARK ORTEGA', 'TERESA DE JESUS STARK ORTEGA', '', true, 'None', 'TERESA DE JESUS', 'STARK ORTEGA');
INSERT INTO candidato VALUES (12133331, 'A', 50, 2662, 401, 5, 'CARLA CANALES PACHECO', 'CARLA CANALES PACHECO', '', false, 'None', 'CARLA', 'CANALES PACHECO');
INSERT INTO candidato VALUES (6013332, 'A', 51, 2662, 418, 157, 'GABRIEL AQUILES GALLEGOS SEPULVEDA', 'GABRIEL AQUILES GALLEGOS SEPULVEDA', '', false, 'None', 'GABRIEL AQUILES', 'GALLEGOS SEPULVEDA');
INSERT INTO candidato VALUES (11154081, 'A', 52, 2662, 999, 99, 'SANDRA BOBADILLA CISTERNA', 'SANDRA BOBADILLA CISTERNA', '', true, 'None', 'SANDRA', 'BOBADILLA CISTERNA');
INSERT INTO candidato VALUES (8996760, 'A', 53, 2662, 999, 99, 'MIGUEL ABUTER LEON', 'MIGUEL ABUTER LEON', '', true, 'None', 'MIGUEL', 'ABUTER LEON');
INSERT INTO candidato VALUES (8603049, 'A', 54, 2662, 999, 99, 'CRISTHIAN ALEXY GONZALEZ SANDOVAL', 'CRISTHIAN ALEXY GONZALEZ SANDOVAL', '', true, 'None', 'CRISTHIAN ALEXY', 'GONZALEZ SANDOVAL');
INSERT INTO candidato VALUES (17276654, 'A', 50, 2663, 418, 157, 'DANIEL EDUARDO MERINO GAMONAL', 'DANIEL EDUARDO MERINO GAMONAL', '', false, 'None', 'DANIEL EDUARDO', 'MERINO GAMONAL');
INSERT INTO candidato VALUES (12916995, 'A', 51, 2663, 999, 99, 'YUSEF SABAG ARANEDA', 'YUSEF SABAG ARANEDA', '', true, 'None', 'YUSEF', 'SABAG ARANEDA');
INSERT INTO candidato VALUES (13605028, 'A', 52, 2663, 999, 99, 'PABLO ANTONIO GIERKE QUEVEDO', 'PABLO ANTONIO GIERKE QUEVEDO', '', true, 'None', 'PABLO ANTONIO', 'GIERKE QUEVEDO');
INSERT INTO candidato VALUES (5595895, 'A', 50, 2664, 401, 99, 'MARIA ISABEL ARANEDA ABURTO', 'MARIA ISABEL ARANEDA ABURTO', '', false, 'None', 'MARIA ISABEL', 'ARANEDA ABURTO');
INSERT INTO candidato VALUES (12324600, 'A', 51, 2664, 439, 150, 'RENE MIGUEL VIDAL LLANOS', 'RENE MIGUEL VIDAL LLANOS', '', false, 'None', 'RENE MIGUEL', 'VIDAL LLANOS');
INSERT INTO candidato VALUES (8505921, 'A', 52, 2664, 400, 1, 'VLADIMIR FICA TOLEDO', 'VLADIMIR FICA TOLEDO', '', false, 'None', 'VLADIMIR', 'FICA TOLEDO');
INSERT INTO candidato VALUES (9108449, 'A', 53, 2664, 999, 99, 'ISRAEL ARANEDA ARRIAGADA', 'ISRAEL ARANEDA ARRIAGADA', '', true, 'None', 'ISRAEL', 'ARANEDA ARRIAGADA');
INSERT INTO candidato VALUES (15211345, 'A', 54, 2664, 999, 99, 'MAYERLY BELTRAN MONTOYA', 'MAYERLY BELTRAN MONTOYA', '', true, 'None', 'MAYERLY', 'BELTRAN MONTOYA');
INSERT INTO candidato VALUES (8946946, 'A', 55, 2664, 999, 99, 'ROBERTO QUINTANA INOSTROZA', 'ROBERTO QUINTANA INOSTROZA', '', true, 'None', 'ROBERTO', 'QUINTANA INOSTROZA');
INSERT INTO candidato VALUES (17913563, 'A', 50, 2665, 401, 2, 'NATALY NEIRA MONTOYA', 'NATALY NEIRA MONTOYA', '', false, 'None', 'NATALY', 'NEIRA MONTOYA');
INSERT INTO candidato VALUES (10149552, 'A', 51, 2665, 418, 157, 'RODOLFO ALEXI BETANCURT MELO', 'RODOLFO ALEXI BETANCURT MELO', '', false, 'None', 'RODOLFO ALEXI', 'BETANCURT MELO');
INSERT INTO candidato VALUES (10402405, 'A', 52, 2665, 444, 198, 'LUZ GONZALEZ CONTRERAS', 'LUZ GONZALEZ CONTRERAS', '', false, 'None', 'LUZ', 'GONZALEZ CONTRERAS');
INSERT INTO candidato VALUES (8690959, 'A', 53, 2665, 439, 150, 'JOSE MIGUEL MUÑOZ SAEZ', 'JOSE MIGUEL MUÑOZ SAEZ', '', false, 'None', 'JOSE MIGUEL', 'MUÑOZ SAEZ');
INSERT INTO candidato VALUES (16756693, 'A', 54, 2665, 400, 1, 'JUAN FRANCISCO VILCHES RIQUELME', 'JUAN FRANCISCO VILCHES RIQUELME', '', false, 'None', 'JUAN FRANCISCO', 'VILCHES RIQUELME');
INSERT INTO candidato VALUES (12023306, 'A', 55, 2665, 999, 99, 'JUAN EMILIO RIVERA CEA', 'JUAN EMILIO RIVERA CEA', '', true, 'None', 'JUAN EMILIO', 'RIVERA CEA');
INSERT INTO candidato VALUES (13804367, 'A', 56, 2665, 999, 99, 'JAIME RAMIREZ BUSTOS', 'JAIME RAMIREZ BUSTOS', '', true, 'None', 'JAIME', 'RAMIREZ BUSTOS');
INSERT INTO candidato VALUES (9744174, 'A', 50, 2666, 401, 99, 'DAVID HERNAN SALINAS ROCA', 'DAVID HERNAN SALINAS ROCA', '', false, 'None', 'DAVID HERNAN', 'SALINAS ROCA');
INSERT INTO candidato VALUES (12982300, 'A', 51, 2666, 400, 3, 'CARLOS TOLOZA SOTO', 'CARLOS TOLOZA SOTO', '', false, 'None', 'CARLOS', 'TOLOZA SOTO');
INSERT INTO candidato VALUES (16427686, 'A', 50, 2667, 401, 7, 'ALFREDO ALEJANDRO PEÑA PEÑA', 'ALFREDO ALEJANDRO PEÑA PEÑA', '', false, 'None', 'ALFREDO ALEJANDRO', 'PEÑA PEÑA');
INSERT INTO candidato VALUES (9268221, 'A', 51, 2667, 999, 99, 'PLACIDO VIDAL BARNACHEA', 'PLACIDO VIDAL BARNACHEA', '', true, 'None', 'PLACIDO', 'VIDAL BARNACHEA');
INSERT INTO candidato VALUES (12386184, 'A', 50, 2668, 401, 99, 'PABLO URRUTIA MALDONADO', 'PABLO URRUTIA MALDONADO', '', false, 'None', 'PABLO', 'URRUTIA MALDONADO');
INSERT INTO candidato VALUES (9698188, 'A', 51, 2668, 400, 99, 'FREDY BARRUETO VIVEROS', 'FREDY BARRUETO VIVEROS', '', false, 'None', 'FREDY', 'BARRUETO VIVEROS');
INSERT INTO candidato VALUES (11259122, 'A', 50, 2669, 399, 99, 'PATRICIO MUÑOZ POBLETE', 'PATRICIO MUÑOZ POBLETE', '', false, 'None', 'PATRICIO', 'MUÑOZ POBLETE');
INSERT INTO candidato VALUES (7488035, 'A', 51, 2669, 401, 2, 'CLAUDIO SOLAR JARA', 'CLAUDIO SOLAR JARA', '', false, 'None', 'CLAUDIO', 'SOLAR JARA');
INSERT INTO candidato VALUES (14274214, 'A', 52, 2669, 444, 99, 'PAMELA VIAL VEGA', 'PAMELA VIAL VEGA', '', false, 'None', 'PAMELA', 'VIAL VEGA');
INSERT INTO candidato VALUES (11577447, 'A', 53, 2669, 400, 1, 'HECTOR RIVERA ZENTENO', 'HECTOR RIVERA ZENTENO', '', false, 'None', 'HECTOR', 'RIVERA ZENTENO');
INSERT INTO candidato VALUES (10555541, 'A', 54, 2669, 999, 99, 'JAIME QUILODRAN ACUÑA', 'JAIME QUILODRAN ACUÑA', '', true, 'None', 'JAIME', 'QUILODRAN ACUÑA');
INSERT INTO candidato VALUES (18854865, 'A', 50, 2670, 400, 1, 'EFRAIN OPORTO TORRES', 'EFRAIN OPORTO TORRES', '', false, 'None', 'EFRAIN', 'OPORTO TORRES');
INSERT INTO candidato VALUES (11699798, 'A', 51, 2670, 999, 99, 'JOAQUIN SANHUEZA VILLAMAN', 'JOAQUIN SANHUEZA VILLAMAN', '', true, 'None', 'JOAQUIN', 'SANHUEZA VILLAMAN');
INSERT INTO candidato VALUES (14544757, 'A', 52, 2670, 999, 99, 'RABINDRANATH ACUÑA OLATE', 'RABINDRANATH ACUÑA OLATE', '', true, 'None', 'RABINDRANATH', 'ACUÑA OLATE');
INSERT INTO candidato VALUES (14031862, 'A', 50, 2671, 401, 99, 'PABLO SALAZAR LILLO', 'PABLO SALAZAR LILLO', '', false, 'None', 'PABLO', 'SALAZAR LILLO');
INSERT INTO candidato VALUES (7131973, 'A', 51, 2671, 444, 198, 'MAXIMO SALAMANCA BARRA', 'MAXIMO SALAMANCA BARRA', '', false, 'None', 'MAXIMO', 'SALAMANCA BARRA');
INSERT INTO candidato VALUES (13579581, 'A', 52, 2671, 439, 150, 'CLAUDIO ANDRES MELO PEREZ', 'CLAUDIO ANDRES MELO PEREZ', '', false, 'None', 'CLAUDIO ANDRES', 'MELO PEREZ');
INSERT INTO candidato VALUES (12983782, 'A', 53, 2671, 400, 1, 'CRISTIAN OSES ABUTER', 'CRISTIAN OSES ABUTER', '', false, 'None', 'CRISTIAN', 'OSES ABUTER');
INSERT INTO candidato VALUES (19293647, 'A', 54, 2671, 999, 99, 'DARIO SEBASTIAN CHAMORRO CHAMORRO', 'DARIO SEBASTIAN CHAMORRO CHAMORRO', '', true, 'None', 'DARIO SEBASTIAN', 'CHAMORRO CHAMORRO');
INSERT INTO candidato VALUES (10847546, 'A', 55, 2671, 999, 99, 'ERASMO ZAVALA CERDA', 'ERASMO ZAVALA CERDA', '', true, 'None', 'ERASMO', 'ZAVALA CERDA');
INSERT INTO candidato VALUES (10562686, 'A', 56, 2671, 999, 99, 'CLAUDIO ALEJANDRO MUÑOZ SEGUEL', 'CLAUDIO ALEJANDRO MUÑOZ SEGUEL', '', true, 'None', 'CLAUDIO ALEJANDRO', 'MUÑOZ SEGUEL');
INSERT INTO candidato VALUES (12556596, 'A', 50, 2672, 401, 2, 'JAIME HENRIQUEZ VEGA', 'JAIME HENRIQUEZ VEGA', '', false, 'None', 'JAIME', 'HENRIQUEZ VEGA');
INSERT INTO candidato VALUES (9248944, 'A', 51, 2672, 400, 1, 'JAIME VELOSO JARA', 'JAIME VELOSO JARA', '', false, 'None', 'JAIME', 'VELOSO JARA');
INSERT INTO candidato VALUES (12766727, 'A', 50, 2673, 401, 99, 'CRISTIAN KARIN CERRO GARRIDO', 'CRISTIAN KARIN CERRO GARRIDO', '', false, 'None', 'CRISTIAN KARIN', 'CERRO GARRIDO');
INSERT INTO candidato VALUES (10500132, 'A', 51, 2673, 999, 99, 'ALEJANDRO VELASQUEZ MEZA', 'ALEJANDRO VELASQUEZ MEZA', '', true, 'None', 'ALEJANDRO', 'VELASQUEZ MEZA');
INSERT INTO candidato VALUES (15194179, 'A', 52, 2673, 999, 99, 'CRISTIAN ALEJANDRO SOBARZO SANHUEZA', 'CRISTIAN ALEJANDRO SOBARZO SANHUEZA', '', true, 'None', 'CRISTIAN ALEJANDRO', 'SOBARZO SANHUEZA');
INSERT INTO candidato VALUES (7052971, 'A', 53, 2673, 999, 99, 'JOSE SAEZ VINET', 'JOSE SAEZ VINET', '', true, 'None', 'JOSE', 'SAEZ VINET');
INSERT INTO candidato VALUES (10182509, 'A', 50, 2674, 401, 99, 'FELIX SEGUNDO VITA MANQUEPI', 'FELIX SEGUNDO VITA MANQUEPI', '', false, 'None', 'FELIX SEGUNDO', 'VITA MANQUEPI');
INSERT INTO candidato VALUES (19052433, 'A', 51, 2674, 999, 99, 'ANDRES PUELMA HUENCHUCAN', 'ANDRES PUELMA HUENCHUCAN', '', true, 'None', 'ANDRES', 'PUELMA HUENCHUCAN');
INSERT INTO candidato VALUES (11579733, 'A', 52, 2674, 999, 99, 'MARIA CRISTINA MEDINA CASTRO', 'MARIA CRISTINA MEDINA CASTRO', '', true, 'None', 'MARIA CRISTINA', 'MEDINA CASTRO');
INSERT INTO candidato VALUES (15953675, 'A', 53, 2674, 999, 99, 'MIRIAM CURRIAO ESPUÑAN', 'MIRIAM CURRIAO ESPUÑAN', '', true, 'None', 'MIRIAM', 'CURRIAO ESPUÑAN');
INSERT INTO candidato VALUES (17366053, 'A', 50, 2675, 399, 197, 'JORGE ALEJANDRO SEPULVEDA ROSALES', 'JORGE ALEJANDRO SEPULVEDA ROSALES', '', false, 'None', 'JORGE ALEJANDRO', 'SEPULVEDA ROSALES');
INSERT INTO candidato VALUES (13517002, 'A', 51, 2675, 401, 99, 'ROBERTO FRANCISCO NEIRA ABURTO', 'ROBERTO FRANCISCO NEIRA ABURTO', '', false, 'None', 'ROBERTO FRANCISCO', 'NEIRA ABURTO');
INSERT INTO candidato VALUES (9870029, 'A', 52, 2675, 400, 1, 'PEDRO DURAN SANHUEZA', 'PEDRO DURAN SANHUEZA', '', false, 'None', 'PEDRO', 'DURAN SANHUEZA');
INSERT INTO candidato VALUES (16314749, 'A', 50, 2676, 401, 5, 'JONNATHAN HIDALGO QUEZADA', 'JONNATHAN HIDALGO QUEZADA', '', false, 'None', 'JONNATHAN', 'HIDALGO QUEZADA');
INSERT INTO candidato VALUES (8294238, 'A', 51, 2676, 400, 99, 'ALEJANDRO SAEZ VELIZ', 'ALEJANDRO SAEZ VELIZ', '', false, 'None', 'ALEJANDRO', 'SAEZ VELIZ');
INSERT INTO candidato VALUES (17326566, 'A', 52, 2676, 999, 99, 'HELMUTH MARTINEZ LLANCAPAN', 'HELMUTH MARTINEZ LLANCAPAN', '', true, 'None', 'HELMUTH', 'MARTINEZ LLANCAPAN');
INSERT INTO candidato VALUES (11249691, 'A', 50, 2677, 401, 130, 'DANILO FRANKLIN URRUTIA CARCAMO', 'DANILO FRANKLIN URRUTIA CARCAMO', '', false, 'None', 'DANILO FRANKLIN', 'URRUTIA CARCAMO');
INSERT INTO candidato VALUES (6399975, 'A', 51, 2677, 400, 1, 'RENE MANUEL GARCIA GARCIA', 'RENE MANUEL GARCIA GARCIA', '', false, 'None', 'RENE MANUEL', 'GARCIA GARCIA');
INSERT INTO candidato VALUES (10913024, 'A', 52, 2677, 999, 99, 'PAOLO ALBERTO VIVANCO MANRIQUEZ', 'PAOLO ALBERTO VIVANCO MANRIQUEZ', '', true, 'None', 'PAOLO ALBERTO', 'VIVANCO MANRIQUEZ');
INSERT INTO candidato VALUES (15260138, 'A', 53, 2677, 999, 99, 'CRISTIAN MORAGA LAGOS', 'CRISTIAN MORAGA LAGOS', '', true, 'None', 'CRISTIAN', 'MORAGA LAGOS');
INSERT INTO candidato VALUES (13660459, 'A', 54, 2677, 999, 99, 'RODRIGO PACHECO BURGOS', 'RODRIGO PACHECO BURGOS', '', true, 'None', 'RODRIGO', 'PACHECO BURGOS');
INSERT INTO candidato VALUES (13962586, 'A', 50, 2678, 401, 99, 'CHRISTIAN PAOLO CARTES FLORES', 'CHRISTIAN PAOLO CARTES FLORES', '', false, 'None', 'CHRISTIAN PAOLO', 'CARTES FLORES');
INSERT INTO candidato VALUES (13732557, 'A', 51, 2678, 439, 150, 'TIMOTEO ABEL MARIPIL PINCHEIRA', 'TIMOTEO ABEL MARIPIL PINCHEIRA', '', false, 'None', 'TIMOTEO ABEL', 'MARIPIL PINCHEIRA');
INSERT INTO candidato VALUES (10881159, 'A', 52, 2678, 400, 99, 'HECTOR CARRASCO RUIZ', 'HECTOR CARRASCO RUIZ', '', false, 'None', 'HECTOR', 'CARRASCO RUIZ');
INSERT INTO candidato VALUES (10094962, 'A', 53, 2678, 999, 99, 'CLAUDIO HENRIQUEZ GONZALEZ', 'CLAUDIO HENRIQUEZ GONZALEZ', '', true, 'None', 'CLAUDIO', 'HENRIQUEZ GONZALEZ');
INSERT INTO candidato VALUES (17498933, 'A', 54, 2678, 999, 99, 'DANIEL PARRA CALABRANO', 'DANIEL PARRA CALABRANO', '', true, 'None', 'DANIEL', 'PARRA CALABRANO');
INSERT INTO candidato VALUES (10726925, 'A', 50, 2679, 399, 99, 'INGRID CALFIN COFRE', 'INGRID CALFIN COFRE', '', false, 'None', 'INGRID', 'CALFIN COFRE');
INSERT INTO candidato VALUES (9048296, 'A', 51, 2679, 401, 2, 'LUIS ARMANDO ARIAS LOPEZ', 'LUIS ARMANDO ARIAS LOPEZ', '', false, 'None', 'LUIS ARMANDO', 'ARIAS LOPEZ');
INSERT INTO candidato VALUES (12536600, 'A', 52, 2679, 418, 99, 'ELIZABETH CAMPOS LEAL', 'ELIZABETH CAMPOS LEAL', '', false, 'None', 'ELIZABETH', 'CAMPOS LEAL');
INSERT INTO candidato VALUES (15235913, 'A', 53, 2679, 400, 99, 'CLAUDIO CARCAMO PAREDES', 'CLAUDIO CARCAMO PAREDES', '', false, 'None', 'CLAUDIO', 'CARCAMO PAREDES');
INSERT INTO candidato VALUES (13965066, 'A', 54, 2679, 999, 99, 'JOSE COLIHUIL BINIMELIS', 'JOSE COLIHUIL BINIMELIS', '', true, 'None', 'JOSE', 'COLIHUIL BINIMELIS');
INSERT INTO candidato VALUES (11409267, 'A', 55, 2679, 999, 99, 'PILAR LAGOS RETAMAL', 'PILAR LAGOS RETAMAL', '', true, 'None', 'PILAR', 'LAGOS RETAMAL');
INSERT INTO candidato VALUES (10844833, 'A', 50, 2680, 401, 99, 'MARCOS EDGARDO HERNANDEZ ROJAS', 'MARCOS EDGARDO HERNANDEZ ROJAS', '', false, 'None', 'MARCOS EDGARDO', 'HERNANDEZ ROJAS');
INSERT INTO candidato VALUES (16632344, 'A', 51, 2680, 444, 99, 'LUIS CAMILO ERICES QUEZADA', 'LUIS CAMILO ERICES QUEZADA', '', false, 'None', 'LUIS CAMILO', 'ERICES QUEZADA');
INSERT INTO candidato VALUES (15228861, 'A', 52, 2680, 400, 1, 'HANS GONZALEZ ESPINOZA', 'HANS GONZALEZ ESPINOZA', '', false, 'None', 'HANS', 'GONZALEZ ESPINOZA');
INSERT INTO candidato VALUES (12705310, 'A', 53, 2680, 999, 99, 'WILLY KEHR LLANOS', 'WILLY KEHR LLANOS', '', true, 'None', 'WILLY', 'KEHR LLANOS');
INSERT INTO candidato VALUES (15250985, 'A', 50, 2681, 401, 2, 'ANDRES ROMERO MARTINEZ', 'ANDRES ROMERO MARTINEZ', '', false, 'None', 'ANDRES', 'ROMERO MARTINEZ');
INSERT INTO candidato VALUES (13156884, 'A', 51, 2681, 444, 99, 'SILVANA YANIXA SAGREDO BARRA', 'SILVANA YANIXA SAGREDO BARRA', '', false, 'None', 'SILVANA YANIXA', 'SAGREDO BARRA');
INSERT INTO candidato VALUES (16631785, 'A', 52, 2681, 400, 99, 'RODRIGO POBLETE TORRES', 'RODRIGO POBLETE TORRES', '', false, 'None', 'RODRIGO', 'POBLETE TORRES');
INSERT INTO candidato VALUES (16825091, 'A', 50, 2682, 401, 5, 'GASTON MUÑOZ RIEGO', 'GASTON MUÑOZ RIEGO', '', false, 'None', 'GASTON', 'MUÑOZ RIEGO');
INSERT INTO candidato VALUES (13111632, 'A', 51, 2682, 418, 157, 'LUCIANO ROBERTO MONSALVE PASMIÑO', 'LUCIANO ROBERTO MONSALVE PASMIÑO', '', false, 'None', 'LUCIANO ROBERTO', 'MONSALVE PASMIÑO');
INSERT INTO candidato VALUES (16825130, 'A', 52, 2682, 444, 99, 'CAROLINA ANDREA FLORES PUMEYRAU', 'CAROLINA ANDREA FLORES PUMEYRAU', '', false, 'None', 'CAROLINA ANDREA', 'FLORES PUMEYRAU');
INSERT INTO candidato VALUES (12706801, 'A', 53, 2682, 400, 1, 'RICARDO JARAMILLO GALINDO', 'RICARDO JARAMILLO GALINDO', '', false, 'None', 'RICARDO', 'JARAMILLO GALINDO');
INSERT INTO candidato VALUES (9226661, 'A', 54, 2682, 999, 99, 'SUSANA FUENTES MORALES', 'SUSANA FUENTES MORALES', '', true, 'None', 'SUSANA', 'FUENTES MORALES');
INSERT INTO candidato VALUES (12927588, 'A', 55, 2682, 999, 99, 'CLAUDIA NAVARRETE ARIAS', 'CLAUDIA NAVARRETE ARIAS', '', true, 'None', 'CLAUDIA', 'NAVARRETE ARIAS');
INSERT INTO candidato VALUES (14079984, 'A', 50, 2683, 401, 99, 'ALEXIS ARTURO PINEDA RUIZ', 'ALEXIS ARTURO PINEDA RUIZ', '', false, 'None', 'ALEXIS ARTURO', 'PINEDA RUIZ');
INSERT INTO candidato VALUES (8097457, 'A', 51, 2683, 400, 1, 'RICARDO PEÑA RIQUELME', 'RICARDO PEÑA RIQUELME', '', false, 'None', 'RICARDO', 'PEÑA RIQUELME');
INSERT INTO candidato VALUES (18296947, 'A', 52, 2683, 999, 99, 'EDUARDO ANDRES BASTIAS SANDOVAL', 'EDUARDO ANDRES BASTIAS SANDOVAL', '', true, 'None', 'EDUARDO ANDRES', 'BASTIAS SANDOVAL');
INSERT INTO candidato VALUES (16847318, 'A', 50, 2684, 401, 99, 'ALEJANDRO CUMINAO BARROS', 'ALEJANDRO CUMINAO BARROS', '', false, 'None', 'ALEJANDRO', 'CUMINAO BARROS');
INSERT INTO candidato VALUES (12362462, 'A', 51, 2684, 439, 150, 'PATRICIO GUILLERMO BARROS SAEZ', 'PATRICIO GUILLERMO BARROS SAEZ', '', false, 'None', 'PATRICIO GUILLERMO', 'BARROS SAEZ');
INSERT INTO candidato VALUES (7301861, 'A', 52, 2684, 999, 99, 'EDUARDO NAVARRETE FUENTES', 'EDUARDO NAVARRETE FUENTES', '', true, 'None', 'EDUARDO', 'NAVARRETE FUENTES');
INSERT INTO candidato VALUES (11960616, 'A', 53, 2684, 999, 99, 'MAURICIO SALAZAR CIFUENTES', 'MAURICIO SALAZAR CIFUENTES', '', true, 'None', 'MAURICIO', 'SALAZAR CIFUENTES');
INSERT INTO candidato VALUES (12388134, 'A', 50, 2685, 401, 2, 'CESAR SEPULVEDA HUERTA', 'CESAR SEPULVEDA HUERTA', '', false, 'None', 'CESAR', 'SEPULVEDA HUERTA');
INSERT INTO candidato VALUES (15237159, 'A', 51, 2685, 418, 157, 'HERNAN GONZALO COÑOMAN LEPIMAN', 'HERNAN GONZALO COÑOMAN LEPIMAN', '', false, 'None', 'HERNAN GONZALO', 'COÑOMAN LEPIMAN');
INSERT INTO candidato VALUES (6634475, 'A', 52, 2685, 999, 99, 'MANUEL ADOLFO SALAS TRAUTMANN', 'MANUEL ADOLFO SALAS TRAUTMANN', '', true, 'None', 'MANUEL ADOLFO', 'SALAS TRAUTMANN');
INSERT INTO candidato VALUES (13811747, 'A', 53, 2685, 999, 99, 'OSCAR CHEFO VERGARA TAPIA', 'OSCAR CHEFO VERGARA TAPIA', '', true, 'None', 'OSCAR CHEFO', 'VERGARA TAPIA');
INSERT INTO candidato VALUES (15503840, 'A', 50, 2686, 439, 99, 'EVELYN VIRGINIA MORA GALLEGOS', 'EVELYN VIRGINIA MORA GALLEGOS', '', false, 'None', 'EVELYN VIRGINIA', 'MORA GALLEGOS');
INSERT INTO candidato VALUES (10390779, 'A', 51, 2686, 400, 37, 'MARCELA ESPARZA SAAVEDRA', 'MARCELA ESPARZA SAAVEDRA', '', false, 'None', 'MARCELA', 'ESPARZA SAAVEDRA');
INSERT INTO candidato VALUES (9774341, 'A', 52, 2686, 999, 99, 'JOSE BRAVO BURGOS', 'JOSE BRAVO BURGOS', '', true, 'None', 'JOSE', 'BRAVO BURGOS');
INSERT INTO candidato VALUES (9226795, 'A', 53, 2686, 999, 99, 'MARIO HERNAN GONZALEZ REBOLLEDO', 'MARIO HERNAN GONZALEZ REBOLLEDO', '', true, 'None', 'MARIO HERNAN', 'GONZALEZ REBOLLEDO');
INSERT INTO candidato VALUES (15656291, 'A', 54, 2686, 999, 99, 'LUIS ANTONIO LEVI ANINAO', 'LUIS ANTONIO LEVI ANINAO', '', true, 'None', 'LUIS ANTONIO', 'LEVI ANINAO');
INSERT INTO candidato VALUES (10127763, 'A', 50, 2687, 401, 4, 'ALEJANDRO SEPULVEDA TAPIA', 'ALEJANDRO SEPULVEDA TAPIA', '', false, 'None', 'ALEJANDRO', 'SEPULVEDA TAPIA');
INSERT INTO candidato VALUES (6113993, 'A', 51, 2687, 999, 99, 'LUIS ALBERTO MUÑOZ PEREZ', 'LUIS ALBERTO MUÑOZ PEREZ', '', true, 'None', 'LUIS ALBERTO', 'MUÑOZ PEREZ');
INSERT INTO candidato VALUES (12363368, 'A', 52, 2687, 999, 99, 'MIGUEL LARA VALDEBENITO', 'MIGUEL LARA VALDEBENITO', '', true, 'None', 'MIGUEL', 'LARA VALDEBENITO');
INSERT INTO candidato VALUES (9014695, 'A', 50, 2688, 401, 2, 'MARTIN SALAZAR CARVAJAL', 'MARTIN SALAZAR CARVAJAL', '', false, 'None', 'MARTIN', 'SALAZAR CARVAJAL');
INSERT INTO candidato VALUES (10332938, 'A', 51, 2688, 400, 1, 'JACQUELINE ROMERO INZUNZA', 'JACQUELINE ROMERO INZUNZA', '', false, 'None', 'JACQUELINE', 'ROMERO INZUNZA');
INSERT INTO candidato VALUES (12423010, 'A', 52, 2688, 999, 99, 'JORGE JARAMILLO HOTT', 'JORGE JARAMILLO HOTT', '', true, 'None', 'JORGE', 'JARAMILLO HOTT');
INSERT INTO candidato VALUES (18435078, 'A', 53, 2688, 999, 99, 'FELIPE ANDRES BARRIL RIQUELME', 'FELIPE ANDRES BARRIL RIQUELME', '', true, 'None', 'FELIPE ANDRES', 'BARRIL RIQUELME');
INSERT INTO candidato VALUES (9599743, 'A', 50, 2689, 399, 99, 'NANCY MILENA ALFARO JURJEVIC', 'NANCY MILENA ALFARO JURJEVIC', '', false, 'None', 'NANCY MILENA', 'ALFARO JURJEVIC');
INSERT INTO candidato VALUES (7914625, 'A', 51, 2689, 401, 99, 'EDITA ESTHER MANSILLA BARRIA', 'EDITA ESTHER MANSILLA BARRIA', '', false, 'None', 'EDITA ESTHER', 'MANSILLA BARRIA');
INSERT INTO candidato VALUES (10513911, 'A', 52, 2689, 400, 37, 'SEBASTIAN ALVAREZ RAMIREZ', 'SEBASTIAN ALVAREZ RAMIREZ', '', false, 'None', 'SEBASTIAN', 'ALVAREZ RAMIREZ');
INSERT INTO candidato VALUES (12336007, 'A', 53, 2689, 999, 99, 'ALVARO AGUILA RIQUELME', 'ALVARO AGUILA RIQUELME', '', true, 'None', 'ALVARO', 'AGUILA RIQUELME');
INSERT INTO candidato VALUES (7844519, 'A', 54, 2689, 999, 99, 'JUAN CARLOS PEREZ NUÑEZ', 'JUAN CARLOS PEREZ NUÑEZ', '', true, 'None', 'JUAN CARLOS', 'PEREZ NUÑEZ');
INSERT INTO candidato VALUES (10084530, 'A', 55, 2689, 999, 99, 'JOEL ALDO CANIO CANIO', 'JOEL ALDO CANIO CANIO', '', true, 'None', 'JOEL ALDO', 'CANIO CANIO');
INSERT INTO candidato VALUES (12743275, 'A', 56, 2689, 999, 99, 'LUIS ALBERTO BURGOS NORAMBUENA', 'LUIS ALBERTO BURGOS NORAMBUENA', '', true, 'None', 'LUIS ALBERTO', 'BURGOS NORAMBUENA');
INSERT INTO candidato VALUES (9054307, 'A', 57, 2689, 999, 99, 'MARIO PEÑAFIEL ESPINOZA', 'MARIO PEÑAFIEL ESPINOZA', '', true, 'None', 'MARIO', 'PEÑAFIEL ESPINOZA');
INSERT INTO candidato VALUES (6104644, 'A', 50, 2690, 399, 197, 'MARGARITA ZONIA LLANCAFIL ABURTO', 'MARGARITA ZONIA LLANCAFIL ABURTO', '', false, 'None', 'MARGARITA ZONIA', 'LLANCAFIL ABURTO');
INSERT INTO candidato VALUES (18125748, 'A', 51, 2690, 401, 99, 'ENRRI DANILO BAÑARES ALARCON', 'ENRRI DANILO BAÑARES ALARCON', '', false, 'None', 'ENRRI DANILO', 'BAÑARES ALARCON');
INSERT INTO candidato VALUES (12268035, 'A', 52, 2690, 999, 99, 'MARIO LLANCALEO BLANCO', 'MARIO LLANCALEO BLANCO', '', true, 'None', 'MARIO', 'LLANCALEO BLANCO');
INSERT INTO candidato VALUES (10082335, 'A', 53, 2690, 999, 99, 'RICARDO TRIPAINAO CALFULAF', 'RICARDO TRIPAINAO CALFULAF', '', true, 'None', 'RICARDO', 'TRIPAINAO CALFULAF');
INSERT INTO candidato VALUES (8754673, 'A', 50, 2691, 401, 4, 'ALFREDO WALDEMAR RIQUELME ARRIAGADA', 'ALFREDO WALDEMAR RIQUELME ARRIAGADA', '', false, 'None', 'ALFREDO WALDEMAR', 'RIQUELME ARRIAGADA');
INSERT INTO candidato VALUES (10676836, 'A', 51, 2691, 400, 3, 'BALDOMERO SANTOS VIDAL', 'BALDOMERO SANTOS VIDAL', '', false, 'None', 'BALDOMERO', 'SANTOS VIDAL');
INSERT INTO candidato VALUES (7061614, 'A', 50, 2692, 401, 2, 'JULIO LAUTARO HUENUL LOPEZ', 'JULIO LAUTARO HUENUL LOPEZ', '', false, 'None', 'JULIO LAUTARO', 'HUENUL LOPEZ');
INSERT INTO candidato VALUES (16246181, 'A', 51, 2692, 400, 3, 'GUILLERMO MARTINEZ SOTO', 'GUILLERMO MARTINEZ SOTO', '', false, 'None', 'GUILLERMO', 'MARTINEZ SOTO');
INSERT INTO candidato VALUES (14419215, 'A', 52, 2692, 999, 99, 'CRISTIAN ISMAEL SANDOVAL ORTIZ', 'CRISTIAN ISMAEL SANDOVAL ORTIZ', '', true, 'None', 'CRISTIAN ISMAEL', 'SANDOVAL ORTIZ');
INSERT INTO candidato VALUES (10492979, 'A', 50, 2693, 401, 4, 'SUSANA XIMENA AGUILERA VEGA', 'SUSANA XIMENA AGUILERA VEGA', '', false, 'None', 'SUSANA XIMENA', 'AGUILERA VEGA');
INSERT INTO candidato VALUES (16634809, 'A', 51, 2693, 400, 1, 'KATHERINNE MIGUELES MUÑOZ', 'KATHERINNE MIGUELES MUÑOZ', '', false, 'None', 'KATHERINNE', 'MIGUELES MUÑOZ');
INSERT INTO candidato VALUES (14491865, 'A', 52, 2693, 999, 99, 'BERNARDO MORA LARA', 'BERNARDO MORA LARA', '', true, 'None', 'BERNARDO', 'MORA LARA');
INSERT INTO candidato VALUES (11415306, 'A', 50, 2694, 399, 197, 'MARIA ZULEMA VERGARA QUIMEN', 'MARIA ZULEMA VERGARA QUIMEN', '', false, 'None', 'MARIA ZULEMA', 'VERGARA QUIMEN');
INSERT INTO candidato VALUES (8196820, 'A', 51, 2694, 401, 232, 'CARLOS ALBERTO MASCIOCCHI LEON', 'CARLOS ALBERTO MASCIOCCHI LEON', '', false, 'None', 'CARLOS ALBERTO', 'MASCIOCCHI LEON');
INSERT INTO candidato VALUES (8437774, 'A', 52, 2694, 400, 99, 'GERMAN VERGARA LAGOS', 'GERMAN VERGARA LAGOS', '', false, 'None', 'GERMAN', 'VERGARA LAGOS');
INSERT INTO candidato VALUES (14081529, 'A', 53, 2694, 999, 99, 'KATALINA GUDENSCHWAGER BASSO', 'KATALINA GUDENSCHWAGER BASSO', '', true, 'None', 'KATALINA', 'GUDENSCHWAGER BASSO');
INSERT INTO candidato VALUES (6842230, 'A', 54, 2694, 999, 99, 'PABLO ASTETE MERMOUD', 'PABLO ASTETE MERMOUD', '', true, 'None', 'PABLO', 'ASTETE MERMOUD');
INSERT INTO candidato VALUES (12268562, 'A', 55, 2694, 999, 99, 'ALEJANDRA AILLAPAN HUIRIQUEO', 'ALEJANDRA AILLAPAN HUIRIQUEO', '', true, 'None', 'ALEJANDRA', 'AILLAPAN HUIRIQUEO');
INSERT INTO candidato VALUES (14094805, 'A', 50, 2695, 401, 99, 'MARIA CRISTINA PAINEMAL PAINEMAL', 'MARIA CRISTINA PAINEMAL PAINEMAL', '', false, 'None', 'MARIA CRISTINA', 'PAINEMAL PAINEMAL');
INSERT INTO candidato VALUES (16046564, 'A', 51, 2695, 400, 99, 'ALVARO LABRAÑA OPAZO', 'ALVARO LABRAÑA OPAZO', '', false, 'None', 'ALVARO', 'LABRAÑA OPAZO');
INSERT INTO candidato VALUES (9815477, 'A', 52, 2695, 999, 99, 'HILARIO HUIRILEF BARRA', 'HILARIO HUIRILEF BARRA', '', true, 'None', 'HILARIO', 'HUIRILEF BARRA');
INSERT INTO candidato VALUES (12183321, 'A', 53, 2695, 999, 99, 'FRANCISCA SYLVIA HUIRILEF BARRA', 'FRANCISCA SYLVIA HUIRILEF BARRA', '', true, 'None', 'FRANCISCA SYLVIA', 'HUIRILEF BARRA');
INSERT INTO candidato VALUES (8524387, 'A', 54, 2695, 999, 99, 'LUIS RAUL HUENCHULEO GALLEGOS', 'LUIS RAUL HUENCHULEO GALLEGOS', '', true, 'None', 'LUIS RAUL', 'HUENCHULEO GALLEGOS');
INSERT INTO candidato VALUES (8385479, 'A', 50, 2696, 401, 2, 'MARIO VENEGAS CARDENAS', 'MARIO VENEGAS CARDENAS', '', false, 'None', 'MARIO', 'VENEGAS CARDENAS');
INSERT INTO candidato VALUES (10586522, 'A', 51, 2696, 444, 198, 'SERGIO ANIBAL PAREDES MONTOYA', 'SERGIO ANIBAL PAREDES MONTOYA', '', false, 'None', 'SERGIO ANIBAL', 'PAREDES MONTOYA');
INSERT INTO candidato VALUES (6535099, 'A', 52, 2696, 400, 99, 'ENRIQUE NEIRA NEIRA', 'ENRIQUE NEIRA NEIRA', '', false, 'None', 'ENRIQUE', 'NEIRA NEIRA');
INSERT INTO candidato VALUES (17460144, 'A', 53, 2696, 999, 99, 'MAXIMILIANO RADONICH RADONICH', 'MAXIMILIANO RADONICH RADONICH', '', true, 'None', 'MAXIMILIANO', 'RADONICH RADONICH');
INSERT INTO candidato VALUES (6162227, 'A', 54, 2696, 999, 99, 'VICTOR MANOLI NAZAL', 'VICTOR MANOLI NAZAL', '', true, 'None', 'VICTOR', 'MANOLI NAZAL');
INSERT INTO candidato VALUES (13387343, 'A', 55, 2696, 999, 99, 'CESAR RODRIGO RIQUELME OÑATE', 'CESAR RODRIGO RIQUELME OÑATE', '', true, 'None', 'CESAR RODRIGO', 'RIQUELME OÑATE');
INSERT INTO candidato VALUES (9128075, 'A', 56, 2696, 999, 99, 'EDUARDO CONTRERAS DIAZ', 'EDUARDO CONTRERAS DIAZ', '', true, 'None', 'EDUARDO', 'CONTRERAS DIAZ');
INSERT INTO candidato VALUES (14600560, 'A', 50, 2697, 401, 99, 'YULIANA EMA BUSTOS ZAPATA', 'YULIANA EMA BUSTOS ZAPATA', '', false, 'None', 'YULIANA EMA', 'BUSTOS ZAPATA');
INSERT INTO candidato VALUES (13151057, 'A', 51, 2697, 444, 99, 'FRANCISCO ANTONIO QUIDULEO CABRERA', 'FRANCISCO ANTONIO QUIDULEO CABRERA', '', false, 'None', 'FRANCISCO ANTONIO', 'QUIDULEO CABRERA');
INSERT INTO candidato VALUES (10673787, 'A', 52, 2697, 400, 1, 'MANUEL MACAYA RAMIREZ', 'MANUEL MACAYA RAMIREZ', '', false, 'None', 'MANUEL', 'MACAYA RAMIREZ');
INSERT INTO candidato VALUES (14467472, 'A', 53, 2697, 999, 99, 'LEONEL EDGARDO ARRIAGADA FUENTES', 'LEONEL EDGARDO ARRIAGADA FUENTES', '', true, 'None', 'LEONEL EDGARDO', 'ARRIAGADA FUENTES');
INSERT INTO candidato VALUES (15878701, 'A', 54, 2697, 999, 99, 'CLAUDIO ULLOA CANALES', 'CLAUDIO ULLOA CANALES', '', true, 'None', 'CLAUDIO', 'ULLOA CANALES');
INSERT INTO candidato VALUES (12589699, 'A', 55, 2697, 999, 99, 'MERY ANNE NAVIA VENEGAS', 'MERY ANNE NAVIA VENEGAS', '', true, 'None', 'MERY ANNE', 'NAVIA VENEGAS');
INSERT INTO candidato VALUES (11689659, 'A', 56, 2697, 999, 99, 'PATRICIO POBLETE HUENCHUMILLA', 'PATRICIO POBLETE HUENCHUMILLA', '', true, 'None', 'PATRICIO', 'POBLETE HUENCHUMILLA');
INSERT INTO candidato VALUES (12363557, 'A', 57, 2697, 999, 99, 'EDISON SANDOVAL CADIZ', 'EDISON SANDOVAL CADIZ', '', true, 'None', 'EDISON', 'SANDOVAL CADIZ');
INSERT INTO candidato VALUES (17745688, 'A', 58, 2697, 999, 99, 'JUAN CRISTOBAL CERDA FERNANDEZ', 'JUAN CRISTOBAL CERDA FERNANDEZ', '', true, 'None', 'JUAN CRISTOBAL', 'CERDA FERNANDEZ');
INSERT INTO candidato VALUES (6147873, 'A', 50, 2698, 401, 7, 'LUIS ALBERTO COULON LOPEZ', 'LUIS ALBERTO COULON LOPEZ', '', false, 'None', 'LUIS ALBERTO', 'COULON LOPEZ');
INSERT INTO candidato VALUES (13153455, 'A', 51, 2698, 400, 99, 'VICTOR MANUEL BARRERA BARRERA', 'VICTOR MANUEL BARRERA BARRERA', '', false, 'None', 'VICTOR MANUEL', 'BARRERA BARRERA');
INSERT INTO candidato VALUES (9395261, 'A', 52, 2698, 999, 99, 'HUGO VIDAL MERINO', 'HUGO VIDAL MERINO', '', true, 'None', 'HUGO', 'VIDAL MERINO');
INSERT INTO candidato VALUES (8655220, 'A', 50, 2699, 401, 99, 'VALENTIN ENRIQUE VIDAL HERNANDEZ', 'VALENTIN ENRIQUE VIDAL HERNANDEZ', '', false, 'None', 'VALENTIN ENRIQUE', 'VIDAL HERNANDEZ');
INSERT INTO candidato VALUES (9321734, 'A', 51, 2699, 400, 3, 'JOSE VILUGRON MARTINEZ', 'JOSE VILUGRON MARTINEZ', '', false, 'None', 'JOSE', 'VILUGRON MARTINEZ');
INSERT INTO candidato VALUES (13334727, 'A', 52, 2699, 999, 99, 'LUIS ORELLANA ROCHA', 'LUIS ORELLANA ROCHA', '', true, 'None', 'LUIS', 'ORELLANA ROCHA');
INSERT INTO candidato VALUES (12027577, 'A', 50, 2700, 401, 99, 'NIBALDO ALEGRIA ALEGRIA', 'NIBALDO ALEGRIA ALEGRIA', '', false, 'None', 'NIBALDO', 'ALEGRIA ALEGRIA');
INSERT INTO candidato VALUES (19655522, 'A', 51, 2700, 400, 99, 'EDUARDO YAÑEZ RIVAS', 'EDUARDO YAÑEZ RIVAS', '', false, 'None', 'EDUARDO', 'YAÑEZ RIVAS');
INSERT INTO candidato VALUES (10723016, 'A', 52, 2700, 999, 99, 'SERGIO HUGO AEDO HENRIQUEZ', 'SERGIO HUGO AEDO HENRIQUEZ', '', true, 'None', 'SERGIO HUGO', 'AEDO HENRIQUEZ');
INSERT INTO candidato VALUES (16511047, 'A', 50, 2701, 401, 2, 'BENJAMIN EDUARDO GARCES GUZMAN', 'BENJAMIN EDUARDO GARCES GUZMAN', '', false, 'None', 'BENJAMIN EDUARDO', 'GARCES GUZMAN');
INSERT INTO candidato VALUES (18148930, 'A', 51, 2701, 400, 99, 'GASTON MELLA CANDIA', 'GASTON MELLA CANDIA', '', false, 'None', 'GASTON', 'MELLA CANDIA');
INSERT INTO candidato VALUES (7048104, 'A', 52, 2701, 999, 99, 'VICTOR HUGO GONZALEZ RODRIGUEZ', 'VICTOR HUGO GONZALEZ RODRIGUEZ', '', true, 'None', 'VICTOR HUGO', 'GONZALEZ RODRIGUEZ');
INSERT INTO candidato VALUES (12705631, 'A', 50, 2702, 400, 99, 'RICHARD LEONELLI CONTRERAS', 'RICHARD LEONELLI CONTRERAS', '', false, 'None', 'RICHARD', 'LEONELLI CONTRERAS');
INSERT INTO candidato VALUES (10348070, 'A', 51, 2702, 999, 99, 'MANUEL PAINIQUEO TRAGNOLAO', 'MANUEL PAINIQUEO TRAGNOLAO', '', true, 'None', 'MANUEL', 'PAINIQUEO TRAGNOLAO');
INSERT INTO candidato VALUES (17557897, 'A', 50, 2703, 401, 4, 'FELIPE SANDOVAL MEDINA', 'FELIPE SANDOVAL MEDINA', '', false, 'None', 'FELIPE', 'SANDOVAL MEDINA');
INSERT INTO candidato VALUES (15226661, 'A', 51, 2703, 400, 37, 'FRANN BARBIERI FERNANDEZ', 'FRANN BARBIERI FERNANDEZ', '', false, 'None', 'FRANN', 'BARBIERI FERNANDEZ');
INSERT INTO candidato VALUES (6685125, 'A', 52, 2703, 999, 99, 'IDA FUENTES VALENZUELA', 'IDA FUENTES VALENZUELA', '', true, 'None', 'IDA', 'FUENTES VALENZUELA');
INSERT INTO candidato VALUES (9184142, 'A', 53, 2703, 999, 99, 'PEDRO HECTOR ORELLANA MOLINA', 'PEDRO HECTOR ORELLANA MOLINA', '', true, 'None', 'PEDRO HECTOR', 'ORELLANA MOLINA');
INSERT INTO candidato VALUES (10620970, 'A', 50, 2704, 401, 7, 'ALEX LORENS CASTILLO SALAMANCA', 'ALEX LORENS CASTILLO SALAMANCA', '', false, 'None', 'ALEX LORENS', 'CASTILLO SALAMANCA');
INSERT INTO candidato VALUES (4984736, 'A', 51, 2704, 444, 99, 'ELEODORO JAVIER SALGADO DELGADO', 'ELEODORO JAVIER SALGADO DELGADO', '', false, 'None', 'ELEODORO JAVIER', 'SALGADO DELGADO');
INSERT INTO candidato VALUES (10739600, 'A', 52, 2704, 400, 99, 'CLAUDIO MUSRE CONTRERAS', 'CLAUDIO MUSRE CONTRERAS', '', false, 'None', 'CLAUDIO', 'MUSRE CONTRERAS');
INSERT INTO candidato VALUES (13580639, 'A', 53, 2704, 999, 99, 'CARLA FRANCISCA SIERRA BELTRAN', 'CARLA FRANCISCA SIERRA BELTRAN', '', true, 'None', 'CARLA FRANCISCA', 'SIERRA BELTRAN');
INSERT INTO candidato VALUES (15226939, 'A', 54, 2704, 999, 99, 'NANCY DEL CARMEN PUENTES TRONCOSO', 'NANCY DEL CARMEN PUENTES TRONCOSO', '', true, 'None', 'NANCY DEL CARMEN', 'PUENTES TRONCOSO');
INSERT INTO candidato VALUES (15869253, 'A', 55, 2704, 999, 99, 'PAOLA ANDREA HERNANDEZ HERNANDEZ', 'PAOLA ANDREA HERNANDEZ HERNANDEZ', '', true, 'None', 'PAOLA ANDREA', 'HERNANDEZ HERNANDEZ');
INSERT INTO candidato VALUES (9633922, 'A', 56, 2704, 999, 99, 'VICTOR ENRIQUE FARIÑA WACHTENDORFF', 'VICTOR ENRIQUE FARIÑA WACHTENDORFF', '', true, 'None', 'VICTOR ENRIQUE', 'FARIÑA WACHTENDORFF');
INSERT INTO candidato VALUES (10906032, 'A', 57, 2704, 999, 99, 'HECTOR JOSE SAEZ PAREDES', 'HECTOR JOSE SAEZ PAREDES', '', true, 'None', 'HECTOR JOSE', 'SAEZ PAREDES');
INSERT INTO candidato VALUES (15224139, 'A', 50, 2705, 401, 4, 'FELIPE ANDRES OSSES CERNA', 'FELIPE ANDRES OSSES CERNA', '', false, 'None', 'FELIPE ANDRES', 'OSSES CERNA');
INSERT INTO candidato VALUES (3040040, 'A', 51, 2705, 400, 99, 'LUIS ALVAREZ VALENZUELA', 'LUIS ALVAREZ VALENZUELA', '', false, 'None', 'LUIS', 'ALVAREZ VALENZUELA');
INSERT INTO candidato VALUES (12705286, 'A', 52, 2705, 999, 99, 'ELVIRA ROXANA ARAVENA GAETE', 'ELVIRA ROXANA ARAVENA GAETE', '', true, 'None', 'ELVIRA ROXANA', 'ARAVENA GAETE');
INSERT INTO candidato VALUES (10202947, 'A', 53, 2705, 999, 99, 'FERNANDO RODRIGO CONTRERAS BOISIER', 'FERNANDO RODRIGO CONTRERAS BOISIER', '', true, 'None', 'FERNANDO RODRIGO', 'CONTRERAS BOISIER');
INSERT INTO candidato VALUES (17910879, 'A', 50, 2706, 444, 99, 'LUIS FELIPE VIDAL IBAÑEZ', 'LUIS FELIPE VIDAL IBAÑEZ', '', false, 'None', 'LUIS FELIPE', 'VIDAL IBAÑEZ');
INSERT INTO candidato VALUES (8169191, 'A', 51, 2706, 400, 99, 'ARIEL GUZMAN ITURRA', 'ARIEL GUZMAN ITURRA', '', false, 'None', 'ARIEL', 'GUZMAN ITURRA');
INSERT INTO candidato VALUES (10592391, 'A', 52, 2706, 999, 99, 'MARIA SOLEDAD CASTILLO HENRIQUEZ', 'MARIA SOLEDAD CASTILLO HENRIQUEZ', '', true, 'None', 'MARIA SOLEDAD', 'CASTILLO HENRIQUEZ');
INSERT INTO candidato VALUES (12189378, 'A', 53, 2706, 999, 99, 'ALFREDO BENAVIDES VIDAL', 'ALFREDO BENAVIDES VIDAL', '', true, 'None', 'ALFREDO', 'BENAVIDES VIDAL');
INSERT INTO candidato VALUES (11680264, 'A', 54, 2706, 999, 99, 'PAULO CESAR MIRANDA ARANEDA', 'PAULO CESAR MIRANDA ARANEDA', '', true, 'None', 'PAULO CESAR', 'MIRANDA ARANEDA');
INSERT INTO candidato VALUES (15562666, 'A', 55, 2706, 999, 99, 'JAVIER ALEJANDRO JARAMILLO SOTO', 'JAVIER ALEJANDRO JARAMILLO SOTO', '', true, 'None', 'JAVIER ALEJANDRO', 'JARAMILLO SOTO');
INSERT INTO candidato VALUES (10100886, 'A', 56, 2706, 999, 99, 'MARISOL ACUÑA RIQUELME', 'MARISOL ACUÑA RIQUELME', '', true, 'None', 'MARISOL', 'ACUÑA RIQUELME');
INSERT INTO candidato VALUES (11988494, 'A', 57, 2706, 999, 99, 'CLAUDIO MIRANDA IBAÑEZ', 'CLAUDIO MIRANDA IBAÑEZ', '', true, 'None', 'CLAUDIO', 'MIRANDA IBAÑEZ');
INSERT INTO candidato VALUES (12253807, 'A', 50, 2707, 399, 99, 'NELSON TORO AGUIRRE', 'NELSON TORO AGUIRRE', '', false, 'None', 'NELSON', 'TORO AGUIRRE');
INSERT INTO candidato VALUES (4423698, 'A', 51, 2707, 401, 5, 'RABINDRANATH QUINTEROS LARA', 'RABINDRANATH QUINTEROS LARA', '', false, 'None', 'RABINDRANATH', 'QUINTEROS LARA');
INSERT INTO candidato VALUES (20340973, 'A', 52, 2707, 418, 99, 'GISELLA SHANTEL ANDRADE MUÑOZ', 'GISELLA SHANTEL ANDRADE MUÑOZ', '', false, 'None', 'GISELLA SHANTEL', 'ANDRADE MUÑOZ');
INSERT INTO candidato VALUES (12021810, 'A', 53, 2707, 400, 1, 'RODRIGO WAINRAIHGT GALILEA', 'RODRIGO WAINRAIHGT GALILEA', '', false, 'None', 'RODRIGO', 'WAINRAIHGT GALILEA');
INSERT INTO candidato VALUES (13002875, 'A', 54, 2707, 999, 99, 'ANDREA QUINTANA DIAZ', 'ANDREA QUINTANA DIAZ', '', true, 'None', 'ANDREA', 'QUINTANA DIAZ');
INSERT INTO candidato VALUES (10233109, 'A', 55, 2707, 999, 99, 'COZUT VASQUEZ GONZALEZ', 'COZUT VASQUEZ GONZALEZ', '', true, 'None', 'COZUT', 'VASQUEZ GONZALEZ');
INSERT INTO candidato VALUES (10483916, 'A', 56, 2707, 999, 99, 'ARTURO SANCHEZ GATICA', 'ARTURO SANCHEZ GATICA', '', true, 'None', 'ARTURO', 'SANCHEZ GATICA');
INSERT INTO candidato VALUES (5441036, 'A', 50, 2708, 401, 7, 'RUBEN ROLANDO CARDENAS GOMEZ', 'RUBEN ROLANDO CARDENAS GOMEZ', '', false, 'None', 'RUBEN ROLANDO', 'CARDENAS GOMEZ');
INSERT INTO candidato VALUES (13901251, 'A', 51, 2708, 439, 150, 'LORENA ESTER PEREZ TORO', 'LORENA ESTER PEREZ TORO', '', false, 'None', 'LORENA ESTER', 'PEREZ TORO');
INSERT INTO candidato VALUES (6914296, 'A', 52, 2708, 400, 3, 'SERGIO GARCIA ALVAREZ', 'SERGIO GARCIA ALVAREZ', '', false, 'None', 'SERGIO', 'GARCIA ALVAREZ');
INSERT INTO candidato VALUES (13168155, 'A', 53, 2708, 999, 99, 'JUAN FRANCISCO CALBUCOY GUERRERO', 'JUAN FRANCISCO CALBUCOY GUERRERO', '', true, 'None', 'JUAN FRANCISCO', 'CALBUCOY GUERRERO');
INSERT INTO candidato VALUES (14517288, 'A', 54, 2708, 999, 99, 'CARLOS MANSILLA GALLARDO', 'CARLOS MANSILLA GALLARDO', '', true, 'None', 'CARLOS', 'MANSILLA GALLARDO');
INSERT INTO candidato VALUES (15286742, 'A', 55, 2708, 999, 99, 'MARCO ANDRES SILVA MALDONADO', 'MARCO ANDRES SILVA MALDONADO', '', true, 'None', 'MARCO ANDRES', 'SILVA MALDONADO');
INSERT INTO candidato VALUES (8011500, 'A', 50, 2709, 401, 99, 'CARLOS HERNAN ALFREDO SOTO SOTOMAYOR', 'CARLOS HERNAN ALFREDO SOTO SOTOMAYOR', '', false, 'None', 'CARLOS HERNAN ALFREDO', 'SOTO SOTOMAYOR');
INSERT INTO candidato VALUES (16822831, 'A', 51, 2709, 439, 150, 'PABLO CESAR MARIN TELLEZ', 'PABLO CESAR MARIN TELLEZ', '', false, 'None', 'PABLO CESAR', 'MARIN TELLEZ');
INSERT INTO candidato VALUES (15285937, 'A', 52, 2709, 999, 99, 'ELISEO FACUNDO BAHAMONDE TURRA', 'ELISEO FACUNDO BAHAMONDE TURRA', '', true, 'None', 'ELISEO FACUNDO', 'BAHAMONDE TURRA');
INSERT INTO candidato VALUES (15285474, 'A', 53, 2709, 999, 99, 'FRANCISCO JAVIER DONOSO OYARZUN', 'FRANCISCO JAVIER DONOSO OYARZUN', '', true, 'None', 'FRANCISCO JAVIER', 'DONOSO OYARZUN');
INSERT INTO candidato VALUES (7136914, 'A', 54, 2709, 999, 99, 'JESUS SILVERIO MORALES ROSALES', 'JESUS SILVERIO MORALES ROSALES', '', true, 'None', 'JESUS SILVERIO', 'MORALES ROSALES');
INSERT INTO candidato VALUES (9025691, 'A', 50, 2710, 401, 2, 'MIGUEL CARDENAS BARRIA', 'MIGUEL CARDENAS BARRIA', '', false, 'None', 'MIGUEL', 'CARDENAS BARRIA');
INSERT INTO candidato VALUES (18345935, 'A', 51, 2710, 439, 99, 'MARCELO IGNACIO BARRIENTOS BARRIENTOS', 'MARCELO IGNACIO BARRIENTOS BARRIENTOS', '', false, 'None', 'MARCELO IGNACIO', 'BARRIENTOS BARRIENTOS');
INSERT INTO candidato VALUES (8882140, 'A', 52, 2710, 400, 1, 'JAVIER OYARZO ALTAMIRANO', 'JAVIER OYARZO ALTAMIRANO', '', false, 'None', 'JAVIER', 'OYARZO ALTAMIRANO');
INSERT INTO candidato VALUES (10026045, 'A', 53, 2710, 999, 99, 'LUIS MARCELO BOHLE FLORES', 'LUIS MARCELO BOHLE FLORES', '', true, 'None', 'LUIS MARCELO', 'BOHLE FLORES');
INSERT INTO candidato VALUES (17035858, 'A', 50, 2711, 401, 5, 'NATALY SCHADOW MUÑOZ', 'NATALY SCHADOW MUÑOZ', '', false, 'None', 'NATALY', 'SCHADOW MUÑOZ');
INSERT INTO candidato VALUES (16338978, 'A', 51, 2711, 400, 99, 'JAVIER ARISMENDI VALENZUELA', 'JAVIER ARISMENDI VALENZUELA', '', false, 'None', 'JAVIER', 'ARISMENDI VALENZUELA');
INSERT INTO candidato VALUES (9140845, 'A', 52, 2711, 999, 99, 'RAMON EUGENIO ESPINOZA SANDOVAL', 'RAMON EUGENIO ESPINOZA SANDOVAL', '', true, 'None', 'RAMON EUGENIO', 'ESPINOZA SANDOVAL');
INSERT INTO candidato VALUES (13315787, 'A', 50, 2712, 399, 197, 'SANDY OLIVIA BARRIENTOS AVENDAÑO', 'SANDY OLIVIA BARRIENTOS AVENDAÑO', '', false, 'None', 'SANDY OLIVIA', 'BARRIENTOS AVENDAÑO');
INSERT INTO candidato VALUES (12336532, 'A', 51, 2712, 401, 99, 'LUIS BLANCO AREVALO', 'LUIS BLANCO AREVALO', '', false, 'None', 'LUIS', 'BLANCO AREVALO');
INSERT INTO candidato VALUES (8424799, 'A', 52, 2712, 400, 3, 'EMILIO GONZALEZ BURGOS', 'EMILIO GONZALEZ BURGOS', '', false, 'None', 'EMILIO', 'GONZALEZ BURGOS');
INSERT INTO candidato VALUES (13737104, 'A', 53, 2712, 999, 99, 'MARCELO ESEDIN CARDENAS GONZALEZ', 'MARCELO ESEDIN CARDENAS GONZALEZ', '', true, 'None', 'MARCELO ESEDIN', 'CARDENAS GONZALEZ');
INSERT INTO candidato VALUES (8072572, 'A', 50, 2713, 399, 197, 'ANTONIO CAILEO NAUTO', 'ANTONIO CAILEO NAUTO', '', false, 'None', 'ANTONIO', 'CAILEO NAUTO');
INSERT INTO candidato VALUES (10351214, 'A', 51, 2713, 401, 2, 'VICTOR RUBEN ANGULO MUÑOZ', 'VICTOR RUBEN ANGULO MUÑOZ', '', false, 'None', 'VICTOR RUBEN', 'ANGULO MUÑOZ');
INSERT INTO candidato VALUES (10751764, 'A', 52, 2713, 444, 99, 'FRANCISCO JAVIER VASQUEZ ALMONACID', 'FRANCISCO JAVIER VASQUEZ ALMONACID', '', false, 'None', 'FRANCISCO JAVIER', 'VASQUEZ ALMONACID');
INSERT INTO candidato VALUES (16136318, 'A', 53, 2713, 400, 3, 'EVELYN BRINTRUP FLORES', 'EVELYN BRINTRUP FLORES', '', false, 'None', 'EVELYN', 'BRINTRUP FLORES');
INSERT INTO candidato VALUES (10434908, 'A', 54, 2713, 999, 99, 'LUIS ERNESTO OROSTICA SALINAS', 'LUIS ERNESTO OROSTICA SALINAS', '', true, 'None', 'LUIS ERNESTO', 'OROSTICA SALINAS');
INSERT INTO candidato VALUES (15299321, 'A', 50, 2714, 401, 2, 'JORGE WESTERMEIER ESTRADA', 'JORGE WESTERMEIER ESTRADA', '', false, 'None', 'JORGE', 'WESTERMEIER ESTRADA');
INSERT INTO candidato VALUES (8170573, 'A', 51, 2714, 400, 99, 'NABIH SOZA CARDENAS', 'NABIH SOZA CARDENAS', '', false, 'None', 'NABIH', 'SOZA CARDENAS');
INSERT INTO candidato VALUES (8979456, 'A', 52, 2714, 999, 99, 'HARDY DIMTER GALLARDO', 'HARDY DIMTER GALLARDO', '', true, 'None', 'HARDY', 'DIMTER GALLARDO');
INSERT INTO candidato VALUES (16432580, 'A', 50, 2715, 399, 197, 'TAMARA AVENDAÑO LEVINAO', 'TAMARA AVENDAÑO LEVINAO', '', false, 'None', 'TAMARA', 'AVENDAÑO LEVINAO');
INSERT INTO candidato VALUES (9856751, 'A', 51, 2715, 400, 99, 'JAMES FRY CAREY', 'JAMES FRY CAREY', '', false, 'None', 'JAMES', 'FRY CAREY');
INSERT INTO candidato VALUES (18636422, 'A', 52, 2715, 999, 99, 'TOMAS ANDRES GARATE SILVA', 'TOMAS ANDRES GARATE SILVA', '', true, 'None', 'TOMAS ANDRES', 'GARATE SILVA');
INSERT INTO candidato VALUES (6391589, 'A', 53, 2715, 999, 99, 'RAMON BAHAMONDE CEA', 'RAMON BAHAMONDE CEA', '', true, 'None', 'RAMON', 'BAHAMONDE CEA');
INSERT INTO candidato VALUES (12752722, 'A', 50, 2716, 399, 99, 'JAIME LEONEL GUERRERO SEPULVEDA', 'JAIME LEONEL GUERRERO SEPULVEDA', '', false, 'None', 'JAIME LEONEL', 'GUERRERO SEPULVEDA');
INSERT INTO candidato VALUES (9222180, 'A', 51, 2716, 401, 5, 'BALTAZAR ELGUETA CHEUQUEPIL', 'BALTAZAR ELGUETA CHEUQUEPIL', '', false, 'None', 'BALTAZAR', 'ELGUETA CHEUQUEPIL');
INSERT INTO candidato VALUES (12190673, 'A', 52, 2716, 400, 99, 'JUAN EDUARDO VERA SANHUEZA', 'JUAN EDUARDO VERA SANHUEZA', '', false, 'None', 'JUAN EDUARDO', 'VERA SANHUEZA');
INSERT INTO candidato VALUES (15874473, 'A', 50, 2717, 399, 197, 'JUAN ELIAS SANHUEZA VARGAS', 'JUAN ELIAS SANHUEZA VARGAS', '', false, 'None', 'JUAN ELIAS', 'SANHUEZA VARGAS');
INSERT INTO candidato VALUES (13407890, 'A', 51, 2717, 439, 150, 'CARLOS GUSTAVO SEITZ ASPEE', 'CARLOS GUSTAVO SEITZ ASPEE', '', false, 'None', 'CARLOS GUSTAVO', 'SEITZ ASPEE');
INSERT INTO candidato VALUES (7523948, 'A', 52, 2717, 400, 3, 'ALIRO CAIMAPO OYARZO', 'ALIRO CAIMAPO OYARZO', '', false, 'None', 'ALIRO', 'CAIMAPO OYARZO');
INSERT INTO candidato VALUES (16461113, 'A', 53, 2717, 999, 99, 'MONICA PAMELA MALDONADO VELASQUEZ', 'MONICA PAMELA MALDONADO VELASQUEZ', '', true, 'None', 'MONICA PAMELA', 'MALDONADO VELASQUEZ');
INSERT INTO candidato VALUES (15304892, 'A', 54, 2717, 999, 99, 'ANDRES ANTONIO OJEDA CARE', 'ANDRES ANTONIO OJEDA CARE', '', true, 'None', 'ANDRES ANTONIO', 'OJEDA CARE');
INSERT INTO candidato VALUES (17742839, 'A', 55, 2717, 999, 99, 'EDUARDO RAUL ALVAREZ VIDAL', 'EDUARDO RAUL ALVAREZ VIDAL', '', true, 'None', 'EDUARDO RAUL', 'ALVAREZ VIDAL');
INSERT INTO candidato VALUES (16158470, 'A', 50, 2718, 401, 5, 'ANAKENNA MANCILLA VEGA', 'ANAKENNA MANCILLA VEGA', '', false, 'None', 'ANAKENNA', 'MANCILLA VEGA');
INSERT INTO candidato VALUES (13409137, 'A', 51, 2718, 400, 1, 'FERNANDO OYARZUN MACIAS', 'FERNANDO OYARZUN MACIAS', '', false, 'None', 'FERNANDO', 'OYARZUN MACIAS');
INSERT INTO candidato VALUES (8579726, 'A', 52, 2718, 999, 99, 'JOSE ENRIQUE NAVARRO OYARZO', 'JOSE ENRIQUE NAVARRO OYARZO', '', true, 'None', 'JOSE ENRIQUE', 'NAVARRO OYARZO');
INSERT INTO candidato VALUES (16996044, 'A', 50, 2719, 401, 99, 'JAVIERA YAÑEZ REBOLLEDO', 'JAVIERA YAÑEZ REBOLLEDO', '', false, 'None', 'JAVIERA', 'YAÑEZ REBOLLEDO');
INSERT INTO candidato VALUES (11414169, 'A', 50, 2720, 401, 99, 'ALEX WALDEMAR GOMEZ AGUILAR', 'ALEX WALDEMAR GOMEZ AGUILAR', '', false, 'None', 'ALEX WALDEMAR', 'GOMEZ AGUILAR');
INSERT INTO candidato VALUES (10089731, 'A', 51, 2720, 400, 99, 'ALEJANDRA VILLEGAS HUICHAMAN', 'ALEJANDRA VILLEGAS HUICHAMAN', '', false, 'None', 'ALEJANDRA', 'VILLEGAS HUICHAMAN');
INSERT INTO candidato VALUES (12760686, 'A', 52, 2720, 999, 99, 'YASNA CECILIA IGOR GUICHACOY', 'YASNA CECILIA IGOR GUICHACOY', '', true, 'None', 'YASNA CECILIA', 'IGOR GUICHACOY');
INSERT INTO candidato VALUES (14310165, 'A', 53, 2720, 999, 99, 'CARLOS ROBERTO CARDENAS BAHAMONDE', 'CARLOS ROBERTO CARDENAS BAHAMONDE', '', true, 'None', 'CARLOS ROBERTO', 'CARDENAS BAHAMONDE');
INSERT INTO candidato VALUES (11717265, 'A', 54, 2720, 999, 99, 'JUAN CARLOS SOTO CARDENAS', 'JUAN CARLOS SOTO CARDENAS', '', true, 'None', 'JUAN CARLOS', 'SOTO CARDENAS');
INSERT INTO candidato VALUES (9277273, 'A', 50, 2721, 401, 4, 'ELSON NOLBERTO CARCAMO BARRIA', 'ELSON NOLBERTO CARCAMO BARRIA', '', false, 'None', 'ELSON NOLBERTO', 'CARCAMO BARRIA');
INSERT INTO candidato VALUES (14405810, 'A', 51, 2721, 439, 99, 'ALEJANDRO ARIEL CARDENAS QUEZADA', 'ALEJANDRO ARIEL CARDENAS QUEZADA', '', false, 'None', 'ALEJANDRO ARIEL', 'CARDENAS QUEZADA');
INSERT INTO candidato VALUES (13170590, 'A', 52, 2721, 400, 1, 'ALEX AGUERO ALVARADO', 'ALEX AGUERO ALVARADO', '', false, 'None', 'ALEX', 'AGUERO ALVARADO');
INSERT INTO candidato VALUES (16078407, 'A', 53, 2721, 999, 99, 'GABRIELA MERCEDES VERA MARTINEZ', 'GABRIELA MERCEDES VERA MARTINEZ', '', true, 'None', 'GABRIELA MERCEDES', 'VERA MARTINEZ');
INSERT INTO candidato VALUES (13408918, 'A', 54, 2721, 999, 99, 'BELFOR TEODOCIO MONTIEL VERA', 'BELFOR TEODOCIO MONTIEL VERA', '', true, 'None', 'BELFOR TEODOCIO', 'MONTIEL VERA');
INSERT INTO candidato VALUES (17201859, 'A', 55, 2721, 999, 99, 'BERNARDINO ROBERTO ARELLANO INOSTROZA', 'BERNARDINO ROBERTO ARELLANO INOSTROZA', '', true, 'None', 'BERNARDINO ROBERTO', 'ARELLANO INOSTROZA');
INSERT INTO candidato VALUES (13170016, 'A', 56, 2721, 999, 99, 'MARCO ANTONIO URIBE BARRIA', 'MARCO ANTONIO URIBE BARRIA', '', true, 'None', 'MARCO ANTONIO', 'URIBE BARRIA');
INSERT INTO candidato VALUES (13169805, 'A', 50, 2722, 401, 2, 'MARCOS VARGAS OYARZUN', 'MARCOS VARGAS OYARZUN', '', false, 'None', 'MARCOS', 'VARGAS OYARZUN');
INSERT INTO candidato VALUES (15892770, 'A', 51, 2722, 400, 99, 'ROMELIO BORQUEZ HIDALGO', 'ROMELIO BORQUEZ HIDALGO', '', false, 'None', 'ROMELIO', 'BORQUEZ HIDALGO');
INSERT INTO candidato VALUES (8851764, 'A', 52, 2722, 999, 99, 'MIGUEL OPITZ GONZALEZ', 'MIGUEL OPITZ GONZALEZ', '', true, 'None', 'MIGUEL', 'OPITZ GONZALEZ');
INSERT INTO candidato VALUES (9894639, 'A', 50, 2723, 399, 99, 'JOSE ANTONIO LOW POBLETE', 'JOSE ANTONIO LOW POBLETE', '', false, 'None', 'JOSE ANTONIO', 'LOW POBLETE');
INSERT INTO candidato VALUES (9597715, 'A', 51, 2723, 401, 2, 'CARLOS CHIGUAY CARCAMO', 'CARLOS CHIGUAY CARCAMO', '', false, 'None', 'CARLOS', 'CHIGUAY CARCAMO');
INSERT INTO candidato VALUES (8738427, 'A', 52, 2723, 400, 99, 'PATRICIO ALTAMIRANO BARRIAS', 'PATRICIO ALTAMIRANO BARRIAS', '', false, 'None', 'PATRICIO', 'ALTAMIRANO BARRIAS');
INSERT INTO candidato VALUES (16309458, 'A', 53, 2723, 999, 99, 'CLAUDIO ESTEBAN VERA MANSILLA', 'CLAUDIO ESTEBAN VERA MANSILLA', '', true, 'None', 'CLAUDIO ESTEBAN', 'VERA MANSILLA');
INSERT INTO candidato VALUES (7761463, 'A', 54, 2723, 999, 99, 'CLAUDIO JORGE BARUDY LABRIN', 'CLAUDIO JORGE BARUDY LABRIN', '', true, 'None', 'CLAUDIO JORGE', 'BARUDY LABRIN');
INSERT INTO candidato VALUES (14630373, 'A', 55, 2723, 999, 99, 'PAULA ANDREA MILLACURA TORRES', 'PAULA ANDREA MILLACURA TORRES', '', true, 'None', 'PAULA ANDREA', 'MILLACURA TORRES');
INSERT INTO candidato VALUES (13594762, 'A', 56, 2723, 999, 99, 'LUIS MARCELO ZAMORANO DIAZ', 'LUIS MARCELO ZAMORANO DIAZ', '', true, 'None', 'LUIS MARCELO', 'ZAMORANO DIAZ');
INSERT INTO candidato VALUES (15883242, 'A', 57, 2723, 999, 99, 'PEDRO ANDRES BARRIA OYARZO', 'PEDRO ANDRES BARRIA OYARZO', '', true, 'None', 'PEDRO ANDRES', 'BARRIA OYARZO');
INSERT INTO candidato VALUES (13001488, 'A', 50, 2724, 401, 5, 'JAVIER UGARTE MANSILLA', 'JAVIER UGARTE MANSILLA', '', false, 'None', 'JAVIER', 'UGARTE MANSILLA');
INSERT INTO candidato VALUES (6641633, 'A', 51, 2724, 400, 99, 'GUSTAVO LOBOS MARIN', 'GUSTAVO LOBOS MARIN', '', false, 'None', 'GUSTAVO', 'LOBOS MARIN');
INSERT INTO candidato VALUES (15288836, 'A', 52, 2724, 999, 99, 'PATRICIO JAVIER BARRIA ALVAREZ', 'PATRICIO JAVIER BARRIA ALVAREZ', '', true, 'None', 'PATRICIO JAVIER', 'BARRIA ALVAREZ');
INSERT INTO candidato VALUES (10172281, 'A', 50, 2725, 401, 99, 'RENE GARCES ALVAREZ', 'RENE GARCES ALVAREZ', '', false, 'None', 'RENE', 'GARCES ALVAREZ');
INSERT INTO candidato VALUES (9687618, 'A', 51, 2725, 439, 99, 'LUIS HERNAN GONZALEZ URIBE', 'LUIS HERNAN GONZALEZ URIBE', '', false, 'None', 'LUIS HERNAN', 'GONZALEZ URIBE');
INSERT INTO candidato VALUES (9015679, 'A', 52, 2725, 400, 3, 'WASHINGTON ARNALDO ULLOA VILLARROEL', 'WASHINGTON ARNALDO ULLOA VILLARROEL', '', false, 'None', 'WASHINGTON ARNALDO', 'ULLOA VILLARROEL');
INSERT INTO candidato VALUES (15291284, 'A', 53, 2725, 999, 99, 'OSCAR ARISTIDES GALLARDO CALBUYAHUE', 'OSCAR ARISTIDES GALLARDO CALBUYAHUE', '', true, 'None', 'OSCAR ARISTIDES', 'GALLARDO CALBUYAHUE');
INSERT INTO candidato VALUES (5562955, 'A', 50, 2726, 399, 197, 'JAIME PAREDES PAREDES', 'JAIME PAREDES PAREDES', '', false, 'None', 'JAIME', 'PAREDES PAREDES');
INSERT INTO candidato VALUES (9293867, 'A', 51, 2726, 401, 2, 'EMETERIO CARRILLO TORRES', 'EMETERIO CARRILLO TORRES', '', false, 'None', 'EMETERIO', 'CARRILLO TORRES');
INSERT INTO candidato VALUES (7371986, 'A', 52, 2726, 400, 3, 'JAVIER HERNANDEZ HERNANDEZ', 'JAVIER HERNANDEZ HERNANDEZ', '', false, 'None', 'JAVIER', 'HERNANDEZ HERNANDEZ');
INSERT INTO candidato VALUES (6304905, 'A', 53, 2726, 999, 99, 'JAIME ALBERTO BERTIN VALENZUELA', 'JAIME ALBERTO BERTIN VALENZUELA', '', true, 'None', 'JAIME ALBERTO', 'BERTIN VALENZUELA');
INSERT INTO candidato VALUES (15323536, 'A', 54, 2726, 999, 99, 'MAURICE GOUDIE DOMINGUEZ', 'MAURICE GOUDIE DOMINGUEZ', '', true, 'None', 'MAURICE', 'GOUDIE DOMINGUEZ');
INSERT INTO candidato VALUES (13906738, 'A', 55, 2726, 999, 99, 'ALVARO ANDRES GOMEZ GONZALEZ', 'ALVARO ANDRES GOMEZ GONZALEZ', '', true, 'None', 'ALVARO ANDRES', 'GOMEZ GONZALEZ');
INSERT INTO candidato VALUES (10873261, 'A', 50, 2727, 401, 99, 'GERARDO AUGUSTO GUNCKEL ARRIAGADA', 'GERARDO AUGUSTO GUNCKEL ARRIAGADA', '', false, 'None', 'GERARDO AUGUSTO', 'GUNCKEL ARRIAGADA');
INSERT INTO candidato VALUES (13323249, 'A', 51, 2727, 418, 157, 'JUAN LUIS AÑAZCO BARRIENTOS', 'JUAN LUIS AÑAZCO BARRIENTOS', '', false, 'None', 'JUAN LUIS', 'AÑAZCO BARRIENTOS');
INSERT INTO candidato VALUES (9529984, 'A', 52, 2727, 400, 3, 'MARIA ELENA OJEDA BETANCOURT', 'MARIA ELENA OJEDA BETANCOURT', '', false, 'None', 'MARIA ELENA', 'OJEDA BETANCOURT');
INSERT INTO candidato VALUES (11597035, 'A', 50, 2728, 401, 2, 'CESAR CROT VARGAS', 'CESAR CROT VARGAS', '', false, 'None', 'CESAR', 'CROT VARGAS');
INSERT INTO candidato VALUES (6451049, 'A', 51, 2728, 439, 99, 'ALICIA DEL CARMEN VILLAR VARGAS', 'ALICIA DEL CARMEN VILLAR VARGAS', '', false, 'None', 'ALICIA DEL CARMEN', 'VILLAR VARGAS');
INSERT INTO candidato VALUES (16638033, 'A', 52, 2728, 999, 99, 'ERWIN DAVID PEREZ MONJE', 'ERWIN DAVID PEREZ MONJE', '', true, 'None', 'ERWIN DAVID', 'PEREZ MONJE');
INSERT INTO candidato VALUES (8927462, 'A', 53, 2728, 999, 99, 'ISIDORO RODOLFO BARQUIN PARDO', 'ISIDORO RODOLFO BARQUIN PARDO', '', true, 'None', 'ISIDORO RODOLFO', 'BARQUIN PARDO');
INSERT INTO candidato VALUES (10772939, 'A', 50, 2729, 401, 4, 'GASTON BERNABE DELGADO ALVAREZ', 'GASTON BERNABE DELGADO ALVAREZ', '', false, 'None', 'GASTON BERNABE', 'DELGADO ALVAREZ');
INSERT INTO candidato VALUES (8215529, 'A', 51, 2729, 400, 3, 'JIMENA NUÑEZ MORALES', 'JIMENA NUÑEZ MORALES', '', false, 'None', 'JIMENA', 'NUÑEZ MORALES');
INSERT INTO candidato VALUES (16047126, 'A', 52, 2729, 999, 99, 'DANIELA NATALIE MOLINA SANDOVAL', 'DANIELA NATALIE MOLINA SANDOVAL', '', true, 'None', 'DANIELA NATALIE', 'MOLINA SANDOVAL');
INSERT INTO candidato VALUES (16048035, 'A', 53, 2729, 999, 99, 'IVAN EDUARDO REYES SANTANA', 'IVAN EDUARDO REYES SANTANA', '', true, 'None', 'IVAN EDUARDO', 'REYES SANTANA');
INSERT INTO candidato VALUES (15274206, 'A', 50, 2730, 401, 99, 'ERNESTO HUAIQUIAN VERA', 'ERNESTO HUAIQUIAN VERA', '', false, 'None', 'ERNESTO', 'HUAIQUIAN VERA');
INSERT INTO candidato VALUES (16376493, 'A', 51, 2730, 400, 1, 'SEBASTIAN CRUZAT CARCAMO', 'SEBASTIAN CRUZAT CARCAMO', '', false, 'None', 'SEBASTIAN', 'CRUZAT CARCAMO');
INSERT INTO candidato VALUES (12422380, 'A', 50, 2731, 401, 2, 'JOSE LUIS MUÑOZ URIBE', 'JOSE LUIS MUÑOZ URIBE', '', false, 'None', 'JOSE LUIS', 'MUÑOZ URIBE');
INSERT INTO candidato VALUES (10697401, 'A', 51, 2731, 400, 99, 'MARIA EUGENIA SILVA MUÑOZ', 'MARIA EUGENIA SILVA MUÑOZ', '', false, 'None', 'MARIA EUGENIA', 'SILVA MUÑOZ');
INSERT INTO candidato VALUES (10670829, 'A', 52, 2731, 999, 99, 'MARGOT INES BARRIENTOS MOLINA', 'MARGOT INES BARRIENTOS MOLINA', '', true, 'None', 'MARGOT INES', 'BARRIENTOS MOLINA');
INSERT INTO candidato VALUES (14495280, 'A', 53, 2731, 999, 99, 'ANA SANTIBAÑEZ HERNANDEZ', 'ANA SANTIBAÑEZ HERNANDEZ', '', true, 'None', 'ANA', 'SANTIBAÑEZ HERNANDEZ');
INSERT INTO candidato VALUES (13589920, 'A', 54, 2731, 999, 99, 'MARCELO ENRIQUE CHEUQUIAN CUMIAN', 'MARCELO ENRIQUE CHEUQUIAN CUMIAN', '', true, 'None', 'MARCELO ENRIQUE', 'CHEUQUIAN CUMIAN');
INSERT INTO candidato VALUES (7719915, 'A', 50, 2732, 399, 99, 'JOSE ARMANDO GUARDA CARRILLO', 'JOSE ARMANDO GUARDA CARRILLO', '', false, 'None', 'JOSE ARMANDO', 'GUARDA CARRILLO');
INSERT INTO candidato VALUES (13403709, 'A', 51, 2732, 401, 4, 'MARCO ANTONIO CARRILLO BRAVO', 'MARCO ANTONIO CARRILLO BRAVO', '', false, 'None', 'MARCO ANTONIO', 'CARRILLO BRAVO');
INSERT INTO candidato VALUES (12138890, 'A', 52, 2732, 444, 99, 'CARMEN CABRERA PINUER', 'CARMEN CABRERA PINUER', '', false, 'None', 'CARMEN', 'CABRERA PINUER');
INSERT INTO candidato VALUES (11921742, 'A', 53, 2732, 400, 1, 'JUAN CARLOS SOTO CAUCAU', 'JUAN CARLOS SOTO CAUCAU', '', false, 'None', 'JUAN CARLOS', 'SOTO CAUCAU');
INSERT INTO candidato VALUES (14425844, 'A', 50, 2733, 401, 99, 'MARCELO JAVIER AÑAZCO NEGRON', 'MARCELO JAVIER AÑAZCO NEGRON', '', false, 'None', 'MARCELO JAVIER', 'AÑAZCO NEGRON');
INSERT INTO candidato VALUES (14490186, 'A', 51, 2733, 400, 99, 'CLARA LAZCANO FERNANDEZ', 'CLARA LAZCANO FERNANDEZ', '', false, 'None', 'CLARA', 'LAZCANO FERNANDEZ');
INSERT INTO candidato VALUES (10581197, 'A', 50, 2734, 400, 3, 'ALEJANDRA TORRES VASQUEZ', 'ALEJANDRA TORRES VASQUEZ', '', false, 'None', 'ALEJANDRA', 'TORRES VASQUEZ');
INSERT INTO candidato VALUES (11577954, 'A', 51, 2734, 999, 99, 'JOSE ALEJANDRO AVELLO BASCUR', 'JOSE ALEJANDRO AVELLO BASCUR', '', true, 'None', 'JOSE ALEJANDRO', 'AVELLO BASCUR');
INSERT INTO candidato VALUES (9045526, 'A', 52, 2734, 999, 99, 'FERNANDO ERWIN GRANDON DOMKE', 'FERNANDO ERWIN GRANDON DOMKE', '', true, 'None', 'FERNANDO ERWIN', 'GRANDON DOMKE');
INSERT INTO candidato VALUES (15967934, 'A', 50, 2735, 401, 5, 'ROBERTO SOTO ESCALONA', 'ROBERTO SOTO ESCALONA', '', false, 'None', 'ROBERTO', 'SOTO ESCALONA');
INSERT INTO candidato VALUES (8554358, 'A', 51, 2735, 999, 99, 'CRISTINA ESPINOZA OJEDA', 'CRISTINA ESPINOZA OJEDA', '', true, 'None', 'CRISTINA', 'ESPINOZA OJEDA');
INSERT INTO candidato VALUES (15792668, 'A', 50, 2736, 400, 1, 'JULIO DELGADO RETAMAL', 'JULIO DELGADO RETAMAL', '', false, 'None', 'JULIO', 'DELGADO RETAMAL');
INSERT INTO candidato VALUES (10950638, 'A', 51, 2736, 999, 99, 'WILLY OCTAVIO ROSAS DELGADO', 'WILLY OCTAVIO ROSAS DELGADO', '', true, 'None', 'WILLY OCTAVIO', 'ROSAS DELGADO');
INSERT INTO candidato VALUES (14365723, 'A', 50, 2737, 399, 197, 'JAIME JORQUERA HERRERA', 'JAIME JORQUERA HERRERA', '', false, 'None', 'JAIME', 'JORQUERA HERRERA');
INSERT INTO candidato VALUES (17445861, 'A', 51, 2737, 401, 2, 'CARLOS GATICA VILLEGAS', 'CARLOS GATICA VILLEGAS', '', false, 'None', 'CARLOS', 'GATICA VILLEGAS');
INSERT INTO candidato VALUES (15304860, 'A', 52, 2737, 439, 150, 'LUZ VALERIA VILLEGAS OJEDA', 'LUZ VALERIA VILLEGAS OJEDA', '', false, 'None', 'LUZ VALERIA', 'VILLEGAS OJEDA');
INSERT INTO candidato VALUES (8440809, 'A', 53, 2737, 999, 99, 'LUPERCIANO SEGUNDO MUÑOZ GONZALEZ', 'LUPERCIANO SEGUNDO MUÑOZ GONZALEZ', '', true, 'None', 'LUPERCIANO SEGUNDO', 'MUÑOZ GONZALEZ');
INSERT INTO candidato VALUES (12362098, 'A', 54, 2737, 999, 99, 'EUGENIO CANALES CANALES', 'EUGENIO CANALES CANALES', '', true, 'None', 'EUGENIO', 'CANALES CANALES');
INSERT INTO candidato VALUES (16364576, 'A', 50, 2738, 401, 99, 'CLAUDIA ANDREA VALDES VASQUEZ', 'CLAUDIA ANDREA VALDES VASQUEZ', '', false, 'None', 'CLAUDIA ANDREA', 'VALDES VASQUEZ');
INSERT INTO candidato VALUES (15517105, 'A', 51, 2738, 444, 198, 'MARCO ADIEL SAN MARTIN SAN MARTIN', 'MARCO ADIEL SAN MARTIN SAN MARTIN', '', false, 'None', 'MARCO ADIEL', 'SAN MARTIN SAN MARTIN');
INSERT INTO candidato VALUES (13739812, 'A', 52, 2738, 400, 99, 'DOLY CADAGAN MARDONES', 'DOLY CADAGAN MARDONES', '', false, 'None', 'DOLY', 'CADAGAN MARDONES');
INSERT INTO candidato VALUES (9018022, 'A', 53, 2738, 999, 99, 'RAUL ROGELIO BECERRA ESCOBAR', 'RAUL ROGELIO BECERRA ESCOBAR', '', true, 'None', 'RAUL ROGELIO', 'BECERRA ESCOBAR');
INSERT INTO candidato VALUES (8386215, 'A', 50, 2739, 401, 99, 'JULIO ESTEBAN CONFUCIO URIBE ALVARADO', 'JULIO ESTEBAN CONFUCIO URIBE ALVARADO', '', false, 'None', 'JULIO ESTEBAN CONFUCIO', 'URIBE ALVARADO');
INSERT INTO candidato VALUES (8691386, 'A', 51, 2739, 400, 3, 'LUIS MARTINEZ GALLARDO', 'LUIS MARTINEZ GALLARDO', '', false, 'None', 'LUIS', 'MARTINEZ GALLARDO');
INSERT INTO candidato VALUES (10004175, 'A', 52, 2739, 999, 99, 'SERGIO ARTURO GONZALEZ BORQUEZ', 'SERGIO ARTURO GONZALEZ BORQUEZ', '', true, 'None', 'SERGIO ARTURO', 'GONZALEZ BORQUEZ');
INSERT INTO candidato VALUES (12540604, 'A', 50, 2740, 401, 99, 'GLORIA DEL CARMEN CADAGAN OPAZO', 'GLORIA DEL CARMEN CADAGAN OPAZO', '', false, 'None', 'GLORIA DEL CARMEN', 'CADAGAN OPAZO');
INSERT INTO candidato VALUES (14089514, 'A', 51, 2740, 400, 1, 'FRANCISCO RONCAGLIOLO LEPIO', 'FRANCISCO RONCAGLIOLO LEPIO', '', false, 'None', 'FRANCISCO', 'RONCAGLIOLO LEPIO');
INSERT INTO candidato VALUES (10070912, 'A', 50, 2741, 399, 99, 'PAULA RODRIGUEZ VALENZUELA', 'PAULA RODRIGUEZ VALENZUELA', '', false, 'None', 'PAULA', 'RODRIGUEZ VALENZUELA');
INSERT INTO candidato VALUES (12059042, 'A', 51, 2741, 401, 99, 'MARCOS RAFAEL SILVA MIRANDA', 'MARCOS RAFAEL SILVA MIRANDA', '', false, 'None', 'MARCOS RAFAEL', 'SILVA MIRANDA');
INSERT INTO candidato VALUES (16975359, 'A', 52, 2741, 400, 37, 'BANS PUINAO CARIMONEY', 'BANS PUINAO CARIMONEY', '', false, 'None', 'BANS', 'PUINAO CARIMONEY');
INSERT INTO candidato VALUES (13969774, 'A', 50, 2742, 401, 7, 'JORGE EDUARDO CALDERON NUÑEZ', 'JORGE EDUARDO CALDERON NUÑEZ', '', false, 'None', 'JORGE EDUARDO', 'CALDERON NUÑEZ');
INSERT INTO candidato VALUES (9915918, 'A', 51, 2742, 400, 3, 'PATRICIO ULLOA GEORGIA', 'PATRICIO ULLOA GEORGIA', '', false, 'None', 'PATRICIO', 'ULLOA GEORGIA');
INSERT INTO candidato VALUES (6308068, 'A', 50, 2743, 401, 2, 'CLAUDIO FICA GOMEZ', 'CLAUDIO FICA GOMEZ', '', false, 'None', 'CLAUDIO', 'FICA GOMEZ');
INSERT INTO candidato VALUES (6994136, 'A', 51, 2743, 400, 99, 'ROBERTO RECABAL CARCAMO', 'ROBERTO RECABAL CARCAMO', '', false, 'None', 'ROBERTO', 'RECABAL CARCAMO');
INSERT INTO candidato VALUES (10935148, 'A', 52, 2743, 999, 99, 'LORENA ANDREA MOLINA MANSILLA', 'LORENA ANDREA MOLINA MANSILLA', '', true, 'None', 'LORENA ANDREA', 'MOLINA MANSILLA');
INSERT INTO candidato VALUES (13826563, 'A', 53, 2743, 999, 99, 'GUSTAVO DIEGO MARQUEZ CADAGAN', 'GUSTAVO DIEGO MARQUEZ CADAGAN', '', true, 'None', 'GUSTAVO DIEGO', 'MARQUEZ CADAGAN');
INSERT INTO candidato VALUES (8909418, 'A', 54, 2743, 999, 99, 'BRUNO DEL CARMEN MANSILLA PEREZ', 'BRUNO DEL CARMEN MANSILLA PEREZ', '', true, 'None', 'BRUNO DEL CARMEN', 'MANSILLA PEREZ');
INSERT INTO candidato VALUES (10004306, 'A', 50, 2744, 401, 99, 'ABEL ALBINO BECERRA VIDAL', 'ABEL ALBINO BECERRA VIDAL', '', false, 'None', 'ABEL ALBINO', 'BECERRA VIDAL');
INSERT INTO candidato VALUES (16364335, 'A', 51, 2744, 999, 99, 'MARISELA CLORINDA JIMENEZ CRUCES', 'MARISELA CLORINDA JIMENEZ CRUCES', '', true, 'None', 'MARISELA CLORINDA', 'JIMENEZ CRUCES');
INSERT INTO candidato VALUES (9988243, 'A', 52, 2744, 999, 99, 'BERNARDO ALEJANDRO LOPEZ SIERRA', 'BERNARDO ALEJANDRO LOPEZ SIERRA', '', true, 'None', 'BERNARDO ALEJANDRO', 'LOPEZ SIERRA');
INSERT INTO candidato VALUES (11657872, 'A', 53, 2792, 999, 99, 'JOVITA DIAZ AROS', 'JOVITA DIAZ AROS', '', true, 'None', 'JOVITA', 'DIAZ AROS');
INSERT INTO candidato VALUES (10942808, 'A', 50, 2745, 401, 99, 'SANTOS FIDEL SEPULVEDA AVILEZ', 'SANTOS FIDEL SEPULVEDA AVILEZ', '', false, 'None', 'SANTOS FIDEL', 'SEPULVEDA AVILEZ');
INSERT INTO candidato VALUES (15304247, 'A', 51, 2745, 400, 1, 'GONZALO CRUCES ALVAREZ', 'GONZALO CRUCES ALVAREZ', '', false, 'None', 'GONZALO', 'CRUCES ALVAREZ');
INSERT INTO candidato VALUES (14043452, 'A', 52, 2745, 999, 99, 'ARIEL KEIM HERMOSILLA', 'ARIEL KEIM HERMOSILLA', '', true, 'None', 'ARIEL', 'KEIM HERMOSILLA');
INSERT INTO candidato VALUES (7346734, 'A', 53, 2745, 999, 99, 'RICARDO ENRIQUE IBARRA VALDEBENITO', 'RICARDO ENRIQUE IBARRA VALDEBENITO', '', true, 'None', 'RICARDO ENRIQUE', 'IBARRA VALDEBENITO');
INSERT INTO candidato VALUES (10252016, 'A', 50, 2746, 401, 99, 'JESSY PAOLA VARGAS BUSTAMANTE', 'JESSY PAOLA VARGAS BUSTAMANTE', '', false, 'None', 'JESSY PAOLA', 'VARGAS BUSTAMANTE');
INSERT INTO candidato VALUES (15321273, 'A', 51, 2746, 400, 3, 'MARCELO JELVEZ CARDENAS', 'MARCELO JELVEZ CARDENAS', '', false, 'None', 'MARCELO', 'JELVEZ CARDENAS');
INSERT INTO candidato VALUES (19295749, 'A', 50, 2747, 399, 197, 'JAVIERA CALVO RIFO', 'JAVIERA CALVO RIFO', '', false, 'None', 'JAVIERA', 'CALVO RIFO');
INSERT INTO candidato VALUES (15309100, 'A', 51, 2747, 401, 99, 'VERONICA NOELIA AGUILAR MARTINEZ', 'VERONICA NOELIA AGUILAR MARTINEZ', '', false, 'None', 'VERONICA NOELIA', 'AGUILAR MARTINEZ');
INSERT INTO candidato VALUES (9188482, 'A', 52, 2747, 400, 1, 'CLAUDIO RADONICH JIMENEZ', 'CLAUDIO RADONICH JIMENEZ', '', false, 'None', 'CLAUDIO', 'RADONICH JIMENEZ');
INSERT INTO candidato VALUES (9441814, 'A', 50, 2748, 401, 5, 'FERNANDO OJEDA GONZALEZ', 'FERNANDO OJEDA GONZALEZ', '', false, 'None', 'FERNANDO', 'OJEDA GONZALEZ');
INSERT INTO candidato VALUES (15580504, 'A', 51, 2748, 400, 99, 'JAIME ARTEAGA VERA', 'JAIME ARTEAGA VERA', '', false, 'None', 'JAIME', 'ARTEAGA VERA');
INSERT INTO candidato VALUES (9433733, 'A', 52, 2748, 999, 99, 'CARLOS FAJARDO CAUÑAN', 'CARLOS FAJARDO CAUÑAN', '', true, 'None', 'CARLOS', 'FAJARDO CAUÑAN');
INSERT INTO candidato VALUES (15187040, 'A', 50, 2749, 401, 99, 'JORGE ESPINOZA VASQUEZ', 'JORGE ESPINOZA VASQUEZ', '', false, 'None', 'JORGE', 'ESPINOZA VASQUEZ');
INSERT INTO candidato VALUES (17752818, 'A', 51, 2749, 400, 3, 'SABINA BALLESTEROS VARGAS', 'SABINA BALLESTEROS VARGAS', '', false, 'None', 'SABINA', 'BALLESTEROS VARGAS');
INSERT INTO candidato VALUES (9079232, 'A', 52, 2749, 999, 99, 'TATIANA VASQUEZ BARRIENTOS', 'TATIANA VASQUEZ BARRIENTOS', '', true, 'None', 'TATIANA', 'VASQUEZ BARRIENTOS');
INSERT INTO candidato VALUES (8132737, 'A', 50, 2750, 401, 2, 'JEANNETTE ISABEL ANDRADE RUIZ', 'JEANNETTE ISABEL ANDRADE RUIZ', '', false, 'None', 'JEANNETTE ISABEL', 'ANDRADE RUIZ');
INSERT INTO candidato VALUES (16162783, 'A', 51, 2750, 400, 99, 'ALEJANDRO CARCAMO GAJARDO', 'ALEJANDRO CARCAMO GAJARDO', '', false, 'None', 'ALEJANDRO', 'CARCAMO GAJARDO');
INSERT INTO candidato VALUES (8921693, 'A', 52, 2750, 999, 99, 'MARCO AURELIO ARTEAGA VARGAS', 'MARCO AURELIO ARTEAGA VARGAS', '', true, 'None', 'MARCO AURELIO', 'ARTEAGA VARGAS');
INSERT INTO candidato VALUES (15697109, 'A', 53, 2750, 999, 99, 'CRISTIAN EDUARDO GODOY POBLETE', 'CRISTIAN EDUARDO GODOY POBLETE', '', true, 'None', 'CRISTIAN EDUARDO', 'GODOY POBLETE');
INSERT INTO candidato VALUES (13267954, 'A', 50, 2751, 401, 2, 'PATRICIO FERNANDEZ ALARCON', 'PATRICIO FERNANDEZ ALARCON', '', false, 'None', 'PATRICIO', 'FERNANDEZ ALARCON');
INSERT INTO candidato VALUES (6968241, 'A', 51, 2751, 400, 3, 'ARTURO STORAKER MOLINA', 'ARTURO STORAKER MOLINA', '', false, 'None', 'ARTURO', 'STORAKER MOLINA');
INSERT INTO candidato VALUES (14082918, 'A', 52, 2751, 999, 99, 'CARLOS ALBERTO SOTO ANGUITA', 'CARLOS ALBERTO SOTO ANGUITA', '', true, 'None', 'CARLOS ALBERTO', 'SOTO ANGUITA');
INSERT INTO candidato VALUES (17611305, 'A', 50, 2758, 432, 99, 'GASPAR MATEO ORTIZ CARDENAS', 'GASPAR MATEO ORTIZ CARDENAS', '', false, 'None', 'GASPAR', 'ORTIZ');
INSERT INTO candidato VALUES (17604080, 'A', 51, 2758, 401, 6, 'IRACI LUIZA HASSLER JACOB', 'IRACI LUIZA HASSLER JACOB', '', false, 'None', 'IRACI', 'HASSLER');
INSERT INTO candidato VALUES (16074387, 'A', 52, 2758, 418, 157, 'KAREN ELIZABETH OSORIO MUÑOZ', 'KAREN ELIZABETH OSORIO MUÑOZ', '', false, 'None', 'KAREN', 'OSORIO');
INSERT INTO candidato VALUES (9262307, 'A', 50, 2753, 401, 99, 'JOSE GABRIEL PARADA AGUILAR', 'JOSE GABRIEL PARADA AGUILAR', '', false, 'None', 'JOSE GABRIEL', 'PARADA AGUILAR');
INSERT INTO candidato VALUES (14230005, 'A', 51, 2753, 400, 1, 'CARLOS GUSTAVO SOTO MIRANDA', 'CARLOS GUSTAVO SOTO MIRANDA', '', false, 'None', 'CARLOS GUSTAVO', 'SOTO MIRANDA');
INSERT INTO candidato VALUES (17552107, 'A', 52, 2753, 999, 99, 'CRISTIAN JUVENAL ANDRADE GALLARDO', 'CRISTIAN JUVENAL ANDRADE GALLARDO', '', true, 'None', 'CRISTIAN JUVENAL', 'ANDRADE GALLARDO');
INSERT INTO candidato VALUES (17238687, 'A', 50, 2754, 401, 99, 'EDUARDO HERNANDEZ ASTUDILLO', 'EDUARDO HERNANDEZ ASTUDILLO', '', false, 'None', 'EDUARDO', 'HERNANDEZ ASTUDILLO');
INSERT INTO candidato VALUES (9347205, 'A', 51, 2754, 400, 99, 'KARINA FERNANDEZ MARIN', 'KARINA FERNANDEZ MARIN', '', false, 'None', 'KARINA', 'FERNANDEZ MARIN');
INSERT INTO candidato VALUES (15905853, 'A', 52, 2754, 999, 99, 'CARLOS HURTADO OYARZUN', 'CARLOS HURTADO OYARZUN', '', true, 'None', 'CARLOS', 'HURTADO OYARZUN');
INSERT INTO candidato VALUES (8977424, 'A', 50, 2755, 400, 99, 'LUIS BARRIA ANDRADE', 'LUIS BARRIA ANDRADE', '', false, 'None', 'LUIS', 'BARRIA ANDRADE');
INSERT INTO candidato VALUES (7497486, 'A', 51, 2755, 999, 99, 'FERNANDO RENE CALLAHAN GIDDINGS', 'FERNANDO RENE CALLAHAN GIDDINGS', '', true, 'None', 'FERNANDO RENE', 'CALLAHAN GIDDINGS');
INSERT INTO candidato VALUES (15306839, 'A', 50, 2756, 401, 2, 'MARCELO RODRIGO CONTRERAS SOTO', 'MARCELO RODRIGO CONTRERAS SOTO', '', false, 'None', 'MARCELO RODRIGO', 'CONTRERAS SOTO');
INSERT INTO candidato VALUES (8267686, 'A', 51, 2756, 439, 150, 'LIBER MAREL LAZO NAVARRO', 'LIBER MAREL LAZO NAVARRO', '', false, 'None', 'LIBER MAREL', 'LAZO NAVARRO');
INSERT INTO candidato VALUES (8724428, 'A', 52, 2756, 999, 99, 'ANA ESTER MAYORGA BAHAMONDE', 'ANA ESTER MAYORGA BAHAMONDE', '', true, 'None', 'ANA ESTER', 'MAYORGA BAHAMONDE');
INSERT INTO candidato VALUES (12016542, 'A', 53, 2756, 999, 99, 'VERONICA BEATRIZ PEREZ MAGDALENA', 'VERONICA BEATRIZ PEREZ MAGDALENA', '', true, 'None', 'VERONICA BEATRIZ', 'PEREZ MAGDALENA');
INSERT INTO candidato VALUES (18208636, 'A', 50, 2757, 401, 6, 'AMARU ERNESTO ROGEL BORQUEZ', 'AMARU ERNESTO ROGEL BORQUEZ', '', false, 'None', 'AMARU ERNESTO', 'ROGEL BORQUEZ');
INSERT INTO candidato VALUES (8421763, 'A', 51, 2757, 400, 99, 'ANAHI CARDENAS RODRIGUEZ', 'ANAHI CARDENAS RODRIGUEZ', '', false, 'None', 'ANAHI', 'CARDENAS RODRIGUEZ');
INSERT INTO candidato VALUES (15306812, 'A', 52, 2757, 999, 99, 'VICTOR HUGO MANSILLA VIDAL', 'VICTOR HUGO MANSILLA VIDAL', '', true, 'None', 'VICTOR HUGO', 'MANSILLA VIDAL');
INSERT INTO candidato VALUES (15820031, 'A', 50, 2759, 399, 99, 'NEHEL ENRIQUE MUÑOZ LAGOS', 'NEHEL ENRIQUE MUÑOZ LAGOS', '', false, 'None', 'NEHEL ENRIQUE', 'MUÑOZ LAGOS');
INSERT INTO candidato VALUES (13465510, 'A', 51, 2759, 401, 99, 'LORENA FACUSE ROJAS', 'LORENA FACUSE ROJAS', '', false, 'None', 'LORENA', 'FACUSE ROJAS');
INSERT INTO candidato VALUES (16340210, 'A', 52, 2759, 439, 150, 'LUIS MOISES CORTES IBARRA', 'LUIS MOISES CORTES IBARRA', '', false, 'None', 'LUIS MOISES', 'CORTES IBARRA');
INSERT INTO candidato VALUES (15724610, 'A', 53, 2759, 400, 1, 'ALEJANDRO ALMENDARES MULLER', 'ALEJANDRO ALMENDARES MULLER', '', false, 'None', 'ALEJANDRO', 'ALMENDARES MULLER');
INSERT INTO candidato VALUES (12643859, 'A', 54, 2759, 999, 99, 'JOHNNY YAÑEZ DIAZ', 'JOHNNY YAÑEZ DIAZ', '', true, 'None', 'JOHNNY', 'YAÑEZ DIAZ');
INSERT INTO candidato VALUES (12469362, 'A', 55, 2759, 999, 99, 'ORFILIA CASTRO TOBAR', 'ORFILIA CASTRO TOBAR', '', true, 'None', 'ORFILIA', 'CASTRO TOBAR');
INSERT INTO candidato VALUES (11838331, 'A', 53, 2758, 426, 99, 'ROSARIO DEL CARMEN CARVAJAL ARAYA', 'ROSARIO DEL CARMEN CARVAJAL ARAYA', '', false, 'None', 'ROSARIO', 'CARVAJAL');
INSERT INTO candidato VALUES (11313457, 'A', 54, 2758, 400, 1, 'MARIO DESBORDES JIMENEZ', 'MARIO DESBORDES JIMENEZ', '', false, 'None', 'MARIO', 'DESBORDES');
INSERT INTO candidato VALUES (13137862, 'A', 50, 2760, 399, 197, 'JOSE CACERES MUÑOZ', 'JOSE CACERES MUÑOZ', '', false, 'None', 'JOSE', 'CACERES MUÑOZ');
INSERT INTO candidato VALUES (11975012, 'A', 51, 2760, 401, 130, 'IRIS LILIAN MORALES OLIVARES', 'IRIS LILIAN MORALES OLIVARES', '', false, 'None', 'IRIS LILIAN', 'MORALES OLIVARES');
INSERT INTO candidato VALUES (5780658, 'A', 52, 2760, 400, 1, 'JULIETA SANTIBAÑEZ LATORRE', 'JULIETA SANTIBAÑEZ LATORRE', '', false, 'None', 'JULIETA', 'SANTIBAÑEZ LATORRE');
INSERT INTO candidato VALUES (9572750, 'A', 53, 2760, 999, 99, 'JOSE SEPULVEDA ZELADA', 'JOSE SEPULVEDA ZELADA', '', true, 'None', 'JOSE', 'SEPULVEDA ZELADA');
INSERT INTO candidato VALUES (14612628, 'A', 54, 2760, 999, 99, 'MAURO TAMAYO ROZAS', 'MAURO TAMAYO ROZAS', '', true, 'None', 'MAURO', 'TAMAYO ROZAS');
INSERT INTO candidato VALUES (13078212, 'A', 55, 2760, 999, 99, 'PILAR CAROLINA ROA ALARCON', 'PILAR CAROLINA ROA ALARCON', '', true, 'None', 'PILAR CAROLINA', 'ROA ALARCON');
INSERT INTO candidato VALUES (16371970, 'A', 50, 2761, 432, 188, 'ERICK COÑOMAN GARAY', 'ERICK COÑOMAN GARAY', '', false, 'None', 'ERICK', 'COÑOMAN GARAY');
INSERT INTO candidato VALUES (17338574, 'A', 51, 2761, 401, 6, 'GRACE ANDREA ARCOS MATURANA', 'GRACE ANDREA ARCOS MATURANA', '', false, 'None', 'GRACE ANDREA', 'ARCOS MATURANA');
INSERT INTO candidato VALUES (13883622, 'A', 52, 2761, 444, 99, 'RODRIGO CARAMORI DONOSO', 'RODRIGO CARAMORI DONOSO', '', false, 'None', 'RODRIGO', 'CARAMORI DONOSO');
INSERT INTO candidato VALUES (11550618, 'A', 53, 2761, 426, 200, 'MARIA ELENA VALENZUELA PINO', 'MARIA ELENA VALENZUELA PINO', '', false, 'None', 'MARIA ELENA', 'VALENZUELA PINO');
INSERT INTO candidato VALUES (10301787, 'A', 54, 2761, 439, 150, 'MACARENA GARCIA-HUIDOBRO LLORT', 'MACARENA GARCIA-HUIDOBRO LLORT', '', false, 'None', 'MACARENA', 'GARCIA-HUIDOBRO LLORT');
INSERT INTO candidato VALUES (13918850, 'A', 55, 2761, 999, 99, 'RENE DE LA VEGA FUENTES', 'RENE DE LA VEGA FUENTES', '', true, 'None', 'RENE', 'DE LA VEGA FUENTES');
INSERT INTO candidato VALUES (16660557, 'A', 56, 2761, 999, 99, 'RONALD OPAZO CERPA', 'RONALD OPAZO CERPA', '', true, 'None', 'RONALD', 'OPAZO CERPA');
INSERT INTO candidato VALUES (6484742, 'A', 57, 2761, 999, 99, 'RUBEN CARVACHO RIVERA', 'RUBEN CARVACHO RIVERA', '', true, 'None', 'RUBEN', 'CARVACHO RIVERA');
INSERT INTO candidato VALUES (12275654, 'A', 50, 2762, 401, 5, 'MANUEL FRANCISCO ZUÑIGA AGUILAR', 'MANUEL FRANCISCO ZUÑIGA AGUILAR', '', false, 'None', 'MANUEL FRANCISCO', 'ZUÑIGA AGUILAR');
INSERT INTO candidato VALUES (16367003, 'A', 51, 2762, 439, 150, 'FELIPE ROSS CORREA', 'FELIPE ROSS CORREA', '', false, 'None', 'FELIPE', 'ROSS CORREA');
INSERT INTO candidato VALUES (14396497, 'A', 52, 2762, 999, 99, 'SEBASTIAN VEGA UMATINO', 'SEBASTIAN VEGA UMATINO', '', true, 'None', 'SEBASTIAN', 'VEGA UMATINO');
INSERT INTO candidato VALUES (13283182, 'A', 50, 2768, 399, 99, 'FREDDY BRITO URIBE', 'FREDDY BRITO URIBE', '', false, 'None', 'FREDDY', 'BRITO URIBE');
INSERT INTO candidato VALUES (15537518, 'A', 51, 2768, 401, 2, 'EDITA ALARCON SAAVEDRA', 'EDITA ALARCON SAAVEDRA', '', false, 'None', 'EDITA', 'ALARCON SAAVEDRA');
INSERT INTO candidato VALUES (12678915, 'A', 52, 2768, 999, 99, 'SILVANA POBLETE ROMERO', 'SILVANA POBLETE ROMERO', '', true, 'None', 'SILVANA', 'POBLETE ROMERO');
INSERT INTO candidato VALUES (10379957, 'A', 53, 2768, 999, 99, 'MARCELO ORTIZ ARAVENA', 'MARCELO ORTIZ ARAVENA', '', true, 'None', 'MARCELO', 'ORTIZ ARAVENA');
INSERT INTO candidato VALUES (13835637, 'A', 54, 2768, 999, 99, 'GERMAN PINO MATURANA', 'GERMAN PINO MATURANA', '', true, 'None', 'GERMAN', 'PINO MATURANA');
INSERT INTO candidato VALUES (7747729, 'A', 55, 2768, 999, 99, 'CLAUDIO EUGENIO ARRIAGADA MACAYA', 'CLAUDIO EUGENIO ARRIAGADA MACAYA', '', true, 'None', 'CLAUDIO EUGENIO', 'ARRIAGADA MACAYA');
INSERT INTO candidato VALUES (12079467, 'A', 51, 2767, 399, 197, 'CAROL ESTER ESPINAZA ASCHIERI', 'CAROL ESTER ESPINAZA ASCHIERI', '', false, 'None', 'CAROL', 'ESPINAZA');
INSERT INTO candidato VALUES (16361186, 'A', 52, 2767, 401, 6, 'NICOLAS ALEJANDRO HURTADO ACUÑA', 'NICOLAS ALEJANDRO HURTADO ACUÑA', '', false, 'None', 'NICOLAS', 'HURTADO');
INSERT INTO candidato VALUES (10662465, 'A', 53, 2767, 426, 99, 'PAOLA ROMERO LLANOS', 'PAOLA ROMERO LLANOS', '', false, 'None', 'PAOLA', 'ROMERO');
INSERT INTO candidato VALUES (16091531, 'A', 54, 2767, 400, 99, 'DANIEL REYES MORALES', 'DANIEL REYES MORALES', '', false, 'None', 'DANIEL', 'REYES');
INSERT INTO candidato VALUES (15330578, 'A', 50, 2763, 401, 99, 'FELIPE EDUARDO MUÑOZ VALLEJOS', 'FELIPE EDUARDO MUÑOZ VALLEJOS', '', false, 'None', 'FELIPE', 'MUÑOZ');
INSERT INTO candidato VALUES (8664704, 'A', 51, 2763, 400, 3, 'IVO PAVLOVIC LAZCANO', 'IVO PAVLOVIC LAZCANO', '', false, 'None', 'IVO', 'PAVLOVIC');
INSERT INTO candidato VALUES (6696750, 'A', 52, 2763, 999, 99, 'GUILLERMO FLORES CONTRERAS', 'GUILLERMO FLORES CONTRERAS', '', true, 'None', 'GUILLERMO', 'FLORES');
INSERT INTO candidato VALUES (9035888, 'A', 53, 2763, 999, 99, 'MIGUEL ANGEL ABDO ARA', 'MIGUEL ANGEL ABDO ARA', '', true, 'None', 'MIGUEL ANGEL', 'ABDO');
INSERT INTO candidato VALUES (15837533, 'A', 51, 2764, 444, 99, 'DANIEL ALEJANDRO BUSTOS AGUAYO', 'DANIEL ALEJANDRO BUSTOS AGUAYO', '', false, 'None', 'DANIEL', 'BUSTOS');
INSERT INTO candidato VALUES (13071182, 'A', 52, 2764, 426, 200, 'JOHNY PEREZ VIDAL', 'JOHNY PEREZ VIDAL', '', false, 'None', 'JOHNY', 'PEREZ');
INSERT INTO candidato VALUES (16370245, 'A', 53, 2764, 400, 99, 'MAXIMILIANO LUKSIC LEDERER', 'MAXIMILIANO LUKSIC LEDERER', '', false, 'None', 'MAXIMILIANO', 'LUKSIC');
INSERT INTO candidato VALUES (10237625, 'A', 54, 2764, 999, 99, 'JOSE ROSSI GIACOSA', 'JOSE ROSSI GIACOSA', '', true, 'None', 'JOSE', 'ROSSI');
INSERT INTO candidato VALUES (12902355, 'A', 55, 2764, 999, 99, 'SERGIO BRAVO CAMPOS', 'SERGIO BRAVO CAMPOS', '', true, 'None', 'SERGIO', 'BRAVO');
INSERT INTO candidato VALUES (13035819, 'A', 51, 2765, 399, 99, 'MARGARITA GARRIDO ACEVEDO', 'MARGARITA GARRIDO ACEVEDO', '', false, 'None', 'MARGARITA', 'GARRIDO');
INSERT INTO candidato VALUES (10849593, 'A', 50, 2764, 401, 4, 'CAROLINA PAOLA ROJAS CHARCAS', 'CAROLINA PAOLA ROJAS CHARCAS', '', false, 'None', 'CAROLINA', 'ROJAS');
INSERT INTO candidato VALUES (7511528, 'A', 53, 2765, 426, 200, 'FRANCISCO ANTONIO BECERRA RIVAS', 'FRANCISCO ANTONIO BECERRA RIVAS', '', false, 'None', 'FRANCISCO', 'BECERRA');
INSERT INTO candidato VALUES (17706105, 'A', 52, 2765, 401, 232, 'DANIELA CONSTANZA PARADA VARGAS', 'DANIELA CONSTANZA PARADA VARGAS', '', false, 'None', 'DANIELA', 'PARADA');
INSERT INTO candidato VALUES (19081625, 'A', 54, 2765, 400, 99, 'AGUSTIN IGLESIAS MUÑOZ', 'AGUSTIN IGLESIAS MUÑOZ', '', false, 'None', 'AGUSTIN', 'IGLESIAS');
INSERT INTO candidato VALUES (16007861, 'A', 50, 2765, 432, 99, 'JENNIFER ANDREA PEREZ RIVERA', 'JENNIFER ANDREA PEREZ RIVERA', '', false, 'None', 'JENNIFER', 'PEREZ');
INSERT INTO candidato VALUES (6333296, 'A', 50, 2770, 401, 190, 'MARILEN CABRERA OLMOS', 'MARILEN CABRERA OLMOS', '', false, 'None', 'MARILEN', 'CABRERA OLMOS');
INSERT INTO candidato VALUES (20298247, 'A', 51, 2770, 426, 200, 'VALENTINA LOWICK-RUSSELL VARGAS', 'VALENTINA LOWICK-RUSSELL VARGAS', '', false, 'None', 'VALENTINA', 'LOWICK-RUSSELL VARGAS');
INSERT INTO candidato VALUES (10253802, 'A', 52, 2770, 400, 3, 'JOSE MANUEL PALACIOS PARRA', 'JOSE MANUEL PALACIOS PARRA', '', false, 'None', 'JOSE MANUEL', 'PALACIOS PARRA');
INSERT INTO candidato VALUES (13858492, 'A', 50, 2772, 399, 99, 'LORETO LETELIER BARRERA', 'LORETO LETELIER BARRERA', '', false, 'None', 'LORETO', 'LETELIER BARRERA');
INSERT INTO candidato VALUES (16648957, 'A', 51, 2772, 401, 99, 'ANDREA ARAYA SALAZAR', 'ANDREA ARAYA SALAZAR', '', false, 'None', 'ANDREA', 'ARAYA SALAZAR');
INSERT INTO candidato VALUES (7013487, 'A', 52, 2772, 439, 150, 'PEDRO ENRIQUE LEA-PLAZA EDWARDS', 'PEDRO ENRIQUE LEA-PLAZA EDWARDS', '', false, 'None', 'PEDRO ENRIQUE', 'LEA-PLAZA EDWARDS');
INSERT INTO candidato VALUES (9006894, 'A', 53, 2772, 400, 1, 'FELIPE ALESSANDRI VERGARA', 'FELIPE ALESSANDRI VERGARA', '', false, 'None', 'FELIPE', 'ALESSANDRI VERGARA');
INSERT INTO candidato VALUES (16124657, 'A', 54, 2772, 999, 99, 'CARLOS MATIAS GALLARDO BELLO', 'CARLOS MATIAS GALLARDO BELLO', '', true, 'None', 'CARLOS MATIAS', 'GALLARDO BELLO');
INSERT INTO candidato VALUES (17317663, 'A', 50, 2773, 401, 6, 'JAVIERA PAZ REYES JARA', 'JAVIERA PAZ REYES JARA', '', false, 'None', 'JAVIERA PAZ', 'REYES JARA');
INSERT INTO candidato VALUES (19033146, 'A', 51, 2773, 426, 99, 'RICARDO ANDRES ZAMBRANO ARIAS', 'RICARDO ANDRES ZAMBRANO ARIAS', '', false, 'None', 'RICARDO ANDRES', 'ZAMBRANO ARIAS');
INSERT INTO candidato VALUES (12148667, 'A', 52, 2773, 400, 99, 'INGRID RODRIGUEZ RODRIGUEZ', 'INGRID RODRIGUEZ RODRIGUEZ', '', false, 'None', 'INGRID', 'RODRIGUEZ RODRIGUEZ');
INSERT INTO candidato VALUES (7353071, 'A', 52, 2769, 426, 99, 'PABLO MALTES BISKUPOVIC', 'PABLO MALTES BISKUPOVIC', '', false, 'None', 'PABLO', 'MALTES');
INSERT INTO candidato VALUES (8967685, 'A', 53, 2769, 999, 99, 'HECTOR GARRIDO ASTUDILLO', 'HECTOR GARRIDO ASTUDILLO', '', true, 'None', 'HECTOR', 'GARRID');
INSERT INTO candidato VALUES (12276169, 'A', 54, 2769, 999, 99, 'GUILLERMO ANTONIO BENAVIDES AGUIRRE', 'GUILLERMO ANTONIO BENAVIDES AGUIRRE', '', true, 'None', 'GUILLERMO', 'BENAVIDES');
INSERT INTO candidato VALUES (15454284, 'A', 50, 2766, 401, 190, 'JOEL ANDRES OLMOS ESPINOZA', 'JOEL ANDRES OLMOS ESPINOZA', '', false, 'None', 'JOEL', 'OLMOS');
INSERT INTO candidato VALUES (12682440, 'A', 51, 2766, 400, 1, 'MARJORIE VASQUEZ ACUÑA', 'MARJORIE VASQUEZ ACUÑA', '', false, 'None', 'MARJORIE', 'VASQUEZ');
INSERT INTO candidato VALUES (10931125, 'A', 52, 2766, 999, 99, 'PATRICIO OSSANDON ORTIZ', 'PATRICIO OSSANDON ORTIZ', '', true, 'None', 'PATRICIO', 'OSSANDON');
INSERT INTO candidato VALUES (7436441, 'A', 54, 2766, 999, 99, 'SANTIAGO REBOLLEDO PIZARRO', 'SANTIAGO REBOLLEDO PIZARRO', '', true, 'None', 'SANTIAGO', 'REBOLLEDO');
INSERT INTO candidato VALUES (14186880, 'A', 53, 2766, 999, 99, 'FRANCISCO MUÑOZ MANQUE', 'FRANCISCO MUÑOZ MANQUE', '', true, 'None', 'FRANCISCO', 'MUÑOZ');
INSERT INTO candidato VALUES (10643602, 'A', 53, 2773, 999, 99, 'JOSE SILVA DIAZ', 'JOSE SILVA DIAZ', '', true, 'None', 'JOSE', 'SILVA DIAZ');
INSERT INTO candidato VALUES (7453526, 'A', 54, 2773, 999, 99, 'MIGUEL BRUNA SILVA', 'MIGUEL BRUNA SILVA', '', true, 'None', 'MIGUEL', 'BRUNA SILVA');
INSERT INTO candidato VALUES (16952200, 'A', 50, 2774, 399, 99, 'JESSICA HORMAZABAL ESPINOZA', 'JESSICA HORMAZABAL ESPINOZA', '', false, 'None', 'JESSICA', 'HORMAZABAL ESPINOZA');
INSERT INTO candidato VALUES (8667900, 'A', 51, 2774, 401, 4, 'MAXIMILIANO RIOS GALLEGUILLOS', 'MAXIMILIANO RIOS GALLEGUILLOS', '', false, 'None', 'MAXIMILIANO', 'RIOS GALLEGUILLOS');
INSERT INTO candidato VALUES (13448412, 'A', 52, 2774, 426, 99, 'JIMMY ARCE LEIVA', 'JIMMY ARCE LEIVA', '', false, 'None', 'JIMMY', 'ARCE LEIVA');
INSERT INTO candidato VALUES (13391793, 'A', 53, 2774, 999, 99, 'CESAR SANHUEZA CEA', 'CESAR SANHUEZA CEA', '', true, 'None', 'CESAR', 'SANHUEZA CEA');
INSERT INTO candidato VALUES (10581606, 'A', 54, 2776, 439, 99, 'ENRIQUE ALEJANDRO BASSALETTI RIESS', 'ENRIQUE ALEJANDRO BASSALETTI RIESS', '', false, 'None', 'ENRIQUE ALEJANDRO', 'BASSALETTI RIESS');
INSERT INTO candidato VALUES (10197539, 'A', 55, 2776, 999, 99, 'CHRISTIAN VITTORI MUÑOZ', 'CHRISTIAN VITTORI MUÑOZ', '', true, 'None', 'CHRISTIAN', 'VITTORI MUÑOZ');
INSERT INTO candidato VALUES (18622498, 'A', 50, 2778, 432, 99, 'CONSTANZA ROZAS SALGADO', 'CONSTANZA ROZAS SALGADO', '', false, 'None', 'CONSTANZA', 'ROZAS SALGADO');
INSERT INTO candidato VALUES (10613064, 'A', 51, 2778, 401, 99, 'LUIS ALBERTO ASTUDILLO PEIRETTI', 'LUIS ALBERTO ASTUDILLO PEIRETTI', '', false, 'None', 'LUIS ALBERTO', 'ASTUDILLO PEIRETTI');
INSERT INTO candidato VALUES (15340071, 'A', 52, 2778, 400, 1, 'HUMBERTO GARCIA DIAZ', 'HUMBERTO GARCIA DIAZ', '', false, 'None', 'HUMBERTO', 'GARCIA DIAZ');
INSERT INTO candidato VALUES (8045239, 'A', 53, 2778, 999, 99, 'JUAN ROZAS ROMERO', 'JUAN ROZAS ROMERO', '', true, 'None', 'JUAN', 'ROZAS ROMERO');
INSERT INTO candidato VALUES (9319799, 'A', 50, 2779, 432, 99, 'EDUARDO GIESEN AMTMANN', 'EDUARDO GIESEN AMTMANN', '', false, 'None', 'EDUARDO', 'GIESEN AMTMANN');
INSERT INTO candidato VALUES (5798597, 'A', 51, 2779, 399, 99, 'CARLOS ALARCON CASTRO', 'CARLOS ALARCON CASTRO', '', false, 'None', 'CARLOS', 'ALARCON CASTRO');
INSERT INTO candidato VALUES (16366992, 'A', 52, 2779, 401, 232, 'MIGUEL ANDRES CONCHA MANSO', 'MIGUEL ANDRES CONCHA MANSO', '', false, 'None', 'MIGUEL ANDRES', 'CONCHA MANSO');
INSERT INTO candidato VALUES (14145250, 'A', 53, 2779, 400, 1, 'CLAUDIA MORA VEGA', 'CLAUDIA MORA VEGA', '', false, 'None', 'CLAUDIA', 'MORA VEGA');
INSERT INTO candidato VALUES (16390694, 'A', 50, 2781, 401, 99, 'ITALO ANDRES BRAVO LIZANA', 'ITALO ANDRES BRAVO LIZANA', '', false, 'None', 'ITALO ANDRES', 'BRAVO LIZANA');
INSERT INTO candidato VALUES (12961075, 'A', 51, 2781, 444, 198, 'PATRICIO CISTERNAS MONREAL', 'PATRICIO CISTERNAS MONREAL', '', false, 'None', 'PATRICIO', 'CISTERNAS MONREAL');
INSERT INTO candidato VALUES (19442140, 'A', 52, 2780, 418, 157, 'DRAZEN ANDRE MARKUSOVIC CACERES', 'DRAZEN ANDRE MARKUSOVIC CACERES', '', false, 'None', 'DRAZEN', 'MARKUSOVIC');
INSERT INTO candidato VALUES (16699398, 'A', 50, 2780, 399, 197, 'DANIELA AROS TORRES', 'DANIELA AROS TORRES', '', false, 'None', 'DANIELA', 'AROS');
INSERT INTO candidato VALUES (17704129, 'A', 51, 2780, 401, 232, 'MACARENA FERNANDEZ DONOSO', 'MACARENA FERNANDEZ DONOSO', '', false, 'None', 'MACARENA', 'FERNANDEZ');
INSERT INTO candidato VALUES (13924893, 'A', 54, 2780, 400, 3, 'JAIME BELLOLIO AVARIA', 'JAIME BELLOLIO AVARIA', '', false, 'None', 'JAIME', 'BELLOLIO');
INSERT INTO candidato VALUES (16213619, 'A', 55, 2771, 999, 99, 'CATALINA SAN MARTIN CAVADA', 'CATALINA SAN MARTIN CAVADA', '', true, 'None', 'CATALINA', 'SAN MARTIN');
INSERT INTO candidato VALUES (16666357, 'A', 50, 2771, 432, 99, 'MARCELA ANDREA CUBILLOS HEVIA', 'MARCELA ANDREA CUBILLOS HEVIA', '', false, 'None', 'MARCELA', 'CUBILLOS H.');
INSERT INTO candidato VALUES (17029781, 'A', 51, 2771, 401, 232, 'CONSTANZA GABRIELA SCHONHAUT SOTO', 'CONSTANZA GABRIELA SCHONHAUT SOTO', '', false, 'None', 'CONSTANZA', 'SCHONHAUT');
INSERT INTO candidato VALUES (13924988, 'A', 52, 2771, 418, 157, 'ANGEL RODRIGO ROZAS DIAZ', 'ANGEL RODRIGO ROZAS DIAZ', '', false, 'None', 'ANGEL', 'ROZAS');
INSERT INTO candidato VALUES (11633534, 'A', 53, 2771, 426, 200, 'IGOR CONTRERAS JERIA', 'IGOR CONTRERAS JERIA', '', false, 'None', 'IGOR', 'CONTRERAS');
INSERT INTO candidato VALUES (6370431, 'A', 54, 2771, 999, 99, 'MARCELA CUBILLOS SIGALL', 'MARCELA CUBILLOS SIGALL', '', true, 'None', 'MARCELA', 'CUBILLOS S.');
INSERT INTO candidato VALUES (16049695, 'A', 52, 2781, 426, 99, 'CRISTIAN RIPOLL RIQUELME', 'CRISTIAN RIPOLL RIQUELME', '', false, 'None', 'CRISTIAN', 'RIPOLL RIQUELME');
INSERT INTO candidato VALUES (8779559, 'A', 53, 2781, 999, 99, 'GABRIEL MOISES SILBER ROMO', 'GABRIEL MOISES SILBER ROMO', '', true, 'None', 'GABRIEL MOISES', 'SILBER ROMO');
INSERT INTO candidato VALUES (5086228, 'A', 50, 2783, 399, 197, 'OSVALDO GUILLERMO MUÑOZ SANCHEZ', 'OSVALDO GUILLERMO MUÑOZ SANCHEZ', '', false, 'None', 'OSVALDO GUILLERMO', 'MUÑOZ SANCHEZ');
INSERT INTO candidato VALUES (17149819, 'A', 51, 2783, 401, 5, 'KARINA ANDREA DELFINO MUSSA', 'KARINA ANDREA DELFINO MUSSA', '', false, 'None', 'KARINA ANDREA', 'DELFINO MUSSA');
INSERT INTO candidato VALUES (8532104, 'A', 52, 2783, 426, 99, 'MANUEL MUÑOZ PALACIOS', 'MANUEL MUÑOZ PALACIOS', '', false, 'None', 'MANUEL', 'MUÑOZ PALACIOS');
INSERT INTO candidato VALUES (8344950, 'A', 53, 2783, 400, 37, 'NATALIA SILVA HERRERA', 'NATALIA SILVA HERRERA', '', false, 'None', 'NATALIA', 'SILVA HERRERA');
INSERT INTO candidato VALUES (11551480, 'A', 54, 2783, 999, 99, 'VERONICA MONTECINOS ORTIZ', 'VERONICA MONTECINOS ORTIZ', '', true, 'None', 'VERONICA', 'MONTECINOS ORTIZ');
INSERT INTO candidato VALUES (10131238, 'A', 50, 2785, 418, 157, 'PAUL FREDDY HERRERA DIAZ', 'PAUL FREDDY HERRERA DIAZ', '', false, 'None', 'PAUL FREDDY', 'HERRERA DIAZ');
INSERT INTO candidato VALUES (16126388, 'A', 51, 2785, 444, 198, 'CAMILA INES AVILES BARRAZA', 'CAMILA INES AVILES BARRAZA', '', false, 'None', 'CAMILA INES', 'AVILES BARRAZA');
INSERT INTO candidato VALUES (15375779, 'A', 52, 2785, 999, 99, 'CLAUDIO NICOLAS CASTRO SALAS', 'CLAUDIO NICOLAS CASTRO SALAS', '', true, 'None', 'CLAUDIO NICOLAS', 'CASTRO SALAS');
INSERT INTO candidato VALUES (17412667, 'A', 50, 2786, 426, 200, 'NICOL ISOLINA AGUILERA ORTIZ', 'NICOL ISOLINA AGUILERA ORTIZ', '', false, 'None', 'NICOL ISOLINA', 'AGUILERA ORTIZ');
INSERT INTO candidato VALUES (12051254, 'A', 51, 2786, 400, 99, 'MAURICIO NOVA FIGUEROA', 'MAURICIO NOVA FIGUEROA', '', false, 'None', 'MAURICIO', 'NOVA FIGUEROA');
INSERT INTO candidato VALUES (14146684, 'A', 52, 2786, 999, 99, 'CRISTOBAL AMARO LABRA BASSA', 'CRISTOBAL AMARO LABRA BASSA', '', true, 'None', 'CRISTOBAL AMARO', 'LABRA BASSA');
INSERT INTO candidato VALUES (11631921, 'A', 52, 2775, 439, 150, 'EDUARDO RENE ESPINOZA GAETE', 'EDUARDO RENE ESPINOZA GAETE', '', false, 'None', 'EDUARDO', 'ESPINOZA');
INSERT INTO candidato VALUES (16480551, 'A', 51, 2775, 401, 6, 'CAMILA LORENA DONATO PIZARRO', 'CAMILA LORENA DONATO PIZARRO', '', false, 'None', 'CAMILA', 'DONATO');
INSERT INTO candidato VALUES (14329979, 'A', 50, 2775, 399, 99, 'FRANCO FRIAS GUTIERREZ', 'FRANCO FRIAS GUTIERREZ', '', false, 'None', 'FRANCO', 'FRIAS');
INSERT INTO candidato VALUES (14339658, 'A', 50, 2776, 432, 99, 'MARCO ANTONIO SOTO BOBADILLA', 'MARCO ANTONIO SOTO BOBADILLA', '', false, 'None', 'MARCO', 'SOTO');
INSERT INTO candidato VALUES (17697418, 'A', 51, 2776, 401, 232, 'TOMAS VODANOVIC ESCUDERO', 'TOMAS VODANOVIC ESCUDERO', '', false, 'None', 'TOMAS', 'VODANOVIC');
INSERT INTO candidato VALUES (17269650, 'A', 52, 2776, 418, 157, 'YENIFER BELEN CERPA CASTRO', 'YENIFER BELEN CERPA CASTRO', '', false, 'None', 'YENIFER', 'CERPA');
INSERT INTO candidato VALUES (15128766, 'A', 53, 2776, 426, 99, 'MAXIMO QUITRAL ROJAS', 'MAXIMO QUITRAL ROJAS', '', false, 'None', 'MAXIMO', 'QUITRAL');
INSERT INTO candidato VALUES (10809043, 'A', 50, 2777, 399, 99, 'EMILIO ROMERO BERRIOS', 'EMILIO ROMERO BERRIOS', '', false, 'None', 'EMILIO', 'ROMERO');
INSERT INTO candidato VALUES (16609644, 'A', 51, 2777, 401, 232, 'EMILIA RIOS SAAVEDRA', 'EMILIA RIOS SAAVEDRA', '', false, 'None', 'EMILIA', 'RIOS');
INSERT INTO candidato VALUES (12863183, 'A', 52, 2777, 426, 99, 'JOSUE ALBERT ORMAZABAL MORALES', 'JOSUE ALBERT ORMAZABAL MORALES', '', false, 'None', 'JOSUE', 'ORMAZABAL');
INSERT INTO candidato VALUES (10273010, 'A', 53, 2777, 400, 99, 'SEBASTIAN SICHEL RAMIREZ', 'SEBASTIAN SICHEL RAMIREZ', '', false, 'None', 'SEBASTIAN', 'SICHEL');
INSERT INTO candidato VALUES (9214318, 'A', 53, 2786, 999, 99, 'SERGIO RIGOBERTO ECHEVERRIA GARCIA', 'SERGIO RIGOBERTO ECHEVERRIA GARCIA', '', true, 'None', 'SERGIO RIGOBERTO', 'ECHEVERRIA GARCIA');
INSERT INTO candidato VALUES (10794658, 'A', 50, 2787, 399, 99, 'CAROLINA ONOFRI SALINAS', 'CAROLINA ONOFRI SALINAS', '', false, 'None', 'CAROLINA', 'ONOFRI SALINAS');
INSERT INTO candidato VALUES (15369148, 'A', 51, 2787, 401, 232, 'ERIKA PAULINA MARTINEZ OSORIO', 'ERIKA PAULINA MARTINEZ OSORIO', '', false, 'None', 'ERIKA PAULINA', 'MARTINEZ OSORIO');
INSERT INTO candidato VALUES (10253488, 'A', 52, 2787, 444, 198, 'RODRIGO ISRAEL ITURRA BECERRA', 'RODRIGO ISRAEL ITURRA BECERRA', '', false, 'None', 'RODRIGO ISRAEL', 'ITURRA BECERRA');
INSERT INTO candidato VALUES (9906326, 'A', 53, 2787, 400, 3, 'CAROL BOWN SEPULVEDA', 'CAROL BOWN SEPULVEDA', '', false, 'None', 'CAROL', 'BOWN SEPULVEDA');
INSERT INTO candidato VALUES (13905081, 'A', 54, 2787, 999, 99, 'MATIAS FREIRE VALLEJOS', 'MATIAS FREIRE VALLEJOS', '', true, 'None', 'MATIAS', 'FREIRE VALLEJOS');
INSERT INTO candidato VALUES (9804250, 'A', 55, 2787, 999, 99, 'ERNESTO BALCAZAR GAMBOA', 'ERNESTO BALCAZAR GAMBOA', '', true, 'None', 'ERNESTO', 'BALCAZAR GAMBOA');
INSERT INTO candidato VALUES (10275956, 'A', 56, 2787, 999, 99, 'JOAQUIN ALBERTO CUADRA REYES', 'JOAQUIN ALBERTO CUADRA REYES', '', true, 'None', 'JOAQUIN ALBERTO', 'CUADRA REYES');
INSERT INTO candidato VALUES (13712286, 'A', 57, 2787, 999, 99, 'PATRICIA HERNANDEZ CORTES', 'PATRICIA HERNANDEZ CORTES', '', true, 'None', 'PATRICIA', 'HERNANDEZ CORTES');
INSERT INTO candidato VALUES (15661396, 'A', 50, 2788, 401, 2, 'GUSTAVO TORO QUINTANA', 'GUSTAVO TORO QUINTANA', '', false, 'None', 'GUSTAVO', 'TORO QUINTANA');
INSERT INTO candidato VALUES (15339448, 'A', 51, 2788, 400, 1, 'DAVID CABEDO ROSAS', 'DAVID CABEDO ROSAS', '', false, 'None', 'DAVID', 'CABEDO ROSAS');
INSERT INTO candidato VALUES (10722557, 'A', 52, 2788, 999, 99, 'GENARO BALLADARES SCHWANER', 'GENARO BALLADARES SCHWANER', '', true, 'None', 'GENARO', 'BALLADARES SCHWANER');
INSERT INTO candidato VALUES (14472502, 'A', 53, 2788, 999, 99, 'ROXANA RIQUELME TABACH', 'ROXANA RIQUELME TABACH', '', true, 'None', 'ROXANA', 'RIQUELME TABACH');
INSERT INTO candidato VALUES (16247595, 'A', 54, 2788, 999, 99, 'ANDRES OLGUIN GUZMAN', 'ANDRES OLGUIN GUZMAN', '', true, 'None', 'ANDRES', 'OLGUIN GUZMAN');
INSERT INTO candidato VALUES (12685109, 'A', 55, 2788, 999, 99, 'MIGUEL ANGEL GARRIDO AGUERO', 'MIGUEL ANGEL GARRIDO AGUERO', '', true, 'None', 'MIGUEL ANGEL', 'GARRIDO AGUERO');
INSERT INTO candidato VALUES (8607818, 'A', 50, 2791, 401, 99, 'JAIME ESCUDERO RAMOS', 'JAIME ESCUDERO RAMOS', '', false, 'None', 'JAIME', 'ESCUDERO RAMOS');
INSERT INTO candidato VALUES (7433076, 'A', 51, 2791, 439, 99, 'CRISTIAN BALMACEDA UNDURRAGA', 'CRISTIAN BALMACEDA UNDURRAGA', '', false, 'None', 'CRISTIAN', 'BALMACEDA UNDURRAGA');
INSERT INTO candidato VALUES (11402974, 'A', 50, 2792, 401, 7, 'ROBERTO PEREZ CATALAN', 'ROBERTO PEREZ CATALAN', '', false, 'None', 'ROBERTO', 'PEREZ CATALAN');
INSERT INTO candidato VALUES (10557636, 'A', 51, 2792, 444, 198, 'JOSUE ALEJANDRO MUÑOZ MADRIAZA', 'JOSUE ALEJANDRO MUÑOZ MADRIAZA', '', false, 'None', 'JOSUE ALEJANDRO', 'MUÑOZ MADRIAZA');
INSERT INTO candidato VALUES (16861774, 'A', 52, 2792, 400, 99, 'ALEJANDRO HORMAZABAL ARTEAGA', 'ALEJANDRO HORMAZABAL ARTEAGA', '', false, 'None', 'ALEJANDRO', 'HORMAZABAL ARTEAGA');
INSERT INTO candidato VALUES (15329993, 'A', 52, 2790, 400, 99, 'KARLA RUBILAR BARAHONA', 'KARLA RUBILAR BARAHONA', '', false, 'None', 'KARLA', 'RUBILAR');
INSERT INTO candidato VALUES (10215047, 'A', 51, 2790, 401, 5, 'LUIS ESCANILLA BENAVIDES', 'LUIS ESCANILLA BENAVIDES', '', false, 'None', 'LUIS', 'ESCANILLA');
INSERT INTO candidato VALUES (18628555, 'A', 50, 2790, 399, 197, 'ELEIN OSSANDON MANRIQUE', 'ELEIN OSSANDON MANRIQUE', '', false, 'None', 'ELEIN', 'OSSANDON');
INSERT INTO candidato VALUES (12890799, 'A', 50, 2784, 399, 99, 'ANDRES RIGOBERTO CACERES BRAVO', 'ANDRES RIGOBERTO CACERES BRAVO', '', false, 'None', 'ANDRES', 'CACERES');
INSERT INTO candidato VALUES (12245832, 'A', 51, 2784, 401, 6, 'FARES MANUEL JADUE LEIVA', 'FARES MANUEL JADUE LEIVA', '', false, 'None', 'FARES', 'JADUE');
INSERT INTO candidato VALUES (6003965, 'A', 52, 2784, 400, 3, 'MAURICIO SMOK ALLEMANDI', 'MAURICIO SMOK ALLEMANDI', '', false, 'None', 'MAURICIO', 'SMOK');
INSERT INTO candidato VALUES (16428509, 'A', 53, 2784, 999, 99, 'ALBERTO ANDRES SEGUEL MENA', 'ALBERTO ANDRES SEGUEL MENA', '', true, 'None', 'ALBERTO', 'SEGUEL');
INSERT INTO candidato VALUES (10949299, 'A', 54, 2784, 999, 99, 'MIGUEL ACOSTA VILLALON', 'MIGUEL ACOSTA VILLALON', '', true, 'None', 'MIGUEL', 'ACOSTA');
INSERT INTO candidato VALUES (13907387, 'A', 50, 2782, 401, 99, 'PAULINA REBECA BOBADILLA NAVARRETE', 'PAULINA REBECA BOBADILLA NAVARRETE', '', false, 'None', 'PAULINA', 'BOBADILLA');
INSERT INTO candidato VALUES (14128084, 'A', 51, 2782, 418, 157, 'PABLO ANDRES FUENZALIDA SALAS', 'PABLO ANDRES FUENZALIDA SALAS', '', false, 'None', 'PABLO', 'FUENZALIDA');
INSERT INTO candidato VALUES (13564527, 'A', 52, 2782, 400, 99, 'CESAR VEGA LAZO', 'CESAR VEGA LAZO', '', false, 'None', 'CESAR', 'VEGA');
INSERT INTO candidato VALUES (16653943, 'A', 53, 2782, 999, 99, 'OSCAR SALDAÑA ABARCA', 'OSCAR SALDAÑA ABARCA', '', true, 'None', 'OSCAR', 'SALDAÑA');
INSERT INTO candidato VALUES (9965040, 'A', 50, 2789, 432, 99, 'ARTURO EDGARDO FERNANDEZ DIAZ', 'ARTURO EDGARDO FERNANDEZ DIAZ', '', false, 'None', 'ARTURO', 'FERNANDEZ');
INSERT INTO candidato VALUES (10397759, 'A', 55, 2782, 999, 99, 'JUAN ELVIRO CARRASCO CONTRERAS', 'JUAN ELVIRO CARRASCO CONTRERAS', '', true, 'None', 'JUAN', 'CARRASCO');
INSERT INTO candidato VALUES (10768485, 'A', 54, 2782, 999, 99, 'PAOLA ROMERO VALDIVIA', 'PAOLA ROMERO VALDIVIA', '', true, 'None', 'PAOLA', 'ROMERO');
INSERT INTO candidato VALUES (9992086, 'A', 51, 2789, 399, 99, 'RAUL ANIBAL MEZA RODRIGUEZ', 'RAUL ANIBAL MEZA RODRIGUEZ', '', false, 'None', 'RAUL', 'MEZA');
INSERT INTO candidato VALUES (10696137, 'A', 52, 2789, 401, 137, 'JUAN CARLOS URZUA PETTINELLI', 'JUAN CARLOS URZUA PETTINELLI', '', false, 'None', 'JUAN', 'URZUA');
INSERT INTO candidato VALUES (10617441, 'A', 53, 2789, 400, 37, 'CAMILA MERINO CATALAN', 'CAMILA MERINO CATALAN', '', false, 'None', 'CAMILA', 'MERINO');
INSERT INTO candidato VALUES (9699458, 'A', 54, 2792, 999, 99, 'HECTOR LEONARDO ALVAREZ CARMONA', 'HECTOR LEONARDO ALVAREZ CARMONA', '', true, 'None', 'HECTOR LEONARDO', 'ALVAREZ CARMONA');
INSERT INTO candidato VALUES (8782092, 'A', 50, 2794, 432, 99, 'GONZALO ALBERTO REBOLLEDO RODRIGUEZ', 'GONZALO ALBERTO REBOLLEDO RODRIGUEZ', '', false, 'None', 'GONZALO ALBERTO', 'REBOLLEDO RODRIGUEZ');
INSERT INTO candidato VALUES (17231295, 'A', 51, 2794, 401, 99, 'JONATHAN OPAZO CARRASCO', 'JONATHAN OPAZO CARRASCO', '', false, 'None', 'JONATHAN', 'OPAZO CARRASCO');
INSERT INTO candidato VALUES (13243043, 'A', 52, 2794, 444, 99, 'ALEJANDRA SOLANGE NAVARRETE CARRASCO', 'ALEJANDRA SOLANGE NAVARRETE CARRASCO', '', false, 'None', 'ALEJANDRA SOLANGE', 'NAVARRETE CARRASCO');
INSERT INTO candidato VALUES (7591497, 'A', 53, 2794, 400, 99, 'MARIO OLAVARRIA RODRIGUEZ', 'MARIO OLAVARRIA RODRIGUEZ', '', false, 'None', 'MARIO', 'OLAVARRIA RODRIGUEZ');
INSERT INTO candidato VALUES (12478602, 'A', 54, 2794, 999, 99, 'FABIOLA ZAPATA PANES', 'FABIOLA ZAPATA PANES', '', true, 'None', 'FABIOLA', 'ZAPATA PANES');
INSERT INTO candidato VALUES (12506260, 'A', 55, 2794, 999, 99, 'CRISTIAN TALAMILLA LOPEZ', 'CRISTIAN TALAMILLA LOPEZ', '', true, 'None', 'CRISTIAN', 'TALAMILLA LOPEZ');
INSERT INTO candidato VALUES (4665425, 'A', 56, 2794, 999, 99, 'CARLOS ESCOBAR PAREDES', 'CARLOS ESCOBAR PAREDES', '', true, 'None', 'CARLOS', 'ESCOBAR PAREDES');
INSERT INTO candidato VALUES (13896861, 'A', 57, 2794, 999, 99, 'EVA ALARCON ALANIS', 'EVA ALARCON ALANIS', '', true, 'None', 'EVA', 'ALARCON ALANIS');
INSERT INTO candidato VALUES (8465637, 'A', 50, 2797, 432, 188, 'CARLOS ENRIQUE CARO BRISO', 'CARLOS ENRIQUE CARO BRISO', '', false, 'None', 'CARLOS ENRIQUE', 'CARO BRISO');
INSERT INTO candidato VALUES (12725279, 'A', 51, 2797, 401, 130, 'MARCELO ALVAREZ ALVAREZ', 'MARCELO ALVAREZ ALVAREZ', '', false, 'None', 'MARCELO', 'ALVAREZ ALVAREZ');
INSERT INTO candidato VALUES (13932556, 'A', 52, 2797, 426, 200, 'RODRIGO PEREZ VIDAL', 'RODRIGO PEREZ VIDAL', '', false, 'None', 'RODRIGO', 'PEREZ VIDAL');
INSERT INTO candidato VALUES (11647988, 'A', 53, 2797, 400, 3, 'MIGUEL ARAYA LOBOS', 'MIGUEL ARAYA LOBOS', '', false, 'None', 'MIGUEL', 'ARAYA LOBOS');
INSERT INTO candidato VALUES (15916948, 'A', 50, 2798, 401, 99, 'CONSTANZA RAQUEL VALENZUELA ROCUANT', 'CONSTANZA RAQUEL VALENZUELA ROCUANT', '', false, 'None', 'CONSTANZA RAQUEL', 'VALENZUELA ROCUANT');
INSERT INTO candidato VALUES (12354743, 'A', 51, 2798, 400, 3, 'HORTENSIA MORA CATALAN', 'HORTENSIA MORA CATALAN', '', false, 'None', 'HORTENSIA', 'MORA CATALAN');
INSERT INTO candidato VALUES (12259853, 'A', 52, 2798, 999, 99, 'MARCELO CEPEDA ROJAS', 'MARCELO CEPEDA ROJAS', '', true, 'None', 'MARCELO', 'CEPEDA ROJAS');
INSERT INTO candidato VALUES (7679962, 'A', 50, 2799, 401, 130, 'MARIO ANTONIO ARROS MUÑOZ', 'MARIO ANTONIO ARROS MUÑOZ', '', false, 'None', 'MARIO ANTONIO', 'ARROS MUÑOZ');
INSERT INTO candidato VALUES (6438902, 'A', 51, 2799, 426, 99, 'GUSTAVO ENRIQUE GONZALEZ ARAYA', 'GUSTAVO ENRIQUE GONZALEZ ARAYA', '', false, 'None', 'GUSTAVO ENRIQUE', 'GONZALEZ ARAYA');
INSERT INTO candidato VALUES (14196438, 'A', 52, 2799, 400, 3, 'RODRIGO CONTRERAS GUTIERREZ', 'RODRIGO CONTRERAS GUTIERREZ', '', false, 'None', 'RODRIGO', 'CONTRERAS GUTIERREZ');
INSERT INTO candidato VALUES (12134562, 'A', 53, 2799, 999, 99, 'RAMON SANDOVAL ZURITA', 'RAMON SANDOVAL ZURITA', '', true, 'None', 'RAMON', 'SANDOVAL ZURITA');
INSERT INTO candidato VALUES (12164228, 'A', 50, 2800, 399, 99, 'JUAN AGUSTIN PINTO MARTINEZ', 'JUAN AGUSTIN PINTO MARTINEZ', '', false, 'None', 'JUAN AGUSTIN', 'PINTO MARTINEZ');
INSERT INTO candidato VALUES (17682380, 'A', 51, 2800, 401, 232, 'LORENA CATALINA OLAVARRIA BAEZA', 'LORENA CATALINA OLAVARRIA BAEZA', '', false, 'None', 'LORENA CATALINA', 'OLAVARRIA BAEZA');
INSERT INTO candidato VALUES (13560068, 'A', 52, 2800, 418, 157, 'EDUARDO ANTONIO CONTRERAS PEREZ', 'EDUARDO ANTONIO CONTRERAS PEREZ', '', false, 'None', 'EDUARDO ANTONIO', 'CONTRERAS PEREZ');
INSERT INTO candidato VALUES (14491741, 'A', 53, 2800, 444, 99, 'LALO CATALAN HERRADA', 'LALO CATALAN HERRADA', '', false, 'None', 'LALO', 'CATALAN HERRADA');
INSERT INTO candidato VALUES (13961316, 'A', 54, 2800, 426, 200, 'SERGIO MILLALEN HIMILAF', 'SERGIO MILLALEN HIMILAF', '', false, 'None', 'SERGIO', 'MILLALEN HIMILAF');
INSERT INTO candidato VALUES (12798871, 'A', 55, 2800, 400, 3, 'PAULA GARATE ROJAS', 'PAULA GARATE ROJAS', '', false, 'None', 'PAULA', 'GARATE ROJAS');
INSERT INTO candidato VALUES (15404463, 'A', 56, 2800, 999, 99, 'DANIEL DOMINGUEZ GONZALEZ', 'DANIEL DOMINGUEZ GONZALEZ', '', true, 'None', 'DANIEL', 'DOMINGUEZ GONZALEZ');
INSERT INTO candidato VALUES (13370187, 'A', 50, 2801, 401, 99, 'MARCELA CHAMORRO MACIAS', 'MARCELA CHAMORRO MACIAS', '', false, 'None', 'MARCELA', 'CHAMORRO MACIAS');
INSERT INTO candidato VALUES (14127515, 'A', 51, 2801, 439, 150, 'ANDREA ELIZABETH GALVEZ SEPULVEDA', 'ANDREA ELIZABETH GALVEZ SEPULVEDA', '', false, 'None', 'ANDREA ELIZABETH', 'GALVEZ SEPULVEDA');
INSERT INTO candidato VALUES (13692673, 'A', 52, 2801, 400, 99, 'PATRICIO BASTIAS GONZALEZ', 'PATRICIO BASTIAS GONZALEZ', '', false, 'None', 'PATRICIO', 'BASTIAS GONZALEZ');
INSERT INTO candidato VALUES (19063641, 'A', 53, 2801, 999, 99, 'JOSE ANDRES ARELLANO BLANCO', 'JOSE ANDRES ARELLANO BLANCO', '', true, 'None', 'JOSE ANDRES', 'ARELLANO BLANCO');
INSERT INTO candidato VALUES (7992641, 'A', 50, 2802, 401, 6, 'ARIADNE PATRICIA CONTE CHASSIN-TRUBERT', 'ARIADNE PATRICIA CONTE CHASSIN-TRUBERT', '', false, 'None', 'ARIADNE PATRICIA', 'CONTE CHASSIN-TRUBERT');
INSERT INTO candidato VALUES (7553714, 'A', 51, 2802, 439, 150, 'BLANCA ROSA CONCHA MARAMBIO', 'BLANCA ROSA CONCHA MARAMBIO', '', false, 'None', 'BLANCA ROSA', 'CONCHA MARAMBIO');
INSERT INTO candidato VALUES (13458410, 'A', 52, 2802, 400, 99, 'KATHERINE DE LA VEGA FUENTES', 'KATHERINE DE LA VEGA FUENTES', '', false, 'None', 'KATHERINE', 'DE LA VEGA FUENTES');
INSERT INTO candidato VALUES (10527830, 'A', 53, 2802, 999, 99, 'YOVANNA FUENTES PINO', 'YOVANNA FUENTES PINO', '', true, 'None', 'YOVANNA', 'FUENTES PINO');
INSERT INTO candidato VALUES (5695737, 'A', 54, 2802, 999, 99, 'MARIA TERESA CAGALJ KRALJ', 'MARIA TERESA CAGALJ KRALJ', '', true, 'None', 'MARIA TERESA', 'CAGALJ KRALJ');
INSERT INTO candidato VALUES (10159044, 'A', 55, 2802, 999, 99, 'LUIS HUMBERTO ALEJANDRO CAAMAÑO AREVALO', 'LUIS HUMBERTO ALEJANDRO CAAMAÑO AREVALO', '', true, 'None', 'LUIS HUMBERTO ALEJANDRO', 'CAAMAÑO AREVALO');
INSERT INTO candidato VALUES (9747528, 'A', 51, 2795, 439, 99, 'CESAR EUGENIO MENA RETAMAL', 'CESAR EUGENIO MENA RETAMAL', '', false, 'None', 'CESAR', 'MENA');
INSERT INTO candidato VALUES (13883301, 'A', 52, 2795, 999, 99, 'CRISTOBAL SANCHEZ CARVALLO', 'CRISTOBAL SANCHEZ CARVALLO', '', true, 'None', 'CRISTOBAL', 'SANCHEZ');
INSERT INTO candidato VALUES (17700252, 'A', 53, 2795, 999, 99, 'VALENTINA DOMINGUEZ SAAVEDRA', 'VALENTINA DOMINGUEZ SAAVEDRA', '', true, 'None', 'VALENTINA', 'DOMINGUEZ');
INSERT INTO candidato VALUES (11261988, 'A', 54, 2795, 999, 99, 'SERGIO TAPIA SANDOVAL', 'SERGIO TAPIA SANDOVAL', '', true, 'None', 'SERGIO', 'TAPIA');
INSERT INTO candidato VALUES (17176403, 'A', 50, 2796, 399, 99, 'CHRISTOPHER EDWIN ESPINOZA OLIVER', 'CHRISTOPHER EDWIN ESPINOZA OLIVER', '', false, 'None', 'CHRISTOPHER', 'ESPINOZA');
INSERT INTO candidato VALUES (15400920, 'A', 51, 2796, 401, 5, 'CHRISTOPHER ANTONIO WHITE BAHAMONDES', 'CHRISTOPHER ANTONIO WHITE BAHAMONDES', '', false, 'None', 'CHRISTOPHER', 'WHITE');
INSERT INTO candidato VALUES (12090358, 'A', 52, 2796, 418, 157, 'VICTOR GALVARINO MOL ALCANTARA', 'VICTOR GALVARINO MOL ALCANTARA', '', false, 'None', 'VICTOR', 'MOL');
INSERT INTO candidato VALUES (12670694, 'A', 53, 2796, 439, 99, 'CHRISTIAN WALTER GOMEZ DIAZ', 'CHRISTIAN WALTER GOMEZ DIAZ', '', false, 'None', 'CHRISTIAN', 'GOMEZ');
INSERT INTO candidato VALUES (12043065, 'A', 54, 2796, 999, 99, 'LEONEL CADIZ SOTO', 'LEONEL CADIZ SOTO', '', true, 'None', 'LEONEL', 'CADIZ');
INSERT INTO candidato VALUES (13450797, 'A', 55, 2796, 999, 99, 'CHRISTIAN PINO LOPEZ', 'CHRISTIAN PINO LOPEZ', '', true, 'None', 'CHRISTIAN', 'PINO');
INSERT INTO candidato VALUES (14118425, 'A', 52, 2793, 400, 3, 'ISABEL VALENZUELA AHUMADA', 'ISABEL VALENZUELA AHUMADA', '', false, 'None', 'ISABEL', 'VALENZUELA');
INSERT INTO candidato VALUES (15565459, 'A', 51, 2793, 418, 99, 'LUIS FRANCISCO SALINAS SEGURA', 'LUIS FRANCISCO SALINAS SEGURA', '', false, 'None', 'LUIS', 'SALINAS');
INSERT INTO candidato VALUES (13672529, 'A', 50, 2793, 401, 232, 'NICOLAS RAUL PAVEZ CUEVAS', 'NICOLAS RAUL PAVEZ CUEVAS', '', false, 'None', 'NICOLAS', 'PAVEZ');
INSERT INTO candidato VALUES (13047374, 'A', 56, 2802, 999, 99, 'CHRISTIAN HERNANDEZ VILLANUEVA', 'CHRISTIAN HERNANDEZ VILLANUEVA', '', true, 'None', 'CHRISTIAN', 'HERNANDEZ VILLANUEVA');
INSERT INTO candidato VALUES (16666407, 'A', 57, 2802, 999, 99, 'SUSANA CORDOVA GONZALEZ', 'SUSANA CORDOVA GONZALEZ', '', true, 'None', 'SUSANA', 'CORDOVA GONZALEZ');
INSERT INTO candidato VALUES (17678967, 'A', 50, 2803, 401, 99, 'MARIA CAROLINA JIMENEZ ALVAREZ', 'MARIA CAROLINA JIMENEZ ALVAREZ', '', false, 'None', 'MARIA CAROLINA', 'JIMENEZ ALVAREZ');
INSERT INTO candidato VALUES (7472016, 'A', 51, 2803, 400, 1, 'JESSICA MUALIM FAJURI', 'JESSICA MUALIM FAJURI', '', false, 'None', 'JESSICA', 'MUALIM FAJURI');
INSERT INTO candidato VALUES (12020344, 'A', 50, 2804, 401, 99, 'EMILIO MARCELO CERDA SAGURIE', 'EMILIO MARCELO CERDA SAGURIE', '', false, 'None', 'EMILIO MARCELO', 'CERDA SAGURIE');
INSERT INTO candidato VALUES (11364173, 'A', 51, 2804, 400, 99, 'MANUEL DEVIA VILCHES', 'MANUEL DEVIA VILCHES', '', false, 'None', 'MANUEL', 'DEVIA VILCHES');
INSERT INTO candidato VALUES (20311989, 'A', 52, 2804, 999, 99, 'FELIPE IGNACIO ANTONIO YAÑEZ FIGUEROA', 'FELIPE IGNACIO ANTONIO YAÑEZ FIGUEROA', '', true, 'None', 'FELIPE IGNACIO ANTONIO', 'YAÑEZ FIGUEROA');
INSERT INTO candidato VALUES (14238675, 'A', 53, 2804, 999, 99, 'MARCIA QUIROZ MALLEA', 'MARCIA QUIROZ MALLEA', '', true, 'None', 'MARCIA', 'QUIROZ MALLEA');
INSERT INTO candidato VALUES (6671006, 'A', 54, 2804, 999, 99, 'FLORENTINO FLORES ARMIJO', 'FLORENTINO FLORES ARMIJO', '', true, 'None', 'FLORENTINO', 'FLORES ARMIJO');
INSERT INTO candidato VALUES (15778313, 'A', 50, 2805, 401, 99, 'SEBASTIAN ENRIQUE ROSAS GUERRERO', 'SEBASTIAN ENRIQUE ROSAS GUERRERO', '', false, 'None', 'SEBASTIAN ENRIQUE', 'ROSAS GUERRERO');
INSERT INTO candidato VALUES (11895761, 'A', 51, 2805, 439, 150, 'ANNEMARIE IRENE MULLER DURING', 'ANNEMARIE IRENE MULLER DURING', '', false, 'None', 'ANNEMARIE IRENE', 'MULLER DURING');
INSERT INTO candidato VALUES (11231486, 'A', 52, 2805, 999, 99, 'LUIS REYES VILLAVICENCIO', 'LUIS REYES VILLAVICENCIO', '', true, 'None', 'LUIS', 'REYES VILLAVICENCIO');
INSERT INTO candidato VALUES (14321305, 'A', 50, 2806, 401, 99, 'ZANDRA SOFIA MAULEN JOFRE', 'ZANDRA SOFIA MAULEN JOFRE', '', false, 'None', 'ZANDRA SOFIA', 'MAULEN JOFRE');
INSERT INTO candidato VALUES (12270259, 'A', 51, 2806, 439, 99, 'XIMENA VARELA ZUÑIGA', 'XIMENA VARELA ZUÑIGA', '', false, 'None', 'XIMENA', 'VARELA ZUÑIGA');
INSERT INTO candidato VALUES (13904537, 'A', 52, 2806, 999, 99, 'SEBASTIAN CHACON SOTO', 'SEBASTIAN CHACON SOTO', '', true, 'None', 'SEBASTIAN', 'CHACON SOTO');
INSERT INTO candidato VALUES (9106540, 'A', 53, 2806, 999, 99, 'JORGE ESPINOZA CUEVAS', 'JORGE ESPINOZA CUEVAS', '', true, 'None', 'JORGE', 'ESPINOZA CUEVAS');
INSERT INTO candidato VALUES (9687401, 'A', 54, 2806, 999, 99, 'JUAN PABLO GOMEZ RAMIREZ', 'JUAN PABLO GOMEZ RAMIREZ', '', true, 'None', 'JUAN PABLO', 'GOMEZ RAMIREZ');
INSERT INTO candidato VALUES (14343436, 'A', 55, 2806, 999, 99, 'ROSSANA SANHUEZA MUÑOZ', 'ROSSANA SANHUEZA MUÑOZ', '', true, 'None', 'ROSSANA', 'SANHUEZA MUÑOZ');
INSERT INTO candidato VALUES (14476154, 'A', 56, 2806, 999, 99, 'FRANCISCO VALDES REYES', 'FRANCISCO VALDES REYES', '', true, 'None', 'FRANCISCO', 'VALDES REYES');
INSERT INTO candidato VALUES (10397539, 'A', 57, 2806, 999, 99, 'SANDRA CECILIA LOPEZ SALAZAR', 'SANDRA CECILIA LOPEZ SALAZAR', '', true, 'None', 'SANDRA CECILIA', 'LOPEZ SALAZAR');
INSERT INTO candidato VALUES (14240481, 'A', 58, 2806, 999, 99, 'ANDREA CESPEDES POBLETE', 'ANDREA CESPEDES POBLETE', '', true, 'None', 'ANDREA', 'CESPEDES POBLETE');
INSERT INTO candidato VALUES (14472322, 'A', 50, 2807, 401, 99, 'CARLOS FRANCISCO ADASME GODOY', 'CARLOS FRANCISCO ADASME GODOY', '', false, 'None', 'CARLOS FRANCISCO', 'ADASME GODOY');
INSERT INTO candidato VALUES (16016894, 'A', 51, 2807, 400, 99, 'JUAN PABLO OLAVE CAMBARA', 'JUAN PABLO OLAVE CAMBARA', '', false, 'None', 'JUAN PABLO', 'OLAVE CAMBARA');
INSERT INTO candidato VALUES (15930807, 'A', 50, 2808, 401, 5, 'FELIPE MUÑOZ HEREDIA', 'FELIPE MUÑOZ HEREDIA', '', false, 'None', 'FELIPE', 'MUÑOZ HEREDIA');
INSERT INTO candidato VALUES (10500387, 'A', 51, 2808, 400, 1, 'JOSE MIGUEL ARELLANO MERINO', 'JOSE MIGUEL ARELLANO MERINO', '', false, 'None', 'JOSE MIGUEL', 'ARELLANO MERINO');
INSERT INTO candidato VALUES (14121272, 'A', 52, 2808, 999, 99, 'PATRICIO MUÑOZ VEGAS', 'PATRICIO MUÑOZ VEGAS', '', true, 'None', 'PATRICIO', 'MUÑOZ VEGAS');
INSERT INTO candidato VALUES (10921989, 'A', 50, 2809, 401, 2, 'NIBALDO MEZA GARFIA', 'NIBALDO MEZA GARFIA', '', false, 'None', 'NIBALDO', 'MEZA GARFIA');
INSERT INTO candidato VALUES (9402368, 'A', 51, 2809, 400, 3, 'RODRIGO CORNEJO INOSTROZA', 'RODRIGO CORNEJO INOSTROZA', '', false, 'None', 'RODRIGO', 'CORNEJO INOSTROZA');
INSERT INTO candidato VALUES (6273717, 'A', 52, 2809, 999, 99, 'MANUEL SEGUNDO FUENTES ROSALES', 'MANUEL SEGUNDO FUENTES ROSALES', '', true, 'None', 'MANUEL SEGUNDO', 'FUENTES ROSALES');
INSERT INTO candidato VALUES (15419180, 'A', 53, 2809, 999, 99, 'DIEGO SAN MARTIN VELASCO', 'DIEGO SAN MARTIN VELASCO', '', true, 'None', 'DIEGO', 'SAN MARTIN VELASCO');
INSERT INTO candidato VALUES (12313928, 'A', 54, 2809, 999, 99, 'CLAUDIA ARANGUIZ VIELMA', 'CLAUDIA ARANGUIZ VIELMA', '', true, 'None', 'CLAUDIA', 'ARANGUIZ VIELMA');
INSERT INTO candidato VALUES (9936533, 'A', 55, 2809, 999, 99, 'EMMA PATRICIA MORALES ARZOLA', 'EMMA PATRICIA MORALES ARZOLA', '', true, 'None', 'EMMA PATRICIA', 'MORALES ARZOLA');
INSERT INTO candidato VALUES (18887754, 'A', 50, 2810, 399, 197, 'JOSE IGNACIO BUSTOS MUÑOZ', 'JOSE IGNACIO BUSTOS MUÑOZ', '', false, 'None', 'JOSE IGNACIO', 'BUSTOS MUÑOZ');
INSERT INTO candidato VALUES (16564215, 'A', 51, 2810, 401, 232, 'CARLA ANDREA AMTMANN FECCI', 'CARLA ANDREA AMTMANN FECCI', '', false, 'None', 'CARLA ANDREA', 'AMTMANN FECCI');
INSERT INTO candidato VALUES (8266414, 'A', 52, 2810, 444, 191, 'JORGE EDUARDO VIVES DIBARRART', 'JORGE EDUARDO VIVES DIBARRART', '', false, 'None', 'JORGE EDUARDO', 'VIVES DIBARRART');
INSERT INTO candidato VALUES (16564240, 'A', 53, 2810, 439, 150, 'LEANDRO JORGE KUNSTMANN COLLADO', 'LEANDRO JORGE KUNSTMANN COLLADO', '', false, 'None', 'LEANDRO JORGE', 'KUNSTMANN COLLADO');
INSERT INTO candidato VALUES (10106529, 'A', 54, 2810, 400, 1, 'EDUARDO BERGER SILVA', 'EDUARDO BERGER SILVA', '', false, 'None', 'EDUARDO', 'BERGER SILVA');
INSERT INTO candidato VALUES (10869184, 'A', 50, 2811, 401, 4, 'JUAN NOLBERTO VALENZUELA GONZALEZ', 'JUAN NOLBERTO VALENZUELA GONZALEZ', '', false, 'None', 'JUAN NOLBERTO', 'VALENZUELA GONZALEZ');
INSERT INTO candidato VALUES (16463968, 'A', 51, 2811, 400, 1, 'CLAUDIO GONZALEZ NAVARRO', 'CLAUDIO GONZALEZ NAVARRO', '', false, 'None', 'CLAUDIO', 'GONZALEZ NAVARRO');
INSERT INTO candidato VALUES (6531905, 'A', 52, 2811, 999, 99, 'GASTON HERMOGENES PEREZ GONZALEZ', 'GASTON HERMOGENES PEREZ GONZALEZ', '', true, 'None', 'GASTON HERMOGENES', 'PEREZ GONZALEZ');
INSERT INTO candidato VALUES (5560964, 'A', 53, 2811, 999, 99, 'MIGUEL ENRIQUE HERNANDEZ MELLA', 'MIGUEL ENRIQUE HERNANDEZ MELLA', '', true, 'None', 'MIGUEL ENRIQUE', 'HERNANDEZ MELLA');
INSERT INTO candidato VALUES (10906147, 'A', 50, 2812, 401, 5, 'JUAN ROCHA AGUILERA', 'JUAN ROCHA AGUILERA', '', false, 'None', 'JUAN', 'ROCHA AGUILERA');
INSERT INTO candidato VALUES (14402401, 'A', 51, 2812, 400, 1, 'EDUARDO URIBE CAMPOS', 'EDUARDO URIBE CAMPOS', '', false, 'None', 'EDUARDO', 'URIBE CAMPOS');
INSERT INTO candidato VALUES (11919784, 'A', 52, 2812, 999, 99, 'MARCELA OLIVERA MONTERO', 'MARCELA OLIVERA MONTERO', '', true, 'None', 'MARCELA', 'OLIVERA MONTERO');
INSERT INTO candidato VALUES (17763089, 'A', 50, 2813, 401, 6, 'ALDO EMILIO RETAMAL ARRIAGADA', 'ALDO EMILIO RETAMAL ARRIAGADA', '', false, 'None', 'ALDO EMILIO', 'RETAMAL ARRIAGADA');
INSERT INTO candidato VALUES (12328031, 'A', 51, 2813, 400, 99, 'VICTOR FRITZ AGUAYO', 'VICTOR FRITZ AGUAYO', '', false, 'None', 'VICTOR', 'FRITZ AGUAYO');
INSERT INTO candidato VALUES (15530888, 'A', 52, 2813, 999, 99, 'JAVIER IGNACIO SANTIBAÑEZ BAEZ', 'JAVIER IGNACIO SANTIBAÑEZ BAEZ', '', true, 'None', 'JAVIER IGNACIO', 'SANTIBAÑEZ BAEZ');
INSERT INTO candidato VALUES (16528177, 'A', 50, 2814, 401, 5, 'EDUARDO ACUÑA ACUÑA', 'EDUARDO ACUÑA ACUÑA', '', false, 'None', 'EDUARDO', 'ACUÑA ACUÑA');
INSERT INTO candidato VALUES (11424410, 'A', 51, 2814, 400, 1, 'SANDRA INES BASTIAS BILBAO', 'SANDRA INES BASTIAS BILBAO', '', false, 'None', 'SANDRA INES', 'BASTIAS BILBAO');
INSERT INTO candidato VALUES (14081941, 'A', 52, 2814, 999, 99, 'ANDRES LARA MARTINEZ', 'ANDRES LARA MARTINEZ', '', true, 'None', 'ANDRES', 'LARA MARTINEZ');
INSERT INTO candidato VALUES (16048857, 'A', 53, 2814, 999, 99, 'GUILLERMO SOTO ORTEGA', 'GUILLERMO SOTO ORTEGA', '', true, 'None', 'GUILLERMO', 'SOTO ORTEGA');
INSERT INTO candidato VALUES (12926335, 'A', 54, 2814, 999, 99, 'LEONARDO MUÑOZ VALLEJOS', 'LEONARDO MUÑOZ VALLEJOS', '', true, 'None', 'LEONARDO', 'MUÑOZ VALLEJOS');
INSERT INTO candidato VALUES (12336167, 'A', 50, 2815, 401, 99, 'PAMELA DORNEMANN ROJAS', 'PAMELA DORNEMANN ROJAS', '', false, 'None', 'PAMELA', 'DORNEMANN ROJAS');
INSERT INTO candidato VALUES (5916172, 'A', 51, 2815, 400, 99, 'GUILLERMO ROLANDO MITRE GATICA', 'GUILLERMO ROLANDO MITRE GATICA', '', false, 'None', 'GUILLERMO ROLANDO', 'MITRE GATICA');
INSERT INTO candidato VALUES (15530547, 'A', 50, 2816, 401, 99, 'CRISTIAN NAVARRETE QUEZADA', 'CRISTIAN NAVARRETE QUEZADA', '', false, 'None', 'CRISTIAN', 'NAVARRETE QUEZADA');
INSERT INTO candidato VALUES (8601658, 'A', 51, 2816, 400, 37, 'RODRIGO CORTES OYARZUN', 'RODRIGO CORTES OYARZUN', '', false, 'None', 'RODRIGO', 'CORTES OYARZUN');
INSERT INTO candidato VALUES (14369618, 'A', 52, 2816, 999, 99, 'MIGUEL ANGEL CARRASCO GARCIA', 'MIGUEL ANGEL CARRASCO GARCIA', '', true, 'None', 'MIGUEL ANGEL', 'CARRASCO GARCIA');
INSERT INTO candidato VALUES (8367549, 'A', 50, 2817, 401, 5, 'RODRIGO VALDIVIA ORIAS', 'RODRIGO VALDIVIA ORIAS', '', false, 'None', 'RODRIGO', 'VALDIVIA ORIAS');
INSERT INTO candidato VALUES (14224776, 'A', 51, 2817, 400, 99, 'DAVID RUIZ CIFUENTES', 'DAVID RUIZ CIFUENTES', '', false, 'None', 'DAVID', 'RUIZ CIFUENTES');
INSERT INTO candidato VALUES (12338608, 'A', 52, 2817, 999, 99, 'PEDRO BURGOS VASQUEZ', 'PEDRO BURGOS VASQUEZ', '', true, 'None', 'PEDRO', 'BURGOS VASQUEZ');
INSERT INTO candidato VALUES (12200063, 'A', 53, 2817, 999, 99, 'ELIAS SABAT ACLEH', 'ELIAS SABAT ACLEH', '', true, 'None', 'ELIAS', 'SABAT ACLEH');
INSERT INTO candidato VALUES (10124516, 'A', 54, 2817, 999, 99, 'PABLO SANDOVAL JARA', 'PABLO SANDOVAL JARA', '', true, 'None', 'PABLO', 'SANDOVAL JARA');
INSERT INTO candidato VALUES (8810114, 'A', 50, 2818, 401, 5, 'JUAN ANDRES REINOSO CARRILLO', 'JUAN ANDRES REINOSO CARRILLO', '', false, 'None', 'JUAN ANDRES', 'REINOSO CARRILLO');
INSERT INTO candidato VALUES (10219549, 'A', 51, 2818, 418, 157, 'MARIA SONIA AGUILEF GALLEGOS', 'MARIA SONIA AGUILEF GALLEGOS', '', false, 'None', 'MARIA SONIA', 'AGUILEF GALLEGOS');
INSERT INTO candidato VALUES (9379595, 'A', 52, 2818, 400, 1, 'ELIANA ELENA AZOCAR SILVA', 'ELIANA ELENA AZOCAR SILVA', '', false, 'None', 'ELIANA ELENA', 'AZOCAR SILVA');
INSERT INTO candidato VALUES (8987883, 'A', 53, 2818, 999, 99, 'SATURNINO CASIMIRO QUEZADA SOLIS', 'SATURNINO CASIMIRO QUEZADA SOLIS', '', true, 'None', 'SATURNINO CASIMIRO', 'QUEZADA SOLIS');
INSERT INTO candidato VALUES (8074172, 'A', 54, 2818, 999, 99, 'ALDO PINUER SOLIS', 'ALDO PINUER SOLIS', '', true, 'None', 'ALDO', 'PINUER SOLIS');
INSERT INTO candidato VALUES (17606436, 'A', 55, 2818, 999, 99, 'MATIAS VELASQUEZ FLORES', 'MATIAS VELASQUEZ FLORES', '', true, 'None', 'MATIAS', 'VELASQUEZ FLORES');
INSERT INTO candidato VALUES (17219196, 'A', 56, 2818, 999, 99, 'CAMILO GOMEZ GOMEZ', 'CAMILO GOMEZ GOMEZ', '', true, 'None', 'CAMILO', 'GOMEZ GOMEZ');
INSERT INTO candidato VALUES (9376636, 'A', 57, 2818, 999, 99, 'HERTY BAEZ HERNANDEZ', 'HERTY BAEZ HERNANDEZ', '', true, 'None', 'HERTY', 'BAEZ HERNANDEZ');
INSERT INTO candidato VALUES (11268655, 'A', 50, 2819, 401, 4, 'FERNANDO JAVIER FLANDEZ MONTECINOS', 'FERNANDO JAVIER FLANDEZ MONTECINOS', '', false, 'None', 'FERNANDO JAVIER', 'FLANDEZ MONTECINOS');
INSERT INTO candidato VALUES (12390652, 'A', 51, 2819, 400, 3, 'LEONILA SAEZ ALARCON', 'LEONILA SAEZ ALARCON', '', false, 'None', 'LEONILA', 'SAEZ ALARCON');
INSERT INTO candidato VALUES (17916563, 'A', 50, 2820, 401, 6, 'CATHERINE DANITZA ESCARATE FUENTES', 'CATHERINE DANITZA ESCARATE FUENTES', '', false, 'None', 'CATHERINE DANITZA', 'ESCARATE FUENTES');
INSERT INTO candidato VALUES (13588810, 'A', 51, 2820, 400, 1, 'MIGUEL ANGEL MEZA SHWENKE', 'MIGUEL ANGEL MEZA SHWENKE', '', false, 'None', 'MIGUEL ANGEL', 'MEZA SHWENKE');
INSERT INTO candidato VALUES (11541951, 'A', 50, 2821, 399, 99, 'GERARDO ABRAHAM JARAMILLO ASENCIO', 'GERARDO ABRAHAM JARAMILLO ASENCIO', '', false, 'None', 'GERARDO ABRAHAM', 'JARAMILLO ASENCIO');
INSERT INTO candidato VALUES (12750493, 'A', 51, 2821, 401, 2, 'JAVIER ROSAS BOBADILLA', 'JAVIER ROSAS BOBADILLA', '', false, 'None', 'JAVIER', 'ROSAS BOBADILLA');
INSERT INTO candidato VALUES (8818022, 'A', 52, 2821, 400, 99, 'LUIS REYES ALVAREZ', 'LUIS REYES ALVAREZ', '', false, 'None', 'LUIS', 'REYES ALVAREZ');
INSERT INTO candidato VALUES (16872045, 'A', 53, 2821, 999, 99, 'CAROLINA ANDREA SILVA PEREZ', 'CAROLINA ANDREA SILVA PEREZ', '', true, 'None', 'CAROLINA ANDREA', 'SILVA PEREZ');
INSERT INTO candidato VALUES (18026034, 'A', 50, 2822, 399, 99, 'SEBASTIAN ARELLANO PESCETTO', 'SEBASTIAN ARELLANO PESCETTO', '', false, 'None', 'SEBASTIAN', 'ARELLANO PESCETTO');
INSERT INTO candidato VALUES (13452061, 'A', 51, 2822, 401, 137, 'GERARDO ESPINDOLA ROJAS', 'GERARDO ESPINDOLA ROJAS', '', false, 'None', 'GERARDO', 'ESPINDOLA ROJAS');
INSERT INTO candidato VALUES (9314005, 'A', 52, 2822, 418, 157, 'RAYKO ALEJANDRO KARMELIC PAVLOV', 'RAYKO ALEJANDRO KARMELIC PAVLOV', '', false, 'None', 'RAYKO ALEJANDRO', 'KARMELIC PAVLOV');
INSERT INTO candidato VALUES (15948142, 'A', 53, 2822, 439, 150, 'STEPHANIE JELDREZ ORTIZ', 'STEPHANIE JELDREZ ORTIZ', '', false, 'None', 'STEPHANIE', 'JELDREZ ORTIZ');
INSERT INTO candidato VALUES (7024697, 'A', 54, 2822, 400, 3, 'RAUL GIL GONZALEZ', 'RAUL GIL GONZALEZ', '', false, 'None', 'RAUL', 'GIL GONZALEZ');
INSERT INTO candidato VALUES (5906318, 'A', 55, 2822, 999, 99, 'ORLANDO SEVERO VARGAS PIZARRO', 'ORLANDO SEVERO VARGAS PIZARRO', '', true, 'None', 'ORLANDO SEVERO', 'VARGAS PIZARRO');
INSERT INTO candidato VALUES (12608888, 'A', 56, 2822, 999, 99, 'JOSE GUSTAVO LEE RODRIGUEZ', 'JOSE GUSTAVO LEE RODRIGUEZ', '', true, 'None', 'JOSE GUSTAVO', 'LEE RODRIGUEZ');
INSERT INTO candidato VALUES (7086147, 'A', 57, 2822, 999, 99, 'JORGE ARMANDO GUILLEN OLIVARES', 'JORGE ARMANDO GUILLEN OLIVARES', '', true, 'None', 'JORGE ARMANDO', 'GUILLEN OLIVARES');
INSERT INTO candidato VALUES (16773166, 'A', 58, 2822, 999, 99, 'ESTEBAN CLAUDIO ROMERO MAMANI', 'ESTEBAN CLAUDIO ROMERO MAMANI', '', true, 'None', 'ESTEBAN CLAUDIO', 'ROMERO MAMANI');
INSERT INTO candidato VALUES (12607747, 'A', 59, 2822, 999, 99, 'DANIEL CHIPANA CASTRO', 'DANIEL CHIPANA CASTRO', '', true, 'None', 'DANIEL', 'CHIPANA CASTRO');
INSERT INTO candidato VALUES (13414181, 'A', 50, 2823, 401, 2, 'CRISTIAN ZAVALA SOTO', 'CRISTIAN ZAVALA SOTO', '', false, 'None', 'CRISTIAN', 'ZAVALA SOTO');
INSERT INTO candidato VALUES (15979807, 'A', 50, 2824, 432, 188, 'JOSE ANTONIO SARCO JIMENEZ', 'JOSE ANTONIO SARCO JIMENEZ', '', false, 'None', 'JOSE ANTONIO', 'SARCO JIMENEZ');
INSERT INTO candidato VALUES (10196668, 'A', 51, 2824, 401, 4, 'ANGELO ALEJANDRO CARRASCO ARIAS', 'ANGELO ALEJANDRO CARRASCO ARIAS', '', false, 'None', 'ANGELO ALEJANDRO', 'CARRASCO ARIAS');
INSERT INTO candidato VALUES (17555571, 'A', 52, 2824, 444, 99, 'FABIAN ALBERTO HILAJA HUMIRE', 'FABIAN ALBERTO HILAJA HUMIRE', '', false, 'None', 'FABIAN ALBERTO', 'HILAJA HUMIRE');
INSERT INTO candidato VALUES (17553948, 'A', 53, 2824, 400, 99, 'JAVIER TITO HUAYLLA', 'JAVIER TITO HUAYLLA', '', false, 'None', 'JAVIER', 'TITO HUAYLLA');
INSERT INTO candidato VALUES (7836043, 'A', 50, 2825, 401, 99, 'ROLANDO MANZANO BUTRON', 'ROLANDO MANZANO BUTRON', '', false, 'None', 'ROLANDO', 'MANZANO BUTRON');
INSERT INTO candidato VALUES (15001097, 'A', 51, 2825, 418, 157, 'VERONICA LUISA MITA TANCARA', 'VERONICA LUISA MITA TANCARA', '', false, 'None', 'VERONICA LUISA', 'MITA TANCARA');
INSERT INTO candidato VALUES (12607838, 'A', 52, 2825, 444, 99, 'IGNACIO PABLO FLORES HUANCA', 'IGNACIO PABLO FLORES HUANCA', '', false, 'None', 'IGNACIO PABLO', 'FLORES HUANCA');
INSERT INTO candidato VALUES (13005849, 'A', 53, 2825, 439, 150, 'ALEX FERNANDO CASTILLO BLAS', 'ALEX FERNANDO CASTILLO BLAS', '', false, 'None', 'ALEX FERNANDO', 'CASTILLO BLAS');
INSERT INTO candidato VALUES (9232529, 'A', 54, 2825, 400, 1, 'GREGORIO MENDOZA CHURA', 'GREGORIO MENDOZA CHURA', '', false, 'None', 'GREGORIO', 'MENDOZA CHURA');
INSERT INTO candidato VALUES (19353900, 'A', 55, 2825, 999, 99, 'CHRISTIAN SERGIO MAMANI FLORES', 'CHRISTIAN SERGIO MAMANI FLORES', '', true, 'None', 'CHRISTIAN SERGIO', 'MAMANI FLORES');
INSERT INTO candidato VALUES (23345803, 'A', 56, 2825, 999, 99, 'RUSSEL BASILIO AQUINO ALCON', 'RUSSEL BASILIO AQUINO ALCON', '', true, 'None', 'RUSSEL BASILIO', 'AQUINO ALCON');
INSERT INTO candidato VALUES (14409571, 'A', 57, 2825, 999, 99, 'LUIS MAURICIO CHAMBILLA CHURA', 'LUIS MAURICIO CHAMBILLA CHURA', '', true, 'None', 'LUIS MAURICIO', 'CHAMBILLA CHURA');
INSERT INTO candidato VALUES (12027790, 'A', 50, 2826, 399, 99, 'JOHN ANDRADES ANDRADES', 'JOHN ANDRADES ANDRADES', '', false, 'None', 'JOHN', 'ANDRADES ANDRADES');
INSERT INTO candidato VALUES (10734673, 'A', 51, 2826, 401, 4, 'CAMILO FRANCISCO BENAVENTE JIMENEZ', 'CAMILO FRANCISCO BENAVENTE JIMENEZ', '', false, 'None', 'CAMILO FRANCISCO', 'BENAVENTE JIMENEZ');
INSERT INTO candidato VALUES (19946134, 'A', 52, 2826, 426, 200, 'EDUARDO AEDO CASTILLO', 'EDUARDO AEDO CASTILLO', '', false, 'None', 'EDUARDO', 'AEDO CASTILLO');
INSERT INTO candidato VALUES (6580267, 'A', 53, 2826, 400, 99, 'SERGIO ZARZAR ANDONIE', 'SERGIO ZARZAR ANDONIE', '', false, 'None', 'SERGIO', 'ZARZAR ANDONIE');
INSERT INTO candidato VALUES (18430007, 'A', 54, 2826, 999, 99, 'FERNANDO BRIONES CONTRERAS', 'FERNANDO BRIONES CONTRERAS', '', true, 'None', 'FERNANDO', 'BRIONES CONTRERAS');
INSERT INTO candidato VALUES (13853195, 'A', 50, 2827, 401, 7, 'PATRICIO ANDRES VELOZO FLORES', 'PATRICIO ANDRES VELOZO FLORES', '', false, 'None', 'PATRICIO ANDRES', 'VELOZO FLORES');
INSERT INTO candidato VALUES (16685246, 'A', 51, 2827, 400, 99, 'GONZALO BUSTAMANTE TRONCOSO', 'GONZALO BUSTAMANTE TRONCOSO', '', false, 'None', 'GONZALO', 'BUSTAMANTE TRONCOSO');
INSERT INTO candidato VALUES (8846773, 'A', 52, 2827, 999, 99, 'JUAN AREVALO ROJAS', 'JUAN AREVALO ROJAS', '', true, 'None', 'JUAN', 'AREVALO ROJAS');
INSERT INTO candidato VALUES (15164911, 'A', 53, 2827, 999, 99, 'GUILLERMO ALEJANDRO YEBER RODRIGUEZ', 'GUILLERMO ALEJANDRO YEBER RODRIGUEZ', '', true, 'None', 'GUILLERMO ALEJANDRO', 'YEBER RODRIGUEZ');
INSERT INTO candidato VALUES (18172028, 'A', 50, 2828, 399, 99, 'KARLA MUÑOZ MALDONADO', 'KARLA MUÑOZ MALDONADO', '', false, 'None', 'KARLA', 'MUÑOZ MALDONADO');
INSERT INTO candidato VALUES (15162023, 'A', 51, 2828, 401, 5, 'RAFAEL PALAVECINO TRONCOZO', 'RAFAEL PALAVECINO TRONCOZO', '', false, 'None', 'RAFAEL', 'PALAVECINO TRONCOZO');
INSERT INTO candidato VALUES (9868248, 'A', 52, 2828, 444, 191, 'SERGIO HERMAN CONTRERAS NAVARRO', 'SERGIO HERMAN CONTRERAS NAVARRO', '', false, 'None', 'SERGIO HERMAN', 'CONTRERAS NAVARRO');
INSERT INTO candidato VALUES (14206603, 'A', 53, 2828, 999, 99, 'VALENTINO ANDRES URRUTIA CABRERA', 'VALENTINO ANDRES URRUTIA CABRERA', '', true, 'None', 'VALENTINO ANDRES', 'URRUTIA CABRERA');
INSERT INTO candidato VALUES (13842502, 'A', 54, 2828, 999, 99, 'JORGE ANDRES DEL POZO PASTENE', 'JORGE ANDRES DEL POZO PASTENE', '', true, 'None', 'JORGE ANDRES', 'DEL POZO PASTENE');
INSERT INTO candidato VALUES (12970107, 'A', 55, 2828, 999, 99, 'CLAUDIA RUBILAR SIERRA', 'CLAUDIA RUBILAR SIERRA', '', true, 'None', 'CLAUDIA', 'RUBILAR SIERRA');
INSERT INTO candidato VALUES (15691290, 'A', 50, 2829, 399, 99, 'OSCAR LABRAÑA RAMOS', 'OSCAR LABRAÑA RAMOS', '', false, 'None', 'OSCAR', 'LABRAÑA RAMOS');
INSERT INTO candidato VALUES (17547692, 'A', 51, 2829, 401, 99, 'EDUARDO ALONSO RIQUELME QUINTEROS', 'EDUARDO ALONSO RIQUELME QUINTEROS', '', false, 'None', 'EDUARDO ALONSO', 'RIQUELME QUINTEROS');
INSERT INTO candidato VALUES (16723146, 'A', 52, 2829, 400, 1, 'RENAN CABEZAS ARROYO', 'RENAN CABEZAS ARROYO', '', false, 'None', 'RENAN', 'CABEZAS ARROYO');
INSERT INTO candidato VALUES (9934364, 'A', 53, 2829, 999, 99, 'LUIS VALENCIA SANDOVAL', 'LUIS VALENCIA SANDOVAL', '', true, 'None', 'LUIS', 'VALENCIA SANDOVAL');
INSERT INTO candidato VALUES (15744754, 'A', 50, 2830, 401, 2, 'GONZALO SANDOVAL GALLARDO', 'GONZALO SANDOVAL GALLARDO', '', false, 'None', 'GONZALO', 'SANDOVAL GALLARDO');
INSERT INTO candidato VALUES (8993729, 'A', 51, 2830, 400, 99, 'JOHNNSON GUIÑEZ NUÑEZ', 'JOHNNSON GUIÑEZ NUÑEZ', '', false, 'None', 'JOHNNSON', 'GUIÑEZ NUÑEZ');
INSERT INTO candidato VALUES (8473409, 'A', 52, 2830, 999, 99, 'ISMAEL ULISES PALMA GUIÑEZ', 'ISMAEL ULISES PALMA GUIÑEZ', '', true, 'None', 'ISMAEL ULISES', 'PALMA GUIÑEZ');
INSERT INTO candidato VALUES (15163304, 'A', 50, 2831, 439, 99, 'JAIRO DEL PINO LEMA', 'JAIRO DEL PINO LEMA', '', false, 'None', 'JAIRO', 'DEL PINO LEMA');
INSERT INTO candidato VALUES (13795370, 'A', 51, 2831, 400, 3, 'MARCELO OJEDA CARCAMO', 'MARCELO OJEDA CARCAMO', '', false, 'None', 'MARCELO', 'OJEDA CARCAMO');
INSERT INTO candidato VALUES (10508365, 'A', 52, 2831, 999, 99, 'GUSTAVO RODRIGUEZ PALMA', 'GUSTAVO RODRIGUEZ PALMA', '', true, 'None', 'GUSTAVO', 'RODRIGUEZ PALMA');
INSERT INTO candidato VALUES (20272984, 'A', 50, 2832, 399, 197, 'JAVIER ESTEBAN CAMPOS PARRA', 'JAVIER ESTEBAN CAMPOS PARRA', '', false, 'None', 'JAVIER ESTEBAN', 'CAMPOS PARRA');
INSERT INTO candidato VALUES (12056738, 'A', 51, 2832, 401, 2, 'MIGUEL ALFONSO PEÑA JARA', 'MIGUEL ALFONSO PEÑA JARA', '', false, 'None', 'MIGUEL ALFONSO', 'PEÑA JARA');
INSERT INTO candidato VALUES (17130845, 'A', 52, 2832, 439, 150, 'FELIPE IGNACIO FUENTEALBA GODOY', 'FELIPE IGNACIO FUENTEALBA GODOY', '', false, 'None', 'FELIPE IGNACIO', 'FUENTEALBA GODOY');
INSERT INTO candidato VALUES (8226720, 'A', 53, 2832, 400, 3, 'JORGE ULLOA AGUILLON', 'JORGE ULLOA AGUILLON', '', false, 'None', 'JORGE', 'ULLOA AGUILLON');
INSERT INTO candidato VALUES (16218596, 'A', 54, 2832, 999, 99, 'FELIPE IGNACIO CATALAN VENEGAS', 'FELIPE IGNACIO CATALAN VENEGAS', '', true, 'None', 'FELIPE IGNACIO', 'CATALAN VENEGAS');
INSERT INTO candidato VALUES (13381643, 'A', 50, 2833, 401, 99, 'RODNY AROLDO BAEZA PALMA', 'RODNY AROLDO BAEZA PALMA', '', false, 'None', 'RODNY AROLDO', 'BAEZA PALMA');
INSERT INTO candidato VALUES (8815259, 'A', 51, 2833, 426, 99, 'JUAN IBARRA MELLA', 'JUAN IBARRA MELLA', '', false, 'None', 'JUAN', 'IBARRA MELLA');
INSERT INTO candidato VALUES (8853118, 'A', 52, 2833, 400, 1, 'PATRICIO SUAZO ROMERO', 'PATRICIO SUAZO ROMERO', '', false, 'None', 'PATRICIO', 'SUAZO ROMERO');
INSERT INTO candidato VALUES (9217073, 'A', 53, 2833, 999, 99, 'LEONTINA DEL CARMEN GUTIERREZ RIVAS', 'LEONTINA DEL CARMEN GUTIERREZ RIVAS', '', true, 'None', 'LEONTINA DEL CARMEN', 'GUTIERREZ RIVAS');
INSERT INTO candidato VALUES (17622113, 'A', 54, 2833, 999, 99, 'RICHARD ORELLANA MONTECINO', 'RICHARD ORELLANA MONTECINO', '', true, 'None', 'RICHARD', 'ORELLANA MONTECINO');
INSERT INTO candidato VALUES (8993531, 'A', 50, 2834, 401, 5, 'RAFAEL CIFUENTES RODRIGUEZ', 'RAFAEL CIFUENTES RODRIGUEZ', '', false, 'None', 'RAFAEL', 'CIFUENTES RODRIGUEZ');
INSERT INTO candidato VALUES (9758678, 'A', 51, 2834, 444, 99, 'JACQUELINE DEL CARMEN BELTRAN FUENTES', 'JACQUELINE DEL CARMEN BELTRAN FUENTES', '', false, 'None', 'JACQUELINE DEL CARMEN', 'BELTRAN FUENTES');
INSERT INTO candidato VALUES (10320412, 'A', 52, 2834, 439, 150, 'CECILIA JANET MENESES VELASQUEZ', 'CECILIA JANET MENESES VELASQUEZ', '', false, 'None', 'CECILIA JANET', 'MENESES VELASQUEZ');
INSERT INTO candidato VALUES (14212622, 'A', 53, 2834, 999, 99, 'ALEJANDRO BECERRA VEGA', 'ALEJANDRO BECERRA VEGA', '', true, 'None', 'ALEJANDRO', 'BECERRA VEGA');
INSERT INTO candidato VALUES (5763500, 'A', 54, 2834, 999, 99, 'PEDRO ENRIQUE INOSTROZA VALENZUELA', 'PEDRO ENRIQUE INOSTROZA VALENZUELA', '', true, 'None', 'PEDRO ENRIQUE', 'INOSTROZA VALENZUELA');
INSERT INTO candidato VALUES (19250943, 'A', 55, 2834, 999, 99, 'GONZALO ROJAS SANDOVAL', 'GONZALO ROJAS SANDOVAL', '', true, 'None', 'GONZALO', 'ROJAS SANDOVAL');
INSERT INTO candidato VALUES (7461349, 'A', 50, 2835, 399, 197, 'ABEL DAVID HUICHALAF PEREZ', 'ABEL DAVID HUICHALAF PEREZ', '', false, 'None', 'ABEL DAVID', 'HUICHALAF PEREZ');
INSERT INTO candidato VALUES (10811630, 'A', 51, 2835, 401, 5, 'JOSE PEDRO HADI PINO', 'JOSE PEDRO HADI PINO', '', false, 'None', 'JOSE PEDRO', 'HADI PINO');
INSERT INTO candidato VALUES (13792697, 'A', 52, 2835, 400, 99, 'EDUARDO REDLICH MARDONES', 'EDUARDO REDLICH MARDONES', '', false, 'None', 'EDUARDO', 'REDLICH MARDONES');
INSERT INTO candidato VALUES (17187508, 'A', 53, 2835, 999, 99, 'LUIS PEDRO FUENTES ALARCON', 'LUIS PEDRO FUENTES ALARCON', '', true, 'None', 'LUIS PEDRO', 'FUENTES ALARCON');
INSERT INTO candidato VALUES (7606328, 'A', 50, 2836, 401, 7, 'JULIO MANUEL ALBERTO FUENTES ALARCON', 'JULIO MANUEL ALBERTO FUENTES ALARCON', '', false, 'None', 'JULIO MANUEL ALBERTO', 'FUENTES ALARCON');
INSERT INTO candidato VALUES (17761785, 'A', 51, 2836, 400, 99, 'MARITZA ELENA ALARCON VERA', 'MARITZA ELENA ALARCON VERA', '', false, 'None', 'MARITZA ELENA', 'ALARCON VERA');
INSERT INTO candidato VALUES (13860873, 'A', 52, 2836, 999, 99, 'JORGE EDUARDO ROMERO VILLALOBOS', 'JORGE EDUARDO ROMERO VILLALOBOS', '', true, 'None', 'JORGE EDUARDO', 'ROMERO VILLALOBOS');
INSERT INTO candidato VALUES (5857125, 'A', 50, 2837, 399, 99, 'PEDRO ENRIQUE RAMIREZ GLADE', 'PEDRO ENRIQUE RAMIREZ GLADE', '', false, 'None', 'PEDRO ENRIQUE', 'RAMIREZ GLADE');
INSERT INTO candidato VALUES (10495258, 'A', 51, 2837, 401, 99, 'ALEJANDRO RODRIGO PEDREROS URRUTIA', 'ALEJANDRO RODRIGO PEDREROS URRUTIA', '', false, 'None', 'ALEJANDRO RODRIGO', 'PEDREROS URRUTIA');
INSERT INTO candidato VALUES (12548752, 'A', 52, 2837, 400, 3, 'MIGUEL GARRIDO DOMINGUEZ', 'MIGUEL GARRIDO DOMINGUEZ', '', false, 'None', 'MIGUEL', 'GARRIDO DOMINGUEZ');
INSERT INTO candidato VALUES (6679102, 'A', 50, 2838, 401, 99, 'LUIS MOLINA MELO', 'LUIS MOLINA MELO', '', false, 'None', 'LUIS', 'MOLINA MELO');
INSERT INTO candidato VALUES (12318895, 'A', 51, 2838, 400, 37, 'OSCAR LLANOS SILVA', 'OSCAR LLANOS SILVA', '', false, 'None', 'OSCAR', 'LLANOS SILVA');
INSERT INTO candidato VALUES (15633510, 'A', 50, 2839, 444, 191, 'RODRIGO ANDRES CASTRO GALAZ', 'RODRIGO ANDRES CASTRO GALAZ', '', false, 'None', 'RODRIGO ANDRES', 'CASTRO GALAZ');
INSERT INTO candidato VALUES (15159424, 'A', 51, 2839, 400, 1, 'ADAN ZAPATA FIGUEROA', 'ADAN ZAPATA FIGUEROA', '', false, 'None', 'ADAN', 'ZAPATA FIGUEROA');
INSERT INTO candidato VALUES (8889784, 'A', 52, 2839, 999, 99, 'MODESTO SEGUNDO SEPULVEDA ANDRADE', 'MODESTO SEGUNDO SEPULVEDA ANDRADE', '', true, 'None', 'MODESTO SEGUNDO', 'SEPULVEDA ANDRADE');
INSERT INTO candidato VALUES (16497620, 'A', 53, 2839, 999, 99, 'JUAN CARLOS RAMIREZ SEPULVEDA', 'JUAN CARLOS RAMIREZ SEPULVEDA', '', true, 'None', 'JUAN CARLOS', 'RAMIREZ SEPULVEDA');
INSERT INTO candidato VALUES (4875153, 'A', 54, 2839, 999, 99, 'RAFAEL EDUARDO TRONCOSO ROZAS', 'RAFAEL EDUARDO TRONCOSO ROZAS', '', true, 'None', 'RAFAEL EDUARDO', 'TRONCOSO ROZAS');
INSERT INTO candidato VALUES (12548274, 'A', 50, 2840, 401, 4, 'CLAUDIO ANDRES RABANAL MUÑOZ', 'CLAUDIO ANDRES RABANAL MUÑOZ', '', false, 'None', 'CLAUDIO ANDRES', 'RABANAL MUÑOZ');
INSERT INTO candidato VALUES (16446232, 'A', 51, 2840, 400, 1, 'NICOLAS TORRES OVALLE', 'NICOLAS TORRES OVALLE', '', false, 'None', 'NICOLAS', 'TORRES OVALLE');
INSERT INTO candidato VALUES (9689646, 'A', 50, 2841, 400, 3, 'ISAIAS CRUCES VALDEBENITO', 'ISAIAS CRUCES VALDEBENITO', '', false, 'None', 'ISAIAS', 'CRUCES VALDEBENITO');
INSERT INTO candidato VALUES (11235103, 'A', 51, 2841, 999, 99, 'RAUL JAIME ESPEJO ESCOBAR', 'RAUL JAIME ESPEJO ESCOBAR', '', true, 'None', 'RAUL JAIME', 'ESPEJO ESCOBAR');
INSERT INTO candidato VALUES (13972541, 'A', 52, 2841, 999, 99, 'JORGE MORALES SANHUEZA', 'JORGE MORALES SANHUEZA', '', true, 'None', 'JORGE', 'MORALES SANHUEZA');
INSERT INTO candidato VALUES (15735456, 'A', 50, 2842, 399, 197, 'GASTON FARIÑA VALLEJOS', 'GASTON FARIÑA VALLEJOS', '', false, 'None', 'GASTON', 'FARIÑA VALLEJOS');
INSERT INTO candidato VALUES (8496761, 'A', 51, 2842, 401, 5, 'GASTON SUAZO SOTO', 'GASTON SUAZO SOTO', '', false, 'None', 'GASTON', 'SUAZO SOTO');
INSERT INTO candidato VALUES (13794005, 'A', 52, 2842, 418, 157, 'OSCAR ALEJANDRO NUÑEZ CRISOSTOMO', 'OSCAR ALEJANDRO NUÑEZ CRISOSTOMO', '', false, 'None', 'OSCAR ALEJANDRO', 'NUÑEZ CRISOSTOMO');
INSERT INTO candidato VALUES (13550020, 'A', 53, 2842, 439, 150, 'DIEGO JOSE FERNANDEZ MOZO', 'DIEGO JOSE FERNANDEZ MOZO', '', false, 'None', 'DIEGO JOSE', 'FERNANDEZ MOZO');
INSERT INTO candidato VALUES (10736015, 'A', 54, 2842, 400, 3, 'JORGE SILVA FUENTES', 'JORGE SILVA FUENTES', '', false, 'None', 'JORGE', 'SILVA FUENTES');
INSERT INTO candidato VALUES (9047882, 'A', 55, 2842, 999, 99, 'HECTOR EULOGIO GUZMAN VASQUEZ', 'HECTOR EULOGIO GUZMAN VASQUEZ', '', true, 'None', 'HECTOR EULOGIO', 'GUZMAN VASQUEZ');
INSERT INTO candidato VALUES (6184882, 'A', 56, 2842, 999, 99, 'FELIPE RUDECINDO LETELIER NORAMBUENA', 'FELIPE RUDECINDO LETELIER NORAMBUENA', '', true, 'None', 'FELIPE RUDECINDO', 'LETELIER NORAMBUENA');
INSERT INTO candidato VALUES (12204971, 'A', 57, 2842, 999, 99, 'NAYARET DOMINGUEZ AGUILERA', 'NAYARET DOMINGUEZ AGUILERA', '', true, 'None', 'NAYARET', 'DOMINGUEZ AGUILERA');
INSERT INTO candidato VALUES (13578134, 'A', 58, 2842, 999, 99, 'BEATRIZ MERCADO CONTRERAS', 'BEATRIZ MERCADO CONTRERAS', '', true, 'None', 'BEATRIZ', 'MERCADO CONTRERAS');
INSERT INTO candidato VALUES (14277741, 'A', 59, 2842, 999, 99, 'RUBEN MENDEZ VENEGAS', 'RUBEN MENDEZ VENEGAS', '', true, 'None', 'RUBEN', 'MENDEZ VENEGAS');
INSERT INTO candidato VALUES (9853775, 'A', 50, 2843, 399, 197, 'HUGO ALBERTO CLAVERIA NOVA', 'HUGO ALBERTO CLAVERIA NOVA', '', false, 'None', 'HUGO ALBERTO', 'CLAVERIA NOVA');
INSERT INTO candidato VALUES (13619240, 'A', 51, 2843, 401, 99, 'LUIS AMESTICA PONCE', 'LUIS AMESTICA PONCE', '', false, 'None', 'LUIS', 'AMESTICA PONCE');
INSERT INTO candidato VALUES (10457817, 'A', 52, 2843, 400, 3, 'JUAN MUÑOZ QUEZADA', 'JUAN MUÑOZ QUEZADA', '', false, 'None', 'JUAN', 'MUÑOZ QUEZADA');
INSERT INTO candidato VALUES (15879643, 'A', 53, 2843, 999, 99, 'RAUL HUMBERTO MARTINEZ GUTIERREZ', 'RAUL HUMBERTO MARTINEZ GUTIERREZ', '', true, 'None', 'RAUL HUMBERTO', 'MARTINEZ GUTIERREZ');
INSERT INTO candidato VALUES (10438773, 'A', 54, 2843, 999, 99, 'JUAN CARLOS SAEZ FREIRE', 'JUAN CARLOS SAEZ FREIRE', '', true, 'None', 'JUAN CARLOS', 'SAEZ FREIRE');
INSERT INTO candidato VALUES (16220750, 'A', 55, 2843, 999, 99, 'WILSON ENRIQUE PALMA JELVES', 'WILSON ENRIQUE PALMA JELVES', '', true, 'None', 'WILSON ENRIQUE', 'PALMA JELVES');
INSERT INTO candidato VALUES (12766355, 'A', 56, 2843, 999, 99, 'SOLANYEN CARDENAS SANDOVAL', 'SOLANYEN CARDENAS SANDOVAL', '', true, 'None', 'SOLANYEN', 'CARDENAS SANDOVAL');
INSERT INTO candidato VALUES (12668092, 'A', 50, 2844, 401, 99, 'MAURICIO CATONI CONTRERAS', 'MAURICIO CATONI CONTRERAS', '', false, 'None', 'MAURICIO', 'CATONI CONTRERAS');
INSERT INTO candidato VALUES (11697087, 'A', 51, 2844, 400, 1, 'ALEX VALENZUELA SANCHEZ', 'ALEX VALENZUELA SANCHEZ', '', false, 'None', 'ALEX', 'VALENZUELA SANCHEZ');
INSERT INTO candidato VALUES (17276445, 'A', 52, 2844, 999, 99, 'ARIEL IGNACIO MIRANDA VALLEJOS', 'ARIEL IGNACIO MIRANDA VALLEJOS', '', true, 'None', 'ARIEL IGNACIO', 'MIRANDA VALLEJOS');
INSERT INTO candidato VALUES (6091500, 'A', 53, 2844, 999, 99, 'JOSE MERCADO FUENTES', 'JOSE MERCADO FUENTES', '', true, 'None', 'JOSE', 'MERCADO FUENTES');
INSERT INTO candidato VALUES (19487190, 'A', 54, 2844, 999, 99, 'ALEXIS MENDEZ URIBE', 'ALEXIS MENDEZ URIBE', '', true, 'None', 'ALEXIS', 'MENDEZ URIBE');
INSERT INTO candidato VALUES (13794179, 'A', 50, 2845, 400, 1, 'CLAUDIO ALMUNA GARRIDO', 'CLAUDIO ALMUNA GARRIDO', '', false, 'None', 'CLAUDIO', 'ALMUNA GARRIDO');
INSERT INTO candidato VALUES (14303647, 'A', 51, 2845, 999, 99, 'ENRIQUE OCTAVIO OLIVARES LANDAETA', 'ENRIQUE OCTAVIO OLIVARES LANDAETA', '', true, 'None', 'ENRIQUE OCTAVIO', 'OLIVARES LANDAETA');
INSERT INTO candidato VALUES (18657610, 'A', 52, 2845, 999, 99, 'CRISTOFER ANTONIO VALDES GONZALEZ', 'CRISTOFER ANTONIO VALDES GONZALEZ', '', true, 'None', 'CRISTOFER ANTONIO', 'VALDES GONZALEZ');
INSERT INTO candidato VALUES (12547761, 'A', 53, 2845, 999, 99, 'FERNANDO CORREA SANDOVAL', 'FERNANDO CORREA SANDOVAL', '', true, 'None', 'FERNANDO', 'CORREA SANDOVAL');
INSERT INTO candidato VALUES (5744742, 'A', 50, 2846, 400, 1, 'VICTOR HUGO RICE SANCHEZ', 'VICTOR HUGO RICE SANCHEZ', '', false, 'None', 'VICTOR HUGO', 'RICE SANCHEZ');
INSERT INTO candidato VALUES (9863684, 'A', 51, 2846, 999, 99, 'VICTOR RAMON TORO LEIVA', 'VICTOR RAMON TORO LEIVA', '', true, 'None', 'VICTOR RAMON', 'TORO LEIVA');
INSERT INTO candidato VALUES (15699415, 'A', 52, 2846, 999, 99, 'MARCO ANTONIO MUÑOZ MOLINA', 'MARCO ANTONIO MUÑOZ MOLINA', '', true, 'None', 'MARCO ANTONIO', 'MUÑOZ MOLINA');
INSERT INTO candidato VALUES (13858822, 'A', 53, 2846, 999, 99, 'RAFAEL GONZALEZ NAVARRETE', 'RAFAEL GONZALEZ NAVARRETE', '', true, 'None', 'RAFAEL', 'GONZALEZ NAVARRETE');
INSERT INTO candidato VALUES (12504197, 'A', 54, 2846, 999, 99, 'SERGIO EMILIO SAAVEDRA TORRES', 'SERGIO EMILIO SAAVEDRA TORRES', '', true, 'None', 'SERGIO EMILIO', 'SAAVEDRA TORRES');
INSERT INTO candidato VALUES (17414523, 'A', 53, 2790, 999, 99, 'MATIAS JAIR TOLEDO HERRERA', 'MATIAS JAIR TOLEDO HERRERA', '', true, 'None', 'MATIAS', 'TOLEDO');
INSERT INTO candidato VALUES (13698753, 'A', 53, 2775, 999, 99, 'GONZALO MONTOYA RIQUELME', 'GONZALO MONTOYA RIQUELME', '', true, 'None', 'GONZALO', 'MONTOYA');
INSERT INTO candidato VALUES (10211329, 'A', 50, 2769, 401, 2, 'CLAUDIA PIZARRO PEÑA', 'CLAUDIA PIZARRO PEÑA', '', false, 'None', 'CLAUDIA', 'PIZARRO');
INSERT INTO candidato VALUES (15421464, 'A', 51, 2769, 418, 157, 'DAVID EDUARDO ZAMBRANO SALAZAR', 'DAVID EDUARDO ZAMBRANO SALAZAR', '', false, 'None', 'DAVID', 'ZAMBRANO');


--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('candidato_candidato_id_seq', 1, false);


--
-- Name: candidato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('candidato_id_seq', 4, true);


--
-- Data for Name: comuna; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO comuna VALUES (2823, 3015, 6001, 'CAMARONES');
INSERT INTO comuna VALUES (2822, 3015, 6001, 'ARICA');
INSERT INTO comuna VALUES (2825, 3015, 6001, 'GENERAL LAGOS');
INSERT INTO comuna VALUES (2824, 3015, 6001, 'PUTRE');
INSERT INTO comuna VALUES (2502, 3001, 6002, 'ALTO HOSPICIO');
INSERT INTO comuna VALUES (2501, 3001, 6002, 'IQUIQUE');
INSERT INTO comuna VALUES (2507, 3001, 6002, 'PICA');
INSERT INTO comuna VALUES (2506, 3001, 6002, 'HUARA');
INSERT INTO comuna VALUES (2505, 3001, 6002, 'COLCHANE');
INSERT INTO comuna VALUES (2504, 3001, 6002, 'CAMIÑA');
INSERT INTO comuna VALUES (2503, 3001, 6002, 'POZO ALMONTE');
INSERT INTO comuna VALUES (2511, 3002, 6003, 'TALTAL');
INSERT INTO comuna VALUES (2510, 3002, 6003, 'SIERRA GORDA');
INSERT INTO comuna VALUES (2509, 3002, 6003, 'MEJILLONES');
INSERT INTO comuna VALUES (2508, 3002, 6003, 'ANTOFAGASTA');
INSERT INTO comuna VALUES (2514, 3002, 6003, 'SAN PEDRO DE ATACAMA');
INSERT INTO comuna VALUES (2513, 3002, 6003, 'OLLAGUE');
INSERT INTO comuna VALUES (2512, 3002, 6003, 'CALAMA');
INSERT INTO comuna VALUES (2516, 3002, 6003, 'MARIA ELENA');
INSERT INTO comuna VALUES (2515, 3002, 6003, 'TOCOPILLA');
INSERT INTO comuna VALUES (2519, 3003, 6004, 'TIERRA AMARILLA');
INSERT INTO comuna VALUES (2518, 3003, 6004, 'CALDERA');
INSERT INTO comuna VALUES (2517, 3003, 6004, 'COPIAPO');
INSERT INTO comuna VALUES (2521, 3003, 6004, 'DIEGO DE ALMAGRO');
INSERT INTO comuna VALUES (2520, 3003, 6004, 'CHAÑARAL');
INSERT INTO comuna VALUES (2525, 3003, 6004, 'HUASCO');
INSERT INTO comuna VALUES (2524, 3003, 6004, 'FREIRINA');
INSERT INTO comuna VALUES (2523, 3003, 6004, 'ALTO DEL CARMEN');
INSERT INTO comuna VALUES (2522, 3003, 6004, 'VALLENAR');
INSERT INTO comuna VALUES (2531, 3004, 6005, 'VICUÑA');
INSERT INTO comuna VALUES (2530, 3004, 6005, 'PAIHUANO');
INSERT INTO comuna VALUES (2529, 3004, 6005, 'LA HIGUERA');
INSERT INTO comuna VALUES (2528, 3004, 6005, 'ANDACOLLO');
INSERT INTO comuna VALUES (2527, 3004, 6005, 'COQUIMBO');
INSERT INTO comuna VALUES (2526, 3004, 6005, 'LA SERENA');
INSERT INTO comuna VALUES (2535, 3004, 6005, 'SALAMANCA');
INSERT INTO comuna VALUES (2534, 3004, 6005, 'LOS VILOS');
INSERT INTO comuna VALUES (2533, 3004, 6005, 'CANELA');
INSERT INTO comuna VALUES (2532, 3004, 6005, 'ILLAPEL');
INSERT INTO comuna VALUES (2540, 3004, 6005, 'RIO HURTADO');
INSERT INTO comuna VALUES (2539, 3004, 6005, 'PUNITAQUI');
INSERT INTO comuna VALUES (2538, 3004, 6005, 'MONTE PATRIA');
INSERT INTO comuna VALUES (2537, 3004, 6005, 'COMBARBALA');
INSERT INTO comuna VALUES (2536, 3004, 6005, 'OVALLE');
INSERT INTO comuna VALUES (2547, 3005, 6007, 'VIÑA DEL MAR');
INSERT INTO comuna VALUES (2546, 3005, 6006, 'QUINTERO');
INSERT INTO comuna VALUES (2545, 3005, 6006, 'PUCHUNCAVI');
INSERT INTO comuna VALUES (2544, 3005, 6007, 'JUAN FERNANDEZ');
INSERT INTO comuna VALUES (2543, 3005, 6007, 'CONCON');
INSERT INTO comuna VALUES (2542, 3005, 6007, 'CASABLANCA');
INSERT INTO comuna VALUES (2541, 3005, 6007, 'VALPARAISO');
INSERT INTO comuna VALUES (2548, 3005, 6007, 'ISLA DE PASCUA');
INSERT INTO comuna VALUES (2552, 3005, 6006, 'SAN ESTEBAN');
INSERT INTO comuna VALUES (2551, 3005, 6006, 'RINCONADA');
INSERT INTO comuna VALUES (2550, 3005, 6006, 'CALLE LARGA');
INSERT INTO comuna VALUES (2549, 3005, 6006, 'LOS ANDES');
INSERT INTO comuna VALUES (2557, 3005, 6006, 'ZAPALLAR');
INSERT INTO comuna VALUES (2556, 3005, 6006, 'PETORCA');
INSERT INTO comuna VALUES (2555, 3005, 6006, 'PAPUDO');
INSERT INTO comuna VALUES (2554, 3005, 6006, 'CABILDO');
INSERT INTO comuna VALUES (2553, 3005, 6006, 'LA LIGUA');
INSERT INTO comuna VALUES (2562, 3005, 6006, 'NOGALES');
INSERT INTO comuna VALUES (2561, 3005, 6006, 'LA CRUZ');
INSERT INTO comuna VALUES (2560, 3005, 6006, 'HIJUELAS');
INSERT INTO comuna VALUES (2559, 3005, 6006, 'CALERA');
INSERT INTO comuna VALUES (2558, 3005, 6006, 'QUILLOTA');
INSERT INTO comuna VALUES (2568, 3005, 6007, 'SANTO DOMINGO');
INSERT INTO comuna VALUES (2567, 3005, 6007, 'EL TABO');
INSERT INTO comuna VALUES (2566, 3005, 6007, 'EL QUISCO');
INSERT INTO comuna VALUES (2565, 3005, 6007, 'CARTAGENA');
INSERT INTO comuna VALUES (2564, 3005, 6007, 'ALGARROBO');
INSERT INTO comuna VALUES (2563, 3005, 6007, 'SAN ANTONIO');
INSERT INTO comuna VALUES (2574, 3005, 6006, 'SANTA MARIA');
INSERT INTO comuna VALUES (2573, 3005, 6006, 'PUTAENDO');
INSERT INTO comuna VALUES (2572, 3005, 6006, 'PANQUEHUE');
INSERT INTO comuna VALUES (2571, 3005, 6006, 'LLAY-LLAY');
INSERT INTO comuna VALUES (2570, 3005, 6006, 'CATEMU');
INSERT INTO comuna VALUES (2569, 3005, 6006, 'SAN FELIPE');
INSERT INTO comuna VALUES (2578, 3005, 6006, 'VILLA ALEMANA');
INSERT INTO comuna VALUES (2577, 3005, 6006, 'OLMUE');
INSERT INTO comuna VALUES (2576, 3005, 6006, 'LIMACHE');
INSERT INTO comuna VALUES (2575, 3005, 6006, 'QUILPUE');
INSERT INTO comuna VALUES (2789, 3013, 6011, 'VITACURA');
INSERT INTO comuna VALUES (2788, 3013, 6013, 'SAN RAMON');
INSERT INTO comuna VALUES (2787, 3013, 6013, 'SAN MIGUEL');
INSERT INTO comuna VALUES (2786, 3013, 6010, 'SAN JOAQUIN');
INSERT INTO comuna VALUES (2785, 3013, 6009, 'RENCA');
INSERT INTO comuna VALUES (2784, 3013, 6009, 'RECOLETA');
INSERT INTO comuna VALUES (2783, 3013, 6009, 'QUINTA NORMAL');
INSERT INTO comuna VALUES (2782, 3013, 6008, 'QUILICURA');
INSERT INTO comuna VALUES (2781, 3013, 6008, 'PUDAHUEL');
INSERT INTO comuna VALUES (2780, 3013, 6010, 'PROVIDENCIA');
INSERT INTO comuna VALUES (2779, 3013, 6011, 'PEÑALOLEN');
INSERT INTO comuna VALUES (2778, 3013, 6013, 'PEDRO AGUIRRE CERDA');
INSERT INTO comuna VALUES (2777, 3013, 6010, 'ÑUÑOA');
INSERT INTO comuna VALUES (2776, 3013, 6008, 'MAIPU');
INSERT INTO comuna VALUES (2775, 3013, 6010, 'MACUL');
INSERT INTO comuna VALUES (2774, 3013, 6009, 'LO PRADO');
INSERT INTO comuna VALUES (2773, 3013, 6013, 'LO ESPEJO');
INSERT INTO comuna VALUES (2772, 3013, 6011, 'LO BARNECHEA');
INSERT INTO comuna VALUES (2771, 3013, 6011, 'LAS CONDES');
INSERT INTO comuna VALUES (2770, 3013, 6011, 'LA REINA');
INSERT INTO comuna VALUES (2769, 3013, 6012, 'LA PINTANA');
INSERT INTO comuna VALUES (2768, 3013, 6010, 'LA GRANJA');
INSERT INTO comuna VALUES (2767, 3013, 6012, 'LA FLORIDA');
INSERT INTO comuna VALUES (2766, 3013, 6013, 'LA CISTERNA');
INSERT INTO comuna VALUES (2765, 3013, 6009, 'INDEPENDENCIA');
INSERT INTO comuna VALUES (2764, 3013, 6009, 'HUECHURABA');
INSERT INTO comuna VALUES (2763, 3013, 6008, 'ESTACION CENTRAL');
INSERT INTO comuna VALUES (2762, 3013, 6013, 'EL BOSQUE');
INSERT INTO comuna VALUES (2761, 3013, 6009, 'CONCHALI');
INSERT INTO comuna VALUES (2760, 3013, 6009, 'CERRO NAVIA');
INSERT INTO comuna VALUES (2759, 3013, 6008, 'CERRILLOS');
INSERT INTO comuna VALUES (2758, 3013, 6010, 'SANTIAGO');
INSERT INTO comuna VALUES (2792, 3013, 6012, 'SAN JOSE DE MAIPO');
INSERT INTO comuna VALUES (2791, 3013, 6012, 'PIRQUE');
INSERT INTO comuna VALUES (2790, 3013, 6012, 'PUENTE ALTO');
INSERT INTO comuna VALUES (2795, 3013, 6008, 'TILTIL');
INSERT INTO comuna VALUES (2794, 3013, 6008, 'LAMPA');
INSERT INTO comuna VALUES (2793, 3013, 6008, 'COLINA');
INSERT INTO comuna VALUES (2799, 3013, 6014, 'PAINE');
INSERT INTO comuna VALUES (2798, 3013, 6014, 'CALERA DE TANGO');
INSERT INTO comuna VALUES (2797, 3013, 6014, 'BUIN');
INSERT INTO comuna VALUES (2796, 3013, 6014, 'SAN BERNARDO');
INSERT INTO comuna VALUES (2804, 3013, 6014, 'SAN PEDRO');
INSERT INTO comuna VALUES (2803, 3013, 6014, 'MARIA PINTO');
INSERT INTO comuna VALUES (2802, 3013, 6014, 'CURACAVI');
INSERT INTO comuna VALUES (2801, 3013, 6014, 'ALHUE');
INSERT INTO comuna VALUES (2800, 3013, 6014, 'MELIPILLA');
INSERT INTO comuna VALUES (2809, 3013, 6014, 'PEÑAFLOR');
INSERT INTO comuna VALUES (2808, 3013, 6014, 'PADRE HURTADO');
INSERT INTO comuna VALUES (2807, 3013, 6014, 'ISLA DE MAIPO');
INSERT INTO comuna VALUES (2806, 3013, 6014, 'EL MONTE');
INSERT INTO comuna VALUES (2805, 3013, 6014, 'TALAGANTE');
INSERT INTO comuna VALUES (2595, 3006, 6016, 'SAN VICENTE');
INSERT INTO comuna VALUES (2594, 3006, 6015, 'REQUINOA');
INSERT INTO comuna VALUES (2593, 3006, 6015, 'RENGO');
INSERT INTO comuna VALUES (2592, 3006, 6015, 'QUINTA DE TILCOCO');
INSERT INTO comuna VALUES (2591, 3006, 6016, 'PICHIDEGUA');
INSERT INTO comuna VALUES (2590, 3006, 6016, 'PEUMO');
INSERT INTO comuna VALUES (2589, 3006, 6015, 'OLIVAR');
INSERT INTO comuna VALUES (2588, 3006, 6015, 'MOSTAZAL');
INSERT INTO comuna VALUES (2587, 3006, 6015, 'MALLOA');
INSERT INTO comuna VALUES (2586, 3006, 6015, 'MACHALI');
INSERT INTO comuna VALUES (2585, 3006, 6016, 'LAS CABRAS');
INSERT INTO comuna VALUES (2584, 3006, 6015, 'GRANEROS');
INSERT INTO comuna VALUES (2583, 3006, 6015, 'DOÑIHUE');
INSERT INTO comuna VALUES (2582, 3006, 6015, 'COLTAUCO');
INSERT INTO comuna VALUES (2581, 3006, 6015, 'COINCO');
INSERT INTO comuna VALUES (2580, 3006, 6015, 'CODEGUA');
INSERT INTO comuna VALUES (2579, 3006, 6015, 'RANCAGUA');
INSERT INTO comuna VALUES (2601, 3006, 6016, 'PAREDONES');
INSERT INTO comuna VALUES (2600, 3006, 6016, 'NAVIDAD');
INSERT INTO comuna VALUES (2599, 3006, 6016, 'MARCHIGUE');
INSERT INTO comuna VALUES (2598, 3006, 6016, 'LITUECHE');
INSERT INTO comuna VALUES (2597, 3006, 6016, 'LA ESTRELLA');
INSERT INTO comuna VALUES (2596, 3006, 6016, 'PICHILEMU');
INSERT INTO comuna VALUES (2611, 3006, 6016, 'SANTA CRUZ');
INSERT INTO comuna VALUES (2610, 3006, 6016, 'PUMANQUE');
INSERT INTO comuna VALUES (2609, 3006, 6016, 'PLACILLA');
INSERT INTO comuna VALUES (2608, 3006, 6016, 'PERALILLO');
INSERT INTO comuna VALUES (2607, 3006, 6016, 'PALMILLA');
INSERT INTO comuna VALUES (2606, 3006, 6016, 'NANCAGUA');
INSERT INTO comuna VALUES (2605, 3006, 6016, 'LOLOL');
INSERT INTO comuna VALUES (2604, 3006, 6016, 'CHIMBARONGO');
INSERT INTO comuna VALUES (2603, 3006, 6016, 'CHEPICA');
INSERT INTO comuna VALUES (2602, 3006, 6016, 'SAN FERNANDO');
INSERT INTO comuna VALUES (2621, 3007, 6017, 'SAN RAFAEL');
INSERT INTO comuna VALUES (2620, 3007, 6017, 'SAN CLEMENTE');
INSERT INTO comuna VALUES (2619, 3007, 6017, 'RIO CLARO');
INSERT INTO comuna VALUES (2618, 3007, 6017, 'PENCAHUE');
INSERT INTO comuna VALUES (2617, 3007, 6017, 'PELARCO');
INSERT INTO comuna VALUES (2616, 3007, 6017, 'MAULE');
INSERT INTO comuna VALUES (2615, 3007, 6017, 'EMPEDRADO');
INSERT INTO comuna VALUES (2614, 3007, 6017, 'CUREPTO');
INSERT INTO comuna VALUES (2613, 3007, 6017, 'CONSTITUCION');
INSERT INTO comuna VALUES (2612, 3007, 6017, 'TALCA');
INSERT INTO comuna VALUES (2624, 3007, 6018, 'PELLUHUE');
INSERT INTO comuna VALUES (2623, 3007, 6018, 'CHANCO');
INSERT INTO comuna VALUES (2622, 3007, 6018, 'CAUQUENES');
INSERT INTO comuna VALUES (2633, 3007, 6017, 'VICHUQUEN');
INSERT INTO comuna VALUES (2632, 3007, 6017, 'TENO');
INSERT INTO comuna VALUES (2631, 3007, 6017, 'SAGRADA FAMILIA');
INSERT INTO comuna VALUES (2630, 3007, 6017, 'ROMERAL');
INSERT INTO comuna VALUES (2629, 3007, 6017, 'RAUCO');
INSERT INTO comuna VALUES (2628, 3007, 6017, 'MOLINA');
INSERT INTO comuna VALUES (2627, 3007, 6017, 'LICANTEN');
INSERT INTO comuna VALUES (2626, 3007, 6017, 'HUALAÑE');
INSERT INTO comuna VALUES (2625, 3007, 6017, 'CURICO');
INSERT INTO comuna VALUES (2641, 3007, 6018, 'YERBAS BUENAS');
INSERT INTO comuna VALUES (2640, 3007, 6018, 'VILLA ALEGRE');
INSERT INTO comuna VALUES (2639, 3007, 6018, 'SAN JAVIER');
INSERT INTO comuna VALUES (2638, 3007, 6018, 'RETIRO');
INSERT INTO comuna VALUES (2637, 3007, 6018, 'PARRAL');
INSERT INTO comuna VALUES (2636, 3007, 6018, 'LONGAVI');
INSERT INTO comuna VALUES (2635, 3007, 6018, 'COLBUN');
INSERT INTO comuna VALUES (2634, 3007, 6018, 'LINARES');
INSERT INTO comuna VALUES (2834, 3016, 6019, 'YUNGAY');
INSERT INTO comuna VALUES (2833, 3016, 6019, 'SAN IGNACIO');
INSERT INTO comuna VALUES (2832, 3016, 6019, 'QUILLON');
INSERT INTO comuna VALUES (2831, 3016, 6019, 'PINTO');
INSERT INTO comuna VALUES (2830, 3016, 6019, 'PEMUCO');
INSERT INTO comuna VALUES (2829, 3016, 6019, 'EL CARMEN');
INSERT INTO comuna VALUES (2828, 3016, 6019, 'CHILLAN VIEJO');
INSERT INTO comuna VALUES (2827, 3016, 6019, 'BULNES');
INSERT INTO comuna VALUES (2826, 3016, 6019, 'CHILLAN');
INSERT INTO comuna VALUES (2841, 3016, 6019, 'TREHUACO');
INSERT INTO comuna VALUES (2840, 3016, 6019, 'RANQUIL');
INSERT INTO comuna VALUES (2839, 3016, 6019, 'PORTEZUELO');
INSERT INTO comuna VALUES (2838, 3016, 6019, 'NINHUE');
INSERT INTO comuna VALUES (2837, 3016, 6019, 'COELEMU');
INSERT INTO comuna VALUES (2836, 3016, 6019, 'COBQUECURA');
INSERT INTO comuna VALUES (2835, 3016, 6019, 'QUIRIHUE');
INSERT INTO comuna VALUES (2846, 3016, 6019, 'SAN NICOLAS');
INSERT INTO comuna VALUES (2845, 3016, 6019, 'SAN FABIAN');
INSERT INTO comuna VALUES (2844, 3016, 6019, 'ÑIQUEN');
INSERT INTO comuna VALUES (2843, 3016, 6019, 'COIHUECO');
INSERT INTO comuna VALUES (2842, 3016, 6019, 'SAN CARLOS');
INSERT INTO comuna VALUES (2653, 3008, 6020, 'HUALPEN');
INSERT INTO comuna VALUES (2652, 3008, 6020, 'TOME');
INSERT INTO comuna VALUES (2651, 3008, 6020, 'TALCAHUANO');
INSERT INTO comuna VALUES (2650, 3008, 6020, 'SANTA JUANA');
INSERT INTO comuna VALUES (2649, 3008, 6020, 'SAN PEDRO DE LA PAZ');
INSERT INTO comuna VALUES (2648, 3008, 6020, 'PENCO');
INSERT INTO comuna VALUES (2647, 3008, 6021, 'LOTA');
INSERT INTO comuna VALUES (2646, 3008, 6020, 'HUALQUI');
INSERT INTO comuna VALUES (2645, 3008, 6020, 'FLORIDA');
INSERT INTO comuna VALUES (2644, 3008, 6020, 'CHIGUAYANTE');
INSERT INTO comuna VALUES (2643, 3008, 6020, 'CORONEL');
INSERT INTO comuna VALUES (2642, 3008, 6020, 'CONCEPCION');
INSERT INTO comuna VALUES (2660, 3008, 6021, 'TIRUA');
INSERT INTO comuna VALUES (2659, 3008, 6021, 'LOS ALAMOS');
INSERT INTO comuna VALUES (2658, 3008, 6021, 'CURANILAHUE');
INSERT INTO comuna VALUES (2657, 3008, 6021, 'CONTULMO');
INSERT INTO comuna VALUES (2656, 3008, 6021, 'CAÑETE');
INSERT INTO comuna VALUES (2655, 3008, 6021, 'ARAUCO');
INSERT INTO comuna VALUES (2654, 3008, 6021, 'LEBU');
INSERT INTO comuna VALUES (2674, 3008, 6021, 'ALTO BIOBIO');
INSERT INTO comuna VALUES (2673, 3008, 6021, 'YUMBEL');
INSERT INTO comuna VALUES (2672, 3008, 6021, 'TUCAPEL');
INSERT INTO comuna VALUES (2671, 3008, 6021, 'SANTA BARBARA');
INSERT INTO comuna VALUES (2670, 3008, 6021, 'SAN ROSENDO');
INSERT INTO comuna VALUES (2669, 3008, 6021, 'QUILLECO');
INSERT INTO comuna VALUES (2668, 3008, 6021, 'QUILACO');
INSERT INTO comuna VALUES (2667, 3008, 6021, 'NEGRETE');
INSERT INTO comuna VALUES (2666, 3008, 6021, 'NACIMIENTO');
INSERT INTO comuna VALUES (2665, 3008, 6021, 'MULCHEN');
INSERT INTO comuna VALUES (2664, 3008, 6021, 'LAJA');
INSERT INTO comuna VALUES (2663, 3008, 6021, 'CABRERO');
INSERT INTO comuna VALUES (2662, 3008, 6021, 'ANTUCO');
INSERT INTO comuna VALUES (2661, 3008, 6021, 'LOS ANGELES');
INSERT INTO comuna VALUES (2695, 3009, 6023, 'CHOLCHOL');
INSERT INTO comuna VALUES (2694, 3009, 6023, 'VILLARRICA');
INSERT INTO comuna VALUES (2693, 3009, 6022, 'VILCUN');
INSERT INTO comuna VALUES (2692, 3009, 6023, 'TOLTEN');
INSERT INTO comuna VALUES (2691, 3009, 6023, 'TEODORO SCHMIDT');
INSERT INTO comuna VALUES (2690, 3009, 6023, 'SAAVEDRA');
INSERT INTO comuna VALUES (2689, 3009, 6023, 'PUCON');
INSERT INTO comuna VALUES (2688, 3009, 6023, 'PITRUFQUEN');
INSERT INTO comuna VALUES (2687, 3009, 6022, 'PERQUENCO');
INSERT INTO comuna VALUES (2686, 3009, 6023, 'PADRE LAS CASAS');
INSERT INTO comuna VALUES (2685, 3009, 6023, 'NUEVA IMPERIAL');
INSERT INTO comuna VALUES (2684, 3009, 6022, 'MELIPEUCO');
INSERT INTO comuna VALUES (2683, 3009, 6023, 'LONCOCHE');
INSERT INTO comuna VALUES (2682, 3009, 6022, 'LAUTARO');
INSERT INTO comuna VALUES (2681, 3009, 6023, 'GORBEA');
INSERT INTO comuna VALUES (2680, 3009, 6022, 'GALVARINO');
INSERT INTO comuna VALUES (2679, 3009, 6023, 'FREIRE');
INSERT INTO comuna VALUES (2678, 3009, 6023, 'CURARREHUE');
INSERT INTO comuna VALUES (2677, 3009, 6023, 'CUNCO');
INSERT INTO comuna VALUES (2676, 3009, 6023, 'CARAHUE');
INSERT INTO comuna VALUES (2675, 3009, 6023, 'TEMUCO');
INSERT INTO comuna VALUES (2706, 3009, 6022, 'VICTORIA');
INSERT INTO comuna VALUES (2705, 3009, 6022, 'TRAIGUEN');
INSERT INTO comuna VALUES (2704, 3009, 6022, 'RENAICO');
INSERT INTO comuna VALUES (2703, 3009, 6022, 'PUREN');
INSERT INTO comuna VALUES (2702, 3009, 6022, 'LUMACO');
INSERT INTO comuna VALUES (2701, 3009, 6022, 'LOS SAUCES');
INSERT INTO comuna VALUES (2700, 3009, 6022, 'LONQUIMAY');
INSERT INTO comuna VALUES (2699, 3009, 6022, 'ERCILLA');
INSERT INTO comuna VALUES (2698, 3009, 6022, 'CURACAUTIN');
INSERT INTO comuna VALUES (2697, 3009, 6022, 'COLLIPULLI');
INSERT INTO comuna VALUES (2696, 3009, 6022, 'ANGOL');
INSERT INTO comuna VALUES (2817, 3014, 6024, 'PANGUIPULLI');
INSERT INTO comuna VALUES (2816, 3014, 6024, 'PAILLACO');
INSERT INTO comuna VALUES (2815, 3014, 6024, 'MARIQUINA');
INSERT INTO comuna VALUES (2814, 3014, 6024, 'MAFIL');
INSERT INTO comuna VALUES (2813, 3014, 6024, 'LOS LAGOS');
INSERT INTO comuna VALUES (2812, 3014, 6024, 'LANCO');
INSERT INTO comuna VALUES (2811, 3014, 6024, 'CORRAL');
INSERT INTO comuna VALUES (2810, 3014, 6024, 'VALDIVIA');
INSERT INTO comuna VALUES (2821, 3014, 6024, 'RIO BUENO');
INSERT INTO comuna VALUES (2820, 3014, 6024, 'LAGO RANCO');
INSERT INTO comuna VALUES (2819, 3014, 6024, 'FUTRONO');
INSERT INTO comuna VALUES (2818, 3014, 6024, 'LA UNION');
INSERT INTO comuna VALUES (2715, 3010, 6025, 'PUERTO VARAS');
INSERT INTO comuna VALUES (2714, 3010, 6026, 'MAULLIN');
INSERT INTO comuna VALUES (2713, 3010, 6025, 'LLANQUIHUE');
INSERT INTO comuna VALUES (2712, 3010, 6025, 'LOS MUERMOS');
INSERT INTO comuna VALUES (2711, 3010, 6025, 'FRUTILLAR');
INSERT INTO comuna VALUES (2710, 3010, 6025, 'FRESIA');
INSERT INTO comuna VALUES (2709, 3010, 6026, 'COCHAMO');
INSERT INTO comuna VALUES (2708, 3010, 6026, 'CALBUCO');
INSERT INTO comuna VALUES (2707, 3010, 6026, 'PUERTO MONTT');
INSERT INTO comuna VALUES (2725, 3010, 6026, 'QUINCHAO');
INSERT INTO comuna VALUES (2724, 3010, 6026, 'QUEMCHI');
INSERT INTO comuna VALUES (2723, 3010, 6026, 'QUELLON');
INSERT INTO comuna VALUES (2722, 3010, 6026, 'QUEILEN');
INSERT INTO comuna VALUES (2721, 3010, 6026, 'PUQUELDON');
INSERT INTO comuna VALUES (2720, 3010, 6026, 'DALCAHUE');
INSERT INTO comuna VALUES (2719, 3010, 6026, 'CURACO DE VELEZ');
INSERT INTO comuna VALUES (2718, 3010, 6026, 'CHONCHI');
INSERT INTO comuna VALUES (2717, 3010, 6026, 'ANCUD');
INSERT INTO comuna VALUES (2716, 3010, 6026, 'CASTRO');
INSERT INTO comuna VALUES (2732, 3010, 6025, 'SAN PABLO');
INSERT INTO comuna VALUES (2731, 3010, 6025, 'SAN JUAN DE LA COSTA');
INSERT INTO comuna VALUES (2730, 3010, 6025, 'RIO NEGRO');
INSERT INTO comuna VALUES (2729, 3010, 6025, 'PUYEHUE');
INSERT INTO comuna VALUES (2728, 3010, 6025, 'PURRANQUE');
INSERT INTO comuna VALUES (2727, 3010, 6025, 'PUERTO OCTAY');
INSERT INTO comuna VALUES (2726, 3010, 6025, 'OSORNO');
INSERT INTO comuna VALUES (2736, 3010, 6026, 'PALENA');
INSERT INTO comuna VALUES (2735, 3010, 6026, 'HUALAIHUE');
INSERT INTO comuna VALUES (2734, 3010, 6026, 'FUTALEUFU');
INSERT INTO comuna VALUES (2733, 3010, 6026, 'CHAITEN');
INSERT INTO comuna VALUES (2738, 3011, 6027, 'LAGO VERDE');
INSERT INTO comuna VALUES (2737, 3011, 6027, 'COYHAIQUE');
INSERT INTO comuna VALUES (2741, 3011, 6027, 'GUAITECAS');
INSERT INTO comuna VALUES (2740, 3011, 6027, 'CISNES');
INSERT INTO comuna VALUES (2739, 3011, 6027, 'AYSEN');
INSERT INTO comuna VALUES (2744, 3011, 6027, 'TORTEL');


--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('comuna_comuna_id_seq', 1, false);


--
-- Name: comuna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('comuna_id_seq', 1, false);


--
-- Data for Name: imagen; Type: TABLE DATA; Schema: public; Owner: app_vav
--



--
-- Name: imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('imagen_id_seq', 9, true);


--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('imagen_imagen_id_seq', 1, false);


--
-- Data for Name: mesa; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO mesa VALUES (14, 1, 'A', 2764, 'HUECHURABA', 'HUECHURABA', 'Colegio Pumahue', 'MESA  9', 1, 1, 0, 0, 0, '2024-10-26 03:10:37.606399', '2024-10-26 03:09:54.402112');
INSERT INTO mesa VALUES (7, 1, 'A', 2796, 'SAN BERNARDO', 'SAN BERNARDO', 'col. Eliodoro Matte Ossa', 'MESA  3', 1, 1, 0, 0, 0, '2024-10-26 03:02:21.164817', '2024-10-26 03:00:03.042797');
INSERT INTO mesa VALUES (6, 1, 'A', 2784, 'RECOLETA', 'RECOLETA', 'LIC San Leonardo Murialdo', 'MESA  25', 1, 1, 0, 0, 0, '2024-10-26 03:02:24.748119', '2024-10-26 02:58:44.081824');
INSERT INTO mesa VALUES (5, 1, 'A', 2775, 'MACUL', 'MACUL', 'estadio nacional', 'MESA  15', 1, 1, 0, 0, 0, '2024-10-26 03:02:29.255633', '2024-10-26 02:57:54.523857');
INSERT INTO mesa VALUES (4, 1, 'A', 2780, 'PROVIDENCIA', 'PROVIDENCIA', 'liceo lastarria', 'MESA  15', 1, 1, 0, 0, 0, '2024-10-26 03:02:33.760192', '2024-10-26 02:57:15.921152');
INSERT INTO mesa VALUES (1, 1, 'A', 2758, 'SANTIAGO', 'SANTIAGO', 'instituto nacional', 'MESA  25', 1, 1, 0, 0, 0, '2024-10-26 03:02:38.060525', '2024-10-26 02:54:33.620324');
INSERT INTO mesa VALUES (3, 1, 'A', 2771, 'LAS CONDES', 'LAS CONDES', 'col. sagrados corazones', 'MESA  21', 1, 1, 0, 0, 0, '2024-10-26 03:02:42.361662', '2024-10-26 02:56:18.575776');
INSERT INTO mesa VALUES (2, 1, 'A', 2790, 'PUENTE ALTO', 'PUENTE ALTO', 'liceo industrial', 'MESA  8', 1, 1, 0, 0, 0, '2024-10-26 03:02:46.9648', '2024-10-26 02:55:24.303827');
INSERT INTO mesa VALUES (15, 1, 'A', 2777, 'ÑUÑOA', 'ÑUÑOA', 'Colegio Akros', 'MESA  16', 1, 1, 0, 0, 0, '2024-10-26 03:12:41.917452', '2024-10-26 03:11:54.481985');
INSERT INTO mesa VALUES (9, 1, 'A', 2766, 'LA CISTERNA', 'LA CISTERNA', 'Chilean Eagles College', 'MESA  18', 1, 1, 0, 0, 0, '2024-10-26 03:04:52.793637', '2024-10-26 03:03:54.268646');
INSERT INTO mesa VALUES (8, 1, 'A', 2769, 'LA PINTANA', 'LA PINTANA', 'San José de la Familia', 'MESA  8', 1, 1, 0, 0, 0, '2024-10-26 03:15:17.740838', '2024-10-26 03:01:03.049343');
INSERT INTO mesa VALUES (10, 1, 'A', 2767, 'LA FLORIDA', 'LA FLORIDA', 'Colegio La Concepción', 'MESA  22', 1, 1, 0, 0, 0, '2024-10-26 03:05:53.2373', '2024-10-26 03:05:11.371011');
INSERT INTO mesa VALUES (11, 1, 'A', 2776, 'MAIPU', 'MAIPU', 'Liceo Nacional de Maipú', 'MESA  15', 1, 1, 0, 0, 0, '2024-10-26 03:07:18.052385', '2024-10-26 03:06:21.982788');
INSERT INTO mesa VALUES (12, 1, 'A', 2763, 'ESTACION CENTRAL', 'ESTACION CENTRAL', 'The Greenland School', 'MESA  7', 1, 1, 0, 0, 0, '2024-10-26 03:08:27.554898', '2024-10-26 03:07:54.395772');
INSERT INTO mesa VALUES (13, 1, 'A', 2789, 'VITACURA', 'VITACURA', 'Colegio Santa Ursula', 'MESA  9', 1, 1, 0, 0, 0, '2024-10-26 03:09:35.590549', '2024-10-26 03:09:07.506392');


--
-- Name: mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('mesa_id_seq', 15, true);


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('mesa_mesa_id_seq', 1, false);


--
-- Data for Name: pacto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO pacto VALUES (403, 'A', 'POR CHILE, SEGUIMOS');
INSERT INTO pacto VALUES (431, 'B', 'IZQUIERDA ECOLOGISTA POPULAR');
INSERT INTO pacto VALUES (433, 'B', 'IZQUIERDA ECOLOGISTA POPULAR');
INSERT INTO pacto VALUES (430, 'B', 'IZQUIERDA ECOLOGISTA POPULAR');
INSERT INTO pacto VALUES (432, 'B', 'IZQUIERDA ECOLOGISTA POPULAR');
INSERT INTO pacto VALUES (458, 'C', 'TODAS Y TODOS POR CHILE');
INSERT INTO pacto VALUES (442, 'D', 'DEMOCRATAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (394, 'E', 'CHILE VAMOS UDI-EVOPOLI E INDEPENDIENTES');
INSERT INTO pacto VALUES (387, 'F', 'PARTIDO SOCIAL CRISTIANO E INDEPENDIENTES');
INSERT INTO pacto VALUES (399, 'F', 'PARTIDO SOCIAL CRISTIANO E INDEPENDIENTES');
INSERT INTO pacto VALUES (386, 'F', 'PARTIDO SOCIAL CRISTIANO E INDEPENDIENTES');
INSERT INTO pacto VALUES (397, 'F', 'PARTIDO SOCIAL CRISTIANO E INDEPENDIENTES');
INSERT INTO pacto VALUES (405, 'G', 'VERDES LIBERALES POR UNA COMUNA SEGURA');
INSERT INTO pacto VALUES (401, 'H', 'CONTIGO CHILE MEJOR');
INSERT INTO pacto VALUES (393, 'I', 'CHILE VAMOS RENOVACION NACIONAL - INDEPENDIENTES');
INSERT INTO pacto VALUES (392, 'I', 'CHILE VAMOS RENOVACIÓN NACIONAL - INDEPENDIENTES');
INSERT INTO pacto VALUES (443, 'J', 'AMARILLOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (428, 'K', 'IZQUIERDA DE TRABAJADORES E INDEPENDIENTES');
INSERT INTO pacto VALUES (429, 'K', 'IZQUIERDA DE TRABAJADORES E INDEPENDIENTES');
INSERT INTO pacto VALUES (456, 'L', 'TU REGION RADICAL');
INSERT INTO pacto VALUES (457, 'L', 'TU REGION RADICAL');
INSERT INTO pacto VALUES (461, 'M', 'REGIONES VERDES LIBERALES');
INSERT INTO pacto VALUES (462, 'M', 'REGIONES VERDES LIBERALES');
INSERT INTO pacto VALUES (463, 'N', 'LO MEJOR PARA CHILE');
INSERT INTO pacto VALUES (466, 'O', 'POR CHILE Y SUS REGIONES');
INSERT INTO pacto VALUES (418, 'P', 'PARTIDO DE LA GENTE E INDEPENDIENTES');
INSERT INTO pacto VALUES (416, 'P', 'PARTIDO DE LA GENTE E INDEPENDIENTES');
INSERT INTO pacto VALUES (417, 'P', 'PARTIDO DE LA GENTE E INDEPENDIENTES');
INSERT INTO pacto VALUES (419, 'P', 'PARTIDO DE LA GENTE E INDEPENDIENTES');
INSERT INTO pacto VALUES (455, 'Q', 'POR UN CHILE MEJOR');
INSERT INTO pacto VALUES (454, 'Q', 'POR UN CHILE MEJOR');
INSERT INTO pacto VALUES (446, 'R', 'CENTRO DEMOCRATICO');
INSERT INTO pacto VALUES (444, 'R', 'CENTRO DEMOCRATICO');
INSERT INTO pacto VALUES (445, 'R', 'CENTRO DEMOCRATICO');
INSERT INTO pacto VALUES (451, 'S', 'FRENTE AMPLIO');
INSERT INTO pacto VALUES (404, 'T', 'TU COMUNA RADICAL');
INSERT INTO pacto VALUES (402, 'U', 'CHILE MUCHO MEJOR');
INSERT INTO pacto VALUES (395, 'V', 'CHILE VAMOS UDI - INDEPENDIENTES');
INSERT INTO pacto VALUES (390, 'W', 'CHILE VAMOS EVOPOLI - INDEPENDIENTES');
INSERT INTO pacto VALUES (426, 'X', 'ECOLOGISTAS, ANIMALISTAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (424, 'X', 'ECOLOGISTAS, ANIMALISTAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (427, 'X', 'ECOLOGISTAS, ANIMALISTAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (425, 'X', 'ECOLOGISTAS, ANIMALISTAS E INDEPENDIENTES');
INSERT INTO pacto VALUES (437, 'Y', 'REPUBLICANOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (438, 'Y', 'REPUBLICANOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (439, 'Y', 'REPUBLICANOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (440, 'Y', 'REPUBLICANOS E INDEPENDIENTES');
INSERT INTO pacto VALUES (398, 'Z', 'CHILE VAMOS');
INSERT INTO pacto VALUES (400, 'Z', 'CHILE VAMOS');
INSERT INTO pacto VALUES (999, '0', 'INDEPENDIENTES');


--
-- Name: pacto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('pacto_id_seq', 1, false);


--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('pacto_pacto_id_seq', 1, false);


--
-- Data for Name: partido; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO partido VALUES (2, 'PARTIDO DEMOCRATA CRISTIANO', 'DC');
INSERT INTO partido VALUES (6, 'PARTIDO COMUNISTA DE CHILE', 'PC');
INSERT INTO partido VALUES (37, 'EVOLUCION POLITICA', 'EVO');
INSERT INTO partido VALUES (130, 'FEDERACION REGIONALISTA VERDE SOCIAL', 'FRVS');
INSERT INTO partido VALUES (150, 'PARTIDO REPUBLICANO DE CHILE', 'REP');
INSERT INTO partido VALUES (191, 'MOVIMIENTO AMARILLOS POR CHILE', 'AMA');
INSERT INTO partido VALUES (198, 'PARTIDO DEMOCRATAS CHILE', 'DEM');
INSERT INTO partido VALUES (200, 'PARTIDO ALIANZA VERDE POPULAR', 'AVP');
INSERT INTO partido VALUES (201, 'IGUALDAD', 'PIG');
INSERT INTO partido VALUES (203, 'POPULAR', 'PP');
INSERT INTO partido VALUES (220, 'PARTIDO DE TRABAJADORES REVOLUCIONARIOS', 'PTRV');
INSERT INTO partido VALUES (1, 'RENOVACION NACIONAL', 'RN');
INSERT INTO partido VALUES (3, 'UNION DEMOCRATA INDEPENDIENTE', 'UDI');
INSERT INTO partido VALUES (4, 'PARTIDO POR LA DEMOCRACIA', 'PPD');
INSERT INTO partido VALUES (5, 'PARTIDO SOCIALISTA DE CHILE', 'PS');
INSERT INTO partido VALUES (7, 'PARTIDO RADICAL DE CHILE', 'PR');
INSERT INTO partido VALUES (99, 'INDEPENDIENTES', 'IND');
INSERT INTO partido VALUES (137, 'PARTIDO LIBERAL DE CHILE', 'PL');
INSERT INTO partido VALUES (157, 'PARTIDO DE LA GENTE', 'PDG');
INSERT INTO partido VALUES (188, 'PARTIDO HUMANISTA', 'PH');
INSERT INTO partido VALUES (190, 'PARTIDO ACCIÓN HUMANISTA', 'AH');
INSERT INTO partido VALUES (197, 'PARTIDO SOCIAL CRISTIANO', 'PSC');
INSERT INTO partido VALUES (232, 'FRENTE AMPLIO', 'FA');


--
-- Name: partido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('partido_id_seq', 1, true);


--
-- Name: partido_partido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('partido_partido_id_seq', 1, false);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO region VALUES (3015, 'DE ARICA Y PARINACOTA', 'XV');
INSERT INTO region VALUES (3001, 'DE TARAPACA', 'I');
INSERT INTO region VALUES (3002, 'DE ANTOFAGASTA', 'II');
INSERT INTO region VALUES (3003, 'DE ATACAMA', 'III');
INSERT INTO region VALUES (3004, 'DE COQUIMBO', 'IV');
INSERT INTO region VALUES (3005, 'DE VALPARAISO', 'V');
INSERT INTO region VALUES (3013, 'METROPOLITANA', 'XIII');
INSERT INTO region VALUES (3006, 'DE OHIGGINS', 'VI');
INSERT INTO region VALUES (3007, 'DEL MAULE', 'VII');
INSERT INTO region VALUES (3016, 'DE ÑUBLE', 'XVI');
INSERT INTO region VALUES (3008, 'DEL BIOBIO', 'VIII');
INSERT INTO region VALUES (3009, 'DE LA ARAUCANIA', 'IX');
INSERT INTO region VALUES (3014, 'DE LOS RIOS', 'XIV');
INSERT INTO region VALUES (3010, 'DE LOS LAGOS', 'X');
INSERT INTO region VALUES (3011, 'DE AYSEN', 'XI');
INSERT INTO region VALUES (3012, 'DE MAGALLANES', 'XII');


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('region_id_seq', 1, false);


--
-- Name: region_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('region_region_id_seq', 1, false);


--
-- Data for Name: swich; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO swich VALUES (2, 4, 14, 3, 9, 10, '0', '2024-10-25 10:02:53.969109', 0);
INSERT INTO swich VALUES (1, 2, 8, 6, 0, 0, '0', '2024-10-26 03:15:46.561739', 0);


--
-- Name: swich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('swich_id_seq', 2, true);


--
-- Name: swich_swich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('swich_swich_id_seq', 1, false);


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO usuario VALUES (1, 'AD', 1, 'm', 'Administrador', 'admin', 'admin2023', 3, '2020-03-10 10:33:05.700099', '2020-03-10 10:33:05.700099');
INSERT INTO usuario VALUES (2, 'OP', 1, 'n', 'Prensa 1', 'prensa1', 'pwd', 1, '2021-05-15 19:06:10.580988', '2021-05-15 19:06:10.580988');
INSERT INTO usuario VALUES (3, 'OP', 1, 'n', 'Prensa 2', 'prensa2', 'pwd', 1, '2021-05-16 12:02:19.180109', '2021-05-16 12:02:19.180109');
INSERT INTO usuario VALUES (4, 'OP', 1, 'n', 'Prensa 3', 'prensa3', 'pwd', 1, '2021-05-16 12:09:04.143502', '2021-05-16 12:09:04.143502');
INSERT INTO usuario VALUES (5, 'OP', 1, 'n', 'Prensa 4', 'prensa4', 'pwd', 1, '2021-05-16 12:30:59.800617', '2021-05-16 12:30:59.800617');
INSERT INTO usuario VALUES (6, 'OP', 1, 'n', 'Prensa 5', 'prensa5', 'pwd', 1, '2021-05-16 12:32:27.107286', '2021-05-16 12:32:27.107286');
INSERT INTO usuario VALUES (7, 'OP', 1, 'n', 'Prensa 6', 'prensa6', 'pwd', 1, '2021-05-16 12:32:44.65376', '2021-05-16 12:32:44.65376');
INSERT INTO usuario VALUES (8, 'OP', 1, 'n', 'Prensa 7', 'prensa7', 'pwd', 1, '2021-05-16 12:33:04.883941', '2021-05-16 12:33:04.883941');
INSERT INTO usuario VALUES (9, 'OP', 1, 'n', 'Prensa 8', 'prensa8', 'pwd', 1, '2021-05-16 12:33:26.60897', '2021-05-16 12:33:26.60897');
INSERT INTO usuario VALUES (10, 'OP', 1, 'n', 'Prensa 9', 'prensa9', 'pwd', 1, '2021-05-16 12:33:42.400539', '2021-05-16 12:33:42.400539');
INSERT INTO usuario VALUES (11, 'OP', 1, 'n', 'Prensa 10', 'prensa10', 'pwd', 1, '2021-05-16 12:34:02.97873', '2021-05-16 12:34:02.97873');
INSERT INTO usuario VALUES (12, 'OP', 1, 'n', 'Prensa 11', 'prensa11', 'pwd', 1, '2022-09-01 14:28:40.919892', '2022-09-01 14:28:40.919892');
INSERT INTO usuario VALUES (13, 'OP', 1, 'n', 'Prensa 12', 'prensa12', 'pwd', 1, '2022-09-01 14:29:08.372841', '2022-09-01 14:29:08.372841');
INSERT INTO usuario VALUES (14, 'OP', 1, 'n', 'Prensa 13', 'prensa13', 'pwd', 1, '2022-09-01 14:29:25.917857', '2022-09-01 14:29:25.917857');
INSERT INTO usuario VALUES (15, 'OP', 1, 'n', 'Prensa 14', 'prensa14', 'pwd', 1, '2022-09-01 14:29:49.173472', '2022-09-01 14:29:49.173472');
INSERT INTO usuario VALUES (16, 'OP', 1, 'n', 'Prensa 15', 'prensa15', 'pwd', 1, '2022-09-01 14:30:14.271053', '2022-09-01 14:30:14.271053');
INSERT INTO usuario VALUES (17, 'OP', 1, 'n', 'Prensa 16', 'prensa16', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (18, 'OP', 1, 'n', 'Prensa 17', 'prensa17', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (19, 'OP', 1, 'n', 'Prensa 18', 'prensa18', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (20, 'OP', 1, 'n', 'Prensa 19', 'prensa19', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (21, 'OP', 1, 'n', 'Prensa 20', 'prensa20', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (22, 'OP', 1, 'n', 'Prensa 21', 'prensa21', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (23, 'OP', 1, 'n', 'Prensa 22', 'prensa22', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (24, 'OP', 1, 'n', 'Prensa 23', 'prensa23', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (25, 'OP', 1, 'n', 'Prensa 24', 'prensa24', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (26, 'OP', 1, 'n', 'Prensa 25', 'prensa25', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (27, 'OP', 1, 'n', 'Prensa 26', 'prensa26', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (28, 'OP', 1, 'n', 'Prensa 27', 'prensa27', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (29, 'OP', 1, 'n', 'Prensa 28', 'prensa28', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (30, 'OP', 1, 'n', 'Prensa 29', 'prensa29', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (31, 'OP', 1, 'n', 'Prensa 30', 'prensa30', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (32, 'OP', 1, 'n', 'Prensa 31', 'prensa31', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (33, 'OP', 1, 'n', 'Prensa 32', 'prensa32', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (34, 'OP', 1, 'n', 'Prensa 33', 'prensa33', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (35, 'OP', 1, 'n', 'Prensa 34', 'prensa34', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (36, 'OP', 1, 'n', 'Prensa 35', 'prensa35', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (37, 'OP', 1, 'n', 'Prensa 36', 'prensa36', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (38, 'OP', 1, 'n', 'Prensa 37', 'prensa37', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (39, 'OP', 1, 'n', 'Prensa 38', 'prensa38', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (40, 'OP', 1, 'n', 'Prensa 39', 'prensa39', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (41, 'OP', 1, 'n', 'Prensa 40', 'prensa40', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (42, 'OP', 1, 'n', 'Prensa 41', 'prensa41', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (43, 'OP', 1, 'n', 'Prensa 42', 'prensa42', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (44, 'OP', 1, 'n', 'Prensa 43', 'prensa43', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (45, 'OP', 1, 'n', 'Prensa 44', 'prensa44', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (46, 'OP', 1, 'n', 'Prensa 45', 'prensa45', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (47, 'OP', 1, 'n', 'Prensa 46', 'prensa46', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (48, 'OP', 1, 'n', 'Prensa 47', 'prensa47', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (49, 'OP', 1, 'n', 'Prensa 48', 'prensa48', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (50, 'OP', 1, 'n', 'Prensa 49', 'prensa49', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (51, 'OP', 1, 'n', 'Prensa 50', 'prensa50', 'pwd', 1, '2023-05-07 12:22:50.151745', '2023-05-07 12:22:50.151745');
INSERT INTO usuario VALUES (52, 'VZ', 1, 'n', 'Tv', 'tv', 'tv', 1, '2022-09-02 08:25:13.05714', '2022-09-02 08:25:13.05714');


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('usuario_id_seq', 54, true);


--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('usuario_usuario_id_seq', 1, false);


--
-- Data for Name: voto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

INSERT INTO voto VALUES (105, 17414523, 2, 10);
INSERT INTO voto VALUES (109, 16213619, 3, 0);
INSERT INTO voto VALUES (112, 13924988, 3, 0);
INSERT INTO voto VALUES (113, 11633534, 3, 0);
INSERT INTO voto VALUES (100, 17611305, 1, 0);
INSERT INTO voto VALUES (110, 16666357, 3, 10);
INSERT INTO voto VALUES (114, 6370431, 3, 10);
INSERT INTO voto VALUES (111, 17029781, 3, 10);
INSERT INTO voto VALUES (115, 10966406, 4, 0);
INSERT INTO voto VALUES (117, 16699398, 4, 0);
INSERT INTO voto VALUES (102, 16074387, 1, 0);
INSERT INTO voto VALUES (119, 13924893, 4, 10);
INSERT INTO voto VALUES (116, 19442140, 4, 10);
INSERT INTO voto VALUES (118, 17704129, 4, 10);
INSERT INTO voto VALUES (121, 16480551, 5, 0);
INSERT INTO voto VALUES (122, 11631921, 5, 10);
INSERT INTO voto VALUES (123, 13698753, 5, 10);
INSERT INTO voto VALUES (120, 14329979, 5, 10);
INSERT INTO voto VALUES (126, 6003965, 6, 0);
INSERT INTO voto VALUES (128, 10949299, 6, 0);
INSERT INTO voto VALUES (127, 16428509, 6, 10);
INSERT INTO voto VALUES (125, 12245832, 6, 10);
INSERT INTO voto VALUES (124, 12890799, 6, 10);
INSERT INTO voto VALUES (129, 17176403, 7, 0);
INSERT INTO voto VALUES (131, 12090358, 7, 0);
INSERT INTO voto VALUES (133, 12043065, 7, 0);
INSERT INTO voto VALUES (130, 15400920, 7, 10);
INSERT INTO voto VALUES (132, 12670694, 7, 10);
INSERT INTO voto VALUES (101, 17604080, 1, 10);
INSERT INTO voto VALUES (104, 11313457, 1, 10);
INSERT INTO voto VALUES (103, 11838331, 1, 10);
INSERT INTO voto VALUES (107, 10215047, 2, 0);
INSERT INTO voto VALUES (134, 13450797, 7, 10);
INSERT INTO voto VALUES (136, 15421464, 8, 0);
INSERT INTO voto VALUES (106, 15329993, 2, 10);
INSERT INTO voto VALUES (108, 18628555, 2, 10);
INSERT INTO voto VALUES (138, 8967685, 8, 0);
INSERT INTO voto VALUES (137, 7353071, 8, 10);
INSERT INTO voto VALUES (139, 12276169, 8, 10);
INSERT INTO voto VALUES (135, 10211329, 8, 10);
INSERT INTO voto VALUES (140, 15454284, 9, 0);
INSERT INTO voto VALUES (143, 14186880, 9, 0);
INSERT INTO voto VALUES (141, 12682440, 9, 10);
INSERT INTO voto VALUES (142, 10931125, 9, 10);
INSERT INTO voto VALUES (144, 7436441, 9, 10);
INSERT INTO voto VALUES (147, 16361186, 10, 0);
INSERT INTO voto VALUES (149, 16091531, 10, 0);
INSERT INTO voto VALUES (145, 11993445, 10, 10);
INSERT INTO voto VALUES (146, 12079467, 10, 10);
INSERT INTO voto VALUES (148, 10662465, 10, 10);
INSERT INTO voto VALUES (150, 14339658, 11, 0);
INSERT INTO voto VALUES (153, 15128766, 11, 0);
INSERT INTO voto VALUES (155, 10197539, 11, 0);
INSERT INTO voto VALUES (154, 10581606, 11, 10);
INSERT INTO voto VALUES (152, 17269650, 11, 10);
INSERT INTO voto VALUES (151, 17697418, 11, 10);
INSERT INTO voto VALUES (156, 15330578, 12, 0);
INSERT INTO voto VALUES (157, 8664704, 12, 10);
INSERT INTO voto VALUES (158, 6696750, 12, 10);
INSERT INTO voto VALUES (159, 9035888, 12, 10);
INSERT INTO voto VALUES (161, 9992086, 13, 0);
INSERT INTO voto VALUES (160, 9965040, 13, 10);
INSERT INTO voto VALUES (163, 10617441, 13, 10);
INSERT INTO voto VALUES (162, 10696137, 13, 10);
INSERT INTO voto VALUES (164, 15837533, 14, 0);
INSERT INTO voto VALUES (165, 13071182, 14, 0);
INSERT INTO voto VALUES (167, 10237625, 14, 0);
INSERT INTO voto VALUES (166, 16370245, 14, 10);
INSERT INTO voto VALUES (169, 10849593, 14, 10);
INSERT INTO voto VALUES (168, 12902355, 14, 10);
INSERT INTO voto VALUES (171, 16609644, 15, 0);
INSERT INTO voto VALUES (170, 10809043, 15, 10);
INSERT INTO voto VALUES (172, 12863183, 15, 10);
INSERT INTO voto VALUES (173, 10273010, 15, 10);


--
-- Name: voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('voto_id_seq', 173, true);


--
-- Name: voto_voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('voto_voto_id_seq', 1, false);


--
-- Name: candidato_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_pkey PRIMARY KEY (candidato_id);


--
-- Name: comuna_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY comuna
    ADD CONSTRAINT comuna_pkey PRIMARY KEY (comuna_id);


--
-- Name: imagen_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY imagen
    ADD CONSTRAINT imagen_pkey PRIMARY KEY (imagen_id);


--
-- Name: mesa_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY mesa
    ADD CONSTRAINT mesa_pkey PRIMARY KEY (mesa_id);


--
-- Name: pacto_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY pacto
    ADD CONSTRAINT pacto_pkey PRIMARY KEY (pacto_id);


--
-- Name: partido_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY partido
    ADD CONSTRAINT partido_pkey PRIMARY KEY (partido_id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);


--
-- Name: swich_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY swich
    ADD CONSTRAINT swich_pkey PRIMARY KEY (swich_id);


--
-- Name: usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (usuario_id);


--
-- Name: voto_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT voto_pkey PRIMARY KEY (voto_id);


--
-- Name: candidato_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT candidato_id_fk FOREIGN KEY (candidato_id) REFERENCES candidato(candidato_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: candidato_pacto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_pacto_id_fkey FOREIGN KEY (pacto_id) REFERENCES pacto(pacto_id) ON DELETE CASCADE;


--
-- Name: candidato_partido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_partido_id_fkey FOREIGN KEY (partido_id) REFERENCES partido(partido_id) ON DELETE CASCADE;


--
-- Name: comuna_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY comuna
    ADD CONSTRAINT comuna_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id) ON DELETE RESTRICT;


--
-- Name: mesa_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT mesa_id_fk FOREIGN KEY (mesa_id) REFERENCES mesa(mesa_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mesa_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY mesa
    ADD CONSTRAINT mesa_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO app_vav;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: candidato; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE candidato FROM PUBLIC;
REVOKE ALL ON TABLE candidato FROM app_vav;
GRANT ALL ON TABLE candidato TO app_vav;


--
-- Name: comuna; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE comuna FROM PUBLIC;
REVOKE ALL ON TABLE comuna FROM app_vav;
GRANT ALL ON TABLE comuna TO app_vav;


--
-- Name: mesa; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE mesa FROM PUBLIC;
REVOKE ALL ON TABLE mesa FROM app_vav;
GRANT ALL ON TABLE mesa TO app_vav;


--
-- Name: pacto; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE pacto FROM PUBLIC;
REVOKE ALL ON TABLE pacto FROM app_vav;
GRANT ALL ON TABLE pacto TO app_vav;


--
-- Name: partido; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE partido FROM PUBLIC;
REVOKE ALL ON TABLE partido FROM app_vav;
GRANT ALL ON TABLE partido TO app_vav;


--
-- Name: region; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE region FROM PUBLIC;
REVOKE ALL ON TABLE region FROM app_vav;
GRANT ALL ON TABLE region TO app_vav;


--
-- Name: voto; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE voto FROM PUBLIC;
REVOKE ALL ON TABLE voto FROM app_vav;
GRANT ALL ON TABLE voto TO app_vav;


--
-- PostgreSQL database dump complete
--

