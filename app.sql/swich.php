<?php
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD SQL PARA EL SWICH
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Configuracion Inicial
	include_once "../configuracion.php";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	Librerias Necesarias
	require_once("$_FUNCIONES/sql.php");
	require_once("$_FUNCIONES/filtros.php");
	require_once("$_FUNCIONES/fechas.php");
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Recibir Funcion Requerida
	$FUNCION										=	filtrarVAR($_REQUEST['f']);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	Arbol de Funciones
	switch($FUNCION)
	{
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Swich Editar
		case "swichEditar"							:
		{
		//	Obtener Variables
			$swich_id								=	filtrarID($_POST['swich_id']);
			$swich_modo								=	filtrarID($_POST['swich_modo']);
			$swich_mesas							=	filtrarID($_POST['swich_mesas']);
			$swich_mesa_1							=	filtrarID($_POST['swich_mesa_1']);
			$swich_mesa_2							=	filtrarID($_POST['swich_mesa_2']);
			$swich_mesa_3							=	filtrarID($_POST['swich_mesa_3']);
			$swich_mesa_4							=	filtrarID($_POST['swich_mesa_4']);
			$swich_votos							=	filtrarVAR($_POST['swich_votos']);

		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM
				swich_editar
				(
					$swich_id,
					$swich_modo,
					$swich_mesas,
					$swich_mesa_1,
					$swich_mesa_2,
					$swich_mesa_3,
					$swich_mesa_4,
					'$swich_votos'
				);
			
			";

		//	Ejecutar Query
			$QUERY_SWICH_EDITAR						=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_SWICH_EDITAR							=	pg_fetch_object($QUERY_SWICH_EDITAR);
			
			echo $_SWICH_EDITAR->swich_editar;
		}
		break;
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener Mesas del Swich
		case "swichMesas"							:
		{
		//	Construir SQL
			$QUERY									=	"
		
				SELECT * FROM mesa_listado( 100 , 0 );
		
			";
		
		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);
		
		//	Generar listado
			while($_MESA							=	pg_fetch_object($QUERY_MESAS))
			{
			//	Crear Array
				$_RESULTADOS[$_MESA->mesa_id]		=	array	
				(
					'mesa_id'						=>	$_MESA->mesa_id,
					'mesa_nombre'					=>	$_MESA->mesa_nombre,
					'mesa_numero'					=>	$_MESA->mesa_numero,
					'mesa_voto_a'					=>	$_MESA->mesa_voto_a,
					'mesa_voto_r'					=>	$_MESA->mesa_voto_r,
					'mesa_voto_cm'					=>	$_MESA->mesa_voto_cm,
					'mesa_voto_cc'					=>	$_MESA->mesa_voto_cc
				);
			}
			
		//	Encodear a Json el Colector
			$_JSON									=	json_encode($_RESULTADOS);
			
		//	Escribir resultado
			echo($_JSON);
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener Mesas del Swich
		case "swichMesasActuales"					:
		{
		//	Obtener Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_actual();
		
			";
		
		//	Ejecutar Query
			$QUERY_SWICH_MESAS						=	pg_query($CONF_DB_CONNECT, $QUERY);
			$_SWICH_MESAS							=	pg_fetch_object($QUERY_SWICH_MESAS);

		//	Obtener la información de las Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_mesas( $_SWICH_MESAS->swich_mesa_1 , $_SWICH_MESAS->swich_mesa_2 , $_SWICH_MESAS->swich_mesa_3 );
		
			";
			
		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);
			
			$MESA_ID = 0;

		//	Generar listado
			while($_MESA							=	pg_fetch_object($QUERY_MESAS))
			{
			//	Construir SQL
				$QUERY								=	"SELECT * FROM mesa_candidatos_swich( $_MESA->mesa_id );";
			
			//	Ejecutar Query
				$QUERY_MESA_CANDIDATOS				=	pg_query($CONF_DB_CONNECT, $QUERY);
			
				$_CANDIDATOS['candidatos']			=	array();

			//	Obtener listado de candidatos
				while($_MESA_CANDIDATOS				=	pg_fetch_object($QUERY_MESA_CANDIDATOS))
				{
				//	Asignar información del candidato
					$_CANDIDATOS['candidatos'][]			=	array	
					(
						'objeto'					=>	(int) $_MESA_CANDIDATOS->voto_id,
						'id'						=>	(int) $_MESA_CANDIDATOS->candidato_id,
						'nombres'					=>	$_MESA_CANDIDATOS->candidato_nombres,
						'apellidos'					=>	$_MESA_CANDIDATOS->candidato_apellidos,
						'ind'						=>	$_MESA_CANDIDATOS->candidato_independiente,
						'genero'					=>	$_MESA_CANDIDATOS->candidato_genero,
						'votos'						=>	(int) $_MESA_CANDIDATOS->voto_total,
						'partido'					=>	$_MESA_CANDIDATOS->partido_codigo,
						'partido_id'				=>	(int) $_MESA_CANDIDATOS->partido_id,
						'pacto'						=>	$_MESA_CANDIDATOS->pacto_codigo,
						'pacto_id'					=>	(int) $_MESA_CANDIDATOS->pacto_id
					);
				}

			//	Crear Array
				$_OBJETO['mesas'][$_MESA->mesa_id]					=	array	
				(
					'id' => (int) $_MESA->mesa_id,
					'tipo' => $_MESA->mesa_tipo,
					'zona_id' => $_MESA->mesa_zona,
					'zona' => $_MESA->mesa_zona_titulo,
					'comuna' => $_MESA->mesa_comuna,
					'local' => $_MESA->mesa_local,
					'numero' => $_MESA->mesa_numero,
					'candidatos' =>	$_CANDIDATOS['candidatos']
				);

				$MESA_ID++;
			}

			if( $MESA_ID == 0 )
			{
				$_OBJETO['mesas']					=	array();
			}
			
		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Encodear Resultados
			$_JSON									=	json_encode($_OBJETO);

		//	Asignar formato Json
			header('Content-Type: application/json');

		//	Generar Json con los Datos
			echo $_JSON;
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener Mesas Consolidadas
		case "swichMesasTotales"					:
		{
		//	Obtener Mesas almacenadas en el Swich
			$QUERY									=	"
				
				SELECT
					COUNT( mesa.mesa_id )

				FROM
					mesa
				
				WHERE
					mesa.mesa_tipo = 'P' AND
					mesa.mesa_estado IN(1,2) AND
					mesa.mesa_zona = 3013

			";

		//	Ejecutar Query
			$QUERY_TOTAL_MESAS						=	pg_query($CONF_DB_CONNECT, $QUERY);
			$_TOTAL_MESAS							=	pg_fetch_object($QUERY_TOTAL_MESAS);

		//	Obtener la información de las Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT
					sum(voto.voto_total) as votos_total,
					candidato.candidato_id,
					candidato.candidato_nombres,
					candidato.candidato_apellidos,
					candidato.candidato_independiente,
					partido.partido_codigo,
					partido.partido_id,
					pacto.pacto_nombre,
					pacto.pacto_id

				FROM
					mesa,
					voto,
					candidato,
					partido,
					pacto

				WHERE
					mesa.mesa_tipo = 'P' AND
					mesa.mesa_zona = 3013 AND
					mesa.mesa_estado IN(1,2) AND
					voto.mesa_id = mesa.mesa_id AND
					candidato.candidato_id = voto.candidato_id AND
					partido.partido_id = candidato.partido_id AND
					pacto.pacto_id = candidato.pacto_id
							
				group by
					candidato.candidato_id,
					candidato.candidato_apellidos,
					partido.partido_codigo,
					partido.partido_id,
					pacto.pacto_nombre,
					pacto.pacto_id
				
				ORDER BY
					votos_total DESC;
		
			";
			
		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	Listado de Candidatos
			$_CANDIDATOS['candidatos']				=	array();
			$_CANDIDATOS['votos']					=	(int) 0;
			$_CANDIDATOS['mesas']					=	(int) $_TOTAL_MESAS->count;

		//	Generar listado
			while($_MESA_CANDIDATOS					=	pg_fetch_object($QUERY_MESAS))
			{
			//	Asignar información del candidato
				$_CANDIDATOS['candidatos'][]		=	array	
				(
					'id'							=>	(int) $_MESA_CANDIDATOS->candidato_id,
					'nombres'						=>	strtolower($_MESA_CANDIDATOS->candidato_nombres),
					'apellidos'						=>	strtolower($_MESA_CANDIDATOS->candidato_apellidos),
					'ind'							=>	$_MESA_CANDIDATOS->candidato_independiente,
					'votos'							=>	(int) $_MESA_CANDIDATOS->votos_total,
					'partido'						=>	$_MESA_CANDIDATOS->partido_codigo,
					'partido_id'					=>	(int) $_MESA_CANDIDATOS->partido_id,
					'pacto'							=>	$_MESA_CANDIDATOS->pacto_nombre,
					'pacto_id'						=>	(int) $_MESA_CANDIDATOS->pacto_id
				);

				$_CANDIDATOS['votos'] += $_MESA_CANDIDATOS->votos_total;
			}

		//	Encodear Resultados
			$_JSON									=	json_encode($_CANDIDATOS);

		//	Asignar formato Json
			header('Content-Type: application/json');

		//	Generar Json con los Datos
			echo $_JSON;
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener Mesas del Swich
		case "swichMesasActualesR"					:
		{
		//	Obtener Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_actual();
		
			";
		
		//	Ejecutar Query
			$QUERY_SWICH_MESAS						=	pg_query($CONF_DB_CONNECT, $QUERY);
			$_SWICH_MESAS							=	pg_fetch_object($QUERY_SWICH_MESAS);

		//	Obtener la información de las Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_mesas( $_SWICH_MESAS->swich_mesa_1 , $_SWICH_MESAS->swich_mesa_2 , $_SWICH_MESAS->swich_mesa_3 );
		
			";
			
		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Generar listado
			while($_MESA							=	pg_fetch_object($QUERY_MESAS))
			{
			//	Crear Array
				$_OBJETO['mesas'][$_MESA->mesa_id]		=	array	
				(
					'mesa_id'						=>	(int) $_MESA->mesa_id,
					'mesa_tipo'						=>	$_MESA->mesa_tipo,
					'mesa_zona_titulo'				=>	$_MESA->mesa_zona_titulo,
					'mesa_comuna'					=>	$_MESA->mesa_comuna,
					'mesa_local'					=>	$_MESA->mesa_local,
					'mesa_numero'					=>	$_MESA->mesa_numero
				);

			//	Construir SQL
				$QUERY									=	"SELECT * FROM mesa_candidatos_swich( $_MESA->mesa_id );";
			
			//	Ejecutar Query
				$QUERY_MESA_CANDIDATOS					=	pg_query($CONF_DB_CONNECT, $QUERY);
			
			//	Obtener listado de candidatos
				while($_MESA_CANDIDATOS					=	pg_fetch_object($QUERY_MESA_CANDIDATOS))
				{
				//	Validar candidato independiente
					if($_MESA_CANDIDATOS->candidato_independiente == 't')
					{
						if($_MESA_CANDIDATOS->partido_codigo == 'IND')
						{
							$partido = 'IND';
							$variacion = 0;
						}
						else
						{
							$partido = 'IND-'.$_MESA_CANDIDATOS->partido_codigo;
							$variacion = 1;
						}
					}
					else
					{
						$partido = $_MESA_CANDIDATOS->partido_codigo;
						$variacion = 0;
					}

				//	Asignar información del candidato
					$_OBJETO['mesas'][$_MESA->mesa_id]['candidatos'][]			=	array	
					(
						'objeto'						=>	(int) $_MESA_CANDIDATOS->voto_id,
						'id'							=>	(int) $_MESA_CANDIDATOS->candidato_id,
						'nombre'						=>	$_MESA_CANDIDATOS->candidato_nombre_corto,
						'votos'							=>	(int) $_MESA_CANDIDATOS->voto_total,
						'lista'							=>	$_MESA_CANDIDATOS->candidato_lista,
						'genero'						=>	$_MESA_CANDIDATOS->candidato_genero,
						'partido'						=>	$partido
					);
				}
			}
			
		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Encodear Resultados
			$_JSON									=	json_encode($_OBJETO);

		//	Asignar formato Json
			header('Content-Type: application/json');

		//	Generar Json con los Datos
			echo $_JSON;
		}
		break;

	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Concción
	pg_close($CONF_DB_CONNECT);
	
?>	