<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

	//	Librerias JS y CSS globales
		include_once "$_COMPONENTES/librerias.js.css.php";

?>

<!--	Libreria Listados	-->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.mesas.js<?php echo $_CONF_VERSION; ?>"></script>
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.consolidados.js<?php echo $_CONF_VERSION; ?>"></script>
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.sorteable.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.listado.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.listado.css<?php echo $_CONF_VERSION; ?>"/>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.formulario.css<?php echo $_CONF_VERSION; ?>"/>

		<!-- Libreria Autocomplate -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.autocomplete.js"></script>

<!--	Livebox	-->		
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>livebox.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>livebox.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Librerias Tipsy -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.tipsy.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>jquery.tipsy.css<?php echo $_CONF_VERSION; ?>"/>
		
<!--	Librerias PubNub -->
		<script src="https://cdn.pubnub.com/sdk/javascript/pubnub.8.2.8.js"></script>
        
<!--	Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Mesas Almacenadas
			var swich_id		=	<?php echo $SWITCH_ID; ?>;
			var swich_modo		=	<?php echo $_SWICH->swich_modo; ?>;
			var swich_mesas		=	<?php echo $_SWICH->swich_mesas; ?>;
			var swich_mesa_1	=	<?php echo $_SWICH->swich_mesa_1; ?>;
			var swich_mesa_2	=	<?php echo $_SWICH->swich_mesa_2; ?>;
			var swich_mesa_3	=	<?php echo $_SWICH->swich_mesa_3; ?>;
			var swich_mesa_4	=	<?php echo $_SWICH->swich_mesa_4; ?>;
			var swich_votos		=	0;

		//	Pubnub Monitoreo de Mesas
		    pubnub = new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>",
				secretKey		:	"<?php echo $_PUBNUB_SECRET_KEY; ?>",
				userId			:	"<?php echo $_PUBNUB_USER_ID; ?>"
		    });

		//	Enviar Información a PubNub
			function enviarPubNub( parametro )
            {
				var publishConfig = {
					channel : "vav_mesas",
					message : parametro
				}
				
				pubnub.publish( publishConfig )
            }

		</script>

<!--	Funcionalidad PubNub -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.mesas.actualizacion.js<?php echo $_CONF_VERSION; ?>"></script>
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.mesas.swich.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias Administrar Swich -->
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>vav.swich.css<?php echo $_CONF_VERSION; ?>"/>

	</head>
	<body>

<?php

	//	Navegacion
		include_once "$_COMPONENTES/navegacion.principal.php";

	//	Header
		include_once "$_COMPONENTES/header.php";

	//	Livebox Editar Mesa
		include_once "$_COMPONENTES/livebox.consolidados.php";

	//	Livebox Fondo
		include_once "$_COMPONENTES/livebox.bg.php";

?>

		<section class="main">
			
			<section class="main-cnt cols x1 margin-bottom">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<header class="titulo-seccion no-border">
						<div class="icono">
							<i class="far fa-window-restore"></i>
						</div>
						<h2 class="icono-on">Administrar Salida TV</h2>
						<h3 class="icono-on">Listado de mesas para despliegue</h3>
						<div class="total-mesas">
							<div id="total-mesas-numero" class="total">15</div>
							<div>
								<div id="total-mesas-valor" class="mesas">Mesas</div>
								<div class="detalles">Disponibles</div>
							</div>
						</div>
						<div class="opciones">
							<div class="input">
								<label>
									<div>Filtrar<br>Mesas</div>
								</label>
							</div>
							<div class="boton activo box-shadow-light bordes-radius tipsy-top" id="opcion-voto-G" title="Gobernadores" onclick="mesa_filtrar('G');">🔴</div>
						</div>
					</header>
				</section>
			</section>
			<section class="main-cnt swich">
				<section class="swich-l">
					<section class="swich-l-scroll relacionados" id="mesas">
