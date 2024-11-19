<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

	//	Librerias JS y CSS globales
		include_once "$_COMPONENTES/librerias.js.css.php";

?>

<!--	Libreria Funcionalidad Mesas	-->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.mesas.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.listado.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.listado.css<?php echo $_CONF_VERSION; ?>"/>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.formulario.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Librerias LiveBox -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>livebox.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>livebox.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Librerias Tipsy -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.tipsy.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>jquery.tipsy.css<?php echo $_CONF_VERSION; ?>"/>
		
<!--	Librerias PubNub -->
		<script src="https://cdn.pubnub.com/sdk/javascript/pubnub.8.2.8.js"></script>
        
<!--	Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Pubnub Monitoreo de Mesas
			pubnub = new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>",
				secretKey		:	"<?php echo $_PUBNUB_SECRET_KEY; ?>",
				userId			:	"<?php echo $_PUBNUB_USER_ID; ?>"
            });

		</script>
		
<!--	Funcionalidad PubNub -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.mesas.actualizacion.js<?php echo $_CONF_VERSION; ?>"></script>
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.mesas.visualizador.js<?php echo $_CONF_VERSION; ?>"></script>

		<style type="text/css">

			.header
			{
				width:calc(100% - 60px) !important;
				margin-left: 0px !important;
			}

			.main
			{
				width:calc(100% - 60px);
				margin-left: 30px;
			}

			.header-usuario
			{
				display:none;
			}

		</style>

	</head>
	<body>

<?php

	//	Header
		include_once "$_COMPONENTES/header.php";

?>

		<section class="main">
			
			<section class="main-cnt cols x1 margin-bottom">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<header class="titulo-seccion no-border">
						<div class="icono"><i class="fas fa-poll"></i></div>
						<h2 class="icono-on">Visualizador Mesas</h2>
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
			
			<section class="main-cnt cols x5" id="mesas">
<?php

	//	ID del Listado
		$_ID								=	1;

	//	Tipo de Objeto
		$_OBJETO_TIPO						=	'MES';

	//	Listado de Objetos Disponibles
		while($_MESA						=	pg_fetch_object($QUERY_MESAS))
		{
			$mesa_tipo_titulo			=	obtener_titulo($_MESA->mesa_tipo);
			$mesa_tipo_icono			=	obtener_icono($_MESA->mesa_tipo);
?>
				<article class="mesa mesa-swich bg-blanco box-shadow bordes-radius filtro-mesa <?php echo $_MESA->mesa_tipo; ?>"
				id="<?php echo $_OBJETO_TIPO.$_MESA->mesa_id; ?>"
				mesa="<?php echo $_MESA->mesa_id; ?>"
				created="<?php echo $_MESA->mesa_publicado; ?>"
				date="<?php echo strtotime($_MESA->mesa_cambio); ?>">
					<div class="mesa-nueva">NUEVA</div>
					<div id="mesa-voto-<?php echo $_MESA->mesa_id; ?>" class="cambios bordes-radius"></div>
					<header>
						<h2 class="<?php echo ($_MESA->mesa_destacada == 1) ? 'importante' : ''; ?>">
							<i class="fas <?php echo ($_MESA->mesa_destacada == 1) ? 'fa-star' : 'fa-hashtag'; ?>"></i>
							<?php echo $_MESA->mesa_id; ?> 
						</h2>
						<h1 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_usuario"><i class="fas fa-user"></i> <?php echo $_MESA->usuario_nombre; ?></h1>
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

<?php

	//	Footer
		include_once "$_COMPONENTES/footer.php";

?>

	</body>
</html>