<?php
				//	ID del Listado
					$_ID								=	1;

				//	Tipo de Objeto
					$_OBJETO_TIPO						=	'MES';

				//	Listado de Objetos Disponibles
					while($_MESA						=	pg_fetch_object($QUERY_MESAS))
					{
						$mesa_tipo_titulo				=	obtener_titulo($_MESA->mesa_tipo);
						$mesa_tipo_icono				=	obtener_icono($_MESA->mesa_tipo);
?>
					<article class="mesa mesa-swich bg-blanco box-shadow bordes-radius filtro-mesa <?php echo $_MESA->mesa_tipo; ?>"
					id="<?php echo $_OBJETO_TIPO.$_MESA->mesa_id; ?>"
					mesa="<?php echo $_MESA->mesa_id; ?>"
					created="<?php echo $_MESA->mesa_publicado; ?>"
					date="<?php echo $_MESA->mesa_cambio; ?>">
						<div class="mesa-nueva">NUEVA</div>
						<div id="mesa-voto-<?php echo $_MESA->mesa_id; ?>" class="cambios bordes-radius"></div>
						<header>
							<h2 class="<?php echo ($_MESA->mesa_destacada == 1) ? 'importante' : ''; ?>">
								<i class="fas <?php echo ($_MESA->mesa_destacada == 1) ? 'fa-star' : 'fa-hashtag'; ?>"></i>
								<?php echo $_MESA->mesa_id; ?> 
							</h2>
							<div class="tipo"><?php echo $mesa_tipo_titulo; ?></div>
							<div class="zona"><?php echo $_MESA->mesa_zona_titulo; ?></div>
<?php
						if( $_MESA->mesa_local )
						{
?>
							<h3 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_nombre"><?php echo $_MESA->mesa_local; ?></h3>
<?php
						}
						else
						{
?>
							<h3 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_nombre">SIN LOCAL</h3>
<?php
						}
						if( $_MESA->mesa_numero )
						{
?>
							<h4 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_numero"><?php echo $_MESA->mesa_numero; ?></h4>
<?php
						}
						else
						{
?>
							<h4 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_numero">-&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;-</h4>
<?php
						}
?>
							<h5 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_ciudad"><i class="fas fa-globe-americas"></i> <?php echo $_MESA->mesa_comuna; ?></h5>
							<h6 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_cambio">
								<time class="timeago line-1" data="<?php echo $_MESA->mesa_id; ?>" datetime="<?php echo strtotime($_MESA->mesa_cambio); ?>"></time>
							</h6>
						</header>
					</article>
<?php
						$_ID++;
					}
?>
					</section>
				</section>
				<section class="swich-r">
					<section class="swich-r-cnt cols x2" id="mesas-swich">
						<div class="swich-r-box box-shadow" id="swich-mesa-1">
							<div class="swich-r-box-opciones" onclick="vaciarEspacio(1);">
								<h2>MESA IZQUIERDA</h2>
								<h3><i class="fas fa-times-circle"></i></h3>
							</div>
							<div class="swich-espacio cols x1 relacionados" id="mesa-1"></div>
						</div>
						<div class="swich-r-box box-shadow" id="swich-mesa-2">
							<div class="swich-r-box-opciones" onclick="vaciarEspacio(2);">
								<h2>MESA DERECHA</h2>
								<h3><i class="fas fa-times-circle"></i></h3>
							</div>
							<div class="swich-espacio cols x1 relacionados" id="mesa-2"></div>
						</div>
						<div class="swich-r-box box-shadow" id="swich-mesa-3" style="display:none;">
							<div class="swich-r-box-opciones" onclick="vaciarEspacio(3);">
								<h2>MESA 3</h2>
								<h3><i class="fas fa-times-circle"></i></h3>
							</div>
							<div class="swich-espacio cols x1 relacionados" id="mesa-3"></div>
						</div>
						<div class="swich-r-box box-shadow" id="swich-mesa-4" style="display:none;">
							<div class="swich-r-box-opciones" onclick="vaciarEspacio(4);">
								<h2>MESA 4</h2>
								<h3><i class="fas fa-times-circle"></i></h3>
							</div>
							<div class="swich-espacio cols x1 relacionados" id="mesa-4"></div>
						</div>

						<div class="swich-r-box swich-nav box-shadow">
							<div class="swich-mesas" id="swich-opcion-modo" style="display:none;">
								<h2>Template</h2>
								<div onclick="swichModo(0);" id="swich-opcion-modo-0" class="bordes-radius box-shadow-light of tipsy-top"
								title="<h2>Modo Tótem</h2><p>Dos Mesas, consolidado a la Izquierda</p>">
									<i class="fas fa-window-restore"></i>
								</div>
								<div onclick="swichModo(1);" id="swich-opcion-modo-1" class="bordes-radius box-shadow-light of tipsy-top"
								title="<h2>Modo Flotante</h2><p>Una Mesa, consolidado a la Derecha</p>">
									<i class="fas fa-window-maximize"></i>
								</div>
							</div>
							<div class="swich-separador" style="display:none;"></div>
							<div class="swich-mesas" id="swich-opcion-mesas">
								<h2>Cantidad de Mesas</h2>
								<div onclick="swichMesas(0);" id="swich-opcion-mesas-0" class="bordes-radius box-shadow-light of tipsy-top" title="<h2>Template Sin Mesas</h2><p>Se ocultaran todas las Mesas</p>"><i class="fas fa-ban"></i></div>
								<div onclick="swichMesas(1);" id="swich-opcion-mesas-1" class="bordes-radius box-shadow-light of tipsy-top" title="<h2>Template 1 Mesa</h2><p>Se mostrara en pantalla 1 Mesa</p>">1</div>
								<div onclick="swichMesas(2);" id="swich-opcion-mesas-2" class="bordes-radius box-shadow-light of tipsy-top" title="<h2>Template 2 Mesas</h2><p>Se mostraran en pantalla 2 Mesas</p>">2</div>
							</div>
							<div class="swich-separador"></div>
							<div class="swich-controles">
								<h2>Visualización en pantalla</h2>
								<div id="cambios-on" class="on bordes-radius" onclick="swichGuardar();">PUBLICAR</div>
								<div id="cambios-of" class="of bordes-radius">PUBLICAR</div>
								<div id="estado-preview-switch" class="preview bordes-radius" onclick="swichPreview();">PREVIEW</div>
							</div>
						</div>

						<div class="swich-r-box swich-nav box-shadow">
							<div class="swich-mesas" id="swich-opcion-mesas">
								<h1>Configuración de consolidados</h1>
								<h2>Selecciona una región para desplegar los resultados</h2>
								<div id="consolidados-render" class="consolidados bordes-radius" onclick="consolidados_asignar();">
									<span id="consolidados-render-tipo" class="tipo">🔴&nbsp;&nbsp;GOBERNADOR</span>
									<hr class="separador"><i class="fas fa-chevron-right"></i></hr>
									<span id="consolidados-render-zona" class="zona">R. METROPOLITANA</span>
									<i id="consolidados-render-icon" class="fa fa-highlighter"></i>
								</div>
							</div>
							<div class="swich-consolidados">
								<div>
									<div class="swich-consolidados-titulo">Posición</div>
									<div class="swich-consolidados-items">
										<div id="consolidados-posicion-l" class="item on tipsy-top" onclick="posicionConsolidados('l');" title="<h2>A la izquierda</h2><p>Será publicado el modulo consolidados</p>"><i class="fas fa-arrow-left"></i></div>
										<div id="consolidados-posicion-r" class="item of tipsy-top" onclick="posicionConsolidados('r');" title="<h2>A la derecha</h2><p>Será publicado el modulo consolidados</p>"><i class="fas fa-arrow-right"></i></div>
									</div>
								</div>
								<div>
									<div class="swich-consolidados-titulo">Estado del modulo en pantalla</div>
									<div class="swich-consolidados-items">
										<div id="consolidados-estado-of" class="item on" onclick="estadoConsolidados('of');"><i class="far fa-eye-slash"></i>&nbsp;&nbsp;&nbsp;OCULTO</div>
										<div id="consolidados-estado-on" class="item of" onclick="estadoConsolidados('on');"><i class="fas fa-eye"></i>&nbsp;&nbsp;&nbsp;VISIBLE</div>
									</div>
									<div class="swich-controles">
										<div id="estado-preview-consolidados" class="preview bordes-radius" style="margin: 0 0 0 15px;" onclick="consolidadosPreview();">PREVIEW</div>
									</div>
								</div>
							</div>
						</div>

					</section>
				</section>
			</section>	
		</section>
	</body>
</html>